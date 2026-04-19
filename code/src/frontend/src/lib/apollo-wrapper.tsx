"use client";

import { ApolloClient, ApolloProvider, HttpLink, InMemoryCache } from "@apollo/client";
import type { ReactNode } from "react";

const client = new ApolloClient({
  link: new HttpLink({
    uri: process.env.NEXT_PUBLIC_GRAPHQL_URL ?? "/graphql/",
  }),
  cache: new InMemoryCache(),
});

export function ApolloWrapper({ children }: { children: ReactNode }) {
  return <ApolloProvider client={client}>{children}</ApolloProvider>;
}
