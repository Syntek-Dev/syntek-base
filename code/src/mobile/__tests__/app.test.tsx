import { renderRouter } from "expo-router/testing-library";

/**
 * Mounts the real router rather than the screen in isolation, so the root layout is
 * exercised too. A layout that renders nothing is a real failure mode, and testing the
 * route on its own would hide it.
 *
 * Queries come from renderRouter's return value, not the global `screen` singleton —
 * React Native Testing Library 14 no longer implements it.
 */
describe("the mobile app", () => {
  it("renders the index route at /", async () => {
    const app = renderRouter("./app", { initialUrl: "/" });

    expect(await app.findByRole("header")).toBeOnTheScreen();
  });

  it("renders the placeholder body copy", async () => {
    const app = renderRouter("./app", { initialUrl: "/" });

    expect(await app.findByText(/mobile surface is running/i)).toBeOnTheScreen();
  });
});
