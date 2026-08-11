import { classify, isRetryable, REPORTING } from "@/lib/error-classes";
import { InvariantViolation } from "@/lib/invariant";

/**
 * The classifier is the half of the mobile error taxonomy that ships at baseline, so it is
 * the half that can be proved here. The error boundary and the error screen are not built —
 * there is no token module and no brand-voice copy to build them from.
 *
 * The cases worth reading are the two that look wrong at a glance: a 503 is *not* the
 * server's bug, and an unrecognised value *is* treated as one.
 */
describe("classify", () => {
  it("treats a broken invariant as a programmer error", () => {
    expect(classify(new InvariantViolation("order.total_matches_lines"))).toBe("programmer");
  });

  it("records a 5xx as the server's programmer error, not this app's", () => {
    expect(classify({ status: 500 })).toBe("programmer");
    expect(classify(new Response(null, { status: 500 }))).toBe("programmer");
  });

  it("treats an unreached-application status as an environment error, 5xx or not", () => {
    // The set exists so a rolling deploy does not file its own restart window as a defect.
    expect(classify({ status: 408 })).toBe("environment");
    expect(classify({ status: 502 })).toBe("environment");
    expect(classify({ status: 503 })).toBe("environment");
    expect(classify({ status: 504 })).toBe("environment");
  });

  it("treats a 4xx the screen can act on as a user error", () => {
    expect(classify({ status: 400 })).toBe("user");
    expect(classify({ status: 403 })).toBe("user");
    expect(classify({ status: 409 })).toBe("user");
  });

  it("treats a success status reaching an error path as this app misreading it", () => {
    expect(classify({ status: 204 })).toBe("programmer");
    expect(classify({ status: 302 })).toBe("programmer");
  });

  it("treats a request that never landed as an environment error", () => {
    expect(classify(new TypeError("Network request failed"))).toBe("environment");

    const aborted = new Error("aborted");
    aborted.name = "AbortError";
    expect(classify(aborted)).toBe("environment");

    const timedOut = new Error("timed out");
    timedOut.name = "TimeoutError";
    expect(classify(timedOut)).toBe("environment");
  });

  it("defaults an unrecognised failure to a programmer error", () => {
    // Defaulting the other way would silence exactly the errors nobody has thought of yet.
    expect(classify(new Error("something nobody anticipated"))).toBe("programmer");
    expect(classify("a thrown string")).toBe("programmer");
    expect(classify(null)).toBe("programmer");
    expect(classify(undefined)).toBe("programmer");
    expect(classify({ status: "500" })).toBe("programmer");
  });

  it("does not mistake a plain TypeError for a transport failure", () => {
    expect(classify(new TypeError("undefined is not a function"))).toBe("programmer");
  });
});

describe("REPORTING", () => {
  it("reports every programmer error, aggregates environment, and never reports user error", () => {
    expect(REPORTING.programmer).toBe("per-event");
    expect(REPORTING.environment).toBe("aggregated");
    expect(REPORTING.user).toBe("never");
  });
});

describe("isRetryable", () => {
  it("offers a retry only where retrying could plausibly work", () => {
    expect(isRetryable("environment")).toBe(true);
    expect(isRetryable("programmer")).toBe(false);
    expect(isRetryable("user")).toBe(false);
  });
});
