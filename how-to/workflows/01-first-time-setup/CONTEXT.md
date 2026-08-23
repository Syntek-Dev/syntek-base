# Workflow: First-Time Setup

The order matters more than the steps do. Steps 1-6 get a stack running; 7-10 settle the brief,
the voice, the visual direction and the sizing envelope — each cheap now and expensive after
the tenth feature, which is why they sit in setup rather than in a backlog.

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/01-first-time-setup/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow the first time you set up this project on a new machine,
or when onboarding a new team member.

It has two halves. **Steps 1–6 give a running stack** and are what a teammate joining an
established project runs. **Steps 7–10 run once per project, before the first feature is
charted**: sharpen the project description, settle the brand voice, settle the visual direction,
then plan scale and architecture. Skip them on an onboarding; do not skip them on a new project.

## Key concepts

- The project runs entirely inside Docker — no local Python or Node installations needed
- Environment files are not committed — copy from `.env.*.example` files
- One deployable, not two: Django serves the pages and the API. Nginx publishes it on host
  port **81** (`http://dev.<%PROJECT_SLUG%>.localhost:81`); 8000 is the container's internal port
- **The description comes before the voice, the voice before the plan, and the plan before the
  feature.** The brief in `CONTEXT.md` says what is being built and for whom; `BRAND-VOICE.md`
  says how the project speaks to that named reader; `/scale-planning` says at what size and
  therefore what is _not_ required. All three are cheap now and expensive after ten features have
  been built on assumptions nobody wrote down.

## Cross-references

### Governing documents

None — setup is sequential; follow STEPS.md in order.

### Related reading

- `how-to/docs/DEVELOPMENT.md` — full command reference
- `how-to/docs/CLI-TOOLING.md` — CLI tools needed during setup
- `project-management/docs/GIT-GUIDE.md` — git config and SSH key setup
- `CONTEXT.md` → _What this project is_ — the brief Step 7 sharpens
- `how-to/src/BRAND-VOICE.md` — the voice Step 8 settles
- `code/docs/VISUAL-DESIGN.md` Section 3 — the visual direction Step 9 settles; the visual half of Step 8's doctrine
- `.claude/skills/scale-planning/SKILL.md` — the Step 10 procedure
- `how-to/src/SCALE-ARCHITECTURE/` · `how-to/src/SERVER-ARCHITECTURE/` — the two snapshots Step 10 fills
- `project-management/workflows/01-feature-map/` — what runs next, once 7 to 10 are done
