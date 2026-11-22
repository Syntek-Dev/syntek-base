#!/usr/bin/env bash
#
# _lib/pnpm-lock.sh — the one reader for pnpm-lock.yaml's dependency-graph document.
#
# Sourced, never executed. Callers: dependencies/update.sh (`_locked_versions`, `_is_direct`)
# and dependencies/audit.sh (the JavaScript legs' importer population).
#
# WHY IT EXISTS. pnpm 12 writes pnpm-lock.yaml as TWO YAML documents (measured 15/11/2026 on
# 12.18.0). The first is new: the `packageManagerDependencies` document, which locks pnpm
# itself and carries its own `importers:` (only `.`), `packages:` and `snapshots:` sections.
# The project's real graph is the second document. A reader that stops at the first
# `importers:` or `packages:` it meets reads pnpm's own lock instead, and reports every real
# dependency absent — with nothing failing. pnpm 11 and earlier wrote one document with no
# `---` separator.
#
# pnpm_lock_graph FILE — print the dependency-graph document of FILE: the LAST YAML document,
# which is the whole file when there is no `---` separator. Prints nothing for a missing file.
pnpm_lock_graph() {
  [[ -f "$1" ]] || return 0
  awk '
    /^---[[:space:]]*$/ { n = 0; next }
    { doc[++n] = $0 }
    END { for (i = 1; i <= n; i++) print doc[i] }' "$1"
}

# pnpm_lock_importers FILE — the graph document's workspace importers, space-separated
# (`.` for the root, then each member's path). Empty when there are none. The awk reads to
# the end rather than `exit`ing after the block: an early exit would SIGPIPE the reader
# upstream, and a caller under `set -o pipefail` would die on a lockfile that parsed cleanly.
pnpm_lock_importers() {
  pnpm_lock_graph "$1" | awk '
    /^importers:/ { i = 1; next }
    i && /^[^ ]/ { i = 0; done = 1 }
    i && !done && /^  [^ ]/ { k = $1; sub(/:$/, "", k); gsub(/\047/, "", k); printf "%s%s", (n++ ? " " : ""), k }'
}
