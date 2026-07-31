# Design Specification: `reader-mcp` (Corpus Reader & Navigation Server)

**Target Server Location:** `src/reader-mcp/mcp-server.ps1`  
**Design Document:** `issues/reader-mcp/reader-mcp-design.md`  
**Status:** Design & Vision Specification  

---

## 1. Executive Summary & Vision

The **`reader-mcp`** is a dedicated Model Context Protocol (MCP) server designed to serve as the **read-heavy navigation, retrieval, and section-slicing interface** for `codex-scientiae` corpus assets.

While `codex-membrane` focuses on document ingestion, structural audit, chunk repair, and editing proposals, **`reader-mcp`** is engineered specifically for downstream LLM agents reading, navigating, and synthesizing documents across the corpus.

It exposes reusable primitives based on the asset architecture design and provides **first-class tool fluency** for accessing and consuming the distinctive pillars of the Bibliotheca architecture.

---

## 2. The Bibliotheca Asset Pillars

The Bibliotheca structures scientific knowledge into three distinct collection pillars, alongside single-document deliverables:

```
                          ┌────────────────────────┐
                          │   Bibliotheca Assets   │
                          └───────────┬────────────┘
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
┌──────────────┐              ┌──────────────┐              ┌──────────────┐
│  Compendia   │              │   Corpora    │              │   Codices    │
├──────────────┤              ├──────────────┤              ├──────────────┤
│ Concept &    │              │ Author &     │              │ Textbook &   │
│ Lineage      │              │ Canon        │              │ Chapter      │
│ Collections  │              │ Archives     │              │ Shards       │
│ (SPC, BARS,  │              │ (Author      │              │ (Monographs, │
│  ph-zigzag)  │              │  Outputs)    │              │  Volumes)    │
└──────────────┘              └──────────────┘              └──────────────┘
```

### 1. Compendia
* **Definition**: Collections of source materials grouped by specific research concepts, theoretical frameworks, or methodological lineages.
* **Examples**: `SPC` (Statistical Process Control / Signal Processing), `BARS`, `ph-zigzag` (Persistent Homology Zigzag).
* **Structural Semantics**: Cross-paper method comparisons, conceptual lineage graphs, and thematic index trees.

### 2. Corpora
* **Definition**: Collections of works grouped by author, research group, or institutional canon.
* **Examples**: Primary author publication archives, lab outputs.
* **Structural Semantics**: Chronological publication sequences, author bibliographies, and co-author cross-walks.

### 3. Codices
* **Definition**: Textbooks and major scientific monographs converted from LaTeX/PDF source and "sharded" into chapter/part files.
* **Examples**: Multi-chapter academic textbooks and reference volumes.
* **Structural Semantics**: Chapter/part hierarchy, volume bounds, cross-chapter definition indices, and theorem dependency chains. Structurally resemble corpora/compendia, but carry distinct chapter-level scope and volume semantics.

---

## 3. Core Affordances & MCP Tool Suite

### 1. Primitive Slicing & Tree Tools
* **`get_document_tree(slug)`**: Fetches the structured tree manifest (`{slug}-tree.md`) containing metadata, section hierarchy, and `[byte_start, byte_end)` byte spans.
* **`read_section_span(slug, anchor | byte_start, byte_end)`**: Precision section-level slicing directly over storage using interval byte spans. Guarantees SMP surrogate-pair safety.

### 2. Pillar-Fluent Navigation Tools
* **`get_compendium_tree(compendium_id)`**: Navigates conceptual compendia (`SPC`, `ph-zigzag`), exposing concept lineage links, method comparisons, and paper member lists.
* **`get_author_corpus(author_name)`**: Traverses author-based corpus archives, exposing chronological work lists and paper relationships.
* **`get_codex_chapters(codex_id)`**: Navigates textbook chapter shards, returning chapter byte spans, part groupings, and theorem/definition indexes.
* **`search_corpus_toc(query, pillar_filter)`**: Cross-document Table of Contents search across all tree sidecars in the corpus with optional pillar filtering (`compendium`, `corpus`, `codex`).

---

## 4. Architectural Alignment

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        Ingestion & Repair Layer                         │
│   latex-ingest  /  pdf-converter  /  codex-membrane (repair/edit)     │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │ (Emits deliverables + sidecars)
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        Post-Processing Subsystem                        │
│   src/md-postprocess/ (md-tree-template, md-hygiene, md-bundle)        │
│   Generates: {slug}.md + {slug}-tree.md + bibliotheca-tree.md          │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │ (Indexes byte-spanned manifests)
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        Consumption & Reader Layer                       │
│                           reader-mcp (MCP Server)                       │
│   Primitives: get_document_tree, read_section_span                       │
│   Pillar Tools: get_compendium_tree, get_author_corpus, get_codex_chapters│
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Synergy with Mask Algebra & Downstream Agent Workflows

1. **Token Efficiency**: Instead of an agent reading a 100KB manuscript to answer a question about Section 3.2, `reader-mcp` allows the agent to call `get_document_tree`, identify Section 3.2's `[12400, 18500)` byte span, and execute `read_section_span` for a 6KB focused slice.
2. **Context Preservation**: Unrelated math blocks, tables, and prose stay outside the agent's context window.
3. **Surrogate Safety**: Byte-span slicing uses `Move-OffsetToCodepointStart` / `Move-OffsetToCodepointEnd` from `src/shared/masks.ps1`, guaranteeing that non-ASCII math symbols ($\mathbb{R}, \mathcal{M}$) are never severed.
4. **Pillar Fluency**: Agents query assets using the natural domain language of the pillar (e.g. querying a `codex` by chapter or a `compendium` by concept lineage).

---

## 6. Phased Roadmap

* **Phase 1 (Current)**: Finalize single-document tree sidecar template engine (`src/md-postprocess/md-tree-template.ps1`).
* **Phase 2**: Codify multi-file bibliotheca navigation file generation (`bibliotheca-tree.md`) across Compendia, Corpora, and Codices pillars.
* **Phase 3**: Implement `src/reader-mcp/mcp-server.ps1` exposing the primitive and pillar-fluent tool suite.
