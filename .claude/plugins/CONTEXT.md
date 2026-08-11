# .claude/plugins

Agent helper scripts — Python scripts each agent can call (`python3 .claude/plugins/<name>.py …`)
to **inspect** the local environment for context. They are **not** MCP servers and **not** a route
for dev operations: anything that builds, tests, migrates, or runs the stack goes through
`code/src/scripts/**/*.sh`. These scripts only read and detect.

## Directory Tree

```text
.claude/plugins/
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── db-tool.py               ← database detection and connection info
├── env-tool.py              ← environment-file discovery, comparison, validation
├── git-tool.py              ← repository status, branch, remote, commit history
├── log-tool.py              ← log-file discovery, logging config, recent-log extraction
├── pm-tool.py               ← PM-tool config detection (ClickUp, Linear, Jira, …)
└── project-tool.py          ← project structure and technology-stack detection
```

## Files

| File              | Purpose                                                             |
| ----------------- | ------------------------------------------------------------------- |
| `project-tool.py` | Project structure and technology-stack detection                    |
| `env-tool.py`     | Environment-file discovery, comparison, and validation              |
| `db-tool.py`      | Database detection and connection info                              |
| `git-tool.py`     | Repository status, branch, remote, and commit-history inspection    |
| `log-tool.py`     | Log-file discovery, logging-config detection, recent-log extraction |
| `pm-tool.py`      | Project-management tool config detection (ClickUp, Linear, Jira, …)  |
