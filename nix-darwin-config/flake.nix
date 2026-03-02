{
  description = "Nix-darwin configuration — fully dynamic";

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
      # ── Runtime detection (requires --impure; set by redeploy.sh / bootstrap.sh) ─
      currentUser = builtins.getEnv "NIXDARWIN_USER";
      currentArch = builtins.getEnv "NIXDARWIN_ARCH";
      currentSystem = if currentArch == "arm64" then "aarch64-darwin" else "x86_64-darwin";

      # ── Derived helpers ────────────────────────────────────────────────────
      isARM = currentSystem == "aarch64-darwin"; # true on Apple Silicon (M-series), false on Intel
      brewPath = if isARM then "/opt/homebrew/bin/brew" else "/usr/local/bin/brew";
      # Determinate Nix (ARM) manages its own daemon → nix.enable = false
      # Vanilla Nix (Intel) needs nix-darwin to manage it → nix.enable = true
      nixEnabled = !isARM;

      # ── Shared Modules ───────────────────────────────────────────────────────
      # Modules applied to every host. Host-specific overrides
      # (dock apps, extra casks, etc.) live in hosts/<hostname>.nix.
      sharedModules = [
        ./apps/default.nix # Default app set (e.g. browsers, communication, media)
        #./home.nix # Home Manager config for user-level packages and settings
        ./homebrew-mas-global.nix # Global Homebrew configuration for GUI apps and Mac App Store
        ./keyboard-shortcuts.nix # Custom keyboard shortcuts
        ./packages.nix # System-level packages (e.g. command-line tools, daemons)
        ./spotx.nix # SpotX — custom Spotify patch with enhanced features
        ./system-settings.nix # Custom system settings (e.g. trackpad, mouse, display)

        # nix-homebrew base module — per-host configuration is generated below
        nix-homebrew.darwinModules.nix-homebrew
      ];

      # ── Host Profiles ──────────────────────────────────────────────────────
      # Only host-SPECIFIC knobs live here. User, architecture, Homebrew path,
      # Rosetta, and nix.enable are detected automatically by the deploy script.
      #   deviceType   – device model label (e.g. "Mac", "iMac", "MacBook Pro")
      #                  combined with username → hostLabel = "{user}'s {deviceType}"
      #   extraModules – optional additional Nix modules
      hosts = {
        "Ks-Mac" = {
          deviceType = "Mac";
        };
        "iMac" = {
          deviceType = "iMac";
        };
        "MacBookPro" = {
          deviceType = "MacBook Pro";
        };
      };

      # ── mkHost Helper ─────────────────────────────────────────────────────────
      mkHost =
        hostname:
        {
          deviceType,
          extraModules ? [ ],
        }:
        let
          hostLabel = "${currentUser}'s ${deviceType}";
        in
        nix-darwin.lib.darwinSystem {
          system = currentSystem;
          specialArgs = {
            user = currentUser;
            inherit hostname hostLabel;
          };
          modules =
            sharedModules
            ++ extraModules
            ++ [
              # Host-specific settings (dock apps, extra casks …)
              ./hosts/${hostname}.nix

              # Platform, Homebrew, Nix daemon, overlays — all auto-derived
              (
                { lib, ... }:
                {
                  nixpkgs.hostPlatform = currentSystem;

                  nix-homebrew = {
                    enable = true;
                    enableRosetta = isARM;
                    user = currentUser;
                    autoMigrate = true;
                  };

                  environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
                    ${currentUser} ALL=(ALL) NOPASSWD: ${brewPath}
                  '';

                  nix.enable = nixEnabled;
                  nix.settings.experimental-features = lib.mkIf nixEnabled [
                    "nix-command"
                    "flakes"
                  ];

                  # nixpkgs-unstable overlay — makes pkgs.unstable.* available everywhere
                  nixpkgs.overlays = [
                    (final: prev: {
                      unstable = import nixpkgs-unstable {
                        system = currentSystem;
                        config.allowUnfree = true;
                      };
                    })
                  ];

                  system.configurationRevision = self.rev or self.dirtyRev or null;
                  system.stateVersion = 6;
                }
              )
            ];
        };

    in
    {
      darwinConfigurations = builtins.mapAttrs mkHost hosts;
    };
}
