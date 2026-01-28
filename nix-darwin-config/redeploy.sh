#!/bin/bash

# Exit on any error
set -e

# --- CONFIGURATION ---
FLAKE_DIR="$HOME/nix-darwin-config"
TARGET_CONFIG="Ks-Mac"

cd "$FLAKE_DIR" || exit 1

# 1. Authorize the session
# This ensures you enter your password (or use TouchID) once at the start.
# Thanks to your flake.nix sudoers rule, Homebrew won't ask again.
# echo "🔐 Authorizing system rebuild..."
# sudo -v

# Ensure Rosetta 2 is available on Apple Silicon (arm64)
# If the probe fails, install Rosetta non-interactively.
if [[ $(uname -m) == "arm64" ]]; then
    echo "🍎 Verifying Rosetta 2 status..."
    if /usr/bin/pgrep -q oahd; then
        echo "🍎 Rosetta 2 is already installed."
    else
        echo "🍎 Rosetta 2 not found. Proceeding with installation..."
        sudo softwareupdate --install-rosetta --agree-to-license
    fi
fi


# 2. Make new files visible to Nix
echo "🔍 Making new files visible to Nix..."
# Required so Nix can see files that aren't yet staged in Git.
git add -N .

# 3. Rebuild
echo "❄️  Rebuilding nix-darwin..."
# UPDATED FOR 2026:
# Using 'nix run' ensures the command is found even if it's not in your current PATH.
# sudo -H prevents home directory ownership warnings.
if sudo -H nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#"$TARGET_CONFIG"; then
    echo "✅ Rebuild successful!"
    echo "ℹ️  Changes are active, but NOT committed. Use 'git commit' when ready."
else
    echo "❌ Rebuild failed."
    exit 1
fi
