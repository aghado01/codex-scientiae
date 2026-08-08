# Verbose comments removed from masks.ps1

```Powershell

#   src/shared/masks.ps1 — the closed mask-algebra primitive set

<#
A detector earns precision the way the rest of the membrane earns its guarantees: by construction, not by supervision. Instead of writing the precise pattern (a brittle strip-list
that loses a whack-a-mole game), write a COARSE overlay (high recall, easy to keep stable) and
SUBTRACT to isolate the target. Exactness lives in the set operation, not the regex.

A `Mask` is a NORMALIZED SPAN SET over a string: a sorted, disjoint, half-open [start,end) list of
UTF-16 offsets, plus the length of the string it is taken over. One representation, one enforced
invariant — every op returns normal form (construction merges overlaps/adjacency, drops zero-length).

The closed operation set (brief's algebra name -> the function here), and nothing beyond it:

| brief    | function          | signature                          |
|----------|-------------------|------------------------------------|
| New-Mask | New-Mask          | (text, regex) -> Mask  (the overlay: coarse match -> spans)
| Complement | Complement-Mask | (Mask[, len]) -> Mask  (everything not covered)
| Sub      | Sub-Mask          | (Mask a, Mask b) -> Mask  (a \ b)
| Intersect| Intersect-Mask    | (Mask a, Mask b) -> Mask
| Union    | Union-Mask        | (Mask a, Mask b) -> Mask
| Density  | Get-MaskDensity   | (text, within-Mask, register) -> count|spans  (the doccer density)
| At-Level | Split-AtLevel     | (text, SpanLevel) -> unit list  (the level lens)

SpanLevel — every detector DECLARES the level it runs at; mixing levels is a bug (doccer #3):
* Character — UTF-16 offsets into the string (delimiter balance).
* Line      — newline split within a chunk (alignment pairing, token-shatter density).
* MultiLine — a chunk / id-range (formula or block extent).

Discipline (what keeps the algebra from becoming the engine we refuse to build):
* PURE + TOTAL. Every op is (string|Mask) -> (Mask|number) with no I/O, no state, no side effects;
    defined on empty / full / partial / boundary input; never throws on valid input (propose_edit
    re-grades mid-repair, so an unbalanced intermediate is normal input). Zero-length spans
    normalize away.
* CODEPOINT SAFE. Offsets are UTF-16 code units (consistent with Get-LatexBalance). A span edge
    lands BETWEEN codepoints, never inside one — SMP math (E/S blackboard bold) is two code units;
    construction snaps any edge that would split a surrogate pair outward to the codepoint boundary.
    Masks do no I/O; the explicit UTF-8-no-BOM backbone lives at the call sites that read content.
* BOUNDED. Inputs are KB chunks / small id-ranges -> O(n) passes, a mask is a handful of spans.
    No quadratic span growth. Lightweight interval ops, not a sweep engine.

Non-goals (the fence — escalate, do not build): no SoA columns / DocPlane / bit-planes, no 64KB LUT,
no hex addressing, no BPE, no general rule-table runner, no persisted mask sidecars (ids are line
indices that split/merge renumber — masks are computed lazily, in memory, like the hotspot overlay).

Pure, no I/O — dot-source and call. latex.ps1 / fidelity.ps1 / normalize.ps1 CONSUME this; logic
does not scatter. This is to spans what latex.ps1 is to math predicates.
#>


# ── codepoint safety: never split a surrogate pair at a boundary ───────────────
# A boundary i splits a pair iff text[i] is a low surrogate and text[i-1] is its high surrogate.
# A start snaps back (include the high half); an end snaps forward (include the low half) — either
# way the full codepoint stays whole. BMP-only patterns never trigger these; the snap is the
# standing-invariant insurance so a future overlay can't quietly halve an SMP glyph.

# ── the one enforced normal form ───────────────────────────────────────────────
# Clamp to [0,len], tolerate reversed pairs, drop zero/negative-length, surrogate-snap edges (when
# the text is in hand), sort, then merge overlapping AND adjacent spans ([0,3)+[3,5) = [0,5), since
# half-open adjacency is contiguous coverage). Every constructor and op funnels through here, so a
# Mask is ALWAYS sorted, disjoint, half-open — no ad-hoc span shape exists anywhere else.

# ── New-Mask — the overlay constructor ─────────────────────────────────────────
# Pattern set: a coarse regex over the text -> one span per (non-empty) match. Spans set: raw
# [start,end) pairs (used by the set ops to re-enter normal form). Either way the result is normalized.

# ── Complement — everything not covered, within [0,len) ────────────────────────
# Gap-walk over the (sorted, disjoint) spans. Defaults to the mask's own length; pass an explicit
# length to complement within a different universe (the brief's `Complement mask len`).

# Blank the masked region to spaces (so a later match can't fuse across a region boundary), leaving
# the COMPLEMENT in place; -Keep inverts (keep the masked region, blank the rest). Length is
# preserved, so offsets still line up. Because masks are surrogate-safe, a boundary never blanks half
# a codepoint. This is the doccer "apply the mask" step the Density count and the gibberish residual
# are both built on.

# ── Density — the doccer rolling count of a register WITHIN a mask region ──────
# Keep only the `Within` region (blank the rest), then count (or return spans of) the register
# pattern in what remains.

# ── At-Level — the level lens (interpretation over the strings already held) ───
# Returns the units at the requested level, each carrying its [Start,End) offsets into the ORIGINAL
# string so a level-local mask can be lifted back (Move-Mask) and recomposed. Character/MultiLine
# are one whole-string unit (Character = balance over the full offset space; MultiLine = the chunk);
# Line splits on newline, the \n excluded from each unit.




```
