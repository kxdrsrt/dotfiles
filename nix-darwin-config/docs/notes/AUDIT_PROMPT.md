# Nix-Darwin Configuration Deep Audit Prompt

> **Target Model:** Claude Opus 4.6
> **Purpose:** Comprehensive audit of a multi-host nix-darwin setup with actionable fix list
> **Date Generated:** 2025-05-25

---

## Instructions for Claude

You are auditing a nix-darwin configuration that manages 3 macOS hosts (1 Apple Silicon, 2 Intel) from a single flake. Perform a deep, critical audit covering correctness, security, maintainability, idempotency, and best practices. Produce a prioritized master TODO list at the end.

---

## Configuration Overview

```
nix-darwin-config/
├── flake.nix                    # Dynamic flake with --impure env var detection
├── flake.lock                   # Pinned inputs (nixpkgs-unstable, nixpkgs-24.11, nix-darwin, nix-homebrew)
├── home.nix                     # Home Manager config (COMMENTED OUT in sharedModules)
├── homebrew-mas-global.nix      # Global Homebrew casks + Mac App Store apps
├── keyboard-shortcuts.nix       # Symbolic hotkey overrides
├── packages.nix                 # System-level Nix packages + fonts
├── spotx.nix                    # Activation script: patches Spotify with SpotX (curls remote script)
├── system-settings.nix          # macOS defaults (dock, trackpad, NSGlobalDomain, etc.)
├── bootstrap.sh                 # First-time provisioning (Nix install, FDA, identity, activation)
├── redeploy.sh                  # Rebuild script (flake update + darwin-rebuild switch --impure)
├── nuke-nix.sh                  # Complete Nix removal for clean reinstall
├── apps/
│   ├── default.nix              # Imports all app modules
│   ├── system/                  # System app prefs (Safari, Finder, Mail, etc.)
│   │   └── default.nix
│   ├── VSCode.nix               # Extension installer + prefs
│   ├── Raycast.nix              # Hotkey + config import
│   ├── Claude.nix               # Empty placeholder prefs
│   ├── BetterDisplay.nix        # Empty placeholder prefs
│   ├── Spotify.nix              # Empty placeholder prefs
│   ├── KarabinerElements.nix    # Empty placeholder prefs
│   └── ... (60+ app modules)
├── hosts/
│   ├── Ks-Mac.nix              # Apple Silicon primary — dock, casks, MAS, login items, locale
│   ├── MacBookPro.nix          # Intel MacBook Pro — dock, login items, locale
│   └── iMac.nix                # Intel iMac — dock, locale (NO login items script)
└── assets/wallpaper.png
```

---

## Full Source Files to Audit

### flake.nix

```nix
{
  description = "Nix-darwin configuration — fully dynamic";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-stable, nix-homebrew, }:
    let
      currentUser = builtins.getEnv "NIXDARWIN_USER";
      currentArch = builtins.getEnv "NIXDARWIN_ARCH";
      currentSystem = if currentArch == "arm64" then "aarch64-darwin" else "x86_64-darwin";

      isARM = currentSystem == "aarch64-darwin";
      brewPath = if isARM then "/opt/homebrew/bin/brew" else "/usr/local/bin/brew";
      nixEnabled = !isARM;
      pkgsSource = if isARM then nixpkgs else nixpkgs-stable;

      sharedModules = [
        ./apps/default.nix
        #./home.nix   # COMMENTED OUT
        ./homebrew-mas-global.nix
        ./keyboard-shortcuts.nix
        ./packages.nix
        ./spotx.nix
        ./system-settings.nix
        nix-homebrew.darwinModules.nix-homebrew
      ];

      hosts = {
        "Ks-Mac" = { deviceType = "Mac"; };
        "iMac" = { deviceType = "iMac"; };
        "MacBookPro" = { deviceType = "MacBook Pro"; };
      };

      mkHost = hostname: { deviceType, extraModules ? [] }:
        let hostLabel = "${currentUser}'s ${deviceType}";
        in nix-darwin.lib.darwinSystem {
          system = currentSystem;
          specialArgs = { user = currentUser; inherit hostname hostLabel; };
          modules = sharedModules ++ extraModules ++ [
            ./hosts/${hostname}.nix
            ({ lib, ... }: {
              nixpkgs.pkgs = import pkgsSource {
                system = currentSystem;
                config.allowUnfree = true;
                overlays = [
                  (final: prev: {
                    pipx = prev.pipx.overrideAttrs {
                      doCheck = false;
                      doInstallCheck = false;
                    };
                  })
                ];
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

              environment.systemPath = lib.optionals isARM [
                "/opt/homebrew/bin"
                "/opt/homebrew/sbin"
              ];

              nix.enable = nixEnabled;
              nix.settings.experimental-features = lib.mkIf nixEnabled [
                "nix-command" "flakes"
              ];

              system.configurationRevision = self.rev or self.dirtyRev or null;
              system.stateVersion = 6;
            })
          ];
        };
    in { darwinConfigurations = builtins.mapAttrs mkHost hosts; };
}
```

