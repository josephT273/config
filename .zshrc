# if [ -f /usr/bin/fastfetch ]; then
#	fastfetch
# fi

# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.config/zsh/completions:"* ]]; then export FPATH="$HOME/.config/zsh/completions:$FPATH"; fi
minifetch() {
  local cyan='%F{cyan}'
  local green='%F{green}'
  local yellow='%F{yellow}'
  local reset='%f'

  local hostname=$(hostname)
  local os
  if [[ -f /etc/os-release ]]; then
    os=$(source /etc/os-release && echo "$NAME $VERSION")
  else
    os=$(uname -sr)
  fi
  local kernel=$(uname -r)
  local uptime=$(uptime -p)
  local cpu=$(awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^[ \t]*//')
  local mem_used=$(free -h | awk '/^Mem:/ {print $3}')
  local mem_total=$(free -h | awk '/^Mem:/ {print $2}')
  local disk_used=$(df -h / | awk 'NR==2 {print $3}')
  local disk_total=$(df -h / | awk 'NR==2 {print $2}')

  print -P "${cyan}🖥️  System Info Summary${reset}"
  print -P "${yellow}-----------------------${reset}"
  print -P "${green}Hostname:${reset} $hostname"
  print -P "${green}OS:${reset} $os"
  print -P "${green}Kernel:${reset} $kernel"
  print -P "${green}Uptime:${reset} $uptime"
  print -P "${green}CPU:${reset} $cpu"
  print -P "${green}Memory:${reset} $mem_used / $mem_total"
  print -P "${green}Disk ( / ):${reset} $disk_used / $disk_total"
  print -P "${yellow}-----------------------${reset}"
  print "Have a great day! 🌟"
}

export PATH=$HOME/futter/flutter/bin:/opt/AdGuardHome:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export CXX=/usr/bin/gcc
export CMAKE_CXX_COMPILER=/usr/bin/gcc
# Path to your Oh My Zsh installation.
export ZSH="$ZDOTDIR/ohmyzsh"
export PATH=$PATH:/snap/bin:/usr/lib/snapd:$HOME/.local/share/swiftly/bin
export PATH="$HOME/.local/bin:$PATH"

ZSH_THEME="robbyrussell"

plugins=(git docker fzf zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# fastfetch # hostnamectl

export EDITOR=nvim
export VISUAL=nvim
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.bun/bin:$HOME/.pub-cache/bin:/opt/nvim-linux-x86_64/bin:$HOME/.config/herd-lite/bin:$HOME/fvm/versions/3.32.4/bin:$HOME/.fvm_flutter/bin:$PATH"

export GOROOT=$HOME/go/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

export ANDROID_HOME=$HOME/Android/Sdk/
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH


export JAVA_HOME="/usr/lib/jvm/default-java"
export PATH="$PATH:/opt/zig/:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$JAVA_HOME/bin"
#l PHP
export PHP_INI_SCAN_DIR="$HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# Bun & NVM
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"


. "$NVM_DIR/nvm.sh"
. "$HOME/.dart-cli-completion/zsh-config.zsh"
. /etc/zsh_command_not_found
. "$HOME/.local/bin/env"


yt() {
    mode="$1"
    url="$2"

    case "$mode" in
        v)
            yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" \
            --merge-output-format mp4 \
            --output "%(playlist_index)s-%(title)s.%(ext)s" "$url"
            ;;
        a)
            yt-dlp -f bestaudio \
            --extract-audio --audio-format mp3 \
            --output "%(playlist_index)s-%(title)s.%(ext)s" "$url"
            ;;
        *)
            echo "Usage: yt [v|a] <url>"
            echo "  v = best video (720p+audio)"
            echo "  a = best audio (mp3)"
            ;;
    esac
}


alias kali="docker run -it kalilinux/kali-last-release /bin/bash"
alias vlang="$HOME/v/v"

# ───── Aliases ─────
#alias vim='nvim'
#alias vi='nvim'
alias svi='sudo nvim'
alias cls='clear'
alias sr='source $HOME/.config/zsh/.zshrc'
alias vz='vim $HOME/.config/zsh/.zshrc'
alias rustbook="rustup doc --book"
# Git
alias gs='git status'
alias gc='git commit -m'
alias gco='git checkout'
alias gi='git init'
alias gcm='git commit -m'
alias lm='git checkout main && git pull'
alias gp='git pull && git push'
alias ulc='git reset --soft HEAD~1'
alias gst='git stash'
alias pop='git stash pop'
alias gstapp='git stash apply'
alias gcom='git add . && git commit -m'
alias lazyg='git add . && git commit -m "$1" && git push'
alias gl="git log --graph --all"
# Docker
alias dcb='docker compose build'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias drmc='docker rm -f $(docker ps -aq)'
alias drun='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias juice='docker run --rm -d --network host --name juice-shop bkimminich/juice-shop'
alias webgoat='docker run --rm -d -p 8090:8080 -p 9090:9090 --name webgoat webgoat/webgoat'
alias mutillidae='docker run --rm -d -p 8082:80 --name mutillidae webpwnized/mutillidae:www-2.12.3'

