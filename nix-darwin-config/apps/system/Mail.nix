{ ... }:

let
  user = "k";
  home = "/Users/${user}";
  mailPlist = "${home}/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist";
in
{
  # Mail is sandboxed — write directly to container plist
  system.activationScripts.postActivation.text = ''
    # ── Mail Preferences (run as user — sandboxed container) ──
    sudo -u ${user} defaults write "${mailPlist}" ColumnLayoutMessageList -bool true
    sudo -u ${user} defaults write "${mailPlist}" ShouldShowSidePreview -bool false
    sudo -u ${user} defaults write "${mailPlist}" DisableInlineAttachmentViewing -bool true
    sudo -u ${user} defaults write "${mailPlist}" DisableReplyAnimations -bool true
    sudo -u ${user} defaults write "${mailPlist}" DisableSendAnimations -bool true
  '';
}
