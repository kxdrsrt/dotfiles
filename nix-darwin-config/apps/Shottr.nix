{ config, pkgs, ... }:

{
  # Shottr app preferences
  system.defaults.CustomUserPreferences = {
    "cc.htSweet.shottr" = {
      # Add Shottr-specific settings here
    };
  };
}
