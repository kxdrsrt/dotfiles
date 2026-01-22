{
  description = "K's Mac nix-darwin configuration";



  inputs = {
    # Nix packages and nix-darwin
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };



  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable }: 
  let
    system = "aarch64-darwin";
  in
  {
    # ============================================================================
    # System Configuration
    # ============================================================================
    darwinConfigurations."Ks-Mac" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [ 
        # ./home.nix # Unused since using dotfiles for home-management
        ./dock-apps.nix
        ./homebrew-mas.nix
        ./login-items.nix
        ./packages.nix
        ./system-settings.nix
        
        ({ ... }: {
          # Overlay for accessing unstable packages
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
          
          # Let Determinate Systems manage Nix installation
          nix.enable = false;
          
          # System metadata
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        })
      ];
    };
  };
}
