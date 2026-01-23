{
  description = "K's Mac nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, nix-homebrew }: 
  let
    system = "aarch64-darwin";
    user = "k"; # Defined once here for consistency
  in
  {
    darwinConfigurations."Ks-Mac" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [ 
        ./dock-apps.nix
        ./homebrew-mas.nix
        ./login-items.nix
        ./packages.nix
        ./system-settings.nix
        
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "${user}";
            autoMigrate = true;
          };
        }
        
        ({ ... }: {
          # 1. AUTOMATED HOMEBREW PASSWORDS
          # This allows the 'brew' binary to run as root without a password prompt
          environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
            ${user} ALL=(ALL) NOPASSWD: /opt/homebrew/bin/brew, /usr/local/bin/brew
          '';

          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
          
          nix.enable = false; # Managed by Determinate Systems
          
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        })
      ];
    };
  };
}
