{ config, pkgs, ... }:

{
  # Flow app preferences
  system.defaults.CustomUserPreferences = {
    "io.github.lynbryan.Flow" = {
      # Add Flow-specific settings here
    };
  };
}
