# Shared PowerShell primitives — extraction design

Date 2026-08-08. Spec for the first extraction pass. Status: **approved design, pending spec review**.

## 1. Context and goal

`latex-ingest` is under active development, and reasoning over its evolving process is harder because
generic, reusable capabilities are interleaved with the application-specific layer. This pass lifts the
generic primitives out into `src/shared` so both sides become legible and examinable on their own
merits — the generic files as candidate reusable utilities, the latex layer as pure domain logic.

This is a **behavior-preserving lift**, not a redesign. The application layer's patterns and sequencing
are the author's active reasoning space and are left semantically untouched; the only change to them is
that code which was never theirs to own is removed. Extracted primitives must be behavior-identical to
what they replace, pinned by tests before any call site is repointed.

## 2. Scope

**In.** Extract three groups of primitives into `src/shared` and retire the duplicate copies onto them:

- Group 1 — path/name safety: portable-leaf validation, reparse-point path safety, bounded file read.
- Group 2 — content identity: SHA-256 → `sha256:<hex>`, and identity-format validation.
- Group 3 — tolerant strict-JSONL reading: the authored-input line reader plus typed field extractors.

Three sites collapse onto the new primitives: `src/latex-ingest/latex-patch.ps1`,
`src/latex-ingest/latex-source.ps1` (today's owner of the "central" reparse check), and
`src/adapters/private/latex-inventory-row.ps1`.

**Out (non-goals).**

- No reconciliation with the Python `article.schema.json#/$defs/portableLeaf` beyond preserving the
  existing "aligned" comment. No new PowerShell↔Python contract.
- The group-4 bounded-regex helpers (`New-LatexPatchRegex`, `Get-LatexPatchRegexMatchCount`) stay in
  `latex-patch.ps1` beside their only consumers, the appliers.
- No refactor of the latex application layer beyond removing the lifted functions and repointing calls.
- No new module/manifest. Organization is themed loose `.ps1` files (chosen approach A), matching the
  existing `md-anchor.ps1` / `md-sentinels.ps1` / `crawl.ps1` precedent.

## 3. The three shared files

Each file is pure function definitions — no side effects, safe to dot-source more than once.

### `src/shared/portable-path.ps1`

- `Test-PortableLeaf -Value <string>` → `[bool]`. True when `Value` is one portable path segment:
  nonempty; not `.` or `..`; no trailing space or dot; no `<>:"/\|?*` or U+0000–U+001F; and no
  case-insensitive reserved basename `CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9]` before a dot or end.
  Canonical form: the single `CultureInvariant` regex from `latex-inventory-row.ps1:25` (declarative,
  visibly aligned with the schema's `portableLeaf`). The imperative char-walk in `latex-patch.ps1:13`
  is proven equivalent (§5) and is the fallback form if review prefers readability over compactness.
- `Test-PathHasReparsePoint -Path <string>` → `[bool]`. True when any existing component of the
  resolved path carries `FileAttributes.ReparsePoint` (symlink/junction). Canonical form: the
  segment-walk shared verbatim by all three current copies.

### `src/shared/file-bytes.ps1`

- `Read-BoundedFileBytes -Path <string> -MaxBytes <long>` → `[byte[]]`. Rejects input larger than
  `MaxBytes` before and during the read; guards against length change, grow, and shrink between the
  stat and the bounded read (the exact TOCTOU discipline of `latex-patch.ps1:75`). `MaxBytes` becomes
  a caller parameter rather than a module constant, since consumers pick their own ceiling (latex
  patch: 1 MiB).
- `Get-ContentIdentity -Bytes <byte[]>` → `sha256:` + 64 lowercase hex.
- `Test-ContentIdentityFormat -Value <string>` → `[bool]`. Matches `^sha256:[0-9a-f]{64}$`. Retires the
  inline `-cnotmatch '^sha256:[0-9a-f]{64}$'` copies in `latex-patch.ps1:126` and
  `adapters/workers/invoke-latex-ingest.ps1:18`.

### `src/shared/authored-jsonl.ps1`

The domain-free reading layer (§4).

- `Read-AuthoredJsonl -Path <string> -MaxBytes <long> [-ExpectedIdentity <string>]` → an object with
  `path`, `identity` (`absent` or `sha256:<hex>`), and `records`, where each record is
  `{ line = <1-based int>, fields = <ordinal Dictionary[string, JsonElement]> }`. `Path` is an
  already-resolved literal (the caller constructs it; the reader does not build names). It performs:
  reparse-point guard on the path → **absent file ⇒ `identity = 'absent'`, empty `records`** (optional
  authored input is a first-class outcome, not an error) → bounded read (`Read-BoundedFileBytes`) →
  `Get-ContentIdentity` → **optional `-ExpectedIdentity` drift assertion** (format-checked via
  `Test-ContentIdentityFormat`, `absent`/`sha256` compared, throw on mismatch) → reparse-point guard
  again after the read (the TOCTOU double-check) → UTF-8-no-BOM enforcement and bare-CR rejection → line
  split (LF or CRLF, optional final newline) → skip blank / full-line `#` / `//` lines → parse each
  remaining line as exactly one strict JSON **object** → reject duplicate or case-colliding keys. It
  applies **no** field vocabulary; the caller validates records. Reparse-refusal is the safe default; a
  future `-AllowReparsePoint` switch is deferred (YAGNI).
- `Get-JsonRequiredString -Fields <dict> -Name <string> -Display <string>` → `[string]`; throws with
  `Display` context if absent or not a JSON string.
- `Get-JsonOptionalString -Fields -Name -Display` → `[string]` (`''` when absent; type-checked when
  present).
- `Get-JsonOptionalPositiveInteger -Fields -Name -Display` → `[int]` or `$null` (renamed from
  `Get-LatexPatchOptionalGuard`; positive-Int32 validation preserved).

## 4. The reader seam

`Read-AuthoredJsonl` owns everything up to and including "here are validated JSON objects, one per
authored line, with typed accessors." `latex-patch.ps1` keeps everything downstream of that: the `op`
enum, per-`op` allowed-field sets, the `\name` control-word rule, duplicate-`define_macro` detection,
record construction, `Assert-LatexPatchRuntimeRecords`, and the appliers. The seam is the line between
"reusable authored-input reading" and "latex patch semantics." A future authored-config or curation
format reuses the reader and supplies its own record validation.

## 5. Duplicate reconciliation findings

- **Reparse check** — `latex-source.ps1:31`, `latex-patch.ps1:53` (fallback body), and
  `latex-inventory-row.ps1:32` are identical in logic. Lift is behavior-preserving trivially.
- **Portable-leaf** — `latex-patch.ps1:13` (imperative) and `latex-inventory-row.ps1:21` (regex) are
  semantically equivalent across reserved-name, dot/dotdot, trailing space/dot, control-char, invalid-
  char, and empty cases. Either is a faithful canonical; the regex is chosen (§3).
- **Bounded read + hash** — `latex-patch.ps1:75` loads ≤ cap then hashes; `latex-inventory-row.ps1`
  hashes via a bounded incremental read. For the shared 1 MiB ceiling, load-then-`Get-ContentIdentity`
  is equivalent. Implementation must confirm the adapter's drift-refusal and size-cap tests stay green
  after consolidation (they are the witnesses).

## 6. Consumer rewiring

- **New files** dot-sourced by relative path at the top of each consumer: `../shared/…` from
  `src/latex-ingest/*`, `../../shared/…` from `src/adapters/private/*`. Shared files are idempotent.
- **`latex-patch.ps1`** — remove `Test-LatexPatchPortableLeaf`, `Test-LatexPatchPathHasReparsePoint`,
  `Read-LatexPatchBoundedBytes`, `Get-LatexPatchRawIdentity`, `Get-LatexPatchItemOrNull`,
  `Assert-LatexPatchIdentity`, the line reader, and the three field extractors; dot-source the three
  shared files. `Get-LatexPatchPath` calls `Test-PortableLeaf`. `Read-LatexPatchSet` becomes: build the
  path (`Get-LatexPatchPath`) → `Read-AuthoredJsonl -ExpectedIdentity` (which subsumes the absent,
  reparse, bounded-read, and identity-drift handling that lived inline) → map each returned record
  through the `op` vocabulary. Identity-drift unit coverage moves to `authored-jsonl.Tests.ps1`; the
  end-to-end drift cases in `latex-patch.Tests.ps1` remain.
- **`latex-source.ps1`** — remove `Test-LatexPathHasReparsePoint`; dot-source `portable-path.ps1`;
  internal callers (`Assert-LatexSourceTreeHasNoReparsePoint` and the deposit paths) call
  `Test-PathHasReparsePoint`. (The tree-recursive `Get-ChildItem -Attributes ReparsePoint` scans are a
  different check and stay.)
- **`latex-inventory-row.ps1`** — remove `Test-LatexBatchPortableLeaf`,
  `Test-LatexBatchPathHasReparsePoint`, and its bounded-hash read; dot-source `portable-path.ps1` +
  `file-bytes.ps1`; repoint (`Resolve-LatexBatchInventoryRoot`, the patch-identity planner, etc.).
- **Deposit callers** — `src/latex-ingest/source-deposit.ps1` and
  `src/logistics/latex-source-deposit.ps1` repoint every `Test-LatexPathHasReparsePoint` call to
  `Test-PathHasReparsePoint`.
- **Clean rename, no `Latex`-named alias** — serves the legibility goal. Fallback if the diff proves
  too wide: a one-line alias in the deposit lane.

### 6a. The one real risk — the transported function

`src/logistics/latex-source-deposit.ps1:265` captures `${function:Test-LatexPathHasReparsePoint}` to
carry the function into a child job/process. Renaming requires updating that capture **and** ensuring
the renamed function is defined in the child context — either transport it the same way under its new
name, or dot-source `portable-path.ps1` in the child bootstrap. This is the highest-care edit; it needs
its own test that the deposit still refuses a reparse-point path when run through the batch/child path,
not only in-process.

## 7. Testing

- New focused Pester containers, one per shared file, pinning each primitive independently — the
  examine-on-merits surface: `tests/shared/portable-path.Tests.ps1`, `file-bytes.Tests.ps1`,
  `authored-jsonl.Tests.ps1`. Cover reserved names, dot/trailing/char edges; size cap + grow/shrink/
  length-drift; UTF-8-no-BOM, bare-CR, blank/comment tolerance, one-object-per-line, dup/case-colliding
  keys; identity format.
- Behavior is first pinned on the **new** primitives, then call sites are repointed, then the existing
  suites act as the no-regression net: `latex-patch` (22), `latex-batch` (10), and the latex-source /
  deposit containers must all stay green. The §6a child-path reparse refusal gets an explicit case.
- The live file-symlink-swap branch remains Administrator-gated (skips without rights); note where that
  limits reparse coverage on an unprivileged host.

## 8. Risks and mitigations

- **Rename footprint** across the deposit lane — mechanical but wide; enumerate every call site in the
  implementation plan and repoint atomically per file.
- **Transported function (§6a)** — the one place a rename can silently break a child-process safety
  check; covered by a dedicated test.
- **Dot-source order** — mitigated by making shared files pure and idempotent, and by having each
  consumer source what it needs at its top.
- **Adapter hash consolidation** — confirmed only when the adapter's drift/size tests pass post-change.

## 9. File inventory

New: `src/shared/{portable-path,file-bytes,authored-jsonl}.ps1`;
`tests/shared/{portable-path,file-bytes,authored-jsonl}.Tests.ps1`.
Modified: `src/latex-ingest/{latex-patch,latex-source,source-deposit}.ps1`;
`src/adapters/private/latex-inventory-row.ps1`; `src/logistics/latex-source-deposit.ps1`;
`src/adapters/workers/invoke-latex-ingest.ps1` (identity-format call). Docs: a `ledger.md` entry under
`issues/shared-primitives/planning/` on landing.
