import js from "@eslint/js";
import tseslint from "typescript-eslint";

export default tseslint.config(
  {
    ignores: [
      "**/node_modules/**",
      "**/.venv/**",
      "**/.next/**",
      "code/src/frontend/src/graphql/generated/**",
      "**/*.min.js",
      "**/*.min.css",
    ],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
);
