# Swarm Brief: Voroninski Corpus — Inline-Math Reconstruction to Promotion

**Audience:** a repair agent/swarm (antigravity / Copilot) with the `codex-membrane` MCP tools connected.
**Corpus:** `ingestion/corpora/voroninski/` — 15 papers (phase retrieval / SDP / convex optimization).
**Goal:** bring each paper to render-clean math, then `publish` into the compendium.

---

## 0. The one thing to internalize first

**The membrane grades these papers `faithful` with near-zero `flagged`, and that grade LIES about the math.**
The prose backbone is sound, but the inline math is pervasively *fragmented and under-marked* by the
extractor. The corruption gate only catches *structural* breakage (unbalanced delimiters, gibberish,
broken environments); it does **not** catch under-markup. The enrichment lane (`get_enrichables`) is
meant to, but its conservative threshold (`math_dirt < 2`, safe-wrap only) surfaces a handful of clean
tokens (`O(n)`, `min()`) and misses the shattered expressions entirely.

> **Therefore: do NOT drive this work off `flagged`/`enrichable` counts. You must READ each body prose
> chunk's `content` and reconstruct its inline math by hand.** The work-list is "every body prose chunk
> with math," not "the flagged set."

This was established by an end-to-end probe of `1611.03935v1` (graded `faithful`, 0 flagged, 8
enrichables) whose body chunks were nonetheless full of broken math. Examples below are verbatim from it.

---

## 1. The fragmentation pattern catalog (verbatim before → reconstructed after)

All examples are real, from `1611.03935v1` chunks 6/15/18/37 and `1602.04426v2` (the `Z 2` case).

| Class | Broken (as extracted) | Reconstructed |
|---|---|---|
| Blackboard sets / spaces | `x_{0} \in C n` , `a_{i} \in C n` , `S n - 1` , `over Z 2` | `x_0 \in \mathbb{C}^n` , `a_i \in \mathbb{C}^n` , `S^{n-1}` , `\mathbb{Z}_2` |
| `$` scattered mid-expression | `$\| a_{i}$ ,x $0 \|$` , `\| a_{i}$ ,$x_{0}$ \|\| $a_{i}$ ,x $1 \|$` | `$\lvert\langle a_i, x_0\rangle\rvert$` , `\lvert\langle a_i,x_0\rangle\rvert\,\lvert\langle a_i,x_1\rangle\rvert` |
| Flattened fraction+sum | `1 m m i =1 $a_{i} a ⊺ i$` | `$\frac{1}{m}\sum_{i=1}^{m} a_i a_i^{\intercal}$` |
| Lost norm bars | `0 . 6 x_{0} 2` , `x_{0} x ⊺ 1 - ˜ x_{0} ˜ x ⊺ 1 1` | `0.6\,\lVert x_0\rVert^2` , `\lVert x_0 x_1^{\intercal} - \tilde x_0 \tilde x_1^{\intercal}\rVert_1` |
| Misplaced accent macro | `(˜ $x_{0}$ , ˜ $x_{1}$ )` | `(\tilde x_0, \tilde x_1)` |
| Mangled glyphs | `ǫ` (epsilon) , `⊺` (transpose) , `∼` for distribution | `\epsilon` , `^{\intercal}` , `\sim` |
| Despaced sub/superscripts | `a ⊺ i` , `y 2 i` , `x 0` , `I n × n` , `c_{0} n` | `a_i^{\intercal}` , `y_i^2` , `x_0` , `I_{n\times n}` , `c_0 n` |
| Inner products | `\| a_{i}$ ,x $0 \|` | `\lvert\langle a_i, x_0\rangle\rvert` |

**Reconstruct from meaning, not surface.** `a_i a_i^\intercal` is a rank-one outer product; `\langle a_i,x_0\rangle`
is the measurement inner product; `\frac1m\sum_{i=1}^m` is the empirical mean. Use the surrounding prose to
deduce intent (per `CHECKLIST.md` §3 and `src/PROCEDURE.md`). **No lazy regex over raw text** — that is the
explicit anti-pattern in the playbook.

---

## 2. Guardrails (non-negotiable)

