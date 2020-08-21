# nix-darwin-config

Personal macOS system configuration managed with [nix-darwin](https://github.com/LnL7/nix-darwin) and [nix-homebrew](https://github.com/zhaofengli/nix-homebrew).

Supports **Apple Silicon (M-series)** and **Intel Macs** from a single flake.

---

## Hosts

| Hostname | Device | Arch |
|---|---|---|
| `Ks-Mac` | Mac Studio | ARM (aarch64) |
| `iMac` | iMac | Intel (x86_64) |
| `MacBookPro` | MacBook Pro | Intel (x86_64) |

---

## Structure

```
flake.nix                   Entry point — defines all hosts
bootstrap.sh                First-time setup on a fresh Mac
redeploy.sh                 Apply config changes (darwin-rebuild switch)
nuke-nix.sh                 Completely remove Nix installation
packages.nix                Nix system packages (CLI tools, fonts)
system-settings.nix         macOS defaults, dock, trackpad, security, etc.
homebrew-mas-global.nix     Homebrew casks + MAS apps (all hosts)
keyboard-shortcuts.nix      Custom hotkeys, screenshot key overrides
spotx.nix                   SpotX Spotify patch (applied after Homebrew)
home.nix                    Home Manager config (optional)
apps/                       Per-app preference modules (3rd party + system)
hosts/                      Host-specific overrides (dock, casks, login items)
assets/                     Static assets (wallpaper.png)
docs/                       Documentation (paid/external apps list)
```

---

## Bootstrap (Fresh Mac)

```bash
xcode-select --install
git clone https://github.com/kxdrsrt/nix-darwin-config ~/nix-darwin-config
cd ~/nix-darwin-config
./bootstrap.sh
```

The script detects architecture, installs Determinate Nix, Homebrew, and runs `darwin-rebuild switch` automatically. Select your host from the menu or pass the hostname as argument: `./bootstrap.sh Ks-Mac`

---

## Redeploy (Apply Changes)

```bash
./redeploy.sh          # Uses local hostname automatically
./redeploy.sh iMac     # Target a specific host
```

Or use the shell alias: `nixre`

---

## Architecture Notes

- **ARM (Apple Silicon):** Uses `nixpkgs-unstable` + Determinate Nix. Homebrew at `/opt/homebrew`. `nix.enable = false` (Determinate manages its own daemon).
- **Intel:** Uses `nixpkgs-24.11` (Ventura-compatible). Homebrew at `/usr/local`. `nix.enable = true`.
- Architecture and user are auto-detected at build time via env vars (`NIXDARWIN_USER`, `NIXDARWIN_ARCH`). No hardcoded values.

---

## Key Features

- **Declarative macOS defaults** — dock, trackpad, keyboard, security, menu bar, hot corners
- **Homebrew casks + MAS apps** via nix-homebrew (`onActivation.cleanup = "zap"`)
- **Per-app preferences** — Safari, Finder, Raycast, Mail, Karabiner, and more in `apps/`
- **Login items** managed declaratively in `hosts/<hostname>.nix`
- **SpotX** applied automatically after every Homebrew activation
- **Touch ID for sudo** enabled via PAM

---

## Paid & External Apps

Apps not managed by this config (manually installed): see [docs/paid-external-apps.md](docs/paid-external-apps.md)
