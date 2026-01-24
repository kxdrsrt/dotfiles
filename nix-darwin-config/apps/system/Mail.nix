{ config, pkgs, ... }:

{
  # Mail app preferences
  system.defaults.CustomUserPreferences = {
    "com.apple.mail" = {
      # Display & Layout
      ColumnLayoutMessageList = true;            # Use column layout for message list
      ShouldShowSidePreview = false;             # Disable side preview pane

      # Attachments
      DisableInlineAttachmentViewing = true;     # Show attachment icons only

      # Animations
      DisableReplyAnimations = true;             # Disable reply animations
      DisableSendAnimations = true;              # Disable send animations
    };
  };
}
