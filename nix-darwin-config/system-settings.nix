{ pkgs, ... }: {
  # ============================================================================
  # System Configuration
  # ============================================================================
  system.primaryUser = "k";                  # Required for user-specific settings


  # ============================================================================
  # Activation Scripts
  # ============================================================================
  system.activationScripts.postActivation.text = ''
    # Apply settings without logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

    # Set wallpaper
    /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to "${./assets/wallpaper.png}"'

    # Unquarantine apps installed by casks/Homebrew/Nix to avoid Gatekeeper prompts.
    # Use 'xattr -d' to strip quarantine from common app locations.
    for dir in "/Applications" "/Applications/Nix Apps" "/opt/homebrew/Caskroom"; do
      if [ -d "$dir" ]; then
        echo "Unquarantining apps in $dir..."
        sudo xattr -rd com.apple.quarantine "$dir"/*.app 2>/dev/null || true
      fi
    done
  '';

  # ============================================================================
  # macOS System Settings
  # ============================================================================
  system.defaults = {

    # Activity Monitor
    ActivityMonitor = {
      IconType = 5;                          # Show CPU usage in dock icon
      ShowCategory = 100;                    # Show all processes
    };



    # Control Center configuration
    controlcenter = {
      BatteryShowPercentage = false;         # Hide battery percentage in menu bar
      Bluetooth = false;                      # Show Bluetooth in menu bar
      NowPlaying = false;                    # Hide Now Playing in Control Center
    };



    # Dock configuration
    dock = {
      autohide = true;                       # Auto-hide dock
      autohide-delay = 0.0;                  # Remove dock show delay
      autohide-time-modifier = 0.0;          # Remove dock animation
      expose-animation-duration = 0.1;       # Fast Mission Control animation
      expose-group-apps = true;              # Group windows by application
      largesize = 75;                        # Magnified icon size
      launchanim = false;                    # Disable launch animation
      magnification = false;                 # Disable magnification
      minimize-to-application = true;        # Minimize windows into app icon
      mru-spaces = false;                    # Don't auto-rearrange spaces by recent use
      orientation = "bottom";                # Dock position on screen
      showLaunchpadGestureEnabled = true;    # Enable pinch gesture for Launchpad
      show-process-indicators = true;        # Show indicator lights for open apps
      show-recents = false;                  # Hide recent applications
      showhidden = true;                     # Make hidden app icons translucent
      static-only = false;                   # Show all apps in Dock
      tilesize = 45;                         # Dock icon size

      # Hot corners
      wvous-bl-corner = 1;                   # Bottom left: disabled
      wvous-br-corner = 1;                   # Bottom right: disabled
      wvous-tl-corner = 1;                   # Top left: disabled
      wvous-tr-corner = 4;                   # Top right: show desktop
    };



    # Finder configuration
    finder = {
      AppleShowAllExtensions = true;         # Show all file extensions
      FXDefaultSearchScope = "SCcf";         # Search current folder by default
      FXEnableExtensionChangeWarning = false; # Disable extension change warning
      FXPreferredViewStyle = "clmv";         # Default to column view
      ShowPathbar = true;                    # Show path bar at bottom
      ShowStatusBar = true;                  # Show status bar at bottom
      _FXShowPosixPathInTitle = true;        # Show full POSIX path in title bar
      _FXSortFoldersFirst = true;            # Sort folders before files
    };


    # LaunchServices
    LaunchServices = {
      LSQuarantine = false;                  # Disable "Are you sure you want to open" dialog
    };



    # Login window
    loginwindow = {
      DisableConsoleAccess = true;           # Disable console login
      GuestEnabled = false;                  # Disable guest account
      LoginwindowText = "K's Mac";           # Custom text shown on login screen
    };



    # Magic Mouse
    magicmouse = {
      MouseButtonMode = "TwoButton";         # Enable right-click
    };



    # Menu bar clock
    menuExtraClock = {
      IsAnalog = false;                      # Use digital clock
      Show24Hour = false;                    # Use 12-hour clock
      ShowDate = 1;                          # Always show date
      ShowDayOfWeek = true;                  # Show day of week
      ShowSeconds = false;                   # Don't show seconds
    };



    # Global macOS settings
    NSGlobalDomain = {
      AppleFontSmoothing = 2;                # Medium font smoothing for non-Apple displays
      AppleICUForce24HourTime = false;       # Use 12-hour time
      AppleInterfaceStyle = "Dark";          # Use dark mode
      AppleInterfaceStyleSwitchesAutomatically = false;  # Don't auto-switch dark mode
      AppleMeasurementUnits = "Centimeters"; # Metric system
      AppleMetricUnits = 1;               # Use metric
      AppleShowAllExtensions = true;           # Show all file extensions
      AppleTemperatureUnit = "Celsius";      # Celsius temperature
      AppleWindowTabbingMode = "always";     # Always prefer tabs when opening documents
      InitialKeyRepeat = 15;                 # Fast initial key repeat
      KeyRepeat = 2;                         # Fast key repeat rate
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticDashSubstitutionEnabled = false;    # Disable smart dashes
      NSAutomaticPeriodSubstitutionEnabled = true;
      NSAutomaticQuoteSubstitutionEnabled = false;   # Disable smart quotes
      NSAutomaticSpellingCorrectionEnabled = false;  # Disable auto-correct
      NSAutomaticWindowAnimationsEnabled = false;    # Disable window animations
      NSDocumentSaveNewDocumentsToCloud = false;     # Save to disk by default (not iCloud)
      NSNavPanelExpandedStateForSaveMode = true;     # Expanded save panel
      NSNavPanelExpandedStateForSaveMode2 = true;    # Expanded save panel
      NSScrollAnimationEnabled = false;              # Disable smooth scrolling
      NSTableViewDefaultSizeMode = 2;                # Medium sidebar icon size
      NSWindowResizeTime = 0.001;                    # Fast window resize
      PMPrintingExpandedStateForPrint = true;        # Expanded print panel
      PMPrintingExpandedStateForPrint2 = true;       # Expanded print panel
    };



    # Screenshot settings
    screencapture.location = "~/Desktop";    # Save screenshots to Desktop



    # Screensaver and security
    screensaver = {
      askForPassword = false;                # Require password after screensaver
      askForPasswordDelay = 3600;            # Require password immediately
    };



    # SMB (Network file sharing)
    smb = {
      NetBIOSName = "Ks-Mac";                # NetBIOS name for network
      ServerDescription = "K's Mac";         # Server description
    };



    # Software Update
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;  # Don't auto-install macOS updates



    # Spaces
    spaces.spans-displays = false;           # Each display has separate spaces



    # Trackpad settings
    trackpad = {
      Clicking = true;                       # Enable tap to click
      TrackpadRightClick = true;             # Enable two-finger right click
      TrackpadThreeFingerDrag = false;       # Disable three-finger drag
      TrackpadFourFingerPinchGesture = 2;     # Launchpad with four-finger pinch
    };



    # Universal Access
    universalaccess = {
      closeViewScrollWheelToggle = true;     # Use scroll gesture with modifier key to zoom
      reduceMotion = false;                  # Keep motion effects
      reduceTransparency = true;             # Reduce transparency
    };



    # Window Manager (macOS Sequoia/Tahoe)
    WindowManager = {
      EnableStandardClickToShowDesktop = false;  # Disable click wallpaper to show desktop
      HideDesktop = false;                       # Don't hide desktop items
      StageManagerHideWidgets = false;           # Show widgets in Stage Manager
      StandardHideDesktopIcons = false;          # Show desktop icons
      StandardHideWidgets = false;               # Show widgets on desktop
    };



    # Custom application-specific preferences
    # Note: Use this only for settings not available in the standard system.defaults options above
    CustomUserPreferences = {
      # Global Preferences (system-wide)
      ".GlobalPreferences" = {
        "com.apple.mouse.tapBehavior" = 1;       # Enable tap to click globally
      };


      # Advertising and Privacy
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false; # Disable Apple ads
        allowIdentifierForAdvertising = false;     # Disable ad tracking
      };


      # AirPlay
      "com.apple.airplay" = {
        showInMenuBarIfPresent = false;          # Hide AirPlay in menu bar
      };


      # Archive Utility
      "com.apple.archiveutility" = {
        "dearchive-move-after" = "~/.Trash";     # Move archives to trash after extraction
        "dearchive-reveal-after" = true;         # Reveal extracted items
      };


      # Bluetooth Audio Agent
      "com.apple.BluetoothAudioAgent" = {
        "Apple Bitpool Min (editable)" = 40;     # Better audio quality for Bluetooth
        "Apple Initial Bitpool Min (editable)" = 40;  # Improved Bluetooth audio quality
        "Apple Initial Bitpool (editable)" = 40;      # Improved Bluetooth audio quality
        "Negotiated Bitpool" = 58;                    # Improved Bluetooth audio quality
        "Negotiated Bitpool Max" = 58;                # Improved Bluetooth audio quality
        "Negotiated Bitpool Min" = 48;                # Improved Bluetooth audio quality
      };


      # Control Center
      "com.apple.controlcenter" = {
        "NSStatusItem Visible AirDrop" = false;  # Hide AirDrop
        "NSStatusItem Visible Battery" = true;   # Show battery in menu bar
        "NSStatusItem Visible Bluetooth" = false; # Hide Bluetooth in menu bar
        "NSStatusItem Visible Clock" = true;     # Show clock
        "NSStatusItem Visible FocusModes" = false; # Hide Focus
        "NSStatusItem Visible Sound" = true;     # Show volume
        "NSStatusItem Visible WiFi" = true;      # Show WiFi
      };


      # Handoff
      "com.apple.coreservices.useractivityd" = {
        ActivityAdvertisingAllowed = true;       # Allow Handoff
        ActivityReceivingAllowed = true;         # Receive Handoff
      };


      # Crash Reporter
      "com.apple.CrashReporter" = {
        AutoSubmit = false;                      # Don't auto-submit crash reports
        DialogType = "none";                     # Disable crash reporter dialog
        UseUNC = 1;                              # Use Notification Center for crash reports
      };


      # Desktop Services and Spring Loading
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;         # No .DS_Store on network volumes
        DSDontWriteUSBStores = true;             # No .DS_Store on USB volumes
        "com.apple.springing.delay" = 0.5;       # Spring loading delay
        "com.apple.springing.enabled" = true;    # Enable spring loading for directories
      };


      # Dictionary
      "com.apple.Dictionary" = {
        ProofreadingEnabled = false;             # Disable proofreading popup
      };


      # Disk Utility
      "com.apple.DiskUtility" = {
        DUDebugMenuEnabled = true;               # Enable debug menu
        DUShowEveryPartition = true;             # Show all partitions
        SidebarShowAllDevices = true;            # Show all devices in sidebar
        advanced-image-options = true;           # Show advanced options
      };


      # Dock - Additional settings
      "com.apple.dock" = {
        "expose-group-apps" = true;              # Group windows by app
        "mru-spaces" = false;                    # Don't rearrange spaces
        springboard-hide-duration = 0;           # Disable springboard hide animation
        springboard-page-duration = 0;           # Disable springboard page animation
        springboard-show-duration = 0;           # Disable springboard show animation
      };


      # Disk Image Verification
      "com.apple.frameworks.diskimages" = {
        skip-verify = true;                      # Skip disk image verification
        skip-verify-locked = true;               # Skip locked disk verification
        skip-verify-remote = true;               # Skip remote disk verification
      };


      # Help Viewer
      "com.apple.helpviewer" = {
        DevMode = true;                          # Show Developer Mode
      };


      # Keyboard and Input
      "com.apple.HIToolbox" = {
        AppleFnUsageType = 2;  # 2 = Show Emoji & Symbols
      };


      # Image Capture - Configured in apps/system/ImageCapture.nix
      # "com.apple.ImageCapture" = { ... };


      # Location Services
      "com.apple.locationmenu" = {
        StatusBarIconEnabled = true;             # Show location icon in menu bar
      };


      # Login Window
      "com.apple.loginwindow" = {
        TALLogoutSavesState = false;             # Don't restore windows on restart
      };


      # Battery Menu
      "com.apple.menuextra.battery" = {
        ShowPercent = "YES";                     # Show battery percentage
        ShowTime = "YES";                        # Show time remaining
      };


      # AirDrop
      "com.apple.NetworkBrowser" = {
        BrowseAllInterfaces = true;              # AirDrop over Ethernet and unsupported interfaces
      };


      # Notification Center
      "com.apple.notificationcenterui" = {
        bannerTime = 5;                          # Notification banner display time (seconds)
      };


      # Energy (Performance optimization)
      "com.apple.PowerManagement" = {
        SleepDisabled = 0;                       # Allow sleep
      };


      # Print
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;             # Quit printer app when done
      };


      # Screenshot - Additional settings
      "com.apple.screencapture" = {
        location = "~/Desktop";                  # Screenshot location
        type = "png";                            # Screenshot format
      };


      # Screensaver - Additional settings
      "com.apple.screensaver" = {
        askForPassword = 1;                      # Require password after screensaver
        askForPasswordDelay = 0;                 # Require password immediately
      };


      # Software Update
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;            # Check for software updates automatically
        AutomaticDownload = 1;                   # Download updates in background
        CriticalUpdateInstall = 1;               # Install system data files and security updates
        ScheduleFrequency = 1;                   # Check for updates daily
      };


      # Spotlight
      "com.apple.spotlight" = {
        orderedItems = [
          { enabled = true; name = "APPLICATIONS"; }
          { enabled = true; name = "DIRECTORIES"; }
          { enabled = true; name = "PDF"; }
          { enabled = true; name = "SYSTEM_PREFS"; }
          { enabled = false; name = "BOOKMARKS"; }
          { enabled = false; name = "CONTACT"; }
          { enabled = false; name = "DOCUMENTS"; }
          { enabled = false; name = "EVENT_TODO"; }
          { enabled = false; name = "FONTS"; }
          { enabled = false; name = "IMAGES"; }
          { enabled = false; name = "MENU_CONVERSION"; }
          { enabled = false; name = "MENU_DEFINITION"; }
          { enabled = false; name = "MENU_EXPRESSION"; }
          { enabled = false; name = "MENU_OTHER"; }
          { enabled = false; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
          { enabled = false; name = "MENU_WEBSEARCH"; }
          { enabled = false; name = "MESSAGES"; }
          { enabled = false; name = "MOVIES"; }
          { enabled = false; name = "MUSIC"; }
          { enabled = false; name = "PRESENTATIONS"; }
          { enabled = false; name = "SOURCE"; }
          { enabled = false; name = "SPREADSHEETS"; }
        ];
      };


      # App Store automatic updates
      "com.apple.storeagent" = {
        LastUpdateCheck = 1;                     # Enable automatic update checks
      };


      # System Preferences
      "com.apple.systempreferences" = {
        NSLanguages = [ "en" ];                  # Set language preferences
        ShowAllMode = true;                      # Show all preference panes
      };


      # Time Machine
      "com.apple.TimeMachine" = {
        DoNotOfferNewDisksForBackup = true;      # Don't prompt to use new disks for Time Machine
        SkipSystemFiles = true;                  # Skip system files in backup
      };


      # Universal Control
      "com.apple.universalcontrol" = {
        Enabled = true;                          # Enable Universal Control
      };


      # Global preferences
      NSGlobalDomain = {
        AppleLanguages = [ "en-US" ];                        # System language
        AppleLocale = "en_US";                               # System locale
        AppleMiniaturizeOnDoubleClick = false;               # Don't minimize on title bar double-click (EXPERIMENTAL)
        "com.apple.mouse.scaling" = 2.5;                     # Mouse tracking speed
        "com.apple.sound.beep.flash" = 0;                    # Disable screen flash on alert
        "com.apple.sound.beep.volume" = 0.7;                 # Alert volume level
        "com.apple.swipescrolldirection" = true;             # Natural scrolling
        "com.apple.trackpad.forceClick" = true;              # Enable Force Click
        "com.apple.trackpad.scaling" = 3.0;                  # Trackpad tracking speed
        NSBrowserColumnAnimationSpeedMultiplier = 0;         # Disable Finder column animations (EXPERIMENTAL)
        NSCloseAlwaysConfirmsChanges = false;                # Don't ask to save on close if no changes
        NSDocumentRevisionsWindowTransformAnimation = 0;     # Disable document revisions animation (EXPERIMENTAL)
        NSScrollViewRubberbanding = false;                   # Disable rubber-band scrolling (EXPERIMENTAL)
        NSToolbarFullScreenAnimationDuration = 0;            # Disable toolbar full screen animation (EXPERIMENTAL)
        QLPanelAnimationDuration = 0;                        # Disable Quick Look animations (EXPERIMENTAL)
        TSMLanguageIndicatorEnabled = false;                 # Hide language indicator
        WebAutomaticSpellingCorrectionEnabled = false;       # Disable auto-correct in web views
        WebKitDeveloperExtras = true;                        # Add context menu item for Web Inspector
      };
    };
  };



  # ============================================================================
  # Firewall Configuration
  # ============================================================================
  networking.applicationFirewall = {
    enable = true;                           # Enable firewall
    allowSigned = true;                      # Allow signed apps
    enableStealthMode = true;                # Enable stealth mode
  };



  # ============================================================================
  # Networking
  # ============================================================================
  networking.hostName = "Ks-Mac";            # Set hostname
  networking.computerName = "K's Mac";       # Set computer name



  # ============================================================================
  # Environment Variables
  # ============================================================================
  environment.variables = {
    EDITOR = "nano";                         # Default editor
    VISUAL = "code";                         # Visual editor
  };



  # ============================================================================
  # System Startup
  # ============================================================================
  system.startup.chime = false;              # Disable startup chime


  # ============================================================================
  # Security and Authentication
  # ============================================================================
  security.pam.services.sudo_local.touchIdAuth = true;  # Enable Touch ID for sudo



  # ============================================================================
  # Shell Configuration
  # ============================================================================
  programs.zsh.enable = true;                  # Enable zsh



  # ============================================================================
  # User Configuration
  # ============================================================================
  users.users.k = {
    name = "k";
    home = "/Users/k";
    shell = pkgs.zsh;                        # Set default shell to zsh
  };
}