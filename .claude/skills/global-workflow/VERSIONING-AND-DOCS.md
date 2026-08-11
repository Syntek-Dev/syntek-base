# Versioning, Documentation & Comments

Semantic versioning, Markdown documentation style, bug-fix records, and
code-comment standards. The project's `project-management/docs/VERSIONING-GUIDE.md`
owns the full versioning rules; this is the shared baseline.

---

## 1. Semantic versioning

Single-track semver: `MAJOR.MINOR.PATCH`.

| Increment | When                                | Example       |
| --------- | ----------------------------------- | ------------- |
| **MAJOR** | Breaking changes                    | 1.0.0 → 2.0.0 |
| **MINOR** | New features (backwards compatible) | 1.0.0 → 1.1.0 |
| **PATCH** | Bug fixes (backwards compatible)    | 1.0.0 → 1.0.1 |

### Pre-commit requirements

Before every commit:

1. Determine the increment (MAJOR / MINOR / PATCH).
2. Update the version files (`VERSION`, `VERSION-HISTORY.md`, and any header
   `**Version**:` lines the change touches).
3. Update `CHANGELOG.md` — changelog-first, before staging.
4. Stage the version and changelog files with the change.

To bump mechanically, delegate to the `release` agent (via the Agent tool) or
follow `project-management/docs/VERSIONING-GUIDE.md`. Never hardcode a version
string that contradicts `VERSION`.

---

## 2. Documentation standards

| Standard      | Value                                                                                     |
| ------------- | ----------------------------------------------------------------------------------------- |
| **Format**    | Markdown (`*.md`)                                                                         |
| **Filenames** | `SCREAMING-SNAKE-CASE.md` (e.g. `CONTEXT.md`, `US015.md`)                                 |
| **Location**  | Alongside the layer they document (`code/docs/`, `project-management/docs/`, …)           |
| **Length**    | Instructional `.md` ≤ **300 code lines** — gate: `audits/docs-length.sh`, never `cloc.sh` |

**Instructional-file limit:** every `.md` that instructs Claude Code —
`**/docs/*.md`, `**/workflows/**/*.md`, `.claude/**/*.md`, and all `CONTEXT.md`
files — must not exceed 300 code lines. Oversized files split into focused
sub-documents; the entry point becomes a thin index that cross-references them.
This limit does **not** apply to root-level files (`README.md`, `CHANGELOG.md`,
`GAPS.md`, …) or `**/src/*.md` human operational guides.

### Markdown style

- **Headings** — one `#` title per file; `##` sections; `###` subsections; avoid
  deep nesting. Blank line before and after every heading.
- **Text** — `**bold**` for emphasis (not `__bold__`), `_italic_`, `` `inline code` ``.
  Keep one style throughout.
- **Lists** — `-` for unordered (2-space indent); `1.` for every ordered item
  (auto-renumbers, 3-space indent); `- [ ]` / `- [x]` for task lists.
- **Tables** — GitHub-flavoured pipe syntax; align with `:` on the separator row
  (`:---` left, `:--:` centre, `---:` right).
- **Code fences** — always tag the language for highlighting and to satisfy
  markdownlint MD040: `python`, `bash`, `json`, `sql`, `css`, `html`.
- **Horizontal rules** — `---` between major sections.
- **British English** — follow the localisation table in [SKILL.md](SKILL.md).
- **Line length** — keep under ~120 characters where practical.

A table of contents helps long human-facing docs, but thin instructional files
under the 300-line limit generally do not need one — prefer a short section map.

---

## 3. Bug-fix documentation

Every bug fix (on a `us###/feature` or `hotfix/*` branch) must be recorded as a
Markdown file. Naming follows the project convention:

```
BUG-<DESCRIPTOR>-DD-MM-YYYY.md      e.g. BUG-AUTH-18-04-2026.md
```

Store it under the PM bugs directory (`project-management/src/**/BUGS/`). The
`bugfix` agent owns the full format via `code/workflows/10-debug/`. Each record
must include:

