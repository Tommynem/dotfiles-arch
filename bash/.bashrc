# Lightweight Bash configuration for remote and minimal machines.
# It intentionally starts no agents, package managers, plugins, or external
# shell frameworks. Copy this file to ~/.bashrc where a simple Bash setup fits.

# Do not change non-interactive shells (scripts, scp, etc.).
[[ $- == *i* ]] || return

# Keep local executables available without assuming any other toolchain.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Sensible defaults available in Bash itself.
export EDITOR="${EDITOR:-vi}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS="${LESS:--FRX}"
export HISTCONTROL="${HISTCONTROL:-ignoreboth}"
export HISTSIZE="${HISTSIZE:-10000}"
export HISTFILESIZE="${HISTFILESIZE:-20000}"
shopt -s histappend cmdhist checkwinsize
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a; history -n"

# A readable prompt that does not need a theme framework.
if [[ $TERM != dumb ]]; then
  PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi

# Everyday navigation and file-listing helpers.
alias q='exit'
alias c='clear'
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'

if ls --color=auto -d . >/dev/null 2>&1; then
  alias ls='ls --color=auto'
fi
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -A'

if grep --color=auto '' /dev/null >/dev/null 2>&1; then
  alias grep='grep --color=auto'
fi

command -v git >/dev/null 2>&1 && alias g='git'
command -v python3 >/dev/null 2>&1 && alias python='python3'
command -v xdg-open >/dev/null 2>&1 && alias open='xdg-open'

# Create a directory and enter it, without relying on a plugin.
mkcd() {
  if [[ $# -ne 1 ]]; then
    printf 'Usage: mkcd DIRECTORY\n' >&2
    return 2
  fi
  mkdir -p -- "$1" && cd -- "$1"
}

# Use tree when installed; otherwise provide a small, dependency-free fallback.
tree() {
  if command -v tree >/dev/null 2>&1; then
    command tree "$@"
  else
    command find "${1:-.}" -maxdepth 2 -print | command sort
  fi
}
