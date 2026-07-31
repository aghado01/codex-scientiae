# Design Specification: Reshaped Deliverable Bundle & `.runs` Discipline

**Target Module:** `src/md-postprocess/md-bundle.ps1`  
**Specification Document:** `issues/md-postprocess/bundle-architecture.md`  
**Status:** Design & Architectural Specification  

---

## 1. Executive Summary & Deliverable Folder Anatomy

`codex-scientiae` standardizes document deliverables on a **self-contained directory bundle convention**. 

Rather than scattering loose markdown files and sibling asset folders at the root of `$markdown_dir` (e.g. `$markdown_dir/{slug}.md` + `$markdown_dir/{slug}/*.png`), every deliverable is encapsulated in a dedicated directory `$markdown_dir/{slug}/`.

```
$markdown_dir/
└── {slug}/                              <-- Self-Contained Deliverable Bundle Directory
    ├── {slug}.md                        <-- Main Markdown Manuscript
    ├── {slug}-tree.md                   <-- Single-Document Tree TOC Sidecar Manifest
    ├── {slug}.toc.jsonl                 <-- Machine-Readable Byte-Spanned TOC Sidecar
    └── images/                          <-- Standardized Asset Subdirectory
        ├── figure-01.png
        ├── figure-02.png
        └── diagram-01.svg
```

### Invariants:
1. **Self-Containment**: A deliverable bundle directory (`$markdown_dir/{slug}/`) can be moved, zipped, or archived as a single standalone folder.
2. **Relative Link Stability**: All image links inside `{slug}.md` resolve relatively to `images/<filename>`.
3. **Tree Sidecar Proximity**: `{slug}-tree.md` resides directly beside `{slug}.md`, pointing relatively to `{slug}.md#anchor`.
4. **Deliverable Cleanliness**: Deliverable bundles contain **only** production assets. Zero intermediate build noise or compiler logs.

---

## 2. Portable Localized Intermediate Artifact Discipline (`.runs`)

During ingestion, compilation, and post-processing (`latex-ingest`, `pdf-converter`, `md-repair`), intermediate build state is created (e.g. un-tarred LaTeX source files, `.aux`/`.log`/`.bbl` TeX compiler outputs, intermediate JSON AST manifests, temporary diagram compile logs).

### Project Organization Hygiene & Portable Conventions

> **Project Hygiene Rule**: Ephemeral downloaded files and raw material assets (PDFs, LaTeX tarballs, un-tarred TeX source files) belong in their conventional place within the project structure rather than dumping files at the repository root level.
>
> **Conventional Inbox Path**: The conventional default location for downloading and depositing raw source materials is **`ingestion/_inbox/{slug}/`**.
>
> **Parameterization Principle**: `ingestion/_inbox/{slug}/` is an **organizational convention for project hygiene**, not a hardcoded path rule. All pipeline tools accept explicit `-SourceDir` parameters. If omitted, tools default to `ingestion/_inbox/{slug}/`, but execute dynamically against any arbitrary source directory path provided.

```
Conventional Ingestion Root (ingestion/)
├── ingestion/_inbox/{slug}/             <-- Conventional Inbox Directory for Raw Downloads
│   ├── {slug}.tex / {slug}.pdf          <-- Input Source Material
│   └── .runs/                           <-- Localized Intermediate Build State
└── ingestion/compendia/{slug}/          <-- Curated Grouping Directory
```

### Rules for Portable `.runs` Discipline:
1. **Portable Source Localization**: `.runs/` directories are created directly inside the active source directory `$SourceDir/.runs/`, completely independent of specific folder names or paths.
2. **Non-Propagation**: `Copy-MdDeliverable` (`src/md-postprocess/md-bundle.ps1`) explicitly ignores `.runs/` directories when building clean deliverable bundles in `$markdown_dir/{slug}/`.
3. **Idempotence**: Deleting a `$SourceDir/.runs/` folder safely resets intermediate build state without destroying original source inputs or finalized deliverable bundles.

---

## 3. Bundler Operations (`src/md-postprocess/md-bundle.ps1`)

`Copy-MdDeliverable` in `src/md-postprocess/md-bundle.ps1` orchestrates the creation and validation of the reshaped deliverable bundle:

```powershell
function Copy-MdDeliverable {
    param(
        [Parameter(Mandatory)] [string]$MarkdownPath,
        [Parameter(Mandatory)] [string]$DestDir
    )
    # 1. Resolves $slug from $MarkdownPath filename
    # 2. Creates destination bundle directory: $bundleDir = Join-Path $DestDir $slug
    # 3. Copies main manuscript -> $bundleDir/$slug.md
    # 4. Relocates & rewrites referenced local images -> $bundleDir/images/
    # 5. Generates tree sidecars -> $bundleDir/$slug-tree.md & $bundleDir/$slug.toc.jsonl
    # 6. Runs post-copy verification (broken link check, sentinel audit)
}
```

---

## 4. Summary of Changes to Existing Pipelines

| Pipeline / Module | Old Behavior | New Reshaped Behavior |
|---|---|---|
| **`src/md-postprocess/md-bundle.ps1`** | Copies `{slug}.md` + loose `{slug}/` sibling image folder | Copies to `$DestDir/{slug}/`, putting manuscript in `{slug}.md`, sidecar in `{slug}-tree.md`, and images in `images/` |
| **`src/latex-ingest/latex-ingest.ps1`** | Emits loose intermediate files in working directory | Localizes intermediate TeX/diagram build state under `_inbox/{slug}/.runs/` |
| **`src/publish.ps1`** | Indexed loose `{slug}.md` files | Indexes self-contained deliverable bundle folders `$markdown_dir/{slug}/` |
