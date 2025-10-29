# Omarchy System Configuration Guide

**System Owner:** IT Professional
**Primary Use:** Development workstation (web development focus) + client/personal data handling
**Last Updated:** 2025-10-30
**Hardware:** Modern hardware, performance monitoring required
**Dotfiles Location:** `/home/tomge/dotfiles-arch/` (this repository)
**Change History:** See `CHANGELOG.md` for detailed repository changes

---

## ABOUT THIS DOCUMENT

This CLAUDE.md file lives in the **dotfiles-arch repository** (`~/dotfiles-arch/`) and serves as the central knowledge base for managing this Omarchy system. It is version-controlled alongside configuration files.

### Claude's Responsibilities

**CRITICAL: Claude MUST actively maintain this document:**

1. **Self-Update Outdated References**
   - When you discover information in this document is outdated, incorrect, or conflicts with reality
   - **IMMEDIATELY** update the relevant section with accurate information
   - Add a note in the commit message about what was corrected

2. **Persist New Vital Information**
   - When new system configurations, patterns, or procedures are established
   - When new packages or tools are installed that affect the development workflow
   - When security configurations or system policies change
   - When discovering important system quirks or gotchas
   - **ADD** this information to the appropriate section

3. **Document Location**
   - This file is at: `/home/tomge/dotfiles-arch/CLAUDE.md`
   - Changes to this file are version controlled with git
   - Always commit updates with descriptive messages

4. **Maintain CHANGELOG.md**
   - **ALWAYS** update `/home/tomge/dotfiles-arch/CHANGELOG.md` when making system changes
   - Add entries under the current date section for:
     - New packages added to dotfiles (under "Added")
     - Configuration changes (under "Changed")
     - Bug fixes (under "Fixed")
     - Removed configurations (under "Removed")
   - Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
   - Reference CHANGELOG.md when recalling what changes have been made to the system
   - Update both CLAUDE.md (for reference/procedures) AND CHANGELOG.md (for chronological changes)

5. **What to Update**
   - ✅ Package lists when new tools are installed/removed
   - ✅ Configuration paths when they change
   - ✅ System procedures when workflow evolves
   - ✅ Security settings when firewall/encryption changes
   - ✅ Known issues and their solutions
   - ✅ The "Last Updated" date at the top
   - ✅ **CHANGELOG.md entries for all dotfiles changes**
   - ❌ Don't remove historical context unless explicitly asked
   - ❌ Don't make stylistic changes without reason

---

## DOTFILES MANAGEMENT STRATEGY

### Repository Structure

All personal configurations are managed in **`~/dotfiles-arch/`** using GNU Stow:

```
~/dotfiles-arch/
├── CLAUDE.md              # This file - system management guide
├── README.md              # Dotfiles repository documentation
├── .gitignore            # Git ignore rules
├── install.sh            # Stow installation script
├── nvim/                 # Neovim configuration package
│   └── .config/nvim/     # Full nvim config (migrated from macOS)
├── alacritty/            # Alacritty configuration package
│   └── .config/alacritty/ # Terminal config overrides
├── zsh/                  # ZSH shell configuration
│   └── .zshrc            # Shell config (migrated from macOS)
├── hypr/                 # Hyprland window manager configuration
│   └── .config/hypr/     # All hypr configs (bindings, monitors, etc.)
├── xcompose/             # XCompose key sequences
│   └── .XCompose         # Custom compose key mappings
└── bin/                  # Custom scripts
    └── .local/bin/       # User binaries (omarchy-menu-custom, etc.)
```

### How Stow Works

GNU Stow creates **symlinks** from `~/.config/` to `~/dotfiles-arch/`:

```
~/.config/nvim → ~/dotfiles-arch/nvim/.config/nvim (symlink)
~/.config/alacritty/alacritty.toml → ~/dotfiles-arch/alacritty/.config/alacritty/alacritty.toml (symlink)
~/.config/hypr → ~/dotfiles-arch/hypr/.config/hypr (symlink)
~/.zshrc → ~/dotfiles-arch/zsh/.zshrc (symlink)
~/.XCompose → ~/dotfiles-arch/xcompose/.XCompose (symlink)
~/.local/bin/omarchy-menu-custom → ~/dotfiles-arch/bin/.local/bin/omarchy-menu-custom (symlink)
```

**This means:**

- Editing `~/.config/nvim/init.lua` directly modifies `~/dotfiles-arch/nvim/.config/nvim/init.lua`
- Changes are automatically reflected in the git repository
- Just `git add`, `git commit`, `git push` to save changes

### Dotfiles Management Commands

