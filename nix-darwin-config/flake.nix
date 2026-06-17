{
  description = "Nix-darwin configuration — fully dynamic";

  # Inputs: external flakes used by this configuration.
  inputs = {
    # Unstable channel — matches nix-darwin master branch.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nixpkgs 25.11 for Intel Macs — modern nixpkgs-unstable packages target
    # macOS 14+ and crash on Ventura (13) / OCLP installs, so Intel hosts pin a
    # released stable channel. NOTE: verify on the Intel host before deploying —
    # if 25.11 also requires macOS 14+, fall back to nixpkgs-25.05-darwin.
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    # nix-darwin provides the darwinSystem helper used to build a macOS config.
    # nix-darwin's branch MUST match the nixpkgs branch it is built against:
    #   master           ↔ nixpkgs-unstable        (ARM hosts)
    #   nix-darwin-25.11 ↔ nixpkgs-25.11-darwin    (Intel hosts)
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Release-matched nix-darwin for Intel hosts pinned to the stable channel.
    nix-darwin-stable.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    # Home Manager — user-level packages and dotfiles. Pinned to the stable
    # release so its modules match. Wiring is in place (see home.nix); enable it
    # later by uncommenting ./home.nix in sharedModules below.
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Optional helper to integrate Homebrew packages via Nix
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Expose brew-src as a direct input so we can update it independently
    # with `nix flake update brew-src` when a new macOS version is released
    # and nix-homebrew's own pinned copy is too old to recognise it.
    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };
    nix-homebrew.inputs.brew-src.follows = "brew-src";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-darwin-stable,
      nixpkgs,
      nixpkgs-stable,
      nix-homebrew,
      brew-src,
      home-manager,
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
      # nixpkgs-unstable packages target macOS 14+; Intel hosts on Ventura need 25.11
      pkgsSource = if isARM then nixpkgs else nixpkgs-stable;
      # nix-darwin branch must match the nixpkgs branch (see inputs above)
      darwinSystem = if isARM then nix-darwin.lib.darwinSystem else nix-darwin-stable.lib.darwinSystem;

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

        # Home Manager — module is loaded but inert (no users configured yet).
        # To enable user-level config from ./home.nix later, uncomment the
        # home-manager wiring block in the inline module inside mkHost below.
        home-manager.darwinModules.home-manager
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
        darwinSystem {
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
                  # ARM → nixpkgs-unstable; Intel → nixpkgs-25.11 (released stable)
                  nixpkgs.pkgs = import pkgsSource {
                    system = currentSystem;
                    config.allowUnfree = true;
                  };

                  nix-homebrew = {
                    enable = true;
                    enableRosetta = false;
                    user = currentUser;
                    autoMigrate = true;
                  };

                  environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
                    ${currentUser} ALL=(ALL) NOPASSWD: ${brewPath}
                  '';

                  # Ensure ARM Homebrew (/opt/homebrew) takes precedence over any
                  # residual Intel Homebrew installation at /usr/local.
                  environment.systemPath = lib.optionals isARM [
                    "/opt/homebrew/bin"
                    "/opt/homebrew/sbin"
                  ];

                  nix.enable = nixEnabled;
                  nix.settings.experimental-features = lib.mkIf nixEnabled [
                    "nix-command"
                    "flakes"
                  ];

                  # ── Home Manager (ready to enable) ─────────────────────────
                  # Uncomment this block to activate user-level config from
                  # ./home.nix. The home-manager.darwinModules module is already
                  # loaded in sharedModules above.
                  # home-manager.useGlobalPkgs = true;
                  # home-manager.useUserPackages = true;
                  # home-manager.extraSpecialArgs = { user = currentUser; };
                  # home-manager.users.${currentUser} = import ./home.nix;

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
