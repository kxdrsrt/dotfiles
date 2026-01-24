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
      AutoFillCreditCardData = 0;                # Don't autofill credit cards
      AutoFillFromAddressBook = 0;               # Don't autofill from contacts
      AutoFillMiscellaneousForms = 0;            # Don't autofill forms

      # Privacy & Security
      UniversalSearchEnabled = 0;                # Don't send search queries to Apple
      SuppressSearchSuggestions = 1;             # Disable search suggestions
      WarnAboutFraudulentWebsites = 1;          # Warn about fraudulent sites
      BlockStoragePolicy = 1;
      EnableEnhancedPrivacyInPrivateBrowsing = 1;
      EnableEnhancedPrivacyInRegularBrowsing = 1;

      # Downloads
      AutoOpenSafeDownloads = 0;                 # Don't open safe files automatically

      # URL / UI Display
      ShowFullURLInSmartSearchField = 1;         # Show full URL in search field
      ShowFavoritesBar = 0;                      # Hide favorites bar
      ShowSidebarInNewWindows = 0;
      ShowSidebarInTopSites = 0;
      ShowBackgroundImageInFavorites = 0;

      # Developer & Extensions
      ExtensionsEnabled = 1;
      IncludeDevelopMenu = 1;                    # Show Develop menu
      IncludeInternalDebugMenu = 1;              # Show internal debug menu
      WebKitDeveloperExtrasEnabledPreferenceKey = 1;  # Enable developer extras
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = 1;

      # Web Content Security & Features
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = 0;
      "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = 1;
      WebKitJavaEnabled = 0;                     # Disable Java
      WebKitJavaScriptCanOpenWindowsAutomatically = 0;  # Disable JS auto-open windows
      WebKitTabToLinksPreferenceKey = 1;         # Press Tab to highlight each item

      # Text & Spell Checking
      WebAutomaticSpellingCorrectionEnabled = 0;  # Disable auto-correction
      WebContinuousSpellCheckingEnabled = 1;    # Enable spell checking
    };
  };
}
