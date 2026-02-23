{ ... }:

{
  system.defaults.CustomUserPreferences = {
    "company.thebrowser.dia" = {
      # Core Browser Settings
      alwaysShowBookmarkBarEnabled = 1;
      displayPageTitleInURLBarEnabled = 1;
      shouldWarnBeforeQuitting = 1;
      nativeAdBlockEnabled = 1;
      
      # Window Restoration
      windowRestorationSetting = 0;  # 0 = don't restore windows
      
      # Assistant/AI Settings
      preferredAssistantPanePresentationStyle = "sidebar";
      
      # Chromium Features
      enableCertificateTransparency = 1;
      enableChromiumDistillabilityService = 1;
      useChromiumAutoPiP = 1;
      useChromiumAutoPiPForGMeetOnly = 1;
      useChromiumTabLoadingPolicy = 1;
      
      # Performance Settings
      compositorFlashingPrevention = 1;
      disableCompositorRecycling = 0;
      disableSkiaGraphite = 0;
      
      # Bookmarks Visibility
      bookmarksVisibilityPreference = {
        Default = 1;
      };
      
      # Allowed URL Schemes
      arcAlwaysAllowedLinkToSchemesPerSite = {
        "discord.com" = [ "discord" ];
        "www.figma.com" = [ "figma" ];
      };
      
      # Assistant Writing Guidelines (customize as needed)
      supertabAssistantPersonalityWritingGuidelines = {
        Default = "Short, precise, simple, clear sentences.\nFormal, diplomatic, like a lawyer.";
      };
    };
  };
}
