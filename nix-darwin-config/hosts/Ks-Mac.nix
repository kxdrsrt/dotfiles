{ ... }:
{
  # ── Apple-Silicon-spezifische Einstellungen ──────────────────────────────────

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix-homebrew = {
    enable        = true;
    enableRosetta = true;    # Rosetta 2 erlaubt brew, x86_64-Bottles auf ARM zu nutzen
    user          = "k";
    autoMigrate   = true;
  };

  environment.etc."sudoers.d/10-homebrew-nopasswd".text = ''
    k ALL=(ALL) NOPASSWD: /opt/homebrew/bin/brew
  '';

  # Determinate Systems verwaltet den Nix-Daemon auf diesem Host extern
  nix.enable = false;
}
