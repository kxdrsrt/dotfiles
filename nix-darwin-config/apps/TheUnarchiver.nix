{ config, pkgs, ... }:

{
  # The Unarchiver app preferences
  system.defaults.CustomUserPreferences = {
    "com.rarlab.theunarchiver" = {
      # Add The Unarchiver-specific settings here
    };
  };
}
