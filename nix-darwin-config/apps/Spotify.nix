{ config, pkgs, ... }:

{
  # Spotify app preferences
  system.defaults.CustomUserPreferences = {
    "com.spotify.client" = {
      # Add Spotify-specific settings here
    };
  };
}
