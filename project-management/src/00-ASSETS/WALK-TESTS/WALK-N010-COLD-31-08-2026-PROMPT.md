You are a cold reader. You have never seen this repository before and you know nothing about it.

A repository exists at `/mnt/archive/OldRepos/syntek/syntek-base`. Start at its root, the way a
stranger would. Nobody is going to tell you where anything is.

## Your task

Pick ONE rule or concern that this repository states somewhere — a convention, a constraint, a
standard, a policy; whatever you encounter that looks load-bearing. Do not pick a file, pick a
RULE. Then answer these four questions about it:

1. **Who cites this?** What points AT this rule from elsewhere in the tree.
2. **What moves if I change this rule?** What else has to change with it.
3. **Is this reachable?** Can it be arrived at from the entry file at all.
4. **Which directory owns this concept?** Where the rule lives, and where it is enforced.

Then answer in the other direction as well: **what points INTO this rule's home from outside it?**
A file that nothing points into, or one whose inbound pointers are broken, is a finding — report it.

## Hard budget — a ceiling, not a target

- **The entry file, plus AT MOST TWO further file reads.** Three file reads in total.
- A fourth file read is a **FAIL** for whichever question needed it. Stop and record the fail.
  Do not spend the read, even if you are certain it would have answered the question.
- **2,000 to 8,000 tokens** across the whole attempt.
- A directory listing, or a search that returns paths and matching lines, is not a "read" — but it
  spends tokens and you must log it.

## How to report — this matters as much as the answers

Produce a report with these sections, in this order:

### Tool log
Every tool call you made, in order, with its target. Mark which three were your file reads.

### The rule I picked
Name it in one sentence, and say where you found it.

### The four questions
For each, give: the **answer** (or `COULD NOT ANSWER`), and its **provenance** — one of:
- `POINTER` — a document explicitly told me, by naming the file or the rule
- `SEARCH` — no document told me; I had to go looking
- `INFERENCE` — I guessed from names or structure, and was not told

### Inbound direction
What points into this rule's home from outside it. Same answer + provenance format.

### Which question broke
Name the first question you could not answer within budget, and at which read it broke. If none
broke, say so.

### Verdict
`PASS` only if all four questions AND the inbound direction were answered within budget.
Otherwise `FAIL`.

## Rules of honesty

- **"Could not look" is a FAIL, never a clean pass.** A reader who gets stuck and reports nothing
  has failed. Say `COULD NOT ANSWER` and move on.
- **Never guess and present it as an answer.** If you inferred it, mark it `INFERENCE` — an
  inference is not an answer for the purposes of the verdict.
- Do not go over budget to rescue the result. Running out IS the result.
