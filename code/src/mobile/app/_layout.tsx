import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";

/**
 * Root layout for the mobile surface.
 *
 * expo-router is adopted as a file-system routing CONVENTION, not a navigation shape:
 * one Stack, one route. Tabs, drawers and a screen tree are a project's decision, made
 * when it has screens worth arranging — the template ships no application code beyond
 * this skeleton, exactly as the Django surface ships no pages.
 */
export default function RootLayout() {
  return (
    <>
      <StatusBar style="auto" />
      <Stack screenOptions={{ headerShown: false }} />
    </>
  );
}