### packages.nix

```nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim git nixfmt wget aria2 inetutils speedtest-cli
    exiftool ffmpeg imagemagick yt-dlp tesseract
    fastfetch coreutils deno nodejs python3
    cmake ninja ccache tree pandoc pipx
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
  ];
}
```

### spotx.nix

```nix
{ pkgs, ... }:
{
  system.activationScripts.spotifyPatch = {
    text = ''
      if [ -d "/Applications/Spotify.app" ]; then
        echo "Applying SpotX patch to Spotify..."
        /usr/bin/osascript -e 'quit app "Spotify"' 2>/dev/null || true
        /usr/bin/pkill -9 Spotify 2>/dev/null || true
        sleep 2
        ${pkgs.bash}/bin/bash <(${pkgs.curl}/bin/curl -sSL https://spotx-official.github.io/run.sh) -B -c -f -h || {
          echo "Warning: SpotX patch failed, but continuing..."
        }
        echo "SpotX patch completed"
      fi
    '';
    deps = [ "homebrew" ];
  };
}
```

### VSCode.nix (extension installer)

```nix
{ user, ... }:
let
  coreExtensions = [
    "bbenoist.nix" "jnoortheen.nix-ide"
    "ms-python.python" "ms-python.vscode-pylance" "ms-python.debugpy"
    "ms-python.vscode-python-envs"
    "ms-toolsai.jupyter" "ms-toolsai.jupyter-keymap" "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags" "ms-toolsai.vscode-jupyter-slideshow"
    "yzhang.markdown-all-in-one" "davidanson.vscode-markdownlint"
    "shd101wyy.markdown-preview-enhanced" "bpruitt-goddard.mermaid-markdown-syntax-highlighting"
    "esbenp.prettier-vscode" "inferrinizzard.prettier-sql-vscode" "foxundermoon.shell-format"
    "mechatroner.rainbow-csv" "grapecity.gc-excelviewer" "mathematic.vscode-pdf"
    "chaunceykiwi.json-tree-view" "hediet.vscode-drawio"
    "redhat.vscode-yaml" "wholroyd.jinja" "asciidoctor.asciidoctor-vscode"
    "christian-kohler.npm-intellisense" "arcanis.vscode-zipfs"
    "formulahendry.code-runner" "mcu-debug.debug-tracker-vscode" "ms-vscode.cpptools-themes"
    "ms-vscode-remote.remote-wsl" "ms-vsliveshare.vsliveshare"
    "github.copilot-chat" "ms-vscode.vscode-speech"
  ];
  installCmds = builtins.concatStringsSep "\n" (
    map (ext: ''sudo -u ${user} /opt/homebrew/bin/code --install-extension "${ext}" --force 2>/dev/null || true'') coreExtensions
  );
in {
  system.activationScripts.vscodeExtensions = {
    text = ''
      if [ -x "/opt/homebrew/bin/code" ]; then
        echo "Installing core VS Code extensions..."
        ${installCmds}
      fi
    '';
  };
  system.defaults.CustomUserPreferences."com.microsoft.VSCode" = {};
}
```

### Safari.nix (activation script approach)

```nix
{ user, ... }:
let
  home = "/Users/${user}";
  safariPlist = "${home}/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist";
in {
  system.activationScripts.postActivation.text = ''
    # ~50 lines of `sudo -u ${user} defaults write "${safariPlist}" ...`
    # Sets session restore, autofill, privacy, downloads, developer menu, etc.
  '';
}
```

### Hosts (Ks-Mac.nix — ARM primary host)

- Overrides loginwindow text with `lib.mkForce`
- Sets locale (en-US UI, en_DE regional)
- Keyboard layouts (German + U.S.)
- Dock persistent-apps (15 apps)
- ARM-specific casks (~30 entries)
- ARM-specific MAS apps (11 entries)
- Login items activation script with `deps = [ "homebrew" ]`

### Hosts (MacBookPro.nix, iMac.nix — Intel)

