#!/usr/bin/env python3
"""Compare md-cleanup preview vs original; emit readable inline diffs."""
from __future__ import annotations

import difflib
import subprocess
import sys
from pathlib import Path

BARS = Path(__file__).resolve().parents[1]
TMP = Path(__file__).resolve().parent
SRC = BARS.parents[1] / "src" / "md-cleanup.ps1"

FILES = [
    "BD2005.md",
    "BM2021.md",
    "GRE1995.md",
    "HTR2005.md",
    "HYK2024.md",
    "TN2020.md",
    "WLK2008.md",
]
APPENDICES = BARS / "references" / "MRA2015.appendices.md"

ps = r"""
. '{src}'
function Get-CleanupPreviewText([string]$Path) {{
    $raw  = [System.IO.File]::ReadAllText($Path)
    $orig = $raw -replace "`r`n", "`n"
    $nonce  = [System.Guid]::NewGuid().ToString('N')
    $marker = "RMASK_${{nonce}}_"
    while ($orig.Contains($marker)) {{ $nonce = [System.Guid]::NewGuid().ToString('N'); $marker = "RMASK_${{nonce}}_" }}
    $script:mdStore = [System.Collections.Generic.List[string]]::new()
    $script:mdTight = 0
    $protect = {{ param($m) $script:mdStore.Add($m.Value); "$marker$($script:mdStore.Count - 1)$marker" }}
    $work = $orig
    $work = [regex]::Replace($work, '(?ms)^```.*?^```', $protect)
    $work = [regex]::Replace($work, '(?s)\$\$.+?\$\$', $protect)
    $work = [regex]::Replace($work, '`[^`\n]+`', $protect)
    $work = [regex]::Replace($work, '!?\[[^\]]*\]\([^)]*\)', $protect)
    $work = [regex]::Replace($work, '\$[^$\n]+\$', {{
        param($m)
        $inner = $m.Value.Substring(1, $m.Value.Length - 2)
        $clean = '$' + (Convert-MathToLatex (Optimize-MathContent $inner @('mathbb'))) + '$'
        if ($clean -ne $m.Value) {{ $script:mdTight++ }}
        $script:mdStore.Add($clean); "$marker$($script:mdStore.Count - 1)$marker"
    }})
    $lines = $work -split "`n", -1
    for ($i = 0; $i -lt $lines.Count; $i++) {{
        $l = Repair-Ligatures $lines[$i]
        if (([regex]::Matches($l, '\|')).Count -lt 2) {{ $l = Wrap-InlineMathMd $l }}
        $lines[$i] = $l
    }}
    $work = $lines -join "`n"
    $guard = 0
    $restoreRx = [regex]::Escape($marker) + '(\d+)' + [regex]::Escape($marker)
    while ($guard -lt 12 -and $work.IndexOf($marker) -ge 0) {{
        $work = [regex]::Replace($work, $restoreRx, {{ param($m) $script:mdStore[[int]$m.Groups[1].Value] }})
        $guard++
    }}
    @{{ orig = $orig; cleaned = $work; tightened = $script:mdTight }}
}}
$path = '{path}'
$p = Get-CleanupPreviewText $path
[Console]::Out.Write($p.cleaned)
""".strip()


def preview(path: Path) -> str:
    script = ps.format(src=SRC, path=path)
    r = subprocess.run(
        ["pwsh", "-NoProfile", "-Command", script],
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if r.returncode != 0:
        raise RuntimeError(r.stderr)
    return r.stdout.replace("\r\n", "\n")


def span_diff(old: str, new: str, max_spans: int = 8) -> list[str]:
    """Character-level diff snippets for one line."""
    sm = difflib.SequenceMatcher(None, old, new)
    out = []
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            continue
        o = old[i1:i2]
        n = new[j1:j2]
        if len(o) > 80:
            o = o[:77] + "..."
        if len(n) > 80:
            n = n[:77] + "..."
        out.append(f"  [{tag}] -{o!r} +{n!r}")
        if len(out) >= max_spans:
            out.append("  ... (truncated)")
            break
    return out


def diff_file(path: Path, out_path: Path, max_line_samples: int = 12) -> dict:
    orig = path.read_text(encoding="utf-8").replace("\r\n", "\n")
    cleaned = preview(path)
    o_lines = orig.split("\n")
    c_lines = cleaned.split("\n")
    changed = []
    for i, (o, c) in enumerate(zip(o_lines, c_lines), start=1):
        if o != c:
            changed.append((i, o, c))
    if len(o_lines) != len(c_lines):
        changed.append(("LEN", str(len(o_lines)), str(len(c_lines))))

    lines_out = [f"# {path.name}", f"changed_lines: {len(changed)}", ""]
    for idx, (i, o, c) in enumerate(changed[:max_line_samples]):
        lines_out.append(f"--- line {i} ---")
        if len(o) > 200:
            lines_out.append(f"  OLD ({len(o)} chars): {o[:200]}...")
        else:
            lines_out.append(f"  OLD: {o}")
        if len(c) > 200:
            lines_out.append(f"  NEW ({len(c)} chars): {c[:200]}...")
        else:
            lines_out.append(f"  NEW: {c}")
        lines_out.extend(span_diff(o, c))
        lines_out.append("")
    if len(changed) > max_line_samples:
        lines_out.append(f"... {len(changed) - max_line_samples} more changed lines (see full unified diff)")
        u = difflib.unified_diff(
            o_lines, c_lines, fromfile=f"a/{path.name}", tofile=f"b/{path.name}", lineterm=""
        )
        lines_out.extend(list(u)[:200])

    out_path.write_text("\n".join(lines_out), encoding="utf-8")
    return {"file": path.name, "changed_lines": len(changed)}


def main() -> None:
    out_dir = TMP / "cleanup-diffs-v2"
    out_dir.mkdir(exist_ok=True)
    targets = [BARS / f for f in FILES]
    if APPENDICES.exists():
        targets.append(APPENDICES)

    print("=== md-cleanup inline diff (dry-run) ===\n")
    for path in targets:
        meta = diff_file(path, out_dir / f"{path.stem}.diff.txt")
        print(f"{meta['file']}: {meta['changed_lines']} changed line(s)")
        text = (out_dir / f"{path.stem}.diff.txt").read_text(encoding="utf-8")
        # print first 40 lines of each for user
        preview_lines = text.splitlines()[:45]
        print("\n".join(preview_lines))
        if len(text.splitlines()) > 45:
            print(f"  ... ({len(text.splitlines()) - 45} more lines in {out_dir / (path.stem + '.diff.txt')})")
        print()


if __name__ == "__main__":
    main()
