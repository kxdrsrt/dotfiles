{ pkgs, ... }: {
  # ============================================================================
  # System Packages - CLI tools and development packages managed by Nix
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Editor and version control
    vim
    git

    # Nix code formatting in IDE's
    nixpkgs-fmt
    
    # Network utilities
    wget
    aria2
    inetutils
    speedtest-cli
    
    # Media tools
    exiftool
    ffmpeg
    imagemagick
    yt-dlp
    tesseract
    
    # System utilities
    fastfetch
    coreutils
    
    # Development tools
    deno
    nodejs
    python3
    cmake
    ninja
    ccache
    
    # Documentation and package management
    pandoc
    pipx
    mas
    
    # Unstable packages (example usage)
    # unstable.package-name
  ];


  # ============================================================================
  # Fonts - Additional fonts beyond macOS defaults
  # ============================================================================
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono           # JetBrains Mono with icons
    pkgs.nerd-fonts.fira-code                # Fira Code with icons
  ];


  # ============================================================================
  # Nix Configuration
  # ============================================================================
  nix.settings.experimental-features = "nix-command flakes";

  # Optimize nix store automatically
  nix.settings.auto-optimise-store = true;


  # Allow proprietary packages from nixpkgs
  nixpkgs.config.allowUnfree = true;
}
