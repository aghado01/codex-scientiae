#!/usr/bin/env python3
"""Audit ph compendium against bars/intersections structural standards."""

from __future__ import annotations

import re
from pathlib import Path

PH = Path(__file__).resolve().parents[1]
COMPENDIA = PH.parent
BARS = COMPENDIA / "bars"
INTERSECTIONS = COMPENDIA / "intersections"

SKIP_HEADING_RE = re.compile(
    r"acknowledg|funding|data availability|reproducibility|"
    r"declaration of competing|article info|conflict of interest|"
    r"categories and subject|general terms|^keywords$",
    re.I,
)

JUNK_HEADING_RE = re.compile(
    r"^(output|• output|results are written|research article|"
    r"nih public access|a dissertation|table of contents|"
    r"lemma \d|notation \d|case \d|definition \d|theorem |"
    r"maroulas|vasileios|xiaojin|marcus hutter|axel theorell)",
    re.I,
)

OCR_LIGATURE_RE = re.compile(r"deﬁ|diﬀ|eﬃ|inﬁ|ﬁl|ﬂ|ﬁ")
BARE_GREEK_RE = re.compile(r"(?<!\$)[µνσρ∆λ](?!\$)")
WRONG_H1_SECTION_RE = re.compile(r"^# (Abstract|Introduction|ACKNOWLEDGEMENTS|TABLE OF CONTENTS|CHAPTER \d)", re.I)

# docs that moved to other compendia but still appear in ph/_CONTENTS
RELOCATED = {
    "GLL2026": INTERSECTIONS,
    "GVPB2025": INTERSECTIONS,
    "MMO2019": INTERSECTIONS,
    "MNO2019": INTERSECTIONS,
    "MR2026": INTERSECTIONS,
    "RVH2020": INTERSECTIONS,
    "SGL2022": INTERSECTIONS,
    "TKH2022": INTERSECTIONS,
    "TN2020": BARS,
    "WLK2008": BARS,
    "HTR2005": BARS,
}

RENAMED_IN_PH = {
    "SIFTS": "SIFTS2013",
    "MPH-REF": "REF-MPH",
    "PH-REF": "REF-PH",
}


def doc_ids() -> list[str]:
    return sorted(
        p.stem
        for p in PH.glob("*.md")
        if p.name not in {"_CONTENTS.md"} and not p.name.startswith("_")
    )


def audit_doc(doc_id: str) -> dict:
    path = PH / f"{doc_id}.md"
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    issues: list[str] = []
    metrics: dict[str, int | str] = {}

    h1 = None
    has_contents = False
    has_ref_link = False
    bad_h1_sections = 0
    headings = {"#": 0, "##": 0, "###": 0, "####": 0}
    boilerplate_h2 = []
    author_block = False
    junk_h = []
    inline_refs = 0

    for i, line in enumerate(lines, 1):
        if re.match(r"^## Contents\s*$", line):
            has_contents = True
        if "references/" in line and "References]" in line:
            has_ref_link = True
        if WRONG_H1_SECTION_RE.match(line.strip()):
            bad_h1_sections += 1
        m = re.match(r"^(#{1,4})\s+(.+)$", line)
        if m:
            lvl, text = len(m.group(1)), m.group(2).strip()
            key = "#" * lvl
            headings[key] = headings.get(key, 0) + 1
            if lvl == 1:
                if h1 is None:
                    h1 = text
                elif i > 1:
                    issues.append(f"extra H1 at line {i}: {text[:50]}")
            elif lvl == 2:
                if SKIP_HEADING_RE.search(text):
                    boilerplate_h2.append(text)
                if JUNK_HEADING_RE.search(text):
                    junk_h.append((i, text[:55]))
        if re.match(r"^\[1\]", line.strip()):
            inline_refs += 1
        if i <= 12 and not line.startswith("#") and not line.startswith("-") and not line.startswith("!"):
            s = line.strip()
            if s and re.search(r"university|department|@|,\s*\d{4,5}|author manuscript", s, re.I):
                if len(s) < 200:
                    author_block = True

    text = "\n".join(lines)
    ligatures = len(OCR_LIGATURE_RE.findall(text))
    bare_greek = len(BARE_GREEK_RE.findall(text))
    h1_wrong = sum(1 for ln in lines if WRONG_H1_SECTION_RE.match(ln.strip()))

    if not h1:
        issues.append("no H1 title")
    if not has_contents:
        issues.append("missing ## Contents")
    if not has_ref_link:
        issues.append("Contents missing References sidecar link")
    if boilerplate_h2:
        issues.append(f"boilerplate H2: {boilerplate_h2[:3]}")
    if junk_h:
        issues.append(f"{len(junk_h)} junk/OCR headings (e.g. line {junk_h[0][0]})")
    if inline_refs:
        issues.append(f"{inline_refs} inline [1] refs in body")
    if h1_wrong:
        issues.append(f"{h1_wrong} sections use # instead of ## (Abstract/Intro/etc.)")
    if ligatures:
        issues.append(f"{ligatures} OCR ligatures (deﬁ/diﬀ/…)")

    ref_path = PH / "references" / f"{doc_id}.md"
    if not ref_path.exists() and not doc_id.startswith("REF-"):
        issues.append("missing references/ sidecar")

    tail = "\n".join(lines[-8:])
    if re.search(r"^## References\s*$", tail, re.M) and doc_id not in {"REF-PH", "REF-MPH"}:
        issues.append("inline ## References section in body (should be sidecar)")

    metrics = {
        "lines": len(lines),
        "h2": headings["##"],
        "h3": headings["###"],
        "ligatures": ligatures,
        "bare_greek": bare_greek,
    }
    return {"id": doc_id, "h1": (h1 or "")[:55], "issues": issues, **metrics}


