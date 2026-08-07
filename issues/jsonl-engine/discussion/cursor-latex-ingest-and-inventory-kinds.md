Sweep is in: **705** `.jsonl` files (excluding worktrees). [`BaseArtifactRegistry`](src/shared/jsonl_engine/registry.py) already seals `KIND` / `VERSION` / `SCHEMA` + header, but **no concrete kind subclasses exist yet**, and its filename pattern (`{KIND}[.run_id].jsonl`) does not match the dominant on-disk convention (`{stem}.{kind}.jsonl`).

### Observed kind clusters

| Family              | Suffix / name                                            | Count | Producer signal        |
| ------------------- | -------------------------------------------------------- | ----: | ---------------------- |
| Latex ingest spine  | `.docstream`, `.refs`, `.slots`, `.diagrams`, `.toc`     |  ~244 | `latex-ingest`         |
| PDF geometry lanes  | `.blocks/.words/.letters/.paths/.figures`                |   430 | inbox / membrane       |
| Membrane repair     | `.nodes/.chunks/.ledger/.discards/.repair-discards`      |   ~12 | membrane-testing       |
| Navigation / corpus | `.toc`, `.chunks` (bibliotecha)                          | small | reader / corpora       |
| Batch ops           | `inventory.jsonl`                                        |     1 | batch-executor         |
| Agent ops           | `reads.jsonl`, chat `exchanges` / `rollout-*`            |   ~10 | doc-dive / chat-export |
| Scratch / fixtures  | `formulas`, `result`, hdbscan `bands/blobs/boxes/panels` |   few | issues / tests         |

None of the production lanes currently write a `__type__: header` line; schemas are implicit in record keys (`kind`/`type`/`id`/`seq`/etc.).

Before I lock a plan, need two decisions:

1. **Deliverable**
   - **A)** Kind catalog under `issues/jsonl-engine` only
   - **B)** Catalog + a central `KindRegistry` map in `jsonl_engine` (id → pattern/producer/discipline/notes), no per-kind schemas yet
   - **C)** Concrete `BaseArtifactRegistry` subclasses + JSON Schemas for production kinds now

2. **Coverage this pass**
   - **Production only** (latex + PDF/membrane + inventory + reads)
   - **Production + ops** (add chat-export / batch telemetry)
   - **Everything** in the sweep

Perhaps registry kinds could adopt pattern **`{stem}.{kind}.jsonl`** (match reality)
