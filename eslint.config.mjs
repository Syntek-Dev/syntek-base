import js from "@eslint/js";
import tseslint from "typescript-eslint";
import reactPlugin from "eslint-plugin-react";
import reactHooksPlugin from "eslint-plugin-react-hooks";
import reactNativePlugin from "eslint-plugin-react-native";

export default tseslint.config(
  {
    ignores: [
      "**/node_modules/**",
      "**/.venv/**",
      "**/.next/**",
      "**/.expo/**",
      "code/src/frontend/src/graphql/generated/**",
      "code/src/mobile/src/graphql/generated/**",
      "**/*.min.js",
      "**/*.min.css",
    ],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  // React rules — web (frontend + shared)
  {
    files: [
      "code/src/frontend/**/*.{ts,tsx}",
      "code/src/shared/**/*.{ts,tsx}",
    ],
    plugins: {
      react: reactPlugin,
      "react-hooks": reactHooksPlugin,
    },
    rules: {
      ...reactPlugin.configs.recommended.rules,
      ...reactHooksPlugin.configs.recommended.rules,
      "react/react-in-jsx-scope": "off",
    },
    settings: {
      react: { version: "detect" },
    },
  },
  // React Native rules — mobile only
  {
    files: ["code/src/mobile/**/*.{ts,tsx}"],
    plugins: {
      react: reactPlugin,
      "react-hooks": reactHooksPlugin,
      "react-native": reactNativePlugin,
    },
    rules: {
      ...reactPlugin.configs.recommended.rules,
      ...reactHooksPlugin.configs.recommended.rules,
      "react/react-in-jsx-scope": "off",
      "react-native/no-unused-styles": "error",
      "react-native/no-inline-styles": "warn",
      "react-native/no-color-literals": "warn",
    },
    settings: {
      react: { version: "detect" },
    },
  },
);
