{ user, ... }:

let
  # Core extensions installed on every machine via `darwin-rebuild switch`.
  # Everything else is managed dynamically by VS Code and tracked in
  # ~/.vscode/extensions/extensions.json (git-tracked in the home repo).
  coreExtensions = [
    # Nix
    "bbenoist.nix"
    "jnoortheen.nix-ide"

    # Python
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.debugpy"
    "ms-python.vscode-python-envs"

    # Jupyter
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"

    # Markdown
    "yzhang.markdown-all-in-one"
    "davidanson.vscode-markdownlint"
    "shd101wyy.markdown-preview-enhanced"
    "bpruitt-goddard.mermaid-markdown-syntax-highlighting"

    # Formatting & Linting
    "esbenp.prettier-vscode"
    "inferrinizzard.prettier-sql-vscode"
    "foxundermoon.shell-format"

    # Data & Files
    "mechatroner.rainbow-csv"
    "grapecity.gc-excelviewer"
    "mathematic.vscode-pdf"
    "chaunceykiwi.json-tree-view"
    "hediet.vscode-drawio"

    # Languages & Frameworks
    "redhat.vscode-yaml"
    "wholroyd.jinja"
    "asciidoctor.asciidoctor-vscode"
    "christian-kohler.npm-intellisense"
    "arcanis.vscode-zipfs"

    # Dev Tools
    "formulahendry.code-runner"
    "mcu-debug.debug-tracker-vscode"
    "ms-vscode.cpptools-themes"

    # Remote & Collaboration
    "ms-vscode-remote.remote-wsl"
    "ms-vsliveshare.vsliveshare"

    # AI
    "github.copilot-chat"

    # Other
    "ms-vscode.vscode-speech"
  ];

  installCmds = builtins.concatStringsSep "\n" (
    map (
      ext:
      ''sudo -u ${user} /opt/homebrew/bin/code --install-extension "${ext}" --force 2>/dev/null || true''
    ) coreExtensions
  );
in
{
  system.activationScripts.vscodeExtensions = {
    text = ''
      if [ -x "/opt/homebrew/bin/code" ]; then
        echo "Installing core VS Code extensions..."
        ${installCmds}
      fi
    '';
  };

  system.defaults.CustomUserPreferences = {
    "com.microsoft.VSCode" = {
      # Add VS Code-specific settings here
    };
  };
}
