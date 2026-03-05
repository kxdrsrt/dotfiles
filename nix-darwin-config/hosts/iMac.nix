{ ... }:
{
  # ── Intel iMac — host-specific settings ────────────────────────────────────

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
    "/Applications/iMazing.app"
  ];

  # ── Intel-specific Casks ─────────────────────────────────────────────────────
  homebrew.casks = [
  ];

  # ── Intel-specific MAS Apps ─────────────────────────────────────────────────
  homebrew.masApps = {
  };

}
