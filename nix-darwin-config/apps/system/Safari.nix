{ ... }:

let
  user = "k";
  home = "/Users/${user}";
  safariPlist = "${home}/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist";
in
{
  # Safari is sandboxed — its prefs live inside its container, so we must
  # write directly to the container plist via an activation script.
  system.activationScripts.postActivation.text = ''
    # ── Safari Preferences (run as user — sandboxed container) ──
    # Session Restoration
    sudo -u ${user} defaults write "${safariPlist}" AlwaysRestoreSessionAtLaunch -int 1
    sudo -u ${user} defaults write "${safariPlist}" ExcludePrivateWindowWhenRestoringSessionAtLaunch -int 1
    sudo -u ${user} defaults write "${safariPlist}" OpenPrivateWindowWhenNotRestoringSessionAtLaunch -int 0

    # AutoFill Settings
    sudo -u ${user} defaults write "${safariPlist}" AutoFillFromiCloudKeychain -int 1
    sudo -u ${user} defaults write "${safariPlist}" AutoFillPasswords -int 1
    sudo -u ${user} defaults write "${safariPlist}" AutoFillCreditCardData -int 0
    sudo -u ${user} defaults write "${safariPlist}" AutoFillFromAddressBook -int 0
    sudo -u ${user} defaults write "${safariPlist}" AutoFillMiscellaneousForms -int 0

    # Privacy & Security
    sudo -u ${user} defaults write "${safariPlist}" UniversalSearchEnabled -int 0
    sudo -u ${user} defaults write "${safariPlist}" SuppressSearchSuggestions -int 1
    sudo -u ${user} defaults write "${safariPlist}" WarnAboutFraudulentWebsites -int 1
    sudo -u ${user} defaults write "${safariPlist}" BlockStoragePolicy -int 1
    sudo -u ${user} defaults write "${safariPlist}" EnableEnhancedPrivacyInPrivateBrowsing -int 1
    sudo -u ${user} defaults write "${safariPlist}" EnableEnhancedPrivacyInRegularBrowsing -int 1

    # Downloads
    sudo -u ${user} defaults write "${safariPlist}" AutoOpenSafeDownloads -int 0

    # URL / UI Display
    sudo -u ${user} defaults write "${safariPlist}" ShowFullURLInSmartSearchField -int 1
    sudo -u ${user} defaults write "${safariPlist}" ShowFavoritesBar -int 0
    sudo -u ${user} defaults write "${safariPlist}" ShowSidebarInNewWindows -int 0
    sudo -u ${user} defaults write "${safariPlist}" ShowSidebarInTopSites -int 0
    sudo -u ${user} defaults write "${safariPlist}" ShowBackgroundImageInFavorites -int 0

    # Developer & Extensions
    sudo -u ${user} defaults write "${safariPlist}" ExtensionsEnabled -int 1
    sudo -u ${user} defaults write "${safariPlist}" IncludeDevelopMenu -int 1
    sudo -u ${user} defaults write "${safariPlist}" IncludeInternalDebugMenu -int 1
    sudo -u ${user} defaults write "${safariPlist}" WebKitDeveloperExtrasEnabledPreferenceKey -int 1
    sudo -u ${user} defaults write "${safariPlist}" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -int 1

    # Web Content Security & Features
    sudo -u ${user} defaults write "${safariPlist}" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" -int 0
    sudo -u ${user} defaults write "${safariPlist}" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" -int 0
    sudo -u ${user} defaults write "${safariPlist}" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" -int 0
    sudo -u ${user} defaults write "${safariPlist}" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" -int 0
    sudo -u ${user} defaults write "${safariPlist}" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" -int 1
    sudo -u ${user} defaults write "${safariPlist}" WebKitJavaEnabled -int 0
    sudo -u ${user} defaults write "${safariPlist}" WebKitJavaScriptCanOpenWindowsAutomatically -int 0
    sudo -u ${user} defaults write "${safariPlist}" WebKitTabToLinksPreferenceKey -int 1

    # Text & Spell Checking
    sudo -u ${user} defaults write "${safariPlist}" WebAutomaticSpellingCorrectionEnabled -int 0
    sudo -u ${user} defaults write "${safariPlist}" WebContinuousSpellCheckingEnabled -int 1
  '';
}