```bash
# Navigate to dotfiles
cd ~/dotfiles-arch

# Install all packages (create symlinks)
./install.sh all

# Install specific package
./install.sh install nvim
stow nvim  # Alternative

# Uninstall package (remove symlinks)
./install.sh uninstall nvim
stow -D nvim  # Alternative

# List available packages
./install.sh list

# Commit configuration changes
git add .
git commit -m "Description of changes"
git push
```

### Currently Managed Configurations

**Active (via stow):**

- ✅ **nvim** - Complete Neovim configuration (migrated from macOS, Linux-adjusted)
- ✅ **alacritty** - Alacritty overrides (Shift+Enter binding + Omarchy defaults)
- ✅ **zsh** - Shell configuration with oh-my-zsh, zoxide, fzf, atuin, zsh-magic-dashboard (migrated from macOS, Linux-adjusted)
  - **Features**: Smart directory jumping (zoxide), fuzzy finding (fzf), shell history (atuin), dashboard on empty Enter (magic-dashboard)
- ✅ **hypr** - Hyprland window manager configuration (bindings, monitors, input, looknfeel, etc.)
  - Custom workspace setup: WT (Terminal), WB (Browsing), WM (Mail), WA (AI) with icon indicators
  - Workspace keybindings: `Super + T/B/M/A` for named workspaces, `Super + 1-5` for numbered
- ✅ **waybar** - Status bar configuration (config.jsonc, style.css)
  - Icon-based workspace indicators for custom workspaces
- ✅ **xcompose** - Custom XCompose key sequences for special character input
- ✅ **bin** - Custom user scripts
  - `omarchy-menu-custom` - Modified Omarchy menu with Logout option in System menu
  - Note: Scripts require symlink in `~/.local/share/omarchy/bin/` to be accessible (see OMARCHY ARCHITECTURE section)
- ✅ **yazi** - File manager configuration
  - Custom keybind `g n` to navigate to NAS pool at `/mnt/nas-pool`

**To Be Added (when customized):**

- ⏳ git - Git configuration
- ⏳ Other tools as needed

### Configuration Backup Strategy

**Automated Backups:**

- Original Omarchy configs backed up with `.omarchy-backup.TIMESTAMP` suffix before stow
- Example: `~/.config/nvim.omarchy-backup.20251029-162428/`

**Version Control:**

- All dotfiles are git-versioned in `~/dotfiles-arch/`
- Commit frequently to maintain history

### macOS Dotfiles Relationship

- **macOS repo:** `https://github.com/Tommynem/dotfiles` (private, stow-based)
- **Arch repo:** `~/dotfiles-arch/` (local, will push to GitHub when ready)
- **Strategy:** Selective migration - copy configs as needed, adjust for Linux
- **Divergence expected:** macOS repo may receive fewer updates as this becomes primary system

---

## CRITICAL GROUND RULES

### 1. System Stability Priority

- **Omarchy is Arch-based and can be frail** - exercise extreme caution with system changes
- Always verify current state before making modifications
- Test changes incrementally rather than batch operations
- Create manual snapshots before major changes: `omarchy-snapshot create`
- Keep recovery procedures readily accessible

### 2. Security & Privacy Requirements

- This system handles **sensitive client data and personal information**
- Security and privacy are **always** primary concerns for any change
- Review all network-facing configurations carefully
- Audit packages before installation, especially from AUR
- Maintain full-disk LUKS encryption (already configured)
- Firewall is enabled by default (all incoming blocked except SSH:22, LocalSend:53317)

### 3. Performance & Resource Management

- System will host hundreds of packages - monitor resource consumption
- Clean up artifacts from unused/unnecessary packages regularly
- Use `pacman -Qtdq | sudo pacman -Rns -` to remove orphaned packages
- Monitor with `btop` (already installed)
- Keep `/var/cache/pacman/pkg/` under control with `paccache -r`

### 4. Operational Safety Protocol

**CRITICAL: Always follow this protocol when working with system operations:**

- **NO ASSUMPTIONS** - Only rely on: CLAUDE.md, explicit user prompts, or verified information
- **USE ABSOLUTE PATHS** whenever possible
- **VERIFY WORKING DIRECTORY** before using relative paths with `pwd`
- **CHECK BEFORE DESTRUCTIVE OPERATIONS** - always confirm target paths/files exist and are correct
- **READ BEFORE WRITE** - verify file contents before modifications
- **TEST COMMANDS** - use dry-run flags when available (e.g., `pacman -S --print-format`)

---

## OMARCHY ARCHITECTURE

### Configuration Philosophy

Omarchy uses a **layered configuration system**:

