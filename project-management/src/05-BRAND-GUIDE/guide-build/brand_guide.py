#!/usr/bin/env python3
"""
brand_guide.py — source-of-truth generator for the Brand Guidelines PDF.

This Python file is the single source of truth for the brand guide. Edit the
INPUTS section below (colours, typography, spacing, logo rules, voice, and the
appendix tokens) and re-run to regenerate the sibling `brand-guide.tex` and
`brand-guide.pdf`. Do NOT hand-edit the generated `.tex` / `.pdf` — they are
overwritten on every run.

The guide ships with a GENERIC PLACEHOLDER brand. A new project fills in its own
tokens here and re-runs; nothing downstream needs to change. Swatches, type
specimens, and spacing bars are drawn programmatically from the token data, so
the PDF always matches the values in this file.

Pipeline (mirrors projectname-business-docs): the script writes a `.tex` and compiles
it to PDF with **xelatex** (run twice for stable layout). xelatex + the TeX Gyre
Heros font ship with any `texlive-xetex` install, so the template is portable.

Usage:
    python3 brand_guide.py             # regenerate brand-guide.tex + brand-guide.pdf
    python3 brand_guide.py --no-pdf    # regenerate the .tex only (skip xelatex)
    python3 brand_guide.py --check     # verify committed .tex matches; writes nothing

Standard library only (no dependencies). British English throughout.
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
TEX_OUT = HERE / "brand-guide.tex"
PDF_OUT = HERE / "brand-guide.pdf"


# =========================================================================== #
# INPUTS — the brand token data. This is the single source of truth.
# Edit these values and re-run. Everything below RENDERERS is derived.
# =========================================================================== #

BRAND = {
    "name": "Your Brand",
    "tagline": "A short, memorable statement of what you stand for.",
    "version": "0.1.0",
    "date": "DD/MM/YYYY",
    "intro": (
        "These are the brand guidelines for Your Brand. They define the visual "
        "and verbal system — colour, typography, spacing, logo usage, and voice "
        "— so that every touchpoint is consistent. Replace the placeholder "
        "values in guide-build/brand_guide.py with your own tokens and re-run to "
        "regenerate this document."
    ),
}

# Colour groups: (group name, [(swatch name, hex, role)]). Hex drives the swatch.
COLOUR_GROUPS = [
    (
        "Brand",
        [
            ("Primary", "#222933", "Primary brand colour"),
            ("Secondary", "#52606D", "Supporting brand colour"),
            ("Accent", "#3B82C4", "Interactive / highlight"),
        ],
    ),
    (
        "Neutral",
        [
            ("Ink 900", "#1A1D21", "Body text on light"),
            ("Grey 700", "#3E4650", "Headings, strong text"),
            ("Grey 500", "#6B7280", "Muted / secondary text"),
            ("Grey 300", "#C7CDD4", "Borders, dividers"),
            ("Grey 100", "#EEF1F4", "Subtle fills, panels"),
            ("Paper", "#FFFFFF", "Base surface"),
        ],
    ),
    (
        "Semantic",
        [
            ("Success", "#2F9E44", "Positive / confirmed"),
            ("Warning", "#E8A317", "Caution / pending"),
            ("Error", "#D64545", "Destructive / failed"),
            ("Info", "#3B82C4", "Neutral information"),
        ],
    ),
]

# Typography families: (role, intended family, note). The specimen renders in the
# compile font (TeX Gyre Heros) as a stand-in — swap in your own font downstream.
TYPE_FAMILIES = [
    ("Headings", "Inter (placeholder)", "Geometric sans; weights 600–700"),
    ("Body", "Inter (placeholder)", "Same family; weights 400–500"),
    ("Mono", "JetBrains Mono (placeholder)", "Code, tokens, data"),
]

# Type scale: (name, size_pt, leading_pt, weight, use).
TYPE_SCALE = [
    ("Display", 40, 46, "Bold", "Hero headlines"),
    ("Heading 1", 32, 38, "Bold", "Page titles"),
    ("Heading 2", 24, 30, "Semibold", "Section headings"),
    ("Heading 3", 20, 26, "Semibold", "Subsections"),
    ("Body Large", 18, 28, "Regular", "Lead paragraphs"),
    ("Body", 16, 26, "Regular", "Default body text"),
    ("Small", 14, 22, "Regular", "Secondary text"),
    ("Caption", 12, 18, "Regular", "Labels and captions"),
]

# Spacing scale: (token, px). Base unit stated separately.
SPACING_BASE_PX = 4
SPACING_SCALE = [
    ("space-0", 0),
    ("space-1", 4),
    ("space-2", 8),
    ("space-3", 12),
    ("space-4", 16),
    ("space-6", 24),
    ("space-8", 32),
    ("space-12", 48),
    ("space-16", 64),
    ("space-24", 96),
]

# Radius scale: (token, px label, use).
RADIUS_SCALE = [
    ("radius-none", "0", "Sharp edges"),
    ("radius-sm", "4", "Inputs, chips"),
    ("radius-md", "8", "Cards, buttons"),
    ("radius-lg", "16", "Modals, panels"),
    ("radius-pill", "999", "Pills, tags"),
    ("radius-full", "50%", "Avatars, circular"),
]

# Logo usage rules (prose bullets).
LOGO_RULES = [
    "Clear space: keep padding equal to the height of the logo mark on every side.",
    "Minimum size: 24 px tall on screen, 15 mm tall in print.",
    "Use the full-colour mark on light surfaces and the reversed (white) mark on "
    "dark or busy backgrounds.",
    "Do not stretch, rotate, recolour, add effects to, or crop the mark.",
    "Keep the mark clear of competing imagery and maintain strong contrast.",
    "Source files live in project-management/src/00-ASSETS/LOGOS/ (SVG source of "
    "truth plus raster exports).",
]

# Voice and tone.
VOICE = {
    "traits": ["Clear", "Confident", "Human", "Concise"],
    "tagline": BRAND["tagline"],
    "do": [
        "Write in plain, active language.",
        "Lead with the benefit to the reader.",
        "Use British English spelling.",
        "Keep sentences short and scannable.",
    ],
    "dont": [
        "Use jargon, buzzwords, or acronyms unexplained.",
        "Over-promise or lean on hype.",
        "Switch tone or register mid-journey.",
        "Pad sentences with filler words.",
    ],
}

# Appendix tokens — summarised as tables (they read poorly as static visuals).
MOTION_DURATIONS = [
    ("motion-instant", "0 ms", "No transition"),
    ("motion-fast", "120 ms", "Hovers, small state changes"),
    ("motion-base", "200 ms", "Default transitions"),
    ("motion-slow", "320 ms", "Overlays, drawers"),
    ("motion-deliberate", "480 ms", "Page-level motion"),
]
MOTION_EASINGS = [
    ("ease-standard", "cubic-bezier(0.2, 0, 0, 1)", "Most transitions"),
    ("ease-decelerate", "cubic-bezier(0, 0, 0, 1)", "Entering elements"),
    ("ease-accelerate", "cubic-bezier(0.3, 0, 1, 1)", "Exiting elements"),
]
ELEVATION = [
    ("shadow-xs", "0 1px 2px rgba(0,0,0,.06)", "Subtle lift"),
    ("shadow-sm", "0 1px 3px rgba(0,0,0,.10)", "Cards at rest"),
    ("shadow-md", "0 4px 8px rgba(0,0,0,.12)", "Raised cards"),
    ("shadow-lg", "0 8px 20px rgba(0,0,0,.14)", "Popovers, menus"),
    ("shadow-xl", "0 16px 32px rgba(0,0,0,.18)", "Modals"),
    ("shadow-focus", "0 0 0 3px rgba(59,130,196,.45)", "Focus ring"),
]
DARK_PAIRS = [
    ("Surface", "#FFFFFF", "#14171A"),
    ("Surface raised", "#F5F7FA", "#1D2126"),
    ("Text", "#1A1D21", "#E6E9EC"),
    ("Muted text", "#6B7280", "#9AA4AF"),
    ("Border", "#E1E5EA", "#2A2F36"),
    ("Accent", "#3B82C4", "#5AA6E0"),
]
ICON_SIZES = [
    ("icon-xs", "12 px", "Inline, dense UI"),
    ("icon-sm", "16 px", "Buttons, labels"),
    ("icon-md", "20 px", "Default UI icons"),
    ("icon-lg", "24 px", "Primary actions"),
    ("icon-xl", "32 px", "Feature icons"),
    ("icon-2xl", "48 px", "Empty states, marketing"),
]


# =========================================================================== #
# LaTeX HELPERS
# =========================================================================== #

_TEX_SPECIALS = {
    "\\": r"\textbackslash{}",
    "&": r"\&",
    "%": r"\%",
    "$": r"\$",
    "#": r"\#",
    "_": r"\_",
    "{": r"\{",
    "}": r"\}",
    "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}",
}


def tex(s: str) -> str:
    """Escape a string for safe use as LaTeX body text."""
    out = []
    for ch in str(s):
        out.append(_TEX_SPECIALS.get(ch, ch))
    return "".join(out)


def hexonly(h: str) -> str:
    return h.lstrip("#").upper()


def sample_for(size: int) -> str:
    return "The quick brown fox" if size >= 22 else "The quick brown fox jumps over the lazy dog"


# The static preamble. `<<FOOTER>>` is substituted before writing. Braces here are
# literal LaTeX (this is a normal string, not an f-string).
PREAMBLE = r"""% !TEX program = xelatex
% GENERATED by guide-build/brand_guide.py — do not edit by hand. Edit the INPUTS in the
% Python source and re-run to regenerate this file.
\documentclass[11pt]{article}
\usepackage[a4paper,margin=20mm]{geometry}
\usepackage{fontspec}
\usepackage[table]{xcolor}
\usepackage{array}
\usepackage{tabularx}
\usepackage{ragged2e}
\usepackage{enumitem}
\usepackage{fancyhdr}
\usepackage[hidelinks]{hyperref}

