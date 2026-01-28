{ config, pkgs, ... }:

{
  # Microsoft Defender Shim app preferences
  system.defaults.CustomUserPreferences = {
    "com.microsoft.wdav.shim" = {
      # Add Microsoft Defender Shim-specific settings here
    };
  };
}