```
~/.config/                    ← YOUR FILES - Make all customizations here
~/.local/share/omarchy/       ← SYSTEM FILES - DO NOT MODIFY DIRECTLY
```

**Golden Rule:** If you need to change something in `~/.local/share/omarchy/`, override it in `~/.config/` instead.

### Directory Structure

#### User Configuration (`~/.config/`)

Key directories and their purposes:

**Window Manager & Desktop:**

- `hypr/` - Hyprland window manager configuration
  - `hyprland.conf` - Main config file
  - `monitors.conf` - Display configuration
  - `bindings.conf` - Keyboard shortcuts
  - `envs.conf` - Environment variables
  - `autostart.conf` - Startup applications
  - `input.conf` - Keyboard/mouse settings
  - `looknfeel.conf` - Visual styling
  - `hypridle.conf`, `hyprlock.conf`, `hyprsunset.conf` - Power/lock/night light
- `waybar/` - Status bar configuration
- `walker/` - Application launcher (Super + Alt + Space)
- `mako/` - Notification daemon

**Applications:**

- `nvim/` - Neovim configuration (→ symlink to `~/dotfiles-arch/nvim/.config/nvim/`)
- `alacritty/` - Terminal emulator (→ `alacritty.toml` symlinked to `~/dotfiles-arch/`)
- `ghostty/` - Alternative terminal
- `kitty/` - Alternative terminal
- `chromium/`, `brave-flags.conf`, `chromium-flags.conf` - Browser configs
- `lazygit/` - Git TUI
- `btop/` - System monitor

**Omarchy-Specific:**

- `omarchy/` - Omarchy customizations and themes
- `aether/` - Omarchy GUI theme manager

**Development Tools:**

- `git/` - Git configuration
- `mise/` - Development environment manager (replaces asdf/nvm)
- `fastfetch/` - System information display
- `starship.toml` - Shell prompt configuration

#### System Defaults (`~/.local/share/omarchy/`)

- `applications/` - Desktop application entries
- `bin/` - Omarchy system scripts (5752+ utilities)
  - **Important:** Custom scripts must be symlinked here to be found by Hyprland bindings and Walker
  - Omarchy looks in this directory for all `omarchy-*` commands
  - Example: `ln -s ~/.local/bin/custom-script ~/.local/share/omarchy/bin/custom-script`
  - Note: Symlinks here may be removed during Omarchy updates
- `config/` - Default configurations
- `default/` - Base system defaults
- `install/` - Installation scripts
- `migrations/` - Version update migrations
- `boot.sh` - System boot script

---

## PACKAGE MANAGEMENT

### Package Sources

Omarchy integrates three package sources:

1. **Official Arch repositories** (pacman)
2. **Omarchy Package Repository** (custom curated packages)
3. **AUR (Arch User Repository)** (community packages - requires review)

### Installation Methods

**Via Omarchy Menu (Recommended):**

- Press `Super + Alt + Space` to open Omarchy menu
- Navigate to `Install > Package` for official packages
- Navigate to `Install > AUR` for AUR packages
  - Press `Alt+B` to view PKGBUILD before installing
- Fuzzy search automatically filters as you type

**Via Command Line:**

```bash
# Official packages
sudo pacman -S [package-name]

# AUR packages (requires yay)
yay -S [package-name]

# Interactive package browser
omarchy-pkg-install
```

### Update Procedures

**Full System Update (Recommended):**

- Via menu: `Update > Omarchy`
- This process:
  1. Pulls latest Omarchy code
  2. Runs pending migrations
  3. Updates all packages (Arch + Omarchy + AUR)
  4. **Automatically creates snapshot** before update

**Manual Updates:**

```bash
# Update package databases
sudo pacman -Sy

# Update all packages
sudo pacman -Syu

# Update AUR packages
yay -Sua
```

### Package Maintenance

**Remove Package:**

```bash
sudo pacman -Rns [package]  # Remove with dependencies
```

**Clean Package Cache:**

```bash
paccache -r      # Keep last 3 versions
paccache -rk1    # Keep only last version
```

**Find Orphaned Packages:**

```bash
pacman -Qtdq              # List orphans
pacman -Qtdq | sudo pacman -Rns -  # Remove orphans
```

**Security: Always review AUR packages:**

```bash
# View PKGBUILD before installing
yay -G [package]  # Clone package build files
cd [package]
cat PKGBUILD      # Review build instructions
```

---

## DEFAULT INSTALLED SOFTWARE

### Core Applications

- **Editor:** Neovim (LazyVim configuration)
- **Terminal:** Alacritty (default), Ghostty, Kitty
- **Browser:** LibreWolf (default), Chromium (for webapps)
- **Window Manager:** Hyprland (tiling)
- **File Manager:** (check via Omarchy menu)
- **Office:** LibreOffice, Typora
- **Notes:** Obsidian

