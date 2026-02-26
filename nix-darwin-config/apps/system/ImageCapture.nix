{ ... }:

{
  # Image Capture preferences
  system.defaults.CustomUserPreferences = {
    "com.apple.ImageCapture" = {
      # Device handling
      disableHotPlug = true; # Prevent Photos from opening when devices plugged in
    };
  };
}
