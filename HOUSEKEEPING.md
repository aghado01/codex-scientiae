# Housekeeping — corpus health & convention parity

A living register of cross-cutting maintenance: corpus-wide defects, convention drift between the three
pillars, and content debt the membrane must re-ingest. Per-deliverable quality lives in
[CHECKLIST.md](CHECKLIST.md); on-disk layout rules in [STANDARDS.md](STANDARDS.md) §8.

**Auto-detectable health is a command, not a manual sweep:**

```pwsh
pwsh -File src/corpus-audit.ps1            # human report (HARD / ADVISORY tiers)
pwsh -File src/corpus-audit.ps1 -Json      # machine-readable
pwsh -File tests/run.ps1 -Path tests/corpus-health.Tests.ps1   # regression gate
```

`src/corpus-audit.ps1` is read-only; it walks the promoted `.md` bodies under `compendia/ codices/
corpora/`. `tests/corpus-health.Tests.ps1` pins the HARD + quality invariants so a regression fails CI.

---

## 1. Health snapshot — 2026-06-23

| tier | class | count | note |
|---|---|---|---|
| HARD | `FILL_ME_IN` | **0** | clean; also gated by `publish.ps1` |
| HARD | U+FFFD | **0** | clean |
| HARD | UTF-8 BOM | **0** | clean (5 stripped this session) |
| ADVISORY | literal ligatures | **0** | normalized (3182 fixed) |
| ADVISORY | mangled URL seps | **0** | normalized (219 fixed) |
| ADVISORY | broken image links | **634** | the link↔storage drift — see §2/§3 (M1) |
| ADVISORY | broken md/nav links | **18** | codices only: `Grimmett2006/SubjectIndex.md` ×16, `Bishop`/`McLachlan` `CONTENTS.md` ×1 — see §3 (M4). `COMPENDIA.md` now clean. |
| ADVISORY | single-column tables | **2** | `ph/KGW2026.md`, `mapper/GLL2026.md` — verify (destroyed table vs legit 1-col) |
| ADVISORY | suspected `?`-mojibake | **0** | clean (URL `?id=` excluded) |

## 2. Convention parity — principle & decisions

The forest grew locality-by-locality and the three pillars diverged. Target is **parity by unit-type**,
harmonized on the cross-cutting dimensions — *not* uniformity for its own sake (a monograph's single
bibliography legitimately differs from a paper's sidecar).

| dimension | **codices** (monograph) | **compendia** (papers) | **corpora** (papers) | parity target |
|---|---|---|---|---|
| pillar nav | `CODICES.md` | `COMPENDIA.md` | `CORPORA.md` | keep (shallow topic/unit index) |
| sub-index file | `CONTENTS.md` | `_CONTENTS.md` | `_CONTENTS.md` | **`_CONTENTS.md` everywhere** |
| body file | `Chapters/ChNN.Name.md` | `{slug}.md` | `{slug}.md` | per unit-type (ok) |
| image dir | `Images/` (caps) | `images/` | `images/` | **lowercase `images/`** |
| image sub-layout | `Chapters/`+`Extra/`+flat | `{slug}/` | `{slug}_images/` | **papers → `images/{slug}/`** |
| in-body img links | `../Images/…` (broken) | flat `{slug}/…` (broken) | `{slug}_images/…` (broken) | resolve to target |
| references | `References.md` (1/book) | `references/{slug}.md` | `References/{slug}_references.md` | papers → `references/{slug}.md`; books keep 1/book |

**Decisions locked 2026-06-23:** sub-index = `_CONTENTS.md` everywhere · papers unify on `images/{slug}/`
+ lowercase `images/` all pillars · regenerate `COMPENDIA.md` now, defer migrations.

## 3. Open migrations — deferred (decisions made, execution pending)

Sequence them *after* the target convention so links are rewritten once, not twice.

- **M1 — broken image links (634).** Rewrite each pillar's in-body links to the target storage. Mechanism
  differs per pillar: compendia `{slug}/…`→`images/{slug}/…`; corpora `{slug}_images/…`→`images/{slug}/…`
  (paired with the dir migration in M2); codices `../Images/…`→`../images/…` after M3. The membrane's
  `Convert-ImageLinks` (`publish.ps1`) already does the compendia flat→`images/` rewrite — reuse it.
- **M2 — corpora → paper convention.** `images/{slug}_images/` → `images/{slug}/`; references
  `References/{slug}_references.md` → `references/{slug}.md`. Update `_CONTENTS.md` links.
- **M3 — codices image dir.** `Images/` → `images/` (case-only rename — stage via a temp name so git
  records it on case-insensitive Windows); reconcile mixed `FigureN.N.png` vs `imageFileN.png` naming.
- **M4 — codices sub-index rename + nav repair.** `CONTENTS.md` → `_CONTENTS.md` in the 3 books; fix the
  `CODICES.md` links. Also repair the 18 broken `.md` links the auditor flags (`Grimmett2006/SubjectIndex.md`
  ×16 — a subject index whose targets no longer resolve; `Bishop`/`McLachlan` `CONTENTS.md` ×1 each).
- **M5 — re-run the auditor** after each migration; `broken_image_link` should trend to 0.

## 4. Content re-extraction debt — membrane lane (deferred, "don't reingest right now")

Genuinely lost from the markdown; needs the membrane / re-extraction, not a text fix.

- **`compendia/statistics/TKH2022.md`** — broken eqs (5/6/8), inline-math `?`-for-paren collapse, Table 1
  data lost (chunks kept only headers + two stray `0.12`).
- **`compendia/ph-applied/GVPB2025.md`** — figure-debris contamination; Tables 1/2/3 reduced to single cells.
- **`compendia/ph/DS2026.md`** — benchmark tables destroyed; figure debris.
- **`compendia/ph/SIFTS2013.md`** — residual math grime (escaped `$G,_$`, fused inline math); membrane math pass.

## 5. Landed this session — 2026-06-23

- Ligatures (3182), mangled URL separators (219), 5 UTF-8 BOMs → normalized to 0 (one UTF-8-no-BOM pass,
  66 files, balanced diff). SMP math verified intact.
- `TKH2022.md` prose recovery: `?`-mojibake + U+FFFD ("Köster") + a duplicated corrupted abstract paragraph.
- `COMPENDIA.md` regenerated (was stale — listed pre-reorg topics with dead `intersections/…` links).
- Added `src/corpus-audit.ps1` (auditor) + `tests/corpus-health.Tests.ps1` (regression gate).

## 6. Tooling

- `src/corpus-audit.ps1` — read-only published-corpus auditor; HARD (publish holes / encoding) vs
  ADVISORY (quality / migration debt) tiers; ordinal-regex + UTF-8-no-BOM throughout.
- `tests/corpus-health.Tests.ps1` — pins HARD + ligature/URL invariants at zero.
- `src/publish.ps1` — `$PubDefectSentinels` refuses `FILL_ME_IN` / U+FFFD at publish time.
