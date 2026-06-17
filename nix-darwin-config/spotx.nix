{ pkgs, ... }:
{
  # ============================================================================
  # Spotify SpotX Patch
  # ============================================================================
  # Applies SpotX ad-blocking patch to Spotify after upgrades
  # Runs after homebrew activation to ensure latest Spotify is installed

  # Applies SpotX ad-blocking patch to Spotify after upgrades.
  # NOTE: this lives in `postActivation` (not a custom activation-script key).
  # nix-darwin only executes a fixed set of activation-script names; custom
  # keys like `spotifyPatch` are defined but NEVER run. postActivation executes
  # immediately after the Homebrew step, so Spotify is already up to date here.
  system.activationScripts.postActivation.text = ''
    # Check if Spotify is installed
    if [ -d "/Applications/Spotify.app" ]; then
      echo "Applying SpotX patch to Spotify..."

      # Terminate Spotify if running
      /usr/bin/osascript -e 'quit app "Spotify"' 2>/dev/null || true
      /usr/bin/pkill -9 Spotify 2>/dev/null || true

      # Wait a moment for clean shutdown
      sleep 2

      # Download and run SpotX installer with flags:
      # -B: Skip banner/logo
      # -c: Clear app cache
      # -f: Force installation
      # -h: Hide non-music content on home screen
      ${pkgs.bash}/bin/bash <(${pkgs.curl}/bin/curl -sSL https://spotx-official.github.io/run.sh) -B -c -f -h || {
        echo "Warning: SpotX patch failed, but continuing..."
      }

      echo "SpotX patch completed"
    else
      echo "Spotify not found, skipping SpotX patch"
    fi
  '';
}
