# Symbol Registry — draft

**Status:** draft, 2026-07-26. *(non-normative until reviewed; flagged entries need adjudication before promotion)*

**Charter.** The production registry serves **one job: canonicalization of variable lexical tokens in LaTeX source** — the spec's §4.4 surjection store (`{\ge, \geq, \geqslant, ≥} → \geq`, `\operatorname → \mathrm`, `\R → \mathbb{R}`). That is the future work this registry feeds.

Two neighboring rule populations were audited here because they share `src/pdf-converter/stores/symbol-map.jsonl`, but **neither is registry content**:

- **Glyph→lexical mappings** (`‖`→`\|`, `Ω`→`\Omega`, CMSY `k`) — real and retained, but they are the **PDF conversion lane's** machinery (pdfdig), resolving extracted glyphs into lexical tokens *before* those tokens ever reach canonicalization. Different store, different converter, different failure modes. The register constrains their *output* (targets must be canonical forms); it does not own the rules.
- **Ligature expansions** (`ﬁ`→`fi`) — Docling-era prose repair with **no analogue in the future work at all**: LaTeX source has no ligature hallucinations. Excluded entirely; see FLAG-7.

The store audit below (§2–§3) stands as findings about the legacy artifact and as intake for the PDF lane's future stores — it is *jurisdiction-tagged*, not registry content. Growth of the registry proper follows the spec's §9 protocol: entries earn their place by provenance from real LaTeX sources, closed classes get enumerated, flagged entries get adjudicated.

---

## 1. Rule taxonomy

The store currently flattens three different *kinds* of rule into one shape. The registry types them, because they have different validity conditions and different failure modes:

| Kind | What it asserts | Example | Fails when |
|---|---|---|---|
| **artifact-correction** | the delivered codepoint is not what was authored (broken `ToUnicode`, font-subset damage); restores identity | CMSY `k` → `‖` | applied outside its font scope |
| **register-spelling** | the identity is known; this is how the register spells it (spec §5: glyph → control sequence) | `‖` → `\|` | the spelling choice was wrong (see FLAG-1) |
| **prose-normalization** | typographic presentation form → plain text | `ﬁ` → `fi` | never (closed Unicode class) |

An artifact-correction and a register-spelling **compose**: CMSY `k` → (identity `‖`) → (spelling `\|`). The store's first entry fuses both steps into one line, which works but hides the identity fact the registry should preserve.

## 2. The registry

### 2.1 Norm / delimiter class — scope: math

| Glyph | Codepoint | Identity | Register form | Kind | Font scope | Provenance | Status |
|---|---|---|---|---|---|---|---|
| `k` | U+006B | `‖` U+2016 | `\|` | artifact-correction ∘ spelling | `cm`/CMSY only | pdfpig-ir-recon 2026-06 (`‖u‖`→`kuk`) | active |
| `‖` | U+2016 | itself | `\|` | register-spelling | any | render-check 2508.11646 | active |
| — | **U+2225 `∥`** | — | `\|` (or `\parallel` — see FLAG-2) | register-spelling | any | **GAP** | **pending** |

### 2.2 Operator class — scope: math

| Glyph | Codepoint | Identity | Register form | Kind | Provenance | Status |
|---|---|---|---|---|---|---|
| `◦` | U+25E6 white bullet | `∘` U+2218 ring operator | `\circ` | artifact-correction ∘ spelling | render-check 2508.11646 (composition) | active |
| — | **U+2218 `∘`** | itself | `\circ` | register-spelling | **GAP** | **pending** |
| `•` | U+2022 bullet | **ambiguous** | `\cdot` | register-spelling | render-check 2508.11646 | **FLAGGED — see FLAG-1** |

### 2.3 Greek class — scope: math

| Glyph | Codepoint | Register form | Provenance | Status |
|---|---|---|---|---|
| `Ω` | U+03A9 | `\Omega` | render-check 2508.11646 | active |
| *remaining Greek alphabet* | U+0391–U+03C9 + variants (`ϵ`,`ϑ`,`ϖ`,`ϱ`,`ς`,`ϕ`) | `\Alpha`…`\omega` per standard names; variants `\epsilon`/`\vartheta`/`\varpi`/`\varrho`/`\varsigma`/`\varphi` | **enumerable — see FLAG-3** | **pending enumeration** |

### 2.4 Ligature class — **EXCLUDED (see FLAG-7)**

Not tabulated. Docling-era prose repair (`ﬁ`→`fi`, U+FB00–FB06) with no analogue in LaTeX source and no role in the future work. The entries stay functional in the legacy store for as long as the membrane lane runs; they enter no future store of either lane by default. One caveat preserved for the PDF lane: PdfPig extraction *can* legitimately deliver ligature codepoints from a PDF's ToUnicode data, so if the class resurfaces there, it is pdfdig prose-side normalization — evidence-driven, per specimen, and still not registry content.

