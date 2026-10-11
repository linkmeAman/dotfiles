# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="devpro"

# Hyphen and case-insensitive completion
HYPHEN_INSENSITIVE="true"

# Auto-update behavior (silent updates every 14 days)
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

# Completion waiting dots
COMPLETION_WAITING_DOTS="true"

# Disable untracked files dirty check (speeds up large git repos)
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Command history timestamp format (yyyy-mm-dd)
HIST_STAMPS="yyyy-mm-dd"

# Enabled plugins
plugins=(
  git                     # Git aliases (gst, gco, gp, gl, ga, gcmsg)
  macos                   # Mac utilities (ofd = open in Finder, pfd = print Finder path, trash)
  z                       # Jump quickly to frequent directories (e.g., 'z project')
  sudo                    # Press ESC twice to prepend 'sudo' to current/previous command
  extract                 # Single command 'x <archive>' extracts zip, tar.gz, 7z, bz2, etc.
  colored-man-pages       # Adds colors to man pages
  copypath                # Copies current directory path to clipboard
  copyfile                # Copies file contents to clipboard (e.g., 'copyfile ~/.ssh/id_rsa.pub')
  web-search              # Search from terminal (e.g., 'google <query>' or 'github <query>')
  fzf                     # Interactive fuzzy finder (Ctrl+R history, Ctrl+T file search)
  zsh-autosuggestions     # Fish-like autosuggestions
  zsh-syntax-highlighting # Syntax highlighting (must be last)
)

source $ZSH/oh-my-zsh.sh
