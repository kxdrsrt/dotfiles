{ user, ... }:

{
  # Jackett — proxy server that translates qBittorrent search queries to
  # tracker-specific HTTP requests, supporting 500+ indexers.
  # Web UI + API on http://127.0.0.1:9117 (start via: brew services start jackett)

  # Install the qBittorrent Jackett search plugin and write jackett.json.
  # Activation script auto-reads Jackett's generated API key from its own
  # ServerConfig.json, so you don't need to copy it manually after a rebuild.
  #
  # First-time setup:
  #   1. brew services start jackett
  #   2. Open http://127.0.0.1:9117 → add your preferred indexers
  #   3. nixre  (rebuild — this script will pick up the API key automatically)
  system.activationScripts.installJackettPlugin.text = ''
    ENGINES_DIR="/Users/${user}/Library/Application Support/qBittorrent/nova3/engines"
    PLUGIN_URL="https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/jackett.py"
    PLUGIN_FILE="$ENGINES_DIR/jackett.py"
    CONFIG_FILE="$ENGINES_DIR/jackett.json"
    JACKETT_CFG="/Users/${user}/.config/Jackett/ServerConfig.json"

    sudo -u ${user} mkdir -p "$ENGINES_DIR"

    # Download / update the plugin file
    if sudo -u ${user} curl -fsSL "$PLUGIN_URL" -o "$PLUGIN_FILE.tmp" 2>/dev/null; then
      mv "$PLUGIN_FILE.tmp" "$PLUGIN_FILE"
      chown ${user} "$PLUGIN_FILE"
      echo "Jackett: qBittorrent search plugin installed/updated"
    else
      echo "Jackett: plugin download failed (no internet?), skipping" >&2
    fi

    # Write jackett.json only if it doesn't already exist (preserve user edits)
    if [ ! -f "$CONFIG_FILE" ]; then
      # Try to read the auto-generated API key from Jackett's own config
      API_KEY="YOUR_API_KEY_HERE"
      if [ -f "$JACKETT_CFG" ]; then
        FOUND=$(grep -o '"APIKey":"[^"]*"' "$JACKETT_CFG" 2>/dev/null | cut -d'"' -f4 || true)
        [ -n "$FOUND" ] && API_KEY="$FOUND"
      fi

      sudo -u ${user} tee "$CONFIG_FILE" > /dev/null <<EOF
{
  "api_key": "$API_KEY",
  "url": "http://127.0.0.1:9117",
  "tracker_first": false,
  "thread_count": 20
}
EOF
      chown ${user} "$CONFIG_FILE"

      if [ "$API_KEY" = "YOUR_API_KEY_HERE" ]; then
        echo "Jackett: jackett.json created — start Jackett, then run nixre to populate the API key"
      else
        echo "Jackett: jackett.json created with API key from Jackett config"
      fi
    else
      echo "Jackett: jackett.json already exists, skipping (edit manually if needed)"
    fi
  '';
}
