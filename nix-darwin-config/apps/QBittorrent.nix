{ config, pkgs, ... }:

{
  # qBittorrent app preferences
  system.defaults.CustomUserPreferences = {
    "org.qbittorrent.qBittorrent" = {
      # Add qBittorrent-specific settings here
    };
  };
}
