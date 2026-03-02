{ pkgs, user, ... }:
{
  # Basic home-manager settings
  home.stateVersion = "23.11";
  home.username = user;
  home.homeDirectory = "/Users/${user}";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Example: Git configuration
  programs.git = {
    enable = true;
    userName = "kxdrsrt";
    userEmail = "kadir.sert@pm.me";
  };

  # Example: Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "ls -la";
      update = "darwin-rebuild switch --flake ~/.config/nix-darwin";
    };

    initExtra = ''
      # Your custom zsh config here
    '';
  };

  # User packages (separate from system packages)
  home.packages = with pkgs; [
    # Add user-specific packages here
    # ripgrep
    # fzf
  ];

  # Manage dotfiles directly
  home.file = {
    # Example: Copy a config file
    # ".config/myapp/config.toml".text = ''
    #   key = "value"
    # '';
  };
}
