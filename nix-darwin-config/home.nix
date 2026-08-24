{ pkgs, user, ... }:
# home-manager is configured but not yet activated — run `darwin-rebuild switch` to enable
{
  # Basic home-manager settings
  home.stateVersion = "25.11";
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
      update = "darwin-rebuild switch --flake ~/nix-darwin-config";
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

  home.file = {
    # watermarks-remover LaunchAgent — auto-starts service on port 8765 at login
    "Library/LaunchAgents/com.watermarks-remover.server.plist".source =
      ./vscode-prompts/com.watermarks-remover.server.plist;

    # VS Code settings (chat.promptFilesLocations points at ./vscode-prompts/)
    # Uncomment when you activate home-manager:
    # "Library/Application Support/Code/User/settings.json".source =
    #   ./vscode-prompts/vscode-settings.json;
  };
}
