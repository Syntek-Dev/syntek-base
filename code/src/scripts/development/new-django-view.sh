#!/usr/bin/env bash
# Scaffold a new public marketing page: a Django view function + a template stub
# that extends marketing/base.html + a urls.py entry in apps.marketing.
#
# The public marketing frontend is Django templates (django-components + HTMX + Alpine).
#
# Usage: bash code/src/scripts/development/new-django-view.sh <route_path>
# Examples:
#   bash code/src/scripts/development/new-django-view.sh case-studies
#   bash code/src/scripts/development/new-django-view.sh guides/accessibility
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

cd "$PROJECT_ROOT"

ROUTE_PATH="${1:-}"

if [[ -z "${ROUTE_PATH}" ]]; then
  echo "Usage: bash code/src/scripts/development/new-django-view.sh <route_path>" >&2
  exit 1
fi

# Strip any surrounding slashes; slugs are lowercase letters, digits, hyphens, slashes.
ROUTE_PATH="${ROUTE_PATH#/}"
ROUTE_PATH="${ROUTE_PATH%/}"
if [[ ! "${ROUTE_PATH}" =~ ^[a-z0-9][a-z0-9/-]*$ ]]; then
  echo "Error: route_path must be lowercase letters, digits, hyphens, and slashes only." >&2
  exit 1
fi

MARKETING="code/src/django/apps/marketing"
URLS="${MARKETING}/urls.py"
TEMPLATE_DIR="code/src/django/templates/marketing"

# Pre-flight. This scaffolder writes into an existing marketing app — it does not
# create one. The baseline template has no apps at all, so without this check the
# script fails halfway through with a bare redirection error and leaves nothing
# useful behind. Each missing piece is named so the fix is obvious.
missing=()
[[ -d "${MARKETING}"     ]] || missing+=("${MARKETING}/ (create it: bash code/src/scripts/development/new-django-app.sh marketing)")
[[ -d "${MARKETING}/views" ]] || missing+=("${MARKETING}/views/ (package holding one module per page)")
[[ -f "${URLS}"          ]] || missing+=("${URLS} (with a 'urlpatterns = [' list)")
[[ -f "${MARKETING}/seo.py" ]] || missing+=("${MARKETING}/seo.py (providing build_seo)")
[[ -d "${TEMPLATE_DIR}"  ]] || missing+=("${TEMPLATE_DIR}/ (holding base.html)")

