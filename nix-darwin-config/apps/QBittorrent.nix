{ ... }:

{
  # qBittorrent app preferences
  system.defaults.CustomUserPreferences = {
    "org.qbittorrent.qBittorrent" = {
      # Add qBittorrent-specific settings here
    };
  };

  # Auto-install latest qBittorrent on every darwin-rebuild.
  # Homebrew cask disabled 2026-09-01 (unsigned, fails Gatekeeper check).
  # Downloads the official DMG from SourceForge and installs to /Applications.
  system.activationScripts.installQbittorrent.text = ''
    INSTALLED=$(defaults read /Applications/qBittorrent.app/Contents/Info CFBundleShortVersionString 2>/dev/null || true)
    LATEST=$(curl -fsSL "https://api.github.com/repos/qbittorrent/qBittorrent/releases/latest" \
      | grep '"tag_name"' \
      | sed 's/.*"release-\([^"]*\)".*/\1/' \
      || true)

    if [ -z "$LATEST" ]; then
      echo "qBittorrent: could not fetch latest version, skipping" >&2
    elif [ "$INSTALLED" = "$LATEST" ]; then
      echo "qBittorrent $LATEST already up to date"
    else
      echo "Installing qBittorrent $LATEST (currently: $INSTALLED)..."
      DMG=$(mktemp /tmp/qbittorrent.XXXXXX.dmg)
      URL="https://downloads.sourceforge.net/qbittorrent/qbittorrent-mac/qbittorrent-$LATEST/qbittorrent-$LATEST.dmg"
      if curl -fsSL "$URL" -o "$DMG"; then
        VOLUME=$(hdiutil attach -nobrowse "$DMG" | awk '/\/Volumes/ {print $NF; exit}')
        rm -rf /Applications/qBittorrent.app
        cp -R "$VOLUME/qbittorrent.app" /Applications/qBittorrent.app
        hdiutil detach "$VOLUME" -quiet
        rm -f "$DMG"
        echo "qBittorrent $LATEST installed successfully"
      else
        rm -f "$DMG"
        echo "qBittorrent: download failed, skipping" >&2
      fi
    fi
  '';
}