| Glyph | Codepoint | Replacement | Provenance | Status |
|---|---|---|---|---|
| `ﬀ` | U+FB00 | `ff` | corpus class (~1800) | active |
| `ﬁ` | U+FB01 | `fi` | corpus class | active |
| `ﬂ` | U+FB02 | `fl` | corpus class | active |
| `ﬃ` | U+FB03 | `ffi` | corpus class | active |
| `ﬄ` | U+FB04 | `ffl` | corpus class | active |
| `ﬅ` | **U+FB05** | `ft` (long s-t) | **GAP — see FLAG-4** | **pending** |
| `ﬆ` | U+FB06 | `st` | corpus class | active |

## 3. Audit flags

### FLAG-1 — `•` → `\cdot` is a semantic adjudication made unconditionally *(internally inconsistent)*

The spec's own rationale (Why-A, axis 2) names `·`/`•` as semantically overloaded — multiplication, composition, placeholder — resolvable only by context. This entry resolves it *unconditionally* to `\cdot`, which asserts "every bullet in math context is a product dot." But `f \bullet g` (category theory), `−\bullet−` (placeholder notation), and bold-dot operators are real and distinct; KaTeX has `\bullet` precisely for them. The identity-preserving mapping is `•` → `\bullet`; `\cdot` is a *guess* at authored intent, motivated by one paper.

**Recommendation:** remap to `\bullet` (identity-preserving, always safe), and let `\cdot` be a per-document adjudication where context supports it — or keep `\cdot` but demote the entry's font scope to the specimen that motivated it. Either way the current universal entry violates the store's own charter ("principled cues only") by encoding a semantic guess as a font-independent rule.

### FLAG-2 — the norm-delimiter homoglyph pair is half-covered *(gap, and a lurking decision)*

`‖` U+2016 (double vertical line) is mapped; `∥` U+2225 (parallel to) is not — and U+2225 is what many fonts' `ToUnicode` actually emits for the norm bars. Identical appearance, different codepoint: the exact homoglyph hazard Why-A/axis-1 catalogues. The gap means conformance currently depends on *which* invisible codepoint a PDF happened to deliver.

The lurking decision: U+2225 is also legitimately `\parallel` (the relation, `AB \parallel CD`). Delimiter-vs-relation is not decidable glyph-locally — it needs position evidence (paired vs infix). Options: map to `\|` and accept mis-spelling relations; map by adjudication; or record both target forms and let the classifier's position evidence pick. **Registry recommendation: the third** — it keeps the store principled and pushes the judgment to where the evidence is.

### FLAG-3 — Greek is a closed class; enumerate it, don't accrete it *(§9.3's predicted transition, arriving early)*

One Greek letter is mapped because one paper broke. The other ~48 (both cases + LaTeX variant forms) will each break a future render-check, one paper at a time, unless enumerated now. The spec's own convergence doctrine (§9.3) says sampling gives way to enumeration once a class is nameable and finite — **Greek is the first class to cross that line.** The enumeration is a fixed, well-known table (standard LaTeX names; capital forms that coincide with Latin letters — `\Alpha`, `\Beta` — need the KaTeX-support check since KaTeX omits some). Ligatures (FLAG-4) are the second such class.

This is worth doing as a deliberate act partly *for the precedent*: it exercises the accretion→enumeration transition the spec predicts, on the cheapest possible case.

### FLAG-4 — ligature class is one entry short of closed *(trivial gap)*

U+FB00–FB06 is a complete, closed Unicode range (Alphabetic Presentation Forms, Latin subset). The store has five of six Latin members; `ﬅ` U+FB05 (long s-t) is missing. One line closes the class permanently.

### FLAG-7 — the store mixes two jurisdictions *(concern mixing, root cause of several flags above)*

The early codex-membrane work bundled several concerns in one pass: **repairing predictable encoding failures** (ligature hallucinations from Docling), **mapping glyphs to lexical tokens**, **canonicalizing lexical tokens**, and possibly others not yet identified. `symbol-map.jsonl`, created ad hoc in that era, carries at least two of these jurisdictions side by side: math-register spelling (glyph → control sequence, governed by the spec) and prose text hygiene (ligature expansion). The ligature entries are not KaTeX, not math, and not this spec's jurisdiction — `ﬁ→fi` is a UTF-8 prose repair. The store's own README mislabels the ligature class as "canonical-register normalization," which is how the mixing propagates: an ad-hoc store became the de facto definition of what the register covers. Other membrane-era artifacts should be audited with the same expectation — the concern inventory above is a checklist, not a closed list.

