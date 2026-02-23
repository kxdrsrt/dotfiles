{ ... }:

{
  # App Store preferences
  system.defaults.CustomUserPreferences = {
    "com.apple.appstore" = {
      # Debug & Developer
      ShowDebugMenu = true;                      # Show debug menu
      WebKitDeveloperExtras = true;              # Enable web inspector
    };

    # App Store automatic updates (Commerce)
    "com.apple.commerce" = {
      AutoUpdate = true;                         # Turn on app auto-update
    };
  };
}

