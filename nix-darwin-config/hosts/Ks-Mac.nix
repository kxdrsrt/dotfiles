{ lib, ... }:
{
  # ── Apple Silicon MacBook — host-specific settings ─────────────────────────

  # ── Login Window ─────────────────────────────────────────────────────────────
  system.defaults.loginwindow.LoginwindowText = lib.mkForce "🅺's Mac";

  # ── Locale & Language ────────────────────────────────────────────────────────
  system.defaults.CustomUserPreferences."com.apple.systempreferences".NSLanguages = [ "en" ];
  system.defaults.CustomUserPreferences.".GlobalPreferences".AppleLanguages = [ "en-US" ]; # English UI
  system.defaults.CustomUserPreferences.".GlobalPreferences".AppleLocale = "en_DE"; # German regional format (metric, dates, numbers)

  # ── Keyboard Input Sources ───────────────────────────────────────────────────
  system.defaults.CustomUserPreferences."com.apple.HIToolbox".AppleEnabledInputSources = [
    {
      InputSourceKind = "Keyboard Layout";
      "KeyboardLayout ID" = 3;
      "KeyboardLayout Name" = "German";
    }
    {
      InputSourceKind = "Keyboard Layout";
      "KeyboardLayout ID" = 0;
      "KeyboardLayout Name" = "U.S.";
    }
  ];

  # ── Dock ─────────────────────────────────────────────────────────────────────
  system.defaults.dock.persistent-apps = [
    "/System/Applications/Mail.app"
    "/Applications/Dia.app"
    "/Applications/WhatsApp.app"
    "/System/Applications/Photos.app"
    "/System/Applications/Notes.app"
    "/System/Applications/Reminders.app"
    "/Applications/Microsoft OneNote.app"
    "/Applications/Notion.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Passwords.app"
    "/Applications/Spotify.app"
    "/System/Applications/System Settings.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Obsidian.app"
    "/System/Applications/Utilities/Terminal.app"
  ];

  # ── ARM-specific Casks ──────────────────────────────────────────────────────
  homebrew.casks = [
    #"alcove" # Dynamic Island for macOS
    "antigravity" # Google Antigravity AI Coding Agent IDE
    "calibre" # E-book library management
    "claude" # AI assistant by Anthropic
    "claude-code" # AI-powered code assistant
    "conductor" # AI-powered file manager
    "cursor" # Code editor with AI assistance
    "discord" # Voice, video, and text chat
    "figma" # Vector graphics editor
    "imageoptim" # Image optimization tool
    "karabiner-elements" # Keyboard customization tool
    "kiro" # Amazon AI IDE
    "lg-onscreen-control" # LG display management
    "microsoft-edge" # Microsoft's Chromium browser
    "microsoft-teams" # Communication platform
    "moonlight" # NVIDIA GameStream client
    "netnewswire" # RSS reader
    "notion" # All-in-one workspace
    "notion-calendar" # Calendar companion for Notion
    "nvidia-geforce-now" # Cloud gaming service
    "obsidian" # Knowledge base and note-taking app
    "protonvpn" # ProtonVPN client
    "tailscale-app" # VPN and zero-config networking
    "reflex-app" # Universal Music Control
    "telegram" # Messaging app
    "thebrowsercompany-dia" # The Browser Company's Dia
    "warp" # Modern AI-powered terminal
  ];

  # ── ARM-specific MAS Apps ───────────────────────────────────────────────────
  homebrew.masApps = {
    "Apple Configurator" = 1037126344; # iOS device manager
    "Brother iPrint&Scan" = 1193539993; # Brother printer app
    "Equinox" = 1591510203; # Dynamic wallpapers
    "finanzblick" = 993109868; # Banking app
    "Flow" = 1423210932; # Pomodoro timer
    "Goodnotes" = 1444383602; # Note-taking app
    "Microsoft OneNote" = 784801555; # Note-taking
    "Shazam" = 897118787; # Music identifier
    "Video Converter" = 1518836004; # Video converter
    "LG Screen Manager" = 1142051783; # LG display management App
    "Windows App" = 1295203466; # Remote Desktop / RDP
  };

  # ── Login Items ───────────────────────────────────────────────────────────
  # Apps that appear in System Settings > General > Login Items.
  # Only touches apps in this list — manually added login items are left alone.
  system.activationScripts.loginItems = {
    text = ''
        MANAGED_APPS=(
          "/Applications/BetterDisplay.app"
          "/Applications/Mos.app"
          "/Applications/Raycast.app"
          "/Applications/Rectangle.app"
          "/Applications/Reflex.app"
          "/Applications/Shottr.app"
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
