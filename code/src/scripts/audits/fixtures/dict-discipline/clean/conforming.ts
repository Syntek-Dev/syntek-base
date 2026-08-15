// Known-negative fixture — this file MUST produce zero findings.

export const ORDER_STATUS = Object.freeze({
  DRAFT: "draft",
  PLACED: "placed",
} as const);

export type OrderStatus = (typeof ORDER_STATUS)[keyof typeof ORDER_STATUS];

export interface Order {
  readonly id: string;
  readonly status: OrderStatus;
  readonly totalPence: number;
}

// A total map keyed by a closed union — the compiler checks completeness, so this is a
// record with named fields wearing Record's clothes, not an untyped bag.
export const LABELS: Record<OrderStatus, string> = {
  draft: "Draft",
  placed: "Placed",
};

export function parse(raw: unknown): Order | null {
  if (typeof raw !== "object" || raw === null) {
    return null;
  }
  const candidate = raw as Partial<Order>;
  if (typeof candidate.id !== "string" || typeof candidate.totalPence !== "number") {
    return null;
  }
  return { id: candidate.id, status: ORDER_STATUS.DRAFT, totalPence: candidate.totalPence };
}
