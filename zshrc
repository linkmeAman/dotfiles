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

# GitHub CLI (Zero-Mouse PR & Issue Management)
alias prs='gh pr status'
alias prl='gh pr list'
alias prc='gh pr checkout'
alias prv='gh pr view'
alias il='gh issue list'
alias iv='gh issue view'

# Instant Developer Cheatsheets in Terminal (cheat python list, cheat git rebase)
cheat() {
  if [ -z "$*" ]; then
    echo "Usage: cheat <lang|tool> [topic]  (e.g. cheat python dict, cheat docker prune, cheat git rebase)"
    return 1
  fi
  curl -s "https://cht.sh/${*// /+}" | ${PAGER:-less -R}
}
alias cht='cheat'

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

  # Fuzzy Open File in Editor with live bat preview (fo [query])
  fo() {
    local file
    file=$(fd --type f --hidden --follow --exclude .git | fzf --query="$*" \
      --header="[Enter: Open in $EDITOR | Esc: Cancel]" \
      --preview 'bat --style=numbers --color=always --line-range :300 {} 2>/dev/null || cat {}' \
      --preview-window=right:60%:wrap)
    [ -n "$file" ] && ${EDITOR:-nvim} "$file"
  }

  # Fuzzy Change Directory with eza tree preview (fcd [query])
  fcd() {
    local dir
    dir=$(fd --type d --hidden --follow --exclude .git | fzf --query="$*" \
      --header="[Enter: cd into directory | Esc: Cancel]" \
      --preview 'eza --tree --icons -L 2 {} 2>/dev/null || ls -la {}' \
      --preview-window=right:50%)
    [ -n "$dir" ] && builtin cd "$dir"
  }

  # Fuzzy Git Log Graph with delta commit diff preview (fgl)
  fgl() {
    local commit
    commit=$(git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" 2>/dev/null | \
      fzf --ansi --no-sort --reverse --tiebreak=index \
          --header="[Enter: Copy Commit Hash | Ctrl-O: Checkout | Esc: Cancel]" \
          --bind="ctrl-o:execute(git checkout \$(echo {} | grep -o '[a-f0-9]\{7,40\}' | head -1) && echo Checked out commit)" \
          --preview 'git show --color=always $(echo {} | grep -o "[a-f0-9]\{7,40\}" | head -1) | delta --side-by-side' \
          --preview-window=right:60%:wrap)
    if [ -n "$commit" ]; then
      local hash=$(echo "$commit" | grep -o '[a-f0-9]\{7,40\}' | head -1)
      if [ -n "$hash" ]; then
        echo -n "$hash" | pbcopy
        echo "📋 Copied commit hash: $hash"
      fi
    fi
  }

  # Interactive CLI manual search with live color preview (ftldr [query])
  ftldr() {
    local cmd
    cmd=$(tldr --list 2>/dev/null | fzf --query="$*" \
      --header="[Enter: Print tldr | Esc: Cancel]" \
      --preview='tldr --color=always {} 2>/dev/null' \
      --preview-window=right:65%:wrap)
    if [ -n "$cmd" ]; then
      tldr "$cmd"
    fi
  }
  alias tldrf='ftldr'

  # Interactive Git Stash Inspector with Delta preview (fstash)
  fstash() {
    local stash
    stash=$(git stash list --pretty=format:'%gd: %s (%cr)' 2>/dev/null | \
      fzf --ansi --no-sort \
          --header="[Enter: Pop stash | Ctrl-A: Apply (keep) | Ctrl-D: Drop stash | Esc: Cancel]" \
          --bind="ctrl-a:execute(git stash apply \$(echo {} | cut -d: -f1) && echo Applied)+abort" \
          --bind="ctrl-d:execute(git stash drop \$(echo {} | cut -d: -f1) && echo Dropped)+abort" \
          --preview='git stash show -p --color=always $(echo {} | cut -d: -f1) 2>/dev/null | delta --side-by-side' \
          --preview-window=right:65%:wrap)
    if [ -n "$stash" ]; then
      local stash_id=$(echo "$stash" | cut -d: -f1)
      git stash pop "$stash_id"
    fi
  }

  # Interactive Git Diff Browser (fdiff [target_branch_or_commit])
  fdiff() {
    local target="${1:-HEAD}"
    if [ "$target" = "main" ] || [ "$target" = "master" ]; then
      local base=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
      [ -n "$base" ] && target="$base"
    fi
    local file
    file=$(git diff --name-only "$target" 2>/dev/null | \
      fzf --header="[Enter: Open in $EDITOR | Esc: Cancel] Diff against $target" \
          --preview="git diff --color=always $target -- {} | delta --side-by-side" \
          --preview-window=right:65%:wrap)
    [ -n "$file" ] && ${EDITOR:-nvim} "$file"
  }

  # Interactive Git Branch Manager & Switcher (fb / fgb)
  fb() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "❌ Not inside a Git repository."
      return 1
    fi
    local branch
    branch=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) | %(committerdate:relative) | %(subject)' 2>/dev/null | \
      fzf --ansi --no-sort \
          --header="[Enter: Checkout | Ctrl-D: Delete branch | Ctrl-Y: Copy name | Esc: Cancel]" \
          --bind="ctrl-d:execute(git branch -d \$(echo {} | cut -d' ' -f1) && echo Deleted)+abort" \
          --bind="ctrl-y:execute(echo -n \$(echo {} | cut -d' ' -f1) | pbcopy && echo Copied branch name)+abort" \
          --preview='git log -n 15 --color=always --graph --oneline $(echo {} | cut -d" " -f1) 2>/dev/null' \
          --preview-window=right:60%:wrap \
          --prompt="🌿 Git Branch > ")
    if [ -n "$branch" ]; then
      local target_branch=$(echo "$branch" | cut -d' ' -f1)
      git checkout "$target_branch"
    fi
  }
  alias fgb='fb'

  # Git Modified Files Quick-Opener (fmod)
  fmod() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "❌ Not inside a Git repository."
      return 1
    fi
    local selected
    selected=$(git status --short 2>/dev/null | \
      fzf -m \
          --header="[Enter: Open in $EDITOR | Tab: Multi-select | Ctrl-A: Stage | Esc: Cancel]" \
          --bind="ctrl-a:execute(echo {+2} | xargs git add && echo Staged)+abort" \
          --preview='git diff --color=always {2} 2>/dev/null | delta --side-by-side' \
          --preview-window=right:65%:wrap \
          --prompt="📝 Modified Files > ")
    if [ -n "$selected" ]; then
      local files=$(echo "$selected" | awk '{print $2}')
      echo "$files" | xargs ${EDITOR:-nvim}
    fi
  }

  # Universal Project Script & Task Runner (frun [task])
  # Auto-detects package.json scripts, Makefile targets, Cargo, and Docker tasks
  frun() {
    local tasks=()
    # 1. Node.js / package.json
    if [ -f "package.json" ]; then
      local node_scripts
      node_scripts=$(node -e "try { const p = require('./package.json'); Object.keys(p.scripts||{}).forEach(k => console.log('npm run ' + k + '  # ' + (p.scripts[k]||''))); } catch(e){}" 2>/dev/null)
      [ -n "$node_scripts" ] && tasks+=("${(f)node_scripts}")
    fi
    # 2. Makefile targets
    if [ -f "Makefile" ] || [ -f "makefile" ]; then
      local make_targets
      make_targets=$(awk -F':' '/^[a-zA-Z0-9_-]+:/ && !/^\./ {print "make " $1}' [Mm]akefile 2>/dev/null)
      [ -n "$make_targets" ] && tasks+=("${(f)make_targets}")
    fi
    # 3. Cargo / Rust
    if [ -f "Cargo.toml" ]; then
      tasks+=("cargo run" "cargo test" "cargo check" "cargo build --release")
    fi
    # 4. Python
    if [ -f "pyproject.toml" ]; then
      tasks+=("poetry run pytest" "poetry run python main.py" "pytest")
    elif [ -f "pytest.ini" ] || [ -d "tests" ]; then
      tasks+=("pytest")
    fi
    # 5. Docker Compose
    if [ -f "docker-compose.yml" ] || [ -f "compose.yaml" ]; then
      tasks+=("docker compose up" "docker compose down" "docker compose ps" "docker compose logs -f")
    fi

    # Fallback to general repo commands if no config files found
    if [ ${#tasks[@]} -eq 0 ]; then
      tasks+=("git status" "git pull" "git log -n 5 --oneline")
    fi

    local selected
    selected=$(printf "%s\n" "${tasks[@]}" | fzf --query="$*" \
      --header="[Enter: Execute Task | Esc: Cancel]" \
      --prompt="⚡ Run Task > ")

    if [ -n "$selected" ]; then
      local cmd=$(echo "$selected" | sed 's/  #.*//')
      echo "🚀 Executing: $cmd"
      eval "$cmd"
    fi
  }

  # Port & Process Assassin (ports, fport, killport [port])
  ports() {
    echo "📡 Active Listening TCP Ports:"
    lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | awk 'NR>1 {printf "%-10s %-8s %-6s %s\n", $9, $1, $2, $8}' | sort -n -k1.11 | column -t
  }

  fport() {
    local target
    target=$(lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | awk 'NR>1 {print $9, "-->", $1, "(PID: " $2 ")"}' | sort -u | \
      fzf --query="$*" \
          --header="[Enter: Kill Process on Port | Esc: Cancel]" \
          --prompt="🔌 Port / Process > ")
    if [ -n "$target" ]; then
      local pid=$(echo "$target" | grep -o 'PID: [0-9]*' | awk '{print $2}')
      local port=$(echo "$target" | awk '{print $1}')
      if [ -n "$pid" ]; then
        kill -9 "$pid" 2>/dev/null
        echo "✅ Killed process (PID $pid) listening on $port"
      fi
    fi
  }
  alias fkillport='fport'

  killport() {
    if [ -n "$1" ]; then
      local port="$1"
      local pid
      pid=$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null)
      if [ -n "$pid" ]; then
        kill -9 $pid 2>/dev/null
        echo "✅ Killed process(es) on port $port (PID: $pid)"
      else
        echo "ℹ️ No process listening on port $port"
      fi
    else
      fport
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

# ==============================================================================
# Terminal Dev Cockpit & Antigravity Automation
# ==============================================================================

# Fast TUI Shortcuts
alias a="/Users/tr/.local/bin/agy"
alias ap="/Users/tr/.local/bin/agy /plan"
alias ab="/Users/tr/.local/bin/agy /boost"
alias lg="lazygit"
alias y="yazi"
alias top="btop"

# Antigravity Git & Code Review Helpers
alias agy-review='git diff | /Users/tr/.local/bin/agy "Review these changes for edge cases, bugs, and performance"'
alias agy-cm='git diff --staged | /Users/tr/.local/bin/agy "Generate a concise conventional commit message"'

# Pipe last command error directly into Antigravity
agy-last() {
  local last_cmd=$(fc -ln -1)
  echo "Analyzing output of: $last_cmd"
  eval "$last_cmd" 2>&1 | /Users/tr/.local/bin/agy "Explain why this command failed and give the exact fix"
}

# Pipe any file into Antigravity with a custom question
agy-ask() {
  if [ -z "$1" ]; then
    echo "Usage: agy-ask <file> <prompt>"
    return 1
  fi
  local file="$1"
  shift
  cat "$file" | /Users/tr/.local/bin/agy "$*"
}

# Ask Antigravity CLI directly from shell without switching modes
ask() {
  if [ -z "$*" ]; then
    echo "Usage: ask <question or prompt>"
    return 1
  fi
  /Users/tr/.local/bin/agy "$*"
}

# 1-Second Dev Session Launcher (Neovim + Antigravity CLI + Terminal Runner)
dev() {
  local session_name="$(basename "$PWD" | tr '.' '_')"
  tmux has-session -t "$session_name" 2>/dev/null
  if [ $? -ne 0 ]; then
    tmux new-session -d -s "$session_name" -n "dev"
    tmux send-keys -t "$session_name:dev" "nvim" C-m
    tmux split-window -h -p 40 -t "$session_name:dev"
    tmux send-keys -t "$session_name:dev.1" "/Users/tr/.local/bin/agy" C-m
    tmux split-window -v -p 45 -t "$session_name:dev.1"
    tmux select-pane -t "$session_name:dev.0"
  fi
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

# Ctrl+F in shell triggers tmux-sessionizer immediately
bindkey -s '^f' 'tmux-sessionizer\n'
alias p="/Users/tr/.local/bin/tmux-sessionizer"
alias proj="/Users/tr/.local/bin/tmux-sessionizer"

# Interactive Git Add with multi-select (Tab: select, Enter: stage)
fga() {
  local files
  files=$(git status -s | fzf -m --header="[Tab: Multi-select to stage | Enter: Stage | Esc: Cancel]" --preview="git diff --color=always {2} 2>/dev/null" | awk '{print $2}')
  if [ -n "$files" ]; then
    echo "$files" | xargs git add
    echo "✓ Staged files:"
    echo "$files"
  fi
}

# Auto-stage, generate commit with Antigravity, and push in one go
gpush-ai() {
  if [ -z "$(git status -s)" ]; then
    echo "No changes to commit."
    return 0
  fi
  if [ -z "$(git diff --cached --name-only)" ]; then
    echo "Staging all tracked modifications..."
    git add -u
  fi
  echo "🤖 Generating commit message with Antigravity..."
  local msg
  msg=$(git diff --cached | /Users/tr/.local/bin/agy "Write ONLY a single concise git conventional commit title and description")
  echo ""
  echo "Proposed Commit Message:"
  echo "------------------------"
  echo "$msg"
  echo "------------------------"
  read -q "REPLY?Commit and push to origin? (y/n): "
  echo ""
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    git commit -m "$msg"
    local branch
    branch=$(git branch --show-current)
    git push origin "$branch"
    echo "✓ Committed and pushed to $branch."
  else
    echo "Aborted."
  fi
}

# Terminal clipboard viewer & helper
clip() {
  echo "📋 Current macOS Clipboard:"
  echo "---------------------------"
  pbpaste
  echo "---------------------------"
}

# ==============================================================================
# Daily Developer Journal & Markdown Notes (note, fnotes)
# ==============================================================================
note() {
  local notes_dir="$HOME/notes"
  mkdir -p "$notes_dir"
  local target_file

  if [ -z "$1" ]; then
    local today=$(date +%Y-%m-%d)
    target_file="$notes_dir/${today}.md"
    if [ ! -f "$target_file" ]; then
      cat << EOF > "$target_file"
# 📝 Dev Journal: $today

## 🎯 Focus & Priorities
- [ ] 

## 💡 Notes & Implementation Findings


## 🔗 References & Commands

EOF
    fi
  else
    target_file="$notes_dir/$1.md"
    if [ ! -f "$target_file" ]; then
      cat << EOF > "$target_file"
# 📝 Note: $1

Created: $(date '+%Y-%m-%d %H:%M')

## 💡 Content

EOF
    fi
  fi

  echo "📓 Opening note: $target_file"
  ${EDITOR:-nvim} "$target_file"
}

fnotes() {
  local notes_dir="$HOME/notes"
  mkdir -p "$notes_dir"
  local file
  file=$(fd --type f -e md . "$notes_dir" 2>/dev/null | fzf --query="$*" \
    --header="[Enter: Open in $EDITOR | Ctrl-Y: Copy path | Esc: Cancel]" \
    --bind="ctrl-y:execute(echo -n {} | pbcopy)+abort" \
    --preview='bat --style=numbers --color=always {} 2>/dev/null || cat {}' \
    --preview-window=right:60%:wrap)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}
alias fnote='fnotes'

# ==============================================================================
# Terminal Zero-Touchpad Task & Checklist Tracker (todo)
# ==============================================================================
todo() {
  local todo_file="$HOME/notes/tasks.txt"
  mkdir -p "$HOME/notes"
  [ ! -f "$todo_file" ] && touch "$todo_file"

  case "$1" in
    add|a)
      shift
      if [ -z "$*" ]; then
        echo "Usage: todo add <task description>"
        return 1
      fi
      echo "[ ] $*" >> "$todo_file"
      echo "✓ Added: $*"
      ;;
    done|d)
      shift
      if [ -z "$1" ]; then
        echo "Usage: todo done <task_number>"
        return 1
      fi
      local num="$1"
      local total=$(wc -l < "$todo_file" | tr -d ' ')
      if [ "$num" -gt "$total" ] 2>/dev/null || [ "$num" -le 0 ] 2>/dev/null; then
        echo "❌ Invalid task number: $num (total tasks: $total)"
        return 1
      fi
      sed -i '' "${num}s/^\[ \]/[x]/" "$todo_file"
      echo "🎉 Completed task #$num!"
      todo list
      ;;
    clean|clear)
      sed -i '' '/^\[x\]/d' "$todo_file"
      echo "🧹 Cleaned completed tasks."
      todo list
      ;;
    list|l|"")
      echo "📋 Developer Action Checklist ($todo_file):"
      echo "--------------------------------------------------------"
      if [ ! -s "$todo_file" ]; then
        echo "  (No pending tasks! Add one with: todo add \"<task>\")"
      else
        local i=1
        while IFS= read -r line; do
          if [[ "$line" == "[x]"* ]]; then
            echo -e "  \033[32m✓\033[0m [\033[90m$i\033[0m] \033[90m${line#\[x\] }\033[0m"
          else
            echo -e "  \033[33m⏳\033[0m [$i] ${line#\[ \]* }"
          fi
          ((i++))
        done < "$todo_file"
      fi
      echo "--------------------------------------------------------"
      echo " Commands: todo add <task> | todo done <num> | todo clean"
      ;;
    *)
      todo add "$@"
      ;;
  esac
}

