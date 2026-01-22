{ pkgs, ... }: {
  # ============================================================================
  # System Configuration
  # ============================================================================
  system.primaryUser = "k";                  # Required for user-specific settings

  # ============================================================================
  # macOS System Settings
  # ============================================================================
  system.defaults = {
    
    # Dock configuration
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      expose-animation-duration = 0.1;
      expose-group-apps = true;
      launchanim = false;
      minimize-to-application = true;
      show-recents = false;
      tilesize = 45;
      largesize = 75;
      magnification = false;
      static-only = true;
      showhidden = true;
      show-process-indicators = true;
      orientation = "bottom";
      mru-spaces = false;
      
      # Hot corners
      wvous-br-corner = 1;
      wvous-tr-corner = 4;
    };


    # Finder configuration
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      _FXSortFoldersFirst = true;
      _FXShowPosixPathInTitle = true;
    };


    # Control Center configuration
    controlcenter = {
      BatteryShowPercentage = true;
      NowPlaying = false;
    };


    # Trackpad settings
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };


    # Screenshot settings
    screencapture.location = "~/Desktop";


    # Screensaver and security
    screensaver = {
      askForPassword = false;
      askForPasswordDelay = 3600;
    };


    # Software Update
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;


    # Login window
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
      LoginwindowText = "K's Mac";
    };


    # Activity Monitor
    ActivityMonitor = {
      ShowCategory = 100;
      IconType = 5;
    };


    # Menu bar clock
    menuExtraClock = {
      Show24Hour = false;
      ShowDate = 1;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };


    # Spaces
    spaces.spans-displays = false;


    # Universal Access
    universalaccess = {
      closeViewScrollWheelToggle = true;
      reduceMotion = false;
      reduceTransparency = true;
    };


    # Global macOS settings
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      AppleWindowTabbingMode = "always";
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      NSAutomaticWindowAnimationsEnabled = false;
      NSScrollAnimationEnabled = false;
      NSWindowResizeTime = 0.001;
    };


    # Custom application-specific preferences
    CustomUserPreferences = {
      # Global preferences
      NSGlobalDomain = {
        WebKitDeveloperExtras = true;
        "com.apple.mouse.scaling" = 2.5;
        "com.apple.trackpad.scaling" = 3.0;
        "com.apple.trackpad.forceClick" = true;
        "com.apple.swipescrolldirection" = true;
      };

      # Finder
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = true;
        DisableAllAnimations = true;
        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file:///Users/k/Downloads/";
        WarnOnEmptyTrash = false;
      };

      # Dock
      "com.apple.dock" = {
        springboard-show-duration = 0;
        springboard-hide-duration = 0;
        springboard-page-duration = 0;
      };

      # Desktop Services
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      # Screensaver
      "com.apple.screensaver" = {
        askForPassword = 1;
        askForPasswordDelay = 0;
      };

      # Screenshot
      "com.apple.screencapture" = {
        location = "~/Desktop";
        type = "png";
      };

      # Safari
      "com.apple.Safari" = {
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        WebKitTabToLinksPreferenceKey = true;
        ShowFullURLInSmartSearchField = true;
        AutoOpenSafeDownloads = false;
        ShowFavoritesBar = false;
        IncludeInternalDebugMenu = true;
        IncludeDevelopMenu = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        WebContinuousSpellCheckingEnabled = true;
        WebAutomaticSpellingCorrectionEnabled = false;
        AutoFillFromAddressBook = false;
        AutoFillCreditCardData = false;
        AutoFillMiscellaneousForms = false;
        WarnAboutFraudulentWebsites = true;
        WebKitJavaEnabled = false;
        WebKitJavaScriptCanOpenWindowsAutomatically = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
      };

      # Mail
      "com.apple.mail" = {
        DisableInlineAttachmentViewing = true;
        ColumnLayoutMessageList = true;
        ShouldShowSidePreview = false;
        DisableSendAnimations = true;
        DisableReplyAnimations = true;
      };

      # Advertising
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };

      # Print
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };

      # Software Update
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        ScheduleFrequency = 1;
        AutomaticDownload = 1;
        CriticalUpdateInstall = 1;
      };

      # Time Machine
      "com.apple.TimeMachine" = {
        DoNotOfferNewDisksForBackup = true;
      };

      # Image Capture
      "com.apple.ImageCapture" = {
        disableHotPlug = true;
      };

      # App Store
      "com.apple.commerce" = {
        AutoUpdate = true;
      };
    };
  };


  # ============================================================================
  # Firewall Configuration
  # ============================================================================
  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    enableStealthMode = true;
  };


  # ============================================================================
  # Activation Scripts
  # ============================================================================
  system.activationScripts.postActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';


  # ============================================================================
  # Networking
  # ============================================================================
  networking.hostName = "Ks-Mac";
  networking.computerName = "K's Mac";


  # ============================================================================
  # Security and Authentication
  # ============================================================================
  security.pam.services.sudo_local.touchIdAuth = true;


  # ============================================================================
  # Shell Configuration
  # ============================================================================
  programs.zsh.enable = true;


  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.k = {
    name = "k";
    home = "/Users/k";
    shell = pkgs.zsh;
  };
}
