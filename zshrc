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

  # Fuzzy Find & Preview Images (fpic [dir|file|query])
  fpic() {
    # If passed an existing file directly, immediately view it
    if [ -n "$1" ] && [ -f "$1" ]; then
      pic "$1"
      return
    fi

    local search_dirs=()
    local initial_query=""

    # Check if argument is a directory or a search query
    if [ -n "$1" ]; then
      if [ -d "$1" ]; then
        search_dirs=("$@")
      else
        initial_query="$*"
        local has_local
        has_local=$(fd -u --type f -e png -e jpg -e jpeg -e gif -e webp -e svg -e bmp -E ".git" -E "node_modules" --max-results 1 . 2>/dev/null)
        if [ -n "$has_local" ]; then
          search_dirs=(".")
        else
          search_dirs=("$HOME/Documents/ScreenShots" "$HOME/Pictures" "$HOME/Downloads" "$HOME/Desktop" "$HOME/Documents" ".")
        fi
      fi
    else
      local has_local
      has_local=$(fd -u --type f -e png -e jpg -e jpeg -e gif -e webp -e svg -e bmp -E ".git" -E "node_modules" --max-results 1 . 2>/dev/null)
      if [ -n "$has_local" ]; then
        search_dirs=(".")
      else
        search_dirs=("$HOME/Documents/ScreenShots" "$HOME/Pictures" "$HOME/Downloads" "$HOME/Desktop" "$HOME/Documents" ".")
      fi
    fi

    local fzf_args=(
      --prompt="🖼 Select Image: "
      --header="Enter: View & Copy Path | Ctrl-O: QuickLook | Esc: Cancel"
      --bind="ctrl-o:execute(qlmanage -p {} >/dev/null 2>&1 &)"
      --preview='chafa --format=symbols -s 50x25 "{}" 2>/dev/null || viu -w 50 "{}" 2>/dev/null'
      --preview-window=right:60%
    )
    if [ -n "$initial_query" ]; then
      fzf_args+=(-q "$initial_query")
    fi

    local file
    file=$(fd -u --type f -e png -e jpg -e jpeg -e gif -e webp -e svg -e bmp \
              -E "Library/Caches" -E ".git" -E "node_modules" -E ".cache" \
              . "${search_dirs[@]}" 2>/dev/null | \
      fzf "${fzf_args[@]}")

    if [ -n "$file" ]; then
      pic "$file"
    fi
  }

  # Fuzzy Find & Inspect Videos (fvid [dir|file|query])
  fvid() {
    # If passed an existing video file directly, immediately play it
    if [ -n "$1" ] && [ -f "$1" ]; then
      vid "$1"
      return
    fi

    local search_dirs=()
    local initial_query=""

    if [ -n "$1" ]; then
      if [ -d "$1" ]; then
        search_dirs=("$@")
      else
        initial_query="$*"
        local has_local
        has_local=$(fd -u --type f -e mp4 -e mov -e mkv -e avi -e webm -e flv -E ".git" -E "node_modules" --max-results 1 . 2>/dev/null)
        if [ -n "$has_local" ]; then
          search_dirs=(".")
        else
          search_dirs=("$HOME/Movies" "$HOME/Downloads" "$HOME/Desktop" "$HOME/Documents" "$HOME" ".")
        fi
      fi
    else
      local has_local
      has_local=$(fd -u --type f -e mp4 -e mov -e mkv -e avi -e webm -e flv -E ".git" -E "node_modules" --max-results 1 . 2>/dev/null)
      if [ -n "$has_local" ]; then
        search_dirs=(".")
      else
        search_dirs=("$HOME/Movies" "$HOME/Downloads" "$HOME/Desktop" "$HOME/Documents" "$HOME" ".")
      fi
    fi

    local fzf_args=(
      --prompt="🎬 Select Video: "
      --header="Enter: Play & Copy Path | Ctrl-O: QuickLook | Esc: Cancel"
      --bind="ctrl-o:execute(qlmanage -p {} >/dev/null 2>&1 &)"
      --preview='ffprobe -v error -show_entries stream=width,height,codec_name:format=duration,size -of default=noprint_wrappers=1 "{}" 2>/dev/null'
      --preview-window=right:50%
    )
    if [ -n "$initial_query" ]; then
      fzf_args+=(-q "$initial_query")
    fi

    local file
    file=$(fd -u --type f -e mp4 -e mov -e mkv -e avi -e webm -e flv \
              -E "Library/Caches" -E ".git" -E "node_modules" -E ".cache" \
              . "${search_dirs[@]}" 2>/dev/null | \
      fzf "${fzf_args[@]}")

    if [ -n "$file" ]; then
      vid "$file"
    fi
  }
fi

# ==============================================================================
# Media Viewers (Photo & Video), Path Copier & CLI Web Browser
# ==============================================================================

# Instant macOS QuickLook preview
ql() {
  if [ -z "$1" ]; then
    echo "Usage: ql <file>"
    return 1
  fi
  qlmanage -p "$1" >/dev/null 2>&1 &
}

