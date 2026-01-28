{ config, pkgs, ... }:

{
  # Rectangle app preferences
  system.defaults.CustomUserPreferences = {
    "com.knollsoft.Rectangle" = {
      # Add Rectangle-specific settings here
    };
  };
}
