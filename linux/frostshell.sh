# FrostShell for Bash and Zsh. Source this file; do not execute it.
frost() {
  printf '\n\033[38;2;46;204;113m       *       .        ❄\033[0m\n'
  printf '\033[38;2;46;204;113m   .      F R O S T S H E L L      *\033[0m\n'
  printf '\033[38;2;244;196;48m        ✦  season\047s greetings  ✦\033[0m\n\n'
}
frost-help() {
  printf '\nFrostShell commands\n  frost       Show the Christmas banner\n  frost-greet Print a seasonal greeting\n  frost-help  Show this help\n\n'
}
frost-greet() {
  local greetings=(
    'May your builds be merry and your bugs be few. 🎄'
    'Wishing you a secure and snow-bright season. ❄'
    'Have a holly, jolly command line. ✨'
    'May your commits be clean and your coffee warm. ☕'
  )
  printf '%s\n' "${greetings[RANDOM % ${#greetings[@]}]}"
}
_frost_prompt() {
  local dir="${PWD##*/}"; [[ -z "$dir" ]] && dir='/'
  local git_part=''
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch; branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
      if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
        git_part="  \033[38;2;244;196;48m ${branch}  ● changes\033[0m"
      else
        git_part="  \033[38;2;244;196;48m ${branch}  ✓ clean\033[0m"
      fi
    fi
  fi
  printf '\n\033[38;2;120;220;232m❄  \033[38;2;46;204;113m%s\033[0m%b\n' "$dir" "$git_part"
  printf '\033[38;2;130;160;145m   %s\033[0m\n' "$(date +%H:%M:%S)"
}
if [[ -n "${ZSH_VERSION:-}" ]]; then
  setopt PROMPT_SUBST
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _frost_prompt
  PROMPT='%F{green}❯%f '
else
  if [[ -n "${PROMPT_COMMAND:-}" ]]; then
    PROMPT_COMMAND="_frost_prompt; ${PROMPT_COMMAND}"
  else
    PROMPT_COMMAND='_frost_prompt'
  fi
  PS1='\[\033[38;2;46;204;113m\]❯ \[\033[0m\]'
fi
frost
