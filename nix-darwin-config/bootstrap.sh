#!/bin/bash

# Ensure macOS system tools are in PATH (sh/bash may not include /usr/sbin).
# diskutil, scutil, softwareupdate, launchctl etc. all live in /usr/sbin.
export PATH="/usr/sbin:/usr/bin:/bin:/sbin:$PATH"

# Terminate execution if any command or pipe segment fails
set -eo pipefail

trap 'echo "❌ Bootstrap failed at line $LINENO. Check the output above for details." >&2' ERR

# --- 0. PRIVILEGE CHECK ---
# Must run as a normal user — sudo escalates internally where needed.
if [ "$(id -u)" -eq 0 ]; then
    echo "❌ Do not run this script as root or with sudo." >&2
    echo "   Run it as your regular user account: ./bootstrap.sh" >&2
    exit 1
fi

# --- 1. GLOBAL CONFIGURATION ---
# Pass hostname as first argument: ./bootstrap.sh iMac
# Without argument: script presents a numbered menu of available host profiles
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "$1" ]; then
    TARGET_HOSTNAME="$1"
else
    # Build list of hosts from hosts/*.nix filenames (strip path + extension)
    # The hosts/ dir only exists after the repo is cloned (step 4), so we fall
    # back to a plain prompt when running on a fresh machine.
    HOST_LIST=()
    if [ -d "$SCRIPT_DIR/hosts" ]; then
        for f in "$SCRIPT_DIR/hosts/"*.nix; do
            [ -f "$f" ] && HOST_LIST+=("$(basename "$f" .nix)")
        done
    fi

    if [ "${#HOST_LIST[@]}" -gt 0 ]; then
        echo ""
        echo "Available host profiles:"
        for i in "${!HOST_LIST[@]}"; do
            printf "  %d) %s\n" "$((i+1))" "${HOST_LIST[$i]}"
        done
        echo ""
        read -rp "Select a host [1-${#HOST_LIST[@]}]: " HOST_CHOICE

        if ! [[ "$HOST_CHOICE" =~ ^[0-9]+$ ]] || \
           [ "$HOST_CHOICE" -lt 1 ] || [ "$HOST_CHOICE" -gt "${#HOST_LIST[@]}" ]; then
            echo "❌ Invalid selection." >&2; exit 1
        fi

        TARGET_HOSTNAME="${HOST_LIST[$((HOST_CHOICE-1))]}"
        echo "→ Selected: $TARGET_HOSTNAME"
        echo ""
    else
        # Repo not yet present — ask for the hostname as plain text
        read -rp "Enter target hostname (e.g. Ks-Mac, iMac, MacBookPro): " TARGET_HOSTNAME
        [ -z "$TARGET_HOSTNAME" ] && { echo "❌ No hostname provided." >&2; exit 1; }
    fi
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

# Source the Nix environment before the detection check: a previous (partial)
# bootstrap run may have installed Nix without it being in PATH yet.
# Doing this first prevents re-running the installer on every retry.
_NIX_DAEMON_PROFILE='/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
if [ -e "$_NIX_DAEMON_PROFILE" ]; then
    # shellcheck source=/dev/null
    . "$_NIX_DAEMON_PROFILE"
fi

