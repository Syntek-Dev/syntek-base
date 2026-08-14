---
workflow: 03-database-migration
phase: build
skills: [database, stack-django]
model: opus
---

# Django Database Migration — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                            |
| ---- | ------------------------------------------------------------------ |
| 1    | **Guides in code/docs/** → DATA-STRUCTURES.md, ENCRYPTION-GUIDE.md |
| 1    | **External — Framework & Language Docs → Backend** → Django 6.x    |
| 5    | **External — Testing** → pytest, pytest-django                     |

---

## Steps

### Step 1 — Define or Modify Models

```text
backend [describe model change]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **MCP:** code-review-graph

### Step 1a — Register or Update the Model in Django Admin (`/control/`)

After adding or changing a model, update the app's `admin.py`:

- **New model** → add an `@admin.register` class with `list_display`, `list_filter`, `search_fields`, `readonly_fields`, `ordering`.
- **Added fields** → add any new fields to the relevant `list_display` / `readonly_fields` / `search_fields` tuples.
- **Removed fields** → remove them from all admin class tuples (Django will raise `ImproperlyConfigured` if a field listed in admin config no longer exists).
- `auto_now` / `auto_now_add` fields must always be in `readonly_fields`.
- Encrypted fields are not searchable — never add them to `search_fields`.

### Step 2 — Generate Migration

```bash
bash code/src/scripts/database/migrate.sh make
```

Review the generated migration file before applying — confirm it matches intent.

### Step 3 — Apply Migration to Dev Database

```bash
bash code/src/scripts/database/migrate.sh run
```

### Step 4 — Verify

```bash
bash code/src/scripts/database/migrate.sh show
bash code/src/scripts/development/shell.sh
# >>> from apps.<app>.models import <Model>; <Model>.objects.all()
```

### Step 5 — Run Tests

```bash
bash code/src/scripts/tests/backend.sh
```

### Step 6 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 7 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
