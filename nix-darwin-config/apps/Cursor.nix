{ config, pkgs, ... }:

{
  # Cursor app preferences
  system.defaults.CustomUserPreferences = {
    "com.todesktop.202007111601.603" = {
      # Add Cursor-specific settings here
    };
  };
}
