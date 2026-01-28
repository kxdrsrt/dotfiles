{ config, pkgs, ... }:

{
  # Reflex app preferences
  system.defaults.CustomUserPreferences = {
    "com.reflexapp.Reflex" = {
      # Add Reflex-specific settings here
    };
  };
}
