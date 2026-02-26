{ pkgs, ... }:
{
  # ── Apple Silicon-specific settings ──────────────────────────────────────────

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix-homebrew = {
    enable        = true;
    enableRosetta = true;
    user          = "k";
    autoMigrate   = true;
  };

  environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
    k ALL=(ALL) NOPASSWD: /opt/homebrew/bin/brew
  '';

  nix.enable = false;

  # ── ARM-specific Casks ──────────────────────────────────────────────────────
  homebrew.casks = [
    "calibre"                              # E-book library management
    "cursor"                               # Code editor with AI assistance
    "conductor"                            # AI-powered file manager
    "discord"                              # Voice, video, and text chat
    "figma"                                # Vector graphics editor
    "imageoptim"                           # Image optimization tool
    "karabiner-elements"                   # Keyboard customization tool
    "kiro"                                 # Amazon AI IDE
    "microsoft-edge"                       # Microsoft's Chromium browser
    "microsoft-teams"                      # Communication platform
    "netnewswire"                          # RSS reader
    "notion"                               # All-in-one workspace
    "nvidia-geforce-now"                   # Cloud gaming service
    "reflex-app"                           # Universal Music Control
    "telegram"                             # Messaging app
    "thebrowsercompany-dia"                # The Browser Company's Dia
    "warp"                                 # Modern AI-powered terminal
  ];

  # ── ARM-specific MAS Apps ───────────────────────────────────────────────────
  homebrew.masApps = {
    "Brother iPrint&Scan" = 1193539993;    # Brother printer app
    "Equinox"             = 1591510203;    # Dynamic wallpapers
    "finanzblick"         = 993109868;     # Banking app
    "Flow"                = 1423210932;    # Pomodoro timer
    "Goodnotes"           = 1444383602;    # Note-taking app
    "Microsoft OneNote"   = 784801555;     # Note-taking
    "Shazam"              = 897118787;     # Music identifier
    "Video Converter"     = 1518836004;    # Video converter
  };

  # ── ARM-specific Nix packages ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
  ];
}
