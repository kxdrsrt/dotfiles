{ ... }:

{
  # Messages app preferences
  system.defaults.CustomUserPreferences = {
    "com.apple.messages" = {
      # Update & Auto-check
      SUEnableAutomaticChecks = false; # Disable auto-update checks
    };

    # Messages text input helper
    "com.apple.messageshelper.MessageController" = {
      SOInputLineSettings = {
        automaticQuoteSubstitutionEnabled = false;
        continuousSpellCheckingEnabled = false;
      };
    };
  };
}
