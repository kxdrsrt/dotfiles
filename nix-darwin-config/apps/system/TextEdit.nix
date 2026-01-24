{ config, pkgs, ... }:

{
  # TextEdit app preferences
  system.defaults.CustomUserPreferences = {
    "com.apple.TextEdit" = {
      # Encoding
      PlainTextEncoding = 4;                     # UTF-8 encoding
      PlainTextEncodingForWrite = 4;             # UTF-8 for writing
      
      # Format
      RichText = 0;                              # Use plain text mode
    };
  };
}
