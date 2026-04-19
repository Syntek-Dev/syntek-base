import type { CodegenConfig } from "@graphql-codegen/cli";

const config: CodegenConfig = {
  overwrite: true,
  schema: process.env.GRAPHQL_SCHEMA_URL ?? "http://localhost:8000/graphql/",
  documents: "src/graphql/queries/**/*.graphql",
  generates: {
    "src/graphql/generated/": {
      preset: "client",
      plugins: [],
    },
  },
};

export default config;
