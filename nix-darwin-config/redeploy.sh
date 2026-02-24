#!/bin/bash

# Exit on any error or failed pipe segment
set -eo pipefail

trap 'echo "❌ Rebuild failed at line $LINENO. Check the output above for details." >&2' ERR

# --- CONFIGURATION ---
FLAKE_DIR="$HOME/nix-darwin-config"
TARGET_CONFIG="Ks-Mac"

cd "$FLAKE_DIR" || exit 1

# Make new untracked files visible to the Nix evaluator without fully staging them
echo "🔍 Making new files visible to Nix..."
git add -N .

# Rebuild and switch — Determinate Nix enables nix-command + flakes by default
echo "❄️  Rebuilding nix-darwin..."
sudo -H nix run nix-darwin -- switch --flake .#"$TARGET_CONFIG"

echo "🔓 Removing quarantine flags from cask-installed apps..."
sudo xattr -dr com.apple.quarantine /Applications/ 2>/dev/null || true

echo "✅ Rebuild successful!"
echo "ℹ️  Changes are active, but NOT committed. Use 'git commit' when ready."
