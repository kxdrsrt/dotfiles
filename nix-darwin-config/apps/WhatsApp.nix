{ config, pkgs, ... }:

{
  # WhatsApp app preferences
  system.defaults.CustomUserPreferences = {
    "com.whatsapp.WhatsApp" = {
      # Add WhatsApp-specific settings here
    };
  };
}
