#!/usr/bin/env bash
# Explicit maintenance action only. CLI updates never update this fork.
set -euo pipefail
case ${1:-} in
  --help|-h)
    printf 'Usage: %s\nReinstall the approved pinned OmO fork and apply its documented local patches.\n' "$0"
    exit 0
    ;;
  '') ;;
  *) printf 'Unknown argument: %s\n' "$1" >&2; exit 2 ;;
esac
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
runtime="$HOME/.local/share/opencode/packages"
mkdir -p "$runtime"
cp "$source_dir/package.json" "$source_dir/package-lock.json" "$runtime/"
# The fork is public. Fetch the lockfile's GitHub SSH URL over HTTPS without
# consulting unlocked SSH keys or changing the user's Git configuration.
GIT_MASTER=1 GIT_CONFIG_COUNT=1 \
  GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf \
  GIT_CONFIG_VALUE_0=ssh://git@github.com/ \
  npm ci --prefix "$runtime" --no-audit --no-fund
package="$runtime/node_modules/oh-my-opencode"
printf '%s  %s\n' e724903fade5b5222e0c2a42cce531dff91c838d4ced3f4b6192639f59adfbdf "$package/dist/index.js" | sha256sum --check --status
patch --batch --forward --no-backup-if-mismatch --directory="$package" -p1 <"$source_dir/reasoning-frontmatter.patch"
patch --batch --forward --no-backup-if-mismatch --directory="$package" -p1 <"$source_dir/preserve-user-agents.patch"
node --check "$package/dist/index.js"
printf 'Installed pinned fork v5.1.38-fork.1 at SHA 68d88c68fac9f519aeb988b4878c9dbaa2aa7ea9 with both local patches.\nRestart the OpenCode shared service to load it.\n'
