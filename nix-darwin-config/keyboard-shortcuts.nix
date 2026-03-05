{ ... }:
{
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Spotlight search (Cmd+Space — disabled, indexing kept)
        "64" = {
          enabled = 0;
        };

        # ----- Disable default screenshot keybindings -----
        # (screenshots are handled by CleanShot X or similar)

        # Save picture of screen as file (Cmd+Shift+3)
        "28" = {
          enabled = 0;
        };
        # Copy picture of screen to clipboard (Cmd+Ctrl+Shift+3)
        "29" = {
          enabled = 0;
        };
        # Save picture of selected area as file (Cmd+Shift+4)
        "30" = {
          enabled = 0;
        };
        # Copy picture of selected area to clipboard (Cmd+Ctrl+Shift+4)
        "31" = {
          enabled = 0;
        };
        # Screenshot and recording options (Cmd+Shift+5)
        "184" = {
          enabled = 0;
        };
      };
    };
  };
}
