# FrostShell for Bash and Zsh. Source this file; do not execute it.
_frost_status() {
  local branch='' state=''
  if command -v git >/dev/null 2>&1 && [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == 'true' ]]; then
    branch=$(git branch --show-current 2>/dev/null)
    if [[ -z "$branch" ]]; then
      local commit; commit=$(git rev-parse --short HEAD 2>/dev/null)
      [[ -n "$commit" ]] && branch="detached@$commit"
    fi
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then state='modified'; else state='clean'; fi
  fi
  printf '\033[32m%s\033[0m' "$PWD"
  if [[ -n "$branch" ]]; then
    printf '  |  \033[33m%s\033[0m  |  ' "$branch"
    if [[ "$state" == 'modified' ]]; then
      printf '\033[31m%s\033[0m' "$state"
    else
      printf '\033[90m%s\033[0m' "$state"
    fi
  fi
  printf '\n'
}

_frost_greeting() {
  local hour
  hour=$(date +%H)
  if (( 10#$hour < 12 )); then printf 'Good morning'
  elif (( 10#$hour < 18 )); then printf 'Good afternoon'
  else printf 'Good evening'
  fi
}

frost() {
  printf '\n\033[36mFROST\033[0m / \033[33m%s\033[0m\n' "$(_frost_greeting)"
  _frost_status
}

frost-help() {
  printf '\nFrostShell commands\n  frost       Show the greeting and current Git context\n  frost-greet Print a seasonal greeting\n  frost-help  Show this help\n\n'
}

frost-greet() {
  local greetings=(
    'May your builds be merry and your bugs be few.'
    'Wishing you a secure and snow-bright season.'
    'Have a holly, jolly command line.'
    'May your commits be clean and your coffee warm.'
  )
  printf '%s\n' "${greetings[RANDOM % ${#greetings[@]}]}"
}

_frost_prompt() {
  printf '\n\033[36mFROST\033[0m  \033[90m%s\033[0m\n' "$(date +%H:%M)"
  _frost_status
}

if [[ -n "${ZSH_VERSION:-}" ]]; then
  setopt PROMPT_SUBST
  autoload -Uz add-zsh-hook
  add-zsh-hook -d precmd _frost_prompt 2>/dev/null || true
  add-zsh-hook precmd _frost_prompt
  PROMPT='%F{green}>%f '
else
  case "${PROMPT_COMMAND:-}" in
    *";_frost_prompt;"*) ;;
    *"_frost_prompt"*) ;;
    *) PROMPT_COMMAND="_frost_prompt${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
  esac
  PS1='\[\033[32m\]>\[\033[0m\] '
fi

if [[ -z "${FROST_SHELL_WELCOMED:-}" ]]; then
  printf '\n\033[36mFROST\033[0m / \033[33m%s\033[0m\n\n' "$(_frost_greeting)"
  FROST_SHELL_WELCOMED=1
fi
