# Changelog

All notable changes to this dotfiles repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [2025-12-01]

### Fixed
- **restic-backup**: Fixed timer not triggering and incorrect retention policy
  - Removed erroneous `Requires=restic-backup.service` from timer unit (caused failures)
  - Changed schedule from daily at 2 AM to hourly (`OnCalendar=hourly`)
  - Added `--keep-hourly 24` to retention policy to preserve hourly backups
  - Reduced `OnBootSec` from 10min to 2min for faster initial backup after boot
  - Retention policy now: 24 hourly, 30 daily, 12 weekly, 12 monthly, 3 yearly

## [2025-11-30]

### Fixed
- **systemd** package: Fixed restic-backup timer not starting on boot
  - Added `timers.target.wants/restic-backup.timer` symlink to enable auto-start
  - Stow-managed unit files showed as "linked" but not "enabled" without this
  - Timer now properly activates on boot and respects `Persistent=true` for catch-up

## [2025-11-29]

### Added
- **restic** package: Encrypted backup system configuration
  - Implements 3-2-1-1-0 backup strategy with AES-256 encryption to NAS
  - Retention policy: 30 daily, 12 weekly, 12 monthly, 3 yearly backups
  - Configuration files: `env` (environment/settings), `exclude.txt` (exclusion patterns)
  - Comprehensive exclusion patterns for caches, build artifacts, and development files
  - Password file location defined (user must create): `~/.config/restic/password`
  - Repository location: `/mnt/nas-pool/backup/restic-omarchy-new` (post-security-incident)
  - Includes detailed README with setup instructions and recovery procedures
- **bin** package updates: Restic backup and restore scripts
  - `restic-backup`: Automated backup script with logging, verification, and retention policy enforcement
  - `restic-restore`: Interactive restore helper with menu-driven recovery options
  - Logs saved to: `~/.local/share/restic/logs/`
- **systemd** package updates: Automated backup scheduling
  - `restic-backup.service`: Backup service with security hardening and timeouts
  - `restic-backup.timer`: Daily backup at 2:00 AM with randomized delay and boot catch-up
  - CPU/IO priority optimization (Nice=10, IOSchedulingClass=idle)

## [2025-11-04]

### Fixed
- **nvim**: Fixed Mini.Sessions "not configured" error on startup
  - Disabled `mini.sessions` module (conflicts with auto-session)
  - Added `vim.g.minisessions_disable = true` in mini.lua
- **nvim**: Fixed Treesitter loading and Python parser errors
  - Pinned nvim-treesitter to stable v0.9.3 (main branch has breaking API changes)
  - Added `lazy = false` to nvim-treesitter config for early loading
  - Fixes "module 'nvim-treesitter.configs' not found" error
  - Fixes telescope.nvim integration issues
- **nvim**: Fixed Python except* syntax error
  - Added Python to Treesitter ensure_installed list
  - Commented out `except*` reference in nvim-treesitter Python highlights query
  - Parser doesn't yet support Python 3.11+ exception groups syntax
  - **Note**: Manual edit to `~/.local/share/nvim/lazy/nvim-treesitter/queries/python/highlights.scm` (line 344)
  - This change will need to be reapplied if nvim-treesitter is reinstalled

## [2025-11-03]

### Added
- **yazi** package: Yazi file manager configuration now managed via stow
  - Added custom keybind `g n` to navigate to NAS pool at `/mnt/nas-pool`
  - Symlinked from `~/.config/yazi/`

## [2025-10-30]

### Added
- **hypr** package: Full Hyprland window manager configuration now managed via stow
  - Includes: bindings.conf, monitors.conf, input.conf, looknfeel.conf, hypridle.conf, hyprlock.conf, hyprsunset.conf, autostart.conf, envs.conf
  - All hypr configs are now version-controlled and symlinked from `~/.config/hypr/`
- **waybar** package: Waybar status bar configuration now managed via stow
  - Includes: config.jsonc, style.css
  - Symlinked from `~/.config/waybar/`
  - **Multi-monitor workspace indicators**: Added `.visible` CSS class styling to show per-monitor workspace state
  - **Window app icons**: Using built-in `window-rewrite` feature to display app icons for open windows in workspaces
  - **Rose Pine theme integration**: Added accent colors to both light and dark themes for workspace styling
- **xcompose** package: XCompose key sequences configuration
  - Custom compose key mappings managed via stow at `~/.XCompose`
- **bin** package: Custom user scripts
  - `omarchy-menu-custom`: Modified Omarchy menu script with Logout option added to System menu
  - Uses `uwsm stop` for proper UWSM-managed session logout (returns to SDDM login screen)
  - Symlinked to `~/.local/bin/omarchy-menu-custom` and `~/.local/share/omarchy/bin/omarchy-menu-custom`
- Custom keybinding: `Super + Alt + Space` now launches `omarchy-menu-custom` with Logout option
- Custom workspace setup with icon-based indicators:
  - WT (Terminal), WB (Browsing), WM (Mail), WA (AI) - icon workspaces
  - W1-W5 - numbered general workspaces
  - Workspace keybindings: `Super + T/B/M/A` for icon workspaces, `Super + 1-5` for numbered
  - Move window bindings: `Super Shift + [key]`
- **Multi-monitor workspace controls**: `Super + Alt + arrows` to move workspaces between monitors

### Changed
- Updated repository structure to include hypr, waybar, xcompose, and bin packages
- System menu now includes Logout option (via custom menu script)
- Workspace bindings: Unbound default numbered workspaces (1-9), rebound to custom naming scheme
- Toggle floating moved from `Super + T` to `Super Shift + F` (T now used for Terminal workspace)
- Commented out conflicting app launch keybindings for manual reassignment
- **Waybar workspace styling**: Active workspace gets full colored border, visible (non-focused) workspaces get bottom underline
- **Removed active icon override**: Workspaces no longer change icon when active (use border styling instead)

### Removed
- Custom `waybar-hyprland-workspaces` script (replaced by built-in waybar `window-rewrite` feature)

## [2025-10-29]

### Added
- Automatic theme switching between Rose Pine (light, 6 AM) and Rose Pine Dark (dark, 6 PM)
  - Configured via systemd user timers
  - System preference automatically switches between `prefer-light` and `prefer-dark`

### Fixed
- Neovim treesitter module loading issue on Linux (race condition with plugin installation)
  - Wrapped treesitter config in `pcall()` for graceful loading

## [2025-10-29] - Initial Setup

### Added
- **nvim** package: Complete Neovim configuration (LazyVim-based, migrated from macOS)
- **alacritty** package: Alacritty terminal configuration with Shift+Enter binding
- **zsh** package: ZSH shell configuration with oh-my-zsh, zoxide, fzf, atuin, zsh-magic-dashboard
- Repository structure with GNU Stow for dotfiles management
- `install.sh` script for managing stow packages
- `.gitignore` for repository
- `README.md` with repository documentation
- `CLAUDE.md` as central system knowledge base
