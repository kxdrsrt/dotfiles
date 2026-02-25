{ ... }:
{
  # ── Intel-iMac-spezifische Einstellungen ─────────────────────────────────────
  # Für jeden weiteren Intel iMac: Datei kopieren, Hostname in flake.nix eintragen.

  nixpkgs.hostPlatform = "x86_64-darwin";

  nix-homebrew = {
    enable        = true;
    enableRosetta = false;   # Intel-Mac braucht kein Rosetta
    user          = "GRAVITY";
    autoMigrate   = true;
  };

  # Intel-Homebrew liegt unter /usr/local statt /opt/homebrew
  environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
    GRAVITY ALL=(ALL) NOPASSWD: /usr/local/bin/brew
  '';
}
