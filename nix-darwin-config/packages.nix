{ pkgs, ... }:
{
  # ============================================================================
  # System Packages - CLI tools and development packages managed by Nix
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Editor and version control
    vim
    git

    # Nix code formatting in IDE's
    nixfmt

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
    tree

    # Documentation and package management
    pandoc
    pipx

    # Zsh plugins
    zsh-autosuggestions # Fish-style ghost-text history suggestions
    zsh-syntax-highlighting # Live command coloring (green/red as you type)

    # Unstable packages (example usage)
    # unstable.package-name
  ];

  # ============================================================================
  # Zsh — enable with compinit + plugins
  # ============================================================================
  programs.zsh = {
    enable = true; # activates compinit and sets zsh as default shell
    enableCompletion = true; # initialises compinit (tab-completion)
    # Source plugins installed via Nix into every zsh session
    interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      # Accept ghost-text suggestion with → arrow key
      bindkey '^[[C' autosuggest-accept
    '';
  };

  # ============================================================================
  # Fonts - Additional fonts beyond macOS defaults
  # ============================================================================
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono # JetBrains Mono with icons
    pkgs.nerd-fonts.fira-code # Fira Code with icons
  ];

}