\setmainfont{TeX Gyre Heros}
\setmonofont{DejaVu Sans Mono}[Scale=0.85]

\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}

% Structural brand colours (independent of the palette on the colour page).
\definecolor{ink}{HTML}{1A1D21}
\definecolor{muted}{HTML}{6B7280}
\definecolor{accent}{HTML}{3B82C4}
\definecolor{swatchrule}{HTML}{C7CDD4}
\definecolor{panel}{HTML}{EEF1F4}

\setlist[itemize]{leftmargin=5mm,itemsep=2pt,topsep=2pt}

% A section heading with an accent rule beneath.
\newcommand{\brandsection}[1]{%
  \par\addvspace{4mm}%
  {\LARGE\bfseries\color{ink}#1}\par\vspace{1.5mm}%
  {\color{accent}\rule{\linewidth}{2pt}}\par\vspace{5mm}%
}

% A single colour swatch cell: fill, name, hex, role. Four fit per row.
% The swatch fill is a 36mm x 15mm block: a zero-width rule sets the height and a
% zero-height rule sets the width, and \fcolorbox fills the bounding box.
\newcommand{\swatchcell}[4]{%
  \begin{minipage}[t]{0.235\linewidth}%
    \fcolorbox{swatchrule}{#1}{\rule{0pt}{15mm}\rule{36mm}{0pt}}\\[3pt]%
    {\footnotesize\bfseries #2}\\%
    {\ttfamily\scriptsize #3}\\%
    {\scriptsize\color{muted}#4}%
  \end{minipage}%
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[L]{\footnotesize\color{muted}<<FOOTER>>}
\fancyfoot[R]{\footnotesize\color{muted}\thepage}

\begin{document}
"""


def render_cover() -> str:
    name = tex(BRAND["name"])
    tagline = tex(BRAND["tagline"])
    version = tex(BRAND["version"])
    date = tex(BRAND["date"])
    return (
        r"\thispagestyle{empty}"
        "\n"
        r"\vspace*{28mm}"
        "\n"
        r"{\color{accent}\rule{40mm}{4pt}}\par\vspace{10mm}"
        "\n"
        r"{\fontsize{52}{58}\selectfont\bfseries\color{ink}" + name + r"}\par\vspace{4mm}"
        "\n"
        r"{\fontsize{22}{28}\selectfont\color{muted}Brand Guidelines}\par\vspace{8mm}"
        "\n"
        r"{\large\color{ink}" + tagline + r"}\par\vspace{18mm}"
        "\n"
        r"\fbox{\parbox[c][34mm][c]{70mm}{\centering\large\color{muted}[ LOGO ]}}\par"
        "\n"
        r"\vfill"
        "\n"
        r"{\footnotesize\color{muted}Version "
        + version
        + r" \quad\textbullet\quad "
        + date
        + r" \quad\textbullet\quad Generated from guide-build/brand\_guide.py}\par"
        "\n"
        r"\clearpage"
        "\n"
    )


def render_intro() -> str:
    return (
        r"\brandsection{Overview}"
        "\n" + r"{\large " + tex(BRAND["intro"]) + r"}\par\vspace{4mm}"
        "\n"
        r"\begin{itemize}"
        "\n"
        r"\item \textbf{Colour} — brand, neutral, and semantic palette."
        "\n"
        r"\item \textbf{Typography} — families and the type scale."
        "\n"
        r"\item \textbf{Spacing \& radius} — the layout rhythm."
        "\n"
        r"\item \textbf{Logo} — usage rules and clear space."
        "\n"
        r"\item \textbf{Voice \& tone} — how the brand sounds."
        "\n"
        r"\item \textbf{Token appendix} — motion, elevation, dark mode, icons."
        "\n"
        r"\end{itemize}"
        "\n"
        r"\clearpage"
        "\n"
    )


def render_colours() -> tuple[str, str]:
    """Return (colour definitions, colour page body)."""
    defs = []
    body = [r"\brandsection{Colour}"]
    cid = 0
    for group, swatches in COLOUR_GROUPS:
        body.append(r"{\large\bfseries\color{ink}" + tex(group) + r"}\par\vspace{3mm}")
        cells = []
        for name, hx, role in swatches:
            token = f"c{cid}"
            cid += 1
            defs.append(r"\definecolor{" + token + r"}{HTML}{" + hexonly(hx) + r"}")
            cell = (
                r"\swatchcell{"
                + token
                + r"}{"
                + tex(name)
                + r"}{\#"
                + hexonly(hx)
                + r"}{"
                + tex(role)
                + r"}"
            )
            cells.append(cell)
        # Lay out four swatches per row.
        for i in range(0, len(cells), 4):
            row = cells[i : i + 4]
            body.append(r"\noindent" + r"\hfill".join(row) + r"\par\vspace{7mm}")
        body.append(r"\vspace{2mm}")
    body.append(r"\clearpage")
    return "\n".join(defs) + "\n", "\n".join(body) + "\n"


def render_type() -> str:
    body = [r"\brandsection{Typography}"]
    # Families table.
    body.append(r"{\large\bfseries\color{ink}Type families}\par\vspace{3mm}")
    body.append(r"\begin{tabularx}{\linewidth}{@{}l l X@{}}")
    body.append(
        r"\rowcolor{ink}\textcolor{white}{\textbf{Role}} & "
        r"\textcolor{white}{\textbf{Family}} & \textcolor{white}{\textbf{Notes}} \\"
    )
    for role, family, note in TYPE_FAMILIES:
        body.append(tex(role) + r" & " + tex(family) + r" & " + tex(note) + r" \\")
    body.append(r"\end{tabularx}\par\vspace{7mm}")
    # Scale specimens.
    body.append(r"{\large\bfseries\color{ink}Type scale}\par\vspace{4mm}")
    for name, size, lead, weight, use in TYPE_SCALE:
        bold = r"\bfseries " if weight in {"Bold", "Semibold", "Black"} else ""
        sample = tex(sample_for(size))
        meta = f"{name}  \\textbullet\\  {size}/{lead} pt  \\textbullet\\  {weight}  \\textbullet\\  {use}"
        body.append(
            r"\noindent{\fontsize{"
            + str(size)
            + r"}{"
            + str(lead)
            + r"}\selectfont "
            + bold
            + sample
            + r"}\par\nobreak\vspace{1mm}"
            + r"{\small\color{muted}"
            + meta
            + r"}\par\vspace{4mm}"
        )
    body.append(r"\clearpage")
    return "\n".join(body) + "\n"


def render_spacing() -> str:
    body = [r"\brandsection{Spacing \& Radius}"]
    body.append(
        r"{\large\bfseries\color{ink}Spacing scale}\par"
        r"{\color{muted}Base unit: "
        + str(SPACING_BASE_PX)
        + r" px. Every gap is a multiple of the base.}\par\vspace{5mm}"
    )
    for token, px in SPACING_SCALE:
        w = max(0.2, px * 0.40)
        body.append(
            r"\noindent\makebox[26mm][l]{\ttfamily\small "
            + tex(token)
            + r"}"
            + r"\textcolor{accent}{\rule{"
            + f"{w:.2f}"
            + r"mm}{3.5mm}}\quad"
            + r"{\small\color{muted}"
            + str(px)
            + r" px}\par\vspace{2.6mm}"
        )
    body.append(r"\vspace{4mm}{\large\bfseries\color{ink}Radius scale}\par\vspace{3mm}")
    body.append(r"\begin{tabularx}{\linewidth}{@{}l l X@{}}")
    body.append(
        r"\rowcolor{ink}\textcolor{white}{\textbf{Token}} & "
        r"\textcolor{white}{\textbf{Value}} & \textcolor{white}{\textbf{Use}} \\"
    )
    for token, px, use in RADIUS_SCALE:
        body.append(r"\texttt{" + tex(token) + r"} & " + tex(px) + r" & " + tex(use) + r" \\")
    body.append(r"\end{tabularx}")
    body.append(r"\clearpage")
    return "\n".join(body) + "\n"


def render_logo() -> str:
    body = [r"\brandsection{Logo}"]
    body.append(
        r"\noindent\fbox{\parbox[c][40mm][c]{\dimexpr\linewidth-2\fboxsep-2\fboxrule\relax}"
        r"{\centering\Large\color{muted}[ LOGO PLACEHOLDER ]\\[2mm]"
        r"{\normalsize Add the mark to 00-ASSETS/LOGOS/ and reference it here}}}"
        r"\par\vspace{7mm}"
    )
    body.append(r"{\large\bfseries\color{ink}Usage rules}\par\vspace{2mm}")
    body.append(r"\begin{itemize}")
    for rule in LOGO_RULES:
        body.append(r"\item " + tex(rule))
    body.append(r"\end{itemize}")
    body.append(r"\clearpage")
    return "\n".join(body) + "\n"


def render_voice() -> str:
    body = [r"\brandsection{Voice \& Tone}"]
    body.append(
        r"{\large\color{ink}Tagline}\par"
        r"{\LARGE\bfseries\color{accent}" + tex(VOICE["tagline"]) + r"}\par\vspace{6mm}"
    )
    body.append(r"{\large\bfseries\color{ink}Personality}\par\vspace{2mm}")
    traits = r" \quad\textbullet\quad ".join(tex(t) for t in VOICE["traits"])
    body.append(r"{\large\color{muted}" + traits + r"}\par\vspace{7mm}")
    # Do / Don't two columns.
    body.append(r"\noindent\begin{minipage}[t]{0.48\linewidth}")
    body.append(r"{\large\bfseries\color{ink}Do}\par\vspace{1mm}\begin{itemize}")
    for d in VOICE["do"]:
        body.append(r"\item " + tex(d))
    body.append(r"\end{itemize}\end{minipage}\hfill\begin{minipage}[t]{0.48\linewidth}")
    body.append(r"{\large\bfseries\color{ink}Don't}\par\vspace{1mm}\begin{itemize}")
    for d in VOICE["dont"]:
        body.append(r"\item " + tex(d))
    body.append(r"\end{itemize}\end{minipage}")
    body.append(r"\clearpage")
    return "\n".join(body) + "\n"


def _token_table(title: str, headers: tuple[str, str, str], rows) -> str:
    out = [r"{\large\bfseries\color{ink}" + tex(title) + r"}\par\vspace{2mm}"]
    out.append(r"\begin{tabularx}{\linewidth}{@{}l l X@{}}")
    out.append(
        r"\rowcolor{ink}\textcolor{white}{\textbf{"
        + tex(headers[0])
        + r"}} & \textcolor{white}{\textbf{"
        + tex(headers[1])
        + r"}} & \textcolor{white}{\textbf{"
        + tex(headers[2])
        + r"}} \\"
    )
    for a, b, c in rows:
        out.append(r"\texttt{" + tex(a) + r"} & " + tex(b) + r" & " + tex(c) + r" \\")
    out.append(r"\end{tabularx}\par\vspace{6mm}")
    return "\n".join(out)


def render_appendix() -> str:
    body = [r"\brandsection{Token Appendix}"]
    body.append(
        r"{\color{muted}Motion, elevation, dark mode, and icon tokens. "
        r"These are recorded here rather than drawn, as they do not read "
        r"well as static print.}\par\vspace{6mm}"
    )
    body.append(_token_table("Motion — duration", ("Token", "Value", "Use"), MOTION_DURATIONS))
    body.append(_token_table("Motion — easing", ("Token", "Curve", "Use"), MOTION_EASINGS))
    body.append(_token_table("Elevation", ("Token", "Shadow", "Use"), ELEVATION))
    body.append(_token_table("Dark mode pairs", ("Token", "Light", "Dark"), DARK_PAIRS))
    body.append(_token_table("Icon sizes", ("Token", "Size", "Use"), ICON_SIZES))
    return "\n".join(body) + "\n"


def render_tex() -> str:
    colour_defs, colour_body = render_colours()
    parts = [
        PREAMBLE.replace("<<FOOTER>>", tex(BRAND["name"]) + " — Brand Guidelines"),
        colour_defs,
        render_cover(),
        render_intro(),
        colour_body,
        render_type(),
        render_spacing(),
        render_logo(),
        render_voice(),
        render_appendix(),
        r"\end{document}" + "\n",
    ]
    return "\n".join(parts)


# =========================================================================== #
# OUTPUT + CLI
# =========================================================================== #


def compile_pdf(tex_path: Path, pdf_path: Path) -> None:
    """Compile a .tex to PDF with xelatex (run twice for stable layout)."""
    xelatex = shutil.which("xelatex")
    if not xelatex:
        raise RuntimeError("xelatex not found. Install it with: sudo apt install texlive-xetex")
    with tempfile.TemporaryDirectory(prefix="brandguide_") as tmp:
        cmd = [
            xelatex,
            "-interaction=nonstopmode",
            "-halt-on-error",
            "-output-directory",
            tmp,
            str(tex_path),
        ]
        result = None
        for _ in range(2):
            result = subprocess.run(cmd, capture_output=True, text=True, cwd=str(tex_path.parent))
            if result.returncode != 0:
                break
        if result is None or result.returncode != 0:
            log = Path(tmp) / (tex_path.stem + ".log")
            errs = ""
            if log.exists():
                errs = "\n".join(
                    ln for ln in log.read_text(errors="replace").splitlines() if ln.startswith("!")
                )[:1200]
            raise RuntimeError(
                f"xelatex failed:\n{errs or (result.stderr[:1000] if result else '')}"
            )
        produced = Path(tmp) / (tex_path.stem + ".pdf")
        if not produced.exists():
            raise RuntimeError("xelatex reported success but produced no PDF.")
        shutil.move(str(produced), str(pdf_path))


def cmd_write(make_pdf: bool) -> int:
    tex_src = render_tex()
    TEX_OUT.write_text(tex_src, encoding="utf-8")
    print(f"wrote {TEX_OUT.name}")
    if make_pdf:
        compile_pdf(TEX_OUT, PDF_OUT)
        size = PDF_OUT.stat().st_size
        print(f"wrote {PDF_OUT.name}  ({size / 1024:.1f} KB)")
    return 0


def cmd_check() -> int:
    gen = render_tex()
    if not TEX_OUT.exists():
        print(f"MISS {TEX_OUT.name}: no committed file to reconcile against")
        return 1
    cur = TEX_OUT.read_text(encoding="utf-8")
    if cur == gen:
        print(f"OK   {TEX_OUT.name}  (byte-identical, {len(gen)} bytes)")
        return 0
    print(f"DIFF {TEX_OUT.name}: committed .tex is out of date — re-run to regenerate.")
    gl, cl = gen.splitlines(), cur.splitlines()
    for i in range(max(len(gl), len(cl))):
        g = gl[i] if i < len(gl) else "<none>"
        c = cl[i] if i < len(cl) else "<none>"
        if g != c:
            print(f"     line {i + 1}:\n       committed: {c!r}\n       generated: {g!r}")
            break
    return 1


def main(argv=None) -> int:
    p = argparse.ArgumentParser(description="Generate the Brand Guidelines PDF.")
    p.add_argument("--no-pdf", action="store_true", help="regenerate the .tex only; skip xelatex")
    p.add_argument(
        "--check", action="store_true", help="verify the committed .tex matches; write nothing"
    )
    args = p.parse_args(argv)
    if args.check:
        return cmd_check()
    return cmd_write(make_pdf=not args.no_pdf)


if __name__ == "__main__":
    sys.exit(main())
