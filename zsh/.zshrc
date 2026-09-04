# =============================================================================
# ZSH Configuration for Omarchy (Arch Linux)
# Migrated from macOS dotfiles with Linux adaptations
# =============================================================================

# Configuration Paths
NVIMCONF="$HOME/.config/nvim/init.lua"
ZSHCONF="$HOME/.zshrc"
# OBSIDIAN_DIR="$HOME/Documents/Obsidian/Everything all at once"

# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor
export EDITOR="nvim"

# FZF Configuration
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)

    # Use fd if available, otherwise fallback to find
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
    fi
fi

# =============================================================================
# Aliases
# =============================================================================

alias windows="docker start omarchy-windows"

# Quick shortcuts
alias q="exit"
alias c='clear'
alias h='cd ~'

# System
alias htop="btop"
alias top="btop"
alias yay='yay --editmenu --cleanafter'
vpn() {
  sudo systemctl start wg-quick@protonvpn.service || return
  sudo tailscale set --accept-dns=true >/dev/null || print -u2 "tailscale: could not reapply MagicDNS"
  sudo resolvectl flush-caches 2>/dev/null || true
  systemctl --no-pager --plain status wg-quick@protonvpn.service
}

vpnoff() {
  sudo systemctl stop wg-quick@protonvpn.service || return
  sudo tailscale set --accept-dns=true >/dev/null || print -u2 "tailscale: could not reapply MagicDNS"
  sudo resolvectl flush-caches 2>/dev/null || true
}

# File operations
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias wget='wget -c'
alias j="z"
alias ji="zi"

# Development
alias n="nvim"
alias zshrc='nvim "$ZSHCONF"'

# Git
alias lg='lazygit'

# Python
alias activate="source venv/bin/activate"
alias python='python3'

# FZF utilities
alias f='fzf --preview="bat --color=always {}"'
alias o='nvim $(fzf --preview="bat --color=always {}")'

# Other
alias clip="wl-copy"
alias open="xdg-open"

# Worktree manager (wt script)
alias wt="/home/tomge/work/wt-arch"

# Github CLI aliases
if command -v gh &> /dev/null; then
    alias ghil='gh issue list'
    alias ghiv='gh issue view'
    alias ghic='gh issue close'
    alias ghir='gh issue reopen'
    alias ghie='gh issue edit'
    alias ghilo='gh issue list --state open'
    alias ghilc='gh issue list --state closed'
    alias ghilm='gh issue list --assignee @me'
fi

# =============================================================================
# Functions
# =============================================================================

# Create and open file
function new() {
    touch "$@"
    n "$@"
}

# CAn be merged into the above if argument ends with /, e.g. `new dir/`
function newdir() {
    mkdir -p "$@"
    cd "$@"
}

# Tree with sane defaults (requires eza)
export TREE_IGNORE_PATTERNS="*.pyc|*~|venv|__pycache__|*.d|*.o|*.lock|*.rlib|*.rmeta|target|node_modules|.git"
function tree() {
    local level=5

    # Check if first argument is a number
    if [[ $1 =~ ^[0-9]+$ ]]; then
        level=$1
        shift
    fi

    if command -v eza &> /dev/null; then
        eza --tree --level=$level --group-directories-first --ignore-glob="$TREE_IGNORE_PATTERNS" -a "$@"
    else
        command tree -L $level "$@"
    fi
}

# Fuzzy selector helper
function fuzzy() {
    if [[ -z $1 ]]; then
        echo "Usage: fuzzy <command>"
        return 1
    fi

    selection=$("$@" | fzf)
    if [[ -z $selection ]]; then
        echo "No selection made."
        return 1
    fi
    echo "$selection"
}

# Copy current working directory to clipboard (requires wl-clipboard on Wayland)
function cwd() {
    if command -v wl-copy &> /dev/null; then
        pwd | tr -d "\r\n" | wl-copy
        echo "Path copied to clipboard (Wayland)"
    elif command -v xclip &> /dev/null; then
        pwd | tr -d "\r\n" | xclip -selection clipboard
        echo "Path copied to clipboard (X11)"
    else
        echo "Install wl-clipboard (Wayland) or xclip (X11) for clipboard support"
        pwd
    fi
}

# Copy file contents to clipboard
function cpf() {
    if [[ -z $1 ]]; then
        echo "Usage: cpf <file>"
        return 1
    fi
    if [[ ! -f $1 ]]; then
        echo "File not found: $1"
        return 1
    fi
    if command -v wl-copy &> /dev/null; then
        wl-copy < "$1"
        echo "Copied $1 to clipboard"
    elif command -v xclip &> /dev/null; then
        xclip -selection clipboard < "$1"
        echo "Copied $1 to clipboard"
    else
        echo "Install wl-clipboard (Wayland) or xclip (X11) for clipboard support"
        return 1
    fi
}

# Git commit with message
function gc() {
    git commit -m "$1"
}

# Git: add, commit, push
function gall() {
    git status
    git add .
    git commit -m "$1"
    git push
}

# Find and replace in files (Linux version)
function replace() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: replace old_string new_string [--apply]"
        return 1
    fi

    old_string="$1"
    new_string="$2"
    shift 2
    delimiter="|"

    if [[ "$1" == "--apply" ]]; then
        echo "Applying changes..."
        # Note: Linux sed syntax (no '' after -i)
        find . -type f -name "*.py" -exec sed -i "s${delimiter}${old_string}${delimiter}${new_string}${delimiter}g" {} +
        echo "Replacement complete."
    else
        echo "Preview mode. The following occurrences will be replaced:"
        find . -type f -name "*.py" -exec grep --color=always -Hn "$old_string" {} +
        echo -e "\nTo apply the changes, rerun the command with the '--apply' flag."
    fi
}

# Yazi file manager - exit at current directory
if command -v yazi &> /dev/null; then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi

# Github issue creation helpers
if command -v gh &> /dev/null; then
    function ghii() {
        echo "Enter issue title:"
        read -r title
        echo "Enter issue body (press Ctrl+D when done):"
        body=$(cat)
        gh issue create -t "$title" -b "$body"
    }

    function ghib() {
        local title="$1"
        local body="$2"
        gh issue create -t "🐛 $title" -b "$body" -l "bug"
    }

    function ghif() {
        local title="$1"
        local body="$2"
        gh issue create -t "✨ $title" -b "$body" -l "enhancement"
    }
fi

# =============================================================================
# Optional Tools & Plugins
# =============================================================================

# Zoxide (smart cd - replaces fasd from macOS config)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    # Use 'z' for directory jumping
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(git zsh-autosuggestions sudo web-search zsh-magic-dashboard)
source "$ZSH/oh-my-zsh.sh"

# Eza aliases (MUST be after oh-my-zsh, which overwrites l/ll with plain ls)
if command -v eza &> /dev/null; then
    alias l='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first'
    alias ll='eza --color=always --long --all --git --icons=always --group-directories-first'
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize atuin AFTER oh-my-zsh to prevent keybinding conflicts
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

# =============================================================================
# End of Configuration
# =============================================================================

# pnpm
export PNPM_HOME="/home/tomge/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$PATH:/home/tomge/.local/bin:/home/tomge/.cargo/bin"

# Bitwarden Desktop SSH agent
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
eval "$(mise activate zsh)"
export PATH=$HOME/go/bin:$PATH
