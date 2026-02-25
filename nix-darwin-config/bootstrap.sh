#!/bin/bash

# Terminate execution if any command or pipe segment fails
set -eo pipefail

trap 'echo "❌ Bootstrap failed at line $LINENO. Check the output above for details." >&2' ERR

# --- 1. GLOBAL CONFIGURATION ---
# Pass hostname as first argument: ./bootstrap.sh iMac
# Without argument: script prompts interactively
if [ -n "$1" ]; then
    TARGET_HOSTNAME="$1"
else
    read -rp "Enter target hostname (e.g. Ks-Mac, iMac): " TARGET_HOSTNAME
    [ -z "$TARGET_HOSTNAME" ] && { echo "❌ No hostname provided." >&2; exit 1; }
fi
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
# Determinate Systems does NOT support Intel (x86_64) Macs.
# Apple Silicon  → Determinate Nix (flakes enabled by default, manages own daemon)
# Intel x86_64   → official upstream Nix installer (flakes must be enabled manually)
if ! command -v nix &>/dev/null; then
    if [[ $(uname -m) == "arm64" ]]; then
        echo "❄️  Nix not found (Apple Silicon). Installing via Determinate Systems..."
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
            sh -s -- install --no-confirm
    else
        echo "❄️  Nix not found (Intel). Installing via official upstream installer..."
        # Multi-user install — required for nix-darwin
        curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | \
            sh -s -- --daemon --yes
        # Enable flakes + nix-command for the current user (nix-darwin will
        # persist this into /etc/nix/nix.conf on first activation)
        mkdir -p "$HOME/.config/nix"
        echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"
        echo "❄️  Flakes enabled in ~/.config/nix/nix.conf"
    fi
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
sudo /usr/sbin/scutil --set ComputerName  "$TARGET_HOSTNAME"
sudo /usr/sbin/scutil --set HostName      "$TARGET_HOSTNAME"
sudo /usr/sbin/scutil --set LocalHostName "$TARGET_HOSTNAME"

# --- 6. COMPATIBILITY LAYER INSTALLATION ---
# Only relevant on Apple Silicon — skipped entirely on Intel.
# Within the arm64 block, only installs Rosetta if it isn't already present.
if [[ $(uname -m) == "arm64" ]]; then
    echo "🍎 Verifying Rosetta 2 status..."
    if /usr/bin/arch -x86_64 true &>/dev/null; then
        echo "🍎 Rosetta 2 is already present."
    else
        echo "🍎 Rosetta 2 not found. Proceeding with installation..."
        sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    fi
fi

# --- 7. SECURITY PERMISSION HANDLER ---
# Full Disk Access is required for nix-darwin to modify system files.
# The system TCC database is only readable by processes that have FDA granted,
# making it a direct and Terminal-specific probe (no Safari dependency).
_check_fda() {
    /usr/bin/sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "" &>/dev/null
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
# This includes *.before-nix backups left behind by a previous (partial) Nix
# install or a failed bootstrap run — nix-darwin treats those as conflicts too.
echo "🧹 Removing conflicting /etc files for nix-darwin..."
for f in \
    /etc/zshenv /etc/zshrc /etc/bashrc /etc/bash.bashrc \
    /etc/zshenv.before-nix /etc/zshrc.before-nix \
    /etc/bashrc.before-nix /etc/bash.bashrc.before-nix; do
    if [ -f "$f" ]; then
        echo "  🗑️  Removing $f"
        sudo rm -f "$f"
    fi
done

# --- 10. SYSTEM ACTIVATION ---
# Determinate Nix (arm64) enables nix-command + flakes by default.
# Vanilla Nix (x86_64) does not — and the nix.conf written above isn't picked
# up in the current shell session until a restart. Pass the features inline
# so this session can bootstrap without needing a restart first.
echo "❄️  Applying system configuration..."
if [[ $(uname -m) == "arm64" ]]; then
    sudo -H nix run nix-darwin -- switch --flake .#"$TARGET_HOSTNAME"
else
    sudo -H nix --extra-experimental-features 'nix-command flakes' \
        run nix-darwin -- switch --flake .#"$TARGET_HOSTNAME"
fi

echo "🔓 Removing quarantine flags from cask-installed apps..."
sudo xattr -dr com.apple.quarantine /Applications/ 2>/dev/null || true

echo "✅ System bootstrap complete! ❄️"
echo "👉 Please restart your terminal session to finalize all changes."
