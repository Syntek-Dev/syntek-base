import { StyleSheet, Text, View } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";

/**
 * The single placeholder route.
 *
 * Replace it with the first real screen. Styling is `StyleSheet.create` over the
 * generated token module — no styling library.
 *
 * The five values below carry `token-allow` because the token module is emitted from the
 * design-token database and so does not exist in the template baseline. They exist so the
 * skeleton boots, not because they are the design: replace each with a token import as the
 * first real screen lands, and delete the annotations so the token audit holds the line.
 */
export default function Index() {
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <Text accessibilityRole="header" style={styles.heading}>
          {"<%MOBILE_APP_NAME%>"}
        </Text>
        <Text style={styles.body}>
          The mobile surface is running. Start from a user story, as the web surface does.
        </Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
  container: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
    gap: 12, // token-allow: no token module at template baseline
    padding: 24, // token-allow: no token module at template baseline
  },
  heading: {
    fontSize: 24, // token-allow: no token module at template baseline
    fontWeight: "600", // token-allow: no token module at template baseline
    textAlign: "center",
  },
  body: {
    fontSize: 16, // token-allow: no token module at template baseline
    textAlign: "center",
  },
});
