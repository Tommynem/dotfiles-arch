# Restic Backup Configuration

Encrypted, automated backups to NAS using Restic.

## Overview

This configuration implements a robust backup strategy following industry best practices:

- **Encryption**: AES-256 encryption for all backups
- **Location**: Network storage at `/mnt/nas-pool/backup/restic-omarchy`
- **Schedule**: Hourly backups (automated via systemd timer)
- **Verification**: A structural check runs before retention/prune, followed by a 5% data check after prune
- **Failure reporting**: Any failed stage makes `restic-backup.service` fail with a nonzero result and sends one persistent critical Omarchy notification
- **Retention Policy**:
  - Last 24 hourly backups (1 day)
  - Last 30 daily backups (1 month)
  - Last 12 weekly backups (3 months)
  - Last 12 monthly backups (1 year)
  - Last 3 yearly backups

## Files Included

### Configuration Files (`.config/restic/`)

- `env` - Environment variables and repository settings
- `exclude.txt` - Patterns for files/directories to exclude from backups
- `password` - Repository password (you must create this)

### Scripts (`.local/bin/`)

- `restic-backup` - Main backup script with logging and verification
- `restic-restore` - Interactive restore helper

### Systemd Units (`.config/systemd/user/`)

- `restic-backup.service` - Backup service definition
- `restic-backup.timer` - Hourly backup schedule

## Initial Setup

### 1. Install Packages

```bash
cd ~/dotfiles-arch
stow restic
stow bin
stow systemd
```

### 2. Create Password File

**IMPORTANT**: Create a strong, unique password for your backup repository.

```bash
# Generate a secure password and save it
openssl rand -base64 32 > ~/.config/restic/password

# Secure the password file
chmod 600 ~/.config/restic/password

# BACKUP THIS PASSWORD SOMEWHERE SAFE (password manager, paper backup, etc.)
# WITHOUT IT, YOUR BACKUPS ARE UNRECOVERABLE!
```

### 3. Verify NAS is Mounted

```bash
mountpoint /mnt/nas-pool
# Should output: /mnt/nas-pool is a mountpoint
```

### 4. Initialize Restic Repository

```bash
# Source the environment
source ~/.config/restic/env

# Initialize the repository
restic init

# Verify initialization
restic snapshots
# Should show: repository ... opened successfully, created new cache
```

### 5. Enable Automated Backups

```bash
# Reload systemd user daemon
systemctl --user daemon-reload

# Enable and start the timer
systemctl --user enable restic-backup.timer
systemctl --user start restic-backup.timer

# Verify timer is active
systemctl --user list-timers | grep restic
```

### 6. Test Manual Backup

```bash
# Run a test backup
restic-backup

# Check the log
ls -lt ~/.local/share/restic/logs/

# Verify snapshot was created
source ~/.config/restic/env && restic snapshots
```

## Usage

### Running Manual Backups

```bash
restic-backup
```

Logs are saved to: `~/.local/share/restic/logs/backup-YYYYMMDD-HHMMSS.log`

If any setup, backup, retention, verification, or statistics stage fails, the user service records a nonzero result. Omarchy sends one critical `Restic backup failed` notification with the failed stage, exit status, and log path. The lifetime-0 notification bypasses Do Not Disturb, persists across shell restarts, and remains until it is explicitly dismissed by clicking, right-clicking, or closing it.

### Restoring Files

```bash
# Interactive restore menu
restic-restore

# Direct restic commands (after sourcing env)
source ~/.config/restic/env

# List snapshots
restic snapshots

# Browse a snapshot
restic ls latest

# Restore entire snapshot
restic restore latest --target /tmp/restore

# Restore specific file/directory
restic restore latest --target /tmp/restore --path /home/tomge/Documents

# Mount snapshot for browsing
mkdir /tmp/backup-mount
restic mount /tmp/backup-mount
# Browse files, then Ctrl+C to unmount
```

### Checking Backup Status

```bash
# View timer status
systemctl --user status restic-backup.timer

# View last backup run
systemctl --user status restic-backup.service

# View repository statistics
source ~/.config/restic/env && restic stats

# Check repository integrity
source ~/.config/restic/env && restic check
```

