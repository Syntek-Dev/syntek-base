#!/usr/bin/env python3
"""copier-commands.py — the `_tasks` and `_migrations` commands of a copier.yml, decoded, and
its `_exclude` entries (round 10).

Read by shipped-boards.sh checks 1 and 2 (run as `python3 -I`, standard library only: the project's
python3 has no YAML library, and the pre-commit leg adds no dependency). It is a MINIMAL YAML
reader for the shapes those two lists are written in, never a general parser:

  - each list item is a scalar (a string task) or a block mapping of scalar keys to scalar values;
  - a scalar is plain, single-quoted, double-quoted or a `|` / `>` block scalar, and is DECODED as
    YAML decodes it — a double-quoted scalar's escapes (`\\x2e`, `\\u002e`, `\\U0000002e`, `\\t`,
    `\\/`, an escaped line break, ...), a single-quoted `''`, line folding, block chomping — so
    check 2 reads the text copier hands to the shell, not the text in the file;
  - keys are compared after decoding, and a key repeated inside one item (two `when:`) is an
    error, never "the last one wins" read silently;
  - anything else in those lists — a flow collection, an anchor, an alias, a tag, a complex key,
    a nested sequence, a value on the lines after its key or a bare `-` (round 9), an unknown
    escape, an unterminated quote — is an error, never a traceback.

An error is a finding (fail closed): check 2 cannot say what such an entry runs, so it never
reads it as harmless.

LINE BREAKS (round 10, 21/11/2026). The file is read raw and split at \n (a \r\n counts as one);
YAML 1.1's other breaks — a lone \r, NEL (\x85), U+2028 and U+2029, which PyYAML honours — are
refused anywhere in copier.yml, as one finding naming the first and its line, because a key after
one is a line to copier and none to this reader.

THE TOP LEVEL (round 9, 21/11/2026). copier.yml is read as ONE DOCUMENT OF PLAIN TOP-LEVEL KEYS,
and anything else is refused. Every column-0 line must be blank, a comment, or an unquoted
identifier and `:`; a quoted or escaped key (`"_tasks":`, `"\\x5fmigrations":`), an explicit `?`
key, a `---` or `...` document marker, a `%` directive, a `!` tag (copier's `!include`), a `<<:`
merge, a flow collection, a column-0 sequence entry or an indented line before the first key is
one finding, as is a tag, anchor or alias opening a top-level value, and a repeated plain key —
because copier (PyYAML, its `!include`, its merge of later documents over earlier ones) can read a
`_tasks`, `_migrations` or `_exclude` there that this reader, and check 1, never see.

Output, one record per line, tab-separated:
  S <step>          one `&&` step of the DECODED command of a copy-gated seed task (its `when:`
                    decodes to the copy test, and its command holds the README move), stripped,
                    a line break or tab in it written `\\n` / `\\t` — for check 2's wired test
  O <line>          a line of the decoded command of every other `_tasks` / `_migrations` entry
  X <entry>         one `_exclude` entry, decoded — for check 1 (round 10, 21/11/2026). An entry
                    that is not one line of one string (a block scalar, a flow collection, a
                    mapping, a decoded line break) is an E record instead; an unquoted entry
                    opening `!` (a tag to YAML) is read as the negation it looks like.
  E <message>       an entry this reader refuses

Usage: python3 -I copier-commands.py COPIER_YML
Exit codes: 0 = read (errors are E records, not an exit code)  2 = unreadable file
"""

from __future__ import annotations

import re
import sys

