{ ... }:

{
  system.defaults.CustomUserPreferences = {
    "company.thebrowser.dia" = {
      # Core Browser Settings
      alwaysShowBookmarkBarEnabled = 0;
      displayPageTitleInURLBarEnabled = 1;
      shouldWarnBeforeQuitting = 1;
      nativeAdBlockEnabled = 1;
      shouldAutomaticallyUpdate = 1;

      # Window Restoration
      windowRestorationSetting = 0; # 0 = don't restore windows

      # Tab Settings
      autoCleanInactiveTabsEnabled = 0;
      tabReorderingHapticsDisabled = 0;
      loadAllProfilesAtStartup = 0;

      # Assistant/AI Settings
      preferredAssistantPanePresentationStyle = "sidebar";
      supertabAssistantPersonalityStatus = {
        Default = "disabled";
      };

      # Notifications
      chatNotificationSoundEnabled = 1;
      reportNotificationSoundEnabled = 1;

      # Chromium Features
      enableCertificateTransparency = 1;
      enableChromiumDistillabilityService = 0;
      enablePageContentExtraction = 1;
      enableTopBandBlinkSampling = 1;
      useChromiumAutoPiP = 1;
      useChromiumAutoPiPForGMeetOnly = 1;
      useChromiumTabLoadingPolicy = 1;

      # Performance Settings
      compositorFlashingPrevention = 1;
      disableBackForwardCache = 1;
      disableCompositorRecycling = 0;
      disableSkiaGraphite = 0;

      # Bookmarks Visibility
      # 0 = hidden, 1 = always show, 2 = new tab only
      bookmarksVisibilityPreference = {
        Default = 2;
      };

      # Allowed URL Schemes
      arcAlwaysAllowedLinkToSchemesPerSite = {
        "discord.com" = [ "discord" ];
        "www.figma.com" = [ "figma" ];
      };

      # Assistant Writing Guidelines
      supertabAssistantPersonalityWritingGuidelines = {
        Default = "Short, precise, simple, clear sentences.\nFormal, diplomatic, like a lawyer.";
      };
    };
  };
}
