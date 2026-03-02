{ pkgs, ... }:
{
  # ── Apple Silicon MacBook — host-specific settings ─────────────────────────

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
    "/Applications/Warp.app"
  ];

  # ── ARM-specific Casks ──────────────────────────────────────────────────────
  homebrew.casks = [
    "calibre" # E-book library management
    "claude-code" # AI-powered code assistant
    "conductor" # AI-powered file manager
    "cursor" # Code editor with AI assistance
    "discord" # Voice, video, and text chat
    "figma" # Vector graphics editor
    "imageoptim" # Image optimization tool
    "karabiner-elements" # Keyboard customization tool
    "kiro" # Amazon AI IDE
    "microsoft-edge" # Microsoft's Chromium browser
    "microsoft-teams" # Communication platform
    "netnewswire" # RSS reader
    "notion" # All-in-one workspace
    "nvidia-geforce-now" # Cloud gaming service
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
    "Windows App" = 1295203466; # Remote Desktop / RDP
  };

  # ── ARM-specific Nix packages ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
  ];

  # ── Login Items ───────────────────────────────────────────────────────────
  # Apps that appear in System Settings > General > Login Items.
  # Only touches apps in this list — manually added login items are left alone.
  system.activationScripts.loginItems.text = ''
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
