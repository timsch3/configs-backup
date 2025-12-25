#!/bin/bash

# 1. Get the directory where this script is located
# This ensures it works even if you run it from a different folder
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR" || exit

# 2. Track installed software
echo "Tracking currently installed software in packages.txt and snaps.txt..."
apt-mark showmanual > packages.txt
snap list | awk 'NR>1 {print $1}' > snaps.txt

# 3. Define source paths
ZSH_RC="$HOME/.zshrc"
GIT_CONFIG="$HOME/.gitconfig"
THEME_SOURCE="$HOME/.oh-my-zsh/custom/themes/robbyrussell-fullpath.zsh-theme"

DATE=$(date +'%Y-%m-%d-%H:%M:%S')

echo "Starting backup in: $REPO_DIR"

# 4. Copy files to the current repo folder
cp "$ZSH_RC" .
cp "$GIT_CONFIG" .

if [ -f "$THEME_SOURCE" ]; then
    cp "$THEME_SOURCE" .
    echo "✓ Theme copied."
else
    echo "✗ Warning: Custom theme not found at $THEME_SOURCE"
fi

# 5. Git Operations
echo "Pushing to GitHub..."

# Add all changes (including the script itself if you modified it)
git add .

# Only commit if there are actually changes to avoid empty commits
if git diff-index --quiet HEAD --; then
    echo "No changes detected. Skipping push."
else
    git commit -m "Backup: $DATE"
    git push origin main
    echo "✓ Backup complete!"
fi
