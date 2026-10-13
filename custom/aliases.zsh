# Useful custom Oh My Zsh aliases for developers

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias d="dirs -v | head -10"

# Modern File Listing & Preview (eza & bat)
if (( ${+commands[eza]} )); then
  alias ls="eza --icons --group-directories-first"
  alias l="eza -la --icons --git --group-directories-first"
  alias ll="eza -l --icons --git --group-directories-first"
  alias lt="eza --tree --icons --level=2 --group-directories-first"
else
  alias l="ls -lah"
  alias ll="ls -lh"
fi

if (( ${+commands[bat]} )); then
  alias cat="bat --paging=never"
  alias preview="bat"
fi

# Safe file operations (confirm before overwrite/delete)
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"

# Git workflow enhancements
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias nah="git reset --hard && git clean -df"

# Shell & Configuration management
alias reload="omz reload"
alias zshconfig="${EDITOR:-nvim} ~/.zshrc"
alias wezconfig="${EDITOR:-nvim} ~/.wezterm.lua"
alias vimconfig="${EDITOR:-nvim} ~/.vimrc"
alias wez="wezterm"

# Network & System
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# Global Pipe Shortcuts (type anywhere on command line)
# Example: `history G git H` expands to `history | grep -i git | head -n 20`
alias -g G='| grep -i'
alias -g L='| less'
alias -g H='| head -n 20'
alias -g T='| tail -n 20'
alias -g C='| pbcopy'
alias -g W='| wc -l'