- **Root-cause analysis** — what actually caused the defect.
- **The fix** — how the change resolves it.
- **Prevention** — recommendations to stop a recurrence.
- **Regression test** — the test that now guards the behaviour.

---

## 4. Code-comment standards

All agents writing code follow these rules (they match the `backend`, `frontend`
and `refactor` agent expectations and `code/docs/CODING-PRINCIPLES.md`).

**Comments and docstrings inside a code file carry the _why_ and nothing else.**
The code states the what — names, types, and structure already say what happens,
and a comment restating them is a duplicate fact that drifts. When the what is
not obvious from the code, rename or split the code rather than describe it.

Everything else — the what, the who, the how, the when, the where, the history,
the story it came from — belongs in the developer documentation, which is free to
carry all of it: `code/docs/*`, `CONTEXT.md`, `CHANGELOG.md`,
`VERSION-HISTORY.md`, and the PM artefacts. A code file never repeats it.

**Scope:** application source that ships in a deployable — `.py`, `.html`, `.css`,
`.js`, `.ts`, `.tsx`, `.rs`, `.slint`. Two exemptions, both because the reference
_is_ the content: **declarative configuration** (`deny.toml`, `pyproject.toml`,
`.gitignore`, CI YAML), where a policy exception needs the trail that justifies
it; and the **dev scripts** under `code/src/scripts/`, operator tooling under the
`runbook` discipline that often names the very rule or document it enforces.

### When to write one

Only when the reason is non-obvious and cannot be expressed in code:

- A constraint the code must satisfy but cannot state (a protocol quirk, a driver
  or browser bug, an ordering nothing else enforces).
- An invariant holding across a distance the reader cannot see locally.
- A deliberate trade-off, and what it rejected.
- A workaround, and the condition under which it can be removed.

If deleting the comment would not confuse the next reader, do not write it.

### No outside references

A comment never points out of the code file. **Never** cite a story (`US###`),
sprint, ADR, plan, bug record, ticket or issue number, PR, commit hash,
`code/docs/*` path, URL, person, or date. The reason travels _in_ the comment — a
reader who cannot open the reference still has to understand why.

```python
# WRONG — points outward, ages badly, says nothing on its own
# Set per US042; see code/docs/URL-STRATEGY.md. TODO(sam): revisit 2026-Q4.
DJANGO_ADMIN_PATH = os.environ.get("DJANGO_ADMIN_PATH", "control/")

# CORRECT — the reason is self-contained
# A guessable admin path attracts credential-stuffing traffic, so the prefix is
# configurable and a deployment can move it without a code change.
DJANGO_ADMIN_PATH = os.environ.get("DJANGO_ADMIN_PATH", "control/")
```

### Docstrings

One short line, stating **why** the module, function, or component exists. The
typed signature already carries the parameters, the return, and (with the raising
path) the exceptions, so no `Args:` / `Returns:` / `Raises:` block restates them.

```python
def constant_time_eq(left: bytes, right: bytes) -> bool:
    """Compare without leaking the matching prefix length through timing."""
```

### The one exception — published interface text

A docstring **emitted to a consumer** is interface documentation, not a comment,
and states the full what: Django Ninja endpoint docstrings and `summary` (both
render on the OpenAPI page) and FastMCP tool docstrings (the prompt a model reads
when choosing a tool). Rules: `code/docs/api-design/API-DOCS.md` and
`code/docs/mcp-server/TOOL-DESIGN.md`. Django `verbose_name` and `help_text` are
user-facing copy and follow the same logic.

### No-pronouns rule

Never use pronouns referring to code.

| Do                                             | Don't                              |
| ---------------------------------------------- | ---------------------------------- |
| `Ordering matters — the index is partial`      | `It has to run first or it breaks` |
| `Retried because the provider 502s under load` | `We retry this here`               |

### Never in a committed file

- **Commented-out code** — git history is the recovery mechanism.
- **`TODO` / `FIXME`** — deferred work goes to `DEFERRED.md` or `GAPS.md`, which
  are read and triaged; a comment is neither.
- **A restatement** of a configuration value, a signature, or the line below it.
