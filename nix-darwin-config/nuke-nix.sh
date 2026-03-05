#!/bin/bash
# nuke-nix.sh — Completely removes Nix from macOS for a clean bootstrap.
# Run as your regular user (sudo is invoked internally).
# After running: REBOOT, then run:  sh bootstrap.sh

if [ "$(id -u)" -eq 0 ]; then
    echo "❌ Do not run as root. Run as your regular user: sh nuke-nix.sh" >&2
    exit 1
fi

echo ""
echo "⚠️  This will completely remove Nix, all build users, and the Nix volume."
echo "   You must REBOOT after this before running bootstrap.sh again."
echo ""
read -rp "Continue? [y/N] " CONFIRM
case "$CONFIRM" in [Yy]) ;; *) echo "Aborted."; exit 0 ;; esac
echo ""

sudo -v

# ── 1. Stop and remove Nix daemon ────────────────────────────────────────────
echo "⏹  Stopping nix-daemon..."
sudo launchctl bootout system/org.nixos.nix-daemon 2>/dev/null || true
sudo launchctl unload -w /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
sudo launchctl unload -w /Library/LaunchDaemons/org.nixos.darwin-store.plist 2>/dev/null || true
echo "🗑️  Removing LaunchDaemon plists..."
sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm -f /Library/LaunchDaemons/org.nixos.darwin-store.plist

# ── 2. Remove Nix APFS volume ────────────────────────────────────────────────
echo "🗑️  Removing Nix APFS volume..."
NIX_DISK=$(diskutil list | awk '/Nix Store/ {print $NF}')
if [ -n "$NIX_DISK" ]; then
    echo "   Found Nix volume: $NIX_DISK"
    sudo diskutil unmount force "$NIX_DISK" 2>/dev/null || true
    sudo diskutil apfs deleteVolume "$NIX_DISK" 2>/dev/null \
        && echo "   Volume $NIX_DISK deleted." \
        || echo "   ⚠️  Could not delete volume now — reboot will clean it up."
else
    echo "   No Nix volume found."
fi

# ── 3. Clean /etc/fstab ───────────────────────────────────────────────────────
echo "🗑️  Cleaning /etc/fstab..."
if grep -q -i 'nix' /etc/fstab 2>/dev/null; then
    sudo sed -i '.bak' '/[Nn]ix/d' /etc/fstab
fi

# ── 4. Clean /etc/synthetic.conf ─────────────────────────────────────────────
echo "🗑️  Cleaning /etc/synthetic.conf..."
if grep -q '^nix$' /etc/synthetic.conf 2>/dev/null; then
    sudo sed -i '.bak' '/^nix$/d' /etc/synthetic.conf
fi

# ── 5. Clean shell profile snippets ──────────────────────────────────────────
echo "🗑️  Cleaning shell profiles..."
for f in /etc/bashrc /etc/zshrc /etc/zshenv /etc/bash.bashrc /etc/profile \
          /etc/zsh/zshrc /etc/zsh/zshenv; do
    [ -f "$f" ] || continue
    # Remove the Nix block (multi-line)
    sudo perl -i -0pe 's/\n?# Nix\nif \[ -e[^\n]+nix-daemon\.sh[^\n]+\n[^\n]+\nfi\n# End Nix//g' "$f" 2>/dev/null || true
    # Remove backup files left by the installer
    sudo rm -f "${f}.before-nix" "${f}.backup-before-nix" 2>/dev/null || true
done
# Fish
for f in /etc/fish/conf.d/nix.fish /usr/local/etc/fish/conf.d/nix.fish \
          /opt/homebrew/etc/fish/conf.d/nix.fish /opt/local/etc/fish/conf.d/nix.fish; do
    sudo rm -f "$f" 2>/dev/null || true
done

# ── 6. Remove /etc/nix ───────────────────────────────────────────────────────
echo "🗑️  Removing /etc/nix..."
sudo rm -rf /private/etc/nix 2>/dev/null || true

# ── 7. Remove build users and group ──────────────────────────────────────────
echo "🗑️  Removing nix build users..."
for i in $(seq 1 32); do
    sudo dscl . -delete "/Users/_nixbld${i}" 2>/dev/null || true
done
sudo dscl . -delete /Groups/nixbld 2>/dev/null || true

# ── 8. Remove root's nix state ───────────────────────────────────────────────
echo "🗑️  Removing root nix state..."
sudo rm -rf /var/root/.nix-profile /var/root/.nix-channels /var/root/.nix-defexpr \
            /var/root/.local/state/nix 2>/dev/null || true

# ── 9. Remove per-user nix files ─────────────────────────────────────────────
echo "🗑️  Removing user nix files..."
for HOME_DIR in /Users/*/; do
    rm -rf "${HOME_DIR}.nix-profile" "${HOME_DIR}.nix-channels" \
           "${HOME_DIR}.nix-defexpr" "${HOME_DIR}.config/nix" \
           "${HOME_DIR}.local/state/nix" 2>/dev/null || true
done

# ── 10. Remove /nix contents (mount point; volume deleted above) ──────────────
# /nix itself is a synthetic firmlink — macOS will remove it after reboot
# once the /etc/synthetic.conf entry is gone. Contents may already be gone
# since the volume was unmounted.
echo "🗑️  Clearing any remaining /nix contents..."
sudo rm -rf /nix 2>/dev/null || true

echo ""
echo "✅ Nix has been removed from this system."
echo ""
echo "👉 REBOOT NOW, then run:  sh ~/nix-darwin-config/bootstrap.sh"
echo ""
