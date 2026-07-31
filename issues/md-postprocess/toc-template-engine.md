# Design Specification: Single-Document & Multi-Document Tree Manifest Engine (`toc-engine`)

**Module Location:** `src/toc-engine/toc-engine.ps1`  
**Store Location:** `src/toc-engine/templates/`  
**Target Sidecar:** `{slug}-tree.md` (emitted alongside `{slug}.md`)  
**Status:** Implemented & Verified  

---

## 1. Executive Summary & Architecture

The **Markdown Tree Manifest Engine** decouples structural navigation extraction, data modeling, and template rendering for documents within `codex-scientiae`. 

Rather than hardcoding Markdown Table of Contents strings or interleaving formatting logic directly inside conversion pipelines (`latex-ingest`, `pdf-converter`), the engine introduces a **declarative, template-driven micro-engine** inspired by `reposnapshot`'s `rs.core.template.ps1`. 

### Key Innovations over Legacy Navigation:
1. **Bounded Byte Spans (`[byte_start, byte_end)`)**: Every section in the tree manifest carries its closed interval byte span. This enables LLM agents and downstream tools to read precise section slices (`ContentOffset = byte_start`, `Length = byte_end - byte_start`) without loading entire documents into context.
2. **Interval Algebra Backbone**: Section boundaries are computed using `src/shared/masks.ps1` (`Get-NormalizedSpans`, `Limit-Mask`, `Split-AtLevel`). This guarantees SMP surrogate-pair safety (never splitting UTF-16 surrogate pairs across section cuts) and totality over the byte space.
3. **Decoupled Template Rendering (`Expand-MdTemplate`)**: Structural data is assembled into an in-memory object model (`New-DeliverableTreeModel`), which is rendered via a zero-dependency Handlebars-lite template engine.
4. **Natural Path to Bibliotheca Navigation**: The engine architecture scales from single-document sidecars (`{slug}-tree.md`) to multi-document corpus/compendium navigation files (`bibliotheca-tree.md`).

---

## 2. Localizing & Replacing Fragmented Legacy Infrastructure

Currently, Table of Contents creation and heading byte-span indexing are fragmented across multiple script files in `src/`. The new `md-tree-template` engine unifies and supersedes these legacy constructs:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Fragmented Legacy Infrastructure                      │
├──────────────────────────────────┬──────────────────────────────────────────┤
│ Function / Location              │ Legacy Defect / Fragmentation            │
├──────────────────────────────────┼──────────────────────────────────────────┤
│ Get-MdContentsEntries (md-toc)   │ Line-based regex scan over text lines    │
│ Get-MdHeadings (md-repair)       │ Duplicate heading scanner with diff data │
│ Get-MdLineIndexFromBytes (md-toc)│ Manual byte-array scanning for 0x0A      │
│ Get-MdByteSpannedEntries (md-toc)│ Non-surrogate-safe section byte calculator│
│ New-MdTocSidecar (md-toc)        │ 80 lines of imperative string building   │
│ Set-MdContentsBlock (md-toc)     │ In-doc ## Contents text replacement      │
│ Inline $toc.Add(...) (finalize)  │ Hardcoded string concatenation in stream │
└──────────────────────────────────┴──────────────────────────────────────────┘
                                        │
                                        ▼ (Unified & Superseded By)
