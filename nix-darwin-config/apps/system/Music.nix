{ config, pkgs, ... }:

{
  # Music app preferences (iTunes/Music)
  system.defaults.CustomUserPreferences = {
    "com.apple.Music" = {
      # Notifications
      userWantsPlaybackNotifications = false;    # Disable music notifications
    };
  };
}
