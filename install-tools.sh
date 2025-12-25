#!/bin/bash

# 1. Update System
sudo apt update && sudo apt upgrade -y

# 2. Install APT Packages
echo "Installing APT packages..."
xargs -a packages.txt sudo apt install -y

# 3. Install Snap Packages
echo "Installing Snaps..."
while read snap_app; do
    sudo snap install "$snap_app"
done < snaps.txt

# 4. Install essential tools 
echo "Installing Dev Tools..."
sudo apt install -y curl git vim zsh

# 5. Setup Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Installation complete."

# 6. Restore Config Files from this Repo
echo "Restoring configuration files..."

# Get the directory where this script is running
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Restore .zshrc
if [ -f "$REPO_DIR/.zshrc" ]; then
    cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
    echo "✓ .zshrc restored."
fi

# Restore .gitconfig
if [ -f "$REPO_DIR/.gitconfig" ]; then
    cp "$REPO_DIR/.gitconfig" "$HOME/.gitconfig"
    echo "✓ .gitconfig restored."
fi

# Restore Custom Theme
THEME_DEST="$HOME/.oh-my-zsh/custom/themes"
mkdir -p "$THEME_DEST" # Ensure the folder exists
if [ -f "$REPO_DIR/robbyrussell-fullpath.zsh-theme" ]; then
    cp "$REPO_DIR/robbyrussell-fullpath.zsh-theme" "$THEME_DEST/"
    echo "✓ Robbyrussell theme restored."
fi

echo "Restoration complete. Please restart your terminal or run 'source ~/.zshrc'."
