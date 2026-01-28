{ config, pkgs, ... }:

{
  # Visual Studio Code app preferences
  system.defaults.CustomUserPreferences = {
    "com.microsoft.VSCode" = {
      # Add VS Code-specific settings here
    };
  };
}
