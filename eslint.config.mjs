import js from "@eslint/js";
import globals from "globals";

// The site is server-rendered by Django — there is no React, no client build, and no
// application JavaScript beyond the progressive-enhancement scripts served from
// code/src/django/static/js/. This config covers those and nothing else.
//
// There is no TypeScript in this stack, so typescript-eslint is not installed and there
// is no typecheck job. Introducing TypeScript or a bundler is a stack change, argued in
// an ADR — see code/docs/RENDERING.md.
export default [
  {
    ignores: [
      "**/node_modules/**",
      "**/.venv/**",
      "code/src/django/staticfiles/**",
      "code/src/django/static/vendor/**",
      "code/src/scripts/tests/reports/**",
      "code/src/scripts/reports/**",
      "**/*.min.js",
      "**/*.min.css",
    ],
  },
  js.configs.recommended,
  {
    // Browser scripts for the Django-templated frontend — small, CSP-clean
    // progressive-enhancement JS served via <script> (e.g. an htmx:afterSwap focus
    // handler). window/document/addEventListener are the browser runtime, not
    // undefined references.
    files: ["code/src/django/static/js/*.js"],
    languageOptions: {
      globals: {
        ...globals.browser,
      },
    },
  },
];
