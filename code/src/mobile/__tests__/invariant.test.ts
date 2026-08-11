import { InvariantViolation, unreachable } from "@/lib/invariant";

/**
 * The guard is the one piece of the mobile error taxonomy that ships at baseline, so it is
 * the one piece that can be proved here. The error boundary and the error screen are not
 * built yet — there is no token module and no brand-voice copy to build them from.
 */
describe("InvariantViolation", () => {
  it("carries the register key that identifies the invariant", () => {
    const error = new InvariantViolation("order.total_matches_lines");

    expect(error.key).toBe("order.total_matches_lines");
    expect(error.name).toBe("InvariantViolation");
  });

  it("uses the key alone as the message when no detail is given", () => {
    expect(new InvariantViolation("order.total_matches_lines").message).toBe(
      "order.total_matches_lines",
    );
  });

  it("appends the detail to the message when one is given", () => {
    expect(new InvariantViolation("order.total_matches_lines", "order=7").message).toBe(
      "order.total_matches_lines: order=7",
    );
  });
});

describe("unreachable", () => {
  it("throws an InvariantViolation naming the key and the offending value", () => {
    // The cast is what a real call site never needs: `never` is unconstructable, which is
    // the point. Here it stands in for a value the API sent that the union did not admit.
    expect(() => unreachable("archived" as never, "order.status_is_known")).toThrow(
      InvariantViolation,
    );
    expect(() => unreachable("archived" as never, "order.status_is_known")).toThrow(
      /order\.status_is_known: unreachable branch reached with archived/,
    );
  });
});