- **Valid intervals are NOT errors.** `[0,1)`, `(a,b]`, `[0,\infty)` are correct math — never "balance" them.
  (The delimiter detector was just fixed to know this; see §5. If you see one flagged, it's stale, re-grade.)
- **Edit, don't regenerate.** Use `propose_edit` with a UNIQUE `find` and send only the diff. Reserve
  `propose_repair` (whole-chunk) for chunks too shattered to anchor.
- **Preserve fidelity end to end.** UTF-8 no-BOM; SMP math, accents, and any surviving glyph must round-trip.
- **Inline vs block.** Inline math → `\( … \)` or `$ … $` (match the file's prevailing style); display math →
  `$$ … $$` on its own lines. Reconstruct splayed `cases`/matrices into proper environments.
- **Do NOT `git commit`.** `git add` is fine; the commit is the user's at a milestone they choose.
- **When genuinely unsure of the math**, `request_review` rather than guess.

---

## 3. The per-paper workflow (membrane tools)

The canonical loop is `restoration_procedure` (the MCP prompt) / `src/PROCEDURE.md`. This brief adds the
math-reconstruction specifics. Per paper:

1. **Orient.** `get_summary paper` and `search paper type=prose section=...` to walk the body. Remember:
   the work-set is body prose chunks *with math*, found by reading content — not the flagged set.
2. **Reconstruct, chunk by chunk.** `get_slice paper id` → rebuild the inline math per §1 → `propose_edit`
   (one fragment per edit, stack until the chunk reads clean) → repeat. Also resolve any genuinely-flagged
   `gibberish` / `intertext` / `unbalanced_delimiters` via their `work_order` recipes.
3. **Fold.** `apply paper`.
4. **Finalize.** `finalize paper` — the 9 papers in §4 marked `preprocessed` have NEVER been finalized;
   this materializes their deliverable. `pending` must reach 0.
5. **Holistic read.** `review_document paper` — the one full-body pass; fix anything that reads wrong in
   context (a heading, a caption, cross-section flow), `apply`, review again.
6. **Publish.** `publish paper topic dry_run=true` first → read the manifest → real `publish`. Note the
   manifest's **`figures_omitted`**: finalize strips images, so publish places the figure FILES and returns
   ready `![…](…)` snippets — splice each into the body with `splice_md`. After promotion, `repair_headings`
   + `update_doc_contents` clean any over-promoted headings / stale TOC.

---

## 4. Inventory & tiering (plan the batch from this)

| Paper | Stage | Deliverable? | flagged | enrich | Notes |
|---|---|---|---|---|---|
| 2008.10579v1 | finalized | yes (204KB) | 0 | 16 | largest; phase retrieval + deep priors |
| 1608.02165v1 | finalized | yes | 0 | 27 | ShapeFit/ShapeKick (SfM) |
| 1611.03935v1 | finalized | yes | 0 | 8 | **probe paper** — exemplar target |
| 1611.05985v3 | finalized | yes | 0 | 15 | |
| 1309.7669v1 | finalized | yes | 10 | 58 | 7 unbalanced (likely interval false-pos — re-grade) |
| 1109.4499v1 | preprocessed* | yes (74KB) | 13 | 70 | *has deliverable but ledger=preprocessed; verify + re-finalize |
| 2011.00288v2 | preprocessed | no | 28 | — | finalize after repair |
| 1812.04176v1 | preprocessed | no | 52 | — | |
| 1807.04261v1 | preprocessed | no | 21 | — | |
| 1804.02008v2 | preprocessed | no | 64 | — | |
| 1705.07576v3 | preprocessed | no | 84 | 18 | gibberish 18 / intertext 17 / unbal 47 (interval-inflated) |
| 1606.04970v3 | preprocessed | no | 66 | 111 | huge enrichable pool |
| 1602.04426v2 | preprocessed | no | 25 | 87 | the `ﬁ`-ligature / `Z 2` paper |
| 1506.01437v2 | preprocessed | no | 49 | — | |
| 1404.3811v1 | preprocessed | no | 18 | — | |

`flagged` counts predate the delimiter fix (§5) — the `unbalanced_delimiters` shares (esp. 1705's 47) are
inflated by valid interval notation and will drop after re-grade. Re-ground with `get_batch_summary
scope=corpora/voroninski` once re-preprocessed.

---

## 5. Pre-flight (do once, before the swarm runs)

1. **Reboot the membrane server** so it loads the fixed `src/latex.ps1` (the interval-tolerant delimiter
   balance — `[0,1)` no longer mis-flags; see `tests/detectors.Tests.ps1`).
2. **Re-preprocess** the corpus under the fixed detector so `flagged`/`agreement` reflect reality:
   `preprocess paper force=true` per paper (or batch). This drops the interval false-positives. Stored
   repairs are preserved unless forced — confirm no applied work is clobbered.
3. **Decide the publish topic.** Voroninski's papers are phase-retrieval / convex-optimization / SDP — there
   is no existing compendium topic for them (`ph`, `mapper`, `statistics`, `misc` exist). The orchestrator
   must pick/create a topic (e.g. `phase-retrieval` or `optimization`) before step 6 of §3. **Open decision
   for the user.**

---

## 6. Definition of done (per paper)

- Every body prose chunk's inline math renders (no `C n`, scattered `$`, flattened sums, lost norm bars,
  stray accents/glyphs).
- `finalize` → `pending = 0`; `review_document` reads clean end to end.
- `publish` landed: body + references + figures in `compendia/{topic}/`, `_CONTENTS.md` block upserted,
  `figures_omitted` all spliced in.
- No `git commit` (left for the user).
