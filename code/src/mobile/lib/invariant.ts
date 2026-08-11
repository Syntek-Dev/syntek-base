/**
 * The mobile surface's programmer-error type, and the exhaustiveness guard built on it.
 *
 * The name matches the backend's `InvariantViolation` deliberately: the register in
 * how-to/src/INVARIANTS.md has one `On breach` column for every surface, and it only reads
 * the same on both if the type does. Rule: code/docs/NEGATIVE-SPACE.md.
 */

/**
 * A rule this codebase must never break, broken anyway. Never shown to a user.
 *
 * The key is the register row's identifier, so a tracker event names which invariant
 * failed rather than only where.
 */
export class InvariantViolation extends Error {
  readonly key: string;

  constructor(key: string, detail?: string) {
    super(detail === undefined ? key : `${key}: ${detail}`);
    this.name = "InvariantViolation";
    this.key = key;
  }
}

/**
 * The branch the type system proved could not happen, reached at runtime.
 *
 * Call it where a union is exhausted — the `default:` of a switch, the final `else`. It
 * takes `never`, so adding a member to the union fails `typecheck.sh` at every call site
 * that has not handled it; the throw is what catches the same value arriving from the API,
 * where the compiler never saw it.
 *
 * Not named `assertNever`: `assert` is the banned mechanism, and this raises a keyed error
 * rather than asserting one.
 */
export function unreachable(value: never, key: string): never {
  throw new InvariantViolation(key, `unreachable branch reached with ${String(value)}`);
}
