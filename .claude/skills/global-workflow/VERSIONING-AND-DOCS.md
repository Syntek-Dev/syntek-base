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

| Standard      | Value                                                                           |
| ------------- | ------------------------------------------------------------------------------- |
| **Format**    | Markdown (`*.md`)                                                               |
| **Filenames** | `SCREAMING-SNAKE-CASE.md` (e.g. `CONTEXT.md`, `US015.md`)                       |
| **Location**  | Alongside the layer they document (`code/docs/`, `project-management/docs/`, …) |
| **Length**    | Instructional `.md` files ≤ **300 code lines** (`cloc --include-lang=Markdown`) |

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

All agents writing code follow these rules (they match the `backend` and
`frontend` agent expectations and `code/docs/CODING-PRINCIPLES.md`).

### File headers

Every source file opens with a module docstring/header comment stating its
purpose — no pronouns.

### Docstrings

Every public function, method, endpoint, or component has a docstring covering:

- What it does (not how).
- Parameters with types.
- Return value with type.
- Exceptions raised.

Django Ninja example:

```python
def list_client_projects(user_id: UUID) -> list[Project]:
    """Return the projects owned by the given user.

    Args:
        user_id: UUID of the authenticated caller, verified for ownership.

    Returns:
        Projects visible to the caller under row-level security.

    Raises:
        PermissionDenied: When the caller lacks the projects.view policy.
    """
```

### No-pronouns rule

Never use pronouns referring to code in comments or docstrings.

| Do                                   | Don't                    |
| ------------------------------------ | ------------------------ |
| `The function validates input`       | `It validates the input` |
| `Returns the user object`            | `Returns this`           |
| `The service handles authentication` | `We handle auth here`    |

Complex logic gets an inline comment explaining **what** and **why**, never a
restatement of the code.
