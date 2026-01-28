{ config, pkgs, ... }:

{
  # Notion app preferences
  system.defaults.CustomUserPreferences = {
    "notion.id" = {
      # Add Notion-specific settings here
    };
  };
}
