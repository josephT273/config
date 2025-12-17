# Linux Bootstrap Installer

One-command installer to set up my full Linux development and pentesting environment:

- Zsh + Oh-My-Zsh
- Dotfiles (zsh, tmux, vim, alacritty, wezterm)
- Dev tools (Go, Node, Bun, Rust, Zig)
- Pentesting tools (nmap, sqlmap, docker labs)
- Terminal, editor, and shell fully configured

---

## 📦 Installation

### Recommended (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/josepht273/config/main/install.sh | bash
```

or using `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/josepht273/config/main/install.sh | bash
```

---

### Safer method (manual review)

```bash
curl -fsSL https://raw.githubusercontent.com/josepht273/config/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

---

## 🔁 After Installation

- **Log out and log back in** (required for Zsh & Docker group)
- Zsh will be set as the default shell
- All configurations will be loaded automatically

---

## ⚠️ Notes

- Designed for **Ubuntu / Debian-based Linux**
- Safe to re-run (idempotent)
- Requires sudo access
- Internet connection required

---

## ✅ Verification

```bash
zsh --version
tmux -V
nvim --version
go version
docker ps
```

---

Enjoy your setup 🚀