### Development Tools

- **Version Control:** git, lazygit, lazydocker
- **Shell:** zsh with starship prompt
- **Search:** ripgrep, fzf
- **Navigation:** zoxide (smart cd)
- **Environment Manager:** mise (replaces nvm/rbenv/pyenv)
- **System Monitor:** btop

### System Utilities

- **Display:** Hyprland with Waybar
- **Launcher:** Walker (Super + Alt + Space)
- **Notifications:** mako
- **Font:** Caskaydia Mono Nerd Font (terminal + system)
- **Screenshots:** (check default screenshot tool)
- **File Sharing:** LocalSend (port 53317)

---

## SYSTEM ADMINISTRATION

### Snapshot Management

**Automatic Snapshots:**

- Created automatically before each system update
- Accessible via Limine bootloader at startup

**Manual Snapshots:**

```bash
# Create snapshot
omarchy-snapshot create

# List snapshots
omarchy-snapshot list

# Restore snapshot
omarchy-snapshot restore
```

**Boot into Snapshot:**

1. Restart system
2. Select snapshot from Limine bootloader menu
3. System boots into previous state

### System Recovery

**If Update Breaks System:**

1. Reboot and select previous snapshot from bootloader
2. OR use: `omarchy-snapshot restore`

**Complete System Restore:**

```bash
omarchy-reinstall  # Restores default configs and packages
```

**Configuration Backup:**

```bash
# Manual backup of user configs
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)

# Restore from backup
cp -r ~/.config.backup.YYYYMMDD ~/.config
```

### System Logs & Troubleshooting

**View System Logs:**

```bash
journalctl -xe              # Recent errors
journalctl -b               # Current boot log
journalctl -u [service]     # Specific service logs
```

**Hyprland Logs:**

```bash
cat ~/.hyprland.log         # Current session log
```

**Check System Status:**

```bash
systemctl --failed          # Failed services
btop                        # System resources
fastfetch                   # System information
```

### Known Issues & Solutions

**Neovim Treesitter Module Not Found (Linux-specific)**

- **Issue:** On first Neovim startup after migrating from macOS, error: `module 'nvim-treesitter.configs' not found`
- **Root Cause:** Race condition where treesitter config loads before plugin is fully installed
- **Solution:** Wrap `require("nvim-treesitter.configs")` in `pcall()` to handle graceful loading
- **Status:** ✅ Fixed in commit ef18aa8 (2025-10-29)
- **File:** `~/dotfiles-arch/nvim/.config/nvim/lua/tomge/plugins/treesitter.lua`
- **Note:** Parsers auto-install on first run due to `auto_install = true` setting

---

## CUSTOMIZATION GUIDELINES

### Safe Customization Workflow

1. **Research First:** Check Omarchy docs and existing configs
2. **Backup:** Create snapshot or backup affected files
3. **Edit in ~/.config/:** Never modify ~/.local/share/omarchy/ directly
4. **Test Incrementally:** Change one thing at a time
5. **Document Changes:** Note what you changed and why
6. **Verify:** Test thoroughly before considering complete

### Editing Configurations

**Via Omarchy Menu (Recommended):**

- Press `Super + Alt + Space`
- Navigate to `Setup > Configs > [process]`
- Edit in Neovim, process auto-restarts on save

**Manual Editing:**

```bash
# Always use absolute paths
nvim /home/tomge/.config/hypr/bindings.conf

# Reload Hyprland after changes
hyprctl reload

# Restart specific services
systemctl --user restart waybar
```

### Theme Management

**Via Aether GUI:**

- Launch Aether application
- Create/modify themes visually

**Manual Theme Creation:**

```bash
# Copy existing theme as template
cp -r ~/.config/omarchy/themes/existing ~/.config/omarchy/themes/custom

# Edit theme files
nvim ~/.config/omarchy/themes/custom/theme.conf

# Switch themes via Omarchy menu or:
omarchy-theme-switch custom
```

### Automatic Theme Switching

**CRITICAL: System automatically switches between light and dark themes.**

**Current Configuration:**

- ✅ **Light Theme:** Rose Pine (6:00 AM - 6:00 PM)
- ✅ **Dark Theme:** Rose Pine Dark (6:00 PM - 6:00 AM)
- ✅ **System Preference:** Automatically sets `prefer-light` / `prefer-dark` for website dark mode support
- ✅ **Method:** systemd user timers (enabled and persistent)

**Implementation Details:**

