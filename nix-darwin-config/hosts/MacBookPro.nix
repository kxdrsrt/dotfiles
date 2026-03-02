{ pkgs, ... }:
{
  # ── Intel MacBook Pro — host-specific settings ─────────────────────────────

  # ── Dock ────────────────────────────────────────────────────────────────
  system.defaults.dock.persistent-apps = [
    "/System/Applications/Launchpad.app"
    "/Applications/WhatsApp.app"
    "/System/Applications/Mail.app"
    "/System/Applications/Maps.app"
    "/System/Applications/Photos.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Reminders.app"
    "/System/Applications/Notes.app"
    "/System/Applications/Freeform.app"
    "/System/Applications/Apple TV.app"
    "/System/Applications/Music.app"
    "/System/Applications/App Store.app"
    "/System/Applications/Passwords.app"
    "/System/Applications/System Settings.app"
    "/Applications/Spotify.app"
    "/System/Applications/OpenCore Patcher.app"
    "/Applications/UPDF.app"
  ];

  # ── Intel-specific Casks ─────────────────────────────────────────────────────
  homebrew.casks = [
  ];

  # ── Intel-specific MAS Apps ─────────────────────────────────────────────────
  homebrew.masApps = {
  };

  # ── Intel-specific Nix packages ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
  ];

  # ── Login Items ───────────────────────────────────────────────────────────────
  # Apps that appear in System Settings > General > Login Items.
  # Only touches apps in this list — manually added login items are left alone.
  system.activationScripts.loginItems.text = ''
    MANAGED_APPS=(
      # "/Applications/Example.app"
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
