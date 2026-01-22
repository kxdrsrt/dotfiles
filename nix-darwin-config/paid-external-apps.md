*Last updated: 2026-01-22*

---

# Paid & External Applications

This document lists all paid, commercial, or external applications installed on the system that are **not managed** through the nix-darwin configuration.

> **Note:** These apps should remain manually installed and not be declared in the flake configuration. Apps already declared in homebrew.casks or homebrew.masApps are excluded from this list.

---

## 3D/CAD

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Autodesk Fusion** | Subscription | 3D CAD/CAM design software |

## Automation

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Hazel** | Paid | Automated file organization |

## Cloud Storage

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **DaftCloud** | Freemium | SoundCloud music client |

## Compatibility

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **CrossOver** | Paid | Run Windows apps without VM |

## Design

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Affinity** | Paid | Professional design suite (Photo/Designer/Publisher) |
| **Icon Composer** | Free | Icon creation tool by Apple |
| **Sketch** | Paid/Subscription | Vector graphics and UI design |

## Design/Productivity

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Ora** | FOSS | Minimal Webkit Browser (beta) |

## Finance

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Steuerbot** | Paid/Subscription | German tax software |

## Gaming

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Ryujinx** | FOSS | Nintendo Switch emulator |

## Media

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **DaftMusic** | Freemium | Apple Music player/manager |
| **Downie 4** | Paid | Video downloader |
| **Fladder** | Free | Jellyfin client |
| **IPTV Live** | Paid (App Store) | IPTV player |
| **Leech** | Paid | Download manager |
| **Permute 3** | Paid | Video converter |

## PDF

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **PDF Expert** | Paid/Subscription | PDF editor and reader |
| **UPDF** | Paid/Freemium | PDF editor and annotator |

## Photo Editing

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **BatchPhoto** | Paid | Batch photo processing |
| **Pixelmator Pro** | Paid (App Store) | Professional image editor |
| **Topaz Gigapixel** | Paid | AI upscaling and enhancement |
| **TouchRetouch** | Paid (App Store) | Remove unwanted objects from photos |

## Photo Management

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **PowerPhotos** | Paid | Apple Photos library manager |

## Productivity

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Spokenly** | Paid | Text-to-speech or note-taking |

## Statistics

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Minitab Statistical Software** | Paid/Subscription | Statistical analysis software (via CrossOver) |

## Utilities

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **DaisyDisk** | Paid | Disk space analyzer with visual interface |
| **OnScreen Control** | Free (LG) | LG monitor control software |
| **OpenNOW** | FOSS | Purpose unclear |
| **Trae** | Freemium | AI IDE by ByteDance |

## Virtualization

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **Parallels Desktop** | Paid/Subscription | Windows/Linux VM software |

## iOS Management

| Application | Price Model | Notes |
|-------------|-------------|-------|
| **3uTools** | Free | iOS device management (Chinese software) |
| **iMazing** | Paid | iOS device backup and transfer |

---

## Summary

- **Total External Apps:** 32
- **Fully Paid:** 15
- **Freemium/Subscription:** 9
- **Free/Open Source:** 7

## Important Notes

1. **Do not add these to homebrew.casks** - They are either:
   - Licensed/activated versions that differ from trial versions
   - Not available in Homebrew
   - Require manual configuration
   - Niche/obscure applications

2. **Keep manual backups** of:
   - License keys and activation files
   - App-specific settings and preferences
   - Custom configurations

3. **App Store purchases** (marked "App Store") can be managed via `mas` in nix-darwin if desired, but only if you want to reinstall from scratch.
