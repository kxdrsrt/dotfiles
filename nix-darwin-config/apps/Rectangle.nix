{ user, ... }:

{
  # Copy Rectangle config to its app support directory before first launch.
  # Rectangle picks this up on startup; also importable via Preferences > Import.
  # Source: ~/.config/rectangle/RectangleConfig.json (tracked in dotfiles git repo)
  system.activationScripts.rectangleConfig.text = ''
    RECT_DIR="/Users/${user}/Library/Application Support/com.knollsoft.Rectangle"
    sudo -u ${user} mkdir -p "$RECT_DIR"
    if [ -f "/Users/${user}/.config/rectangle/RectangleConfig.json" ]; then
      /bin/cp "/Users/${user}/.config/rectangle/RectangleConfig.json" "$RECT_DIR/RectangleConfig.json"
      chown ${user} "$RECT_DIR/RectangleConfig.json"
    fi
  '';
}
