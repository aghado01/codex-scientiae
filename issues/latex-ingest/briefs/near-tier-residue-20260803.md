# Brief — near-tier residue close-out

**Date:** 2026-08-03 · **Goal:** drive corpus residue to ≈0 outside declared kernel classes,
each task specimen-backed. **Context:** field notes
[probe-prose-channel-20260802.md](../discussions/probe-prose-channel-20260802.md) (§13–14);
sweep tables `artifacts/latex-ingest/probe/_sweep-summary.md`; per-paper artifacts under
`artifacts/latex-ingest/probe/{slug}/`; staged sources under
`artifacts/latex-ingest/probe/_staging/{slug}-latex` (or `ingestion/_inbox/{slug}/{slug}-latex`).

**Verification, every task:** re-probe the specimen
(`scratch/probe-prose-channel.ps1 -Slug <s> -SourceDir <staging>`) — closure invariants
(leaked = 0, orphaned = 0) must hold; close the brief with a full sweep
(`scratch/probe-sweep.ps1`). Production edits ride the golden pin
(`Invoke-Pester tests/latex-ingest.refs.Tests.ps1`); regenerate the fixture only deliberately.

## T1 — verb-in-table loss trace

Specimen: 2605.01664v1, 5 orphaned `@@VERB@@` entries — inline `\verb` stashed at raw source
sits inside table floats and the markers vanish during tabular realization (suspect
`Convert-Tabular` cell handling in `src/latex-ingest/latex-ingest.ps1`). Trace which pass
destroys them; preferred fix preserves the markers through cell emission so verb content
renders as inline code inside the markdown table; otherwise loud-fail at the destroying pass.
Success: 2605 orphans 0, verb content present in output.

## T2 — env census

`\begin`/`\end` residue (~31 hits across ~12 papers): from the per-paper probe reports
(`residue.commands`) and `prose.md` greps, enumerate the environment NAMES still leaking raw.
Classify each: admit as kind (file the admission question in planning/roadmap — user decides) /
strip as kernel (implement) / defer with a note. Implement the trivial strips in this pass.

## T3 — quote macros

Specimen: 2207.00510, `\lq` ×45 (expect `\rq` in the wild too). Lower to typographic quotes in
prose position, respecting math-protection order and the house text-mutation traps
(ordinal-safe replaces). Success: 2207 residue 0.

## T4 — 2410.01294v3 macro-harvest trace

Residue 442/85 distinct; the stream is channel-starved (math barely captured). Its author
macros (`\these`/`\These`-style case-colliding pairs) never expand — trace `Get-LatexMacros` /
`Expand-LatexMacros` against the paper's preamble (staging dir above): likely a harvest-pattern
gap (`\def` variant, `\newcommand*` form, or a case-collision). Fix the harvest/expansion.
Success: residue collapses, LMATH count surges, closure holds.

## Report

*(appended on completion)*
