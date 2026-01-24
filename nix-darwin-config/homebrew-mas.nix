{ ... }: {
  # ============================================================================
  # Homebrew Configuration - GUI apps and Mac App Store
  # ============================================================================
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";  # Remove packages not in flake
  homebrew.onActivation.upgrade = true;   # Auto-upgrade on rebuild

  homebrew.caskArgs = {
    no_quarantine = true;
  };

  homebrew.brews = [
      "mas"                               # Mac App Store CLI, managed outside of Nix          
    ];

  # GUI Applications via Homebrew Casks
  homebrew.casks = [
    "alcove"                               # Dynamic Island for macOS
    "altserver"                            # Server to sideload iOS apps
    # "android-file-transfer"                # File transfer for Android devices
    # "anki"                                 # Flashcard learning app
    "appcleaner"                           # Thorough uninstaller
    # "arc"                                  # Innovative browser with built-in tools
    # "audiate"                            # Audio transcription and editing with AI
    "betterdisplay"                        # Advanced display management
    # "blender"                            # Open-source 3D creation suite
    # "cakebrew"                           # GUI for Homebrew management
    "calibre"                              # E-book library management
    # "canva"                              # Web-based graphic design tool
    # "chatgpt"                            # Desktop client for ChatGPT
    # "chatbox"                              # All-in-one AI assistant client
    "coconutbattery"                       # Battery monitoring tool
    "cursor"                               # Code editor with AI assistance
    "deepl"                                # AI-powered translation tool
    # "diffusionbee"                       # GUI for Stable Diffusion on Apple Silicon
    "discord"                              # Voice, video, and text chat
    # "displaylink"                        # Drivers for USB displays
    "figma"                                # Vector graphics editor
    # "framer"                               # Interactive design prototyping tool
    # "google-chrome"                        # Google's web browser
    # "google-drive"                       # Cloud storage sync
    # "handbrake"                          # Video transcoder
    "iina"                                 # Modern media player for macOS
    "imageoptim"                           # Image optimization tool
    # "iptvnator"                          # IPTV player
    # "jan"                                  # Local AI assistant
    # "jordanbaird-ice"                    # Menu bar customization tool
    # "kap"                                  # Screen recorder
    "karabiner-elements"                   # Keyboard customization tool
    "kiro"                                 # Amazon AI IDE
    # "linearmouse"                        # Mouse and trackpad customization
    # "mac-mouse-fix"                        # Mouse customization utility
    # "macwhisper"                           # Audio transcription tool
    # "malwarebytes"                         # Anti-malware software
    # "mathpix-snipping-tool"                # OCR tool for math equations
    # "mem"                                # AI-powered note-taking
    "microsoft-auto-update"                # Microsoft app updater
    "microsoft-edge"                       # Microsoft's Chromium browser
    "microsoft-office"                     # Office productivity suite
    "microsoft-teams"                      # Communication platform
    "mos"                                  # Smooth scrolling utility
    "netnewswire"                          # RSS reader
    #"netspot"                              # WiFi analyzer
    # "nook"                                 # Minimal WebKit browser (beta)
    "notion"                               # All-in-one workspace
    "nvidia-geforce-now"                   # Cloud gaming service
    # "obs"                                  # Streaming and recording software
    # "opencore-patcher"                     # macOS patcher for unsupported Macs
    # "openvpn-connect"                      # VPN client
    "pearcleaner"                          # Advanced Mac cleaner
    "qbittorrent"                          # BitTorrent client
    # "quickwhisper"                         # Quick voice transcription
    "raycast"                              # Productivity launcher
    "rectangle"                            # Window management tool
    "reflex-app"                           # Universal Music Control with buttons
    "rustdesk"                             # Remote desktop software
    "shottr"                               # Screenshot tool
    "spotify"  # Music streaming service
   # "steam"                                # Gaming platform
    "telegram"                             # Messaging app
    "the-unarchiver"                       # Archive extraction utility
    "thebrowsercompany-dia"                # The Browser Company's Dia
    "visual-studio-code"                   # Source code editor
    "warp"                                 # Modern AI-powered terminal
    "whatsapp"                             # Messaging app
    # "zoom"                                 # Video conferencing
  ];

  # Mac App Store Applications
  homebrew.masApps = {
    # "1Blocker" = 1365531024;                 # Safari ad blocker
    # "Accelerate" = 1459809092;               # Download manager
    # "AdGuard for Safari" = 1440147259;       # Safari ad blocker
    "Apple Configurator" = 1037126344;       # iOS device manager
    # "Auto HD FPS for YouTube" = 1546729687;   # Auto HD YouTube
    # "Bakery" = 1575220747;                   # Icon generator
    "Brother iPrint&Scan" = 1193539993;      # Brother printer app
    # "Compressor" = 424390742;                # Video encoder
    # "Developer" = 640199958;                 # Apple dev news
    "Equinox" = 1591510203;                  # Dynamic wallpapers
    # "Final Cut Pro" = 424389933;             # Video editor
    "finanzblick" = 993109868;               # Banking app
    "Flow" = 1423210932;                     # Pomodoro timer
    # "Fullifier" = 1532642909;                # Safari fullscreen video
    "Goodnotes" = 1444383602;                # Note-taking app
    # "HP Smart" = 1474276998;                 # HP printer app
    "Hush" = 1544743900;                     # Block cookie popups
    # "Instapaper" = 288545208;                # Read-it-later
    # "Keynote" = 409183694;                   # Apple presentations
    # "Kompressor" = 6468196574;               # File compressor
    # "Mactracker" = 430255202;                # Apple hardware database
    "Microsoft OneNote" = 784801555;         # Note-taking
    # "Mockview" = 1592728145;                 # Device mockup tool
    # "Motion" = 434290957;                    # Motion graphics
    # "Numbers" = 409203825;                   # Apple spreadsheets
    # "Pages" = 409201541;                     # Apple word processor
    # "Perplexity" = 6714467650;               # AI search engine
    # "PiPifier" = 1160374471;                 # Picture-in-Picture
    # "Planmore" = 1613129298;                 # Day planner
    # "Proton Pass" = 6502835663;              # Password manager
    # "Scan Thing" = 1556313108;               # Document scanner
    "Shazam" = 897118787;                    # Music identifier
    # "Shoop" = 1568244961;                    # AI photo editor
    # "SongShift" = 1097974566;                # Playlist transfer
    # "Structured" = 1499198946;               # Visual planner
    # "TestFlight" = 899247664;                # Beta testing
    # "The Unarchiver" = 425424353;            # Archive extractor
    "uBlock Origin Lite" = 6745342698;       # Safari ad blocker
    "Video Converter" = 1518836004;          # Video converter
    "Video Speed Controller" = 1588368612;   # Video speed control
    # "VPN.lat" = 1526622816;                  # VPN client
    "Windows App" = 1295203466;              # Remote Desktop
    # "Xcode" = 497799835;                     # Apple IDE
  };
}
