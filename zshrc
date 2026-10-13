# User PATH
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="devpro"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change the frequency the auto-updater is run (in days).
zstyle ':omz:update' frequency 14

# Uncomment the following line to set how old an update must be before it's applied, manually or via the auto-updater (in days).
# zstyle ':omz:update' cooldown 10

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git)
plugins=(
      git                   # Git aliases (gst, gco, gp, gl, ga, gcmsg)
      macos                 # Mac utilities (ofd = open in Finder, pfd = print Finder path, trash)
      z                     # Jump quickly to frequent directories (e.g., 'z project')
      sudo                  # Press ESC twice to prepend 'sudo' to current/previous command
      extract               # Single command 'x <archive>' extracts zip, tar.gz, 7z, bz2, etc.
      colored-man-pages     # Adds colors to man pages
      copypath              # Copies current directory path to clipboard
      copyfile              # Copies file contents to clipboard (e.g., 'copyfile ~/.ssh/id_rsa.pub')
      web-search            # Search from terminal (e.g., 'google <query>' or 'github <query>')
      fzf                   # Interactive fuzzy finder (Ctrl+R history, Ctrl+T file search)
      zsh-autosuggestions   # Fish-like autosuggestions (from Step 1)
      zsh-syntax-highlighting # Syntax highlighting (from Step 1, must be last)
    )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Terminal Editor Environment (Neovim)
export EDITOR='nvim'
export VISUAL='nvim'
alias v='nvim'
alias vim='nvim'
alias code='"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"'

# Developer CLI Tools & Productivity Aliases
alias lg='lazygit'
alias ld='lazydocker'
alias lsql='lazysql'
alias json='jless'
alias disk='dust'
alias ports='lsof -iTCP -sTCP:LISTEN -P -n'
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias tree='eza --tree --icons -L 2'
alias cat='bat --paging=never'

# Yazi Terminal File Manager (cd on quit)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias f='y'

# Zoxide (Smart directory jumping with 'z')
eval "$(/opt/homebrew/bin/zoxide init zsh)"

# ==============================================================================
# FZF Power Integration (Zero-Touchpad Fuzzy Search, Bat Previews & Quick Tools)
# ==============================================================================
if command -v fzf >/dev/null 2>&1; then
  eval "$(/opt/homebrew/bin/fzf --zsh)"
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS="--height 45% --layout=reverse --border --prompt='🔍 ' --pointer='▶' --marker='✓' --color=bg+:#24283b,bg:#1a1b26,spinner:#ff007c,hl:#565f89,fg:#c0caf5,header:#565f89,info:#0db9d7,pointer:#7dcfff,marker:#73daca,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7dcfff"
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :300 {} 2>/dev/null || cat {}' --preview-window=right:55%:wrap"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --icons -L 2 {} 2>/dev/null || ls -la {}' --preview-window=right:50%"

  # Interactive process killer (Tab to multi-select, Enter to kill)
  kp() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --header='[Kill Process: Tab to multi-select, Enter to kill]' | awk '{print $2}')
    if [ -n "$pid" ]; then
      echo "$pid" | xargs kill -${1:-9}
      echo "Killed process(es): $pid"
    fi
  }

  # Interactive git branch switcher
  fco() {
    local branch
    branch=$(git branch --all | grep -v HEAD | sed 's/.* //' | sed 's#remotes/[^/]*/##' | sort -u | fzf --header="[Git Checkout Branch]")
    [ -n "$branch" ] && git checkout "$branch"
  }

  # Interactive search inside files with live preview (fif <query>)
  fif() {
    if [ ! "$#" -gt 0 ]; then echo "Usage: fif <query>"; return 1; fi
    local file
    file=$(rg --line-number --no-heading --color=always "$@" 2>/dev/null | fzf -d ':' --ansi --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null' --preview-window=right:60%:wrap)
    if [ -n "$file" ]; then
      local target_file=$(echo "$file" | cut -d: -f1)
      local target_line=$(echo "$file" | cut -d: -f2)
      ${EDITOR:-vim} "+$target_line" "$target_file"
    fi
  }
fi

# WezTerm Shell Integration (OSC 7 Directory Tracking & OSC 133 Semantic Prompts)
if [[ "$TERM_PROGRAM" == "WezTerm" && -f "/Applications/WezTerm.app/Contents/Resources/wezterm.sh" ]]; then
  source "/Applications/WezTerm.app/Contents/Resources/wezterm.sh"
fi

# Ensure Claude Code connects directly to Anthropic / claude.ai without AI Gateway proxy
unset ANTHROPIC_AUTH_TOKEN
unset ANTHROPIC_BASE_URL


