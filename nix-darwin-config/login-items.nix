{ ... }:
{
  # ============================================================================
  # Login Items Configuration
  # ============================================================================
  # Note: macOS Login Items vs LaunchAgents:
  # - Login Items: Apps that appear in System Settings > General > Login Items
  # - LaunchAgents: Background services managed by launchd
  # This file manages login items declaratively using activation scripts

  system.activationScripts.loginItems.text = ''
    # Declaratively managed login items.
    # Only touches apps in this list — manually added login items are left alone.
    MANAGED_APPS=(
      "/Applications/Alcove.app"
      "/Applications/AltServer.app"
      "/Applications/BetterDisplay.app"
      "/Applications/Mos.app"
      "/Applications/Raycast.app"
      "/Applications/Rectangle.app"
      "/Applications/Reflex.app"
      "/Applications/Shottr.app"
    )

    add_login_item() {
      local app_path="$1"
      local app_name=$(basename "$app_path" .app)
      if ! osascript -e "tell application \"System Events\" to get the name of every login item" | grep -q "$app_name"; then
        osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app_path\", hidden:false}" 2>/dev/null || true
        echo "Added login item: $app_name"
      fi
    }

    remove_login_item() {
      local app_name=$(basename "$1" .app)
      osascript -e "tell application \"System Events\" to delete login item \"$app_name\"" 2>/dev/null || true
    }

    for app in "''${MANAGED_APPS[@]}"; do
      if [ -d "$app" ]; then
        add_login_item "$app"
      else
        # App not installed — ensure its login item is removed
        remove_login_item "$app"
      fi
    done
  '';
}
