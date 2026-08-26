# Dotfiles for Arch Linux (Omarchy)

Personal dotfiles for Omarchy/Arch Linux, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Each subdirectory is a "package" that can be independently installed using stow:

- `nvim/` - Neovim editor configuration (migrated from macOS with Linux-specific adjustments)
- `alacritty/` - Alacritty terminal configuration overrides
- `thunderbird/` - Profile-targeted Thunderbird dual skins, managed with `./thunderbird/manage-skin` (see `thunderbird/README.md`)

## Omarchy 4 (Quattro) cleanup — pending

Do **not** delete these yet. This repository retains them while the Quattro
migration is verified on both machines:

- `mako/` — queued for deletion. Omarchy 4 replaces Mako notifications with
  its Quickshell-based shell.
- `hypr/.config/hypr/autostart.conf`, `bindings.conf`, `hypridle.conf`,
  `hyprland.conf`, `hyprlock.conf`, `input.conf`, `looknfeel.conf`, and
  `monitors.conf` — legacy pre-Quattro configuration, superseded by the Lua
  migration in the same package. Keep until the new Lua configuration is
  confirmed on both machines.

Keep the `hypr/` package itself: its Lua files remain the active Omarchy 4
configuration. `envs.conf`, `hyprsunset.conf`, and `xdph.conf` need a separate
review before any removal. Source: [Omarchy v4.0.0 release notes](https://github.com/basecamp/omarchy/releases/tag/v4.0.0).

## Prerequisites

- Arch Linux (Omarchy)
- [GNU Stow](https://www.gnu.org/software/stow/): `sudo pacman -S stow`

## Installation

### Fresh Installation on New Machine

```bash
# Clone this repository
cd ~
gh repo clone Tommynem/dotfiles-arch
# Or: git clone https://github.com/Tommynem/dotfiles-arch.git

cd ~/dotfiles-arch

# Install all packages (creates symlinks)
./install.sh all

# Or install specific packages
stow nvim
stow alacritty
```

### Installing Individual Packages

```bash
cd ~/dotfiles-arch
stow <package-name>
```

For example:
```bash
stow nvim       # Install neovim configuration
stow alacritty  # Install alacritty configuration
```

### Uninstalling Packages

```bash
cd ~/dotfiles-arch
stow -D <package-name>
```

## How It Works

GNU Stow creates symlinks from your home directory to the files in this repository. For example:

```
~/dotfiles-arch/nvim/.config/nvim  →  ~/.config/nvim (symlink)
~/dotfiles-arch/alacritty/.config/alacritty/alacritty.toml  →  ~/.config/alacritty/alacritty.toml (symlink)
```

This means you edit files in their normal locations (`~/.config/nvim/init.lua`, `~/.config/alacritty/alacritty.toml`), but they're actually stored in `~/dotfiles-arch` and version controlled by git.

## Configuration Notes

### Neovim
- Migrated from macOS dotfiles with Linux-specific adjustments:
  - Python provider: `/usr/bin/python3` (was `/opt/homebrew/bin/python3.12`)
  - Browser opener: `xdg-open` (was `open`)
- All other configurations are cross-platform compatible

### Alacritty
- Preserves Omarchy theme import: `~/.config/omarchy/current/theme/alacritty.toml`
- Adds Shift+Enter binding for newline insertion in terminal
- Maintains Omarchy defaults for fonts, padding, and decorations

## Maintenance

### Adding New Dotfiles

1. Create a new package directory: `mkdir ~/dotfiles-arch/newapp`
2. Move your config into it, maintaining the home directory structure:
   ```bash
   mkdir -p ~/dotfiles-arch/newapp/.config
   mv ~/.config/newapp ~/dotfiles-arch/newapp/.config/
   ```
3. Stow the package: `cd ~/dotfiles-arch && stow newapp`
4. Commit to git: `git add . && git commit -m "Add newapp configuration"`

### Removing Packages

```bash
cd ~/dotfiles-arch
stow -D <package-name>  # Remove symlinks
rm -rf <package-name>   # Remove from repository
```

### Syncing Changes

Since stow creates symlinks, any changes you make to your dotfiles in their normal locations are automatically reflected in this repository.

To commit and push changes:

```bash
cd ~/dotfiles-arch
git add .
git commit -m "Update configuration"
git push
```

## Migration from macOS

This repository contains configurations selectively migrated from the macOS dotfiles repo. Configs are adjusted for Linux/Omarchy compatibility while maintaining functionality.

## Notes

- Stow will not overwrite existing files. If you have conflicts, back up or remove the existing files first.
- This is designed to work alongside Omarchy's default configurations
- Backups of original Omarchy configs are created with `.omarchy-backup.TIMESTAMP` suffix
