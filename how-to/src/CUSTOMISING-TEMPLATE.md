# Customising the Template — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Overview

syntek-base is a GitHub template repository. When you create a new project from it, the
`install.sh` script handles renaming all `project-name` placeholders automatically. This guide
covers everything beyond the rename — adjustments you are expected to make to own the template
as your project.

---

## Step 1 — Create your repository from the template

1. Open [github.com/Syntek-Dev/syntek-base](https://github.com/Syntek-Dev/syntek-base) on GitHub.
2. Click **Use this template → Create a new repository**.
3. Choose your organisation, name, and visibility.
4. Clone your new repository.

---

## Step 2 — Run the install script

```bash
chmod +x install.sh
./install.sh
```

The interactive prompt replaces every occurrence of:

| Placeholder | Replaced with |
| ----------- | ------------- |
| `project-name` | `your-project-name` (kebab-case) |
| `project_name` | `your_project_name` (snake_case) |
| `ProjectName` | `YourProjectName` (PascalCase) |
| `projectname` | `yourprojectname` (lowercase) |

This covers filenames, content, Docker Compose files, Django settings, environment files,
CLAUDE.md, and all documentation.

---

## Step 3 — Update these files manually

After the rename, review and update the following:

### README.md

- Replace the description in the header with your project's purpose.
- Update the **Licence** section if your project is proprietary (the template is MIT; your
  product built on it may have different licensing).
- Update the GitHub URLs to your repository.

### CONTRIBUTING.md

- Update the GitHub URLs and contact details.
- Adjust the quick-links table if you add or remove guides from `how-to/src/`.

### .claude/CLAUDE.md

- Update the project name in the header.
- Adjust the stack overview table if your stack differs from the template defaults.
- Review the MCP server section — remove entries for servers you will not use.

### project-management/docs/GIT-GUIDE.md

- Confirm the branch strategy matches your team's workflow. The default is
  `feature → testing → dev → staging → main`.

### code/src/backend/config/settings/base.py

- Set `TIME_ZONE`, `LANGUAGE_CODE`, and `SITE_NAME` for your project.

### code/src/docker/.env.*.example

- Remove placeholder values and add your project-specific variables.
- Document every variable — future team members read these files as a reference.

---

## Step 4 — Remove what you do not need

The template ships three application layers: backend, frontend, and mobile. Remove the layers
you will not use:

### Removing the mobile app

```bash
rm -rf code/src/mobile/
```

Then remove the `mobile` service from all Docker Compose files and references from:

- `code/src/CONTEXT.md`
- `.claude/CLAUDE.md` (stack overview table)
- `README.md`

### Removing the frontend

```bash
rm -rf code/src/frontend/
```

Remove the `frontend` service from Docker Compose files and update all references.

---

## Step 5 — Initialise your app code

The template ships scaffolding only — no application business logic. Use the Syntek Dev Suite
to initialise the stack:

```bash
/syntek-dev-suite:setup
```

This creates the Django apps, Next.js pages, and connects them via the GraphQL schema.

---

## Step 6 — Write your first user story

Use the PM workflow to capture your first feature:

```bash
enter project-management/
```

Then follow `project-management/workflows/01-story-creation/STEPS.md`.

---

## Keeping your project up to date with the template

The template is not intended to be continuously synced into downstream projects — once you use
it as a base, your project diverges intentionally. However, if you want to pull in specific
improvements made to the template:

1. Add the template as an upstream remote:

```bash
git remote add template git@github.com:Syntek-Dev/syntek-base.git
```

2. Fetch changes:

```bash
git fetch template
```

3. Cherry-pick the specific commit(s) you want:

```bash
git cherry-pick <commit-sha>
```

Wholesale merging from the template is not recommended once your project has diverged.