```bash
# Service files (define what theme to switch to)
~/.config/systemd/user/theme-switch-light.service  # Switches to rose-pine
~/.config/systemd/user/theme-switch-dark.service   # Switches to rose-pine-dark

# Timer files (define when to switch)
~/.config/systemd/user/theme-switch-light.timer    # Triggers at 6:00 AM daily
~/.config/systemd/user/theme-switch-dark.timer     # Triggers at 6:00 PM daily
```

**Changing Themes (Simple):**

To switch to different themes, edit the service files:

```bash
# Edit light theme (daytime)
nvim ~/.config/systemd/user/theme-switch-light.service
# Change: Environment=THEME_NAME=rose-pine
# To:     Environment=THEME_NAME=<new-theme>

# Edit dark theme (nighttime)
nvim ~/.config/systemd/user/theme-switch-dark.service
# Change: Environment=THEME_NAME=rose-pine-dark
# To:     Environment=THEME_NAME=<new-theme>

# Apply changes
systemctl --user daemon-reload

# Available themes
omarchy-theme-list
```

**Changing Times:**

```bash
# Edit timer files
nvim ~/.config/systemd/user/theme-switch-light.timer  # Change OnCalendar=*-*-* 06:00:00
nvim ~/.config/systemd/user/theme-switch-dark.timer   # Change OnCalendar=*-*-* 18:00:00

# Apply changes
systemctl --user daemon-reload
systemctl --user restart theme-switch-light.timer theme-switch-dark.timer
```

**Manual Override:**

```bash
omarchy-theme-set rose-pine       # Switch to light theme immediately
omarchy-theme-set rose-pine-dark  # Switch to dark theme immediately
```

**How Theme Switching Works:**

When `omarchy-theme-set <theme>` is called:

1. Updates symlink: `~/.config/omarchy/current/theme` → `/path/to/theme`
2. Changes background image
3. Restarts UI components (waybar, mako, hyprland)
4. Applies theme to specific apps:
   - Terminals (alacritty, kitty, ghostty)
   - Browsers (chromium, brave)
   - Neovim
   - VS Code
   - Obsidian vaults
   - System monitor (btop)
5. **Sets system preference** via `gsettings`:
   - `prefer-light` if theme has `light.mode` marker file
   - `prefer-dark` otherwise
6. **Calls hook:** `~/.config/omarchy/hooks/theme-set "<theme-name>"`

**Integrating New Programs with Theme System:**

**IMPORTANT: All newly installed programs should respect the theme system.**

**Option 1: Add to Hook (Recommended for CLI tools and simple configs)**

Create or edit: `~/.config/omarchy/hooks/theme-set`

```bash
#!/bin/bash
# Called with theme name as $1

THEME_NAME="$1"
THEME_DIR="$HOME/.config/omarchy/current/theme"

# Example: Configure bat (code highlighter)
case "$THEME_NAME" in
  rose-pine)
    # Light theme
    bat cache --build --theme="Catppuccin-latte"
    ;;
  rose-pine-dark|catppuccin|gruvbox|nord|tokyo-night)
    # Dark themes
    bat cache --build --theme="Catppuccin-mocha"
    ;;
esac

# Example: Configure other tools
# Update ~/.config/my-app/config based on theme
# Restart services if needed
```

Make executable: `chmod +x ~/.config/omarchy/hooks/theme-set`

**Option 2: Symlink to Current Theme (For apps that support config includes)**

```bash
# App reads from:
~/.config/my-app/theme.conf → ~/.config/omarchy/current/theme/my-app.conf

# Create theme-specific configs in each theme:
~/.config/omarchy/themes/rose-pine/my-app.conf
~/.config/omarchy/themes/rose-pine-dark/my-app.conf
```

**Option 3: Read System Preference (For GUI apps)**

Apps that respect `gsettings` automatically work:

```bash
gsettings get org.gnome.desktop.interface color-scheme
# Returns: 'prefer-light' or 'prefer-dark'
```

Browsers and many GUI apps automatically detect this.

**Theme File Structure:**

Each theme directory (`~/.local/share/omarchy/themes/<theme-name>/`) contains:

- `alacritty.toml` - Terminal colors
- `btop.theme` - System monitor
- `chromium.theme` - Browser theme
- `ghostty.conf`, `kitty.conf` - Other terminals
- `hyprland.conf` - Window manager colors
- `hyprlock.conf` - Lock screen
- `mako.ini` - Notifications
- `neovim.lua` - Neovim colorscheme
- `vscode.json` - VS Code theme
- `waybar.css`, `walker.css` - UI components
- `obsidian.css` - (Optional) Obsidian theme
- `light.mode` - (Optional) Marker file for light themes
- `backgrounds/` - Theme backgrounds

