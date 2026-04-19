import type { Metadata } from "next";
import { ApolloWrapper } from "@/lib/apollo-wrapper";
import "./globals.css";

export const metadata: Metadata = {
  title: "Syntek Studio",
  description: "Syntek Studio website",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en-GB">
      <body>
        <ApolloWrapper>{children}</ApolloWrapper>
      </body>
    </html>
  );
}
