{ user, ... }:

let
  home = "/Users/${user}";
  previewPlist = "${home}/Library/Containers/com.apple.Preview/Data/Library/Preferences/com.apple.Preview.plist";
in
{
  # Preview is sandboxed — write directly to container plist
  system.activationScripts.postActivation.text = ''
    # ── Preview Preferences (run as user — sandboxed container) ──
    sudo -u ${user} defaults write "${previewPlist}" NSQuitAlwaysKeepsWindows -bool false
  '';
}
