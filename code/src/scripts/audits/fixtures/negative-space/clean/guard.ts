// Fixture mobile guard for negative-space.sh --self-test. Never bundled.
//
// One client-guard key, thrown at exactly one site, and carried by a register row.

export class InvariantViolation extends Error {
  readonly key: string;

  constructor(key: string) {
    super(key);
    this.name = "InvariantViolation";
    this.key = key;
  }
}

export function label(status: string): string {
  if (status === "draft") {
    return "Draft";
  }
  throw new InvariantViolation("order.status_is_known");
}