# ==============================================================================
# Zero-Touchpad Visual File Differ (vdiff, cdiff)
# ==============================================================================
vdiff() {
  if [ -z "$1" ]; then
    echo "Usage: vdiff <file1> <file2>  (or: vdiff <file> to diff against Git HEAD)"
    return 1
  fi
  if [ -n "$2" ]; then
    if [ ! -f "$1" ] || [ ! -f "$2" ]; then
      echo "❌ Both files must exist: '$1' and '$2'"
      return 1
    fi
    ${EDITOR:-nvim} -d "$1" "$2"
  else
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      ${EDITOR:-nvim} -d "$1" <(git show HEAD:"$1" 2>/dev/null)
    else
      echo "❌ Please provide two files to diff: vdiff <file1> <file2>"
    fi
  fi
}

cdiff() {
  if [ -z "$2" ]; then
    echo "Usage: cdiff <file1> <file2>"
    return 1
  fi
  delta --side-by-side "$1" "$2"
}

# ==============================================================================
# Fuzzy Command History Search & Quick Editor (fh [query])
# ==============================================================================
fh() {
  local cmd
  local history_source
  if [ -s "$HOME/.zsh_history" ]; then
    history_source=$(sed -E 's/^: [0-9]+:[0-9]+;//' "$HOME/.zsh_history" 2>/dev/null | awk '!seen[$0]++')
  else
    history_source=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//' | awk '!seen[$0]++')
  fi
  cmd=$(echo "$history_source" | \
    fzf --tac --query="$*" \
        --header="[Enter: Edit on prompt | Ctrl-Y: Copy to clipboard | Esc: Cancel]" \
        --bind="ctrl-y:execute(echo -n {} | pbcopy && echo Copied)+abort" \
        --prompt="📜 Command History > ")
  if [ -n "$cmd" ]; then
    print -z "$cmd"
  fi
}

