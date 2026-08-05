# Doccer K2c chip brief — strict stack pairing with complete identity-bearing residue

Runstamp 20260805_093203. Canon at entry: D1–D31; K1, K2a, and K2b closed; contract harness
1733 checks green. This is the final consecutive implementation chip in the K2a–K2c tranche
frozen by the [joint K2 contract](sol-doccer-k2-joint-contract-20260804_214547.md).

## Contract

Land one domain-neutral strict stack pairing over exact occurrence inputs:

~~~text
Pairing.Pair
  OpenInput          ClaimSelection(open basis)
  CloseInput         ClaimSelection(close basis)
  Policy             named opener/closer compatibility rule

PairingResult
  exact inputs + exact policy object stamp
  MatchEdges         ClaimPairView(open basis, close basis)
  PairedRegions()    explicit identity-forgetting envelope projection
  Faults
    UnclosedOpens    ClaimSelection(open basis)
    DanglingCloses   ClaimSelection(close basis)
    MismatchedPairs  ClaimPairView(open basis, close basis)
    OpenResidue / CloseResidue
~~~

Open and close roles are supplied as exact selections rather than inferred from universal kind
names. The selections may use distinct frozen batches on compatible masters. `PairingPolicy`
retains a required diagnostic name and either a direct compatibility delegate or a `ByKey`
selector/comparer; the result retains the exact policy object that ran.

## Reference stack semantics

Selected claims form a word only when their nonempty spans establish one intrinsic reading order.
K2c therefore refuses an occurrence assigned both roles and refuses equal/overlapping token spans
across the combined population. It does not invent an insertion-, ordinal-, or role-based tie
break. Adjacent tokens are valid; batch insertion order is irrelevant.

In ascending geometric order:

- an opener is pushed;
- a closer on an empty stack becomes `DanglingCloses`;
- otherwise the top opener is popped and the caller policy is evaluated exactly for that pair;
- a compatible pair becomes one `MatchEdges` edge;
- an incompatible pair becomes one `MismatchedPairs` edge. It consumes both endpoints into fault
  residue and never searches below the stack top for a compatible alternative;
- openers left after the final token become `UnclosedOpens`.

The mismatch behavior follows the witnessed name-aware LaTeX environment scan and is not repair:
it records the exact local violation of stack discipline. It neither skips a token nor chooses a
replacement match.

## Result laws

For exact input selections \(O\) and \(C\), accepted-match projections and residue form disjoint
complete partitions:

\[
O=\pi_L(\mathrm{MatchEdges})\uplus\mathrm{OpenResidue},\qquad
C=\pi_R(\mathrm{MatchEdges})\uplus\mathrm{CloseResidue}.
\]

`OpenResidue` partitions into unclosed and mismatched openers; `CloseResidue` partitions into
dangling and mismatched closers. `MismatchedPairs` preserves the correlation between its two unary
projections. Accepted edges are forward, partial one-to-one, compatible under the stamped policy,
and noncrossing. These are result invariants, not claims that matching is containment or
parenthood.

`PairedRegions()` is an optional query, not stored parallel truth. Each match projects to the
closed token envelope `[open.Start, close.End)` and the resulting spans normalize through
`SpanSet`; nested, overlapping, or adjacent envelopes may collapse exactly because this operation
advertises that it forgets occurrence identity.

## Assurance surface

- an environment-family witness exercises nested keys and normalized paired-region projection;
- a fence-family witness exercises a second caller key policy and sequential matches;
- adversarial input simultaneously retains a dangling closer, a top-only mismatched pair, a later
  valid match, and an unclosed opener;
- bounded exhaustive words over two opener and two closer keys are differential-checked against an
  independently written abstract stack oracle;
- every bounded result is checked for match/residue partition, category partition, forward
  one-to-one noncrossing compatible edges, and exact input/basis/policy stamps;
- separate compatible bases, insertion-order independence, empty populations, custom/null keys,
  overlapping-role refusal, spatial-overlap refusal, incompatible masters, null public
  boundaries, and topology laziness remain executable;
- delivered-assembly smoke requires `PairingResult`, `PairingFaults`, and `Pairing.Pair`.

## Boundaries

K2c adds no repair, recovery search, inferred containment, inferred parenthood, canonical derived
facts, persistent occurrence IDs, pairing wire format, public delimiter vocabulary, grammar DSL,
or optimized/indexed stack backend. Delimiter recognition and open/close/key meaning remain
caller policy and store data. Later facts may cite match edges as support without changing this
pairing result.

## Done criteria

- public contracts compile without warnings and format cleanly;
- the two witnessed families, adversarial residue, bounded differential oracle, and invariant laws
  are green;
- D32, README, workplan, roadmap, ledger, joint K2 and predecessor briefs, and this report agree
  that K2 is closed and K3/K4a co-design is active next;
- the verified local payload exposes the pairing surface and passes assembly plus CLI smoke.

---

## Report

Completed 2026-08-05. Harness **1733 → 1779 checks green**; the verified local payload was
refreshed through `build-doccer.ps1`. Delivered-assembly smoke now requires `PairingPolicy`,
`PairingResult`, `PairingFaults`, `Pairing.Pair`, and `PairingResult.PairedRegions`; the manifest
records base commit `0b058ff` with a dirty source stamp for this K2c worktree.

`src/doccer/Algebra/Pairing.cs` supplies one reference stack implementation. Exact input
selections assign roles; `PairingPolicy` retains the caller's named compatibility rule; and
`PairingResult` retains those same objects beside exact match/fault carriers. Input validation
accepts distinct compatible bases but refuses incompatible masters, dual-role occurrences, and
equal or overlapping token positions. Batch insertion order never defines the word.

Each closer consumes only the current stack top. Compatible endpoints become `MatchEdges`;
incompatible endpoints become `MismatchedPairs` without deeper search; empty-stack closes become
`DanglingCloses`; remaining opens become `UnclosedOpens`. Mismatch projections and unclosed or
dangling selections combine into exact open/close residue, and match projections plus residue are
disjoint complete partitions. `PairedRegions()` is computed only when requested and explicitly
normalizes full match envelopes through `SpanSet`.

The environment witness retains two nested key families while its paired envelopes collapse
honestly to outer coverage. The fence witness uses a custom key comparer, sequential matches, and
distinct compatible batch/master objects. The adversarial witness records a dangling closer,
top-only mismatch, later valid outer match, and final unclosed opener in one execution. Finally,
the independent abstract stack oracle agrees on all 5,461 words of length zero through six over
open-A, open-B, close-A, and close-B; every result separately satisfies exact stamps, category and
input partitions, compatibility, forwardness, partial one-to-one, and noncrossing.

No delimiter vocabulary, repair, recovery search, containment, parenthood, fact minting,
persistence, wire format, optimizer, or Lean dependency landed. D32 closes K2 at 1,779 checks. The
joint K3/K4a located-relation/candidate-graph contract design is active next.