**Adding New App Theme Support:**

1. Create config file in theme directories
2. Update `omarchy-theme-set` or use hook system
3. Test switching works correctly

**Monitoring Theme Switches:**

```bash
# Check timer status
systemctl --user list-timers | grep theme-switch

# View recent theme changes
journalctl --user -u theme-switch-light.service -u theme-switch-dark.service --since today

# Current theme
omarchy-theme-current
```

---

## DEVELOPMENT ENVIRONMENT

### Primary Focus: Web Development

**Language/Runtime Management:**
Use `mise` for managing development environments:

```bash
# Node.js
mise use node@lts          # Install LTS version
mise use node@20.10.0      # Install specific version

# Python
mise use python@latest

# Ruby
mise use ruby@latest

# View installed
mise list

# View available
mise ls-remote node
```

**Package Managers:**

- npm/npx (via mise's Node.js)
- yarn (install via: `npm install -g yarn`)
- pnpm (install via: `npm install -g pnpm`)

### Essential Development Packages to Consider

**Web Development:**

```bash
# Database
sudo pacman -S postgresql redis

# Containers
sudo pacman -S docker docker-compose
sudo systemctl enable docker
sudo usermod -aG docker tomge

# API Testing
yay -S postman-bin
# or
sudo pacman -S httpie

# Additional terminals for testing
# Already installed: alacritty, ghostty, kitty
```

**Code Quality:**

```bash
# Already available in Neovim via LazyVim
# LSPs, linters, formatters configured per-project
```

### Git Configuration

**Check Current Config:**

```bash
git config --list
cat ~/.config/git/config  # If using XDG config
cat ~/.gitconfig          # Traditional location
```

**Set User Info (if not set):**

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### SSH Keys

**Location:**

```bash
ls -la ~/.ssh/
```

**Generate New Key (if needed):**

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## MACOS MIGRATION NOTES

**macOS Dotfiles Location:** `/home/tomge/dotfiles-macos/` (cloned from private GitHub repo)

- Contains all legacy macOS configurations for reference
- Use as source when selectively migrating settings to Arch configs

### Configuration Transfer Strategy

**Priority Files to Transfer:**

1. SSH keys (`~/.ssh/`)
2. Git configuration (`~/.gitconfig` or `~/.config/git/`)
3. Development project directories
4. Browser profiles/bookmarks
5. Custom scripts and tools
6. Application-specific configs (if compatible)

**Transfer Methods:**

```bash
# Using rsync over network
rsync -avz --progress user@macbook:~/.ssh/ ~/.ssh/
rsync -avz --progress user@macbook:~/Projects/ ~/Projects/

# Using external drive
cp -r /media/drive/.ssh ~/
cp -r /media/drive/Projects ~/

# Using cloud sync (selective)
# Download from cloud storage to appropriate directories
```

**Path Mapping:**

```
macOS                          →  Linux (Omarchy)
/Users/[user]/                 →  /home/tomge/
~/Library/Application Support/ →  ~/.config/ or ~/.local/share/
/Applications/                 →  /usr/share/applications/ or ~/.local/share/applications/
```

### Application Equivalents

**To Research During Migration:**

- macOS exclusive apps → Linux alternatives
- Homebrew packages → pacman/AUR equivalents
- macOS-specific scripts → Update for Linux paths/tools

**Common Replacements:**

- Homebrew → pacman/yay
- iTerm2 → Alacritty/Ghostty/Kitty (already installed)
- Finder → Thunar or CLI tools
- Spotlight → Walker (Super + Alt + Space)

### Font Rendering Differences

- Omarchy uses Caskaydia Mono Nerd Font by default
- May need to transfer custom fonts to `~/.local/share/fonts/`
- Run `fc-cache -fv` after adding fonts

---

## SECURITY CHECKLIST

### Current Security Posture

- ✅ Full-disk LUKS encryption enabled
- ✅ Firewall active (ufw/nftables)
  - SSH: Port 22 open
  - LocalSend: Port 53317 open
  - All other incoming: BLOCKED
- ⚠️ Verify SSH key-based auth (disable password auth)
- ⚠️ Review AUR packages before installation
- ⚠️ Audit startup applications

### Security Maintenance Tasks

**Regular Security Reviews:**

```bash
# Check firewall status
sudo ufw status verbose

# Review open ports
sudo ss -tulpn

# Check for security updates
sudo pacman -Syu

# Audit installed packages
pacman -Q | wc -l    # Total count
pacman -Qm           # AUR packages only

# Review systemd services
systemctl list-unit-files --state=enabled
```

**SSH Hardening (if not done):**

```bash
# Edit SSH config
sudo nvim /etc/ssh/sshd_config

# Recommended settings:
# PermitRootLogin no
# PasswordAuthentication no
# PubkeyAuthentication yes
# AllowUsers tomge

# Restart SSH
sudo systemctl restart sshd
```

**File Permissions Audit:**

```bash
# Check for world-writable files (periodic check)
find /home/tomge -type f -perm -002 2>/dev/null

# Verify SSH directory permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

---

## MONITORING & MAINTENANCE

### Weekly Tasks

- [ ] Check system updates: `Update > Omarchy` via menu
- [ ] Review disk space: `df -h`
- [ ] Check system logs for errors: `journalctl -p 3 -b`
- [ ] Monitor resource usage: `btop`

### Monthly Tasks

- [ ] Clean package cache: `paccache -r`
- [ ] Remove orphaned packages: `pacman -Qtdq | sudo pacman -Rns -`
- [ ] Review installed packages: `pacman -Q | less`
- [ ] Verify backup/snapshot strategy
- [ ] Audit AUR packages for updates/abandonment

### Quarterly Tasks

- [ ] Full security audit (firewall, services, permissions)
- [ ] Review and clean ~/Projects/ and ~/Downloads/
- [ ] Evaluate new Omarchy features/updates
- [ ] Document system changes in this file

### Performance Monitoring

**Key Metrics to Watch:**

```bash
# CPU and Memory
btop

# Disk usage
df -h
du -sh ~/.cache/*
du -sh ~/.local/share/*

# Process analysis
ps aux --sort=-%mem | head
ps aux --sort=-%cpu | head

# Startup time analysis
systemd-analyze blame
systemd-analyze critical-chain
```

---

## KNOWN SYSTEM INFORMATION

**Verified Paths:**

- Home: `/home/tomge/`
- Config: `/home/tomge/.config/`
- Omarchy System: `/home/tomge/.local/share/omarchy/`

**Installed Terminals:**

- Alacritty (default)
- Ghostty
- Kitty

**Active Configuration Directories:**

- aether, alacritty, btop, chromium, fcitx5, ghostty, git, hypr, kitty, lazygit, mako, mise, nvim, omarchy, swayosd, waybar, walker, xournalpp, yay

**Window Manager:** Hyprland (Wayland)

**Display Server:** Wayland (Hyprland compositor)

**Shell:** zsh (with starship prompt)

---

## IMPORTANT OMARCHY COMMANDS

```bash
# System Updates
omarchy-update              # Full system update (also via menu)

# Snapshots
omarchy-snapshot create     # Create manual snapshot
omarchy-snapshot list       # List all snapshots
omarchy-snapshot restore    # Restore from snapshot

# Package Management
omarchy-pkg-install         # Interactive package browser

# Theme Management
omarchy-theme-set [name]    # Switch theme manually
omarchy-theme-list          # List available themes
omarchy-theme-current       # Show current theme
# NOTE: Automatic switching configured (6am light, 6pm dark)
# See "Automatic Theme Switching" section for details

# System Restore
omarchy-reinstall          # Restore defaults (nuclear option)

# Configuration Access
# Super + Alt + Space -> Setup > Configs > [process]
```

---

## QUICK REFERENCE

**Essential Keybinds:**

- `Super + Alt + Space` - Omarchy menu (Walker)
- Check `/home/tomge/.config/hypr/bindings.conf` for complete list

**Config File Locations:**

- Hyprland: `/home/tomge/.config/hypr/hyprland.conf`
- Waybar: `/home/tomge/.config/waybar/`
- Terminal: `/home/tomge/.config/alacritty/` (→ symlinked to `~/dotfiles-arch/alacritty/`)
- Neovim: `/home/tomge/.config/nvim/` (→ symlinked to `~/dotfiles-arch/nvim/`)
- Shell: `/home/tomge/.zshrc` (→ symlinked to `~/dotfiles-arch/zsh/`)
- Starship: `/home/tomge/.config/starship.toml`
- **Dotfiles Repo:** `/home/tomge/dotfiles-arch/` (stow-managed configurations)

**System Directories:**

- Applications: `~/.local/share/applications/`
- Fonts: `~/.local/share/fonts/`
- Omarchy: `~/.local/share/omarchy/`

**Documentation:**

- Omarchy Manual: https://learn.omacom.io/2/the-omarchy-manual
- Omarchy GitHub: https://github.com/basecamp/omarchy
- Arch Wiki: https://wiki.archlinux.org/

---

## NOTES FOR CLAUDE

### Document Maintenance (HIGHEST PRIORITY)

**YOU MUST ACTIVELY MAINTAIN THIS DOCUMENT:**

1. **Self-Update When Information is Outdated**
   - If you discover this document contains outdated, incorrect, or conflicting information
   - **IMMEDIATELY** edit `/home/tomge/dotfiles-arch/CLAUDE.md` to correct it
   - Commit with message explaining the correction
   - Examples: package versions changed, paths moved, new tools installed, configurations updated

2. **Persist Important New Information**
   - When installing new packages that affect development workflow
   - When establishing new system procedures or patterns
   - When discovering system quirks, gotchas, or solutions to problems
   - When security configurations change
   - **ADD** to the appropriate section in this document

3. **Update Tracking**
   - Always update the "Last Updated" date at the top when making changes
   - Commit CLAUDE.md changes with descriptive messages
   - Example: `git commit -m "Update CLAUDE.md: Add Docker installation to package list"`

4. **What Requires Documentation**
   - ✅ New packages installed (update "Currently Managed Configurations" or relevant sections)
   - ✅ Configuration changes (new dotfiles packages, stow configs)
   - ✅ System procedures that deviate from defaults
   - ✅ Security/firewall changes
   - ✅ Performance optimizations or resource issues discovered
   - ✅ Known issues and their workarounds
   - ❌ Temporary experiments or test configurations
   - ❌ User's personal project details

### Working with This System

**Core Principles:**

1. **Always verify paths** - Use `pwd` and absolute paths
2. **Check before acting** - Use `ls`, `cat`, or test commands first
3. **No assumptions** - Only rely on: CLAUDE.md, user prompts, verified facts
4. **Security first** - Consider privacy/security implications (handles sensitive client data)
5. **Incremental changes** - One change at a time, test thoroughly
6. **Document changes** - Update CLAUDE.md when making significant modifications
7. **Snapshot before major changes** - Use `omarchy-snapshot create`
8. **Prefer Omarchy tools** - Use built-in utilities when available
9. **AUR caution** - Always review PKGBUILDs for security
10. **Resource awareness** - Monitor system resources during operations

### Dotfiles Management Protocol

**When modifying configurations:**

1. **Check if managed by dotfiles-arch:**
   - `nvim` - YES (managed via stow)
   - `alacritty` - YES (managed via stow)
   - Others - Check "Currently Managed Configurations" section above

2. **For dotfiles-managed configs:**
   - Edit files in their normal locations (`~/.config/nvim/...`)
   - Changes automatically reflect in `~/dotfiles-arch/` (symlinks)
   - **MUST** commit changes after editing:
     ```bash
     cd ~/dotfiles-arch
     git add .
     git commit -m "Description of changes"
     ```
   - Update CLAUDE.md if new packages added or significant changes made

3. **Adding new dotfiles package:**
   - Create package directory in `~/dotfiles-arch/`
   - Maintain home directory structure (e.g., `.config/`, `.zshrc`)
   - Use `stow <package>` to create symlinks
   - Update "Currently Managed Configurations" section in CLAUDE.md
   - Commit to git

4. **For non-managed configs:**
   - Edit directly in `~/.config/` as usual
   - Consider adding to dotfiles-arch if frequently customized

**Common Pitfalls to Avoid:**

- ❌ Modifying files in `~/.local/share/omarchy/` directly
- ❌ Using relative paths without verifying CWD
- ❌ Installing packages without understanding dependencies
- ❌ Making multiple changes without testing each
- ❌ Forgetting to create snapshots before risky operations
- ❌ Assuming macOS paths/commands work on Linux
- ❌ Ignoring security implications of AUR packages
- ❌ Not cleaning up after removed packages
- ❌ Editing dotfiles-managed configs without committing to git
- ❌ Forgetting to update CLAUDE.md when system changes significantly
- ❌ Breaking symlinks by removing files from `~/dotfiles-arch/` without unstowing

**System State Verification Commands:**

```bash
pwd                          # Where am I?
ls -la [path]               # What's here?
pacman -Q [package]         # Is package installed?
systemctl status [service]  # Is service running?
which [command]             # Where is this command?
file [path]                 # What type of file is this?
```

---

**End of Configuration Guide**

## DOCUMENT MAINTENANCE REMINDER

**Claude: You are responsible for keeping this document accurate and up-to-date.**

- ✅ Update immediately when you discover outdated information
- ✅ Add new vital information as the system evolves
- ✅ Commit changes to git with descriptive messages
- ✅ Update the "Last Updated" date when making changes
- ⚠️ This is not optional - accurate documentation is critical for system management

**Location:** `/home/tomge/dotfiles-arch/CLAUDE.md` (version-controlled)