# ==============================================================================
# Environment Variable & Secret Inspector (fenv [query])
# ==============================================================================
fenv() {
  local entry
  entry=$(printenv | sort | fzf --query="$*" \
    --header="[Enter: Copy Value | Ctrl-E: Copy 'export VAR=VAL' | Esc: Cancel]" \
    --bind="ctrl-e:execute(echo -n 'export {}' | pbcopy && echo Copied export string)+abort" \
    --preview='echo {}' \
    --preview-window=down:3:wrap \
    --prompt="🔐 Environment Vars > ")
  if [ -n "$entry" ]; then
    local var_name=$(echo "$entry" | cut -d= -f1)
    local var_val=$(echo "$entry" | cut -d= -f2-)
    echo -n "$var_val" | pbcopy
    echo "📋 Copied value of \$$var_name to clipboard!"
  fi
}


# Terminal Keyboard HUD Cheatsheet
keys() {
  cat << 'EOF'
=============================================================================
              TERMINAL COCKPIT KEYBOARD CHEATSHEET (ZERO TOUCHPAD)
=============================================================================
  PROJECT & LAUNCH:
    p / proj        Fuzzy search any project repository & launch 3-pane dev
    dev             Open 3-pane layout in current directory (Nvim | AGY | Terminal)
    note            Open quick terminal scratchpad buffer
    killport <port> Free port instantly (e.g., killport 3000)

  ANTIGRAVITY CLI:
    a               Launch Antigravity CLI (agy)
    ask "<prompt>"  Quick ask Antigravity directly from shell
    agy-review      Feed unstaged git diff into Antigravity for review
    agy-cm          Generate conventional git commit message from staged changes
    agy-last        Send last command error directly to Antigravity to fix

  WEZTERM SHORTCUTS:
    ⌘ ⌥ A           Split pane right (40%) and launch Antigravity CLI
    ⌘ ⇧ A           Open Antigravity CLI in new tab
    ⌘ D / ⌘ ⇧ D     Split horizontally / vertically
    ⌘ ⌥ H/J/K/L     Jump between panes (Vim keys)
    ⌘ ⇧ E           Fuzzy open any URL with keyboard letter hints
    ⌘ ⇧ Space       QuickSelect copy mode (hashes, paths, IPs)

  TMUX FLOATING POPUPS (Press Ctrl+B then key):
    Prefix + a      Instant floating Antigravity CLI popup
    Prefix + g      Instant floating Lazygit popup
    Prefix + y      Instant floating Yazi file manager popup
    Prefix + b      Instant floating Btop system monitor popup
    Prefix + [      Vi copy mode (v = select, y = copy to macOS clipboard)

  NVIM / VIM SHORTCUTS:
    <Space> a a     Launch Antigravity CLI in terminal drawer
    <Space> a r     Review current file with Antigravity
    <Space> e       Toggle NERDTree file tree
    <Space> f       Fuzzy find files (fzf)
    <Space> g       Live grep search (ripgrep)
=============================================================================
EOF
}
alias cheatsheet='keys'

# ==============================================================================
# Copy Output of Last Command to Clipboard (cl [cmd])
# Zero-Touchpad: never highlight terminal text to copy output!
# ==============================================================================
cl() {
  local last_cmd
  if [ -n "$*" ]; then
    last_cmd="$*"
  else
    last_cmd=$(fc -ln -1 | sed 's/^[ ]*//')
  fi
  if [ -z "$last_cmd" ] || [ "$last_cmd" = "cl" ]; then
    echo "ℹ️ No previous command found to copy output from."
    return 1
  fi
  echo "📋 Capturing output of: $last_cmd"
  local output
  output=$(eval "$last_cmd" 2>&1)
  if [ -n "$output" ]; then
    echo -n "$output" | pbcopy
    local count=$(echo "$output" | wc -l | tr -d ' ')
    echo "✓ Copied output ($count lines) to macOS clipboard!"
  else
    echo "ℹ️ Command produced no output."
  fi
}

# ==============================================================================
# Interactive Terminal Cockpit HUD & Command Discovery (hud / <F1>)
# ==============================================================================
hud() {
  local entries=(
    "note [topic]             --> Daily dev journal & markdown notes in Neovim"
    "fnotes                   --> Fuzzy search past notes with syntax preview"
    "todo [add|done|clean]    --> Instant terminal action checklist tracker"
    "cl [cmd]                 --> Copy output of previous command to clipboard"
    "fmod                     --> Fuzzy browse modified Git files & open in Neovim"
    "fb                       --> Interactive Git branch switcher & manager"
    "vdiff <f1> [f2]          --> Side-by-side Neovim visual file differ"
    "cdiff <f1> <f2>          --> Fast side-by-side terminal Delta diff"
    "fh [query]               --> Fuzzy command history search & edit on prompt"
    "fenv [query]             --> Environment variables & secrets inspector"
    "ports                    --> List all active listening TCP ports & PIDs"
    "fport / killport <port>  --> Port & process killer (free port 3000/8000)"
    "frun [task]              --> Universal project task runner (npm/make/cargo)"
    "fstash                   --> Interactive Git stash browser with Delta diff"
    "fdiff [branch]           --> Interactive Git diff browser against branch"
    "ftldr [cmd]              --> Interactive fuzzy tldr manual with color preview"
    "api [method] <url>       --> REST API test runner in jless"
    "?? <question>            --> Instant shell AI command assistant"
    "sandbox [lang]           --> Disposable Git-backed coding playground"
    "fo [query]               --> Fuzzy find file with bat preview & open"
    "fcd [query]              --> Fuzzy directory changer with eza tree preview"
    "fgl                      --> Interactive Git log graph with Delta diff"
    "fpic / fvid              --> Inline terminal image & video previewer"
    "cheat [topic]            --> Instant programming cheat sheet (cht.sh)"
    "dev                      --> 1-second 3-pane dev session launcher"
    "p / proj                 --> Fuzzy project switcher (tmux-sessionizer)"
    "lg                       --> Launch Lazygit TUI dashboard"
    "y                        --> Launch Yazi terminal file manager"
    "top                      --> Launch Btop system monitor"
  )

  local selected
  selected=$(printf "%s\n" "${entries[@]}" | \
    fzf --header="[Enter: Paste command onto prompt | Esc: Cancel]" \
        --prompt="⚡ Terminal Cockpit HUD > ")

  if [ -n "$selected" ]; then
    local cmd=$(echo "$selected" | awk '{print $1}')
    print -z "$cmd"
  fi
}
alias helpme='hud'

# Bind F1 in interactive shell to open HUD
_hud_widget() {
  BUFFER="hud"
  zle accept-line
}
zle -N _hud_widget
bindkey '^[[11~' _hud_widget 2>/dev/null || true
bindkey '^[OP' _hud_widget 2>/dev/null || true

# ==============================================================================
# REST API Explorer & Interactive JSON Viewer (HTTPie + jless)
# ==============================================================================
api() {
  if [ -z "$1" ]; then
    echo "Usage: api [METHOD] <URL> [REQUEST_ITEMS...]"
    echo "Example: api get https://dummyjson.com/products/1"
    echo "         api https://api.github.com/zen"
    echo "         api post https://httpbin.org/post name=John age:=30"
    return 1
  fi
  if [ -t 1 ] && command -v jless >/dev/null 2>&1; then
    http --print=b "$@" | jless
  else
    http "$@"
  fi
}

# ==============================================================================
# Instant Shell AI / Terminal Command Assistant (?? <question>)
# ==============================================================================
function \?\?() {
  if [ -z "$*" ]; then
    echo "Usage: ?? <natural language question or command intent>"
    echo "Example: ?? find files larger than 100MB and sort by size"
    echo "         ?? extract tar.gz"
    echo "         ?? git show commits modifying specific file"
    return 1
  fi
  local query="$*"
  echo "🤖 Querying terminal assistant for: $query"
  # 1. If local Ollama daemon is active, use it for zero-latency local answers
  if pgrep -x "ollama" >/dev/null 2>&1; then
    local model
    model=$(ollama list 2>/dev/null | awk 'NR==2 {print $1}')
    if [ -n "$model" ]; then
      ollama run "$model" "Provide ONLY the exact terminal command(s) with a brief one-line comment for: $query"
      return
    fi
  fi
  # 2. Fast direct cheat sheet query
  local res
  res=$(curl -s --connect-timeout 4 "https://cht.sh/~${query// /+}")
  if [ -n "$res" ] && [[ "$res" != *"404 Not Found"* ]]; then
    echo "$res" | ${PAGER:-cat}
  else
    echo "💡 Searching CLI results via ddgr..."
    ddgr --np -n 4 "$query"
  fi
}

# ==============================================================================
# Disposable Zero-Touchpad Code Sandbox (sandbox [lang])
# ==============================================================================
sandbox() {
  local lang="${1:-python}"
  local ts
  ts=$(date +%Y%m%d_%H%M%S)
  local dir="/tmp/sandbox_${lang}_${ts}"
  mkdir -p "$dir"
  builtin cd "$dir" || return 1
  git init -q

  local main_file="main.py"
  case "$lang" in
    py|python)
      main_file="main.py"
      cat << 'EOF' > "$main_file"
def main():
    print("🚀 Sandbox Python environment ready!")

if __name__ == "__main__":
    main()
EOF
      ;;
    js|javascript|node)
      main_file="index.js"
      cat << 'EOF' > "$main_file"