SECTIONS = ("_tasks", "_migrations")
COPY_GATE = re.compile(r"^<%\s*_copier_operation\s*==\s*.copy.\s*%>$")
README_MOVE = "mv .copier/README.md README.md"
# The one entry exempt from check 2's word rule: the migration that deletes the staging directory
# on update. It names the bare .copier directory, which the rule reads as every board, but it
# removes the seeds rather than reading them. Exempt only when its whole decoded command is
# exactly this; anything added to it is read like any other entry.
STAGING_RM = "rm -rf .copier"
TOP_KEY = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):(?:\s|$)")
KEY = re.compile(r"""^("(?:[^"\\]|\\.)*"|'(?:[^']|'')*'|[A-Za-z_][\w-]*)\s*:(?:\s|$)""")
ESCAPES = {
    "0": "\0",
    "a": "\a",
    "b": "\b",
    "t": "\t",
    "\t": "\t",
    "n": "\n",
    "v": "\v",
    "f": "\f",
    "r": "\r",
    "e": "\x1b",
    " ": " ",
    '"': '"',
    "/": "/",
    "\\": "\\",
    "N": "\x85",
    "_": "\xa0",
    "L": "\u2028",
    "P": "\u2029",
}
HEX = {"x": 2, "u": 4, "U": 8}
# YAML 1.1's line breaks other than \n (PyYAML's scan_line_break): a \r not before a \n, NEL,
# U+2028 and U+2029. Read raw (newline=""), so a lone CR is not folded into a \n unseen.
BREAKS = re.compile("\r(?!\n)|[\x85\u2028\u2029]")
BREAK_NAMES = {"\r": "a lone CR", "\x85": "NEL (U+0085)", "\u2028": "U+2028", "\u2029": "U+2029"}


class RefusedError(Exception):
    """An entry this reader will not guess at."""


def indent(line: str) -> int:
    return len(line) - len(line.lstrip(" "))


def blank_or_comment(line: str) -> bool:
    s = line.strip()
    return not s or s.startswith("#")


def fold(lines: list[str]) -> str:
    """Flow-scalar line folding: a break between text is a space, each blank line a newline."""
    if len(lines) == 1:
        return lines[0]
    segs = [lines[0].rstrip()] + [ln.strip() for ln in lines[1:-1]] + [lines[-1].lstrip()]
    out, blanks = segs[0], 0
    for k, seg in enumerate(segs[1:], 1):
        if not seg and k < len(segs) - 1:
            blanks += 1
            continue
        out += ("\n" * blanks if blanks else " ") + seg
        blanks = 0
    return out


def double_quoted(text: str) -> tuple[str, str]:
    """Decode a double-quoted scalar opening text; return (value, what follows the close)."""
    body, i, n = [], 1, len(text)
    while i < n:
        c = text[i]
        if c == '"':
            break
        if c == "\\":
            i += 1
            if i >= n:
                raise RefusedError("a double-quoted scalar ends in a lone backslash")
            e = text[i]
            if e == "\n":  # an escaped line break: joined with no space, leading blanks dropped
                i += 1
                while i < n and text[i] in " \t":
                    i += 1
                continue
            if e in ESCAPES:
                body.append("\x00ESC" + ESCAPES[e])
                i += 1
                continue
            if e in HEX:
                digits = text[i + 1 : i + 1 + HEX[e]]
                if len(digits) != HEX[e] or not re.fullmatch(r"[0-9A-Fa-f]+", digits):
                    raise RefusedError(f"a double-quoted scalar holds a malformed \\{e} escape")
                body.append("\x00ESC" + chr(int(digits, 16)))
                i += 1 + HEX[e]
                continue
            raise RefusedError(f"a double-quoted scalar holds the unknown escape \\{e}")
        body.append(c)
        i += 1
    else:
        raise RefusedError("a double-quoted scalar is never closed")
    # Fold the raw line breaks first, then put the escaped characters in, so an escaped newline or
    # space is never folded away.
    parts, cur = [], []
    for piece in body:
        if piece.startswith("\x00ESC"):
            parts.append(("".join(cur), piece[4:]))
            cur = []
        else:
            cur.append(piece)
    parts.append(("".join(cur), ""))
    value = "".join(fold(raw.split("\n")) + esc for raw, esc in parts)
    return value, text[i + 1 :]


def single_quoted(text: str) -> tuple[str, str]:
    i, n = 1, len(text)
    while i < n:
        if text[i] == "'":
            if i + 1 < n and text[i + 1] == "'":
                i += 2
                continue
            break
        i += 1
    else:
        raise RefusedError("a single-quoted scalar is never closed")
    return fold(text[1:i].split("\n")).replace("''", "'"), text[i + 1 :]


