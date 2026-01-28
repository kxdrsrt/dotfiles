{ config, pkgs, ... }:

{
  # Figma app preferences
  system.defaults.CustomUserPreferences = {
    "com.figma.Desktop" = {
      # Add Figma-specific settings here
    };
  };
}
