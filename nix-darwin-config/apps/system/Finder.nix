{ config, pkgs, ... }:

{
  # Finder preferences
  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      # Animations
      DisableAllAnimations = true;               # Disable all Finder animations
      
      # Info Panes
      FXInfoPanesExpanded = {
        General = true;
        OpenWith = true;
        Privileges = true;
      };
      
      # Window Behavior
      NewWindowTarget = "PfDe";                  # New Finder windows open Downloads
      NewWindowTargetPath = "file:///Users/k/Downloads/";  # Downloads folder path
      QLEnableTextSelection = true;              # Allow text selection in Quick Look
      
      # Desktop Display
      ShowExternalHardDrivesOnDesktop = true;    # Show external drives on desktop
      ShowHardDrivesOnDesktop = false;           # Hide internal drives on desktop
      ShowMountedServersOnDesktop = false;       # Hide network drives on desktop
      ShowRemovableMediaOnDesktop = true;        # Show USB drives on desktop
      
      # Trash
      WarnOnEmptyTrash = false;                  # Don't warn when emptying trash
    };
  };
}
