# Codepoint-collapse follow-up report (items 1–4)

Continuation of the surrogate/encoding hardening pass. The prior session handled stdio UTF-8 pinning,
the `Get-Preview` helper at the seven fixed-N preview `Substring` sites, and `-Root` derivation — those
were NOT touched here. Verified: `pwsh -NoProfile -Command ". ./src/preprocess.ps1; …"` dot-sources the
full chain + md-cleanup/finalize/restructure cleanly after all edits.

---

## Item 1 — repair.ps1 `$onset` boundary

**Finding: already surrogate-safe by construction. No code change to logic; documented in place.**

`$onset` flows from `Get-CorruptionOnset` (repair.ps1:35–49) into `$content.Substring(0,$onset)` /
`$content.Substring($onset)` (repair.ps1:75, 98, 102). It is NEVER computed arithmetically. It is one of:
- `$content.IndexOf('\intertext')` — offset of the ASCII literal `\`, a single code unit; or
- `[regex]::Match($content,'(?:\b\w\s){5,}').Index` — the regex match start, which begins at a `\w` char.

A lone surrogate code unit has Unicode category **Cs**, matched by neither `\` nor `\w` (`\w` =
`[\p{L}\p{Mn}\p{Nd}\p{Pc}]`, excludes Cs). So `$onset` always lands on the **first code unit of a
non-surrogate (BMP) character** — a valid UTF-16 boundary — and the head/tail split can never bisect an
SMP surrogate pair (e.g. 𝔼 U+1D53C = D835 DD3C). The `$onset-1` predecessor likewise cannot be a high
surrogate, since `$onset` itself is not a low surrogate.

**Change:** added a `SURROGATE-SAFE BY CONSTRUCTION` doc block above `Get-CorruptionOnset` — **repair.ps1:36–43**.

**Deliberately left alone:** no defensive clamp added — it would be unreachable dead code given the proof
above, and the task prescribes "document safe" for the `.Index`/`IndexOf` case.

**Residual risk:** only if a future edit makes `$onset` arithmetic (e.g. `$onset += k`). The doc block warns
against that. The other length spans in the same block — `$head.Length / $content.Length` (repair.ps1:74,
a ratio: the 2×-SMP factor cancels) and `$content.Length - $onset` (repair.ps1:91,97, code-unit spans that
MUST stay code-unit to match the `Substring` offsets) — are correctly code-unit and left as-is.

---

## Item 2 — md-cleanup.ps1 PUA sentinel collision

**Finding: `[char]0xE000` as mask sentinel collides with real PUA content** (this corpus treats PUA as
semantic typesetter signal per PROCEDURE/WORKFLOW). A real `U+E000<digits>U+E000` run in the body would be
matched by the restore regex `U+E000(\d+)U+E000` and replaced with `$mdStore[wrongIndex]` → corruption or
index-out-of-range.

**Fix (both belt + suspenders):** replaced the single PUA char with a **GUID-nonced multi-char ASCII marker**
`RMASK_<32 hex>_`, **asserted absent** from the source before use (regenerate-on-collision loop).
- `${nonce}` braces are required — `"RMASK_$nonce_"` would bind the variable `$nonce_` (underscore is a
  legal PS identifier char). Trailing `_` keeps the `(\d+)` index unambiguous (marker can't end mid-digit).
- Marker has no whitespace / ligature / pipe chars, so the ligature + inline-wrap line passes treat it as a
  single opaque prose token (same invariant the old single-char sentinel relied on).
- Restore regex is now `[regex]::Escape($marker)+'(\d+)'+[regex]::Escape($marker)`.

**Changes:**
- **md-cleanup.ps1:84–92** — marker derivation + absent-assertion + `$protect` placeholder.
- **md-cleanup.ps1:100** — inline-math closure placeholder uses `$marker`.
- **md-cleanup.ps1:128–132** — restore loop: escaped `$restoreRx`, `IndexOf($marker)` guard.

**Verified:** round-trip test on a doc containing `…PUA hint <U+E000>7<U+E000>…`, a fenced block, inline
math, and an SMP glyph → PUA hint survives verbatim, fenced code intact, no `RMASK_` leak, `changed=False`
(the internal mask/restore cycle is a no-op on this input, which is the pass condition — the old sentinel
would have mutated the PUA run).

**Residual risk:** effectively nil (GUID nonce + explicit absent-assert). The marker is ASCII-visible if a
crash ever left it un-restored, which is easier to diagnose than an invisible PUA char.

---

## Item 3 — provider → .NET file-I/O sweep (content read/write only)

Standardized all **content** reads/writes onto `[System.IO.File]::*` with explicit
`[System.Text.UTF8Encoding]::new($false)` (no-BOM). Left every path cmdlet (`Test-Path`, `New-Item`,
`Split-Path`, `Join-Path`, `Get-Item`, `Get-ChildItem`, `Remove-Item`, `Get-FileHash`) untouched, per scope.

**Reads converted (`Get-Content -Raw` → `ReadAllText(path, UTF8NoBom)`):**
- project-ir.ps1:70 (raw external IR JSON — now BOM-tolerant decode)
- jsonl.ps1:112 (inventory, in Write-JsonlStage), jsonl.ps1:203 (Get-Inventory)
- serving.ps1:62 (leases), :128 (proposal overlay), :182 (edit base), :215 (apply scan)
- finalize.ps1:125, :126 (body/refs for Get-FinalReview)

**Whole-file writes converted (`… | Set-Content -Encoding utf8` → `WriteAllText`):**
- jsonl.ps1:105 (.sig), jsonl.ps1:119 (inventory)
- serving.ps1:67 (leases), :160 (proposal), :196 (proposal)
- finalize.ps1:90, :91 (body/refs; `$utf8` local at finalize.ps1:89)

**Appends converted (`… | Add-Content -Encoding utf8` → `AppendAllText(... + "\`n", …)`):**
- jsonl.ps1:189 (ledger jsonl), serving.ps1:410 (review-requests jsonl), restructure.ps1:48 (structure-audit jsonl)

**Deliberate behavior changes (all in service of "remove BOM/CRLF/formatter surprises"):**
- `Set-Content`/`Add-Content` appended a **platform CRLF**; the .NET writes emit **LF only**. For the three
  JSONL appends I add an explicit `"\`n"` so line-orientation is preserved; readers are `ReadLines` (splits
  on `\n`, tolerates a stray trailing `\r` on any pre-existing CRLF lines), so mixed old/new files still parse.
- finalize body/refs now end in a single `\n` (was a trailing `\r\n` from Set-Content) — matches STANDARDS §4.
- Whole-file JSON sidecars (sig/inventory/leases/proposals) lose the spurious trailing newline Set-Content
  added; irrelevant to `ConvertFrom-Json`.

**`.jidx` consistency — verified, left byte-based:** the JSONL stage files (`*.chunks.jsonl`/`*.nodes.jsonl`)
are written ONLY by `Write-JsonlStage` via `StreamWriter` + `UTF8Encoding($false)` (jsonl.ps1:87) — unchanged.
`JsonlIndex::Build` scans raw bytes for `0x0A` (jsonl.ps1:25–32) and `Read-JsonlRecord` seeks by byte offset
then decodes with `StreamReader` + `UTF8Encoding($false)` (jsonl.ps1:135) — already UTF-8 at the seek target,
unchanged. None of the files I converted are `.jidx`-indexed, so there is no offset-vs-decode drift risk.

**Deliberately left alone:**
- md-cleanup.ps1:79/136/168 — already `[System.IO.File]::ReadAllText/WriteAllText`. `File.WriteAllText`
  without an encoding arg is **UTF-8 no-BOM by .NET default**, so these are already compliant; not in cmdlet
  scope. (Optional: make the encoding explicit for uniformity — low value, skipped to avoid scope creep.)
- All `[System.IO.File]::ReadLines(...)` call sites (collapse/fidelity/zones/sections/normalize/repair/headings/
  serving/jsonl) — already .NET; `ReadLines` BOM-detects and defaults to UTF-8.
- serving.ps1:270, :308 — `([string]…).Length` used as the dispatch **byte budget** proxy: raw-size measure,
  left per item-4 rubric (see below).

**Residual risk:** none functional. Cosmetic only: md-cleanup relies on the implicit no-BOM default rather
than an explicit encoding — flagged above if the requesting session wants full uniformity.

---

## Item 4 — rune-aware length heuristics

Converted the three heuristics whose `.Length` semantically means **glyph/codepoint count** (where SMP math
glyphs = 2 UTF-16 units each would otherwise over-count and mis-grade) to
`[System.Globalization.StringInfo]::new(s).LengthInTextElements` (text-element count; for these
single-codepoint math glyphs, text-elements == codepoints == intended glyph count; robust, no ref-struct
enumeration like `EnumerateRunes()` needs).

**Changed:**
- **normalize.ps1:143→145** — `Get-FurnitureKind` "≤4-char crumb" gate. SMP-only runs of 3–4 glyphs
  (6–8 units) previously **escaped** the gate; now correctly measured. (Behavioral note: such short SMP runs
  may now newly tag as `crumb` furniture — this is the *intended* "≤4 glyphs" semantics; the tag is reversible
  and audited, and 2-glyph SMP already tagged under the old code.)
- **headings.ps1:37→40** — `Get-BodyTypography` length-weighted modal font/size. Documented intent is "weight
  by amount of body text so a few large display lines can't outvote the mass"; code units over-weight SMP
  display lines 2×/glyph, *against* that intent. Text-element count makes the vote glyph-fair. (Soft
  proportional weight — low blast radius.)
- **headings.ps1:77→82** — `Invoke-HeadingRecovery` "short heading" `$MaxLen` (180) gate. A math-bearing
  heading could exceed 180 *code units* while under 180 glyphs and be wrongly rejected; now glyph-accurate.

**Verified:** `StringInfo` reads `𝔼𝔽𝔾` as 3 text-elements vs 6 code units.

**Deliberately left alone (raw-size / index-consistent / count — NOT glyph heuristics):**
- normalize.ps1:80 (`$tok.Length -eq 1`) and normalize.ps1:92 (`$tok.Length -ne 1`) — the single-glyph token
  classifiers in `Test-MathGlyphToken` / `Test-StrongMath`. These sit in the inline-math **wrap** path; a lone
  SMP letter (len 2) currently fails `-eq 1`. **NOT changed** — two reasons: (1) blast radius — they reshape
  token-run boundaries across the *whole corpus's serialized math*, larger than the grading heuristics and
  warranting your explicit sign-off + a sample-doc diff; (2) mostly inert anyway — math-alphanumerics
  (U+1D400+) are Unicode category Lu/Ll, not `\p{Sm}`/Greek, so `Test-StrongMath` returns false for them
  regardless, and a pure math-alphanumeric run won't wrap without an accompanying strong (BMP) symbol.
  **Recommendation:** if you want SMP letters absorbed into adjacent math runs (e.g. `π 𝔼 ≥ c` →
  `$\pi 𝔼 \geq c$` instead of breaking at 𝔼), make `Test-MathGlyphToken`'s length-1 test rune-aware — but
  diff sample outputs first.
- repair.ps1:66 (`$content.Length -gt 0`, non-empty guard), repair.ps1:74 (head/total **ratio**),
  repair.ps1:91/97 (code-unit spans tied to `Substring` offsets).
- serving.ps1:270/308 (dispatch **byte-budget** proxy), jsonl.ps1:27–29/116 (byte scan / file byte length),
  latex.ps1:19 (`$n=$s.Length` — ASCII-delimiter balance scanner loop bound, correct over code units),
  md-cleanup.ps1:97/170 (`$...$`-delimiter strip arithmetic), serving.ps1:191/192, restructure.ps1:83
  (find/replace edit offsets, code-unit-consistent with `IndexOf`).
- md-cleanup.ps1:176 `if ($span.Length -gt 72) {$span.Substring(0,72)}` — a human punch-list **preview**
  truncation that could surrogate-split for display. Out of item-4 scope (a grading heuristic), and a preview
  site → belongs to the prior session's `Get-Preview` treatment. **Recommendation:** route it through
  `Get-Preview` alongside the other preview sites.

**Residual risk:** the crumb-gate (143) and weight (37) changes shift behavior slightly on SMP-heavy inputs by
design; both are reversible/auditable furniture tags and soft weights, not destructive. Worth a spot-check on
one math-heavy sample doc during the next preprocess run.

---

## Net files touched

**9 source files:** `src/repair.ps1` (doc only), `src/md-cleanup.ps1`, `src/jsonl.ps1`, `src/serving.ps1`,
`src/finalize.ps1`, `src/project-ir.ps1`, `src/restructure.ps1`, `src/normalize.ps1`, `src/headings.ps1`
— plus the report at `.claude/codepoint-followup-report.md`.
