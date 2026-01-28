{ config, pkgs, ... }:

{
  # Karabiner-EventViewer app preferences
  system.defaults.CustomUserPreferences = {
    "org.pqrs.Karabiner-EventViewer" = {
      # Add Karabiner-EventViewer-specific settings here
    };
  };
}
