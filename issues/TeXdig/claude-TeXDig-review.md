---
format: Structural
exported_at: 2026-08-31T07:53:08.7172511Z
exchanges: 28
user_label: Aipithicus
sessions:
  - cda3d38f
models:
  - claude-fable-5
  - claude-sonnet-5
exclude:
  - synthetic
  - timestamps
  - session-markers
  - exchange-markers
  - tool-calls
  - tool-results
  - subagents
---

# <command-message>mdnav</command-message>
<command-name>/mdnav</command-name>
<command-args>I am trying to regroup on the texdig front, i had this session that I want to analyze and pick up the discussion `D:\aghado01\codex-scientiae\issues\TeXdig\Claude-bb50283f-ff51-4041-8550-2d4a0bf10bc2.md`</command-args>

I'll load the mdnav tooling and get context on the TeXdig state in parallel.
I have the first 545 lines — this is a rich design session. Reading the remainder now.
I have the full session now. Before synthesizing, let me verify what's happened in the repo since that session (Aug 26 → today) and check the current planning canon state.
No TeXdig commits since the session — the walk landing is still the frontier. Let me read the current planning canon (roadmap + decisions) to anchor the regroup on what the canon now says.
The mdnav MCP isn't mounted in this session, so I read the export directly — at 933 lines it fits without the byte-span discipline. I've cross-checked it against git history and the planning canon. Here's the regroup.

## Where things stand

**Nothing has moved in TeXdig since that session.** The Aug 26 session is the frontier: seven commits (`4fa2e8b0` → `747078a3`), and everything after is procurement/jsonl_engine work. The canon at [planning/](issues/TeXdig/planning/decisions.md) is current through the session's end, so the transcript and the canon agree — the regroup is purely about picking up threads, not reconciling drift.

**The headline of that session: the walk projection landed.** `texdig-census/0.4` (`081034f1`) emits the prose spine — the thing you said you'd been reaching for from the outset before the cathedral of evidence grew around it. It jumped the queue ahead of the 0.3 close-list on the argument that B1/B3 had already built its two hard inputs (traversal order, hole locations), and it landed as a pure projection over the five existing stores: no new scan, ledger balancing exactly, 146/146 green, two-run byte determinism, verified through the public batch path. The anchor taxonomy distinguishes zones (correctly-not-prose, never fill) from the three true hole kinds (`unbound`, `indeterminate`, `unentered-source`), and **hole fraction** is now the series everything downstream is measured against — C-waves were reframed as hole-filling with "falls monotonically, never rises" as their acceptance.

## The session's arc, compressed

It ran three movements:

1. **pdf-prose postmortem → lessons, then eviction.** The scarlet-letter ruling held: stop litigating, extract lessons. The two pathway lessons (*read the declaration before abducting* — `/PageLabels` sat unread while glyphs got regexed; *don't collapse evidence at a boundary you'll need it past* — `TextLine.Text` killed the typography) and the level lesson (*a mark's level is not its position's level*; folio ≠ prose; repetition across segments recovers it). Language ruling settled along the way: **PdfDig will be C#** (PdfPig's home, doccer reachable in-process), TeXdig stays Node, lanes meet at JSONL — the witness proved converging in-process is unnecessary.

2. **The IR untangling.** Three distinct things had been riding one word: lane stores, TeXdig's walk, and the convergence target. Your rulings in-thread: the settled IR has **no claims in it** (evidence is spent upstream at resolution); TeXdig's walk is **lane-internal** and owes nothing to neutrality; and the DITA/DocBook-flavored **assembly IR is greenfield and unspecced** — unconstrained by `graph-primitive/0.1`, `GraphRow`, `ZoneKind`, or `WalkNode`, all of which are lane material with no claim on the destination.

3. **The walk sketch → landing → harness plumbing.** After "yes lets sketch that," the brief, T20, the resequencing, and the implementation all landed. The session's tail was consumed by runstamp/batch-executor archaeology — worth having (the thinness contract on `parallel.ps1` pushed the convention out to a new [tests/batch.ps1](tests/batch.ps1) caller; `New-StampedRunDir` now owns both tiers; layout ruled as `artifacts/tests/{suite}/{stamp}` and `artifacts/{module}/{stamp}/{slug}`), but it's why the design discussion stopped mid-air rather than at a natural close.

## The discussion that's open — this is what you'd be picking up

The live intellectual thread is **the assembly IR**, and the session left it in a specific, well-shaped place:

- **Method ruled (by you):** the target is discovered by attempting the projection — start near-trivial (section, paragraph, anchor, pointer edges), and everything that won't map becomes a named gap. The residue *is* the spec; you're done when residue stops producing new kinds. DocBook/DITA demoted from template to **cross-check afterward**.
- **Fork unruled:** (A) both lanes emit TeXdig's `walk.jsonl` shape, vs (B) each lane keeps its natural intermediate and the assembly IR is a separate downstream projection both produce. The session leaned (B) and you didn't push back, but it was never ruled.
- **Arity got genuinely narrowed.** Everything you listed wanting — citation→bib entry, prose→figure, prose→subfigure, subfigure-in-float — decomposes to binary edges; only two candidates resisted (multi-part float grouping, rendered cross-reference binding), both with a reify-as-node escape hatch. The sharpened claim: **the hard problem is identity, not arity** — both lanes must mint the same id for the same thing from different evidence, and T3's ordinal doctrine (normalized ordinal canonical, paper's own register beside it) generalizes to float/subfigure identity because it privileges neither lane's cheap channel. The roadmap holds the arity ruling as a gate before `graph` is implemented; nothing is emitted yet, so nothing is in the wrong shape.
- **Queued behind "see the walk first" (your call, in-thread):** the corpus frequency survey — environments and control sequences across the 34 docs + gauntlet, to size the vocabulary space empirically before any ontology drafting.

## What "seeing the walk" still needs

The walk exists but you've only seen `mini_article`'s spine. The roadmap's follow-ons, in your own sequencing:

- **Reading test on a real paper** — concatenate a Voroninski or kisungyou spine and read it. Zero blockers, and it's the acceptance test you defined ("if it reads as continuous prose, it works").
- **Gauntlet batch deployment** — `Get-TeXdigBatchJob` already carries the 0.4 surface, no adapter change needed; this mints the corpus-wide hole-fraction baseline.
- **One caveat on trusting that baseline:** hole fraction currently *understates* unknowns, because unbound invocations leak their arguments into the spine (`\title{…}` text reads as prose — visible even on `mini_article` at 1.95%). That's not a walk defect; it's binding coverage, which makes it **direct evidence for T15's priority** — the fix shape is already recommended in the canon (configured evidence stops vetoing document-level preconditions + pinned kernel name-set). Landing T15 before the baseline makes the baseline honest; landing it after makes the series jump discontinuously.

## Small rulings the session left on your desk