# npm / bun
alias nin='npm init'
alias nrd='npm run dev'
alias nrb='npm run build'
alias ni='npm install'
alias nu='npm uninstall'
alias nr='npm run'
alias nrp='npm run prisma:studio'

alias bx='bunx'
alias b='bun'
alias ba='bun add'
alias bi='bun install'
alias br='bun run'
alias bu='bun update'
alias bre='bun remove'
alias brd='bun run dev'
alias brb='bun run build'
alias brp='bun pm'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias web='cd /var/www/html'
alias video='open ~/Hunter'


# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

alias drz='nohup $HOME/drizzle-gateway/start > $HOME/drizzle-gateway/drz.log 2>&1 &'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'


# Tmux
alias t='tmux'
alias ta='tmux a'
alias pythonv="python3 -m venv ${1} && source ./${1}/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"
# System
alias update='sudo nala update && sudo nala full-upgrade -y'
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias ports='netstat -tulanp'
alias ipa='ip a'
alias openports='netstat -nape --inet'

# Search & File
# alias grep='rg'
alias f='find . | grep '
alias h='history | grep '
alias p='ps aux | grep '
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias bat='cat'
alias ghidra="/opt/ghidra_11.4.2_PUBLIC/ghidraRun"
alias sqledit="harlequin"


alias win='qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -cpu host \
  -smp 4 \
  -machine type=q35,accel=kvm \
  -drive file=$HOME/Pentest/Tools/windows.qcow2,format=qcow2 \
  -vga virtio \
  -display default \
  -net nic -net user \
  -usb -device usb-tablet \
  -fsdev local,id=fsdev0,path=$HOME/qemu-share,security_model=mapped \
  -device virtio-9p-pci,fsdev=fsdev0,mount_tag=hostshare'


#alias ls="ls -la"
learn() {
  cd ~/Hunter/Learn/"$1" || echo "❌ Directory '$1' does not exist."
}

project() {
    cd ~/Hunter/Project/"$1" || echo "❌ Directory '$1' does not exist."
}


extract() {
	for archive in "$@"; do
		[[ ! -f "$archive" ]] && echo "Not a file: $archive" && continue
		case "$archive" in
			*.tar.bz2) tar xvjf "$archive" ;;
			*.tar.gz) tar xvzf "$archive" ;;
			*.bz2) bunzip2 "$archive" ;;
			*.rar) unrar x "$archive" ;;
			*.gz) gunzip "$archive" ;;
			*.tar) tar xvf "$archive" ;;
			*.tbz2) tar xvjf "$archive" ;;
			*.tgz) tar xvzf "$archive" ;;
			*.zip) unzip "$archive" ;;
			*.Z) uncompress "$archive" ;;
			*.7z) 7z x "$archive" ;;
			*) echo "Unknown archive: $archive" ;;
		esac
	done
}

# Enhanced copy with progress bar
copyf() {
  set -e
  strace -q -ewrite cp -- "$1" "$2" 2>&1 |
    awk -v total_size="$(stat -c '%s' "$1")" '
      {
        count += $NF
        if (count % 10 == 0) {
          percent = int((count / total_size) * 100)
          printf "%3d%% [", percent
          for (i = 0; i <= percent; i++) printf "="
          printf ">"
          for (i = percent; i < 100; i++) printf " "
          printf "]\r"
        }
      }
      END { print "" }
    '
}
alias cpy=copyf  # Use `cpy source target`

# Enhanced move using copy + trash
movef() {
  copyf "$1" "$2" && trash "$1"
}
alias mov=movef  # Use `mov source target`


alias fzf="fzf --height 80% --layout reverse --border"
# Safe delete via trash-cli
# alias rm='trash -v'
alias ng_host="ngrok http $1 --url impala-mature-snipe.ngrok-free.app --host-header=rewrite"
alias pg_host="ssh -p 443 -R0:localhost:$1 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 OvU24ExBSFp@free.pinggy.io"
# FZF: Open file using Neovim with preview like Telescope
# FZF: Open file using Neovim with preview, centered floating box
fzfopen() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always {} || cat {}' \
             --layout=reverse \
             --height=90% \
             --border=rounded \
             --margin=1% \
             --info=inline \
             --prompt="📂 Open file > " \
             --preview-window=down:60%:wrap \
             --color=border:bright-green,fg+:white,bg+:-1 \
             --header-first \
             --bind "ctrl-l:toggle-preview")
  [[ -n "$file" ]] && nvim "$file"
}
alias ffzf=fzfopen

