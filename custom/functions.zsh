# ==============================================================================
# Essential Developer Helper Functions & Utilities
# Automatically loaded by Oh My Zsh from ~/.oh-my-zsh/custom/
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Navigation & Directory Management
# ------------------------------------------------------------------------------

# Navigate up N directories (e.g., `up 3` goes up 3 levels)
function up() {
  local limit=${1:-1}
  local d=""
  for ((i=1; i<=limit; i++)); do
    d="../$d"
  done
  cd "$d" || return 1
}

# Create directory (including parents) and immediately enter it
function mkcd() {
  if [[ -z "$1" ]]; then
    echo "Usage: mkcd <directory_path>"
    return 1
  fi
  mkdir -p "$1" && cd "$1"
}

# Create a temporary scratch directory in /tmp and immediately cd into it
function cdtemp() {
  local dir
  dir=$(mktemp -d "${TMPDIR:-/tmp}/scratch.XXXXXX")
  cd "$dir" && echo "Entered temporary scratch directory: $dir"
}

# Jump directly to the root of the current Git repository
function groot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    cd "$root"
  else
    echo "Error: Not inside a Git repository."
    return 1
  fi
}

# Clean tree view without needing external `tree` package installed
function tre() {
  local depth="${1:-2}"
  find . -maxdepth "$depth" -not -path '*/.*' 2>/dev/null | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/| - \1/"
}

# ------------------------------------------------------------------------------
# 2. Search & File Inspection
# ------------------------------------------------------------------------------

# Fast find files by case-insensitive name
function ff() {
  if [[ -z "$1" ]]; then
    echo "Usage: ff <filename_pattern>"
    return 1
  fi
  find . -type f -iname "*$1*" 2>/dev/null
}

# Fast find directories by case-insensitive name
function fd() {
  if [[ -z "$1" ]]; then
    echo "Usage: fd <dirname_pattern>"
    return 1
  fi
  find . -type d -iname "*$1*" 2>/dev/null
}

# Fast recursive text search with line numbers (skips binaries and dot directories)
function ftext() {
  if [[ -z "$1" ]]; then
    echo "Usage: ftext <search_term>"
    return 1
  fi
  grep -rnI --exclude-dir=".git" --exclude-dir="node_modules" --exclude-dir=".venv" --color=auto "$1" .
}

