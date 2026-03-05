#!/bin/bash

# Exit on any error or failed pipe segment
set -eo pipefail

trap 'echo "❌ Rebuild failed at line $LINENO. Check the output above for details." >&2' ERR

# --- PRIVILEGE CHECK ---
if [ "$(id -u)" -eq 0 ]; then
    echo "❌ Do not run this script as root or with sudo." >&2
    echo "   Run it as your regular user account: ./redeploy.sh" >&2
    exit 1
fi

# --- CONFIGURATION ---
FLAKE_DIR="$HOME/nix-darwin-config"
# Hostname-Argument optional: ./redeploy.sh iMac
# Ohne Argument: lokalen Hostnamen verwenden (muss Flake-Key matchen)
TARGET_CONFIG="${1:-$(/usr/sbin/scutil --get LocalHostName)}"

# --- AUTO-DETECTION ---
DETECTED_USER="$USER"
DETECTED_ARCH="$(uname -m)"

cd "$FLAKE_DIR" || exit 1

# Make new untracked files visible to the Nix evaluator without fully staging them
echo "🔍 Making new files visible to Nix..."
git add -N .

# Rebuild and switch — env vars are passed explicitly so flake.nix can read them
# darwin-rebuild uses the nix-darwin version pinned in flake.lock (unlike `nix run nix-darwin`)
echo "❄️  Rebuilding nix-darwin..."
echo "   Host: $TARGET_CONFIG | User: $DETECTED_USER | Arch: $DETECTED_ARCH"
sudo -H env NIXDARWIN_USER="$DETECTED_USER" NIXDARWIN_ARCH="$DETECTED_ARCH" \
  darwin-rebuild switch --flake .#"$TARGET_CONFIG" --impure

echo "🔓 Removing quarantine flags from cask-installed apps..."
sudo xattr -dr com.apple.quarantine /Applications/ 2>/dev/null || true

echo "✅ Rebuild successful!"
echo "ℹ️  Changes are active, but NOT committed. Use 'git commit' when ready."
