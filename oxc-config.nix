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
        "react-perf"
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
      import { defineConfig } from "vite";
      import react from "@vitejs/plugin-react";
      import { transform } from "oxc-transform";

      function rustReactCompilerOnlyPlugin() {
        return {
          name: "vite-plugin-oxc-react-compiler",
          enforce: "pre" as const,

          // Only apply React Compiler's transform
          async transform(code: string, id: string) {
            if (!/\.[jt]sx$/.test(id) || id.includes("node_modules")) {
              return null;
            }

            try {
              const result = await transform(id, code, {
                reactCompiler: {
                  target: "19",
                },
              });

              return {
                code: result.code,
                map: result.map,
              };
            } catch (err) {
              console.error(`[OXC React Compiler Error]:`, err);
              return null;
            }
          },
        };
      }

      export default defineConfig({
        plugins: [rustReactCompilerOnlyPlugin(), react({ include: /\.(js|jsx|ts|tsx)$/ })],
      });
    '';

    ".vscode/settings.json".json = {
      # editor
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "oxc.oxc-vscode";

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
    };
  };
}
