{ ... }: {
  # ============================================================================
  # Login Items Configuration
  # ============================================================================
  # Note: macOS Login Items vs LaunchAgents:
  # - Login Items: Apps that appear in System Settings > General > Login Items
  # - LaunchAgents: Background services managed by launchd
  # This file manages login items declaratively using activation scripts
  
  system.activationScripts.loginItems.text = ''
    # Function to add login item if not already present
    add_login_item() {
      local app_path="$1"
      local app_name=$(basename "$app_path" .app)
      
      # Check if item already exists
      if ! osascript -e "tell application \"System Events\" to get the name of every login item" | grep -q "$app_name"; then
        osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app_path\", hidden:false}" 2>/dev/null || true
        echo "Added login item: $app_name"
      fi
    }
    
    # Remove all existing login items first for clean state
    osascript -e 'tell application "System Events" to delete every login item' 2>/dev/null || true
    
    # Add login items in order
    add_login_item "/Applications/Alcove.app"
    add_login_item "/Applications/AltServer.app"
    add_login_item "/Applications/BetterDisplay.app"
    add_login_item "/Applications/Mos.app"
    add_login_item "/Applications/Raycast.app"
    add_login_item "/Applications/Rectangle.app"
    add_login_item "/Applications/Reflex.app"
    add_login_item "/Applications/Shottr.app"
  '';
}
