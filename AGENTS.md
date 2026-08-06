## State of the project

After a great deal of hasty development, many initiatives hit a wall and the project is now under drastic renovations on many levels including reorganizing, refactoring and disentangling concerns in source code, establishing repository layout and hygiene standards/conventions, codifying replication workflows for internal and external dependencies, and re-writing project-level documentation. It's therefore important to help the user identify systemic issues, repair bad patterns that have emerged, and remain open to fluid changes in workflow conventions, terminology and development goals.

This document is intentionally vague in order not to overspecify or otherwise block flexible problem-solving and fresh perspective on earlier work and development practices.

## Notices

1. With the entire project currently under heavy renovation and flux, it will not be uncommon to find code unexpectedly broken and items missing due to breaking changes and moving things. Just because a test or import fails, or something isn't where you expect it to be, doesn't mean it doesn't exist anymore. More likely, it has been moved without having the appropriate pointers updated. If confused, ask the user for clarification or guidance if you encounter an issue like this.

2. the new batch-executor is now operational, with adapters for latex-ingest as well as the test suite. the entry-point for doing latex-ingest batch runs.

3. See `tests/README.md` for guidance on adding new tests and running test batches via the batch-executor entrypoint. See ingestion/README.md for detail, and src/latex-ingest/latex-batch.ps1 for the inventory-based entrypoint.

## Codex-Scientiae MCPs

This project develops several distinct MCP concepts relating to procurement, document ingestion, asset management and reader/consumer of codex-scientiae materials, and continue to evolve.

### Procurement and the "Scholar"

An umbrella for identifying, discovering and acquiring source materials for codex-scientiae ingestion that includes functionality for things like fetching source material assets from Arvix, Zenodo, Sci-Hub, DOI based search, semantic scholar queries, among other things.

### latex-ingest MCP

A planned MCP for running latex-to-markdown e2e pipeline and help with managing asset delivery and housekeeping matters. May eventually be subsumed by the planned Librarian MCP concept.

### Reader MCP

Currently under development, it implements basic capabilities for an agent to navigate and "read" codex-scientiae assets based on the projects TOC sidecar semantics and features.

### Librarian MCP

A planned MCP implementation that will equip an agent with tools and guidance for performing maintenance on collected codex-scientiae knowledge assets such as the `bibliotecha' collections including codices, compendia and corpora pillars.

### Codex-Membrane

A now-retired MCP that was dedicated to opendataloader-pdf markdown repair but which pioneered the role of a reasoning agent and sub-agent swarms in adjudicating and resolving ambiguity and quality control in agentic PDF conversion workflows, themes that will return in the successor to the codex-membrane and pdf-converter pilot projects.

## Connection to other projects

Since this project exists to inspire and guide development on other projects, user may ask to commit analysis, digests and briefs to other projects particularly [ThermoMapper](..\ThermoMapper)

User may also create snapshots for ease of inspection under `..\project-snapshots` , in particular the SPCX (running codename for ps.core.pwshspc) snapshot folder there .

## Graveyard

[graveyard/codex-scientiae](..\graveyard\codex-scientiae) is the archive repository for refuse and retired code moved out of codex-scientiae, and a source for archaeological excavation for future development
