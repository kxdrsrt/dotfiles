#!/bin/bash

# Terminate execution if any command or pipe segment fails
set -eo pipefail

trap 'echo "❌ Bootstrap failed at line $LINENO. Check the output above for details." >&2' ERR

# --- 1. GLOBAL CONFIGURATION ---
# Target identifier for the Nix Flake configuration
TARGET_HOSTNAME="Ks-Mac"
# Source repository for dotfiles and system configuration
GIT_REPO="https://github.com/kxdrsrt/dotfiles"

# --- 2. AUTHENTICATION & SESSION MANAGEMENT ---
# Prime administrative privileges and maintain the session in the background.
# This prevents timeouts during long downloads or manual configuration steps.
# The keepalive is automatically cleaned up when the script exits.
echo "🔑 Authorizing bootstrap process..."
sudo -v
SUDO_KEEPALIVE_PID=""
_start_keepalive() {
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    SUDO_KEEPALIVE_PID=$!
}
_stop_keepalive() {
    [ -n "$SUDO_KEEPALIVE_PID" ] && kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
}
trap _stop_keepalive EXIT
_start_keepalive

# --- 3. NIX INSTALLATION ---
# Install Nix via the Determinate Systems installer if it is not already present.
# Determinate Nix enables nix-command and flakes by default — no extra flags needed.
if ! command -v nix &>/dev/null; then
    echo "❄️  Nix not found. Installing via Determinate Systems installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install --no-confirm
    # Source the Nix daemon environment so subsequent commands can use nix
    # shellcheck source=/dev/null
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    echo "❄️  Nix is already installed."
fi

# --- 4. HOME DIRECTORY INITIALIZATION ---
# Overlay the repository onto the existing user home directory
echo "🔄 Initializing user environment in home directory..."
cd "$HOME" || exit 1

if [ ! -d ".git" ]; then
    git init
    git remote add origin "$GIT_REPO"
fi
git fetch origin
git checkout -f master

# --- 5. SYSTEM IDENTITY SETUP ---
# Set the system network names to match the configuration attribute
echo "🔧 Configuring system identity to '$TARGET_HOSTNAME'..."
sudo scutil --set ComputerName "$TARGET_HOSTNAME"
sudo scutil --set HostName "$TARGET_HOSTNAME"
sudo scutil --set LocalHostName "$TARGET_HOSTNAME"

# --- 6. COMPATIBILITY LAYER INSTALLATION ---
# Only relevant on Apple Silicon — skipped entirely on Intel.
# Within the arm64 block, only installs Rosetta if it isn't already present.
if [[ $(uname -m) == "arm64" ]]; then
    echo "🍎 Verifying Rosetta 2 status..."
    if /usr/bin/arch -x86_64 true &>/dev/null; then
        echo "🍎 Rosetta 2 is already present."
    else
        echo "🍎 Rosetta 2 not found. Proceeding with installation..."
        sudo softwareupdate --install-rosetta --agree-to-license
    fi
fi

# --- 7. SECURITY PERMISSION HANDLER ---
# Full Disk Access is required for nix-darwin to modify system files.
# The system TCC database is only readable by processes that have FDA granted,
# making it a direct and Terminal-specific probe (no Safari dependency).
_check_fda() {
    sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "" &>/dev/null
}
if ! _check_fda; then
    echo "🔐 Full Disk Access not detected. Requesting permission..."
    echo "👉 1. Find your Terminal app in the Full Disk Access list."
    echo "👉 2. Toggle the permission to ON."
    echo "👉 3. Return here and press Enter to continue."
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
    read -rp "Press [Enter] once permissions are granted..."
    # Verify the permission was actually granted before continuing
    if ! _check_fda; then
        echo "❌ Full Disk Access still not detected. Please grant it and re-run." >&2
        exit 1
    fi
else
    echo "🔐 Full Disk Access already granted, skipping prompt."
fi

# nix-darwin-config is part of the same dotfiles repo, already present after
# step 4 — no separate clone needed.
cd "$HOME/nix-darwin-config" || exit 1

# --- 8. VERSION CONTROL STAGING ---
# Make untracked files visible to the Nix evaluator without fully staging them
git add -N . || true

# --- 9. PRE-ACTIVATION CLEANUP ---
# nix-darwin refuses to overwrite unrecognized /etc files.
# Remove known conflicting files so activation proceeds unattended.
echo "🧹 Removing conflicting /etc files for nix-darwin..."
for f in /etc/zshenv /etc/zshrc /etc/bashrc /etc/bash.bashrc; do
    if [ -f "$f" ]; then
        echo "  🗑️  Removing $f"
        sudo rm -f "$f"
    fi
done

# --- 10. SYSTEM ACTIVATION ---
# Execute the nix-darwin build and activation.
# Determinate Nix enables nix-command + flakes by default, so no extra flags needed.
# sudo -H ensures the correct home directory for the root user.
echo "❄️  Applying system configuration..."
sudo -H nix run nix-darwin -- switch --flake .#"$TARGET_HOSTNAME"

echo "✅ System bootstrap complete! ❄️"
echo "👉 Please restart your terminal session to finalize all changes."