# Human-readable disk usage breakdown for files or folders
function sizeof() {
  if [[ -z "$1" ]]; then
    du -sh ./* 2>/dev/null | sort -h
  else
    du -sh "$@" 2>/dev/null
  fi
}

# ------------------------------------------------------------------------------
# 3. Process, Network & Port Helpers
# ------------------------------------------------------------------------------

# Kill whatever process is occupying a specific local port (e.g. `killport 3000`)
function killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port_number>"
    return 1
  fi
  local pids
  pids=$(lsof -tiTCP:"$1" -sTCP:LISTEN 2>/dev/null)
  if [[ -z "$pids" ]]; then
    echo "Port $1 is clean (no active listener)."
    return 0
  fi
  echo "Found process(es) on port $1 (PID: $pids). Terminating..."
  kill -9 $pids 2>/dev/null && echo "Port $1 successfully freed."
}

# Quick local HTTP file server using Python 3
function serve() {
  local port="${1:-8000}"
  echo "Starting HTTP server on http://localhost:$port (Ctrl+C to stop)..."
  python3 -m http.server "$port"
}

# Display both local IP and external WAN IP
function myip() {
  local local_ip
  local_ip=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "Unavailable")
  echo "Local IP:  $local_ip"
  echo "Public IP: $(curl -s --connect-timeout 2 https://ifconfig.me 2>/dev/null || echo "Unavailable")"
}

# ------------------------------------------------------------------------------
# 4. Git Productivity Helpers
# ------------------------------------------------------------------------------

# Safely undo the last commit while keeping all changes staged
function gundo() {
  git reset --soft HEAD~1
  echo "Last commit undone. Changes are preserved in the staging area."
}

# Delete merged local branches cleanly (keeps main/master)
function gclean() {
  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
  echo "Cleaning local branches merged into $default_branch..."
  git branch --merged "$default_branch" | grep -v "^\*" | grep -v "$default_branch" | xargs -n 1 git branch -d 2>/dev/null
}

# ------------------------------------------------------------------------------
# 5. Data & Developer Tools
# ------------------------------------------------------------------------------

# Pretty-print and format JSON from file, string, or pipe
function json() {
  if [[ -p /dev/stdin ]]; then
    python3 -m json.tool
  elif [[ -f "$1" ]]; then
    python3 -m json.tool "$1"
  elif [[ -n "$1" ]]; then
    echo "$1" | python3 -m json.tool
  else
    echo "Usage: json '<json_string>' or json <file.json> or cat file.json | json"
  fi
}

# Quick URL encoder
function urlencode() {
  if [[ -z "$1" ]]; then
    echo "Usage: urlencode <string>"
    return 1
  fi
  python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

# Quick URL decoder
function urldecode() {
  if [[ -z "$1" ]]; then
    echo "Usage: urldecode <encoded_string>"
    return 1
  fi
  python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))" "$1"
}

# Quick in-terminal calculator
function calc() {
  if [[ -z "$1" ]]; then
    echo "Usage: calc '<math_expression>'"
    return 1
  fi
  python3 -c "import math; print($*)"
}

# Quick cheat sheet viewer from cheat.sh
function cheat() {
  if [[ -z "$1" ]]; then
    echo "Usage: cheat <command_name>"
    return 1
  fi
  curl -s --connect-timeout 3 "https://cheat.sh/$1" | head -n 45
}

# Benchmark execution of a command over 5 runs
function bench() {
  if [[ -z "$1" ]]; then
    echo "Usage: bench <command>"
    return 1
  fi
  echo "Benchmarking 5 iterations of: $*"
  for i in {1..5}; do
    time eval "$@" >/dev/null 2>&1
  done
}

# Print $PATH cleanly, one directory per line
function path() {
  echo "$PATH" | tr ':' '\n'
}

# ------------------------------------------------------------------------------
# 6. Command Understanding & Explanations
# ------------------------------------------------------------------------------

# Understand what any command and its flags do via explainshell.com
function explain() {
  if [[ -z "$1" ]]; then
    echo "Usage: explain '<command_with_flags>'"
    echo "Example: explain 'tar -xzvf archive.tar.gz'"
    return 1
  fi
  local encoded
  encoded=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$*")
  echo "Opening explanation for: $*"
  open "https://explainshell.com/explain?cmd=$encoded" 2>/dev/null || echo "Visit: https://explainshell.com/explain?cmd=$encoded"
}

# Understand what an alias, function, or command actually does/expands to
function why() {
  if [[ -z "$1" ]]; then
    echo "Usage: why <alias_or_command_name>"
    echo "Example: why gst"
    return 1
  fi
  type "$1"
}

# ------------------------------------------------------------------------------
# 7. Interactive Developer Cheatsheet & Help
# ------------------------------------------------------------------------------

# Interactive help and reference dashboard for all custom functions & shortcuts
function help() {
  local cyan="\033[1;36m"
  local green="\033[1;32m"
  local yellow="\033[1;33m"
  local purple="\033[1;35m"
  local bold="\033[1m"
  local dim="\033[2m"
  local reset="\033[0m"

  _show_cheatsheet() {
    echo -e "${cyan}================================================================${reset}"
    echo -e "${bold}             ⚡ OH MY ZSH - DEVELOPER TOOLKIT CHEATSHEET ⚡${reset}"
    echo -e "${cyan}================================================================${reset}"
    echo ""
    echo -e "${yellow}[ 🧠 Understand & Learn Commands ]${reset}"
    echo -e "  ${green}tldr <cmd>${reset}            ${dim}Concise, practical real-world command examples${reset}"
    echo -e "  ${green}explain '<cmd>'${reset}       ${dim}Opens explainshell.com to break down flags/syntax${reset}"
    echo -e "  ${green}why <alias|cmd>${reset}       ${dim}Reveals the underlying definition of any command/alias${reset}"
    echo -e "  ${green}cheat <cmd>${reset}           ${dim}Fetch cheat sheet from cheat.sh${reset}"
    echo ""
    echo -e "${yellow}[ ⚡ Modern File Tools (bat & eza) ]${reset}"
    echo -e "  ${green}preview <file> / cat${reset}  ${dim}Syntax-highlighted file viewer with line numbers (bat)${reset}"
    echo -e "  ${green}l / ll${reset}                ${dim}Modern directory listing with icons & git status (eza)${reset}"
    echo -e "  ${green}lt${reset}                    ${dim}Modern directory tree view with icons (eza)${reset}"
    echo ""
    echo -e "${yellow}[ ⚡ Typing Superpowers (FZF & Speed) ]${reset}"
    echo -e "  ${purple}Ctrl + R${reset}              ${dim}Fuzzy search entire command history with live filter${reset}"
    echo -e "  ${purple}Ctrl + T${reset}              ${dim}Fuzzy file finder + LIVE SYNTAX PREVIEW (bat)${reset}"
    echo -e "  ${purple}Alt/Option + C${reset}        ${dim}Fuzzy directory jump + LIVE TREE PREVIEW (eza)${reset}"
    echo -e "  ${purple}** + Tab${reset}              ${dim}FZF fuzzy completion (e.g. cd **<Tab>, kill **<Tab>)${reset}"
    echo -e "  ${purple}Ctrl + Space / Ctrl + F${reset} ${dim}Accept autosuggestion ghost text${reset}"
    echo -e "  ${purple}Option + →${reset}            ${dim}Accept autosuggestion word-by-word${reset}"
    echo ""
    echo -e "${yellow}[ 🔗 Global Pipes (Type Anywhere) ]${reset}"
    echo -e "  ${green}... G <pattern>${reset}        ${dim}| grep -i <pattern>${reset}"
    echo -e "  ${green}... C${reset}                  ${dim}| pbcopy (copies output to macOS clipboard!)${reset}"
    echo -e "  ${green}... H / ... T${reset}          ${dim}| head -n 20  /  | tail -n 20${reset}"
    echo -e "  ${green}... L / ... W${reset}          ${dim}| less        /  | wc -l (count lines)${reset}"
    echo ""
    echo -e "${yellow}[ 📁 Navigation & Directories ]${reset}"
    echo -e "  ${green}up [n]${reset}                ${dim}Go up N directories (e.g. up 2 = cd ../..)${reset}"
    echo -e "  ${green}mkcd <dir>${reset}            ${dim}Create nested directory and cd into it${reset}"
    echo -e "  ${green}cdtemp${reset}                ${dim}Create & jump into a scratch temp directory in /tmp${reset}"
    echo -e "  ${green}groot${reset}                 ${dim}Jump directly to the root of the current Git repo${reset}"
    echo -e "  ${green}d${reset}                     ${dim}Show 10 most recently visited directories${reset}"
    echo -e "  ${green}tre [depth]${reset}           ${dim}Tree-view of files/folders (default depth: 2)${reset}"
    echo ""
    echo -e "${yellow}[ 🌐 Network & Processes ]${reset}"
    echo -e "  ${green}killport <port>${reset}       ${dim}Kill process on port (e.g. killport 3000)${reset}"
    echo -e "  ${green}serve [port]${reset}          ${dim}Start local HTTP server (default: http://localhost:8000)${reset}"
    echo -e "  ${green}ports${reset}                 ${dim}List all active listening TCP ports & process names${reset}"
    echo -e "  ${green}myip${reset}                  ${dim}Display local LAN IP and public WAN IP${reset}"
    echo -e "  ${green}flushdns${reset}              ${dim}Flush macOS DNS cache${reset}"
    echo ""
    echo -e "${yellow}[ 🔍 Search & Files ]${reset}"
    echo -e "  ${green}ff <pattern>${reset}          ${dim}Find files by name recursively (case-insensitive)${reset}"
    echo -e "  ${green}fd <pattern>${reset}          ${dim}Find directories by name recursively${reset}"
    echo -e "  ${green}ftext <query>${reset}         ${dim}Grep text in files with line numbers (skips node_modules)${reset}"
    echo -e "  ${green}sizeof [target]${reset}       ${dim}Human-readable disk space usage sorted by size${reset}"
    echo ""
    echo -e "${yellow}[ 🛠️ Git Workflow ]${reset}"
    echo -e "  ${green}glog${reset}                  ${dim}Pretty interactive color commit graph${reset}"
    echo -e "  ${green}gundo${reset}                 ${dim}Undo last commit, keeping changes staged${reset}"
    echo -e "  ${green}gclean${reset}                ${dim}Delete local branches already merged into main${reset}"
    echo -e "  ${green}nah${reset}                   ${dim}Discard all local changes & untracked files${reset}"
    echo -e "  ${green}gst / gco / ga${reset}        ${dim}Git status / checkout / add${reset}"
    echo ""
    echo -e "${yellow}[ 🧮 Data & Utilities ]${reset}"
    echo -e "  ${green}json <file|str>${reset}       ${dim}Format/prettify JSON string or file${reset}"
    echo -e "  ${green}calc \"<expr>\"${reset}         ${dim}Run quick math calculation (e.g. calc '2**16')${reset}"
    echo -e "  ${green}bench \"<cmd>\"${reset}         ${dim}Benchmark execution time over 5 runs${reset}"
    echo -e "  ${green}path${reset}                  ${dim}Print \$PATH line by line${reset}"
    echo -e "  ${green}urlencode / urldecode${reset} ${dim}Encode or decode URL query strings${reset}"
    echo ""
    echo -e "${yellow}[ ⌨️ Keybindings & Shortcuts ]${reset}"
    echo -e "  ${purple}↑ / ↓${reset}                 ${dim}Search history matching current input prefix${reset}"
    echo -e "  ${purple}Option + ← / →${reset}        ${dim}Jump forward / backward by word${reset}"
    echo -e "  ${purple}Tab${reset}                   ${dim}Interactive arrow-key navigable completion menu${reset}"
    echo -e "  ${purple}Esc Esc${reset}               ${dim}Prepend sudo to current command${reset}"
    echo -e "${cyan}================================================================${reset}"
  }

  if [[ -n "$1" ]]; then
    _show_cheatsheet | grep -i -C 2 --color=always "$1" || {
      echo "No entry found for '$1'."
      echo "Run 'help' without arguments to see the full list."
    }
  else
    _show_cheatsheet
  fi
}

alias zhelp="help"