### Viewing Logs

```bash
# Latest backup log
ls -t ~/.local/share/restic/logs/ | head -1 | xargs -I {} cat ~/.local/share/restic/logs/{}

# All logs
ls -lt ~/.local/share/restic/logs/

# Systemd journal
journalctl --user -u restic-backup.service -n 50
```

Use both the timestamped log and the user-service journal when investigating a failed run.

### Repository Repair Safety

Stop the timer before any repository repair so an automated backup cannot run concurrently with repair commands:

```bash
systemctl --user stop restic-backup.timer
systemctl --user status restic-backup.timer
```

Run the repair and a full `restic check` manually. Restart the timer only after the repository is healthy:

```bash
systemctl --user start restic-backup.timer
```

## Customization

### Changing Backup Schedule

Edit `~/.config/systemd/user/restic-backup.timer`:

```ini
# For twice daily (2 AM and 2 PM)
OnCalendar=*-*-* 02,14:00:00

# For every 6 hours
OnCalendar=*-*-* 00/6:00:00
```

Then reload:
```bash
systemctl --user daemon-reload
systemctl --user restart restic-backup.timer
```

### Modifying Retention Policy

Edit `~/.config/restic/env`:

```bash
export RETENTION_HOURLY="24"   # Last 24 hours
export RETENTION_DAILY="30"    # Last 30 days
export RETENTION_WEEKLY="12"   # Last 12 weeks
export RETENTION_MONTHLY="12"  # Last 12 months
export RETENTION_YEARLY="3"    # Last 3 years
```

### Adding Exclusions

Edit `~/.config/restic/exclude.txt` and add patterns:

```
# Exclude specific directory
/home/tomge/large-files/

# Exclude pattern
**/*.iso
```

## Security Notes

1. **Password Protection**: The repository password is stored in `~/.config/restic/password` with 600 permissions. Keep a backup of this password in your password manager!

2. **Encryption**: All backups are encrypted with AES-256. Even if someone gains access to your NAS, they cannot read the backups without the password.

3. **SSH Keys & Secrets**: Since backups are encrypted, SSH keys, GPG keys, and other sensitive files are safely included in backups.

4. **Old Pre-Incident Backups**: The old repository at `/mnt/nas-pool/backup/restic-omarchy/` is being archived separately and should be compressed for long-term storage.

## Troubleshooting

### Backup Fails: "repository not found"

```bash
# Initialize the repository
source ~/.config/restic/env
restic init
```

### Backup Fails: "NAS not mounted"

```bash
# Check NAS mount
mountpoint /mnt/nas-pool

# Remount if needed
# (add your NAS mount command here)
```

### Timer Not Running

```bash
# Check timer status
systemctl --user list-timers | grep restic

# Enable timer
systemctl --user enable restic-backup.timer
systemctl --user start restic-backup.timer
```

### Permission Denied Errors

```bash
# Fix password file permissions
chmod 600 ~/.config/restic/password

# Fix script permissions
chmod +x ~/.local/bin/restic-backup
chmod +x ~/.local/bin/restic-restore
```

## Recovery Scenarios

### Recovering After System Reinstall

1. Mount your NAS
2. Restore dotfiles and stow restic package
3. Restore password file from secure backup
4. Verify repository access: `source ~/.config/restic/env && restic snapshots`
5. Use `restic-restore` to recover files

### Testing Recovery

**Do this at least once to ensure you can actually restore!**

```bash
# Create test restore directory
mkdir -p /tmp/restore-test

# Restore a specific file
source ~/.config/restic/env
restic restore latest --target /tmp/restore-test --path /home/tomge/.zshrc

# Verify
diff /tmp/restore-test/home/tomge/.zshrc ~/.zshrc
```

## Additional Resources

- [Restic Documentation](https://restic.readthedocs.io/)
- [Restic Forum](https://forum.restic.net/)
- Repository location: `/mnt/nas-pool/backup/restic-omarchy`
- Logs: `~/.local/share/restic/logs/`