┌─────────────────────────────────────────────────────────────────────────────┐
│                     Unified md-tree-template Engine                         │
├──────────────────────────────────┬──────────────────────────────────────────┤
│ Component                        │ Unified Role & Implementation            │
├──────────────────────────────────┼──────────────────────────────────────────┤
│ Get-MdAnchor (md-toc.ps1)        │ Kept as canonical heading slug engine    │
│ New-DeliverableTreeModel         │ Single canonical model builder using     │
│                                  │ Interval Algebra (masks.ps1)             │
│ Expand-MdTemplate                │ Zero-dependency Handlebars-lite renderer │
│ Export-MdTreeSidecar             │ Template-driven {slug}-tree.md generator │
│ templates/single-doc-tree.md     │ Declarative template for tree sidecar    │
│ templates/in-doc-contents.md     │ Declarative template for in-doc ## Contents│
└──────────────────────────────────┴──────────────────────────────────────────┘
```

### Detailed Supersession Mapping

1. **`Get-MdAnchor` (`src/md-postprocess/md-toc.ps1`)**:
   * **Status**: Retained as canonical slug primitive.
   * **Role**: Computes GitHub-compatible heading anchors (`#1-introduction`). Used by `New-DeliverableTreeModel`.

2. **Heading Scanners (`Get-MdContentsEntries` & `Get-MdHeadings`)**:
   * **Status**: Superseded by `New-DeliverableTreeModel`.
   * **Fix**: Replaces duplicate line-regex scanners with `Get-TexProseMask` + `Get-NormalizedSpans` to detect headings outside code fences reliably.

3. **Byte-Span Calculators (`Get-MdLineIndexFromBytes` & `Get-MdByteSpannedEntries`)**:
   * **Status**: Superseded by Mask / Interval Algebra (`src/shared/masks.ps1`).
   * **Fix**: Replaces manual `0x0A` byte-loop scanning with SMP surrogate-pair safe interval bounds `[byte_start, byte_end)`.

4. **Imperative String Concatenators (`New-MdTocSidecar` & `New-MdContentsBlock`)**:
   * **Status**: Superseded by `Expand-MdTemplate`.
   * **Fix**: Replaces 80+ lines of imperative `[void]$sb.AppendLine(...)` string building with declarative templates in `src/md-postprocess/templates/`.

5. **`repair_headings` MCP Tool (`src/codex-membrane/mcp-server.ps1` & `md-repair.ps1`)**:
   * **Status**: Refactored to call `New-DeliverableTreeModel` and `Expand-MdTemplate`.
   * **Fix**: Preserves existing MCP tool signature while delegating rendering to the unified engine.

---

### 2.1 Extracted Design Constraints & Indentation Conventions

Extracted directly from existing legacy implementations (`src/md-postprocess/md-toc.ps1`, `src/audits/md-repair.ps1`, `src/finalize.ps1`), the new `md-tree-template` engine enforces the following invariants:

1. **Hierarchical Indentation Rule**:
   * **H2 Headings**: Flush (0 spaces indentation).
   * **H3 Headings**: Indented 2 spaces (`"  "`).
   * **H4 Headings**: Indented 4 spaces (`"    "`).
   * **General Formula**: `indent_string = '  ' * [Math]::Max(0, [int]$level - 2)`
   * The model builder (`New-DeliverableTreeModel`) pre-computes `$section.indent` so templates emit consistent hierarchical indentation without template logic bloat.

2. **Anchor Normalization Primitive (`Get-MdAnchor`)**:
   * Anchors are normalized via GitHub-style rules: lowercase, strip `[^\w\s-]`, substitute `\s+` $\to$ `-`, trim trailing hyphens.
   * Fallback: empty anchors fallback to `section-{hash}`.
   * Universal invariant: `Get-MdAnchor` remains the single source of truth across all conversion and post-processing steps.

3. **Self-Referential Heading Exclusion**:
   * Headings matching `^(?i)contents$` or `^(?i)table of contents$` are filtered out to prevent the TOC heading from self-referencing inside its own list.

4. **Link Scope Qualification**:
   * **In-Doc `## Contents`**: Emits relative internal hash links: `[Heading Text](#anchor)`.
   * **Sidecar `{slug}-tree.md`**: Emits document-qualified relative links: `[Heading Text]({slug}.md#anchor)`.