console.log("🚀 Sandbox JavaScript ready!");
EOF
      ;;
    ts|typescript)
      main_file="index.ts"
      cat << 'EOF' > "$main_file"
console.log("🚀 Sandbox TypeScript ready!");
EOF
      ;;
    sh|bash|zsh)
      main_file="script.sh"
      cat << 'EOF' > "$main_file"
#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Sandbox Shell script ready!"
EOF
      chmod +x "$main_file"
      ;;
    go|golang)
      main_file="main.go"
      cat << 'EOF' > "$main_file"
package main

import "fmt"

func main() {
    fmt.Println("🚀 Sandbox Go ready!")
}
EOF
      ;;
    rs|rust)
      main_file="main.rs"
      cat << 'EOF' > "$main_file"
fn main() {
    println!("🚀 Sandbox Rust ready!");
}
EOF
      ;;
    html|web)
      main_file="index.html"
      cat << 'EOF' > "$main_file"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sandbox</title>
</head>
<body>
  <h1>🚀 Sandbox Web ready!</h1>
</body>
</html>
EOF
      ;;
    *)
      main_file="scratch.txt"
      echo "🚀 Sandbox scratchpad ready!" > "$main_file"
      ;;
  esac

  echo "🧪 Sandbox initialized at: $dir"
  echo "📁 Opening $main_file in ${EDITOR:-nvim}..."
  ${EDITOR:-nvim} "$main_file"
}
alias sb='sandbox'

