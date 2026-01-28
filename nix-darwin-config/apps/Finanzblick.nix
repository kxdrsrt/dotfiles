{ config, pkgs, ... }:

{
  # Finanzblick app preferences
  system.defaults.CustomUserPreferences = {
    "de.buhl.finanzblick" = {
      # Add Finanzblick-specific settings here
    };
  };
}
