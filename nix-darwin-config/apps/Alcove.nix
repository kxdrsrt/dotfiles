{ config, pkgs, ... }:

{
  # Alcove app preferences
  system.defaults.CustomUserPreferences = {
    "com.alcove" = {
      # Add Alcove-specific settings here
    };
  };
}
