#!/usr/bin/env bash
set -e

echo "Starting Hunter Linux bootstrap..."
sleep 1

DOTFILES_REPO="https://github.com/josepht273/config.git"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# ─────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────
is_installed() {
  command -v "$1" >/dev/null 2>&1
}

pkg_installed() {
  dpkg -s "$1" >/dev/null 2>&1
}

install_pkg() {
  if ! pkg_installed "$1"; then
    echo "[+] Installing $1"
    sudo apt install -y "$1"
  else
    echo "[=] $1 already installed"
  fi
}

# ─────────────────────────────────────────────
# SYSTEM UPDATE
# ─────────────────────────────────────────────
sudo apt update

# ─────────────────────────────────────────────
# BASE PACKAGES
# ─────────────────────────────────────────────
packages=(
  git curl wget unzip zip tar
  zsh tmux neovim vim
  fzf bat tree ripgrep
  nala net-tools htop
  build-essential cmake
  python3 python3-pip
  docker.io docker-compose
  qemu-kvm virt-manager
  nasm dosbox
  fonts-firacode
  trash-cli
  alacritty
)

for pkg in "${packages[@]}"; do
  install_pkg "$pkg"
done

# Docker setup
if ! groups "$USER" | grep -q docker; then
  sudo systemctl enable --now docker
  sudo usermod -aG docker "$USER"
fi

# ─────────────────────────────────────────────
# OH MY ZSH
# ─────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[+] Installing Oh My Zsh"
  RUNZSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "[=] Oh My Zsh already installed"
fi

# Plugins
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# FZF
if [ ! -d "$HOME/.fzf" ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

# ─────────────────────────────────────────────
# GO
# ─────────────────────────────────────────────
if ! is_installed go; then
  echo "[+] Installing Go"
  wget -q https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
  rm go1.22.4.linux-amd64.tar.gz
else
  echo "[=] Go already installed"
fi

# ─────────────────────────────────────────────
# NODE / NVM / BUN / DENO
# ─────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
  echo "[+] Installing NVM"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

if ! is_installed node; then
  nvm install --lts
fi

is_installed bun || curl -fsSL https://bun.sh/install | bash
is_installed deno || curl -fsSL https://deno.land/install.sh | bash

# ─────────────────────────────────────────────
# RUST
# ─────────────────────────────────────────────
if ! is_installed rustc; then
  echo "[+] Installing Rust"
  curl https://sh.rustup.rs -sSf | sh -s -- -y
else
  echo "[=] Rust already installed"
fi

# ─────────────────────────────────────────────
# WEZTERM
# ─────────────────────────────────────────────
if ! is_installed wezterm; then
  echo "[+] Installing WezTerm"
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm.gpg
  echo "deb [signed-by=/usr/share/keyrings/wezterm.gpg] https://apt.fury.io/wez/ * *" \
    | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt update
  sudo apt install -y wezterm
else
  echo "[=] WezTerm already installed"
fi

# ─────────────────────────────────────────────
# DOTFILES
# ─────────────────────────────────────────────
if [ ! -d "$HOME/config" ]; then
  git clone "$DOTFILES_REPO" "$HOME/config"
  cp -r "$HOME/config/." "$HOME/"
else
  echo "[=] Dotfiles already present"
fi

mkdir -p ~/.config/zsh ~/.config/nvim

# ─────────────────────────────────────────────
# TMUX / VIM
# ─────────────────────────────────────────────
[ ! -d ~/.tmux/plugins/tpm ] && \
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

[ ! -f ~/.vim/autoload/plug.vim ] && \
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ─────────────────────────────────────────────
# NEOVIM (LATEST)
# ─────────────────────────────────────────────
if ! nvim --version | grep -q "NVIM v0.10"; then
  echo "[+] Installing latest Neovim"
  sudo apt remove neovim -y || true
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz
else
  echo "[=] Latest Neovim already installed"
fi

# ─────────────────────────────────────────────
# SHELL
# ─────────────────────────────────────────────
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)"
fi

# ─────────────────────────────────────────────
# CLEANUP
# ─────────────────────────────────────────────
sudo apt autoremove -y
sudo apt autoclean

echo "Installation complete"
echo "Log out and log back in to apply changes"
