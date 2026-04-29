{ ... }:

{
  # Microsoft Office apps preferences (Excel, Word, PowerPoint, Outlook, OneNote)
  # Teams has its own module: MicrosoftTeams.nix
  system.defaults.CustomUserPreferences = {
    "com.microsoft.Excel" = {
      # Add Excel-specific settings here
    };
    "com.microsoft.Word" = {
      # Add Word-specific settings here
    };
    "com.microsoft.Powerpoint" = {
      # Add PowerPoint-specific settings here
    };
    "com.microsoft.Outlook" = {
      # Add Outlook-specific settings here
    };
    "com.microsoft.onenote.mac" = {
      # Add OneNote-specific settings here
    };
  };
}
