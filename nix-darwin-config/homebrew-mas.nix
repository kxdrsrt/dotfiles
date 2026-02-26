{ ... }:
{
  # ============================================================================
  # Homebrew Configuration — GUI apps and Mac App Store
  # Host-specific additions live in hosts/<hostname>.nix
  # ============================================================================
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap"; # Remove packages not in flake
  homebrew.onActivation.upgrade = true; # Auto-upgrade on rebuild

  homebrew.caskArgs = {
    no_quarantine = true; # Avoid "damaged app" warnings for unsigned apps
  };

  homebrew.brews = [
    "mas" # Mac App Store CLI
  ];

  # ── Global Casks ─ only uncommented entries are active on every host ────────────────────────────────
  # Commented-out entries are either host-specific (→ hosts/*.nix) or optional
  homebrew.casks = [
    # "alcove"                                # Dynamic Island for macOS
    # "altserver"                             # Server to sideload iOS apps
    # "android-file-transfer"                  # File transfer for Android devices
    # "anki"                                  # Flashcard learning app
    "appcleaner" # Thorough uninstaller
    # "audiate"                               # Audio transcription and editing with AI
    "betterdisplay" # Advanced display management
    # "blender"                               # Open-source 3D creation suite
    # "canva"                                 # Web-based graphic design tool
    # "chatbox"                               # All-in-one AI assistant client
    # "chatgpt"                               # Desktop client for ChatGPT
    "coconutbattery" # Battery monitoring tool
    "deepl" # AI-powered translation tool
    # "diffusionbee"                          # GUI for Stable Diffusion on Apple Silicon
    # "displaylink"                           # Drivers for USB displays
    # "framer"                                # Interactive design prototyping tool
    "google-chrome" # Google's web browser
    # "google-drive"                          # Cloud storage sync
    # "handbrake"                             # Video transcoder
    "iina" # Modern media player for macOS
    # "iptvnator"                             # IPTV player
    # "jan"                                   # Local AI assistant
    # "kap"                                   # Minimal Screen recorder
    # "linearmouse"                           # Mouse and trackpad customization
    # "mac-mouse-fix"                          # Mouse customization utility
    # "macwhisper"                            # Audio transcription tool
    # "malwarebytes"                          # Anti-malware software
    # "mathpix-snipping-tool"                 # OCR tool for math equations
    # "mem"                                   # AI-powered note-taking
    "microsoft-auto-update" # Microsoft app updater
    "microsoft-office" # Office productivity suite
    "mos" # Smooth scrolling utility
    # "netspot"                               # WiFi analyzer
    # "nook"                                  # Minimal WebKit browser (beta)
    # "obs"                                   # Streaming and recording software
    # "opencore-patcher"                      # macOS patcher for unsupported Macs
    # "openvpn-connect"                       # VPN client
    "pearcleaner" # Advanced Mac cleaner
    "qbittorrent" # BitTorrent client
    # "quickwhisper"                          # Quick voice transcription
    "raycast" # Productivity launcher
    "rectangle" # Window management tool
    "rustdesk" # Remote desktop software
    "shottr" # Screenshot tool
    "spotify" # Music streaming service
    # "steam"                                 # Gaming platform
    "the-unarchiver" # Archive extraction utility
    "visual-studio-code" # Source code editor
    "whatsapp" # Messaging app
    # "zoom"                                  # Video conferencing
  ];

  # ── Global MAS Apps ─ only uncommented entries are active on every host ─────────────────────────────
  # Commented-out entries are either host-specific (→ hosts/*.nix) or optional
  homebrew.masApps = {
    # "1Blocker"              = 1365531024;   # Safari ad blocker
    # "Accelerate"            = 1459809092;   # Download manager
    # "AdGuard for Safari"    = 1440147259;   # Safari ad blocker
    "Apple Configurator" = 1037126344; # iOS device manager
    # "Auto HD FPS for YouTube" = 1546729687; # Auto HD YouTube
    # "Bakery"                = 1575220747;   # Icon generator
    # "Compressor"            = 424390742;    # Video encoder
    # "Developer"             = 640199958;    # Apple dev news
    # "Final Cut Pro"         = 424389933;    # Video editor
    # "Fullifier"             = 1532642909;    # Safari fullscreen video
    # "HP Smart"              = 1474276998;   # HP printer app
    "Hush" = 1544743900; # Block cookie popups
    # "Instapaper"            = 288545208;    # Read-it-later
    # "Keynote"               = 409183694;    # Apple presentations
    # "Kompressor"            = 6468196574;   # File compressor
    # "Mactracker"            = 430255202;    # Apple hardware database
    # "Mockview"              = 1592728145;   # Device mockup tool
    # "Motion"                = 434290957;    # Motion graphics
    # "Numbers"               = 409203825;    # Apple spreadsheets
    # "Pages"                 = 409201541;    # Apple word processor
    # "Perplexity"            = 6714467650;   # AI search engine
    # "PiPifier"              = 1160374471;    # Picture-in-Picture
    # "Planmore"              = 1613129298;   # Day planner
    # "Proton Pass"           = 6502835663;   # Password manager
    # "Scan Thing"            = 1556313108;   # Document scanner
    # "Shoop"                 = 1568244961;   # AI photo editor
    # "SongShift"             = 1097974566;   # Playlist transfer
    # "Structured"            = 1499198946;   # Visual planner
    # "TestFlight"            = 899247664;    # Beta testing
    # "The Unarchiver"        = 425424353;    # Archive extractor
    "uBlock Origin Lite" = 6745342698; # Safari ad blocker
    "Video Speed Controller" = 1588368612; # Video speed control
    # "VPN.lat"               = 1526622816;   # VPN client
    "Windows App" = 1295203466; # Remote Desktop / RDP
    # "Xcode"                 = 497799835;    # Apple IDE
  };
}