# ==============================================================================
# Zero-Touchpad Developer Superpowers (Terminal as Sole Base of Operations)
# ==============================================================================

# 1. Zero-Touchpad Command Output Grabber (cl / copylast)
# Captures stdout/stderr of the last executed command directly to macOS clipboard
cl() {
  local last_cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')
  if [ -z "$last_cmd" ] || [[ "$last_cmd" == cl* ]] || [[ "$last_cmd" == copylast* ]]; then
    echo "ℹ️ No previous command to capture."
    return 1
  fi
  echo "📋 Re-running to capture output: $last_cmd"
  local out
  out=$(eval "$last_cmd" 2>&1)
  echo -n "$out" | pbcopy
  local lines=$(echo "$out" | wc -l | tr -d ' ')
  echo "✅ Copied $lines lines of output from \"$last_cmd\" to macOS clipboard!"
}
alias copylast='cl'

# Pipe last command output directly into an Antigravity prompt
clask() {
  local last_cmd=$(fc -ln -1 | sed 's/^[[:space:]]*//')
  if [ -z "$last_cmd" ]; then
    echo "ℹ️ No previous command found."
    return 1
  fi
  local prompt="${*:-Explain this output and provide fixes if there are errors}"
  echo "🤖 Sending output of \"$last_cmd\" to Antigravity..."
  eval "$last_cmd" 2>&1 | /Users/tr/.local/bin/agy "$prompt"
}

