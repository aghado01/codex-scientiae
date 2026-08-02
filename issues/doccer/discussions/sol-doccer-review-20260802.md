Overall, the work is strong and substantially more mature than the original sketch. The planning canon, README, implementation, and tests agree unusually well. I found one high-priority correctness defect, several contract gaps, and some roadmap sequencing worth adjusting.

## Findings

1. **[P1] `CollectInto` can leave a partially mutated batch after failure.**

[`CompileAndProbe`](/D:/aghado01/codex-scientiae/src/doccer/Collector/RegexCollector.cs:171) only tests the regex against an empty input. A context-dependent zero-width expression such as `(?=a)` passes that probe. If it follows a valid rule, the valid rule’s claims enter the builder before the zero-width match throws in `AddMatches`.

I reproduced:

```text
good rule emits one claim
(?=a) throws
builder.Count remains 1
```

That contradicts the atomicity promise at [`RegexCollector.cs:127`](/D:/aghado01/codex-scientiae/src/doccer/Collector/RegexCollector.cs:127). `CollectInto` should stage all new claims and commit them only after every rule and region succeeds. This also protects against match timeouts and optional captures that unexpectedly produce empty claims.

::code-comment{title="[P1] Collection is not atomic" body="CompileAndProbe only tests the empty input. A context-dependent zero-width rule such as `(?=a)` passes that probe; when it follows a valid rule, earlier claims are added before AddMatches throws, leaving the caller's builder partially mutated despite the atomicity promise. Stage emitted claims and commit them only after every rule and region completes successfully." file="D:/aghado01/codex-scientiae/src/doccer/Collector/RegexCollector.cs" start=127 end=139 priority=1}

2. **[P2] A misspelled capture group silently disables a rule.**

[`AddMatches`](/D:/aghado01/codex-scientiae/src/doccer/Collector/RegexCollector.cs:259) treats an unknown group name like a legitimate nonparticipating group and emits nothing. An inventory with `"captureGroup":"titel"` can therefore load successfully and silently produce zero claims.

The compiled regex’s group names/numbers should be checked during rule validation so the loader can report the inventory origin and line.

::code-comment{title="[P2] Validate capture-group identity" body="An unknown CaptureGroup returns an unsuccessful Group and the collector silently emits no claims. This turns inventory typos into missing evidence. Validate the requested name or number against the compiled regex during CompileAndProbe so the JSONL loader can fail with file-and-line provenance." file="D:/aghado01/codex-scientiae/src/doccer/Collector/RegexCollector.cs" start=257 end=263 priority=2}

3. **[P2] Empty-span intersection semantics are inconsistent.**

[`TextSpan.Intersects`](/D:/aghado01/codex-scientiae/src/doccer/Core/TextSpan.cs:49) reports that `[5,5)` intersects `[0,10)`. Consequently, `SortedSpanLookup.FindIntersecting([5,5))` returns the containing claim.

That could be useful as a point query, but it is not ordinary half-open set intersection:

- `SpanSet` discards empty spans.
- Allen relations reject them.
- `TextTopology.Project` explicitly documents its special insertion-point convention.
- `Intersects` does not document a point-query convention.

I recommend making `Intersects` set-theoretic and adding a named `ContainsPosition`/`FindContainingPoint` operation. Otherwise, document insertion-point semantics consistently across the algebra before Tranche 3.

::code-comment{title="[P2] Empty spans intersect occupied ranges" body="For an empty span `[x,x)`, this expression can return true against a containing non-empty interval. That is useful only if Intersects is intentionally also a point-location query, but SpanSet and Allen relations use ordinary empty-set semantics. Make Intersects require both spans to be non-empty, or separate the insertion-point behavior into a named query." file="D:/aghado01/codex-scientiae/src/doccer/Core/TextSpan.cs" start=49 priority=2}

4. **[P2] Direct C# callers can construct undefined scope and level values.**

The JSONL loader validates enum names, but `PatternRule` itself accepts casts such as `(ExecutionScope)99`. Every value other than `WholeMaster` currently falls through to per-line execution. Undefined `SpanLevel` values can likewise enter claims.

