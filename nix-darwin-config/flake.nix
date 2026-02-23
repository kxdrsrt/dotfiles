{
  description = "K's Mac nix-darwin configuration";

  # Inputs: external flakes used by this configuration.
  inputs = {
    # Unstable channel — matches nix-darwin master branch.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Unstable channel imported as an overlay for bleeding-edge packages.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin provides the darwinSystem helper used to build a macOS config
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; # follow the same nixpkgs input

    # Optional helper to integrate Homebrew packages via Nix
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  # `outputs` builds the darwin configuration. We capture commonly used
  # values in `let` so they can be referenced multiple times below.
  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, nix-homebrew }:
  let
    system = "aarch64-darwin"; # target platform (Apple Silicon)
    user = "k";                # local username used by some modules
  in
  {
    # Top-level darwin configuration for the machine named "Ks-Mac".
    darwinConfigurations."Ks-Mac" = nix-darwin.lib.darwinSystem {
      inherit system;

      # `modules` composes your configuration from small files and expressions.
      modules = [
        # UI and dock settings for apps
        ./dock-apps.nix

        # Settings for MAS/Homebrew GUI apps
        ./homebrew-mas.nix

        # Login items and autostart configuration
        ./login-items.nix

        # User-level package and utility selections
        ./packages.nix

        # Keyboard shortcuts configuration
        ./keyboard-shortcuts.nix

        # Home manager configuration (Currently not used due to GitHub Dotfiles management)
        # ./home.nix

        # SpotX - Spotify adblocker configuration
        ./spotx.nix

        # Central place to include all app configs (third-party and system)
        # ./apps/default.nix already imports ./apps/system via ./system
        ./apps/default.nix

        # System-wide settings like defaults and preferences
        ./system-settings.nix

        # Integrate the nix-homebrew module to manage Homebrew via Nix
        nix-homebrew.darwinModules.nix-homebrew

        # Inline override for nix-homebrew module options
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;      # don't auto-enable Rosetta for brew
            user = "${user}";         # which user owns the Homebrew setup
            autoMigrate = true;         # migrate existing brew installs when possible
          };
        }

        # Arbitrary inline module for special system tweaks and overlays
        ({ ... }: {
          # 1. Allow brew to run without sudo password for the given user.
          #    This writes a sudoers fragment into /etc via Nix (be cautious).
          environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
            ${user} ALL=(ALL) NOPASSWD: /opt/homebrew/bin/brew, /usr/local/bin/brew
          '';

          # 2. Add a nixpkgs overlay named `unstable` that imports the
          #    `nixpkgs-unstable` input; useful to access bleeding-edge packages.
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true; # allow unfree packages in this overlay
              };
            })
          ];

          # 3. Disable the Nix service here because it's managed elsewhere
          #    (Determinate Systems manages Nix on this host).
          nix.enable = false;

          # Metadata fields used at build/deploy time
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        })
      ];
    };
  };
}
