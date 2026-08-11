// Fixture test for negative-space.sh --self-test. Never run by Jest.
//
// This file exists to prove the EXCLUSION. It constructs an unregistered key, exactly as
// the real mobile suite does. If test code ever stops being exempt, `clean/` starts
// producing findings and the self-test fails — which is the point.

import { InvariantViolation } from "./guard";

describe("InvariantViolation", () => {
  it("carries its key", () => {
    expect(new InvariantViolation("fixture.never_registered_ts").key).toBe(
      "fixture.never_registered_ts",
    );
  });
});
