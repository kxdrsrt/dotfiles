{ config, pkgs, ... }:

{
  # Safari preferences applied as CustomUserPreferences
  system.defaults.CustomUserPreferences = {
    "com.apple.Safari" = {
      # Session Restoration
      AlwaysRestoreSessionAtLaunch = 1;
      ExcludePrivateWindowWhenRestoringSessionAtLaunch = 1;
      OpenPrivateWindowWhenNotRestoringSessionAtLaunch = 0;

      # AutoFill Settings
      AutoFillFromiCloudKeychain = 1;
      AutoFillPasswords = 1;
      AutoFillCreditCardData = 0;
      AutoFillFromAddressBook = 0;
      AutoFillMiscellaneousForms = 0;

      # Privacy & Security
      UniversalSearchEnabled = 0;
      SuppressSearchSuggestions = 1;
      WarnAboutFraudulentWebsites = 1;
      BlockStoragePolicy = 1;
      EnableEnhancedPrivacyInPrivateBrowsing = 1;
      EnableEnhancedPrivacyInRegularBrowsing = 1;

      # Downloads
      AutoOpenSafeDownloads = 0;

      # URL / UI
      ShowFullURLInSmartSearchField = 1;
      ShowFavoritesBar = 0;
      ShowSidebarInNewWindows = 0;
      ShowSidebarInTopSites = 0;
      ShowBackgroundImageInFavorites = 0;

      # Extensions / Developer
      ExtensionsEnabled = 1;
      IncludeDevelopMenu = 1;                    # show Develop menu (matches system-settings.nix)
      IncludeInternalDebugMenu = 1;              # show internal debug menu
      WebKitDeveloperExtrasEnabledPreferenceKey = 1;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = 1;

      # Web content flags (WebKit ContentPageGroupIdentifier keys)
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = 1;
    };
  };
}