- German-only locale and keyboard
- Different dock layouts referencing OCLP, UPDF, 3uTools, iMazing
- Empty casks/masApps lists (rely solely on globals)
- iMac.nix has NO login items activation script (inconsistency)

---

## Audit Dimensions

Please evaluate the following areas and produce findings:

### 1. **Correctness & Evaluation Safety**

- `builtins.getEnv` requires `--impure` — what happens if someone forgets?
- Empty env vars (`currentUser = ""`) — does the config fail gracefully?
- `nix-darwin.inputs.nixpkgs.follows = "nixpkgs"` but Intel uses `nixpkgs-stable` — is nix-darwin itself still built against unstable on Intel? Any ABI issues?
- Multiple `system.activationScripts.postActivation.text` definitions across modules (system-settings.nix AND Safari.nix) — are they merged or does one override the other?

### 2. **Security**

- `sudo spctl --master-disable` globally disables Gatekeeper
- `xattr -dr com.apple.quarantine` removes quarantine from ALL apps
- sudoers rule: `${currentUser} ALL=(ALL) NOPASSWD: ${brewPath}` — is NOPASSWD for ALL targets too broad? Should it be more restrictive?
- SpotX downloads and executes a remote shell script (`curl | bash`) during system activation — supply chain risk
- `homebrew.onActivation.cleanup = "zap"` can destructively remove user data

### 3. **Idempotency & Reliability**

- SpotX patch runs on every rebuild (kills Spotify, downloads, patches) — idempotent?
- VS Code extension install runs on every rebuild — slow but harmless?
- Login items script uses `grep` on comma-separated osascript output — fragile parsing
- `nix flake update` in redeploy.sh updates ALL inputs every rebuild — intentional? Could break things

### 4. **Architecture & Modularity**

- 60+ app .nix files where most are empty `CustomUserPreferences = {}` — useful scaffolding or dead weight?
- `home.nix` exists but is commented out of sharedModules — orphaned?
- Dual app management: apps listed in both `homebrew-mas-global.nix` (casks) AND individual `apps/*.nix` (prefs) — confusing separation?
- No `nixosConfigurations` test or CI — how is correctness validated?

### 5. **Compatibility & Edge Cases**

- VS Code extension installer hardcodes `/opt/homebrew/bin/code` — breaks on Intel
- `nixfmt` package — the old `nixfmt` or the new `nixfmt-rfc-style`? They're different packages
- `inetutils` on macOS may conflict with system `ping`, `hostname`, etc.
- `nixpkgs-24.11-darwin` for Intel — is this branch still maintained/receiving security updates?
- `pipx` overlay disables tests globally — masking real breakage?

### 6. **Maintainability & DX**

- No `README.md` in root (only `docs/paid-external-apps.md`)
- No automated testing or `nix flake check`
- Hostname detection via `scutil --get LocalHostName` must exactly match flake attribute keys
- No garbage collection configured (nix-collect-garbage)
- No pinning strategy documented — `nix flake update` moves everything to HEAD

### 7. **macOS-Specific Concerns**

- `system.defaults.screensaver.askForPasswordDelay = 3600` — 1 hour before requiring password after screensaver is a significant security gap
- `NSScrollAnimationEnabled = false` + `NSAutomaticWindowAnimationsEnabled = false` — may cause visual glitches in some apps
- `AppleFontSmoothing = 2` — deprecated on macOS 14+; has no effect on Apple Silicon
- Hot corner `wvous-tl-corner = 5` (screensaver) combined with 1-hour password delay = easy unauthorized access
- `show-process-indicators` + `static-only = false` is redundant (static-only=false is default)

### 8. **Shell Scripts (bootstrap.sh, redeploy.sh, nuke-nix.sh)**

- bootstrap.sh is 370+ lines handling Intel recovery edge cases — should complex recovery logic be documented separately?
- `set -eo pipefail` but no `set -u` (unset variables won't error)
- HOME directory init does `git checkout -f master` — destructive force checkout on existing home
- sudo keepalive pattern is solid but PID cleanup could race on SIGKILL

---

## Deliverable

Produce a **Master TODO List** organized by priority:

1. **Critical (blocks correctness or poses security risk)**
2. **High (reliability/idempotency issues that cause rebuild failures)**
3. **Medium (maintainability, DX, best practices)**
4. **Low (cosmetic, nice-to-have, future improvements)**

For each item:

- One-line description
- Which file(s) to change
- Suggested fix (brief)

End with a summary assessment: Is this configuration production-ready for personal use? What's the single highest-impact improvement?
