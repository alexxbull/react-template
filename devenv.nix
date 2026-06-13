# See full reference at https://devenv.sh/reference/options/
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
in
{
  imports = [ ./oxc-config.nix ]; # setup oxlint env with react compiler (rust) for vite and vscode

  # https://devenv.sh/languages/
  languages = {
    javascript = {
      enable = true;
      package = unstable.nodejs_26;
      nodejs.enable = true;
      pnpm = {
        enable = true;
        install.enable = true;
      };
    };
  };

  packages = with pkgs; [
    nixfmt-rs
    oxfmt
    oxlint
    tsgolint
    unstable.typescript
    unstable.typescript-go
  ];

  files.".vscode/extensions.json".json = {
    recommendations = [
      "jnoortheen.nix-ide" # nix language support
      "oxc.oxc-vscode" # oxc
      "typescriptteam.native-preview" # typescript support (7.0+)
      "britesnow.vscode-toggle-quotes"  # toggle quotes: `, "", `
    ];
  };

  tasks = {
    # Install eslint-plugin-react-hooks if not installed
    "init:eslint-plugin-react-hooks" = {
      exec = ''
        if [ ! -d ./node_modules/eslint-plugin-react-hooks ]; then 
          pnpm add -D eslint-plugin-react-hooks
          echo "Installed missing npm package: eslint-plugin-react-hooks"
        fi
      '';
      before = [ "devenv:enterShell" ];
    };

    # Install oxc-transform if not installed
    "init:oxc-transform" = {
      exec = ''
        if [ ! -d ./node_modules/oxc-transform ]; then 
          pnpm add -D oxc-transform
          echo "Installed missing npm package: oxc-transform"
        fi
      '';
      before = [ "devenv:enterShell" ];
    };

    # Create vite.config.ts if it does not exist
    # using .tmp/vite.config.ts as a template
    "init:vite-config" = {
      exec = ''
        if [ ! -f vite.config.ts ]; then 
          cp .tmp/vite.config.ts vite.config.ts
          chmod +w vite.config.ts
          echo "Created missing file: vite.config.ts"
        fi
      '';
      after = [ "devenv:enterShell" ];
    };

    # Cleanup .tmp dir if it exists
    "clean:tmp-dir" = {
      exec = "rm -rf .tmp/";
      after = [ "init:vite-config" ];
    };
  };  

  enterShell = ''
    echo "Dev environment for React and Node.js"
    echo "node: $(node --version)"
  '';
}
