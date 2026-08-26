# Dotfiles Inventory and Sync Plan

Inventory date: 2026-07-08

Machines:

- `gomarchy` — laptop, local machine
- `tomarchy-ts` — office PC, reached with `ssh tomarchy-ts`

This repository is intended to be the source of truth for dotfiles using GNU
Stow, but both machines have drifted. Several files are present in the repo and
also exist in `$HOME`, yet are not symlinked back to the repo.

## Current repository packages

Existing managed areas:

- `alacritty`
- `bin`
- `hypr`
- `mako`
- `nvim`
- `opencode`
- `restic`
- `systemd`
- `xcompose`
- `yazi`
- `zsh`

## Stow/symlink state observed

### gomarchy

Linked into repo:

- `~/.XCompose`

Present but not linked into repo:

- `~/.zshrc`
- `~/.config/alacritty/alacritty.toml`
- `~/.config/hypr/bindings.conf`
- `~/.config/nvim/init.lua`
- `~/.config/mako/config`
- `~/.config/yazi/keymap.toml`
- `~/.config/restic/env`

### tomarchy-ts

Linked into repo:

- `~/.zshrc`
- `~/.XCompose`
- `~/.config/mako/config`
- `~/.config/restic/env`

Present but not linked into repo:

- `~/.config/alacritty/alacritty.toml`
- `~/.config/hypr/bindings.conf`
- `~/.config/nvim/init.lua`
- `~/.config/yazi/keymap.toml`

## Dirty repo state observed

### gomarchy

Modified repo files included:

- `alacritty/.config/alacritty/alacritty.toml`
- `bin/.local/bin/claude`
- `hypr/.config/hypr/*.conf`
- `zsh/.zshrc`

Untracked repo files included:

- tool binaries/wrappers under `bin/.local/bin/`
- Hypr backup files under `hypr/.config/hypr/`
- `laptop-setup.sh`

### tomarchy-ts

Modified repo files included:

- `alacritty/.config/alacritty/alacritty.toml`
- `bin/.local/bin/claude`
- `bin/.local/bin/restic-backup`
- `hypr/.config/hypr/*.conf`
- `nvim/.config/nvim/**/*.lua`
- `restic/.config/restic/exclude.txt`
- `zsh/.zshrc`

Untracked repo files included:

- tool binaries/wrappers under `bin/.local/bin/`
- `chromium/`
- Hypr backup files under `hypr/.config/hypr/`
- `laptop-setup.sh`

## Unmanaged configs worth reviewing

Likely useful to bring under management after review:

- `~/.config/atuin`
- `~/.config/btop`
- `~/.config/fastfetch`
- `~/.config/ghostty`
- `~/.config/git`
- `~/.config/kitty`
- `~/.config/lazygit`
- `~/.config/mise`
- `~/.config/starship.toml`
- `~/.config/swayosd`
- `~/.config/tmux`
- `~/.config/walker`
- `~/.config/waybar`

Review carefully before tracking:

- `~/.config/opencode` — track only curated config; exclude `node_modules`,
  backups, state, auth, and generated `.omo` files
- `~/.config/gh` — may include authentication state
- browser/app configs such as Brave, Cursor, Signal, Obsidian
- secrets or credentials in shell, Restic, SSH, password-store, or API-tool config

## Recommended end state

Keep GNU Stow, but split packages by scope:

```text
common/       shared everywhere
gomarchy/     laptop-only overrides
```

Install order:

```bash
stow --no-folding common
stow --no-folding "$(hostname)"
```

Use `--no-folding` so individual files remain visibly symlinked and easier to
audit.

## Cleanup plan

1. Freeze manual edits while reconciling.
2. Run `scripts/audit-dotfiles` on both machines.
3. Remove or ignore generated noise:
   - `*.bak.*`
   - `.zcompdump*`
   - downloaded AppImages
   - generated language-server/tool shims
   - cache, history, and state files
4. Reconcile conflicting edits between machines, starting with:
   - `zsh/.zshrc`
   - `hypr/.config/hypr/*.conf`
   - `alacritty/.config/alacritty/alacritty.toml`
   - `nvim/.config/nvim/**`
   - `restic/.config/restic/exclude.txt`
   - `bin/.local/bin/restic-backup`
5. Move shared files into `common/` and true host-specific files into the host
   package.
6. Replace copied active files with Stow symlinks.
7. Commit and push only curated config, scripts, and documentation.

## Opencode / Oh My OpenAgent

`tomarchy-ts` was synced on 2026-07-08 with the curated local opencode config:

- `opencode.json`
- `oh-my-openagent.json`
- `AGENTS.md`
- `agents/hermes.md`
- `package.json`
- `playwright-mcp.json`
- `tui.json`

The remote old config was backed up under:

```text
~/.config/opencode/backup-before-sync-20260708-101059
```

Remote verification performed:

```bash
~/.local/bin/opencode --version
~/.config/opencode/node_modules/.bin/playwright-mcp --help
```

Both completed successfully. To reinstall dependencies on any machine:

```bash
cd ~/.config/opencode
npm install
```

## Normal sync workflow after cleanup

On the machine where edits are made:

```bash
cd ~/work/projects/dotfiles-arch
scripts/audit-dotfiles
git status
git diff
git commit
git push
```

On the other machine:

```bash
cd ~/work/projects/dotfiles-arch
git pull --rebase
stow --no-folding common
stow --no-folding "$(hostname)"
scripts/audit-dotfiles
```