# FZF: Search and install packages via nala or apt (floating, preview on right)
fzfinstall() {
  local selected
  if command -v nala &>/dev/null; then
    selected=$(nala search '' |
      fzf --multi \
          --layout=reverse \
          --prompt="📦 Search Nala > " \
          --preview-window=right:60%:wrap \
          --preview="nala show {1}")
    [[ -n "$selected" ]] && echo "$selected" | awk '{print $1}' | xargs -r sudo nala install -y
  else
    selected=$(apt search '' 2>/dev/null |
      grep -E '^[a-zA-Z0-9\\-]+' |
      fzf --multi \
          --layout=reverse \
          --prompt="📦 Search APT > " \
          --preview-window=right:60%:wrap \
          --preview="apt show {1}")
    [[ -n "$selected" ]] && echo "$selected" | awk '{print $1}' | xargs -r sudo apt install -y
  fi
}
alias aptf=fzfinstall

# Quick fuzzy open with nvim or celluloid
vfv() { vim "$(fzf -m --layout=reverse --border=rounded --height=90%)"; }
cvf() { celluloid "$(fzf -m --layout=reverse --border=rounded --height=90%)"; }

# ── Web App Project Starter Aliases ──

alias nxt='npx create-next-app@latest'                     # Next.js
alias svk='npm create svelte@latest'                       # SvelteKit
alias vt='npm create vite@latest'                          # Vite (choose framework on prompt)
alias rct='npx create-react-app'                           # React
alias xps='npx express-generator'                          # Express
alias lav='laravel new'                                    # Laravel via Laravel installer
# Optional: Laravel installer setup if not installed
alias lavsetup='composer global require laravel/installer'

# ── Custom Starter App with Directory ──
mkproject() {
  mkdir -p "$1" && cd "$1"
}

alias mkp=mkproject  # Usage: mkp my-app → creates and cd into


alias lav='laravel new'                        # Laravel new project
alias lavsetup='composer global require laravel/installer'  # Install Laravel globally

alias flt='flutter create'                     # Flutter app
alias dlib='dart create -t package-simple'     # Dart package
alias dapp='dart create -t console-full'       # Dart app

alias crn='cargo new'                          # New Rust binary crate
alias crl='cargo new --lib'                    # New Rust library crate
alias crr='cargo run'                          # Run project


alias gon='go mod init'                        # Init go module
alias gomk='go run main.go'                    # Run main.go
alias gok='go build && ./$(basename $(pwd))'   # Build & run binary


gomake() {
  mkdir -p "$1" && cd "$1"
  go mod init "$1"
  cat <<EOF > main.go
package main

import "fmt"

func main() {
  fmt.Println("🚀 Go $1 App Ready")
}
EOF
  go run main.go
}
alias gomk=gomake


# Get internal + external IP
ipinfo() {
  echo "📡 Internal IP: $(ip route get 1 | awk '{print $7; exit}')"
  echo "🌍 External IP: $(curl -s https://ifconfig.me)"
}
alias myip='ipinfo'


fun() {
  local choice
  choice=$(printf "Say Hello\nShow Date\nRandom Joke\nOpen Google\nExit" | fzf --prompt="Pick a fun action: " --height=10 --border --layout=reverse)

  case "$choice" in
    "Say Hello")
      echo "Hello, Hunter! Have a great day! 🌟"
      ;;
    "Show Date")
      date
      ;;
    "Random Joke")
      curl -s https://icanhazdadjoke.com/ -H "Accept: text/plain"
      ;;
    "Open Google")
      xdg-open "https://www.google.com" >/dev/null 2>&1 &
      echo "Opening Google..."
      ;;
    "Exit")
      echo "Have fun later!"
      ;;
    *)
      echo "No valid choice selected."
      ;;
  esac
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# eval "$(zellij setup --generate-auto-start zsh)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
. "$HOME/.deno/env"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '$HOME/.opam/opam-init/init.zsh' ]] || source '$HOME/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
export PATH=$PATH:$HOME/.dotnet

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"


# Updae man page read order
export MANSECT=2:3:1:5:7:8

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.x86_64.json
export ZED_ALLOW_EMULATED_GPU=1
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
eval "$(zoxide init zsh)"
