## State of the project

After a great deal of hasty development, many initiatives hit a wall and the project is now under drastic renovations on many levels including reorganizing, refactoring and disentangling concerns in source code, establishing repository layout and hygiene standards/conventions, codifying replication workflows for internal and external dependencies, and re-writing project-level documentation. It's therefore important to help the user identify systemic issues, repair bad patterns that have emerged, and remain open to fluid changes in workflow conventions, terminology and development goals.

This document is intentionally vague in order not to overspecify or otherwise block flexible problem-solving and fresh perspective on earlier work and development practices.

## Notices

1. With the entire project currently under heavy renovation and flux, it will not be uncommon to find code unexpectedly broken and items missing due to breaking changes and moving things. Just because a test or import fails, or something isn't where you expect it to be, doesn't mean it doesn't exist anymore. More likely, it has been moved without having the appropriate pointers updated. If confused, ask the user for clarification or guidance if you encounter an issue like this.

2. the new batch-executor is now operational

3. See `tests/README.md` for guidance on adding new tests and running test batches via the batch-executor entrypoint.

4. Repository test runs and test scratch belong under `artifacts/tests/{suite}/YYYYMMDD_HHmmss[_NN]`
   (ISO-ordered date so directory names sort chronologically; `_NN` is a same-second collision
   sequence, never a label). `New-TestSuiteRunDir` in `src/infrastructure/containment.ps1` is the minting
   authority and `tests/batch.ps1` calls it — do not format a stamp by hand. Module run output uses
   the sibling tier `artifacts/{module}/{stamp}/{slug}/` via `New-ModuleRunDir`.
   The repository `.codex/` tree and the user-global `~/.Codex` tree are Codex CLI client state,
   not a project write boundary.

## Codex-Scientiae MCPs

This project develops several distinct MCP concepts relating to procurement, document ingestion, asset management and reader/consumer of codex-scientiae materials, and continue to evolve.

### Procurement and the "Scholar"

An umbrella for identifying, discovering and acquiring source materials for codex-scientiae ingestion that includes functionality for things like fetching source material assets from Arvix, Zenodo, Sci-Hub, DOI based search, semantic scholar queries, among other things.

### Reader MCP

Currently under development, it implements basic capabilities for an agent to navigate and "read" codex-scientiae assets based on the projects TOC sidecar semantics and features.

## Connection to other projects

Since this project exists to inspire and guide development on other projects, user may ask to commit analysis, digests and briefs to other projects particularly [ThermoMapper](..\ThermoMapper)

User may also create snapshots for ease of inspection under `..\project-snapshots` , in particular the SPCX (running codename for ps.core.pwshspc) snapshot folder there .

## Graveyard

[graveyard/codex-scientiae](..\graveyard\codex-scientiae) is the archive repository for refuse and retired code moved out of codex-scientiae, and a source for archaeological excavation for future development

## Dev Guidelines (WIP)

- Separation of code and config. Config is data.

- Docstrings are future public materials that should be written in declarative, factual voicing -- not persuasive essay, not doctrine, not commentary, or even exposition -- just terse facts. When editing existing files, review the doc strings and ask if they should be revised to conform to this sensibility.

- Reusability: This project strives to write minimal lines of code and maximize effectiveness. If shared primitives already enable or should naturally own an operation, don't duplicate functionality in bespoke helper utilities (such as jsonl read/write primitives or markdown processing operations).

### PowerShell Conventions

- **Collections as Return Values**: PowerShell enumerates collections across the pipeline, collapsing empty collections to `$null` and single-element collections to scalars. The unary-comma idiom (`,$x`) is fragile across call sites and easily omitted. A collection must be exposed as a property or method result (e.g., `$ledger.Results()`), never a bare function return value.

- **Classes and Session State**: Class methods resolve commands in the caller's session state, not the defining module's session state. Class methods should interact strictly with .NET types and their own members rather than invoking module functions.

- **Class Method Defaults and Validation**: PowerShell class methods discard parameter defaults (e.g. `[hashtable]$d = @{}`) at compile time; use method overloads instead. Method parameters do not support `[ValidateSet]`; enforce parameter validation explicitly in method logic.

- **Module Class Exports**: PowerShell classes do not export cleanly from modules across all import patterns. Provide a public factory function (e.g., `New-ProbeLedger`) as the module's outward-facing constructor.

### Verification & Evidence Ledgers

- **Witnessed Claims vs. Absence of Failure**: Artifacts must record witnessed checks rather than asserting hardcoded check names or assuming "nothing threw". A ledger records explicitly witnessed execution per probe.

- **Tri-State Probe Outcomes**: Probes distinguish three outcomes:
  - `passed`: The probe ran and its condition held.
  - `not-applicable`: The input shape did not call for the check (e.g., a single-payload archive has no members to confine; an entrypoint was explicitly specified so ambiguity scanning was bypassed).
  - `waived`: Tolerant mode accepted what strict mode would reject (e.g., missing literal inputs).
  - *Rule*: `ABSENT` is not `PASSED`, and `TOLERATED` is neither. Non-passing outcomes (`not-applicable`, `waived`) must specify a `reason` in their detail payload.

- **Success-Side Recording**: Probes record on the success side of guards. Failing probes still throw and abort the transaction. The ledger makes non-firing guards enumerable; it never converts a throw into a result.

- **Bidirectional Coverage Assertion (`AssertCoverage`)**: Callers declare the probe set they are accountable for. Both directions fail:
  - An unwitnessed claim: a declared probe was never recorded.
  - An undeclared claim: a recorded probe was never declared.
