# External TeXdig gauntlet via Codex batch-adapters

Yes. Codex owns the corpus, the batch engine, run hygiene, and artifacts. aipithicus/texdig owns the engine and a thin caller. That matches aipithicus `docs/testing.md` §4 (corpus runs are a downstream application's job; no corpus runner ships in TeXdig) and the existing adapter contract (emit `BatchJob` records only; caller owns `New-BatchPlan` / `Invoke-BatchPlan`).

## What already exists

- **Adapter + executor:** `Get-TeXdigBatchJob` + `Find-TeXdigBatchArticle` already do one deposited `article.json` per job, collection expansion one level, run-relative `texdig-jobs/` + `texdig-temp/`, and `CODEX_TEMP` on the child.
- **House caller pattern:** `tests/batch.ps1` (mint + `CODEX_TEMP`) → `tests/parallel.ps1` (adapters → plan → invoke). Pester/pytest only; do not hang a gauntlet off `parallel.ps1`.
- **Precedent:** in-repo census worker `src/TeXdig/run-census.ps1` composed by `Get-TeXdigBatchJob`; graveyard `Get-LatexBatchJob` (inventory row → isolated child, caller-owned plan).
- **Gap:** `Get-TeXdigBatchJob` freezes `src/TeXdig/run-census.ps1` and `packages/node` inside **RepositoryRoot**. The new engine lives at `D:\aipithicus\texdig`. `@texdig/cli` is documented, not landed. `tests/TeXdig` is already gone.

Do not overload `Get-TeXdigBatchJob` until the leftover in-repo census is graveyarded. New adapter, same module.

## Split

| Owner | Owns |
|---|---|
| **codex-scientiae** | `ingestion/gauntlet` deposits; `Get-TeXdigGauntletJob`; run minting; `artifacts/texdig/{stamp}/{slug}/`; `CODEX_TEMP` / JSON scratch; article discovery |
| **aipithicus/texdig** | Engine; `scripts/codex-gauntlet.ps1` (caller); `scripts/codex-gauntlet-worker.ps1` (child entry) |

Gauntlet stress is **module run output**, not a test-batch: mint with `New-ModuleRunDir -Module texdig -Slug gauntlet` → `artifacts/texdig/{stamp}/gauntlet/`. Not `artifacts/tests/`.

## Codex adapter: `Get-TeXdigGauntletJob`

New public command in `src/batch-adapters` (export from `adapters.psd1`; load via existing `adapters.psm1` host-file list).

**Inputs**

- `Path` — article dir, `article.json`, or collection dir. Same expansion as `Find-TeXdigBatchArticle` (reuse that helper; do not copy).
- `RunDirectory` — existing absolute descendant of **Codex** `RepositoryRoot/artifacts` (existing `Resolve-BatchAdapterRunDirectory`).
- `RepositoryRoot` — Codex root (default adapter default).
- `EngineRoot` — mandatory, absolute, **outside** Codex; aipithicus/texdig.
- `Worker` — optional; default `{EngineRoot}/scripts/codex-gauntlet-worker.ps1`. Must exist at plan time (fail the whole plan, same as current TeXdig worker freeze).
- `PowerShellPath` — same resolution as the other adapters.

**Planning (no mkdir, no invoke)**

- Identity: `texdig-gauntlet:{codex-relative-article}#{treeSha256-digest}` (re-deposit changes id).
- Address: `RunDirectory/texdig-jobs/<slug>-<digest>/` and `RunDirectory/texdig-temp/<slug>-<digest>/` (reuse `Resolve-TeXdigBatchJobAddress`).
- Child: `Kind = PowerShellProcess`, `EntryPoint = Worker`, `WorkingDirectory = EngineRoot`.
- Parameters frozen: `Article`, `OutDirectory` (= job dir), `EngineRoot`.
- Env: `CODEX_TEMP` = temp root; `CODEX_JSON_SCRATCH_ROOT` = `{temp}/json-scratch`; `TEMP`/`TMP`/`TMPDIR` projected from `CODEX_TEMP`.
- `Writes`: job dir + temp root.
- Cost: tree bytes from `article.json` (existing manifest read).

Adapter does **not** know the new engine's store schema. The worker owns emission under `OutDirectory`.

Thinness unchanged: no `New-Item`, no `New-ModuleRunDir`, no `Invoke-BatchPlan`.

## aipithicus caller (thin)

`scripts/codex-gauntlet.ps1` — the only Codex-facing surface in TeXdig.

1. Resolve Codex root: `-CodexRoot`, else `CODEX_SCIENTIAE_ROOT`, else refuse (no silent `D:\aghado01\...`).
2. Dot-source `src/logistics/run-paths.ps1` and `artifact-boundary.ps1`; import `adapters.psd1` and `batch-executor.psd1`.
3. Mint `New-ModuleRunDir -Module texdig -Slug gauntlet -ArtifactsRoot (Join-Path $CodexRoot artifacts)`.
4. `Set-CodexTempEnvironment` against that run (does not touch ambient TEMP).
5. `$jobs = Get-TeXdigGauntletJob -Path (Join-Path $CodexRoot 'ingestion/gauntlet') -RunDirectory $run -RepositoryRoot $CodexRoot -EngineRoot $TeXdigRoot` (optional `-Path` for one collection or one article).
6. `New-BatchPlan` / `Invoke-BatchPlan`. Same success/fail throw shape as `tests/parallel.ps1`.
7. Forward `-MaxWorkers` etc. as executor args. Do not reimplement scheduling.

`scripts/codex-gauntlet-worker.ps1` — child entry the adapter freezes.

- Params: `Article`, `OutDirectory`, `EngineRoot`.
- Require `CODEX_TEMP` (absolute). Do not read ambient TEMP as scratch.
- Invoke the engine against the deposit's `{slug}-tex/` tree (or whatever the engine's first gauntlet surface is). Until `@texdig/cli` exists, this script is the freeze point: it may call `node` on a documented EngineRoot entry; it must not write outside `OutDirectory` / `CODEX_TEMP`.
- Nonzero exit on worker failure. No run-dir minting.