5. **Static Schema Header Row & Tabular Metadata**:
   * **Explicit Schema Header Row**: Directly above the tree entries, a static header row names every field and its exact quantity/units (`section row metadata: section_link | level | byte_start | byte_end | byte_width (B) | char_count (chars)`).
   * **Hierarchical Encoding**: Indentation encodes structural hierarchy (H2 flush, H3 2 spaces), while tabular values on each line provide exact byte offsets and character counts without repeating schema label noise.

---

### What Is Lifted (The Template Engine Mechanics):
* **The Handlebars-Lite Expander (`Expand-MdTemplate`)**: A lightweight 3-pass template expansion algorithm:
  1. `{{#each Collection}} ... {{/each}}` — Array iteration over section models.
  2. `{{#if Property}} ... {{/if}}` — Conditional section emission.
  3. `{{Dotted.Property.Path}}` — Scalar property substitution with scope resolution (`Resolve-TemplateValue`).

### What Is Decoupled & Redesigned (The Output Format):
The output format is **NOT** a verbatim copy of `reposnapshot`'s tree manifest. `reposnapshot` manifests index multi-file code repositories, enumerating payload shard file lists (`shard_001.md`), per-file row tables, and multi-file directory trees.

In contrast, `codex-scientiae` single-document tree sidecars (`{slug}-tree.md`) are simpler and domain-focused:
* **YAML Frontmatter Header**: Core document metadata (slug, title, authors, DOI, total bytes, section count).
* **Agent Guidance Callout**: Brief instruction explaining how to inspect sections via `view_file` using byte spans.
* **Hierarchical TOC Tree**: Clean bullet list linking to sections (`[Title](document.md#anchor)` for sidecars, `[Title](#anchor)` for in-doc TOCs) alongside `[byte_start, byte_end)` byte spans.

---

## 4. Mask / Interval Algebra Integration

Legacy string-splitting methods (`$text -split '(?m)^#+'`) destroy offset alignments and risk splitting multi-byte Unicode codepoints. The new tree engine leverages `src/shared/masks.ps1`:

```
Document Byte Space [0, TotalBytes)
 ├── Section 1:  [0, 1420)        (Title + Abstract)
 ├── Section 2:  [1420, 5890)     (1 Introduction)
 ├── Section 3:  [5890, 12400)    (2 Methods)
 └── Section 4:  [12400, 18500)   (3 Results & Discussion)
```

### Invariants Enforced by Interval Algebra:
1. **Totality**: $\bigcup_{i} [\text{start}_i, \text{end}_i) = [0, \text{TotalBytes})$. Section intervals cover the manuscript continuously without gaps or overlaps.
2. **Surrogate-Pair Safety**: Boundaries snap outward (`Move-OffsetToCodepointStart` / `Move-OffsetToCodepointEnd`), guaranteeing no surrogate pair (e.g. $\mathbb{R}$, $\mathcal{M}$) is cut in half at a section boundary.
3. **Byte-Level Precision**: Spans index exact UTF-16 / UTF-8 on-disk byte offsets for instant offset seeking.

---

## 5. Component Design & API Contract

### Module: `src/md-postprocess/md-tree-template.ps1`

```powershell
# 1. Assembles the deliverable tree model from Markdown text + metadata
function New-DeliverableTreeModel {
    param(
        [Parameter(Mandatory)][string]$MarkdownText,
        [Parameter(Mandatory)][string]$Slug,
        [hashtable]$Metadata = @{}
    )
    # Returns [PSCustomObject] containing:
    #   - Header: { slug, title, authors, doi, total_bytes, section_count }
    #   - Sections: Array of { level, title, anchor, byte_start, byte_end, byte_span, char_count }
}

# 2. Renders a template string against a model object
function Expand-MdTemplate {
    param(
        [Parameter(Mandatory)][string]$TemplateText,
        [Parameter(Mandatory)][object]$Model
    )
    # 3-pass expansion: {{#each}}, {{#if}}, {{Property}}
}

# 3. High-level exporter for deliverable tree sidecars
function Export-MdTreeSidecar {
    param(
        [Parameter(Mandatory)][string]$MarkdownFilePath,
        [string]$TemplatePath = (Join-Path $PSScriptRoot 'templates/single-doc-tree.template.md')
    )
    # Emits {slug}-tree.md beside {slug}.md
}
```