def block_scalar(header: str, lines: list[str], parent: int) -> str:
    m = re.fullmatch(r"([|>])([+-]?)([1-9]?)([+-]?)\s*(#.*)?", header)
    if not m or (m.group(2) and m.group(4)):
        raise RefusedError(f"a block scalar header {header!r} this reader does not know")
    style, chomp = m.group(1), m.group(2) or m.group(4)
    if m.group(3):
        n = parent + int(m.group(3))
    else:
        firsts = [indent(ln) for ln in lines if ln.strip()]
        n = firsts[0] if firsts else parent + 1
    body = [ln[n:] if ln.strip() else "" for ln in lines]
    if any(ln.strip() and indent(ln) < n for ln in lines):
        raise RefusedError("a block scalar line sits left of its indentation")
    while body and not body[-1]:
        body.pop()
    if style == "|":
        text = "\n".join(body)
    else:  # folded: a break between plain lines is a space; blank and indented lines keep theirs
        text, blanks, last = "", 0, None
        for ln in body:
            if not ln:
                blanks += 1
                continue
            kind = "more" if ln[0] in " \t" else "plain"
            if last is None:
                text += "\n" * blanks
            elif last == "plain" and kind == "plain":
                text += "\n" * blanks if blanks else " "
            else:
                text += "\n" * (blanks + 1)
            text += ln
            blanks, last = 0, kind
    if chomp != "-" and text:
        text += "\n"
    return text


def scalar(rest: str, more: list[str], parent: int) -> str:
    """The value after `key:` (or `- `), with its continuation lines."""
    r = rest.strip()
    if r[:1] in "|>" and r:
        return block_scalar(r, more, parent)
    if r[:1] in "[{&*!%@`?" and r:
        raise RefusedError(
            f"a value opening {r[:1]!r} (a flow collection, anchor, alias, tag or "
            "reserved indicator)"
        )
    if r.startswith("- ") or r == "-":
        raise RefusedError("a nested sequence")
    if r and r[0] in "\"'":  # r[:1] is '' on an empty value, and '' is in every string
        whole = "\n".join([r] + more)
        value, after = (double_quoted if r[0] == '"' else single_quoted)(whole)
        after = after.strip()
        if after and not after.startswith("#"):
            raise RefusedError("text follows a quoted scalar")
        return value
    if not r and any(ln.strip() for ln in more):
        raise RefusedError(
            "a value on the lines after its key or `-` (a nested block, or a scalar this "
            "reader reads only on the key's own line)"
        )
    lines = [re.sub(r"(^|\s)#.*$", "", ln).rstrip() for ln in [r] + more]
    while lines and not lines[-1].strip():
        lines.pop()
    for ln in lines:
        if re.search(r":(\s|$)", ln.strip()):
            raise RefusedError("a plain scalar holding `: ` (a nested mapping)")
    return fold(lines) if lines else ""


def items(section: list[str], seq: int):
    """Yield (number, raw lines) for each item of the list at indent seq."""
    starts = [
        i
        for i, ln in enumerate(section)
        if indent(ln) == seq and (ln[seq:].startswith("- ") or ln[seq:].rstrip() == "-")
    ]
    for k, s in enumerate(starts, 1):
        end = starts[k] if k < len(starts) else len(section)
        raw = section[s:end]
        while raw and blank_or_comment(raw[-1]):
            raw.pop()
        yield k, raw


def parse_item(raw: list[str], seq: int, label: str):
    first = raw[0][seq + 1 :]
    col = seq + 1 + indent(first)
    head = first.strip()
    if not KEY.match(head):
        return scalar(head, raw[1:], seq)
    value: dict[str, str] = {}
    lines = [" " * col + head] + raw[1:]
    j = 0
    while j < len(lines):
        ln = lines[j]
        if blank_or_comment(ln) and not (j and indent(ln) > col):
            j += 1
            continue
        if indent(ln) != col:
            raise RefusedError(f"{label}: a line at indent {indent(ln)}, not its keys' {col}")
        m = KEY.match(ln[col:])
        if not m:
            raise RefusedError(f"{label}: a line that is no `key:` inside a mapping")
        key = m.group(1)
        key = scalar(key, [], col) if key[0] in "\"'" else key
        rest = ln[col + m.end() :]
        more, j = [], j + 1
        while j < len(lines) and (not lines[j].strip() or indent(lines[j]) > col):
            more.append(lines[j])
            j += 1
        while more and not more[-1].strip():
            more.pop()
        if key in value:
            raise RefusedError(
                f"{label} repeats the key {key}: — YAML keeps the last, so the entry "
                "does not run as it first reads"
            )
        value[key] = scalar(rest, more, col)
    return value


