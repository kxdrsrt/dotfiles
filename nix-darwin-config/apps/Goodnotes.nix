{ config, pkgs, ... }:

{
  # Goodnotes app preferences
  system.defaults.CustomUserPreferences = {
    "com.goodnotes.macapp" = {
      # Add Goodnotes-specific settings here
    };
  };
}
