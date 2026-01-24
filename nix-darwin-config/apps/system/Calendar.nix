{ config, pkgs, ... }:

{
  # Calendar app preferences (iCal)
  system.defaults.CustomUserPreferences = {
    # iCal (Calendar)
    iCal = {
      "Show time in Month View" = true;         # Show event times in month view
      "Show Week Numbers" = true;               # Show week numbers
    };
  };
}
