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

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, nix-homebrew }:
  let
    # ── Gemeinsame Module ─────────────────────────────────────────────────────
    # Alle Module, die auf jedem Host gelten. Host-spezifische Abweichungen
    # (Plattform, Homebrew-Pfad usw.) stehen in hosts/<hostname>.nix.
    sharedModules = [
      ./dock-apps.nix
      ./homebrew-mas.nix
      ./login-items.nix
      ./packages.nix
      ./keyboard-shortcuts.nix
      ./spotx.nix
      ./apps/default.nix
      ./system-settings.nix

      # nix-homebrew Basismodul – Konfiguration erfolgt pro Host
      nix-homebrew.darwinModules.nix-homebrew
    ];

    # ── mkHost-Helper ─────────────────────────────────────────────────────────
    # Baut eine darwinSystem-Konfiguration aus:
    #   system   – "aarch64-darwin" | "x86_64-darwin"
    #   hostname – Name der Host-Datei unter hosts/<hostname>.nix
    #   user     – lokaler macOS-Benutzername (wird als specialArg weitergereicht)
    mkHost = { system, hostname, user }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit user; };
        modules = sharedModules ++ [

          # Host-spezifische Einstellungen (Plattform, Homebrew-Pfad, Rosetta …)
          ./hosts/${hostname}.nix

          # Gemeinsame Overlays + System-Metadaten
          ({ ... }: {
            # nixpkgs-unstable Overlay, damit pkgs.unstable.* überall verfügbar ist
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];

            # Determinate Systems verwaltet den Nix-Daemon extern
            nix.enable = false;

            system.configurationRevision = self.rev or self.dirtyRev or null;
            system.stateVersion = 6;
          })
        ];
      };

  in
  {
    darwinConfigurations = {

      # ── Apple-Silicon MacBook ────────────────────────────────────────────────
      "Ks-Mac" = mkHost {
        system   = "aarch64-darwin";
        hostname = "Ks-Mac";
        user     = "k";
      };

      # ── Intel iMac ───────────────────────────────────────────────────────────
      # Für jeden weiteren Intel-Host: Eintrag hier duplizieren und
      # hosts/<neuer-hostname>.nix von hosts/iMac.nix ableiten.
      "iMac" = mkHost {
        system   = "x86_64-darwin";
        hostname = "iMac";
        user     = "GRAVITY";
      };

    };
  };
}
