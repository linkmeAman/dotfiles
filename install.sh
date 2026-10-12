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
  brew install fzf ripgrep bat eza tlrc

  if ! command -v wezterm >/dev/null 2>&1; then
    echo "==> Installing WezTerm via Homebrew Cask..."
    brew install --cask wezterm || true
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

# 6. Link WezTerm configuration
echo "==> Linking WezTerm configuration..."
ln -sf "$DOTFILES_DIR/wezterm.lua" "$HOME/.wezterm.lua"

# 7. Setup & Link Vim configuration
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

# 8. Update tldr cache
if command -v tldr >/dev/null 2>&1; then
  echo "==> Initializing tldr cache..."
  tldr --update 2>/dev/null || true
fi

echo ""
echo "================================================================"
echo "  🎉 Installation complete! Reload your shell or run:          "
echo "     source ~/.zshrc                                            "
echo "================================================================"
