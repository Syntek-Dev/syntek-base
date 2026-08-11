import js from "@eslint/js";
import globals from "globals";

// The WEB SURFACE is server-rendered by Django — there is no React, no client build, and
// no application JavaScript beyond the progressive-enhancement scripts served from
// code/src/django/static/js/. This config covers those and nothing else.
//
// There is no TypeScript on the web surface, so typescript-eslint is not installed here
// and there is no root typecheck job. Introducing TypeScript or a bundler into the
// Django-served pages is a stack change, argued in an ADR — see code/docs/RENDERING.md.
//
// The optional React Native mobile surface (code/src/mobile/, off by default) is the one
// sanctioned home for TypeScript. It is a self-contained pnpm workspace member carrying
// its own tsconfig, typescript-eslint and typecheck, so it needs nothing from this file
// but an ignore entry. Consequence: once mobile is present, root `lint:js` no longer
// covers everything and the mobile lint script must be invoked separately.
export default [
  {
    ignores: [
      "**/node_modules/**",
      "**/.venv/**",
      // Inert no-op on a web-only project: the path does not exist, and ESLint ignores
      // a pattern that matches nothing. The mobile surface lints itself through
      // code/src/scripts/mobile/lint.sh with its own config.
      "code/src/mobile/**",
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
    // The negative-space self-test fixtures mirror those scripts deliberately — the
    // known-clean case IS a browser listener — so they need the same runtime globals.
    files: ["code/src/django/static/js/*.js", "code/src/scripts/audits/fixtures/**/*.js"],
    languageOptions: {
      globals: {
        ...globals.browser,
      },
    },
  },
];