Because the DLL is the canonical operation-grain API, its constructors should enforce `Enum.IsDefined`, not depend on the loader.

::code-comment{title="[P2] Reject undefined enum values" body="The public constructor accepts cast enum values outside SpanLevel and ExecutionScope. ExecutionRegions then treats every unknown scope as PerLine because it only distinguishes WholeMaster from the else branch. Validate both enum arguments here so direct DLL consumers receive the same guarantees as JSONL consumers." file="D:/aghado01/codex-scientiae/src/doccer/Collector/RegexCollector.cs" start=67 end=74 priority=2}

5. **[P2] The reusable package is materially behind the source.**

The checked-in [`packages/doccer/CodexSci.Doccer.dll`](/D:/aghado01/codex-scientiae/packages/doccer/CodexSci.Doccer.dll) is still from the original prototype commit and does not contain `ExecutionScope`. The current source assembly is 78,848 bytes; the packaged one is 49,664 bytes with a different hash.

Selective payload refresh is intentional, but consumers presently cannot determine what source revision the payload represents. I would add a package manifest containing at least:

- Source commit.
- Build timestamp.
- Target framework/runtime.
- Contract or schema version.
- Test-harness result.

A package smoke test should load the delivered DLL and assert a few expected public types before a refresh is considered successful.

## Verification and test-surface gaps

The documented **1,263 checks pass**, and both the engine and CLI build with warnings treated as errors. The source CLI’s `inspect` and `relate` commands also work.

The tests are thoughtful—particularly around malformed UTF-16, reconstruction, line boundaries, laziness, run keys, suppression, and inventory provenance—but the raw count overstates breadth slightly: 896 checks come from the 128 × 7 randomized Boolean-law loop.

Two currently advertised public operations receive no direct tests:

- [`IntervalJoins.Join`](/D:/aghado01/codex-scientiae/src/doccer/Algebra/AllenRelation.cs:106)
- [`TextTopology.Project`](/D:/aghado01/codex-scientiae/src/doccer/Core/TextTopology.cs:284)

There are also no tests for:

- Context-dependent zero-width matches.
- Unknown capture groups.
- Undefined direct-API enum values.
- Empty-span relational semantics.
- The packaged DLL/CLI rather than source build outputs.
- A custom comparer passed to `EmitRuns`.

The README carefully says several Tier-1 properties are protected “in the contract harness.” The roadmap’s phrasing is slightly broader. [`ValidateIntrinsic`](/D:/aghado01/codex-scientiae/src/doccer/Validation/Validation.cs:115) itself only checks atom coverage and claim bounds; reconstruction, line consistency, suppression, determinism, and interning are test laws rather than a callable runtime Tier-1 runner. That distinction should be made explicit in `roadmap.md`, or the runner should eventually expose those checks.

## Planning review

The decision canon is excellent. D3–D8 cleanly resolve the most dangerous earlier ambiguities:

- Suppression is query policy.
- Atom facts are distinct from derived runs.
- Claim priority differs from resolution policy.
- Level metadata differs from execution scope.
- “Lift” has been decomposed into five operations.
- Generic density has been rejected.

The roadmap has two sequencing issues:

- **The harvest survey should precede the first durable CLI contract.** Queue item 3 says the survey “feeds and refines the verb list,” but item 2 builds the first verbs and wire records first. Swapping them would reduce the chance of freezing the wrong task grain.
- **Tranche 3 is too broad for one chip.** It currently combines `TextSlice`/rebase, group/project basis stamping, gap cadence, priority-aware lookup, and three parked questions. Those have different law surfaces and failure modes. I would split it into:
  1. slice/rebase;
  2. group/project;
  3. gap cadence;
  4. priority-aware lookup.

The provisional CLI also predates D13. `relate` is operation-grain, and `inspect` serializes an anonymous object outside the source-generated wire context. Either label these as disposable developer diagnostics or reconcile them when `collect` and the first task-grain algebra verb land.

No repository files were changed during the review; the worktree remains clean.