**Disposition:** the *rules* are correct and stay; the *jurisdiction* splits. At the two-store migration (§4), prose-hygiene entries exit to their own store (e.g. `prose-normalization.jsonl`) governed by a manuscript-hygiene standard, and Store 2 becomes math-register-only. FLAG-4 (`ﬅ` U+FB05 gap) remains valid but transfers to the prose-hygiene ledger.

### FLAG-5 — the `unicode` field carries LaTeX, not Unicode *(schema drift)*

The store README defines `unicode` as "replacement text" and `katex` as "canonical KaTeX for math runs, optional" — but every math-scope entry puts the KaTeX control sequence **in the `unicode` field** (`"unicode": "\\|"`) and omits `katex`, while prose entries set `katex: null` explicitly. Consequences: the field name lies; the *identity* codepoint (what the glyph actually is) is recorded nowhere; and field presence is inconsistent across scopes. The mature schema (§4) separates identity from spelling. Until migration, treat `unicode` as "replacement in register form" and ignore the name.

### FLAG-6 — `font_pattern` is undocumented for this store *(schema drift, minor)*

The CMSY entry carries `font_pattern`, a field the README documents for `font-roles.jsonl` but not for `symbol-map.jsonl`. Either document it in the symbol-map schema or key artifact-corrections to `font_family` alone.

## 4. Proposed mature schema — two stores, two stages

Spec §4.4 sets the production shape: **identity resolution ∘ class projection** — two stores with clean validity conditions **and distinct owners**:

**Store 1 — glyph resolution** (font-conditional, runs first, **owned by the PDF lane**). Everything that turns extracted glyphs into lexical tokens: artifact corrections (CMSY `k` → `‖`, keyed by font scope) and glyph→lexical spellings (`‖` → `\|`, `Ω` → `\Omega`). The LaTeX lane touches this store only for the rare Unicode character authored directly in source (`≥` in a `unicode-math` document). Schema below.

**Store 2 — equivalence classes** (font-independent surjection, runs second, **the registry proper**). One entry per concept over *lexical tokens as they vary in LaTeX source*: `{\ge, \geq, \geqslant} → \geq`, `\operatorname → \mathrm`, `\R → \mathbb{R}`, `\dfrac → \frac`. Load-time invariants: canonical ∈ members; member sets pairwise disjoint; canonical parses under KaTeX. **Disjointness is the policy**: a form needing two classes is structurally inexpressible and lands in the adjudication tier instead — flags of that shape stop being judgment calls and become validation failures.

The two compose across lanes: pdfdig resolves glyphs to tokens (Store 1), and both lanes' token streams pass through the same canonicalization (Store 2) — one register target, per §0.1 of the spec.

Ligature expansion is **neither store** (FLAG-7): dead for the LaTeX lane, evidence-pending for the PDF lane, registry content never.

Store 1 entry shape, with identity and spelling separated (fixes FLAG-5, preserves what FLAG-1/FLAG-2 need):

```json
{
  "char": "k",
  "codepoint": "U+006B",
  "font_family": "cm",
  "font_pattern": "CMSY",
  "identity": "U+2016",
  "register_form": "\\|",
  "alt_forms": [],
  "scope": "math",
  "kind": "artifact-correction",
  "status": "active",
  "provenance": "pdfpig-ir-recon 2026-06 (the ‖u‖→kuk class)",
  "notes": "ToUnicode absent/wrong; identity is the double bar, spelled \\| per register"
}
```

- `identity` — the resolved codepoint (what was authored). Equal to `codepoint` for pure register-spelling entries.
- `register_form` — the canonical spelling per spec §5/§4.3.
- `alt_forms` — for FLAG-2-shaped cases: legitimate alternative targets, selected downstream by position/context evidence.
- `kind` — `artifact-correction` | `register-spelling` | `prose-normalization`.
- `status` — `active` | `flagged` | `pending`. Flagged entries still apply but are on the adjudication queue; pending entries are enumerated but unverified against KaTeX.

## 5. Adjudication queue

| Item | Action needed | Blocking? |
|---|---|---|
| FLAG-1 `•`→`\cdot` | decide: `\bullet` universal, or demote to specimen scope | no — but every conversion touching `•` inherits the guess until decided |
| FLAG-2 U+2225 | add entry; decide single-target vs `alt_forms` | no |
| FLAG-3 Greek | enumerate ~48 letters + variants; verify against KaTeX support table | no |
| FLAG-4 `ﬅ` | add one line | no |
| FLAG-5 schema | adopt §4 schema or rename field at next store touch | no — cosmetic until the registry drives the store |
| FLAG-6 `font_pattern` | document in store README | no |
| FLAG-7 jurisdiction split | move ligature entries to a prose-hygiene store at migration; correct the store README's "canonical-register" label | no — rules behave correctly today; only the labeling misleads |