# 2. Interactive Git Branch Manager (fgb / fbranch)
# Browse, checkout, create, or delete branches with zero mouse clicks
fgb() {
  local branch
  branch=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)|%(committerdate:relative)|%(authorname)|%(subject)' 2>/dev/null | \
    column -t -s '|' | \
    fzf --prompt="🌿 Branches > " \
        --header="[Enter: Checkout | Ctrl-D: Delete Branch | Esc: Cancel]" \
        --bind="ctrl-d:execute(git branch -D \$(echo {} | awk '{print \$1}') && echo Deleted branch)+reload(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)|%(committerdate:relative)|%(authorname)|%(subject)' | column -t -s '|')" \
        --preview="git log -n 12 --color=always --oneline \$(echo {} | awk '{print \$1}') 2>/dev/null" \
        --preview-window=right:60%:wrap)
  if [ -n "$branch" ]; then
    local target=$(echo "$branch" | awk '{print $1}')
    [ -n "$target" ] && git checkout "$target"
  fi
}
alias fbranch='fgb'

# 3. Interactive Git Modified Files Picker (fmod / fchanged)
# View modified files with Delta diff preview, stage with Ctrl-A, open in Neovim
fmod() {
  local file
  file=$(git status --porcelain 2>/dev/null | awk '{print $2}' | \
    fzf --prompt="📝 Modified Files > " \
        --header="[Enter: Open in $EDITOR | Ctrl-A: Stage | Esc: Cancel]" \
        --bind="ctrl-a:execute(git add {})+reload(git status --porcelain | awk '{print \$2}')" \
        --preview="git diff --color=always {} 2>/dev/null | delta --side-by-side || cat {}" \
        --preview-window=right:65%:wrap)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}
