# shared-primitives — ledger (completed)

Index of what landed. Design: [primitive-extraction-design](2026-08-08-primitive-extraction-design.md);
plan: [primitive-extraction-plan](2026-08-08-primitive-extraction-plan.md); program map:
[consolidation-program](../../infrastructure/planning/2026-08-08-consolidation-program.md).

## 2026-08-08

- **Thread 1 — PS-native primitive extraction (behavior-preserving lift).** Three themed, dot-sourced,
  side-effect-free `src/shared` files, each independently tested, and every previous copy retired onto
  them. No logic changed; the lifts were verified equivalent to what they replaced.
  - **`src/shared/portable-path.ps1`** — `Test-PortableLeaf` (regex form, aligned with the article
    schema's `portableLeaf`) and `Test-PathHasReparsePoint`. Retired the identical/equivalent copies in
    `latex-patch.ps1`, `latex-source.ps1`, and `latex-inventory-row.ps1`.
  - **`src/shared/file-bytes.ps1`** — `Read-BoundedFileBytes -Path -MaxBytes` (TOCTOU-guarded, `MaxBytes`
    a parameter), `Get-ContentIdentity` (`sha256:<hex>`), `Test-ContentIdentityFormat`. Replaced
    `latex-patch`'s bounded read + raw-identity and the adapter's bounded incremental hash.
  - **`src/shared/authored-jsonl.ps1`** — `Read-AuthoredJsonl` (reparse-guard → absent → bounded read →
    identity + optional drift assertion → UTF-8/no-BOM/no-bare-CR → comment/blank tolerance → one strict
    object per line, no dup/case-colliding keys → `{ line, fields }`) plus `Get-JsonRequiredString` /
    `Get-JsonOptionalString` / `Get-JsonOptionalPositiveInteger`. A `-Subject` parameter (default
    `'authored JSONL'`) labels file/path/identity error messages so a caller keeps its own wording; the
    reader owns no domain vocabulary.
  - **Consumers repointed.** `latex-patch.ps1` (its `Read-LatexPatchSet` now = build path → shared reader
    with `-Subject 'LaTeX patch'` → map records through the `op` vocabulary in `ConvertFrom-LatexPatchRecord`;
    nine helper functions removed). `latex-source.ps1` + `source-deposit.ps1` +
    `logistics/latex-source-deposit.ps1` (incl. its in-process `${function:}` closure capture) +
    `latex-ingest.ps1` onto `Test-PathHasReparsePoint`. The adapter `latex-inventory-row.ps1` onto the
    shared safety + bytes primitives.
  - **Gates.** New: portable-path 10/10, file-bytes 5/5, authored-jsonl 6/6. No-regression net held:
    latex-patch 22/22, latex-batch 10/10, source-deposit 12/12, latex-source-deposit 5/5,
    latex-ingest-integration 7/7, latex-ingest-compat 4/4, wider latex-ingest 60/60. All 17 changed `.ps1`
    parse clean; `git diff --check` clean; zero straggling references to the retired function names.
  - **Test wording changed (behavior identical):** two oversize assertions moved off the domain-specific
    `1 MiB` / `canonical patch exceeds` wording onto the byte-parameterized primitive's generic
    `exceeds the 1048576-byte limit`. `-Subject` preserved every other message verbatim, so no other
    assertion changed.

### Deferred / deviations

- **`Test-PathWithinRoot` NOT unified (deferred).** Its copies diverge — `latex-source.ps1` uses a
  case-folding `StartsWith` prefix; `latex-inventory-row.ps1` and `inventory-catalog.ps1` use ordinal
  relative-path (`..`) checks. Unifying it is a reconciliation with a real behavior decision, not the
  behavior-identical lift the rest of thread 1 was. Left in place; wants its own scoped pass.
- **`invoke-latex-ingest.ps1` identity-format regex left in place (deviation from plan T6/5).** The worker
  validates `ExpectedPatchIdentity` on its fast-fail path *before* it dot-sources anything, inside a batch
  child process. Adding a `src/shared` dependency there is higher blast-radius than retiring one inline
  regex warrants, so the `^sha256:[0-9a-f]{64}$` check stays. Revisit if the worker later loads shared
  files anyway.

### Unchanged

- The `path-topology` container remains red on its four pre-existing retired-JSONL references
  (`jsonl.ps1`, `jso-ops/jsonl-v2*.ps1` from unrelated test files) — documented archaeology, not touched
  by this work, which introduced no new topology violation.

### Next (consolidation program)

- Thread 2 — retire `inventory-catalog.ps1` onto the engine (add a registry-rebuild CLI verb; the engine
  machinery already exists). Thread 3 — promote the Ledger archetype into the engine.
