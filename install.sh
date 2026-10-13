#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Automated Installation Script
# Sets up Oh My Zsh, custom devpro theme, plugins, WezTerm, Vim, and CLI tools
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "================================================================"
echo "    ⚡ Setting up Developer Dotfiles, Shell, WezTerm & Vim ⚡    "
echo "================================================================"

# 1. Install Homebrew (if on macOS and not installed)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
  fi

  echo "==> Installing core CLI tools via Homebrew..."
  brew install fzf ripgrep fd bat eza tlrc yazi neovim lazygit lazydocker lazysql dust jless httpie zoxide chafa viu w3m lynx mpv ddgr

  if ! command -v wezterm >/dev/null 2>&1; then
    echo "==> Installing WezTerm via Homebrew Cask..."
    brew install --cask wezterm || true
  fi

  if ! command -v aerospace >/dev/null 2>&1; then
    echo "==> Installing AeroSpace tiling window manager via Homebrew Cask..."
    brew install --cask nikitabobko/tap/aerospace || true
  fi

  if [[ ! -d "/Applications/Hammerspoon.app" ]]; then
    echo "==> Installing Hammerspoon (for Option+Space Quake toggle)..."
    brew install --cask hammerspoon || true
  fi
fi

# 2. Install Oh My Zsh if not installed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Clone custom Oh My Zsh plugins
echo "==> Installing custom Oh My Zsh plugins..."
mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  echo "--> Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  echo "--> Cloning zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 4. Backup existing configuration files
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
  echo "==> Backing up existing ~/.zshrc to $BACKUP"
  cp "$HOME/.zshrc" "$BACKUP"
fi

if [[ -f "$HOME/.vimrc" && ! -L "$HOME/.vimrc" ]]; then
  VIM_BACKUP="$HOME/.vimrc.backup.$(date +%Y%m%d%H%M%S)"
  echo "==> Backing up existing ~/.vimrc to $VIM_BACKUP"
  cp "$HOME/.vimrc" "$VIM_BACKUP"
fi

if [[ -f "$HOME/.wezterm.lua" && ! -L "$HOME/.wezterm.lua" ]]; then
  WEZ_BACKUP="$HOME/.wezterm.lua.backup.$(date +%Y%m%d%H%M%S)"
  echo "==> Backing up existing ~/.wezterm.lua to $WEZ_BACKUP"
  cp "$HOME/.wezterm.lua" "$WEZ_BACKUP"
fi

# 5. Link Zsh configuration files
echo "==> Linking Zsh dotfiles..."
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/custom/aliases.zsh" "$ZSH_CUSTOM/aliases.zsh"
ln -sf "$DOTFILES_DIR/custom/functions.zsh" "$ZSH_CUSTOM/functions.zsh"
ln -sf "$DOTFILES_DIR/custom/dev_options.zsh" "$ZSH_CUSTOM/dev_options.zsh"
ln -sf "$DOTFILES_DIR/custom/themes/devpro.zsh-theme" "$ZSH_CUSTOM/themes/devpro.zsh-theme"

# 6. Link WezTerm, Terminal Dashboard, and CLI tools
echo "==> Linking WezTerm configuration and CLI companions..."
mkdir -p "$HOME/.local/bin"
ln -sf "$DOTFILES_DIR/wezterm.lua" "$HOME/.wezterm.lua"
if [[ -f "$DOTFILES_DIR/bin/wz" ]]; then
  ln -sf "$DOTFILES_DIR/bin/wz" "$HOME/.local/bin/wz"
  chmod +x "$HOME/.local/bin/wz"
fi
if [[ -f "$DOTFILES_DIR/bin/term-dash" ]]; then
  ln -sf "$DOTFILES_DIR/bin/term-dash" "$HOME/.local/bin/term-dash"
  chmod +x "$HOME/.local/bin/term-dash"
fi

# 7. Link AeroSpace Tiling Window Manager & Hammerspoon
echo "==> Linking AeroSpace & Hammerspoon configurations..."
ln -sf "$DOTFILES_DIR/aerospace.toml" "$HOME/.aerospace.toml"
if [[ -f "$DOTFILES_DIR/hammerspoon/init.lua" ]]; then
  mkdir -p "$HOME/.hammerspoon"
  ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"
fi

# 8. Link Tmux configuration
echo "==> Linking Tmux configuration..."
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# 9. Setup & Link Vim configuration
echo "==> Setting up Vim environment..."
mkdir -p "$HOME/.vim/backup" "$HOME/.vim/swap" "$HOME/.vim/undodir"
ln -sf "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
if [[ -d "$DOTFILES_DIR/.vim" ]]; then
  cp -f "$DOTFILES_DIR/.vim/GUIDE.txt" "$HOME/.vim/" 2>/dev/null || true
  cp -f "$DOTFILES_DIR/.vim/README.md" "$HOME/.vim/" 2>/dev/null || true
fi

# Bootstrap Vim plugins via vim-plug non-interactively
if command -v vim >/dev/null 2>&1; then
  echo "==> Synchronizing Vim plugins..."
  vim +PlugInstall +qall 2>/dev/null || true
fi

# 10. Setup Neovim configuration
echo "==> Setting up Neovim configuration..."
mkdir -p "$HOME/.config/nvim"
cat << 'EOF' > "$HOME/.config/nvim/init.vim"
" Inherits and runs master ~/.vimrc with true color support
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
if (has("termguicolors"))
  set termguicolors
endif
source ~/.vimrc
EOF

# 9. Update tldr cache
if command -v tldr >/dev/null 2>&1; then
  echo "==> Initializing tldr cache..."
  tldr --update 2>/dev/null || true
fi

echo ""
echo "================================================================"
echo "  🎉 Installation complete! Reload your shell or run:          "
echo "     source ~/.zshrc                                            "
echo "================================================================"