alias fchanged='fmod'

# 4. Fuzzy Environment Variables Inspector & Copier (fenv)
fenv() {
  local var
  var=$(env | sort | fzf --prompt="🔐 Env Vars > " \
    --header="[Enter: Copy Value | Ctrl-N: Copy Variable Name | Esc: Cancel]" \
    --bind="ctrl-n:execute(echo -n \$(echo {} | cut -d= -f1) | pbcopy)+abort" \
    --preview="echo {}" --preview-window=down:3:wrap)
  if [ -n "$var" ]; then
    local val=$(echo "$var" | cut -d= -f2-)
    echo -n "$val" | pbcopy
    echo "📋 Copied value of $(echo "$var" | cut -d= -f1) to clipboard!"
  fi
}

# 5. Fuzzy Shell Aliases & Functions Search (falias)
falias() {
  local item
  item=$(alias | fzf --prompt="⚡ Aliases > " --header="[Enter: Copy Command | Esc: Cancel]" --preview="echo {}" --preview-window=down:3:wrap)
  if [ -n "$item" ]; then
    local cmd=$(echo "$item" | cut -d= -f2- | sed "s/^'//; s/'$//")
    echo -n "$cmd" | pbcopy
    echo "📋 Copied alias command to clipboard: $cmd"
  fi
}

