#!/usr/bin/env python3
"""Extract reference sidecars from main body or archive; strip inline ## References."""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]
ARCHIVE = PH.parents[1] / ".archive" / "compendia" / "ph"
REFS = PH / "references"

REF_HEADING_RE = re.compile(r"^#{1,2}\s+(References|Bibliography|REFERENCES|BIBLIOGRAPHY)\s*$", re.I)

DOCS = sorted(
    p.stem
    for p in PH.glob("*.md")
    if p.name != "_CONTENTS.md" and not p.name.startswith("_")
)


def read_lines(path: Path) -> list[str]:
    if not path.exists():
        return []
    return path.read_text(encoding="utf-8", errors="replace").splitlines()


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def find_ref_section(lines: list[str]) -> tuple[int, int] | None:
    for i, line in enumerate(lines):
        if REF_HEADING_RE.match(line.strip()):
            start = i
            end = len(lines)
            for j in range(i + 1, len(lines)):
                if re.match(r"^#{1,2}\s+", lines[j]) and not lines[j].startswith("###"):
                    end = j
                    break
                if re.match(r"^\[Page \d+\]\s*$", lines[j]):
                    end = j
                    break
            return start, end
    return None


def parse_hlww_table(lines: list[str]) -> list[str]:
    """Parse mangled pipe-table bibliography from HLWW2024 archive."""
    entries: list[str] = []
    for line in lines:
        if not line.startswith("|["):
            continue
        if "---" in line:
            continue
        parts = line.split("|")
        if len(parts) < 4:
            continue
        keys_raw, body = parts[1].strip(), parts[2].strip()
        keys = re.findall(r"\[[^\]]+\]", keys_raw)
        if not keys:
            continue
        # Split merged bodies on ". G." / ". B." / ". S." author boundaries when multiple keys
        if len(keys) == 1:
            entries.append(f"- {keys[0]} {body}")
            continue
        chunks = re.split(r"(?<=\d{4}\))\.\s+(?=[A-Z])", body)
        if chunks and chunks[0].startswith(","):
            chunks[0] = chunks[0].lstrip(", ")
        while len(chunks) < len(keys):
            chunks.append("")
        for key, chunk in zip(keys, chunks):
            chunk = chunk.strip().lstrip(", ")
            if chunk:
                entries.append(f"- {key} {chunk}")
    return entries


def normalize_ref_lines(lines: list[str], doc_id: str) -> str:
    cleaned: list[str] = [f"# References — {doc_id}", ""]
    for line in lines:
        s = line.strip()
        if not s or REF_HEADING_RE.match(s):
            continue
        if s.startswith("[Page "):
            continue
        if s.startswith("|") and "---" in s:
            continue
        if s.startswith("- "):
            cleaned.append(s)
            continue
        if s.startswith("["):
            cleaned.append(f"- {s}")
            continue
        if re.match(r"^\[\d+\]", s):
            cleaned.append(f"- {s}")
            continue
        if s.startswith("|["):
            continue
        cleaned.append(s)
    return "\n".join(cleaned) + "\n"


def extract_from_source(doc_id: str, lines: list[str]) -> str | None:
    span = find_ref_section(lines)
    if not span:
        return None
    start, end = span
    section = lines[start:end]
    if doc_id == "HLWW2024":
        bullets = parse_hlww_table(section)
        if bullets:
            return f"# References — {doc_id}\n\n" + "\n".join(bullets) + "\n"
    body = [ln for ln in section if not REF_HEADING_RE.match(ln.strip())]
    return normalize_ref_lines(body, doc_id)


def strip_ref_section(lines: list[str]) -> list[str]:
    span = find_ref_section(lines)
    if not span:
        return lines
    start, end = span
    out = lines[:start] + lines[end:]
    while out and out[-1].strip() == "":
        out.pop()
    return out


def archive_path(doc_id: str) -> Path | None:
    p = ARCHIVE / doc_id / f"{doc_id}.md"
    return p if p.exists() else None


def process_doc(doc_id: str, dry_run: bool = False) -> str:
    ref_path = REFS / f"{doc_id}.md"
    main_path = PH / f"{doc_id}.md"
    main_lines = read_lines(main_path)

    if ref_path.exists():
        stripped = strip_ref_section(main_lines)
        if len(stripped) != len(main_lines) and not dry_run:
            main_path.write_text("\n".join(stripped) + "\n", encoding="utf-8")
            return f"{doc_id}: stripped inline refs from main ({len(main_lines)} -> {len(stripped)} lines)"
        return f"{doc_id}: sidecar OK"

    # Try main body
    content = extract_from_source(doc_id, main_lines)
    source = "main"

    # Try archive
    if not content:
        ap = archive_path(doc_id)
        if ap:
            content = extract_from_source(doc_id, read_lines(ap))
            source = f"archive ({ap.name})"

    if not content:
        return f"{doc_id}: NO refs found in main or archive"

    if dry_run:
        return f"{doc_id}: would create sidecar from {source} ({content.count(chr(10))} lines)"

    write_text(ref_path, content)
    stripped = strip_ref_section(main_lines)
    if len(stripped) != len(main_lines):
        main_path.write_text("\n".join(stripped) + "\n", encoding="utf-8")
    return f"{doc_id}: created sidecar from {source}"


def main() -> None:
    for doc_id in DOCS:
        print(process_doc(doc_id))


if __name__ == "__main__":
    main()
