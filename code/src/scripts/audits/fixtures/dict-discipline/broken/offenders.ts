// Known-positive fixture — every line here MUST be reported. Never "fix" this file.

export type Payload = Record<string, unknown>; // T1

export function parse(raw: string): Record<string, any> {
  // T1
  return JSON.parse(raw);
}

export interface Bag {
  [key: string]: string; // T2
}

export function accept(value: object): void {
  // T2
  void value;
}