def top_level_kind(line: str) -> str:
    """What a column-0 line that is no plain `key:` is, for the finding."""
    if line[0] in "\"'":
        return "a quoted or escaped key"
    if line[0] == "?":
        return "an explicit `?` key"
    if line.startswith(("---", "...")):
        return "a document marker (copier merges a later document over this one)"
    kinds = {
        "%": "a directive",
        "!": "a tag (copier's `!include` among them)",
        "<": "a merge key",
        "[": "a flow collection",
        "{": "a flow collection",
        "-": "a sequence entry at column 0",
        "&": "an anchor",
        "*": "an alias",
        "\t": "a tab-indented line",
    }
    return kinds.get(line[0], "not a plain `key:`")


def top_level(lines: list[str], out: list[str]) -> list[tuple[int, str]]:
    """The plain top-level keys, as (line index, key); every other column-0 shape refused."""
    keys: list[tuple[int, str]] = []
    seen: set[str] = set()
    refused: list[str] = []
    for i, ln in enumerate(lines):
        if blank_or_comment(ln):
            continue
        if ln.startswith(" "):
            if not keys:
                refused.append(f"line {i + 1} is indented before any top-level key")
            continue
        m = TOP_KEY.match(ln)
        if not m:
            refused.append(f"line {i + 1} (`{ln[:40]}`) is {top_level_kind(ln)}")
            continue
        value = re.sub(r"(^|\s)#.*$", "", ln[m.end() :]).strip()
        if value[:1] in ("!", "&", "*"):
            refused.append(f"line {i + 1} gives `{m.group(1)}:` {top_level_kind(value)}")
        key = m.group(1)
        if key in seen:
            out.append(
                f"E\tcopier.yml repeats the top-level key {key}: — YAML keeps the last, so "
                "the value copier reads is not the one first read"
            )
        seen.add(key)
        keys.append((i, key))
    if refused:
        more = f" (and {len(refused) - 1} more)" if len(refused) > 1 else ""
        out.append(
            "E\tcopier.yml is not one document of plain top-level keys — "
            f"{refused[0]}{more}; copier may read a _tasks, _migrations or _exclude there "
            "that checks 1 and 2 never see, so it is a finding"
        )
    return keys


def line_breaks(text: str, out: list[str]) -> None:
    """Refuse every YAML line break but \n and \r\n, the two this reader splits at (round 10)."""
    found = [(m.start(), m.group()) for m in BREAKS.finditer(text)]
    if found:
        pos, ch = found[0]
        more = f" (and {len(found) - 1} more)" if len(found) > 1 else ""
        out.append(
            f"E\tcopier.yml line {text.count(chr(10), 0, pos) + 1} holds {BREAK_NAMES[ch]}{more}, "
            "a YAML line break (PyYAML breaks at \\r\\n, \\r, \\n, NEL, U+2028 and U+2029) this "
            "reader does not split at — copier may read a top-level key after it that checks 1 "
            "and 2 never see, so it is a finding"
        )


def section_of(lines: list[str], i: int) -> list[str]:
    """The lines of the section whose key is on line i: up to the next column-0 line."""
    j = i + 1
    while j < len(lines) and (blank_or_comment(lines[j]) or lines[j].startswith(" ")):
        j += 1
    return lines[i + 1 : j]


def exclude_entry(raw: list[str], seq: int, label: str) -> str:
    """One `_exclude` entry, decoded — or refused when it is not one line of one string."""
    head = raw[0][seq + 1 :].strip()
    if head.startswith("!"):  # unquoted: a tag to YAML, a negation to the eye — read as one
        if len(raw) > 1:
            raise RefusedError("an unquoted `!` entry on more than one line")
        return re.sub(r"\s+#.*$", "", head)
    if head[:1] in "|>" and head:
        raise RefusedError("a block scalar")
    if head[:1] in "[{" and head:
        raise RefusedError("a flow collection")
    value = parse_item(raw, seq, label)
    if not isinstance(value, str):
        raise RefusedError("a mapping, not a string")
    if "\n" in value:
        raise RefusedError("a string holding a line break")
    return value


