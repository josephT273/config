#!/usr/bin/env bash
set -e

echo "🚀 Starting Hunter Linux bootstrap..."
sleep 2

# ─────────────────────────────────────────────
# VARIABLES
# ─────────────────────────────────────────────
DOTFILES_REPO="https://github.com/josepht273/config.git"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# ─────────────────────────────────────────────
# SYSTEM UPDATE
# ─────────────────────────────────────────────
sudo apt update && sudo apt upgrade -y

# ─────────────────────────────────────────────
# BASE PACKAGES
# ─────────────────────────────────────────────
sudo apt install -y \
  git curl wget unzip zip tar \
  zsh tmux neovim vim \
  fzf bat tree ripgrep \
  nala net-tools htop \
  build-essential cmake \
  python3 python3-pip \
  docker.io docker-compose \
  qemu-kvm virt-manager \
  nasm dosbox \
  fonts-firacode \
  trash-cli

# Enable Docker
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# ─────────────────────────────────────────────
# OH MY ZSH
# ─────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

git clone https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true

git clone https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null || true
~/.fzf/install --all

# ─────────────────────────────────────────────
# GO
# ─────────────────────────────────────────────
wget -q https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
rm go1.22.4.linux-amd64.tar.gz

# ─────────────────────────────────────────────
# NODE / NVM / BUN / DENO
# ─────────────────────────────────────────────
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts

curl -fsSL https://bun.sh/install | bash
curl -fsSL https://deno.land/install.sh | bash

# ─────────────────────────────────────────────
# RUST
# ─────────────────────────────────────────────
curl https://sh.rustup.rs -sSf | sh -s -- -y


# ─────────────────────────────────────────────
# ALACRITTY
# ─────────────────────────────────────────────
sudo apt install -y alacritty
mkdir -p ~/.config/alacritty

# ─────────────────────────────────────────────
# WEZTERM
# ─────────────────────────────────────────────
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm.gpg
echo "deb [signed-by=/usr/share/keyrings/wezterm.gpg] https://apt.fury.io/wez/ * *" \
  | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install -y wezterm

# ─────────────────────────────────────────────
# DOTFILES
# ─────────────────────────────────────────────
git clone "$DOTFILES_REPO" "$HOME/config"

cp -r "$HOME/config/." "$HOME/"
mkdir -p ~/.config/zsh
mkdir -p ~/.config/nvim

# ─────────────────────────────────────────────
# TMUX PLUGINS
# ─────────────────────────────────────────────
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || true

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ─────────────────────────────────────────────
# DEFAULT SHELL
# ─────────────────────────────────────────────

# ─────────────────────────────────────────────
# CLEANUP
# ─────────────────────────────────────────────
sudo apt autoremove -y
sudo apt autoclean

echo "Removing pre installed neovim"
sudo apt remove neovim -y
sleep 3

echo "Install latest version of neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

echo "✅ Installation complete!"
echo "👉 Log out and log back in to apply Zsh & Docker group changes"
