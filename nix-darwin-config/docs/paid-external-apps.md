_Last updated: 2026-01-22_

---

# Paid & External Applications

This document lists all paid, commercial, or external applications installed on the system that are **not managed** through the nix-darwin configuration.

> **Note:** These apps should remain manually installed and not be declared in the flake configuration. Apps already declared in homebrew.casks or homebrew.masApps are excluded from this list.

---

## Summary Statistics

| Metric                    | Count |
| ------------------------- | ----- |
| **Total External Apps**   | 32    |
| **Fully Paid**            | 15    |
| **Freemium/Subscription** | 9     |
| **Free/Open Source**      | 7     |

---

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

---

## Master Application List

| Category            | Application                  | Price Model       | Notes                                                |
| ------------------- | ---------------------------- | ----------------- | ---------------------------------------------------- |
| 3D/CAD              | Autodesk Fusion              | Subscription      | 3D CAD/CAM design software                           |
| Automation          | Hazel                        | Paid              | Automated file organization                          |
| Cloud Storage       | DaftCloud                    | Freemium          | SoundCloud music client                              |
| Compatibility       | CrossOver                    | Paid              | Run Windows apps without VM                          |
| Design              | Affinity                     | Paid              | Professional design suite (Photo/Designer/Publisher) |
| Design              | Icon Composer                | Free              | Icon creation tool by Apple                          |
| Design              | Sketch                       | Paid/Subscription | Vector graphics and UI design                        |
| Design/Productivity | Ora                          | FOSS              | Minimal Webkit Browser (beta)                        |
| Finance             | Steuerbot                    | Paid/Subscription | German tax software                                  |
| Gaming              | Ryujinx                      | FOSS              | Nintendo Switch emulator                             |
| Media               | DaftMusic                    | Freemium          | Apple Music player/manager                           |
| Media               | Downie 4                     | Paid              | Video downloader                                     |
| Media               | Fladder                      | Free              | Jellyfin client                                      |
| Media               | IPTV Live                    | Paid (App Store)  | IPTV player                                          |
| Media               | Leech                        | Paid              | Download manager                                     |
| Media               | Permute 3                    | Paid              | Video converter                                      |
| PDF                 | PDF Expert                   | Paid/Subscription | PDF editor and reader                                |
| PDF                 | UPDF                         | Paid/Freemium     | PDF editor and annotator                             |
| Photo Editing       | BatchPhoto                   | Paid              | Batch photo processing                               |
| Photo Editing       | Pixelmator Pro               | Paid (App Store)  | Professional image editor                            |
| Photo Editing       | Topaz Gigapixel              | Paid              | AI upscaling and enhancement                         |
| Photo Editing       | TouchRetouch                 | Paid (App Store)  | Remove unwanted objects from photos                  |
| Photo Management    | PowerPhotos                  | Paid              | Apple Photos library manager                         |
| Productivity        | Spokenly                     | Paid              | Text-to-speech or note-taking                        |
| Statistics          | Minitab Statistical Software | Paid/Subscription | Statistical analysis software (via CrossOver)        |
| Utilities           | DaisyDisk                    | Paid              | Disk space analyzer with visual interface            |
| Utilities           | OnScreen Control             | Free (LG)         | LG monitor control software                          |
| Utilities           | OpenNOW                      | FOSS              | Purpose unclear                                      |
| Utilities           | Trae                         | Freemium          | AI IDE by ByteDance                                  |
| Virtualization      | Parallels Desktop            | Paid/Subscription | Windows/Linux VM software                            |
| iOS Management      | 3uTools                      | Free              | iOS device management (Chinese software)             |
| iOS Management      | iMazing                      | Paid              | iOS device backup and transfer                       |
