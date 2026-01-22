#!/bin/bash

set -e

FLAKE_DIR="$HOME/nix-darwin-config"
cd "$FLAKE_DIR" || exit 1

echo "🔄 Rebuilding nix-darwin configuration..."
darwin-rebuild switch --flake .

echo "✅ Rebuild successful! ❄️"
