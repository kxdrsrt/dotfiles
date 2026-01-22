{ pkgs, ... }: {
  # ============================================================================
  # macOS System Settings
  # ============================================================================
  system.defaults = {
    
    # Dock configuration
    dock = {
      autohide = true;                       # Auto-hide dock
      autohide-delay = 0.0;                  # Remove dock show delay
      autohide-time-modifier = 0.0;          # Remove dock animation
      expose-animation-duration = 0.1;       # Fast Mission Control animation
      expose-group-apps = true;              # Group windows by application
      launchanim = false;                    # Disable launch animation
      minimize-to-application = true;        # Minimize windows into app icon
      show-recents = false;                  # Hide recent applications
      tilesize = 45;                         # Dock icon size
      largesize = 75;                        # Magnified icon size
      magnification = false;                 # Disable magnification
      static-only = true;                    # Only show running apps in Dock
      showhidden = true;                     # Make hidden app icons translucent
      show-process-indicators = true;        # Show indicator lights for open apps
      orientation = "bottom";                # Dock position on screen
      mru-spaces = false;                    # Don't auto-rearrange spaces by recent use
      
      # Hot corners
      wvous-br-corner = 1;                   # Bottom right: disabled
      wvous-tr-corner = 4;                   # Top right: show desktop
    };


    # Finder configuration
    finder = {
      AppleShowAllExtensions = true;         # Show all file extensions
      FXPreferredViewStyle = "clmv";         # Default to column view
      ShowPathbar = true;                    # Show path bar at bottom
      ShowStatusBar = true;                  # Show status bar at bottom
      FXDefaultSearchScope = "SCcf";         # Search current folder by default
      FXEnableExtensionChangeWarning = false; # Disable extension change warning
      _FXSortFoldersFirst = true;            # Sort folders before files
      _FXShowPosixPathInTitle = true;        # Show full POSIX path in title bar
    };


    # Control Center configuration
    controlcenter = {
      BatteryShowPercentage = true;          # Show battery percentage in menu bar
      NowPlaying = false;                    # Hide Now Playing in Control Center
    };


    # Trackpad settings
    trackpad = {
      Clicking = true;                       # Enable tap to click
      TrackpadRightClick = true;             # Enable two-finger right click
      TrackpadThreeFingerDrag = false;       # Disable three-finger drag
    };


    # Screenshot settings
    screencapture.location = "~/Desktop";    # Save screenshots to Desktop


    # Screensaver and security
    screensaver = {
      askForPassword = false;                # Require password after screensaver
      askForPasswordDelay = 3600;            # Require password immediately
    };


    # Software Update
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;  # Don't auto-install macOS updates


    # Login window
    loginwindow = {
      GuestEnabled = false;                  # Disable guest account
      DisableConsoleAccess = true;           # Disable console login
      LoginwindowText = "K's Mac";  # Custom text shown on login screen
    };


    # Activity Monitor
    ActivityMonitor = {
      ShowCategory = 100;                    # Show all processes
      IconType = 5;                          # Show CPU usage in dock icon
    };


    # Menu bar clock
    menuExtraClock = {
      Show24Hour = false;                    # Use 12-hour clock
      ShowDate = 1;                          # Always show date
      ShowDayOfWeek = true;                  # Show day of week
      ShowSeconds = false;                   # Don't show seconds
    };


    # Firewall
    alf = {
      globalstate = 1;                       # Enable firewall
      allowsignedenabled = 1;                # Allow signed apps
      stealthenabled = 1;                    # Enable stealth mode
    };


    # Spaces
    spaces.spans-displays = false;           # Each display has separate spaces


    # Universal Access
    universalaccess = {
      closeViewScrollWheelToggle = true;     # Use scroll gesture with modifier key to zoom
      reduceMotion = false;                  # Keep motion effects
      reduceTransparency = true;             # Reduce transparency
    };


    # Global macOS settings
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";          # Use dark mode
      AppleShowAllExtensions = true;         # Show all file extensions
      InitialKeyRepeat = 15;                 # Fast initial key repeat
      KeyRepeat = 2;                         # Fast key repeat rate
      AppleMiniaturizeOnDoubleClick = false; # Don't minimize on title bar double-click
      AppleWindowTabbingMode = "always";     # Always prefer tabs when opening documents
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      NSAutomaticWindowAnimationsEnabled = false;  # Disable window animations
      NSScrollAnimationEnabled = false;            # Disable smooth scrolling
      NSWindowResizeTime = 0.001;                  # Fast window resize
      NSScrollViewRubberbanding = false;           # Disable rubber-band scrolling
      QLPanelAnimationDuration = 0;                # Disable Quick Look animations
      NSDocumentRevisionsWindowTransformAnimation = false;  # Disable document versions animation
      NSToolbarFullScreenAnimationDuration = 0;    # Disable toolbar full screen animation
      NSBrowserColumnAnimationSpeedMultiplier = 0; # Disable Finder column animations
      "com.apple.mouse.scaling" = 2.5;             # Mouse tracking speed
      "com.apple.trackpad.scaling" = 3.0;          # Trackpad tracking speed
      "com.apple.trackpad.forceClick" = true;      # Enable Force Click
      "com.apple.swipescrolldirection" = true;     # Natural scrolling
    };


    # Custom application-specific preferences
    # Note: Use this only for settings not available in the standard system.defaults options above
    CustomUserPreferences = {
      # Global preferences
      NSGlobalDomain = {
        WebKitDeveloperExtras = true;              # Add context menu item for Web Inspector
      };

      # Finder - Additional settings not available in system.defaults.finder
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;    # Show external drives on desktop
        ShowHardDrivesOnDesktop = false;           # Hide internal drives on desktop
        ShowMountedServersOnDesktop = false;       # Hide network drives on desktop
        ShowRemovableMediaOnDesktop = true;        # Show USB drives on desktop
        DisableAllAnimations = true;               # Disable all Finder animations
        NewWindowTarget = "PfDe";                  # New Finder windows open Downloads
        NewWindowTargetPath = "file://${HOME}/Downloads/";  # Downloads folder path
        WarnOnEmptyTrash = false;                  # Don't warn when emptying trash
      };

      # Dock - Additional animation settings
      "com.apple.dock" = {
        springboard-show-duration = 0;             # Disable springboard show animation
        springboard-hide-duration = 0;             # Disable springboard hide animation
        springboard-page-duration = 0;             # Disable springboard page animation
      };

      # Desktop Services
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;           # Avoid creating .DS_Store files on network volumes
        DSDontWriteUSBStores = true;               # Avoid creating .DS_Store files on USB volumes
      };

      # Screensaver - Additional settings
      "com.apple.screensaver" = {
        askForPassword = 1;                        # Require password after screensaver
        askForPasswordDelay = 0;                   # Require password immediately
      };

      # Screenshot - Additional settings
      "com.apple.screencapture" = {
        location = "~/Desktop";                    # Screenshot location
        type = "png";                              # Screenshot format
      };

      # Safari
      "com.apple.Safari" = {
        UniversalSearchEnabled = false;            # Don't send search queries to Apple
        SuppressSearchSuggestions = true;          # Disable search suggestions
        WebKitTabToLinksPreferenceKey = true;      # Press Tab to highlight each item
        ShowFullURLInSmartSearchField = true;      # Show full URL in search field
        AutoOpenSafeDownloads = false;             # Don't open safe files automatically
        ShowFavoritesBar = false;                  # Hide favorites bar
        IncludeInternalDebugMenu = true;           # Show debug menu
        IncludeDevelopMenu = true;                 # Show develop menu
        WebKitDeveloperExtrasEnabledPreferenceKey = true;  # Enable developer extras
        WebContinuousSpellCheckingEnabled = true;  # Enable spell checking
        WebAutomaticSpellingCorrectionEnabled = false;  # Disable auto-correction
        AutoFillFromAddressBook = false;           # Don't autofill from contacts
        AutoFillCreditCardData = false;            # Don't autofill credit cards
        AutoFillMiscellaneousForms = false;        # Don't autofill forms
        WarnAboutFraudulentWebsites = true;        # Warn about fraudulent sites
        WebKitJavaEnabled = false;                 # Disable Java
        WebKitJavaScriptCanOpenWindowsAutomatically = false;  # Disable JS auto-open windows
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
      };

      # Mail
      "com.apple.mail" = {
        DisableInlineAttachmentViewing = true;     # Show attachment icons only
        ColumnLayoutMessageList = true;            # Attempt to enable column layout
        ShouldShowSidePreview = false;             # Disable side preview
        DisableSendAnimations = true;              # Disable send animations
        DisableReplyAnimations = true;             # Disable reply animations
      };

      # Advertising
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false; # Disable personalized ads
      };

      # Print
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;               # Quit printer app when done
      };

      # Software Update
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;              # Check for software updates automatically
        ScheduleFrequency = 1;                     # Check for updates daily
        AutomaticDownload = 1;                     # Download updates in background
        CriticalUpdateInstall = 1;                 # Install system data files and security updates
      };

      # Time Machine
      "com.apple.TimeMachine" = {
        DoNotOfferNewDisksForBackup = true;        # Don't prompt to use new disks for Time Machine
      };

      # Image Capture
      "com.apple.ImageCapture" = {
        disableHotPlug = true;                     # Prevent Photos from opening when devices plugged in
      };

      # App Store
      "com.apple.commerce" = {
        AutoUpdate = true;                         # Turn on app auto-update
      };
    };
  };

  # ============================================================================
  # Activation Scripts
  # ============================================================================
  system.activationScripts.postActivation.text = ''
    # Apply settings without logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # ============================================================================
  # Networking
  # ============================================================================
  networking.hostName = "Ks-Mac";            # Set hostname
  networking.computerName = "K's Mac";       # Set computer name


  # ============================================================================
  # Security and Authentication
  # ============================================================================
  security.pam.enableSudoTouchIdAuth = true;  # Enable Touch ID for sudo


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
    shell = pkgs.zsh;                        # Set default shell to zsh
  };
}