import { renderRouter } from "expo-router/testing-library";

/**
 * Mounts the real router rather than the screen in isolation, so the root layout is
 * exercised too. A layout that renders nothing is a real failure mode, and testing the
 * route on its own would hide it.
 *
 * renderRouter is awaited: from React Native Testing Library 14 rendering is async, and
 * expo-router 58's renderRouter returns a Promise of the result. Queries are taken from
 * that result, so each test names the tree it is asserting against.
 */
describe("the mobile app", () => {
  it("renders the index route at /", async () => {
    const app = await renderRouter("./app", { initialUrl: "/" });

    expect(await app.findByRole("header")).toBeOnTheScreen();
  });

  it("renders the placeholder body copy", async () => {
    const app = await renderRouter("./app", { initialUrl: "/" });

    expect(await app.findByText(/mobile surface is running/i)).toBeOnTheScreen();
  });
});