# 6. Clean System PATH Viewer (fpath)
fpath() {
  echo "🛤 Current System PATH Entries:"
  echo "$PATH" | tr ':' '\n' | awk '{
    if (system("test -d \"" $0 "\"") == 0)
      printf "  \033[32m✔\033[0m %-40s\n", $0;
    else
      printf "  \033[31m✘\033[0m %-40s (directory missing)\n", $0;
  }'
}

# 7. Fuzzy Command Help & Flag Search (fhelp <cmd>)
fhelp() {
  if [ -z "$1" ]; then
    echo "Usage: fhelp <command>  (e.g. fhelp git, fhelp cargo, fhelp docker)"
    return 1
  fi
  "$1" --help 2>&1 | fzf --prompt="📖 Help: $1 > " --header="[Enter / Esc: Exit]" --preview-window=hidden
}

# 8. Terminal QR Code Generator (qr <text_or_url>)
# Instant QR code directly in the terminal to transfer links to mobile without mouse
qr() {
  if [ -z "$*" ]; then
    echo "Usage: qr <text or url>  (e.g. qr https://github.com)"
    return 1
  fi
  curl -s "https://qrenco.de/$*"
}

# 9. Quick Local HTTP File Server with port fallback (serve [port])
serve() {
  local port="${1:-8080}"
  echo "🌐 Starting local web server on http://localhost:$port (serving $PWD)"
  python3 -m http.server "$port"
}
