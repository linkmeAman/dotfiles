# DevPro Aesthetic Zsh Theme
# Connected tree-style modern prompt with:
# - Line 1: ╭─ [Path] [Git Info] [Timestamp] [Execution Timer]
# - Line 2: ╰─ [Status] ❯

zmodload zsh/datetime 2>/dev/null
autoload -Uz add-zsh-hook

_DEVPRO_CMD_START=0
_DEVPRO_ELAPSED=""

function _devpro_preexec() {
  _DEVPRO_CMD_START=$EPOCHREALTIME
}

function _devpro_precmd() {
  local exit_code=$?
  if (( _DEVPRO_CMD_START > 0 )); then
    local -F diff=$(( EPOCHREALTIME - _DEVPRO_CMD_START ))
    if (( diff >= 1.0 )); then
      if (( diff < 60.0 )); then
        _DEVPRO_ELAPSED=$(printf " %%F{214}⏱ %.1fs%%f" $diff)
      else
        local -i mins=$(( diff / 60 ))
        local -i secs=$(( diff % 60 ))
        _DEVPRO_ELAPSED=$(printf " %%F{214}⏱ %dm %ds%%f" $mins $secs)
      fi
    else
      _DEVPRO_ELAPSED=""
    fi
    _DEVPRO_CMD_START=0
  else
    _DEVPRO_ELAPSED=""
  fi
  return $exit_code
}

add-zsh-hook preexec _devpro_preexec
add-zsh-hook precmd _devpro_precmd

# Git status styling
ZSH_THEME_GIT_PROMPT_PREFIX="%F{135}git:(%F{75}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{135})%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{214} ✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{76} ✔%f"

function _devpro_git_info() {
  local info
  if [[ -n "${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}" ]]; then
    info="${_OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]}"
  elif (( ${+functions[_omz_git_prompt_info]} )); then
    info="$(_omz_git_prompt_info)"
  elif (( ${+functions[git_prompt_info]} )); then
    info="$(git_prompt_info)"
  fi
  if [[ -n "$info" ]]; then
    echo -n " ${info}"
  fi
}

setopt prompt_subst

PROMPT='%F{240}╭─%f %F{39}%B%~%b%f$(_devpro_git_info) %F{242}[%D{%Y-%m-%d %H:%M:%S}]%f${_DEVPRO_ELAPSED}
%F{240}╰─%f%(?.%F{76}❯%f.%F{196}✖ %? ❯%f) '

RPROMPT=''