def audit_contents() -> dict:
    text = (PH / "_CONTENTS.md").read_text(encoding="utf-8")
    issues: list[str] = []
    stale: list[str] = []
    relocated: list[str] = []
    renamed: list[str] = []
    missing_on_disk: list[str] = []

    linked = re.findall(r"\]\((\w+)\.md\)", text)
    unique = sorted(set(linked))

    for doc in unique:
        if doc == "references":
            continue
        local = PH / f"{doc}.md"
        if local.exists():
            continue
        if doc in RENAMED_IN_PH:
            actual = RENAMED_IN_PH[doc]
            if (PH / f"{actual}.md").exists():
                renamed.append(f"{doc} -> {actual}.md")
                continue
        if doc in RELOCATED:
            dest = RELOCATED[doc]
            if (dest / f"{doc}.md").exists():
                relocated.append(f"{doc} (now in {dest.name}/)")
                continue
        missing_on_disk.append(doc)

    on_disk = set(doc_ids())
    for doc in on_disk:
        if doc not in unique and not doc.startswith("REF-"):
            issues.append(f"on disk but not in _CONTENTS: {doc}")

    h3_links = len(re.findall(r"^  - \[", text, re.M))
    if h3_links == 0:
        issues.append("_CONTENTS has no depth-3 (indented) subsection links")

    if not re.match(r"^# Persistent Homology", text):
        issues.append("_CONTENTS missing top-level # hub title")

    compendia = (COMPENDIA / "COMPENDIA.md").read_text(encoding="utf-8")
    if "ph/_CONTENTS" not in compendia and "ph/" not in compendia:
        issues.append("COMPENDIA.md does not list ph compendium")

    return {
        "issues": issues,
        "stale_relocated": relocated,
        "stale_renamed": renamed,
        "missing": missing_on_disk,
        "linked_count": len(unique),
        "on_disk_count": len(on_disk),
    }


def main() -> None:
    docs = doc_ids()
    print("=== PH compendium audit ===\n")
    print(f"Docs on disk: {len(docs)}")
    print(f"Total lines: {sum((PH / f'{d}.md').read_text(encoding='utf-8').count(chr(10)) for d in docs)}\n")

    ok = issue = 0
    by_issue: dict[str, list[str]] = {}

    for doc_id in docs:
        r = audit_doc(doc_id)
        status = "OK" if not r["issues"] else "ISSUES"
        if r["issues"]:
            issue += 1
        else:
            ok += 1
        print(f"{r['id']}: {status} ({r['lines']} lines, ##={r['h2']}, ###={r['h3']})")
        for iss in r["issues"]:
            print(f"  - {iss}")
            key = iss.split("(")[0].split(":")[0].strip()
            by_issue.setdefault(key, []).append(doc_id)

    print(f"\n=== Summary: {ok} OK / {issue} with issues / {len(docs)} total ===\n")

    print("=== Issue frequency ===")
    for k, ids in sorted(by_issue.items(), key=lambda x: -len(x[1])):
        print(f"  {k}: {len(ids)} docs — {', '.join(ids)}")

    print("\n=== _CONTENTS.md ===")
    c = audit_contents()
    print(f"  Linked papers in hub: {c['linked_count']}")
    print(f"  Papers on disk: {c['on_disk_count']}")
    for iss in c["issues"]:
        print(f"  - {iss}")
    if c["stale_relocated"]:
        print(f"  - {len(c['stale_relocated'])} stale entries (moved to bars/intersections):")
        for x in c["stale_relocated"]:
            print(f"      {x}")
    if c["stale_renamed"]:
        print(f"  - {len(c['stale_renamed'])} stale renames on disk:")
        for x in c["stale_renamed"]:
            print(f"      {x}")
    if c["missing"]:
        print(f"  - {len(c['missing'])} broken links (file missing everywhere):")
        for x in c["missing"]:
            print(f"      {x}")

    print("\n=== Reference sidecars ===")
    for doc_id in docs:
        if doc_id.startswith("REF-"):
            continue
        ref = PH / "references" / f"{doc_id}.md"
        mark = "OK" if ref.exists() else "MISSING"
        print(f"  {doc_id}: {mark}")

    print("\n=== Size outliers (lines) ===")
    sizes = [(d, (PH / f"{d}.md").read_text(encoding="utf-8").count("\n") + 1) for d in docs]
    for d, n in sorted(sizes, key=lambda x: -x[1])[:6]:
        print(f"  {d}: {n}")


if __name__ == "__main__":
    main()