---

## 6. Output Format Specification: `{slug}-tree.md`

Below is the canonical layout of a single-document tree sidecar emitted by `Export-MdTreeSidecar`:

```markdown
---
slug: 2307.12345
title: "Persistent Homology over Metric Spaces"
authors: "Jane Doe, John Smith"
doi: "10.1016/j.top.2026.01"
total_bytes: 45890
section_count: 7
generated_at: "2026-07-30T12:30:00Z"
---

# Document Tree Manifest: 2307.12345

> **Agent Inspection Guidance:**
> This manifest indexes the structural sections of [`2307.12345.md`](file:///path/to/2307.12345.md).
> Each section carries a closed byte span `[byte_start, byte_end)`. To inspect a specific section
> without loading the whole document, use `view_file` with `ContentOffset = byte_start` and `Length = byte_end - byte_start`.

## Table of Contents & Section Byte Spans

`section row metadata: section_link | level | byte_start | byte_end | byte_width (B) | char_count (chars)`

- [Abstract](2307.12345.md#abstract)    H1    0    1420    1420    1380
- [1 Introduction](2307.12345.md#1-introduction)    H1    1420    5890    4470    4310
  - [1.1 Background](2307.12345.md#11-background)    H2    2800    4100    1300    1260
  - [1.2 Related Work](2307.12345.md#12-related-work)    H2    4100    5890    1790    1720
- [2 Methods](2307.12345.md#2-methods)    H1    5890    12400    6510    6380
  - [2.1 Boundary Operators](2307.12345.md#21-boundary-operators)    H2    7200    9800    2600    2520
- [3 Results & Discussion](2307.12345.md#3-results--discussion)    H1    12400    38500    26100    25400
- [References](2307.12345.md#references)    H1    38500    45890    7390    7150
```

---

## 7. Extension Path to Multi-Document / Bibliotheca Navigation

While single-document sidecars (`{slug}-tree.md`) serve standalone deliverables, the same template engine scales seamlessly to **multi-document compendia and bibliotheca navigation**:

```
Bibliotheca Compendium Root
├── bibliotheca-tree.md               <-- Multi-document Index (renders compendium template)
├── paper-01/
│   ├── paper-01.md
│   └── paper-01-tree.md              <-- Single-document Tree Sidecar
└── paper-02/
    ├── paper-02.md
    └── paper-02-tree.md              <-- Single-document Tree Sidecar
```

### Structural Comparison: Reposnapshot vs. Bibliotheca Engine

| Dimension | `reposnapshot` Shards | `codex-scientiae` Single-Doc Tree | `bibliotheca` Compendium Tree |
|---|---|---|---|
| **Unit of Abstraction** | Code repository file / payload chunk | Single academic manuscript section | Multi-paper compendium / corpus volume |
| **Indexing Dimension** | File path, line count, token size | Heading hierarchy, `#anchor` link, `[byte_start, byte_end)` | Paper slug, title, DOI, primary topics, relative paths |
| **Primary Use Case** | Repository context window slicing | Section-level reading without full document loading | Corpus-wide agent routing & compendium navigation |

---

## 8. Next Steps for Implementation

1. Create template files in `src/md-postprocess/templates/`:
   * `single-doc-tree.template.md`
   * `in-doc-contents.template.md`
2. Implement `New-DeliverableTreeModel`, `Expand-MdTemplate`, and `Export-MdTreeSidecar` in `src/md-postprocess/md-tree-template.ps1`.
3. Add unit tests in `tests/md-tree-template.Tests.ps1`.
4. Integrate `Export-MdTreeSidecar` into `Copy-MdDeliverable` (`src/md-postprocess/md-bundle.ps1`) and pipeline entry points.
