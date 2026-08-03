# The markdown-primitives plane — principled form, 2026-07-29

**Status:** working doctrine for the current build; feeds the scriba-scientiae reboot as prior art.
Genesis: `issues/reboot/gemini-latex-ingest-updates-20260729.md` (the "agnostic markdown primitives"
thread) — legacy code had markdown-level operations scattered ad hoc through
finalize/publish/md-repair/md-cleanup and inline in latex-ingest, with concerns mixed per file
rather than per operation. This document names the principle and inventories the plane.

## The principle

A **markdown primitive** is an operation on markdown *text or its on-disk bytes* that is true of
the TARGET register, not of any producing lane. Three obligations:

1. **Format-agnostic** — no knowledge of LaTeX, PDF geometry, or the membrane IR. If a rule cites
   a LaTeX defect, that is provenance (why the rule was born), never a dependency.
2. **Pure interface** — text in/text out (or bytes in/bytes out for splice tools). No lane state,
   no run-dir knowledge, no side effects beyond the declared output.
3. **Idempotent** — `f(f(x)) = f(x)`, tested. A primitive may be re-run on published documents;
   the md-hygiene extraction surfaced a real latent non-idempotence the inline form hid
   (retro-indented bullets re-read as prose), which is exactly why the obligation is explicit.

**Lanes call primitives at emission** so deliverables are *born complete* — never "converted, then
repaired by a later tool." Post-hoc tools (md-repair) exist for documents already on disk, and
share the primitives' engines (one slug function, one hygiene walk) so post-hoc output matches
emission output. That is the whole anti-drift argument: one engine per concern, N callers.

Layer below: `src/math-register.ps1` is the same idea one register down — a *span-level* primitive
(math canonicalization) that both lanes serialize through. It is not markdown-aware; markdown
primitives sit above it and never re-do its job.

## Inventory — the plane as of 2026-07-29

| Module (src/audits/) | Concern | Engine | Callers |
|---|---|---|---|
| `md-toc.ps1` | heading slugs + `## Contents` block | `Get-MdAnchor`, `Get-MdContentsEntries`, `New-/Set-MdContentsBlock` | latex-ingest (emission), finalize (chunk TOC), md-repair (regeneration) |
| `md-hygiene.ps1` | emission-grade hygiene: whitespace lint, MD026 + level clamp, MD034 autolinks, `$a$$b$` span-adjacency, list repair | `Format-MdHygiene` | latex-ingest (emission); available to any lane |
| `md-bundle.ps1` | standalone-deliverable bundling + destination-side link verification + sentinel counts | `Get-MdLocalImageLinks`, `Copy-MdDeliverable` | latex-ingest (`-DeliverableDir`); manual shelf work |
| `md-register.ps1` | THE figure/image register (image line, italic caption, flagged marker) | (pre-existing) | latex-ingest, membrane finalize weave |
| `md-repair.ps1` | post-hoc byte-splice repair: line index, heading inventory/verdicts, surgical `Set-MdSpan` | `Get-MdLineIndex`, `Get-MdHeadings`, `Set-MdSpan`, `Update-MdContents` | agents/MCP, post-promotion only |
| `md-lint.ps1` | conformance checks | (pre-existing) | gates |

Two heading scanners exist BY DESIGN: md-toc's text-plane scan (build/insert in a string) and
md-repair's byte-offset scan (splice on disk without shifting anchors). Different jurisdictions,
one shared slug function.

## Remaining trapped concerns (the debt, named)

- **`publish.ps1`** — `New-ContentsBlock`/`Set-ContentsBlock` manipulate the *compendium contents
  page* (re-pointing in-doc anchors at `slug.md#…`). Markdown-text-level; a natural md-toc
  extension (`-LinkBase` on the block builder) when publish is next touched. Deliberately not done
  now — publish formalities are out of the current renovation's scope.
- **`md-cleanup.ps1`** — membrane-specific repair (protection masking, wrap passes) entangled with
  register concerns that now belong to math-register (its math passes already delegate). The
  protection-masking pattern (fences/links/inline code) recurs here and in other walks; a shared
  masking primitive is a *candidate*, flagged not built — three hand-rolled instances is at the
  threshold, but the membrane lane is scheduled for reboot replacement, so extraction may be waste.
- **`finalize.ps1`** — caption relocation and references-sidecar split operate on the *chunk
  stream*, not markdown text: chunk-plane by nature, correctly outside this plane. Its TOC
  assembly already links the shared slug engine.
- **Heading-clamp duplication** — md-hygiene clamps levels at emission; md-repair verdicts headings
  post-hoc. Same *concern*, different evidence (sequence vs typography+content); unify only if the
  reboot gives them one IR.

## Test doctrine

Every primitive gets direct unit specs (`tests/md-{name}.Tests.ps1`) including an explicit
idempotency spec — indirect coverage through full conversions is not coverage of the primitive.
Real-paper reconversion after an extraction must be byte-identical (verified for md-hygiene on
1109.0573v2).
