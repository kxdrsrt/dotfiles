{ pkgs, ... }: {
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
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
      };
    };
  };
}
