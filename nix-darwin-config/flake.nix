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
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Optional helper to integrate Homebrew packages via Nix
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-unstable,
      nix-homebrew,
    }:
    let
      # ── Shared Modules ───────────────────────────────────────────────────────
      # Modules applied to every host. Host-specific overrides
      # (platform, Homebrew path, etc.) live in hosts/<hostname>.nix.
      sharedModules = [
        # dock-apps.nix is NOT loaded globally —
        # each host imports it explicitly (or defines its own dock apps)
        ./homebrew-mas.nix
        ./login-items.nix
        ./packages.nix
        ./keyboard-shortcuts.nix
        ./spotx.nix
        ./apps/default.nix
        ./system-settings.nix

        # nix-homebrew base module — per-host configuration in hosts/<hostname>.nix
        nix-homebrew.darwinModules.nix-homebrew
      ];

      # ── mkHost Helper ─────────────────────────────────────────────────────────
      # Builds a darwinSystem configuration from:
      #   system    – "aarch64-darwin" | "x86_64-darwin"
      #   hostname  – filename under hosts/<hostname>.nix
      #   hostLabel – human-readable device name (login screen, SMB, computerName)
      #   user      – local macOS username (passed through as specialArg)
      mkHost =
        {
          system,
          hostname,
          hostLabel,
          user,
          extraModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit user hostname hostLabel; };
          modules =
            sharedModules
            ++ extraModules
            ++ [

              # Host-specific settings (platform, Homebrew path, Rosetta …)
              ./hosts/${hostname}.nix

              # Shared overlays + system metadata
              (
                { ... }:
                {
                  # nixpkgs-unstable overlay — makes pkgs.unstable.* available everywhere
                  nixpkgs.overlays = [
                    (final: prev: {
                      unstable = import nixpkgs-unstable {
                        inherit system;
                        config.allowUnfree = true;
                      };
                    })
                  ];

                  # nix.enable is set per host:
                  #   Ks-Mac (Determinate): false  — Determinate manages the daemon
                  #   iMac   (vanilla Nix): true   — nix-darwin manages the daemon

                  system.configurationRevision = self.rev or self.dirtyRev or null;
                  system.stateVersion = 6;
                }
              )
            ];
        };

    in
    {
      darwinConfigurations = {

        # ── Apple-Silicon MacBook ────────────────────────────────────────────────
        "Ks-Mac" = mkHost {
          system = "aarch64-darwin";
          hostname = "Ks-Mac";
          hostLabel = "K's Mac";
          user = "k";
          extraModules = [ ./dock-apps.nix ];
        };

        # ── Intel iMac ───────────────────────────────────────────────────────────
        # To add another Intel host: duplicate this entry and
        # derive hosts/<new-hostname>.nix from hosts/iMac.nix.
        "iMac" = mkHost {
          system = "x86_64-darwin";
          hostname = "iMac";
          hostLabel = "iMac";
          user = "GRAVITY";
        };

      };
    };
}