if ! command -v nix &>/dev/null; then
    if [[ $(uname -m) == "arm64" ]]; then
        echo "❄️  Nix not found (Apple Silicon). Installing via Determinate Systems..."
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
            sh -s -- install --no-confirm
    else
        echo "❄️  Nix not found (Intel). Installing via official upstream installer..."
        # Nix 2.25+ requires macOS 14 (Sonoma). Pin to the last version that
        # supports Ventura (13) and older for OCLP / older hardware.
        MACOS_MAJOR=$(sw_vers -productVersion | cut -d. -f1)
        if [[ "$MACOS_MAJOR" -le 13 ]]; then
            echo "   macOS $MACOS_MAJOR detected — pinning to Nix 2.24.10 (last Ventura-compatible release)"
            NIX_INSTALL_URL="https://releases.nixos.org/nix/nix-2.24.10/install"
        else
            NIX_INSTALL_URL="https://nixos.org/nix/install"
        fi
        # Multi-user install — required for nix-darwin
        #
        # Intel pre-flight: remove any stale Nix LaunchDaemon / APFS volume
        # state that causes "Bootstrap failed: 5: Input/output error" for
        # org.nixos.darwin-store on reinstalls (even after nuke-nix.sh).
        echo "🧹 Intel pre-flight: clearing stale Nix installation state..."

        # 1. Evict any lingering launchd service entries (clears the in-memory
        #    database even when plists have already been deleted).
        sudo launchctl bootout system/org.nixos.darwin-store 2>/dev/null || true
        sudo launchctl bootout system/org.nixos.nix-daemon   2>/dev/null || true
        sudo launchctl unload -w /Library/LaunchDaemons/org.nixos.darwin-store.plist 2>/dev/null || true
        sudo launchctl unload -w /Library/LaunchDaemons/org.nixos.nix-daemon.plist   2>/dev/null || true
        sudo rm -f /Library/LaunchDaemons/org.nixos.darwin-store.plist
        sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist

        # 2. Delete any leftover Nix APFS volume (a stale volume is the most
        #    common reason the installer fails with EIO on the darwin-store step).
        _PREFLIGHT_NIX_VOL=$(diskutil list | awk '/Nix Store/ {print $NF}')
        if [ -n "$_PREFLIGHT_NIX_VOL" ]; then
            echo "   Found stale Nix volume: $_PREFLIGHT_NIX_VOL — removing..."
            sudo diskutil unmount force "$_PREFLIGHT_NIX_VOL" 2>/dev/null || true
            if sudo diskutil apfs deleteVolume "$_PREFLIGHT_NIX_VOL" 2>/dev/null; then
                echo "   Volume removed."
            else
                echo "❌ Could not delete Nix APFS volume $_PREFLIGHT_NIX_VOL." >&2
                echo "   Please reboot and run bootstrap.sh again." >&2
                exit 1
            fi
        fi

        # 3. Remove stale /etc/fstab Nix entries.
        sudo sed -i '.bak' '/[Nn]ix/d' /private/etc/fstab 2>/dev/null || true

        # 4. Ensure the /nix firmlink exists — synthetic.conf entry + apply
        #    without reboot via apfs.util.  Without this the installer's
        #    darwin-store LaunchDaemon can fail to mount at boot time.
        if ! grep -q '^nix' /private/etc/synthetic.conf 2>/dev/null; then
            printf 'nix\n' | sudo tee -a /private/etc/synthetic.conf >/dev/null
        fi
        sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t 2>/dev/null || true
        sleep 1  # allow firmlink to materialise

        # The official Nix installer has a known macOS reinstall bug:
        # its cleanup phase (when it finds a previous install) removes
        # /etc/nix, then later tries to `install` nix.conf into it — and
        # fails.  Even on a clean install, race conditions can occur.
        #
        # Fix: pre-create /etc/nix/nix.conf with the content the installer
        # would write, then lock the directory with macOS's immutable flag
        # so the installer's cleanup can't delete it.  Unlock after.
        sudo mkdir -p /private/etc/nix
        printf 'build-users-group = nixbld\n' | sudo tee /private/etc/nix/nix.conf >/dev/null
        sudo chflags schg /private/etc/nix

        # Download installer to a file instead of piping through sh.
        # Piped execution (curl | sh) steals stdin/TTY from the installer,
        # which causes subtle failures in its cleanup and setup phases.
        NIX_INSTALL_SCRIPT="$(mktemp)"
        curl --proto '=https' --tlsv1.2 -sSf -L "$NIX_INSTALL_URL" -o "$NIX_INSTALL_SCRIPT"
        NIX_INSTALL_RESULT=0
        sh "$NIX_INSTALL_SCRIPT" --daemon --yes || NIX_INSTALL_RESULT=$?
        rm -f "$NIX_INSTALL_SCRIPT"

        # Unlock the directory now that the installer is done
        sudo chflags noschg /private/etc/nix

        if [ "$NIX_INSTALL_RESULT" -ne 0 ]; then
            echo "⚠️  Nix installer exited non-zero ($NIX_INSTALL_RESULT) — checking state..."
            # Even with the lock, the installer may fail for other reasons.
            # Check whether the essential pieces landed.
            if [ -d /nix/store ] && [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
                echo "   /nix/store and daemon profile present — install likely succeeded despite error."
                # Ensure nix.conf is correct
                printf 'build-users-group = nixbld\n' | sudo tee /private/etc/nix/nix.conf >/dev/null
                echo "✅ Recovery successful."
            else
                echo "❌ Nix installation incomplete. Dumping state for debugging:" >&2
                echo "   /nix/store exists: $([ -d /nix/store ] && echo yes || echo NO)" >&2
                echo "   /nix mount: $(/sbin/mount | grep '/nix' || echo 'not mounted')" >&2
                echo "   /etc/nix/nix.conf exists: $([ -f /etc/nix/nix.conf ] && echo yes || echo NO)" >&2
                exit 1
            fi
        fi
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

# Ensure /etc/nix/nix.conf exists — it may be absent after a partial install
# (the upstream installer has a known macOS reinstall bug: its cleanup phase
# removes /etc/nix, then fails to recreate nix.conf). The daemon and
# nix-darwin both require it.
if [ ! -f /private/etc/nix/nix.conf ] && [ ! -f /etc/nix/nix.conf ]; then
    echo "   Ensuring /etc/nix/nix.conf exists..."
    # Use sudo install -d (more reliable than mkdir -p via sudo sh -c on macOS)
    sudo install -d -m 755 /private/etc/nix
    # Use tee to write as root — avoids shell-redirect permission issues
    printf 'build-users-group = nixbld\n' | sudo tee /private/etc/nix/nix.conf >/dev/null
    if [ -f /private/etc/nix/nix.conf ]; then
        echo "   Created /etc/nix/nix.conf"
    else
        echo "❌ Failed to create /etc/nix/nix.conf — filesystem state:" >&2
        ls -la /private/etc/nix 2>&1 >&2 || echo "   directory not found" >&2
        echo "   If this system has a partial Nix install, run: sh nuke-nix.sh" >&2
        exit 1
    fi
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
# Env vars feed the flake's builtins.getEnv calls (requires --impure).
DETECTED_USER="$USER"
DETECTED_ARCH="$(uname -m)"
echo "❄️  Applying system configuration..."
echo "   Host: $TARGET_HOSTNAME | User: $DETECTED_USER | Arch: $DETECTED_ARCH"

# Determinate Nix (arm64) enables nix-command + flakes by default.
# Vanilla Nix (x86_64) does not — pass the features inline so this
# session can bootstrap without needing a restart first.
if [[ $(uname -m) == "arm64" ]]; then
    sudo -H env NIXDARWIN_USER="$DETECTED_USER" NIXDARWIN_ARCH="$DETECTED_ARCH" \
        nix run nix-darwin -- switch --flake .#"$TARGET_HOSTNAME" --impure
else
    # Intel: `nix run nix-darwin` fetches a nix-darwin binary whose closure
    # contains nix libs compiled for macOS 14+ — these crash on Ventura (13).
    # Instead: build the system derivation with the installed nix (2.24.x),
    # then call activate directly. darwin-rebuild is available afterwards.

    # Ensure the nix daemon is running — it may not have started yet after a
    # fresh install in the same session.
    echo "❄️  Starting nix daemon..."
    sudo launchctl load -w /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
    sleep 3

    echo "❄️  Building system derivation (Intel / Ventura-compatible path)..."
    sudo -H env NIXDARWIN_USER="$DETECTED_USER" NIXDARWIN_ARCH="$DETECTED_ARCH" \
        nix --extra-experimental-features 'nix-command flakes' \
        build ".#darwinConfigurations.$TARGET_HOSTNAME.system" \
        --impure --out-link /tmp/nix-darwin-first-boot
    echo "❄️  Activating system configuration..."
    sudo -H env NIXDARWIN_USER="$DETECTED_USER" NIXDARWIN_ARCH="$DETECTED_ARCH" \
        /tmp/nix-darwin-first-boot/activate
fi

echo "🔓 Removing quarantine flags from cask-installed apps..."
sudo xattr -dr com.apple.quarantine /Applications/ 2>/dev/null || true

echo "✅ System bootstrap complete! ❄️"
echo "👉 Please restart your terminal session to finalize all changes."