# Photo Viewer & Path Copier (pic <image_file>) - High-DPI Native Graphics
pic() {
  if [ -z "$1" ]; then
    echo "Usage: pic <path_to_image>"
    return 1
  fi
  local target="$1"
  if [ ! -f "$target" ]; then
    echo "❌ File not found: $target"
    return 1
  fi
  local abs_path
  abs_path="$(cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target")"
  echo -n "$abs_path" | pbcopy
  echo "📋 Copied path to clipboard: $abs_path"

  # High-resolution pixel graphics using Kitty protocol (WezTerm native)
  if [ "${TERM_PROGRAM:-}" = "WezTerm" ] || [ -n "${WEZTERM_PANE:-}" ]; then
    chafa -f kitty --scale max "$target" 2>/dev/null || chafa -f iterm --scale max "$target" 2>/dev/null || chafa "$target"
  elif command -v chafa >/dev/null 2>&1; then
    chafa -f kitty --scale max "$target" 2>/dev/null || chafa -f iterm --scale max "$target" 2>/dev/null || chafa "$target"
  elif command -v viu >/dev/null 2>&1; then
    viu "$target"
  fi
}

# Video Player & Path Copier (vid <video_file>) - High-Fidelity Retina Playback
vid() {
  if [ -z "$1" ]; then
    echo "Usage: vid <path_to_video>"
    return 1
  fi
  local target="$1"
  if [ ! -f "$target" ]; then
    echo "❌ File not found: $target"
    return 1
  fi
  local abs_path
  abs_path="$(cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target")"
  echo -n "$abs_path" | pbcopy
  echo "📋 Copied path to clipboard: $abs_path"
  if command -v ffprobe >/dev/null 2>&1; then
    echo "🎞 Video Metadata:"
    ffprobe -v error -show_entries format=duration,size,bit_rate:stream=width,height,codec_name -of default=noprint_wrappers=1 "$target" 2>/dev/null | head -n 6
  fi
  if command -v mpv >/dev/null 2>&1; then
    mpv \
      --profile=high-quality \
      --vo=gpu-next \
      --hwdec=auto-safe \
      --hidpi-window-scale=yes \
      --scale=ewa_lanczossharp \
      --cscale=ewa_lanczossharp \
      --autofit=75% \
      --geometry=50%:50% \
      "$target"
  else
    open "$target"
  fi
}

# Smart CLI Web Browser & Query Handler (w3m + ddgr)
export BROWSER='w3m'

web() {
  if [ -z "$*" ]; then
    w3m "https://html.duckduckgo.com"
    return
  fi

  local input="$*"
  # Detect if input is a URL (starts with http/file or is domain.tld / localhost)
  if [[ "$input" =~ ^https?:// ]] || [[ "$input" =~ ^file:// ]] || [[ "$input" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]] || [[ "$input" =~ ^localhost(:[0-9]+)? ]]; then
    if [[ ! "$input" =~ ^[a-zA-Z]+:// ]]; then
      input="https://$input"
    fi
    w3m "$input"
  else
    # Not a URL -> Search query! (e.g. browse "what is llm" or web rust async)
    search "$@"
  fi
}
alias browse='web'

# ==============================================================================
# CLI Web Search Suite (100% Terminal - No Browser Redirection, No GUI)
# ==============================================================================

# Interactive terminal web search (ddgr + w3m, copies links with 'c <num>')
search() {
  if [ -z "$*" ]; then
    echo "Usage: search <query>"
    return 1
  fi
  if command -v ddgr >/dev/null 2>&1; then
    ddgr --url-handler w3m -n 7 "$@"
  else
    w3m "https://html.duckduckgo.com/html/?q=${*// /+}"
  fi
}

# Quick instant print to terminal & exit (no interactive prompt, no lag)
qsearch() {
  if [ -z "$*" ]; then
    echo "Usage: qsearch <query>"
    return 1
  fi
  if command -v ddgr >/dev/null 2>&1; then
    ddgr --np -n 8 "$@"
  else
    w3m -dump "https://html.duckduckgo.com/html/?q=${*// /+}" | head -n 35
  fi
}

# Clear any legacy aliases from earlier shell sessions
unalias google duck ddg bing github stackoverflow wiki 2>/dev/null || true

# CLI search engine aliases (all 100% terminal-native, zero GUI redirection)
alias google='search'
alias duck='search'
alias ddg='search'
alias bing='search'

alias qgoogle='qsearch'
alias qduck='qsearch'

# Site-specific CLI terminal searches
function github {
  if [ -z "$*" ]; then
    echo "Usage: github <query>"
    return 1
  fi
  ddgr --url-handler w3m -w github.com "$@"
}
alias ghs='github'

function so {
  if [ -z "$*" ]; then
    echo "Usage: so <query>"
    return 1
  fi
  ddgr --url-handler w3m -w stackoverflow.com "$@"
}
alias stackoverflow='so'

function wiki {
  if [ -z "$*" ]; then
    echo "Usage: wiki <query>"
    return 1
  fi
  ddgr --url-handler w3m -w wikipedia.org "$@"
}
alias wikipedia='wiki'

# Read any website or article as clean text directly in terminal
readweb() {
  if [ -z "$1" ]; then
    echo "Usage: readweb <url>"
    return 1
  fi
  w3m -dump -cols 100 "$1" | ${PAGER:-less}
}
alias catweb='readweb'

# WezTerm Shell Integration (OSC 7 Directory Tracking & OSC 133 Semantic Prompts)
if [[ "$TERM_PROGRAM" == "WezTerm" && -f "/Applications/WezTerm.app/Contents/Resources/wezterm.sh" ]]; then
  source "/Applications/WezTerm.app/Contents/Resources/wezterm.sh"
fi

# Ensure Claude Code connects directly to Anthropic / claude.ai without AI Gateway proxy
unset ANTHROPIC_AUTH_TOKEN
unset ANTHROPIC_BASE_URL


