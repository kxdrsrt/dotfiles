{ ... }:
{
  # ── Intel MacBook Pro — host-specific settings ─────────────────────────────

  # ── Locale & Language ────────────────────────────────────────────────────────
  system.defaults.CustomUserPreferences."com.apple.systempreferences".NSLanguages = [ "de" ];
  system.defaults.CustomUserPreferences.".GlobalPreferences".AppleLanguages = [ "de-DE" ]; # German UI
  system.defaults.CustomUserPreferences.".GlobalPreferences".AppleLocale = "de_DE"; # German regional format

  # ── Keyboard Input Sources ───────────────────────────────────────────────────
  system.defaults.CustomUserPreferences."com.apple.HIToolbox".AppleEnabledInputSources = [
    {
      InputSourceKind = "Keyboard Layout";
      "KeyboardLayout ID" = 3;
      "KeyboardLayout Name" = "German";
    }
  ];

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
    "/System/Applications/TV.app"
    "/System/Applications/Music.app"
    "/System/Applications/App Store.app"
    "/System/Applications/Passwords.app"
    "/System/Applications/System Settings.app"
    "/Library/Application Support/Dortania/OpenCore-Patcher.app"
    "/Applications/Spotify.app"
    "/Applications/UPDF.app"
    "/Applications/3uTools.app"
  ];

  # ── Intel-specific Casks ─────────────────────────────────────────────────────
  homebrew.casks = [
  ];

  # ── Intel-specific MAS Apps ─────────────────────────────────────────────────
  homebrew.masApps = {
  };

  # ── Login Items ───────────────────────────────────────────────────────────────
  # Apps that appear in System Settings > General > Login Items.
  # Only touches apps in this list — manually added login items are left alone.
  system.activationScripts.loginItems = {
    text = ''
        MANAGED_APPS=(
          # "/Applications/Example.app"
        )

      # Fetch existing login items once (avoids repeated osascript calls)
      EXISTING_ITEMS=$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null || echo "")

      for app in "''${MANAGED_APPS[@]}"; do
        app_name=$(basename "$app" .app)
        if [ -d "$app" ]; then
          if ! echo "$EXISTING_ITEMS" | grep -q "$app_name"; then
            osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app\", hidden:false}" 2>/dev/null || true
            echo "Added login item: $app_name"
          fi
        else
          # App not installed — ensure its login item is removed
          osascript -e "tell application \"System Events\" to delete login item \"$app_name\"" 2>/dev/null || true
        fi
      done
    '';
    deps = [ "homebrew" ];
  };
}
