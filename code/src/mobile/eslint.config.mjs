// ESLint for the MOBILE SURFACE only.
//
// This config is deliberately self-contained: the mobile app is a pnpm workspace member
// with its own eslint, typescript-eslint and TypeScript devDependencies, so nothing about
// React Native or TSX leaks into the repository root. The root config ignores this
// directory entirely.
//
// Consequence, by design: root `lint:js` does NOT cover this tree. Lint it through
// code/src/scripts/mobile/lint.sh, which CI invokes as a separate step.
import expoConfig from "eslint-config-expo/flat.js";
import { config, configs } from "typescript-eslint";

export default config(
  {
    ignores: [
      "node_modules/**",
      ".expo/**",
      ".expo-bundle/**",
      "coverage/**",
      "android/**",
      "ios/**",
      "expo-env.d.ts",
    ],
  },
  expoConfig,
  ...configs.recommended,
  {
    rules: {
      // Design values are token-driven. A raw colour or spacing literal in a
      // StyleSheet is caught by code/src/scripts/audits/mobile-tokens.sh, not here —
      // this rule set covers correctness, not the token-first law.
      "@typescript-eslint/no-unused-vars": [
        "error",
        { argsIgnorePattern: "^_", varsIgnorePattern: "^_" },
      ],
    },
  },
);
