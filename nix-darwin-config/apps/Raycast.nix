{ user, ... }:

{
  system.activationScripts.raycastConfig.text = ''
    # Set Raycast global hotkey to Cmd+Space natively via plist (takes effect before first launch)
    sudo -u ${user} defaults write com.raycast.macos raycastGlobalHotkey "Command-49"

    # Copy .rayconfig export for manual import of extensions, aliases, quicklinks, etc.
    # Import via: Raycast → Settings → Advanced → Import Settings & Data
    # Source: ~/.config/raycast/K.rayconfig (tracked in dotfiles git repo)
    RAYCAST_DIR="/Users/${user}/Library/Application Support/com.raycast.macos"
    sudo -u ${user} mkdir -p "$RAYCAST_DIR"
    if [ -f "/Users/${user}/.config/raycast/K.rayconfig" ]; then
      /bin/cp "/Users/${user}/.config/raycast/K.rayconfig" "$RAYCAST_DIR/raycast.rayconfig"
      chown ${user} "$RAYCAST_DIR/raycast.rayconfig"
    fi
  '';
}