if (( ${#missing[@]} > 0 )); then
  echo "Error: the marketing app is not scaffolded yet. Missing:" >&2
  printf '  • %s\n' "${missing[@]}" >&2
  echo "" >&2
  echo "This script adds a page to an existing marketing app; it does not create one." >&2
  echo "See code/docs/ARCHITECTURE-PATTERNS.md and code/docs/URL-STRATEGY.md." >&2
  exit 1
fi

# Derive names from the last path segment.
SEGMENT="${ROUTE_PATH##*/}"                 # e.g. case-studies
MODULE="${SEGMENT//-/_}"                    # python-safe module/function name: case_studies
URL_NAME="${SEGMENT}"                       # url name keeps hyphens: case-studies
# Title Case from the segment: "case-studies" -> "Case Studies"
TITLE=$(echo "${SEGMENT}" | sed -E 's/-/ /g; s/(^| )([a-z])/\1\u\2/g')

VIEW_FILE="${MARKETING}/views/${MODULE}.py"
TEMPLATE_FILE="${TEMPLATE_DIR}/${MODULE}.html"

if [[ -f "${VIEW_FILE}" ]]; then
  echo "Error: ${VIEW_FILE} already exists." >&2
  exit 1
fi
if [[ -f "${TEMPLATE_FILE}" ]]; then
  echo "Error: ${TEMPLATE_FILE} already exists." >&2
  exit 1
fi

echo "Scaffolding marketing page /${ROUTE_PATH}/ ..."

# ── View function ─────────────────────────────────────────────────────────────
cat > "${VIEW_FILE}" <<PYEOF
"""${TITLE} marketing page (\`/${ROUTE_PATH}/\`).

Scaffolded by new-django-view.sh. Supplies an \`seo\` dict (build_seo) and renders
\`marketing/${MODULE}.html\`, which extends \`marketing/base.html\`. Pull published content
from the domain services directly (SSR) — never an admin-gated Django Ninja endpoint.
"""

from __future__ import annotations

from django.shortcuts import render

from .. import seo as seo_lib


def ${MODULE}(request):
    """${TITLE} page (\`/${ROUTE_PATH}/\`)."""
    ctx = {
        "seo": seo_lib.build_seo(
            title="${TITLE} | <%PROJECT_NAME%>",
            description="TODO: SEO description for the ${TITLE} page (<= 160 characters).",
            path="/${ROUTE_PATH}/",
        ),
    }
    return render(request, "marketing/${MODULE}.html", ctx)
PYEOF

# ── Template stub (extends the marketing base) ────────────────────────────────
cat > "${TEMPLATE_FILE}" <<'HTMLEOF'
{% extends "marketing/base.html" %}
{% comment %}__TITLE__ page (`/__ROUTE__/`) — scaffolded by new-django-view.sh.
Server-render first; HTMX for server ops (always with a visible indicator); Alpine for local
interactions. hx-boost is banned. Token-first CSS only (var(--token)).{% endcomment %}
{% load static %}

{% block page_css %}{# <link rel="stylesheet" href="{% static 'css/pages/__MODULE__.css' %}"> #}{% endblock %}

{% block marketing_content %}
  <section class="__MODULE__">
    <h1>__TITLE__</h1>
    <p>TODO: page content. Reuse a django-component from code/src/django/components/ rather
       than inlining markup.</p>
  </section>
{% endblock %}
HTMLEOF
# Fill the template placeholders (kept literal in the heredoc so template tags survive).
sed -i "s/__TITLE__/${TITLE}/g; s|__ROUTE__|${ROUTE_PATH}|g; s/__MODULE__/${MODULE}/g" "${TEMPLATE_FILE}"

# ── urls.py entry (best-effort auto-insert; prints the line to add on failure) ─
python3 - "$URLS" "$MODULE" "$ROUTE_PATH" "$URL_NAME" <<'PYINS'
import sys

urls_path, module, route, name = sys.argv[1:5]
src = open(urls_path, encoding="utf-8").read()

import_line = f"from .views import {module}\n"
path_line = f'    path("{route}/", cm({module}.{module}), name="{name}"),\n'

if f'name="{name}"' in src or f"from .views import {module}\n" in src:
    print(f"  urls.py already references '{name}' / '{module}' — skipping auto-insert.")
    sys.exit(0)

lines = src.splitlines(keepends=True)
out, added_import, added_path = [], False, False
for line in lines:
    out.append(line)
    if not added_import and line.startswith("from .views.home import home"):
        out.append(import_line)
        added_import = True
    if not added_path and line.strip() == "urlpatterns = [":
        out.append(path_line)
        added_path = True

if added_import and added_path:
    open(urls_path, "w", encoding="utf-8").write("".join(out))
    print(f"  urls.py: added import + route (name='{name}').")
else:
    print("  Could not auto-edit urls.py — add these to apps/marketing/urls.py manually:")
    print(f"    {import_line.rstrip()}")
    print(f"    {path_line.strip()}")
    print("  (Anonymous GET pages are wrapped with cm(...) for the page cache; a POST/CSRF")
    print("   page like the contact form must NOT be cached — register it without cm().)")
PYINS

echo ""
echo "Done. Marketing page /${ROUTE_PATH}/ scaffolded:"
echo "  view:     ${VIEW_FILE}"
echo "  template: ${TEMPLATE_FILE}"
echo "Next:"
echo "  • Verify apps/marketing/urls.py registers the route (cache with cm() if anonymous GET)."
echo "  • Fill the SEO description + JSON-LD in the view (see apps/marketing/seo.build_seo)."
echo "  • Add page copy via django-components; token-first CSS only. Verify the route renders 200."
