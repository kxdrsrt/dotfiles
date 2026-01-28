{ config, pkgs, ... }:

{
  # Raycast app preferences
  system.defaults.CustomUserPreferences = {
    "com.raycast.macos" = {
      # Add Raycast-specific settings here
    };
  };
}
