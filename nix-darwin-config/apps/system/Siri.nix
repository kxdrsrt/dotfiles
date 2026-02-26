{ ... }:

{
  # Siri preferences
  system.defaults.CustomUserPreferences = {
    # Siri Analytics
    "com.apple.assistant.backedup" = {
      "Siri Data Sharing Opt-In Status" = 2; # Opt out of Siri analytics
    };

    # Siri Assistant
    "com.apple.assistant.support" = {
      "Assistant Enabled" = false; # Disable Siri
    };
  };
}
