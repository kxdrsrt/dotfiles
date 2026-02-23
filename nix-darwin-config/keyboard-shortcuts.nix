{ ... }: {
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Spotlight search (Cmd+Space → Cmd+1)
        "64" = {
          enabled = 1;
          value = {
            type = "standard";
            parameters = [
              65535
              10
              1048576
            ];
          };
        };

        # ----- Disable default screenshot keybindings -----
        # (screenshots are handled by CleanShot X or similar)

        # Save picture of screen as file (Cmd+Shift+3)
        "28" = { enabled = 0; };
        # Copy picture of screen to clipboard (Cmd+Ctrl+Shift+3)
        "29" = { enabled = 0; };
        # Save picture of selected area as file (Cmd+Shift+4)
        "30" = { enabled = 0; };
        # Copy picture of selected area to clipboard (Cmd+Ctrl+Shift+4)
        "31" = { enabled = 0; };
        # Screenshot and recording options (Cmd+Shift+5)
        "184" = { enabled = 0; };
      };
    };
  };
}
