{ config, pkgs, ... }:

{
  # OneDrive app preferences
  system.defaults.CustomUserPreferences = {
    "com.microsoft.OneDrive" = {
      # Add OneDrive-specific settings here
    };
  };
}
