#!/bin/bash

# Terminate execution if any command fails
set -e

# --- 1. GLOBAL CONFIGURATION ---
# Target identifier for the Nix Flake configuration
TARGET_HOSTNAME="Ks-Mac"
# Source repository for dotfiles and system configuration
GIT_REPO="https://github.com/kxdrsrt/dotfiles"

# --- 2. AUTHENTICATION & SESSION MANAGEMENT ---
# Prime administrative privileges and maintain the session in the background
# This prevents timeouts during long downloads or manual configuration steps
echo "🔑 Authorizing bootstrap process..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- 3. HOME DIRECTORY INITIALIZATION ---
# Overlay the repository onto the existing user home directory
echo "🔄 Initializing user environment in home directory..."
cd "$HOME" || exit 1

if [ ! -d ".git" ]; then
    git init
    git remote add origin "$GIT_REPO"
fi
git fetch origin
git checkout -f master

# --- 4. SYSTEM IDENTITY SETUP ---
# Set the system network names to match the configuration attribute
echo "🔧 Configuring system identity to '$TARGET_HOSTNAME'..."
sudo scutil --set ComputerName "$TARGET_HOSTNAME"
sudo scutil --set HostName "$TARGET_HOSTNAME"
sudo scutil --set LocalHostName "$TARGET_HOSTNAME"

# --- 5. COMPATIBILITY LAYER INSTALLATION ---
# Ensure Rosetta 2 is available for Intel-based binary support
if [[ $(uname -m) == "arm64" ]]; then
    echo "🍎 Verifying Rosetta 2 status..."
    # Check whether Rosetta is available by attempting to run an x86_64 command.
    # If this succeeds, Rosetta is installed; otherwise install it.
    if /usr/bin/arch -x86_64 true &>/dev/null; then
        echo "🍎 Rosetta 2 is already present."
    else
        echo "🍎 Rosetta 2 not found. Proceeding with installation..."
        sudo softwareupdate --install-rosetta --agree-to-license
    fi
fi

# --- 6. CONFIGURATION REPOSITORY SETUP ---
# Synchronize the local nix-darwin configuration directory
echo "🔄 Synchronizing system configuration repository..."
if [ ! -d "$HOME/nix-darwin-config" ]; then
    echo "📂 Cloning configuration files from $GIT_REPO..."
    git clone "$GIT_REPO" "$HOME/nix-darwin-config"
fi

# --- 7. SECURITY PERMISSION HANDLER ---
# Prompt for Full Disk Access to enable modification of system preferences
echo "🔐 Requesting necessary system permissions..."
echo "👉 1. Find your Terminal app in the Full Disk Access list."
echo "👉 2. Toggle the permission to ON."
echo "👉 3. Return here and press Enter to continue."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
read -p "Press [Enter] once permissions are granted..."

cd "$HOME/nix-darwin-config" || exit 1

# --- 8. VERSION CONTROL STAGING ---
# Ensure all files are tracked so they are visible to the Nix evaluator
git add . || true

# --- 9. SYSTEM ACTIVATION ---
# Execute the nix-darwin build and activation
echo "❄️  Applying system configuration..."
# sudo -H ensures correct home directory ownership for the root user
# .#$TARGET_HOSTNAME targets the specific machine attribute defined at the top
sudo -H nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#"$TARGET_HOSTNAME"

echo "✅ System bootstrap complete! ❄️"
echo "👉 Please restart your terminal session to finalize all changes."
