{ ... }:
{
  files = {
    ".oxlintrc.json".json = {
      categories = {
        correctness = "error";
        perf = "warn";
      };
      jsPlugins = [
        {
          name = "react-compiler";
          specifier = "eslint-plugin-react-hooks";
        }
      ];
      options = {
        "typeAware" = true;
      };
      plugins = [
        "eslint"
        "import"
        "oxc"
        "promise"
        "react"
        "typescript"
        "unicorn"
      ];
      rules = {
        "react/rules-of-hooks" = "error";
        "react-compiler/config" = "error";
        "react-compiler/error-boundaries" = "error";
        "react-compiler/gating" = "error";
        "react-compiler/globals" = "error";
        "react-compiler/immutability" = "error";
        "react-compiler/incompatible-library" = "warn";
        "react-compiler/preserve-manual-memoization" = "error";
        "react-compiler/purity" = "error";
        "react-compiler/refs" = "error";
        "react-compiler/set-state-in-effect" = "error";
        "react-compiler/set-state-in-render" = "error";
        "react-compiler/static-components" = "error";
        "react-compiler/unsupported-syntax" = "warn";
        "react-compiler/use-memo" = "error";
      };
    };

    # Vite does not work with a symlinked vite.config.ts so save this file in a temp location
    # and create the local vite.config.ts file later in a shell environment by copying the temp file
    ".tmp/vite.config.ts".text = ''
      import react from "@vitejs/plugin-react";
      import path from "path";
      import { defineConfig } from "vite";

      export default defineConfig({
        plugins: [react({ compiler: true })],
        resolve: {
          alias: {
            '@': path.resolve(__dirname, './src'),
          },
        },
      });
    '';

    "tsconfig.json".json = {
      "compilerOptions" = {
        "tsBuildInfoFile" = "./node_modules/.tmp/tsconfig.app.tsbuildinfo";
        "target" = "es2023";
        "lib" = ["ES2023" "DOM"];
        "module" = "esnext";
        "types" = ["vite/client"];
        "skipLibCheck" = true;

        # Bundler mode
        "moduleResolution" = "bundler";
        "allowImportingTsExtensions" = true;
        "verbatimModuleSyntax" = true;
        "moduleDetection" = "force";
        "noEmit" = true;
        "jsx" = "react-jsx";

        # Linting
        "noUnusedLocals" = true;
        "noUnusedParameters" = true;
        "erasableSyntaxOnly" = true;
        "noFallthroughCasesInSwitch" = true;

        # Support absolute import paths
        "paths" = {
          "@/*" = ["./src/*"];
        };
      };
      "include" = ["src"];
    };

    ".vscode/settings.json".json = {
      # editor
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "oxc.oxc-vscode";
      "editor.codeActionsOnSave" = {
          "source.organizeImports" = "always";
      };

      #oxc
      "oxc.enable" = true;
      "oxc.enable.oxlint" = true;
      "oxc.enable.oxfmt" = true;
      "oxc.configPath" = ".oxlintrc.json";
      "oxc.path.oxfmt" = ".devenv/profile/bin/oxfmt";
      "oxc.path.oxlint" = ".devenv/profile/bin/oxlint";
      "oxc.path.tsgolint" = ".devenv/profile/bin/tsgolint";

      # typescript
      "js/ts.experimental.useTsgo" = true;
      "js/ts.preferences.importModuleSpecifier" = "shortest";

      # typescript react
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "oxc.oxc-vscode";
      };
    };
  };
}
