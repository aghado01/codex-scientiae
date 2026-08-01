Not in any particular order:

- codify repository conventions for defining and managing dependencies that span several distinct languages and development paradigms including C#, nodejs, and powershell, loosely inspired by tools like homebrew
- `codex-scientiae/artifacts` is git-ignored and contains intermediate build artifacts for various things including ingestion workflow runs, compiler build artifacts for C# and npm, and other things
- `codex-scientiae/brewery` not git-ignored, intended to contain recipes for specifying, rehydrating and replicating project dependencies such as specifications for dotnet and npm builds, code relating to the compiler build executions, fetching scripts, package management specs, dependency versions, lock files, etc.
- `codex-scientiae/packages` contains dependency payloads libraries and binaries built from first (e.g. hdbscan) or third-party (e.g. pdfpig) vendors. includes node_modules for each npm dependency, maintained separately.
  - need to migrate items under `tools` including first-party driver code that uses dependencies into src, localized with the project code it relates to
  - move node_modules to `packages`
  - move lock files and other items as appropriate to `brewery`
  - refactor build workflows to respect the new organizational principles

- consolidate, disentangle, refactor and generally get source code under control
- latex-ingest and MCP are current refactoring priorities
- identifying systemic design and implementation failures in old code
- quarantine retired initiatives' code such as codex-membrane and pdf-converter, retain elsewhere for post-mortem analysis and next-gen planning and design
- clean up tests and reoganize into modular `tests/{module}` layout that parallels emerging `src/{module}` structure
