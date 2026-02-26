{ pkgs, ... }:
{
  # ── Intel iMac-specific settings ───────────────────────────────────────────────
  # To add another Intel iMac: copy this file and add an entry in flake.nix.

  nixpkgs.hostPlatform = "x86_64-darwin";

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = "GRAVITY";
    autoMigrate = true;
  };

  environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
    GRAVITY ALL=(ALL) NOPASSWD: /usr/local/bin/brew
  '';

  nix.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ── Dock ────────────────────────────────────────────────────────────────
  system.defaults.dock.persistent-apps = [
    "/Applications/WhatsApp.app"
    "/System/Applications/Mail.app"
    "/System/Applications/Photos.app"
    "/System/Applications/Notes.app"
    "/System/Applications/Reminders.app"
    "/System/Applications/Calendar.app"
    "/System/Applications/Passwords.app"
    "/System/Applications/System Settings.app"
    "/Applications/Spotify.app"
  ];

  # ── Intel-specific Casks ─────────────────────────────────────────────────────
  homebrew.casks = [
  ];

  # ── Intel-specific MAS Apps ─────────────────────────────────────────────────
  homebrew.masApps = {
  };

  # ── Intel-specific Nix packages ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
  ];
}
