{ user, ... }:

{
  # Finder preferences - both standard defaults and custom preferences
  system.defaults.finder = {
    AppleShowAllExtensions = true; # Show all file extensions
    FXDefaultSearchScope = "SCcf"; # Search current folder by default
    FXEnableExtensionChangeWarning = false; # Disable extension change warning
    FXPreferredViewStyle = "clmv"; # Default to column view
    NewWindowTarget = "Other"; # New Finder windows open custom path
    NewWindowTargetPath = "file:///Users/${user}/Downloads/"; # Downloads folder
    ShowExternalHardDrivesOnDesktop = true; # Show external drives on desktop
    ShowHardDrivesOnDesktop = false; # Hide internal drives on desktop
    ShowMountedServersOnDesktop = false; # Hide network drives on desktop
    ShowPathbar = true; # Show path bar at bottom
    ShowRemovableMediaOnDesktop = true; # Show USB drives on desktop
    ShowStatusBar = true; # Show status bar at bottom
    _FXShowPosixPathInTitle = false; # Show full POSIX path in title bar
    _FXSortFoldersFirst = true; # Sort folders before files
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      # Animations
      DisableAllAnimations = true; # Disable all Finder animations

      # Info Panes
      FXInfoPanesExpanded = {
        General = true; # Expand General pane
        OpenWith = true; # Expand Open With pane
        Privileges = true; # Expand Privileges pane
      };

      # Quick Look
      QLEnableTextSelection = true; # Allow text selection in Quick Look

      # Trash
      WarnOnEmptyTrash = false; # Don't warn when emptying trash
    };
  };
}