def exclude(lines: list[str], i: int, out: list[str]) -> None:
    """`_exclude`, for check 1: X records of decoded entries, E for one it cannot read."""
    tail = " — check 1 cannot read what it excludes, so it is a finding"
    if re.sub(r"(^|\s)#.*$", "", lines[i][len("_exclude:") :]).strip()[:1] in ("!", "&", "*"):
        return  # a tag, anchor or alias: top_level has refused it already, as the one finding
    if not re.match(r"^_exclude\s*:\s*(#.*)?$", lines[i]):
        out.append("E\tcopier.yml _exclude: is not a block sequence this reader knows" + tail)
        return
    section = section_of(lines, i)
    body = [ln for ln in section if not blank_or_comment(ln)]
    if not body:
        return
    seq = indent(body[0])
    if any(indent(ln) < seq for ln in body):
        out.append("E\tcopier.yml _exclude: a line left of its list" + tail)
    for k, raw in items(section, seq):
        try:
            out.append("X\t" + exclude_entry(raw, seq, f"copier.yml _exclude entry {k}"))
        except RefusedError as exc:
            msg = str(exc)
            if not msg.startswith("copier.yml"):
                msg = f"copier.yml _exclude entry {k}: {msg}"
            out.append(f"E\t{msg}{tail}")


def main() -> int:
    try:
        with open(sys.argv[1], encoding="utf-8", newline="") as fh:
            text = fh.read()
    except (OSError, IndexError, UnicodeDecodeError) as exc:
        print(f"copier-commands.py: {exc}", file=sys.stderr)
        return 2
    out: list[str] = []
    line_breaks(text, out)
    lines = text.replace("\r\n", "\n").split("\n")
    keys = top_level(lines, out)
    for i, name in keys:
        if name == "_exclude":
            exclude(lines, i, out)
            continue
        if name not in SECTIONS:
            continue
        if not re.match(r"^(_tasks|_migrations)\s*:\s*(#.*)?$", lines[i]):
            out.append(
                f"E\tcopier.yml {name}: is not a block sequence this reader knows — check 2 "
                "cannot read it"
            )
            continue
        section = section_of(lines, i)  # ends at the next column-0 line, a key or a refused shape
        body = [ln for ln in section if not blank_or_comment(ln)]
        if not body:
            continue
        seq = indent(body[0])
        for ln in body:
            if indent(ln) < seq:
                out.append(
                    f"E\tcopier.yml {name}: a line left of its list — check 2 cannot read it"
                )
                break
        for k, raw in items(section, seq):
            try:
                value = parse_item(raw, seq, f"copier.yml {name} entry {k}")
            except RefusedError as exc:
                msg = str(exc)
                if not msg.startswith("copier.yml"):
                    msg = f"copier.yml {name} entry {k}: {msg}"
                out.append(f"E\t{msg} — check 2 cannot read what it runs, so it is a finding")
                continue
            command = value if isinstance(value, str) else value.get("command", "")
            when = "" if isinstance(value, str) else value.get("when", "")
            seed = (
                name == "_tasks"
                and COPY_GATE.match(when.strip()) is not None
                and README_MOVE in command
            )
            if seed:  # each `&&` step of the decoded command, its breaks and tabs made visible
                steps = (
                    st.strip().replace("\n", "\\n").replace("\t", "\\t")
                    for st in command.split("&&")
                )
                out.extend("S\t" + st for st in steps)
                continue
            if name == "_migrations" and command.strip() == STAGING_RM:
                continue  # removes the staging directory and reads nothing in it (see STAGING_RM)
            out.extend("O\t" + c for c in command.split("\n"))
            if not isinstance(value, str):
                for key, val in value.items():
                    if key not in ("command", "when", "version"):
                        out.extend("O\t" + c for c in val.split("\n"))
    print("\n".join(out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
