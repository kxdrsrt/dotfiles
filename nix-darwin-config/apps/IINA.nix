{ config, pkgs, ... }:

{
  # IINA app preferences
  system.defaults.CustomUserPreferences = {
    "com.colloquial.iina" = {
      # Add IINA-specific settings here
    };
  };
}