This is not a corpus runner and not a CI gate. It matches testing.md §4.

## What this is not

- Not `tests/batch.ps1` / `tests/parallel.ps1` (test harness; TeXdig not a framework lane).
- Not pointing `Get-TeXdigBatchJob` at aipithicus (still bound to `src/TeXdig/run-census.ps1`).
- Not writing gauntlet artifacts into aipithicus or `D:\aghado01\test-runs`.
- Not inventing the new census store list in Codex. Worker owns files under `OutDirectory`.

## Tests (Codex)

- Adapter unit: discovers gauntlet-shaped fixture (`tests/fixtures/texdig/mini_article`), rejects `RunDirectory` outside Codex artifacts, rejects missing `EngineRoot`/`Worker`, emits `CODEX_TEMP` + projected TEMP, creates no directories.
- Thinness: export list includes `Get-TeXdigGauntletJob`; planner still cannot call `Invoke-BatchPlan` / `New-Item`.
- Optional focused live job later, behind engine-present skip: one mini_article through the aipithicus worker. Not required for adapter landing if the worker is still a stub that writes a receipt and exits 0.

## Sequence

1. Codex: `Get-TeXdigGauntletJob` + tests against mini_article + a stub worker path in the test fixture.
2. aipithicus: caller script + worker stub that records article path and `OutDirectory` (proves the hop).
3. Worker grows with the engine CLI; adapter parameters stay frozen.

## Docs

- Codex `src/batch-adapters/README.md`: new section, ownership table, mint path `artifacts/texdig/{stamp}/gauntlet`.
- aipithicus `docs/testing.md` §4: one paragraph pointing at `scripts/codex-gauntlet.ps1` and Codex as the downstream app.