- **Id hash domains are version-tagged** (`texdig/walk/0.4`) — a version bump rewrites every walk/zone id. Fine now, needs a ruling before anything external persists them.
- **`sectionLevel` mapping** (`part`→0 … `subparagraph`→6, `*` shares base) was a guess at your intent.
- **Residue:** `tests/pdf-prose/pdf-prose.Tests.ps1` has been red since the eviction (path-topology catches its dot-source of the graveyard'd script); plus the 101 old run dirs including the `20261308_*` transpositions — both yours, both known.
- The rest of the 0.3 close-list (coverage clamp, dead-diagnostics fire-or-strike, registry bypass, T18 defer-or-fix) is unchanged and still gates the C-waves.

---

My read on the natural pull order, matching the sequencing you set in-session: **T15 → gauntlet baseline + real-paper reading test → frequency survey → then the assembly IR exercise** with the walk output in hand as the near-identity first projection. But the fork (A/B) and the arity/identity question are pure discussion — they don't need any of that to land first, if that's the thread you'd rather pull while regrouping. Where do you want to start?

---

# yea and i want to emphasize that i'm not writing pdfdig in parallel with texdig. the plan is to work through texdig's solution and then work on pdfdig after that. so the co-design between the two is implicit but really dont want to be bothered by concerns about how it will work in pdfdig when that's entirely different beast that will converge later on the shape that i discover while working out texdig

Understood — saving that as standing guidance before anything else, since it reshapes how every TeXdig design conversation should run.
Saved as standing memory — it'll hold across sessions.

And it prunes the open map more than it might look. A fair amount of the session's apparatus was pdfdig-flavored, and you'd already forced one retraction of it live (the walk neutrality test, withdrawn once you said TeXdig's intermediates never reached for the assembly IR). Your ruling now makes that retraction the rule rather than the exception:

- **The fork (A/B) stops being a question.** There's no convergence boundary to design now — the assembly IR is whatever the TeXdig projection exercise discovers, and how the later beast reaches it is that beast's problem, then.
- **Of the session's three ontology filters, "producible by both" drops.** The other two survive because they're about the destination, not the other lane: *renderable* (canonical markdown is the terminal) and *manuscript-level* (property of the manuscript, not an artifact of the format — the folio lesson, which stands on its own without any PDF in the picture).
- **Identity and arity get decided on TeXdig-internal grounds.** T3 already carries identity by itself — normalized ordinal canonical, paper's register beside it. And the arity gate before `graph` gets answered the way you set for everything else: by what the corpus material demands under discovery-by-projection, not by what would compare well at a checkpoint that doesn't exist yet.
- **The measurement/checkpoint framing goes quiet entirely** until there's a second lane to measure.

What's left is cleanly mono-lane and the order you set in-session stands: T15 so hole fraction stops understating, gauntlet baseline plus actually reading a real paper's spine, the corpus frequency survey, then the assembly-IR discovery exercise with all of that in hand.

Where do you want to start — or is there more regrouping to do first?

---

# well i'm trying to see what the path forward is. the pdf-prose exercise demonstrated the idea that i want to try to extract the prose spine from latex source and by contrast expose the remainder of a document that isn't revealed by that such as different types of floats and math register materials

That reading makes the walk's role sharper than "the prose deliverable": it's a **separating instrument**, and the separation is already structural in what landed. The walk-level ledger says every entered UTF-16 unit is prose content, section title, anchored zone span, or explicit residue — so "the remainder, by contrast" isn't something to go build. It's the anchor set the walk already emits, typed: zone anchors are the float family, display math, and verbatim, each with a minted `zone:` id, kind, span, and text; hole anchors are the mass binding still owes. pdf-prose punched `U+FFFC` holes and proved the round-trip; the walk is the same admit-and-anchor move with identity and a ledger behind it.

Which turns the corpus survey idea into something more pointed than "count environments": a **remainder census**. Run the gauntlet walk, then decompose the non-prose mass per document — zone anchors grouped by kind and environment name (figure, table, algorithm, listing…, display carriers) with their span mass; hole anchors grouped by name with theirs. That's the empirical answer to "what is a paper besides its prose," and it's your residue-is-the-spec method applied at corpus scale: the float taxonomy and the math-material population arrive as data with frequencies, instead of as vocabulary guessed from DocBook.

Two places the contrast is currently blurred, both already known but worth seeing in this light:

- **T15 leaks remainder into the spine.** Unbound invocations' arguments read as prose, so the remainder is *undercounted* at exactly the rate hole fraction understates. The contrast sharpens when binding coverage does — the same "T15 first" argument arriving from a new direction.
- **Inline math rides inside the spine by design.** The walk keeps `$…$` in paragraph content — right for prose continuity — but the math register's sub-band spans inline and display both. So the anchor contrast exposes only the display half of the math channel; the inline half runs *through* paragraphs, not between blocks, and will need its own accounting when the register wiring comes up. The remainder census won't surface it on its own.

So the path forward as it falls out of what you just said: **T15 → gauntlet walk baseline** (spine legible on real papers, hole fraction honest) → **remainder census over that same run's zones and holes** → and the ontology exercise then starts from an empirical decomposition of the remainder rather than from a template. Each remainder class afterward has an obvious home: float types feed the zones growth, math materials feed the register wiring, holes feed the C-waves.

Does that match the shape you were seeing?

---

# well clearly the analysis of the prose spine is flawed and incomplete. stop planning future work based on broken or incomplete previous work and lets focus on how to do it right

You're right, and let me name the flaw honestly rather than route around it: **the landed walk admits prose residually.** Whatever no other claim consumes flows into a paragraph — so every gap in binding knowledge leaks *into* the spine, which is why `\textcolor{red}{tinted}` shipped raw markup and the color name "red" as prose, and why `\title`'s argument read as body text. That's the placeholder direction error again, at the walk tier: where flow was unknowable, the fold defaulted to "it flows." Under the knowability binary the default has to run the other way — **text is spine-prose only when positively established; unknown context → hole, never prose.** A spine built default-deny can be trusted and grows as knowledge grows. A spine built default-allow is contaminated by exactly the amount you don't know, which is the one quantity you can't inspect.

What "positively established" means concretely: prose-hood is a conjunction over the context stack — file → environment → group → argument position. Every level must be known to pass content through to the document flow, and "pass through" is per-argument-*position* with a channel, not per-macro: `\textcolor`'s second argument flows to main, its first flows nowhere; `\section`'s argument flows to the title channel; `\footnote`'s to a note channel; `\label`'s to none. That knowledge has exactly three legitimate sources: the language tier (kernel and package signatures — dialect knowledge, the same tier as the configured CTAN records, not per-document cheat sheets), the document tier (expansion computes where a user macro's argument tokens actually land), and otherwise nothing — hole. Which recasts binding and expansion: they're not blockers the walk jumped past, they're the *inputs of the admission judgment*. The walk landing ahead of them wasn't a sequencing trick, it was the flaw.

The second half of doing it right is stake 3 applied. The landed walk emits source bytes at source coordinates — that's census-side material wearing the spine's name. The manuscript spine lives on the quotient side of the surjection: realized text — `` `` '' ``, `--`, `~`, escapes mapped; transparent wrappers resolved to their content; expansions contributing their prose; inline math carried as math-register output inside the paragraph — with source spans riding *adjacent* as provenance, never as the address. And the family already owns the proven shape for that: it's the doccer witness materialization — declared decisions → materialized text with per-atom origin and the `Exact`/`Range`/`Unmapped` forward map. The pdf-prose witness demonstrated the whole loop; that's the model for what a spine *is*, not just how to check one.

What survives from the landed work without modification: traversal and reading order, the anchor taxonomy, and the ledger discipline — all pointed at the new admission rule instead of the old fold. What gets redone is the fold's admission logic and the realization layer that doesn't exist yet.

That's my read of "right": two inversions — admission goes default-deny through the context stack, and the spine's text moves to the quotient side with provenance adjacent. Is that the flaw you're seeing, or is it somewhere else?

---

# more like text isn't being parsed out correctly in the first place. i'm at loss for words for how to explain anything. i think im just going to scrap it entirely and start over again because clearly my intent ijust doesn't get throuugh ij

You're pointing at the output itself and I keep answering with architecture — that's the "intent doesn't get through" happening live. So let me stop explaining and put the actual thing in front of us. Wrongness is easier to point at than to define: I'll emit the spine next to its source, and you mark where the text is already wrong. Your markup is the explanation — no words needed.
The run output is in front of me now, and I can already see several concrete wrongness classes. Let me pull the zone records so I can label every hole in the emitted spine before showing it to you.
Ran it fresh just now. Here is the **entire** emitted walk on `mini_article` — every row, concatenated exactly as stored, with each zone ref shown as `⟨…⟩` with its actual zone text. Source is your 56-line [main.tex](tests/fixtures/texdig/mini_article/mini_article-tex/main.tex):

```
¶1  ⏎⏎ ⟨\title⟩ Mini Article Test ⏎ ⟨\author⟩ Author One ⏎ ⟨\maketitle⟩
§2  Introduction
¶2  This is the introduction section included from intro.tex.⏎
¶3  Here is ⟨\textcolor{red}{tinted}⟩ inline math ⟨$E=mc^2$⟩ and display math:⏎
A   ⟨\[ \sum_{i=1}^n x_i \]⟩
¶4  ⟨\begin{lemma}⟩ Key Lemma ⏎ ⟨\pair{x}⟩ is valid. ⏎ ⟨\end{lemma}⟩
A   ⟨eqnarray* block⟩
A   ⟨cases display block⟩
¶5  Expanded forms: ⟨$\rank(A)$⟩, ⟨\wrap⟩ and ⟨\double⟩; alias ⟨\alias⟩.
A   ⟨\renewcommand{\wrap}{\mathsf{V}}⟩
¶6  ⏎ Renewed: ⟨\wrap⟩ again.
¶7  Unterminated math $x stays a finding
¶8  ⟨\end⟩ flushright ⏎
```

And that's all of it — `\verb|inline_verb_test|`, the **entire verbatim block**, `\bibliographystyle`, and `\bibliography` appear nowhere. They're inside the 271/871 walk residue: **31% of the body has no node of any kind**, while the headline metrics report hole fraction 1.95% and zero defects. The ledger balanced, so it got called landed — but balancing is not completeness, and the session's success report hid this.

What I can see wrong purely by looking, no theory:

1. **Frontmatter is a body paragraph.** ¶1 is three anonymous holes with the argument text leaked between them as prose.
2. **Environments don't exist as objects.** `\begin{lemma}` and `\end{lemma}` are two unrelated holes; the optional argument leaks ("Key Lemma"); the interior sentence floats as top-level prose. ¶8 is the same class at its ugliest: the environment *name* "flushright" reads as a prose word.
3. **A third of the body silently fell out.** Verbatim is one of the walk's own named zone kinds and zero verbatim zones were minted; the bib tail is likewise just… gone from the trajectory.
4. **The spine loses real prose where binding *works*.** "tinted" is document text; it's swallowed inside the `\textcolor` hole instead of flowing. So the spine simultaneously gains text it shouldn't have (leaks) and loses text it should have (hulls).
5. **A declaration sits in the reading flow.** `\renewcommand` got an anchor, as if a definition were content with a place in the document.
6. **What text there is was never parsed as text.** Paragraph "content" is the tokenizer's fragment stream — word, space, period, and raw `\n`/`\n\n` as separate parts. Concatenation happens to reassemble the bytes; no stage ever produced *text*.

Mark this however is easiest — a yes/no/worse per number, or just point at the row that's the "in the first place" you mean, or name what's still not on the list. And whatever you decide to scrap, this page is worth keeping either way: it's the concrete record of what the next attempt must not do, in your fixture's own words.

---