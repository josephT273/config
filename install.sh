#!/usr/bin/env bash
set -e

echo "Starting Hunter Linux bootstrap..."
sleep 1

DOTFILES_REPO="https://github.com/josepht273/config.git"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# ─────────────────────────────────────────────
# ENVIRONMENT DETECTION
# ─────────────────────────────────────────────
is_wsl=false
is_termux=false

if grep -qi "microsoft" /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
  is_wsl=true
  echo "[!] Running inside WSL"
fi

if [ -n "$TERMUX_VERSION" ] || [ -d "/data/data/com.termux" ]; then
  is_termux=true
  echo "[!] Running inside Termux"
fi

# ─────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────
is_installed() {
  command -v "$1" >/dev/null 2>&1
}

pkg_installed() {
  if [ "$is_termux" = true ]; then
    pkg list-installed 2>/dev/null | grep -q "^$1/"
  else
    dpkg -s "$1" >/dev/null 2>&1
  fi
}

install_pkg() {
  if ! pkg_installed "$1"; then
    echo "[+] Installing $1"
    if [ "$is_termux" = true ]; then
      pkg install -y "$1"
    else
      sudo apt install -y "$1"
    fi
  else
    echo "[=] $1 already installed"
  fi
}

# ─────────────────────────────────────────────
# TERMUX BOOTSTRAP
# ─────────────────────────────────────────────
if [ "$is_termux" = true ]; then
  echo "[*] Running Termux setup..."

  # Storage permission
  if [ ! -d "$HOME/storage" ]; then
    echo "[+] Requesting storage access..."
    termux-setup-storage
  fi

  # Update repos
  pkg update -y && pkg upgrade -y

  # Core packages (Termux names differ from apt)
  termux_packages=(
    git curl wget unzip zip tar
    zsh neovim vim
    fzf bat tree ripgrep
    htop
    build-essential cmake
    python python-pip
    nodejs-lts
    rust
    golang
    nasm
    openssh
    tmux
    proot
    proot-distro
    termux-api
    termux-tools
    tsu
  )

  for pkg in "${termux_packages[@]}"; do
    install_pkg "$pkg"
  done

  # Oh My Zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Installing Oh My Zsh (Termux)"
    RUNZSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

  [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  # FZF
  if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
  fi

  # Bun
  is_installed bun || curl -fsSL https://bun.sh/install | bash

  # NVM (optional fallback if nodejs-lts is not enough)
  if [ ! -d "$HOME/.nvm" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi

  # Neovim latest via pkg (Termux ships a recent build)
  # LazyVim setup
  if ! nvim --version 2>/dev/null | grep -q "NVIM v0.10"; then
    mkdir -p ~/.config
    [ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
    [ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.bak
    [ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim ~/.local/state/nvim.bak
    [ -d ~/.cache/nvim ] && mv ~/.cache/nvim ~/.cache/nvim.bak
    echo "[+] Installing LazyVim (Termux)"
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
  fi

  # TMUX plugin manager
  [ ! -d ~/.tmux/plugins/tpm ] && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # Vim-plug
  [ ! -f ~/.vim/autoload/plug.vim ] && \
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # Termux: set zsh as default shell
  # chsh is not available; use termux's method
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "[+] Setting zsh as default shell (Termux)"
    chsh -s zsh 2>/dev/null || \
      { [ ! -f "$PREFIX/etc/passwd" ] || sed -i "s|/bin/sh|$(command -v zsh)|" "$PREFIX/etc/passwd"; }
  fi

  # Dotfiles
  if [ ! -d "$HOME/config" ]; then
    git clone "$DOTFILES_REPO" "$HOME/config"
    cp -r "$HOME/config/." "$HOME/"
  fi

  # Termux.properties defaults (enable extra keys row, bell-character)
  mkdir -p ~/.termux
  if [ ! -f ~/.termux/termux.properties ]; then
    cat > ~/.termux/termux.properties <<'EOF'
# Extra keys row visible in terminal
extra-keys = [['ESC','TAB','CTRL','ALT','-','|','HOME','END'],['F1','F2','F3','F4','F5','F6','UP','DOWN'],['LEFT','RIGHT','BKSP','DEL','PGUP','PGDN','INS','']]

# Allow external apps to run commands
allow-external-apps = true

# Bell character behavior: ignore, vibrate, beep
bell-character = vibrate
EOF
    echo "[+] termux.properties written"
  fi

  # proot-distro: optionally install Ubuntu for full Linux env
  if is_installed proot-distro; then
    if ! proot-distro list | grep -q "ubuntu.*installed"; then
      echo "[?] Install Ubuntu via proot-distro? (y/N)"
      read -r ans
      if [[ "$ans" =~ ^[Yy]$ ]]; then
        proot-distro install ubuntu
        echo "[+] Ubuntu installed. Launch with: proot-distro login ubuntu"
      fi
    fi
  fi

  echo ""
  echo "Termux setup complete!"
  echo "Restart Termux or run: source ~/.zshrc"
  exit 0
fi

# ─────────────────────────────────────────────
# SYSTEM UPDATE  (non-Termux)
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
)

for pkg in "${packages[@]}"; do
  install_pkg "$pkg"
done

# GUI tools only if NOT WSL
if [ "$is_wsl" = false ]; then
  install_pkg alacritty
else
  echo "[=] Skipping Alacritty (WSL)"
fi

# Docker setup
if ! groups "$USER" | grep -q docker; then
  sudo systemctl enable --now docker || true
  sudo usermod -aG docker "$USER"
fi

# ─────────────────────────────────────────────
# OH MY ZSH
# ─────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[+] Installing Oh My Zsh"
  RUNZSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
  wget -q https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
  rm go1.22.4.linux-amd64.tar.gz
fi

# ─────────────────────────────────────────────
# NODE / NVM / BUN / DENO
# ─────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
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
  curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

# ─────────────────────────────────────────────
# WEZTERM (skip on WSL)
# ─────────────────────────────────────────────
if [ "$is_wsl" = false ]; then
  if ! is_installed wezterm; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm.gpg
    echo "deb [signed-by=/usr/share/keyrings/wezterm.gpg] https://apt.fury.io/wez/ * *" \
      | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt update
    sudo apt install -y wezterm
  fi
else
  echo "[=] Skipping WezTerm (WSL)"
fi

# ─────────────────────────────────────────────
# DOTFILES
# ─────────────────────────────────────────────
if [ ! -d "$HOME/config" ]; then
  git clone "$DOTFILES_REPO" "$HOME/config"
  cp -r "$HOME/config/." "$HOME/"
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
  sudo apt remove neovim -y || true
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz
  # required
  mv ~/.config/nvim{,.bak}
  # optional but recommended
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}

  echo "Installing Lazyvim"
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
fi

# ─────────────────────────────────────────────
# SHELL FIX (NO PAM ERROR)
# ─────────────────────────────────────────────
if [ "$is_wsl" = false ]; then
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "[+] Changing default shell to zsh"
    sudo chsh -s "$(command -v zsh)" "$USER"
  fi
else
  echo "[=] Skipping chsh (WSL limitation)"

  # fallback: auto-start zsh
  if ! grep -q "exec zsh" ~/.bashrc; then
    echo 'exec zsh' >> ~/.bashrc
  fi
fi


# ─────────────────────────────────────────────
# CLEANUP
# ─────────────────────────────────────────────
sudo apt autoremove -y
sudo apt autoclean
rm -rf .git install.sh

echo "Installation complete"
echo "Restart your terminal"
