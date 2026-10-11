# Developer Quality-of-Life Options & Enhancements for Zsh

# ----------------------------------------------------------------------
# 1. Directory Navigation & Stack
# ----------------------------------------------------------------------
# Type a directory name directly to cd into it (e.g. `..` or `folder`)
setopt AUTO_CD

# Keep directory stack so you can jump back with `cd -<tab>` or `popd`
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ----------------------------------------------------------------------
# 2. History Enhancements
# ----------------------------------------------------------------------
# Share history across all open terminal sessions immediately
setopt SHARE_HISTORY

# Security: Commands starting with a space are omitted from history (e.g. ` export API_KEY=...`)
setopt HIST_IGNORE_SPACE

# History deduplication and cleaning
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

# ----------------------------------------------------------------------
# 3. Pattern Matching & Safety
# ----------------------------------------------------------------------
# Allow pasting commands with comments (#) without throwing error
setopt INTERACTIVE_COMMENTS

# Do not error if a wildcard/glob finds no match (prevents `zsh: no matches found`)
setopt NO_NOMATCH

# ----------------------------------------------------------------------
# 4. Interactive History Substring Search (Up / Down Arrow)
# ----------------------------------------------------------------------
# Type any prefix (e.g., `git ` or `docker `) and press Up/Down to search matching history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search    # Up Arrow
bindkey '^[[B' down-line-or-beginning-search  # Down Arrow
bindkey '^P' up-line-or-beginning-search      # Ctrl+P
bindkey '^N' down-line-or-beginning-search    # Ctrl+N

# ----------------------------------------------------------------------
# 5. Word-by-Word Navigation (macOS Alt/Option & Ctrl)
# ----------------------------------------------------------------------
bindkey '^[[1;5C' forward-word    # Ctrl + Right
bindkey '^[[1;5D' backward-word   # Ctrl + Left
bindkey '^[^[[C' forward-word     # Option + Right (macOS Terminal)
bindkey '^[^[[D' backward-word    # Option + Left (macOS Terminal)
bindkey '\e[1;3C' forward-word    # Option + Right (iTerm2)
bindkey '\e[1;3D' backward-word   # Option + Left (iTerm2)

# ----------------------------------------------------------------------
# 6. Interactive Tab Completion Menu
# ----------------------------------------------------------------------
# Allow arrow-key navigation in completion menus
zstyle ':completion:*' menu select
# Group completion results by category
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ----------------------------------------------------------------------
# 7. Typo & Spelling Correction
# ----------------------------------------------------------------------
# If you mistype a command (e.g. `gti`), prompt before failing: `zsh: correct 'gti' to 'git' [nyae]?`
setopt CORRECT

# ----------------------------------------------------------------------
# 8. FZF (Fuzzy Finder) Integration & Ripgrep / Bat / Eza Previews
# ----------------------------------------------------------------------
if (( ${+commands[fzf]} )); then
  if (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  export FZF_DEFAULT_OPTS='--height 45% --layout=reverse --border --prompt="🔍 " --pointer="▶" --marker="✓"'

  # Live file preview with syntax highlighting (bat) when pressing Ctrl+T
  if (( ${+commands[bat]} )); then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :100 {} 2>/dev/null || cat {}' --preview-window=right:60%:wrap"
  fi

  # Live directory tree preview (eza) when pressing Alt+C
  if (( ${+commands[eza]} )); then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --level=2 {} 2>/dev/null || ls {}' --preview-window=right:60%"
  fi
fi

# Modern colorized manual pages using bat
if (( ${+commands[bat]} )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ----------------------------------------------------------------------
# 9. Quick Autosuggestion Keybindings
# ----------------------------------------------------------------------
# Press Ctrl+Space or Ctrl+F to accept full ghost-text autosuggestion
bindkey '^ ' autosuggest-accept
bindkey '^F' autosuggest-accept
