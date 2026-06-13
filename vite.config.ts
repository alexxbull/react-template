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
