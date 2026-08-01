## How To Use This Repository

- Start at the directory that matches the material you want.
- Open that directory's `CONTENTS.md` first.
- If a collection does not yet have a `CONTENTS.md`, use its primary source document until an index is added.
- Keep this README at directory level only; do not expand chapter, section, or subsection trees here.

## Resource Map

Navigation is telescoping — the single source of truth is [CONTENTS.md](CONTENTS.md), which points to the
per-collection roots ([codices](codices/CODICES.md), [compendia](compendia/COMPENDIA.md),
[corpora](corpora/CORPORA.md)); each of those points further down. Don't duplicate the tree here — it drifts.

The three collections:

- **codices/** — long-form textbooks (Bishop2006, Grimmett2006, McLachlan2000).
- **compendia/** — curated, theme-ordered paper collections (ph, ph-applied, mapper, statistics, …).
- **corpora/** — author/topic paper sets (KisungYou, VladVoroninski).

## Pipeline (how documents get here)

Published documents are produced by the **codex-membrane** restoration pipeline, not by hand. Raw extracts
land under `ingestion/` (`ingestion/{codices,compendia,corpora}/…`), are repaired chunk-by-chunk through the
membrane (the MCP server and workflow in `src/codex-membrane/`), then `publish`ed into the collections
above. See [WORKFLOW.md](WORKFLOW.md) (failure taxonomy) and [STANDARDS.md](STANDARDS.md) (output format).
