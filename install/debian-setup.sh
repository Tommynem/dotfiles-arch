#!/bin/bash
# Debian Server Setup Script
# Installs common utilities and zsh workflow dependencies

set -e

echo "=== Debian Server Setup ==="
echo ""

# Update package lists
echo "[1/8] Updating package lists..."
sudo apt update

# Core utilities from repos
echo "[2/8] Installing core utilities from apt..."
sudo apt install -y \
    vim \
    batcat \
    lazygit \
    htop \
    tree \
    ncdu \
    curl \
    wget \
    rsync \
    net-tools \
    git \
    tmux \
    unzip \
    zip \
    tar \
    jq \
    fd-find \
    ripgrep \
    ufw \
    fail2ban \
    logrotate \
    fzf \
    bat \
    zsh \
    zoxide \
    neovim \
    unattended-upgrades \
    npm \

# Create symlinks for Debian-renamed binaries
echo "[3/8] Creating compatibility symlinks..."
mkdir -p ~/.local/bin
[ ! -e ~/.local/bin/fd ] && ln -s $(which fdfind) ~/.local/bin/fd || true

# Ensure ~/.local/bin is in PATH
if ! grep -q 'local/bin' ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# Install eza (modern ls)
echo "[4/8] Installing eza..."
if ! command -v eza &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
else
    echo "eza already installed, skipping."
fi

# Install atuin (shell history)
echo "[5/8] Installing atuin..."
if ! command -v atuin &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
    echo "atuin already installed, skipping."
fi

# Install fastfetch
echo "[6/8] Installing fastfetch..."
if ! command -v fastfetch &> /dev/null; then
    FASTFETCH_VERSION=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r '.tag_name')
    wget -q "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb" -O /tmp/fastfetch.deb
    sudo dpkg -i /tmp/fastfetch.deb
    rm /tmp/fastfetch.deb
else
    echo "fastfetch already installed, skipping."
fi

# Install oh-my-zsh and plugins
echo "[7/8] Installing oh-my-zsh and plugins..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# zsh-syntax-highlighting
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# zsh-magic-dashboard
[ ! -d "$ZSH_CUSTOM/plugins/zsh-magic-dashboard" ] && \
    git clone https://github.com/chrisgrieser/zsh-magic-dashboard "$ZSH_CUSTOM/plugins/zsh-magic-dashboard"

# spaceship theme
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    git clone https://github.com/spaceship-prompt/spaceship-prompt "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

echo "[8/8] Installing programming dependencies and utilities (e.g. needed for nvim config)"
# Rust/Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Docker
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


echo ""
echo "=== Setup Complete ==="
echo ""
echo "Installed:"
echo "  - Core: vim, htop, tree, ncdu, curl, wget, rsync, net-tools, git, tmux"
echo "  - Archive: unzip, zip, tar"
echo "  - Search: fd, ripgrep, fzf, jq"
echo "  - Modern: bat, eza, zoxide, neovim"
echo "  - Shell: zsh, oh-my-zsh, atuin, fastfetch"
echo "  - Security: ufw, fail2ban, logrotate"
echo ""
echo "Next steps:"
echo "  1. Copy your .zshrc to this machine"
echo "  2. Run: chsh -s \$(which zsh)"
echo "  3. Copy nvim: cp -r ./dotfiles-arch/nvim/.config/nvim/ ~/.config/nvim"
echo "  4. Log out and back in"
