/**
 * Which of the three error classes a failure belongs to, on a device.
 *
 * The classes are code/docs/NEGATIVE-SPACE.md's and are identical on every surface. What
 * differs here is which one is *ordinary*: on a server an environment error is unusual, on a
 * phone it is the common case — a train tunnel is not a defect. Reporting every failed
 * request is how a mobile error tracker becomes noise, and a noisy tracker is a muted one.
 *
 * This module is the classifier only. The screen that renders the result is deliberately not
 * built (code/docs/MOBILE-CODING-PRINCIPLES.md § 5): it needs the token module and the
 * project's brand voice, neither of which exists at baseline. The classification does not,
 * which is why the half that can be proved here ships and the half that cannot does not.
 */

import { InvariantViolation } from "./invariant";

/** The three classes. Surface-agnostic by design — the backend raises the same three. */
export type ErrorClass = "programmer" | "user" | "environment";

/** How often each class reaches the error tracker, once one is wired. */
export type ReportingRule = "per-event" | "aggregated" | "never";

/**
 * The reporting rule per class — the same three rows the backend already follows.
 *
 * `aggregated` is what keeps the tracker credible on this surface. A user on a train loses
 * connectivity dozens of times an hour, and none of it is a defect in this app.
 */
export const REPORTING: Record<ErrorClass, ReportingRule> = {
  programmer: "per-event",
  environment: "aggregated",
  user: "never",
};

/**
 * Statuses that mean "you did not reach the application", not "the application is broken".
 *
 * 502, 503 and 504 come from the edge when the process behind it is not answering, and 408
 * is a timeout the server noticed first. Each is the same fact as being offline, so each is
 * an environment error despite three of the four being 5xx. Without this set a rolling
 * deploy would file every request in the restart window as a defect in someone's code.
 */
const UNREACHED_STATUSES: ReadonlySet<number> = new Set([408, 502, 503, 504]);

/** The status of a thrown `Response`, or of any error object carrying one. */
function httpStatus(error: unknown): number | null {
  if (typeof error !== "object" || error === null || !("status" in error)) {
    return null;
  }
  const status: unknown = (error as { status: unknown }).status;
  return typeof status === "number" ? status : null;
}

/** A request that never completed: offline, DNS, a dropped connection, or an abort. */
function isTransportFailure(error: unknown): boolean {
  if (!(error instanceof Error)) {
    return false;
  }
  if (error.name === "AbortError" || error.name === "TimeoutError") {
    return true;
  }
  // React Native's fetch throws exactly this for every transport-level failure.
  return error instanceof TypeError && /network request failed/i.test(error.message);
}

/**
 * Classify anything that reached an error path.
 *
 * A 5xx is recorded as the **server's** programmer error, not this app's: the app shows the
 * error screen and reports that it saw one, and never files the server's bug as its own.
 *
 * The default is `programmer`, and that is the load-bearing choice rather than a fallback. A
 * failure nobody anticipated is a bug until someone proves otherwise, so an unrecognised
 * value is reported rather than shrugged off. Defaulting to `environment` would silence
 * exactly the errors nobody has thought about yet — the ones worth hearing about.
 */
export function classify(error: unknown): ErrorClass {
  if (error instanceof InvariantViolation) {
    return "programmer";
  }

  const status = httpStatus(error);
  if (status !== null) {
    if (UNREACHED_STATUSES.has(status)) {
      return "environment";
    }
    // A 2xx or 3xx that reached an error path means this app misread a success.
    return status >= 500 || status < 400 ? "programmer" : "user";
  }

  return isTransportFailure(error) ? "environment" : "programmer";
}

/** Whether a failure of this class is worth telling the user they can retry. */
export function isRetryable(cls: ErrorClass): boolean {
  return cls === "environment";
}
