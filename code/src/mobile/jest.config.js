// Jest for the mobile surface.
//
// The floors match the backend but are enforced per runtime: coverage.py and Jest share no
// accumulator, so a single combined percentage across both surfaces is not achievable.
module.exports = {
  preset: "jest-expo",
  // No setupFilesAfterEnv: React Native Testing Library ships its Jest matchers
  // (toBeOnTheScreen and friends) built in since v12.4, so the old extend-expect
  // entry point no longer exists.
  collectCoverageFrom: [
    "app/**/*.{ts,tsx}",
    "components/**/*.{ts,tsx}",
    "!**/*.test.{ts,tsx}",
    "!**/node_modules/**",
  ],
  coverageThreshold: {
    global: {
      lines: 75,
      branches: 75,
    },
    // Auth-adjacent mobile code carries 90%, matching the backend. The entry is NOT
    // shipped, because Jest fails a run whose coverageThreshold glob matches nothing —
    // a per-glob floor is not inert the way an ESLint ignore or a pnpm glob is. Add it
    // in the same change that adds the first auth screen:
    //
    //   "./app/(auth)/**/*.{ts,tsx}": { lines: 90, branches: 90 },
  },
};
