#!/bin/bash

set -e

cd "$HOME" || exit 1

echo "🔄 Initializing dotfiles repository..."
git init
git remote add origin https://github.com/kxdrsrt/dotfiles.git
git fetch
git checkout -f main

echo "🔄 Rebuilding nix-darwin configuration..."
cd "$HOME/nix-darwin-config" || exit 1
darwin-rebuild switch --flake .

echo "✅ Bootstrap successful! ❄️"
