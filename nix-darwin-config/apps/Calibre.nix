{ config, pkgs, ... }:

{
  # calibre app preferences
  system.defaults.CustomUserPreferences = {
    "com.calibre" = {
      # Add calibre-specific settings here
    };
  };
}
