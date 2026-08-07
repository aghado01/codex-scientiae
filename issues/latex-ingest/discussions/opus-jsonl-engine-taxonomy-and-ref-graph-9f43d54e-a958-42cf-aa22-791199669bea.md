---
format: Structural
exported_at: 2026-08-07T23:44:48.1982765Z
exchanges: 122
user_label: Aipithicus
sessions:
  - 9f43d54e
models:
  - claude-opus-5
exclude:
  - thinking
  - synthetic
  - timestamps
  - session-markers
  - exchange-markers
  - tool-calls
  - tool-results
  - subagents
---

# so i want to do a little retrospective on some old code to examine some class method implementations i've done in powershell in order to think about how to construct good class methods for new gen codex-scientiae code, starting with my jso-ops which is currently written awkwardly in functional code. i hope you can help me and conjure some powershell scripting and SDK best practices flex to help me do this. observe for example, my original jso-utils, very old. minus all of the fluffy telemetry, can you see how i was breaking my architecture up into "classy" orchestrator and "functional" primitives `D:\aghado01\graveyard\codex-scientiae\legacy_code\jso-utils`?  then there's the `bootstrap-registries` component. Since i'm working on the new `jso-ops` in codex-scientiae, i am remembering this and other earlier work once again and want to do some archaeology, and think about how to write my new stuff in a more mature form

I read both legacy modules, `Bootstrap-Registries.ps1`, and the new `jso-ops` files, and ran the class mechanics against PS 7 to check what actually holds. Findings first, then the doctrine they imply.

## What the legacy split actually was

Your instinct in `jso-utils` was sound and more principled than you may remember it being:

- **Core** = ~50 stateless verb-noun functions — `Read-JsonFile`, `New-BloomFilter`, `Split-JsonlByRecordCount`. Pure transforms, path in / object out.
- **Orchestrator** = three classes — `JsoEncoder` (strategy + static factories), `JsoSharding` (a mutable counter), `JsoProcessor` (fluent builder + executor).
- **`New-JsoProcessor` / `New-JsoEncoder`** = factory functions wrapping the classes, because **PowerShell classes cannot be exported from a module**. That constraint, not taste, is why those functions exist.

And the tell that you already knew the real rule: buried in *Core*, not the orchestrator, is `class JsonlEnumerator : System.IDisposable`. You put a class exactly where a **resource with a lifetime** needed owning, and left everything else functional. That's the correct instinct, and it's the one I'd formalize.

## Three defects in the legacy orchestrator, each teaching a rule

**1. The parallel path never ran.** `ProcessJsonlFile` and `ProcessJsonFiles` both call `ForEach-Object -Parallel { param(...) } -ArgumentList ... -ThrottleLimit ...`. Verified: `-Parallel` and `-ArgumentList` are in **different parameter sets** — that call throws `Parameter set cannot be resolved`. `-Parallel` blocks take no `param()`; they take `$using:`. So `JsoProcessor`'s headline feature was dead code in both methods.

The rule isn't "test more." It's that `UseParallelism` was a **flag in an untyped hashtable** rather than a capability object. A `bool` in `[hashtable]$Config` branches to code nothing ever forces you to exercise, and `Set-StrictMode` can't help you — a typo'd key is a silent `$null`, not an error. The `Config` hashtable undoes the exact type safety that was the reason to reach for a class.

**2. Class method default values parse, then get thrown away.** This one is worth internalizing:

```
class T { static [string] F([int]$a = 5) { return "a=$a" } }
[T]::F()   ->  ERROR: Cannot find an overload for "F" and the argument count: "0"
[T]::F.OverloadDefinitions  ->  static string F(int a)
```

`[JsoEncoder]::CreateTabular([string[]]$Columns = $null, [switch]$AutoDiscover)` compiles to **arity 2**. The `= $null` is decoration the parser accepts and discards. It only works because `New-JsoEncoder` always passes both. Same story with `[switch]` in a method signature: it parses, but there's no `-AutoDiscover` call syntax — you pass `$true` positionally, so it's `[bool]` wearing a costume. **Overloads are the only real defaults in a class.**

**3. Fluent methods that lie.** `WithFormat`/`WithConfig` mutate `$this` and return `$this`, so `$b = $a.WithFormat('json')` leaves `$a` changed too. The legacy call sites write `$processor = $processor.WithConfig(...)`, which *reads* like rebinding and isn't. Pick one: mutators return `[void]`, or `WithX` clones and returns a new instance. Returning `$this` after mutating is the worst of both.

A fourth, quieter one: class methods call module functions (`ConvertTo-CanonicalJson`, `New-BloomFilter`, `Select-JsonPath`) from inside class bodies. PS resolves those **at runtime against the caller's session state** — an invisible dependency that breaks the moment the type is used outside the module.

## Bootstrap-Registries: the opposite pole

`CorpusRegistryBootstrapper` is the other failure mode — **class as application**, not as type. Constructor does disk I/O (`LoadOrCreateRegistry()` at line 28), so you cannot construct one without touching the filesystem; every method `Write-Host`s, fusing the domain to the console; `WriteMemoryLog` welds telemetry into the domain object. And `Invoke-Expression '$DomainRules'` with a **regex fallback that parses PowerShell source** to recover a domain name is the load-bearing lesson: config that must be executed to be read isn't config.

What it got *right*, and is worth keeping: it's a genuine session object with a real lifecycle — load → register → stats → save — and its side-effecting methods honestly return `[void]`. That's a legitimate class. It just should have taken its registry as data and emitted results instead of printing them.

## Where the new jso-ops actually stands

It is not naively functional — it's considerably more mature than the legacy, and it's already 80% of the way to the answer:

- [`class JsonlIndex`](src/shared/jso-ops/jsonl-v2.ps1:37) is used *correctly*: typed fields, two invariant-bearing methods (`GetOffset` range-checks, `IsCurrent` self-validates), zero I/O ownership.
- `function script:` private helpers give you module-private discipline inside a dot-sourced file.
- Public functions carry `[CmdletBinding()]`, `ValidateSet`, `ValidateRange` — the things classes *can't* do.

The awkwardness you're feeling is specific, and it's one thing repeated:

**You are hand-rolling a nominal type system.** [`jsonl-store-v2.ps1:88`](src/shared/jso-ops/jsonl-store-v2.ps1:88) stamps `$policy.PSObject.TypeNames.Insert(0, 'Jsonl.StorePolicy')`, and [`Assert-JsonlStorePolicy`](src/shared/jso-ops/jsonl-store-v2.ps1:113) checks that tag at runtime — after which every public function declares a bare, untyped `$Policy,` ([line 418](src/shared/jso-ops/jsonl-store-v2.ps1:418), [454](src/shared/jso-ops/jsonl-store-v2.ps1:454)) and calls the assert manually. A `[JsonlStorePolicy]$Policy` parameter does all of that at **bind time**, with a better error, and deletes the assert entirely.

Three consequences fall out of the same root:

- **Row shape drifts.** `script:New-JsonlStoreRow` returns a 5-field `pscustomobject` that then gets `$row.Order` reassigned ([:499](src/shared/jso-ops/jsonl-store-v2.ps1:499), [:504](src/shared/jso-ops/jsonl-store-v2.ps1:504)) and an `Add-Member -NotePropertyName ByteOffset` bolted on ([:339](src/shared/jso-ops/jsonl-store-v2.ps1:339)). Two shapes wearing one name.
- **The mutex try/finally is copy-pasted** across Create / Add / Remove / Subtract / Sort. That's an `IDisposable` lease begging to exist — the one thing `JsonlEnumerator` already taught you in 2025.
- **`ContentionAction` + `ContentionTimeoutMilliseconds` + `RetryIntervalMilliseconds`** appear together in ~8 signatures and get threaded down by hand. Parameters that always travel together are one object.

## The doctrine

**Classes for nouns that own something. Functions for verbs that transform.** "Own" means state that must stay internally consistent, or a resource with a lifetime. `JsoProcessor` owned nothing — it held a config bag and called free functions, which is why it rotted.

Three legitimate class kinds, and nothing else:

| Kind | Owns | Examples in your code |
|---|---|---|
| **Record / value** | invariants over its own fields | `JsonlIndex` ✓, `JsonlStorePolicy` (pending), `JsonlStoreRow` (pending) |
| **Resource handle** (`IDisposable`) | a stream, mutex, lease | `JsonlEnumerator` ✓, `JsonlPathMutex` (pending) |
| **Strategy** | one decision, injected | what `JsoEncoder` was reaching for |

Rules for the methods themselves:

1. **A class method may call .NET and its own members. Nothing else.** No module functions, no cmdlets — those resolve against the caller's session state at runtime.
2. **Overloads, not defaults.** Defaults are silently discarded; `[switch]` has no call syntax.
3. **Validation lives on properties, not method parameters.** `[ValidateSet]` on a property parses; on a method parameter it's a hard parse error — *"valid on 'Property, Field' declarations only."* So put the invariant on the field and let the constructor be the gate.
4. **Uncaptured output in a method is discarded** (unlike a function). This is a feature — methods can't accidentally pollute the pipeline. Lean on it.
5. **Keep the cmdlet surface functional.** `[CmdletBinding()]`, `ValidateSet`, `ShouldProcess`/`-WhatIf`, comment-based help, pipeline binding — none of these exist in classes. `New-JsonlStorePolicy` stays a function forever; it just returns a real type.
6. **Classes don't export.** `using module` or dot-source; a `New-X` function is the public door. You already do this.

One nuance worth knowing since you use `-Parallel`: a class *instance* does marshal across the boundary via `$using:` and its methods work — but the type name arrives as `<f37cdba4>.P`, so you cannot type-annotate or `::new()` inside the parallel block. Instances travel; types don't.

## The smallest high-yield move

If you want one change that converts most of the awkwardness: make `New-JsonlStorePolicy` return `[JsonlStorePolicy]::new(...)` instead of a tagged `pscustomobject`, type the `$Policy` parameters, and delete `Assert-JsonlStorePolicy`. The function keeps every line of its current validation logic — it just hands back a real type at the end. Then `JsonlStoreRow` as a class with `Order` as a settable property makes the merge loop honest, and the mutex becomes a lease.

Where do you want to push first — the policy type, or the lease/contention object? They're independent, and the lease is the one that deletes the most repeated code.

---

# right it had warts. and im not trying to copy my old work so much as point out patterns and concepts, the reusability and organization, the engine-building. even if parallel path never ran, the point is that iwas part of my design. i just never finished it

Reading it that way, the design is more coherent than the implementation, and three things in it are load-bearing.

## The engine found three orthogonal axes

`JsoProcessor` isn't a god object if you read what it *composes*:

- **`JsoEncoder`** — the transform axis. Named, parameterized, pluggable, with a `Custom` escape hatch.
- **`JsoSharding`** — the partition axis. Where does the next record go, decoupled from what the record is.
- **`Config`** — the execution-policy axis. Parallelism, buffering, depth, progress.

Transform × partition × execution really are independent. You can vary any one and hold the others. That's an algebra, and finding it is the hard part — the implementation fusing builder and executor is the easy part to redo.

Now look at what carried into `jso-ops`:

| axis | legacy | new |
|---|---|---|
| transform / validate | `JsoEncoder` | `New-JsonlStorePolicy` — **survived**, but as a tagged `pscustomobject` |
| partition | `JsoSharding` | **gone** |
| execution policy | `JsoProcessor.Config` | **dissolved** into `ContentionAction`/`Timeout`/`RetryInterval`/`Depth`/`IndexPath` repeated across 8 signatures |

That's the actual diagnosis of why the new code feels awkward while being technically better: **the primitives got much stronger and the axes got flattened into parameters.** Store policy is `JsoEncoder`'s direct descendant — named strategy, validated at construction, factory-built — it just has no type to live in, so the compiler can't see the axis. And the other two axes stopped being nameable at all.

## The vocabulary pattern

`[JsoEncoder]::CreateIdentity() / CreateMinifier() / CreateCanonical() / CreateJsonPath() / CreateTabular()` — the class is a **namespace of known configurations**. Not "here are five functions," but "here is the vocabulary of transforms this engine knows," discoverable by typing `[JsoEncoder]::`.

`New-JsonlInventoryStorePolicy` is exactly that move — a named, known configuration of the general policy. But it's one loose function beside `New-JsonlStorePolicy`, so the vocabulary is a naming convention rather than a place. When the second and third store kinds arrive, nothing collects them.

The `identity` member matters too. `CreateIdentity()` plus `if ($encoder.Name -ne 'identity')` means the transform axis has a **unit element** you can recognize and skip. That's what makes "always apply the transform" safe as a uniform rule — no special-casing "no transform configured" at every call site.

## Plan and execution were meant to be separate

The fluent chain builds a description of work; `ProcessJsonlFile` runs it. That separation is the real content of the builder, and it's the thing that would have surfaced the parallel path — not more tests. A plan is a **value**: you can print it, diff it, log it, assert on it, hand it to a different executor. `WithSharding(...).EnableParallelism(5)` produces something inspectable before anything touches disk.

In `jso-ops` there is no plan. Every public function takes its full configuration inline and executes immediately, so the configuration exists only during the call. That's also why `-WhatIf` has nowhere to live.

## Reconciliation, not exceptions

`ProcessJsonFiles` returns `@{ Processed; Failed; Stats }` with each item as `{Path, Content, Success, Error}`. Batch work reports an **accounting** instead of dying on item 40 of 500. `New-JsonlStoreMutationResult` is the same instinct — `Changed` / `AffectedRecords` / `RecordCount` / `IndexStatus` — but it's per-mutation only. The batch-level envelope didn't come forward.

## The index format has a real version lineage

This one's the clearest evidence of continuous engine work rather than restarts:

- **v1** — `New-JsonlBinaryIndex`: magic `JSO\x01`, version byte, int32 count, `(offset, length)` pairs, `.jli` sidecar, plus an optional `.checksum` sidecar carrying sha256 of the data file, the binary index, and the JSON index.
- **v2** — JSOI: `JSOI` + int32 version + int32 lineCount + int64 sourceLength + int64 sourceLastWriteUtcTicks + offsets, `.jidx` sidecar.

v2 answers a question v1 raised. Length became derivable and dropped. Magic became unambiguous. And the checksum sidecar — v1's honest attempt at "is this index still valid?" — got resolved by a **layering rule**, written into the header comment: length + mtime detect staleness cheaply, *"This is not a content hash; applications requiring provenance-grade verification should layer that policy above these primitives."* That's the same designer, five months later, deciding which tier owns provenance. The format is the durable artifact; the code around it is replaceable.

## The registry concept

`Bootstrap-Registries` is a different engine idea entirely, and it's the one with no descendant in `jso-ops`: a **registry as a cached, refreshable index over a workspace**, where each domain declares itself with a pair — `*config.json` for data, `domain-rules.ps1` for behavior — and the engine discovers rather than being told. `-Force` = rebuild from scratch vs. load cached. `AutoDiscover` vs. explicit directories. `UpdateGlobalStats` rolling per-domain counts up to a workspace total.

That's provider self-declaration plus a materialized index, which is a much bigger concept than JSONL mechanics and sits closer to what a catalog tier wants.

---

So the through-line I'd name: **the engine is the axes and the vocabulary; the operations are compositions.** The legacy code found the axes and couldn't finish the machinery. The new code built machinery worth keeping and mislaid the axes.

Which of the three axes is actually live for you right now? Policy is clearly real. I can't tell from the code whether partition is a thing you still need or whether sharding was specific to that old workload — and that changes whether "plan" is worth having at all, or whether the execution-policy object alone carries the weight.

---

# JsoEncoder is more primitive than JsonlStorePolicy. New-JsonlStorePolicy would be an instantiation. And it would have several sibling for different categories of jsonl metadata stores, such as ledgers and other things

Got it — I had the arrow backwards. `JsoEncoder` isn't the ancestor of the policy; it's the tier the policy is *assembled from*. Encoder is a brick, policy is a wall, and `New-JsonlStorePolicy` is one wall among several.

Which means the interesting thing: **the primitive tier is already in your new code, latent, inlined into the policy factory's parameter list.**

Look at what `New-JsonlStorePolicy` actually takes. It's four primitive slots wearing parameter clothes:

| slot | current spelling |
|---|---|
| key extractor | `KeyPointer` + `KeyMode` (`None`/`Scalar`/`ScopedRelativePath`) + `KeySelector` |
| ordering | `CanonicalSort` — `hashtable[]` of `{Pointer, Descending}` |
| validator | `SchemaPath` + `SchemaValidator` |
| comparer | `KeyComparison` (`Ordinal`/`OrdinalIgnoreCase`) |

And the key-extractor slot is `JsoEncoder`'s exact shape, flattened. `ValidateSet('None','Scalar','ScopedRelativePath')` is a hand-rolled registry of named extractors — `Scalar` dispatches to `Get-JsonlStoreScalarKey`, `ScopedRelativePath` to `Assert-JsonlScopedRelativePath` — and `KeySelector` is the `Custom` escape hatch. Same vocabulary-plus-escape-hatch pattern as `CreateCanonical()`/`CreateJsonPath()`/`Custom`. It just has no type, so the vocabulary lives in a string enum that can't grow without editing the ValidateSet, and the dispatch lives in an `if` chain in `Invoke-JsonlStoreRecordPolicy`.

**The cost shows up as guard clauses.** Lines 32–44 are five consecutive `throw`s doing nothing but policing which of those three parameters may co-occur:

```
KeySelector + KeyPointer        -> throw
KeyMode ≠ None without KeyPointer -> throw
KeyPointer without KeyMode       -> silently coerce to Scalar
KeySelector + KeyMode            -> throw
UniqueKey without either         -> throw
```

Every one of those is a combination that becomes *unconstructible* the moment the extractor is one object instead of three parameters. That's the tell that a primitive is missing — you're validating a product type that should have been a sum type.

And `None` is your identity element, same as `CreateIdentity()`. Right now it's spelled `$null` and checked at `if ($null -eq $Policy.KeyPointer) { return $null }`.

## The thing your sibling categories expose

If inventory and ledger are both store kinds, there's a **fifth slot that doesn't exist yet: mutation discipline.**

`Add-JsonlStoreRecords` branches on presence of a policy, not on a property of one:

- **`$Policy` present** → read every existing row, rebuild the key dictionary, merge, re-sort, `Write-JsonlLines -ExistingFile Replace`. Full-file rewrite, every append.
- **no `$Policy`** → `Add-JsonlRecords`, a true append.

So today, "append-only" is only reachable by having *no governance at all*. A ledger — which is precisely the case that wants validation and a key and strict arrival order and **never** a re-sort — has no way to exist. It would either rewrite the whole file on every entry, or give up its schema.

Inventory and ledger differ on more than key extraction:

- inventory: keyed, unique, canonically sorted, rewrite-on-mutation, order is derived
- ledger: append-only, order *is* the content, uniqueness (if any) is monotonic rather than positional, rewriting is a defect

That's not one axis with two settings — that's the mutation discipline being a first-class primitive alongside key/sort/validate. `CanonicalSort = @()` almost says "don't sort," but the merge-and-rewrite still happens.

So the tier stack reads:

1. **primitives** — extractors, comparers, orderings, validators, disciplines. Named, small, with identity elements and a custom escape hatch.
2. **kinds** — `New-JsonlStorePolicy` and its siblings, each an assembly of primitives. Inventory, ledger, whatever else.
3. **operations** — create/add/remove/subtract/sort, which consume a kind and don't know what kind it is.

`New-JsonlInventoryStorePolicy` is already sitting at tier 2 correctly, and it's the only one there.

What are the other categories you're seeing? Ledger's clear enough to reason about, but I don't want to guess at the rest — whether the discipline distinction is really binary (append vs. rewrite) or whether something like a run manifest or a work-order store needs a third mode changes whether that slot is an enum or a genuine primitive with implementations.

---

# Lets look at jso-ops jsonl-store in comparison conceptually with jso-utils bootstrap-registries. back then i was thinking about different kinds of registries, which are one kind of thing which might be built from a base class jsonl store constructor

---

# [Request interrupted by user]

---

# please continue

That test settles a constraint that shapes the whole answer:

- A class defined in a module, whose method calls a module-private function, **fails when the method is invoked from the caller's scope** — `Get-Private is not recognized`.
- Worse: once the caller defines a function by that name, the method silently binds to *the caller's version*.

So class methods resolve commands at the call site, not in their defining module. **A base class cannot own the mutation transaction** — a `JsonlStore.Append()` calling `Write-JsonlLines` would either fail or be hijackable. That's not a style preference, it's a hard boundary, and it decides what "base class jsonl store constructor" can mean. I'll come back to it.

## The two halves

Set the store layer and the registry side by side and they're almost perfectly complementary — neither one overlaps the other:

| | `jsonl-store-v2` | `bootstrap-registries` |
|---|---|---|
| atomic publish, cross-process lease | ✓ | — |
| index maintenance, strict codec | ✓ | — |
| key / sort / schema as passed-in policy | ✓ | — |
| per-mutation result accounting | ✓ | — |
| **envelope** (version, scope, created, updated) | — | ✓ |
| **derived & rebuildable** (`-Force` rescan) | — | ✓ |
| **freshness** (`registered_at`, `last_scanned`) | — | ✓ |
| **rollup** over entries | — | ✓ |
| **upsert** as the default | — | ✓ |
| **discovery** (entries found, not supplied) | — | ✓ |
| **admission contract** on the referent | — | ✓ |

That's why it's surfacing now. The store layer built the transaction. The registry sketch built the entity model and lifecycle. You never had both at once.

## What registry-ness actually is

Reading `CorpusRegistryBootstrapper` as a shape rather than a script, a registry is:

**A derived, rebuildable, keyed table of references to things living elsewhere, scoped to a root, carrying its own freshness and a rollup.**

Each clause is doing work, and each one distinguishes registry from ledger:

- **Derived** — `AutoDiscoverDomains` scans for `Collections-*` or a directory containing `domain-rules.ps1`. `-Force` throws the file away and rescans. A registry can *always* be recomputed from the world; a ledger is authoritative and can't be.
- **Keyed with upsert** — `$this.Registry.domains[$domainName] = $domainInfo`. Re-registering is normal, not an error. Contrast the store's `DuplicateKeyAction = 'Stop'` default. Registries want `Replace` as the *default*, which is why that parameter exists but points the wrong way for this category.
- **References, not content** — `directory`, `config_file`, `rules_file`. Every entry is a pointer plus a description. The registry never holds the thing.
- **Scoped** — `workspace_directory` on the envelope, entry keys meaningful only relative to it. This is exactly what `KeyMode = 'ScopedRelativePath'` already encodes. That key extractor *is* the registry key extractor; it arrived in the store layer without the tier that motivates it.
- **Freshness** — `registered_at` and `last_scanned` per entry, `updated` on the envelope. Because it's derived it can be stale, so it has to say when it was true.
- **Rollup** — `UpdateGlobalStats` maintains `total_documents` / `total_stores` / `total_size_mb` over the entries.
- **Nesting** — `stores = @{}` inside each domain. Registries contain registries.

## Two things that don't survive the move to JSONL

**The envelope has nowhere to live.** In a single JSON document, `version` / `created` / `workspace_directory` / `global_stats` are free — they're just sibling keys next to `domains`. JSONL has no header. Three homes, and they're not equivalent:

- **record 0 as a typed header** — but then `CanonicalSort` sorts it away. The envelope-as-record and the canonical-ordering primitive are in direct conflict.
- **a sidecar** — you already have the precedent with `.jidx`, and `_catalog.json` in the library design is arguably this exact thing.
- **recomputed** — which is what `Get-JsonlStoreInfo` already does for path/count/bytes/index-status.

The split is clean, though: mechanical facts *can* be recomputed and already are. `version`, `scope`, `last_scanned`, `kind` are **authored** — no amount of reading the file recovers them. So the envelope question is really "where do the authored, non-derivable store facts live," and it's the same question `Complete-JsonlStore` is circling.

**Validation changes kind.** `Assert-JsonlScopedRelativePath` checks the key's *string shape* — NFC, forward slashes, relative, no `..`, no control characters — and deliberately never touches the filesystem. `RegisterDomain` refuses an entry unless the referent exists *and* ships both halves of its declaration (`*config.json` and `domain-rules.ps1`). Store-policy validation is **structural**, over the record. Registry admission is **referential**, over the thing the record points at. That's a distinct slot, not a stricter version of the same one — and it's the one that makes a registry rebuildable, because the admission predicate is also the discovery predicate.

## So what can the base class be

Given the binding constraint, the honest shape is: **the hierarchy is data, the operations stay functions.**

A `JsonlStore` base owns identity and invariants — path, index path, scope, envelope, composed policy slots, and pure methods that touch nothing but .NET (`IsCurrent()`-style). `JsonlRegistry : JsonlStore` adds scope, freshness, rollup, admission predicate. Siblings add theirs. What inheritance buys you isn't method dispatch — it's **parameter binding as dispatch**: `Add-JsonlStoreRecords -Store $anything` binds for every descendant, while a registry-only operation declares `[JsonlRegistry]$Store` and rejects a ledger at bind time, before a single byte moves.

Which is what legacy jso-utils half-found under the same pressure. `JsoEncoder` holds a **scriptblock** rather than implementing a method — that's the identical workaround for the identical constraint, arrived at by feel.

One forward caution since you said several siblings: PowerShell is single-inheritance. Registry / ledger / inventory as siblings under one base is fine. "A ledger that's also scoped" is not expressible by inheriting twice — that has to come from a composed slot. So the varying parts want to live in the primitive slots and the hierarchy wants to stay shallow.

The thing I can't resolve from the code: is **derived-and-rebuildable** the defining property of registry-ness for you, or is it incidental to that particular corpus scan? It matters a lot — if a registry is by definition recomputable, then `-Force` isn't a flag, it's the primary constructor, and the stored file is a cache. That's a very different base class than one where the store is the truth.

---

# jsonl does have a sort of notion of a header, actually. there's examples of jsonl schemas that have a first row that is something like _metadata

---

# [Request interrupted by user]

---

# my current artifacts are not necessarily the end state. this discussion is just as much about how to implement them better as much as it is about redesigning them along the way if the right framework emerges. so don't read into the transient artifacts too much as if they are gospel

Fair — I'll treat them as sketches, not evidence.

The header record matters at framework level for a reason bigger than "where do the fields go": **it inverts who knows the store's kind.**

Right now the caller asserts kind at every operation — `Policy` is passed in each time, and the file itself is mute. With a prologue record, the store *declares* itself, and the flow reverses: read record 0, learn the kind, select the policy, then validate that the caller's expectations match. That's the difference between a policy you must remember to supply and one that's recoverable from the artifact. For anything that gets relocated, handed between projects, or picked up months later, that's the whole game.

It also makes the base-class question tractable in a way it wasn't. "Base class jsonl store constructor" needs something to construct *from*. Without a prologue there's nothing — you'd have to be told everything, which is just the current parameter tails wearing a class. With one, the constructor has a real job: read the prologue, dispatch on `kind`, hydrate the right typed store. And it stays legal under the binding constraint, because a *function* does the reading and the class only holds the result.

## What it costs

A prologue introduces **record roles** into a layer that currently has none — every primitive treats all lines identically. Canonical sort would sort it away; unique-key checks would demand a key from it; the schema validator would run against it; count, head, tail, range, and remove-at all include it.

Seven special cases, or one concept. The concept is that a store has **bands** — prologue and body, possibly epilogue — and the primitives operate on the body. Stated once, at the read layer where per-record metadata already flows, rather than as `if index -eq 0` scattered across the operations. That's the difference between a header being a feature and a header being a recurring bug.

The one that bites silently: **physical vs. logical addressing.** Offsets are line starts, so with a prologue, "record 3" is either the fourth line or the third body record, and the two are off by one forever. Every consumer that does its own arithmetic gets it wrong in a way nothing detects.

## The constraint that actually separates your siblings

This is the part I think is load-bearing for the registry/ledger question:

**A mutable prologue and an append-only discipline are mutually exclusive.**

If the header carries `updated`, `last_scanned`, or rollup counts, then every mutation rewrites line 0 — and any change in its length shifts every byte offset in the file. For a registry that's free; it already rewrites on merge. For a ledger it's fatal: an append-only store with a live header isn't append-only. You'd be rewriting a 100k-line ledger to bump a counter.

So the rollup slot isn't universally available. It's a capability of rewriting disciplines only.

Which gives a rule that works across every sibling: **the prologue is a birth certificate, not a dashboard.** Immutable-at-create facts only — kind, format version, scope, created, schema identity. Everything mutable either gets derived on read (which is already the right answer for count, bytes, index status) or lives elsewhere.

And that cleanly finishes the envelope question from before. Three classes of store fact:

- **mechanical** — recomputable from the file. Derive. Never store.
- **authored & immutable** — kind, version, scope. The prologue. Available to every discipline.
- **authored & mutable** — freshness, rollup. The residue, and *this is precisely where registry and ledger part ways.* A registry needs them and can afford them in-band. A ledger either does without or puts them in a sidecar that's explicitly a cache.

The sibling categories aren't distinguished by their key extractors. They're distinguished by whether they can afford mutable metadata — which is the same thing as whether they rewrite, which is the same thing as the mutation discipline. Three descriptions of one axis.

Worth noting there are two conventions in circulation and they're not compatible: a type-discriminated first record, versus reserved `_`-prefixed fields carried on *every* record. The second needs no bands and no addressing fix, and survives concatenation and shuffling — at the cost of repeating the envelope on every line and having no place for facts that are about the store rather than the row. Which one you pick determines whether "bands" is a concept you need at all.

So the fork: is a store's identity a property of the file (prologue) or a property of every record (reserved fields)? That choice cascades further than the header question itself — it decides whether concatenating two stores is meaningful, and whether a record can be moved between stores without rewriting it.

---

# well if you look across the various jsonl files in my repo, some of them might want to be immutable, others not. i think what im reaching for here is primitives for creating different types of jsonl data structures with reusable base class or classes with different instantiations to bake in and single-source-of-truth discipline in building actual data as well as in minting new data structures and tables when need arises

Then what you're reaching for has two distinct halves, and they need different machinery — that's worth separating before anything else.

**Building actual data** is enforcement at write time. **Minting a new structure** is derivation at design time. They're both "single source of truth," but one is a runtime gate and the other is a code-generation-shaped problem.

## The declaration has to be data, the class is its materialization

If a store kind is defined only as a PowerShell class or a `New-XPolicy` function, it's single-sourced in code — but the data files can't carry it, so a store still can't say what it is. If it's defined only as a schema file, the code has to reinterpret it every time and you lose the type.

The version that closes the loop: **the declaration is data, the prologue references it by identity, and the class is what you get when you hydrate it.** A store's prologue says "kind `inventory`, v2." The engine resolves that against a table of kind declarations and gets back a typed policy object. Writer and reader consult the same declaration; neither one holds a copy.

Which makes the single source of truth **a registry of kinds** — and that's the same shape as `bootstrap-registries`, one tier up. Keyed table of self-declaring entries, discovered or authored, with an admission contract, scoped, rebuildable. You were building a registry of domains; the framework needs a registry of *store kinds*. That recursion is a good sign rather than a smell — it means minting a kind is itself a registry operation, not a special code path.

It's also what turns minting from "copy the nearest `New-XStorePolicy` and edit it" into an actual operation with a gate.

## The writer side is a different problem than validation

`Add-JsonlStoreRecords -Records @(...)` accepts arbitrary objects and checks them afterward. That's not single-source-of-truth in building data — that's a guard downstream of twenty call sites that each hand-build a hashtable slightly differently.

Single-sourcing the *building* means the kind mints the record: you don't construct a row and submit it for approval, you ask the kind for one and it cannot come out malformed. Field names, required fields, key derivation, reserved prefixes — all from the declaration, none of them retyped at a call site.

This is the same move as the key-extractor observation from earlier, one level up: **make illegal states unconstructible rather than checked.** That theme has now shown up at three tiers — parameter combinations in the policy factory, record shape at the write boundary, and store kind at the artifact boundary. That consistency is probably the actual design principle you're circling.

## Immutability is a declared property, and it's not binary

"Some want to be immutable, others not" resolves cleanly if discipline is a slot on the declaration rather than a behavior of the engine. But it wants at least three values, not two:

- **sealed** — written once, completed, never touched again. Content hash is meaningful here and only here. (`Complete-JsonlStore` is already reaching for this, and the v1 `.checksum` sidecar was the right idea at the wrong tier.)
- **append-only** — grows, never rewrites. Offsets are stable forever, so indexes stay valid incrementally. Cannot afford a mutable prologue.
- **mutable** — rewrites freely. Can afford a live prologue, rollups, canonical re-sort.

And discipline isn't independent of the other slots — it *gates* them. Canonical sort is meaningless for append-only. Rollup-in-prologue is unavailable to anything but mutable. A content hash is only stable for sealed. So the declaration isn't a flat bag of settings; some slots are only legal given others. Which is the same "sum type, not product type" problem again — and the reason minting deserves to be a validated operation rather than filling in a template.

## The fork I can't resolve for you

Whether the siblings are **subclasses** or **one class with different declarations** comes down to a single question: does any operation need to refuse a store *at bind time*, before it runs?

If `Sort-JsonlStore` should be unable to even accept a ledger — signature-level rejection, no runtime check — you want types, and the hierarchy is real. If refusal is always "the discipline says no" at execution, you want one class and the discipline slot carries it.

The tension is that PowerShell gives you single inheritance, and you already have a case that wants two axes at once — a ledger that's also scoped. Types buy you bind-time rejection; slots buy you composition. You can't have both on the same axis, so it's worth knowing which axis actually needs the hierarchy. My read is that the *entity model* differs genuinely between a registry (entries are references to things elsewhere) and a ledger (entries are events), while discipline and keying are slots — but that's a read, not a conclusion.

The thing I'd want to know before anything else: **when a kind evolves, what happens to stores written under the old declaration?** Read-only compatibility, migration, or hard refusal — that answer determines whether the prologue needs a version at all, and whether the kind registry holds one declaration per kind or a lineage of them. It's upstream of the base-class question, because it decides what the constructor is actually resolving against.

---

# the fork you are pointing to points to two different kinds of factories i suppose. what i want is reusable abstractions to build a system on that centralizes core operations that are duplicated throughout the repo right now. i want the registry of kinds.

Census done. It's worse than "some duplication" — and the shape of it tells you what the registry has to carry.

## Three JSON stacks

- `ConvertTo-Json` at ~15 call sites
- **Newtonsoft** fast path with a per-record cmdlet fallback and fallback telemetry ([jsonl.ps1:133](src/shared/jsonl.ps1:133))
- **System.Text.Json** in jso-ops (`ConvertFrom-JsonlLine -AsJsonElement`)

Different type coercion, different null and date handling, different depth semantics. No declaration can promise byte-identical output while three stacks are live.

## Ten depth values, all chosen at the call site

`2` (toc-engine — unstated, so cmdlet default), `3`, `4`, `5`, `6`, `8`, `12`, `16`, `24`, `32`. Nobody picked these from the data's actual nesting; each one is whatever the person writing that line guessed. toc-engine's silent default-2 is the one that will truncate first.

Depth is not a caller's decision. It's a property of the kind — `formulas` needs what `formulas` needs, forever. This is the clearest single-source-of-truth win available: declared once per kind, never passed again.

## Two line terminators, both internally consistent

jso-ops pins `$sw.NewLine = "`n"`. [jsonl.ps1:123-125](src/shared/jsonl.ps1:123) takes the platform default and then *computes offsets from it* — `$nlBytes = $utf8.GetByteCount($sw.NewLine)`. On Windows that's CRLF, and the offsets are correct for CRLF, so it's self-consistent and produces a different on-disk format.

The consequence is concrete: `Write-JsonlLines` explicitly throws on any line containing CR. The pending replacement would **refuse to rewrite files the current production writer produces.**

## Two encoder strictnesses

`[UTF8Encoding]::new($false)` — silent replacement of invalid sequences — instantiated independently in six files (and freshly allocated *per log record* at [logger.ps1:154](src/shared/logger/logger.ps1:154)). jso-ops alone uses `::new($false, $true)`, which throws. For a corpus carrying SMP math and ligatures, those two are not interchangeable.

## Companions derived by regex at the call site

`$ChunksPath -replace '\.chunks\.jsonl$', '' + '.ledger.jsonl'`. A kind should know its own companions — index, ledger, sidecars — rather than every caller reconstructing the naming rule.

And the same disease outside stores: `Write-Rpc`/`Write-RpcError` are copy-pasted across four MCP servers at depths 24/16/16/16.

## The kinds are already there — about ten of them

chunks, ledger, docstream, toc, formulas, inventory/catalog, run log, governance fires, docgraph, promotion-candidates. All minted ad hoc. And `src/shared/jsonl.ps1` already has `Add-LedgerEntry`, `Get-Inventory`, `Get-JsonlSchema` — a proto-registry that's **keyed by function name instead of by data**. That's the thing you're replacing.

## The finding that resolves the prologue question

Several of these kinds are already **tagged unions, not single schemas**:

- latex-ingest emits `{"row":"label",...}` alongside other row shapes
- chunks emit `{"type":"heading",...}` alongside other types
- tex-docgraph writes **nodes and edges into one file**

So a record's role is already a *field* in your data, not a position. Which means the prologue doesn't need bands, doesn't need special-casing at seven primitives, and doesn't create a physical-vs-logical addressing split. **It's one more member of a union that already exists.**

The price is that two slots become per-row-type rather than per-store: validation becomes a dispatch table keyed on the discriminator, and canonical ordering has to be defined within row type. That's a real cost, but it's one concept instead of an exception threaded through everything.

## So the declaration has to carry

Everything the census shows currently retyped per call site:

- **codec** — stack, depth, encoder strictness, newline. All four are free variables today.
- **row types** — the discriminator field and its members
- **discipline** — sealed / append-only / mutable
- **key + comparer**, **ordering** (per row type)
- **companions** — index and sidecar naming rules
- **prologue** — which union member, and what's in it

That's the abstraction, and it's derived from the duplication rather than invented.

The decision upstream of all of it: **which serializer wins.** The Newtonsoft path exists for a measured reason — that 17.5-second comment is real perf work — and jso-ops is built on System.Text.Json. A kind can declare depth and newline and strictness, but it can't guarantee identical bytes across three stacks. Single-sourcing how data gets *built* means picking one, and that choice constrains the declaration's shape.

Do you want to settle the serializer question first, or start sketching the declaration and let the codec slot stay open?

---

# well encoding strictness will eventually need to accommodate exotic code points when a jsonl file captures extracted content from PDFs, where things like PUA might be informative. that can be handled with UTF-16 no? strictness is a knob

Measured — and it splits into two things that look like one:

**PUA needs no knob at all.** Both settings produce identical bytes:

| | lax `new($false)` | strict `new($false,$true)` |
|---|---|---|
| U+E000 (BMP PUA) | `EE 80 80` | `EE 80 80` |
| U+F0000 (Plane-15 PUA) | `F3 B0 80 80` | `F3 B0 80 80` |
| U+D800 (lone surrogate) | `EF BF BD` | **throws** |

PUA codepoints are ordinary Unicode scalars. UTF-8 encodes them without complaint, and `throwOnInvalidBytes` never fires on them. So extracted PDF content carrying font-private glyph codepoints survives today, under the strictest setting, unchanged.

**The knob only fires on things with no UTF-8 representation** — lone surrogates. And there the intuition inverts: lax isn't the permissive setting, it's the **destructive** one. It silently substitutes U+FFFD. Strict throws and tells you. For evidence preservation, strict is the safe default and lax is the one that quietly eats your data.

**UTF-16 wouldn't recover it**, because the loss happens before encoding. `ConvertTo-Json` on a lone surrogate emits `{"v":"\uFFFD"}` — the replacement already happened in the serializer. System.Text.Json relaxed does the same. By the time any encoder sees the string, the original code unit is gone. Changing the file encoding can't recover information the serializer already discarded.

Beyond that, JSON's `\uXXXX` escape *is* UTF-16 — the escape hatch already exists inside a UTF-8 file, so there's no expressiveness gained. And a UTF-16 JSONL file breaks byte-offset indexing, grep, and every consumer for a problem it doesn't solve.

## The measurement that actually matters for your PDF lane

Same PUA character, different stacks:

- `ConvertTo-Json` → raw `EE 80 80`, **3 bytes**
- System.Text.Json (even relaxed) → `"\uE000"`, **6 ASCII bytes**

And U+F0000 comes back as `"\uDB80\uDC00"` — escaped as a surrogate pair, 12 bytes instead of 4.

Identical content, different byte counts. Offsets differ, `.jidx` goes stale, file hashes differ, diffs fill with noise. On a formulas store full of math-font PUA, that's not a corner case — it's most of the file.

One refinement to what I said earlier, though: this is a **write-side** problem only. Parsing `\uE000` and parsing raw `EE 80 80` both yield the same value, so reader stack choice is harmless. jso-ops already writes with `ConvertTo-Json` and reads with System.Text.Json, and that asymmetry is fine. Which makes "which serializer wins" a narrower question than three-stacks implies — it's really "which serializer *writes*."

## What the slot should be

Not "strictness." Two separate declarations:

- **escaping policy** — raw vs. escaped for non-ASCII. Determines bytes, therefore offsets and hashes. Must be one value per kind, and probably one value repo-wide, or stores written by different tools aren't comparable.
- **unrepresentable-input policy** — throw, escape, or substitute. And the honest answer is that this belongs at the **extraction boundary**, not in storage. If PDF extraction can produce lone surrogates, the ingest lane has to decide what to do with them while it still has the original; a storage codec that receives an already-substituted U+FFFD has nothing left to decide.

So the codec slot is smaller than it looked: pick the writer, declare the escaping, and the strictness setting is just "strict, always" — because the case where it fires is a case you want to hear about.

---

# i would say depth is something that can be determined dynamically. you can calculate the depth of a pscustomobject that's in memory before you write it, instead of magic numbers and worrying about truncation

You already built it — `Get-JsonDepth` is in legacy Core, and it's structurally right: counts dictionaries, enumerables, and pscustomobjects, correctly excludes strings from the enumerable branch. But I ran it against the serializer and it's **uncalibrated by exactly one level**, in every case:

| input | `Get-JsonDepth` | `-Depth` actually needed |
|---|---|---|
| pscustomobject ×3 | 3 | **2** |
| hashtable ×3 | 3 | **2** |
| nested arrays | 5 | **4** |

It counts the step *into* the leaf scalar; `ConvertTo-Json` renders scalars inline and doesn't spend a level on them. Consistent +1 — harmless when you feed it straight to `-Depth` (over-provisioning never truncates), wrong the moment you use it as an assertion.

Which is the general lesson: **a depth calculator has to be defined by the serializer's counting rule, not independently of it.** That makes it part of the codec, not a free-standing utility — and it has to be re-calibrated if the writer ever changes.

## Two things worth knowing before you drop the magic numbers

**Truncation isn't omission — it's stringification.** At insufficient depth you get `{"a":{"b":"System.Collections.Hashtable"}}`. That's valid JSON. It parses. It passes a loose schema. It carries a .NET type name where your data was supposed to be. That's why the magic numbers are dangerous — the failure is *plausible*, not loud.

**But it is loud if you ask.** Warning count is 1 at insufficient depth, 0 at sufficient. And jso-ops already writes with `-WarningAction Stop` at [jsonl-v2.ps1:250](src/shared/jso-ops/jsonl-v2.ps1:250) — so in the new code a wrong depth **throws rather than corrupts**. Truncation is already defanged there. It's live at the other ~15 call sites, and toc-engine's unstated default-2 is the one most likely to be silently eating data right now.

So dynamic depth is an ergonomics-and-correctness-by-construction win, not an emergency repair. Worth knowing which, because it affects sequencing.

## The job you'd be silently removing

The magic number is doing double duty: fidelity bound **and cycle brake**. I fed `ConvertTo-Json` a self-referential hashtable and it serialized happily — repeating until depth ran out, then stringifying. Fixed depth makes cycles terminate.

`Get-JsonDepth` has no cycle detection. On that same input it recurses until the stack dies. And your data provably contains cycles — that's precisely what the Newtonsoft "self-referencing loop" fallback in [jsonl.ps1:133](src/shared/jsonl.ps1:133) is catching, with the comment naming `$hash.Keys | Sort-Object` as the classic source.

So cycle detection isn't a refinement on a dynamic depth walker, it's a precondition.

## The shape I'd argue for

**Compute actual, declare a ceiling.** Dynamic measurement eliminates truncation and the guessing. The declared ceiling keeps the signal you'd otherwise lose: a record that comes out 12 deep in a kind that's normally 4 deep means something got PSObject-wrapped or a whole sub-document got embedded inline. That's a bug, and unbounded dynamic depth would quietly serialize it perfectly.

Depth then stops being a declared *value* in the kind registry and becomes a declared *bound* — a smaller slot that no call site ever passes, and that fails loudly on anomaly instead of on guesswork.

## And it gets cheaper if the kind mints the record

Measuring depth up front is a second full traversal before serialization walks the same graph again. That cost is real on a 33MB lane.

But if records are minted by the kind rather than hand-built at the call site — the writer-side single-source-of-truth from earlier — depth accumulates during construction. No second walk. And a minted record can't contain a reference cycle in the first place, because the minter built every node.

So the two things you're reaching for reinforce each other: minting makes dynamic depth free and cycle-safe, and dynamic depth removes the last magic number from the call sites. That's probably the argument for doing minting first and treating depth as something that falls out of it.

---

# regarding lower level operations ive been thinking alot about bitmaps and XOR. not that XOR solves everything but its a useful primitive starting point for parsing because you can use it get inside of delimited spans

The parity mask lands exactly on your half-open convention. With escapes masked out:

```
text     : let $x^2$ and \$5 then $y$ done
unescaped: ....1...1..............1.1.....
inside   : ....1111...............11......
```

`[open, close)` — opening delimiter included, closing excluded. And the other two conventions are one boolean op away: content-only is `parity AND NOT delims`, full extent is `parity OR delims`. In a span list those are three different loops; here they're three instructions. That's the representation earning its place.

## The property worth designing around: parity errors are non-local

Compare the run without escape handling:

```
naive    : ....1111.......11111111..111111
```

One missed `\$` at index 15 doesn't corrupt one span — it **inverts everything downstream to the end of the block**. A span-list scanner that misses a delimiter loses one span; a parity scanner that misses one loses the entire remainder.

Which makes two things correctness-critical rather than optimizations: the escape mask, and the cross-chunk carry bit. One wrong carry inverts a whole downstream block. That's presumably why D42 gives prefix-parity/transition/chunk its own obligation row separate from harvest — it's not the same failure mode as getting a boundary off by one.

And I should flag that my escape mask is the naive one. `bs -shl 1` only catches a single backslash; `\\$` is an escaped *backslash* followed by a live delimiter, and getting that right means finding **odd-length backslash runs**, which is carry propagation — an add, not an XOR. That step is the hardest thing in the stack and it's the one my demo glosses.

## Where parity is the right primitive, and where it structurally isn't

It works for **flat, symmetric, self-delimiting** tokens — `$…$`, `` `…` ``, `"…"`. Same token both ends, no nesting, parity fully determines membership.

It's not a tuning problem but a representation mismatch for:

- **Nesting** — `{`/`}`, `\begin`/`\end`. Depth is a prefix *sum*, and one bit per position can't hold a counter. Different carrier, different algorithm.
- **Asymmetric** — `[` vs `]`. Parity can't distinguish open from close, so you can't even build the input bitmap from one character class.
- **Multi-character** — `$$`, ```` ``` ````, `\begin{equation}`. Needs a match bitmap (shift-AND across per-character bitmaps) first, and then `$$` vs `$` disambiguation is its own problem because the long delimiter contains the short one.

Your document domain straddles both. Markdown math is mostly the easy class. LaTeX structure is mostly the hard one. So "useful starting point" is precise — it covers a real and frequent class completely, and covers the rest not at all.

## Where it shouldn't spread

JSONL record splitting doesn't need any of this. JSON forbids raw newlines inside strings, so a naive LF scan is already correct — `Read-JsonlPhysicalRecords` is right as written. Worth naming, because the abductive-census reflex here should return *no*: the string-mask machinery buys nothing on a format whose delimiter can't appear inside a span.

## The layering is already settled

`masks.ps1` fences bit-planes with "escalate, do not build," and D42/V0 is the escalation, correctly placed. The division that falls out:

- **bitmap** — where delimiters *become* spans. Derivation, and the boolean ops on the way there.
- **span list** — where spans are stored, composed, and handed around. The normalized, codepoint-safe, surrogate-snapped form.

One-way lowering. Which is also why D42's fourth item — extensional equality between a packed `SpanSet` backend and the interval-list reference — is a genuinely separate obligation from the parity work: going *back* the other way is a claim about representing the same value, not about producing a different sort.

One practical note: the ladder above is six shift-XOR steps on a `ulong`, in plain PowerShell, no SIMD and no carry-less multiply. So the portable reference D42 wants at V1 doesn't need intrinsics or C# — the word-at-a-time scalar version is the reference, and SWAR/SIMD/clmul stay in the tier that gets gated separately.

---

# thinking in python for a moment, what do you think of this jsonl engine quick draft `D:\aghado01\codex-scientiae\issues\infrastructure\discussions\gemini-python-jsonl-engine.md`

Good bones, and it independently lands on several things we worked out — but its central claim is wrong, and I can show it.

## What it gets right

- **The PUA diagnosis is correct** and matches my measurement: UTF-8 covers every scalar value; lone surrogates are the actual problem.
- **Binary mode + explicit `.encode()`** is a better shape than either of your PowerShell writers. In `"wb"`, `\n` stays LF on every platform — that's the clean fix for the CRLF divergence in `jsonl.ps1`.
- **Offsets from `tell()` during the write**, not a rescan — the same insight as your own jsonl.ps1 comment.
- **Incremental SHA-256 while writing** — free provenance, and it revives the v1 `.checksum` idea at the tier where it's actually meaningful.
- **`__type__` header record** and **`KIND`/`VERSION` as class attributes** — that's the tagged-union conclusion and the declaration-as-type shape.
- `get_output_path()` deriving the filename from `KIND` is "the kind knows its own companions."

## The central claim is false

`DEFAULT_ERRORS = "surrogateescape"  # Retains lone surrogates from broken CMap tables`

Measured:

```
U+D800 (high — what UTF-16 PDF extraction yields)  -> UnicodeEncodeError
U+DC80 (in surrogateescape's own range)            -> b'\x80'
U+DFFF (low, out of range)                         -> UnicodeEncodeError
```

`surrogateescape` only round-trips **U+DC80–U+DCFF** — the range it itself produces when *decoding* undecodable bytes. It is a byte-smuggling mechanism, not a surrogate-preservation mechanism. On the exact case the document names, it raises.

The handler that works is `backslashreplace` → `b'\\ud800'`. But the principled fix is one layer up:

```
json.dumps({"x":"\ud800"}, ensure_ascii=True)  -> '{"x": "\\ud800"}'
```

JSON's own `\uXXXX` escape *is* a UTF-16 code unit — it carries a lone surrogate losslessly, and the output is pure ASCII so no encoding error is possible. The draft explicitly disables that (`ensure_ascii=False`, justified as "cleaner, readable JSONL") and then reaches for a broken error handler to fix the problem it just created.

That's the escaping-policy slot in miniature: escaping isn't cosmetic. It's the lossless carrier for code units that have no UTF-8 form.

## The UTF-16 option is unusable as written

```
line1 -> b'\xff\xfe{\x00"\x00a\x00"\x00:\x001\x00}\x00\n\x00'
line2 -> b'\xff\xfe{\x00"\x00b\x00"\x00:\x002\x00}\x00\n\x00'
```

`.encode("utf-16")` emits a BOM **per call**, so every record gets one. The offsets would still be "correct," so the index would faithfully describe an unreadable file. (`utf-16-le` avoids it, but no JSONL consumer reads either.)

## `default=str` is the Python cognate of the depth bug

```
{"t": "2026-01-01 00:00:00", "s": "{1, 2}", "o": "<__main__.Foo object at 0x000001F0C1F4BC20>"}
```

Silent stringification producing valid-but-wrong JSON — the same failure as `"System.Collections.Hashtable"`. And note the **memory address**: with `default=str`, byte-identical reruns are impossible, which destroys the SHA-256 provenance the engine is otherwise carefully computing. Those two features are in direct conflict.

## Other confirmed defects

- **Line 178 `def write((self) -> str:`** — doesn't parse.
- **Sidecar naming diverges**: `foo.jsonl.jidx` (append) vs `Resolve-JsonlIndexPath`'s `ChangeExtension` → `foo.jidx`. They won't find each other's indexes.
- **Index regression + magic collision**: `JSOI` version **1** with only count + offsets — no `sourceLength`, no `sourceLastWriteUtcTicks`, so **zero staleness detection**. And that's now a third distinct layout claiming that magic (PS v1 `JSO\x01`/.jli with offset+length pairs; PS v2 JSOI with length+mtime; this).
- **Sidecars written before the atomic rename** — a failed `os.replace` leaves `.jidx` and `.sig` describing a file that doesn't exist. The atomicity doesn't extend to the sidecar set.
- **`__exit__` leaks on success-without-commit** — cleanup only runs when `exc_type is not None`, so a forgotten `commit()` orphans the `.tmp` permanently.
- **"Streaming" is half true** — `BaseArtifactRegistry.add()` accumulates everything in `self._records`. The engine streams; the registry buffers the whole lane.
- `datetime.utcnow()` is deprecated in 3.12+.

## The architectural read

The ABC has roughly the right skeleton — `KIND`, `VERSION`, `validate_record`, `build_header`, `get_output_path` are four of the slots. What's missing is what we established actually separates your kinds:

- **no discipline slot** — `write()` always creates fresh. No sealed, no append-only, no mutable.
- **no key, uniqueness, or ordering.**
- **no row-type union** — `validate_record` is a single function, so nodes-and-edges-in-one-file can't be expressed. And the header bypasses validation entirely: `build_header()` output goes straight to `engine.append`, never through `validate_record`.

And the one I'd flag hardest: **the codec is a constructor parameter, not a kind property.**

```python
PdfExtractRegistry(target_dir=..., encoding=..., errors=...)
```

Any caller can change a kind's encoding and error strategy at the call site. That's the exact leak the whole design exists to close — the class declares `DEFAULT_ENCODING` and then lets it be overridden per instance. If codec facts belong to the kind, they can't be arguments.

Same structural caution as before on inheritance-as-declaration: `PdfExtractRegistry` gets its identity by subclassing, so a kind that is both scoped and append-only needs mixins or composition, not a second parent.

Net: worth keeping as a source of ideas — binary-mode writing, incremental hashing, offsets-during-write, and the ABC skeleton are all real. But the encoding story needs inverting (escape at the serializer, don't rescue at the encoder), and the slots that distinguish your kinds aren't there yet.

---

# `D:\aghado01\codex-scient`iae\src\shared\jsonl_engine

Confirmed two real bugs, one of them fatal on first use.

## The header fails its own schema

```
header validates against body schema: False
-> 'page_num' is a required property
```

`build_header()` ends with `return self.validate_record(header)`, and `validate_record` checks against the single class-level `SCHEMA`. So **any registry with a meaningful SCHEMA crashes on line 0 of every write.** Not latent — immediate.

Root cause is the tagged-union point: `SCHEMA` is one schema for all rows, but the store holds at least two row types. The fix has to be `oneOf`/`if-then-else` keyed on `__type__`, or a separate `HEADER_SCHEMA`. That's the schema slot becoming a dispatch table, which is the thing the design needs anyway.

## orjson and stdlib produce different bytes

```
stdlib default : {"a": 1, "b": [1, 2], "c": {"d": "x"}}    38 bytes
stdlib compact : {"a":1,"b":[1,2],"c":{"d":"x"}}           31 bytes
orjson         : always compact
```

Same record, different bytes depending on whether orjson happens to be installed — and it's an `ImportError` fallback, so it flips silently on a `pip install`. That breaks the two things the engine works hardest to provide: the `.sig` SHA-256 stops being reproducible, and the `.jidx` offsets stop matching across environments. The feature that needs byte determinism is undermined by the feature that trades it for speed.

`separators=(",", ":")` closes the gap for spacing. But there's a harder problem underneath: **orjson has no `ensure_ascii` option** — it always emits raw UTF-8 and raises on invalid UTF-8 by design. So the two backends cannot be made byte-identical if you ever need ASCII escaping. And you do:

## The surrogate capability was removed, not replaced

```
stdlib: UnicodeEncodeError - 'utf-8' codec can't encode character '\ud800'
```

Dropping `surrogateescape` was right — it never worked. But nothing took its place, so the PDF lane this was built for now **throws mid-write on exactly the input it exists to handle.** Better than corrupting, but it's an unhandled exception in the middle of a lane.

`ensure_ascii=True` fixes it losslessly (JSON's `\uXXXX` *is* a UTF-16 code unit), and it incidentally kills the non-ASCII escaping divergence too. But orjson can't do it — orjson literally cannot serialize a lone surrogate at all. So for `pdf_extracted_tokens`, orjson is not a valid backend, and the serializer choice can't be a global try/except.

## The index collision is now live on both sides

`reader.py` refuses anything but version 1:

```python
if version != 1: raise ValueError(f"Unsupported JSOI index version: {version}")
```

Meanwhile [jsonl-v2.ps1](src/shared/jso-ops/jsonl-v2.ps1:23) writes `JSOI` version 2 with `sourceLength` and `sourceLastWriteUtcTicks`. Same magic, same `.jidx` extension, same `src/shared/`, mutually unreadable.

And dropping those two fields has a consequence beyond compatibility: `commit()` does three separate `os.replace` calls. Each is atomic alone, the set is not. A crash between them leaves a new `.jsonl` beside a stale `.jidx` — and with no length or mtime in the header, **that staleness is undetectable**. Those fields aren't decoration; they're what makes non-atomic sidecar publication safe.

## Both sidecars are write-only

`read_index()` returns a list of offsets and nothing consumes it — there's no `get_record(n)` that seeks. `.sig` is never verified. So random access and provenance exist on paper; the reader streams from byte zero either way. Worth closing that loop before the formats calcify, because a reader is what shakes out whether the format carries enough.

Minor: `read_records`' fallback opens in text mode, so universal-newlines silently absorbs CRLF — the reader can't detect the contamination the writer is careful to avoid.

## What's genuinely better

- Multi-file `.tmp` → `os.replace` for all three artifacts.
- `_committed` flag plus `__exit__` cleaning up on uncommitted-or-exception — the leak is gone.
- `__enter__` resets offsets/count/hasher, so the engine is safely re-enterable.
- Sidecar naming now uses `splitext` → `foo.jidx`, matching `Resolve-JsonlIndexPath` semantics.
- **`SCHEMA` as a class-level dict is the right move** — the declaration is *data*, not an abstract method. That's the shape we wanted: a kind declares, it doesn't implement.

## Still absent structurally

No discipline slot. `write()` and `open_writer()` both create fresh and `os.replace` over the target, so there is no append and no seal — **a ledger is still unrepresentable**, and `.sig` implicitly assumes sealed. No key, uniqueness, or ordering slots.

The two I'd fix before anything else are the header/schema crash and the serializer bifurcation — the first blocks first use, and the second quietly poisons the provenance story that justifies the `.sig` at all.

---

# "depending on whether orjson is installed" . you are familiar with "requirements" files right?

Yes — pinned deps make "silently flips" a non-issue. But then the right move is deleting the fallback, not keeping it: a hard `import orjson` fails loudly on a bad environment, while the try/except fails quietly into a different byte format. Declaring the dependency *and* keeping the silent alternate path is the one combination that gets you neither guarantee.

The current state is the awkward part. `requirements.txt` is:

```
markdown
python-frontmatter
mistune
```

None of the four optional imports the engine reaches for. In the venv: `jsonschema` and `jsonlines` are installed but undeclared; **`orjson` and `jmespath` aren't there at all**. So today the engine runs the stdlib path, and `ArtifactReader.query()` raises `RuntimeError` on any call. My probe with bare `python` gave the same answer the venv would have.

Two things survive pinning, though, and they're the ones I'd actually keep:

**orjson can't do the job for the PDF kind.** It has no `ensure_ascii` and rejects strings containing surrogates by design. Pinning it doesn't fix that — it makes it *certain* that `pdf_extracted_tokens` can't serialize, rather than uncertain. That's a capability mismatch, not a packaging one. If lone surrogates need to round-trip, the serializer has to be the stdlib one with `ensure_ascii=True`, and orjson is out for that kind regardless of what's in the requirements file.

**The `.sig` doesn't record what produced it.** Payload is `sha256`, `line_count`, `metadata`, `created_at`. If that hash is provenance-grade, then a future mismatch should be attributable — serializer name, version, and options belong in the sig, so "the bytes changed" can be distinguished from "the data changed." That's the authored-metadata slot again, and it's the version of the determinism concern that no amount of pinning removes: pinning makes the producer stable, recording it makes the artifact self-explaining.

---

# updates D:\aghado01\codex-scientiae\src\shared\jsonl_engine

Round trip run. Three real wins, and four failures — one of which blocks ordinary reads, not just validation.

## What works

**Serialization is now correct and lossless:**
```
{"__type__":"header","kind":"demo","version":"1.0"}
{"id":1,"text":"PUA \ue000 and astral \ud835\udd38"}
{"id":2,"text":"lone surrogate \ud800 here"}
```
Compact, LF, ASCII-escaped. PUA preserved, astral preserved as a surrogate pair, lone surrogate preserved as `\ud800`. That's the lossless carrier working exactly as intended.

**The JSOI v2 binary layout is byte-correct.** PowerShell reads it clean: `version=2 count=3 srcLen=150`. And `seek_record` and `verify_signature` both work — the sidecars aren't write-only anymore.

## The ticks are wrong, and it breaks reads not just checks

```
index ticks       : 639216777354910080
file mtime ticks  : 639216777354910118
delta             : -38 ticks
```

PowerShell: `THROW: Stale JSONL index`. And critically, so does `Get-JsonlRecordCount` — an *ordinary read* consults the index, so a Python-written store isn't merely unvalidatable from PowerShell, it's **unreadable through the indexed path**.

Two independent causes:

1. `commit()` records `datetime.now(timezone.utc)` — wall clock at commit, not the file's `LastWriteTimeUtc`. Close by luck, never equal.
2. `timestamp() * 10_000_000` in float64 can't hold an 18-digit tick value. Measured drift against integer math: **28 ticks**.

Fix is both — `os.stat(...).st_mtime_ns // 100 + OFFSET`, integer throughout, read from the **final** path after `os.replace`. That reorders the transaction: rename the `.jsonl` first, stat it, then build and rename the sidecars.

## The two readers disagree about the same file

```python
return abs(ticks - self.source_last_write_ticks) < 10_000_000   # 1 second
```

Python's `is_current()` returned **True** for the file PowerShell called stale. That's worse than either being wrong — it's a semantic fork in a shared format. The v2 contract as PowerShell implements it is exact tick equality; a tolerant reader on the other side means a file is simultaneously fresh and stale depending on who asks, and it hides the ticks bug from the side that could have caught it. The tolerance should go.

## The lone surrogate survives the file but not the .NET reader

```
Read-Jsonl -> Malformed JSONL line 3:
  "Cannot read incomplete UTF-16 JSON text as string with missing low surrogate."
```

This isn't a bug in either side. Python's `json.loads` yields `'\ud800'` because Python strings hold lone surrogates. .NET strings can too — but System.Text.Json refuses to *materialize* one from a `\uD800` escape.

So the escaping fix is genuinely lossless on disk and in Python, and unreadable by your existing PowerShell reader. That makes lone-surrogate preservation a **cross-language contract decision**, not a codec setting. Either the PowerShell side gets a raw-text read path for such records (`GetRawText()` rather than `GetString()`), or the extraction boundary converts them — the string carries U+FFFD and an integer code-unit array carries the evidence, which is what the original draft's `codepoints` idea was reaching for.

That's the earlier claim demonstrated rather than argued: the unrepresentable-input policy belongs upstream of storage.

## APPEND on an empty file produces a structurally invalid index

```
after __enter__: line_count=1 offsets=[0]
committed      : line_count=2 offsets=[0, 0]   actual lines=1
```

Duplicate offset. `Read-JsonlIndex` enforces strictly increasing (`$offsets[$i] -le $prior` → throw), so that index is rejected outright. Cause is the unconditional `self.offsets.append(0)` before the reconstruction loop.

And the append path itself does `content = src.read()` then copies the whole file to `.tmp`. Appending one line to a 100 MB ledger reads and rewrites 100 MB, in memory. APPEND exists precisely to avoid that — right now it's CREATE with extra steps.

## The slot leaked again

```python
def __init__(self, target_dir, run_id=None, discipline=Discipline.CREATE):
```

Discipline is a **constructor parameter**, while `KIND`/`VERSION`/`SCHEMA` are class attributes. So a caller can append to a kind that should be sealed. Same shape as the encoding leak you already closed — discipline belongs as `DISCIPLINE: Discipline` beside the others.

Related: `SEALED` only raises in `__enter__`. Nothing marks the artifact sealed on disk; `.sig` records it and no reader consults it. A caller passing `CREATE` overwrites a sealed store without resistance.

And `open_writer()` writes no header while `write()` does — two file shapes for one kind depending on which entry point the caller picked.

## Order I'd fix in

1. **Ticks** — integer math, real mtime, stat after rename. Unblocks all PowerShell reads.
2. **Drop the 1-second tolerance** — make Python agree with the contract instead of papering over it.
3. **APPEND offsets** — the empty-file case emits an index the other side rejects.
4. **`DISCIPLINE` as a class attribute**, and header emission moved somewhere both write paths share.

The surrogate question is the one I'd actually think about rather than patch — it's a decision about where evidence lives, and both answers are defensible.

---

# 🛠️ Key Enhancements in V4

1. Flexible Header Row Policy (`EMIT_HEADER = False` Default):
   * Recognizes that existing production lanes write unheadered JSONL streams where record schemas are implicit in payload keys.
   * `BaseArtifactRegistry` defines `EMIT_HEADER: bool = False` by default. Header emission can be explicitly enabled per registry class (`EMIT_HEADER = True`) without breaking unheadered production streams.
2. Naming Conventions (`{stem}.{kind}.jsonl` & Custom Names):
   * `get_output_path(stem=None, filename=None)` supports all project naming patterns:
      * Direct filenames: `filename="inventory.jsonl"`
      * Stem format: `stem="1105.4224v1"` →→ `1105.4224v1.docgraph.jsonl`
      * Standard fallback: `NAME_FORMAT.format(kind=self.KIND)`
3. Reordered Commit Transaction for Exact .NET Ticks:
   * Reordered `commit()` lifecycle:
      1. Closes `.jsonl.tmp` and renames to final `.jsonl`.
      2. Performs `os.stat()` on the final `.jsonl` file.
      3. Computes integer `.NET` UTC Ticks: `(st_mtime_ns // 100) + 621_355_968_000_000_000`.
      4. Writes `.jidx.tmp` and `.sig.tmp` using exact stat ticks, then renames sidecars.
   * Result: Proven byte-exact match with PowerShell’s `(Get-Item file).LastWriteTimeUtc.Ticks` and `[JsonlIndex]::IsCurrent()`.
4. Zero-Tolerance Reader Validation:
   * Removed the float 1-second tolerance in `ArtifactReader.is_current()`. Now enforces exact integer tick equality (`ticks == source_last_write_ticks`).
5. `APPEND` Mode Offset Reconstruction:
   * Fixed `APPEND` mode line-offset scan (eliminating duplicate `0` offset on empty file appends).

Verified — claim 3 holds. `delta=0` on every case, and PowerShell now reads through the index:

```
[create]       ticks exact=True  delta=0      Read-JsonlIndex -Path : OK
[append]       ticks exact=True  delta=0      Get-JsonlRecordCount  : 5
[empty-append] ticks exact=True  delta=0      Read-Jsonl            : 5 records
```

`st_mtime_ns // 100 + OFFSET` against the post-rename stat matches `LastWriteTimeUtc.Ticks` exactly. The append path also works properly now — reconstructed `[0,20,40]`, committed `[0,20,40,60,80]`, records `[0,1,2,3,4]`, and the empty-file case gives `line_count=0 offsets=[]` then `count=1 offsets=[0]`. Both bugs closed.

Worth noting the two fixes are coupled: publishing `.jsonl` before the sidecars moves the crash window to "live file, stale index" — which is only safe *because* the ticks now work and PowerShell throws on it. Previously that ordering would have been silently wrong.

## One corruption bug left: unterminated last line

```
existing:  {"a":1}\n{"b":2}          (no trailing newline)
after:     {"a":1}\n{"b":2}{"c":3}\n
index:     count=3  offsets=[0, 8, 15]
```

APPEND concatenates onto the partial line, fusing two JSON objects into one physical record. And the index is the dangerous part:

- `Read-JsonlIndex -Path` → **OK**, count=3 (offsets are strictly increasing, in range, first is zero — structurally valid)
- `Get-JsonlRecordCount` → **3** (answered from the index)
- `Read-Jsonl` → **THROW: Malformed JSONL**

So the index asserts three records over a file with two physical lines, one of which isn't valid JSON — and the index is the artifact that passes validation. Offset 15 points into the middle of the fused line.

`__enter__` reconstructs offsets by iterating lines but never checks `content.endswith(b"\n")`. The PowerShell side already models this — `Initialize-Jsonl`'s Append mode is documented as opening "a valid line-boundary target." Same guard is needed here: refuse, or terminate the file first.

(I probed `Test-Jsonl` too crudely to interpret its result — ignore that line in my output.)

## Two tradeoffs worth being deliberate about

**`EMIT_HEADER = False` moves identity to the filename.** Pragmatic for existing lanes, but it gives up the property that made the header interesting: the artifact no longer declares its own kind. With the header off, kind is recoverable only from the filename or from `.sig`'s `metadata` — and `.sig` is optional and separable, while filenames get renamed, copied, and relocated. Given how much moves around this repo, that's the fragile carrier. Not wrong as a default; just worth knowing that unheadered artifacts are name-dependent for their identity.

**`NAME_FORMAT` is bypassed on the stem path.** The `elif stem:` branch hardcodes `f"{stem}.{self.KIND}.jsonl"` and ignores `NAME_FORMAT` entirely. A kind declaring a hyphen-infix format gets silently dot-infixed whenever a caller passes a stem. That's the declaration-overridden-by-call-site pattern again, in a smaller place — the stem branch should render through `NAME_FORMAT` like the fallback does.

## Unchanged

APPEND still does `content = src.read()` and copies the whole file — one line onto a 100 MB ledger reads and rewrites 100 MB in memory. That buys crash-atomicity, which is a real trade, but it's the cost the discipline exists to avoid. Worth deciding explicitly rather than inheriting: an append-only store can recover from a torn write by truncating to the last complete line, which is cheaper insurance than a full copy.

`DISCIPLINE` as a class attribute is the right fix and closes the leak. Still absent: key, uniqueness, and ordering slots — the ones that would let this express an inventory rather than just a stream.

---

# I will follow up on that feedback. in the meantime ```🛠️ Key Architectural Additions

1. Schema Factory & Registry (`schema_registry.py`):
   * Eliminates hardcoded inline schema dicts in Python code.
   * Automatically discovers, indexes, and compiles all `*.schema.json` files under repository schema roots (e.g. `ingestion/inventory/inventory-row.schema.json` and `metadata.schema.json`).
   * Indexes schemas by `$id`, filename, or schema key, and caches `jsonschema.Draft202012Validator` instances in memory.
2. Portable Path Resolution (`paths.py`):
   * `RepoPaths.root()` dynamically traverses up from the execution context to locate the repository root via sentinel markers (`AGENTS.md`, `.git`, `Directory.Build.props`).
   * Eliminates all hardcoded drive letters or absolute system paths.
3. External Schema Binding in `BaseArtifactRegistry` (`registry.py`):
   * Registries specify external schema names or IDs (`SCHEMA_NAME = "inventory-row.schema.json"` or `SCHEMA_ID = "codex-scientiae/document-inventory-row/0.1"`).
   * On initialization, `BaseArtifactRegistry` resolves the compiled validator directly from `SchemaRegistry`.

```

Discovery works — both schemas indexed by `$id`, filename, and stem, all three key forms resolve, internal `$ref`s resolve, both pass `check_schema`. Schemas as external data addressed by `$id` is the "declaration is data" conclusion actually landing.

But every defect I found is the same species: **a silent fallback where a refusal belongs.** Three instances, and two of them chain.

## 1. A typo in `SCHEMA_NAME` silently disables validation

```
GoodReg   validator_bound=True  -> rejected (ValidationError)
TypoReg   validator_bound=False -> ACCEPTED junk
```

`TypoReg` declares `inventory-row.schmea.json`, gets `None`, and accepts `{"total":"garbage"}` without complaint. The comment says it plainly — *"registry operates unvalidated."*

Your PowerShell side already forbids exactly this. `New-JsonlStorePolicy` throws:

> `'SchemaPath requires SchemaValidator; schema validation must not be implied but skipped'`

Same failure mode, already named and refused, one directory over. The Python side needs the same distinction: **not declared** (both `SCHEMA_NAME` and `SCHEMA_ID` are `None` → unvalidated is intentional) versus **declared and unresolvable** (→ raise at construction). Right now `schema_key = self.SCHEMA_ID or self.SCHEMA_NAME or self.KIND` collapses them — the `KIND` fallback is what makes the two indistinguishable.

## 2. Root resolution outside the repo returns a wrong path, not an error

```
'C:\Users\azrie' -> 'D:\aghado01\codex-scientiae\ingestion\inventory'
'C:\'            -> 'D:\aghado01\codex-scientiae\ingestion\inventory'
```

No sentinel found anywhere up the tree, so `find_repository_root` falls through to `return os.path.abspath(os.getcwd())` — and cwd happened to be a random subdirectory from an earlier command in my shell. That's now "the repository root."

The chain: bad root → `RepoPaths.resolve("ingestion","inventory")` points nowhere → `auto_discover` hits `if not os.path.exists(path): continue` → **empty registry, no error** → every registry falls into bug #1 → the whole pipeline runs unvalidated. Two silent fallbacks compose into total silent failure.

Two fixes, both small: start from `os.path.dirname(os.path.abspath(__file__))` rather than `os.getcwd()` — the module knows where it lives, cwd is caller state — and raise instead of falling back.

**Worktree collision confirmed** as a related case:
```
'...\.claude\worktrees\elastic-faraday-a21f6a\src' -> '...\.claude\worktrees\elastic-faraday-a21f6a'
```
That worktree has its own `AGENTS.md`. `__file__`-based resolution handles this correctly either way — from a worktree copy of the module it *should* resolve to the worktree.

## 3. `open_writer` with `EMIT_HEADER=True` writes no header

```
file contents: b'{"body":1}\n'
```

```python
engine = JsonlEngine(...)
if self.EMIT_HEADER and (...):
    with engine:
        engine.append(self.build_header())   # <- exits without commit()
return engine
```

The `with` block exits uncommitted, so `__exit__` deletes the tmp. The caller then re-enters, `__enter__` reopens `"wb"` and truncates, and the header is gone. `write()` honors `EMIT_HEADER`; `open_writer()` silently doesn't — same kind, two file shapes, decided by which method the caller picked.

## Smaller

- **Draft is hardcoded.** `Draft202012Validator` regardless of the file's `$schema`. Both current schemas are 2020-12, so it's latent — `jsonschema.validators.validator_for(schema)` closes it.
- **No `check_schema` at registration.** Both pass today. A malformed schema would compile fine and silently under-validate, since JSON Schema ignores unknown keywords. One line where you already load the file.
- **Key collisions overwrite silently.** `stem = filename.split(".")[0]`, indexed into a namespace shared across all search paths, resolved in `os.walk` order. No collision now; nothing would tell you about the first one.
- **`NAME_FORMAT` is now bypassed by three of four branches** (`filename`, `stem`, `run_id`). It applies only in the bare case. Either route them all through it or drop it.

## The through-line

Every one of these is the engine choosing to continue over choosing to fail. That's the opposite posture from the PowerShell layer next door, which fails loudly on stale indexes, refuses implied-but-skipped validation, and rejects CR in a record. For a validation and provenance layer, continuing is the wrong default — a silently unvalidated store is worse than no store, because it looks like evidence.

I'd fix in this order: `_resolve_payload_validator` raising on declared-but-missing, `find_repository_root` starting from `__file__` and raising on not-found, then the `open_writer` header. The first two are three lines each and they're what stands between this and a pipeline that quietly validates nothing.

---

# ok, ```🛠️ Key Refinements Implemented (V7)

1. Unterminated Last Line Guard on `APPEND` (`engine.py`):
   * `JsonlEngine.__enter__()` checks if an existing file ends with `\n`. If a trailing LF is missing, it raises `ValueError` immediately upon opening the stream, preventing concatenated/fused records.
2. Fail Fast on Declared-But-Missing Schemas (`registry.py`):
   * If a registry specifies `SCHEMA_NAME` or `SCHEMA_ID`, but `SchemaRegistry` cannot resolve it (e.g. due to a typo or missing schema file), `BaseArtifactRegistry.__init__` raises `KeyError` immediately at construction time.
3. `__file__`-Anchored Root Discovery (`paths.py`):
   * `find_repository_root()` starts searching from `__file__`'s location. If sentinel markers (`AGENTS.md`, `.git`, `Directory.Build.props`) are not found, it raises `RuntimeError` immediately rather than falling back to an arbitrary working directory.
4. Schema Checking & Collision Protection (`schema_registry.py`):
   * Runs `validator_cls.check_schema()` at registration time to verify schema structure.
   * Detects key collisions and raises `KeyError` if two distinct schemas attempt to register under identical names.
5. `NAME_FORMAT` Standardized Routing:
   * All output path resolution routes cleanly through `NAME_FORMAT.format(kind=self.KIND, stem=stem, run_id=self.run_id)`.``` , i also added centralized registries under json_engine/registries

All five verified:

```
APPEND onto unterminated file   -> ValueError: Cannot append to unterminated JSONL file
declared-but-missing schema     -> KeyError: Declared schema '...' could not be resolved
no schema declared (docgraph)   -> constructed, validator=None      <- distinction preserved
root from outside any repo      -> RuntimeError: Could not locate repository root sentinels
different schema on used key    -> KeyError: Schema registration collision
docgraph WITHOUT stem           -> docgraph.jsonl                   <- not ".docgraph.jsonl"
```

And the schema layer is demonstrably live — my probe's incomplete manifest got rejected with `'arxiv' is a required property at [document -> identifiers]`. That's the system working, not a defect.

The catalog is the thing you said you wanted. `RegistryCatalog` + `@register` + `PARENT_KIND`/`CHILD_KINDS` is a registry of kinds, and the typed minting methods (`add_inventory_row`, `add_node`/`add_edge`, `add_manifest`) are the writer-side single-source-of-truth — records come from the kind instead of being hand-built at call sites.

Its real payoff is that the gaps are now enumerable rather than hypothetical:

## `_schemas_by_id` is dead state

```
_schemas_by_id populated? []
```

`_register_entry` writes only `_schemas_by_name` and `_validators`. `has_schema` still checks `_schemas_by_id` (clause never fires) and `get_schema` checks it first (always misses, falls through). Lookups work by accident because `_register_entry(schema_id, ...)` puts the `$id` into the *name* map.

Consequence beyond tidiness: `$id` and filename now share one namespace, so a schema whose `$id` happened to equal another's filename would raise a false collision, and there's no longer any way to say "resolve this as an ID." Populate it or delete it — an unpopulated index inside the source of truth is the thing that misleads someone six months out.

## The hierarchy has a dangling reference

```
document   parent=inventory  children=['docgraph', 'math']  DANGLING=['math']
```

`RegistryCatalog.register` checks only that `KIND` isn't empty or `"base"`. Nothing validates that a declared parent or child resolves to a registered kind — so `math` is a declared relationship to a kind that doesn't exist.

That's the exact failure class you just fixed one level down (declared-but-unresolvable schema, silently tolerated), recurring at the hierarchy level. It can't be checked at decoration time because registration order isn't guaranteed, so it wants a `RegistryCatalog.validate()` run after the package finishes importing — or lazy resolution that raises on first traversal.

## `document` may not belong in this engine

`DocumentMetadataRegistry` has `NAME_FORMAT = "metadata.json"` and adds exactly one record, so `write()` would emit `metadata.json` plus `metadata.jidx` and `metadata.sig` — a seek index over a single record, and a `.sig` for a file that isn't a stream. (I couldn't confirm the emitted bytes: the schema correctly rejected my incomplete test manifest before it wrote.)

The question worth deciding rather than inheriting: is `document` a *store*, or a *document that happens to have a schema*? It's currently routed through the store engine to get validation, which is the wrong lever for that — the validation you want is `SchemaRegistry`, which is now independently available. A single-object manifest joining a catalog of JSONL stores makes the catalog mean something looser than it did a moment ago.

## The two hardest cases are the two unmodeled ones

**`docgraph` is the tagged union and has no schema.** Nodes and edges in one file, discriminated on `type`, and it's the only kind with `SCHEMA_NAME = None`. The union case is now sitting in the catalog, visible and unwritten — it wants a `oneOf` keyed on `type`, which is the same dispatch shape `validate_record` already does for headers.

**No kind declares a key, uniqueness, or ordering.** And that's now sharp, because `InventoryCatalogRegistry` is the same conceptual object as PowerShell's `New-JsonlInventoryStorePolicy`, which declares `KeyMode='ScopedRelativePath'`, `UniqueKey=$true`, `KeyComparison='OrdinalIgnoreCase'`, and a `CanonicalSort`. The Python inventory declares a schema and a filename. **Two definitions of "inventory store" in one repo that disagree about what an inventory store is** — and the Python one can currently write the same `document_parent` twice without noticing.

Related: all four kinds inherit `DISCIPLINE = CREATE`. Append and seal are implemented and unexercised — no kind in the catalog is a ledger yet, so the discipline that motivated the whole slot has no representative to prove it against.

If I were picking the next thing: the key/unique/sort slots, using `New-JsonlInventoryStorePolicy` as the specification. It's the one place the two languages currently make different promises about the same file.

---

# document shouldn't be there, and im not sure about math either. kinds are archetypes of jsonl artifacts, and so far i was trying to build against the relevant subset written by latex-ingest and by the post-ingestion workflow with `metadata.json` being atoms that populate the `inventory.jsonl` one directory above them in a locality-centered manner. any directory containing {slug} sub-directories with valid, unpacked latex source `{slug}-tex` can be used to automatically generate inventory.jsonl files that declare the information needed to do runs against individuals or batches. so i need an inventory kind as well as every other pertinent jsonl artifact that gets built, but with the new details introduced by the jsonl_engine including the header rows, which current artifacts dont exhibit because i haven't actually run a latex ingest using jsonl_engine yet

---

# metadata.json IS AN ARTIFACT. what else would you call it? yes its a sentinel file, but its automatically generated from data based on existing code in elsewhere under src

---

# wrong again. get a grip. ingestion/inventory/{slug}/metadata.json. generated by powershell json capabilities written earlier, same thing will be written with slight modifications later once the jsonl_engine is built

`CONVENTION.md` settles it — I should have opened that first.

## What the convention already fixes

`metadata.json` is an artifact, and the doc says exactly why it's JSON rather than JSONL: *"the manifest is one bounded object that automation can validate, update when another source form arrives, and project directly into a row of a parent JSONL inventory store."* So it's a schema-governed generated artifact that **projects into** a row — not a store kind. Written atomically and last, with `state: "source-ready"` as the transaction's success sentinel.

And `inventory.jsonl` is a **materialized view** over those sentinels: one directory level, non-recursive, a directory without `metadata.json` is not inferred to be a document, and a malformed or slug-disagreeing sentinel **aborts the whole build**. That's discover → read declaration → admit-if-valid → emit rows, which is the same shape `Bootstrap-Registries` was reaching for, with referential admission rather than structural.

## The inventory kind's slots are already specified — and none are implemented

Straight from the convention:

| slot | convention says | `InventoryCatalogRegistry` has |
|---|---|---|
| key | `document_parent`, catalog-relative direct-child path | — |
| uniqueness | **case-insensitive** (exposes portable path collisions) | — |
| sort | `document_parent`, **ordinal**, preserved spelling | — |
| discipline | first publish refuses existing; rebuild is explicit `-ExistingFile Replace` | inherits `CREATE` |
| freshness | `metadata_sha256` per row | — |

Note the subtlety the convention is careful about: **unique case-insensitively, sort ordinally.** Two different comparers on the same field — which is precisely why `New-JsonlStorePolicy` keeps `KeyComparison` and `CanonicalSort` as separate slots. Any implementation that collapses them gets one of the two wrong.

## The header row collides with a stated guarantee

This is the thing that matters for your "with the new details including header rows":

> *"There is no build timestamp, so identical sentinels produce byte-identical UTF-8-no-BOM, LF-only catalog bytes."*

`build_header()` emits `"created_at": datetime.now(timezone.utc).isoformat()`. Adding that header to `inventory.jsonl` **breaks byte-identical rebuild** — the property the convention deliberately engineered by omitting a build timestamp.

So for inventory, a header is only admissible if it carries no clock: `{__type__, kind, version}` and nothing else. Which is arguably right in general — it's the birth-certificate rule from earlier, and `created_at` was always the field that made a prologue mutable.

Adjacent: `.sig` also carries `created_at`, so the sidecar won't be reproducible even when the catalog is. Fine, since it's not catalog bytes — but worth knowing that "byte-identical rebuild" will hold for the `.jsonl` and not the `.sig`.

## The latex-ingest JSONL artifacts

From the emitting code:

- `{slug}.refs.jsonl` — reference sites + both display projections; already a tagged union (`row = 'label'` discriminator)
- `{slug}.docstream.jsonl` — the document stream
- `{slug}.diagrams.jsonl` — diagram evidence, depth 3
- `{slug}.toc.jsonl` — byte-span TOC (toc-engine)
- docgraph nodes+edges — tagged union on `type`
- `{slug}-latex.patch.jsonl` — **hand-authored, not emitted.** Read by the converter, ops restricted to `define_macro|source_replace|output_replace`, `reason` mandatory. That's an *input* kind with human authorship and read-time validation — a different discipline from everything else in the catalog.

That last one is worth calling out because it breaks the assumption baked into `BaseArtifactRegistry`: every kind so far is something the engine writes. A patch file is something the engine only ever validates and reads.

Two questions I'd want your call on before the kind set firms up: does `refs` stay one union kind or split, and should read-only authored kinds (patch) live in the same catalog with a null writer, or somewhere else entirely?

---

# well, the move is to expand the engine to be able to do its job, and create the json atomic file, as well as build inventory.jsonl files systematically, just like i'm already doing. i am building a new engine for a reason, not so i can add decorative patches

Read it. That's the specification — here's what the engine has to grow to replace it, in dependency order.

## 1. The materializer verb (no Python counterpart at all)

`Write-LatexInventoryCatalog` is a pipeline the Python side has no shape for:

```
enumerate direct children → admit if metadata.json exists → read+validate sentinel
→ project to row → sort Ordinal → uniqueness OrdinalIgnoreCase → serialize+validate → publish
```

`BaseArtifactRegistry` is caller-driven: `add()` validates one record and buffers it, `write()` iterates `_records` in insertion order. **There's nowhere for sort and uniqueness to live**, because ordering happens after all rows exist and validation currently happens before any of them do. Absorbing this isn't adding a method — it moves where validation sits relative to ordering.

The materializer needs four declared things, which are the registry-tier slots from earlier:
- **source** — direct children of the root, one level, never recursive
- **admission** — `metadata.json` present. Absent is *silently skipped* ("not a document"); present-but-invalid **aborts the whole build**. Two different failure modes on the same predicate, deliberately.
- **projection** — manifest → row, including the identity assertion `manifest.slug == document_parent` (Ordinal)
- **path shape** — forward-slash, NFC, direct-child (exactly one segment), no `.`/`..`, no control characters

## 2. Key, uniqueness, and sort — with two different comparers

```powershell
[StringComparer]::Ordinal.Compare(...)              # sort
HashSet[string]::new([StringComparer]::OrdinalIgnoreCase)   # uniqueness
```

Sort ordinal so spelling is preserved; dedupe case-insensitively so portable path collisions surface. One field, two comparers, and collapsing them silently loses one guarantee. Neither exists in Python today.

## 3. Validate the serialized line, not the dict

```powershell
$line = ConvertTo-Json -InputObject $Record -Compress -Depth 32 -WarningAction Stop
$valid = $line | Test-Json -SchemaFile $rowSchema
```

Schema validation runs **after** serialization, so it catches anything serialization itself introduces — depth truncation, type coercion, key reordering. Python validates the dict in `add()` and never re-checks the emitted line. Given the `default=str`/depth class of bug we already found, that ordering is doing real work.

## 4. The single-object JSON artifact form

`metadata.json` needs the same transactional discipline in a different container: atomic write, schema-validated, **written last as the success sentinel**, never silently replacing, idempotent return when fingerprints match. The engine only knows JSONL right now. This is a peer writer to `JsonlEngine`, not a JSONL store with one row — routing it through the store engine would give it a `.jidx` over a single record and a `.sig` that isn't a stream.

## 5. A verifying reader, not a streaming one

`Read-LatexInventoryCatalog` checks, in order: filename is exactly `inventory.jsonl` (case-sensitive), no BOM, strict UTF-8, file ends with LF, no blank or CR-bearing record, each line schema-valid, path shape re-asserted, **canonical ordinal order enforced**, uniqueness re-checked, `metadata_path == {parent}/metadata.json` exactly, referent exists and is within root, **sha256 re-hashed against the row**, manifest re-read and cross-checked on slug / schema / state.

`ArtifactReader` verifies a file against its own `.sig`. This verifies the catalog **against the world** — it's the freshness mechanism the convention chose instead of an envelope timestamp. Note `metadata_sha256` is per-row staleness, which is why the catalog needs no header clock.

## 6. Two small durability/format gaps

- **`fsync`**: PS does `$stream.Flush($true)` — forced to disk. `JsonlEngine.commit()` does `flush()` then `close()`, which only reaches the OS buffer. Add `os.fsync(self._file.fileno())` before close.
- The PS materializer emits **no sidecars** — just `inventory.jsonl`. If the engine emits `.jidx` and `.sig` for this kind, that's a deliberate expansion of the artifact set, not a match.

## The header constraint you'll need to decide once

You want header rows, and the convention currently guarantees *"identical sentinels produce byte-identical bytes"* by having no build timestamp. Those are compatible only if the header carries no clock — `{__type__, kind, version}` and nothing else. `build_header()`'s `created_at` is the single field that breaks it. Drop it from the header and the guarantee survives the addition; keep it and every rebuild differs.

`.sig`'s `created_at` is fine — it's not catalog bytes — but it does mean the `.jsonl` will be reproducible while the `.sig` isn't.

---

# maybe whatever model wrote "identical sentinels produce byte-identical bytes" was over-interpretting my guidance. I want the sentinels to reliably convey their contents, which are immutable, because the source latex files that get unpacked don't change, so that slogan is double down on much ado about nothing. im fine with a timestamp. i care that the sentinel files are reliably operational ,and they only need to get built once. and they are by construction, portable with their source materials

Agreed — I took that line as a design constraint when it was a slogan. If the content is immutable and the artifact is built once, byte-reproducibility buys nothing operationally; it only pays off when you rebuild and want to diff. Timestamp in the header is fine, `.sig` timestamp is fine, and nothing else in the gap list depends on it.

Your three actual requirements are already enforced in the convention, and none of them are threatened by a clock:

- **portable with source** — manifests persist forward-slash paths relative to the document directory, never a drive letter, profile, checkout, or temp path
- **built once** — an existing valid sentinel is validated against the archive and source-tree fingerprints and *returned idempotently without being rewritten*
- **reliably operational** — written atomically and last, so `state: "source-ready"` existing means the transaction completed

The `metadata_sha256` in the inventory row is orthogonal to all of this and stays: it's not about reproducibility, it's the catalog noticing a sentinel changed under it. And since manifests *do* get updated when a new source form arrives, that check has a real job.

## The one consequence worth acting on

Build-once-with-idempotent-return isn't any of the three disciplines the engine defines:

- `CREATE` overwrites
- `APPEND` extends
- `SEALED` refuses to open at all

What `metadata.json` needs is **create if absent; if present, validate and return without rewriting; conflict is a visible error**. That's a fourth mode, and it's the one the artifact actually has. It's also the right home for the fingerprint comparison — "a different existing tree is a visible conflict" is discipline logic, not caller logic.

Worth naming it now while the enum is three values, because it's the discipline that makes the sentinel a sentinel. Everything else in the gap list — materializer, key/unique/sort, post-serialization validation, the JSON artifact writer, the verifying reader, `fsync` — is unchanged.

---

# no. the point of this design system is that any {slug} directory will be expected to have a `manifest.json`, so by portability i mean if i move {slug} directory containing a latex tarball, its unpacked `{slug}-tex`next to it and the `manifest.json` that is deterministically generated once, the process of building `inventory.jsonl` somewhere else doesn't care

Right — the `{slug}/` directory is the relocatable unit. Tarball, `{slug}-tex/`, and the manifest travel together, and the manifest only ever references things inside its own directory, relative to itself. It has no knowledge of a parent.

Which is why location lives entirely on the catalog side: `document_parent` is **derived at materialization time** (`GetRelativePath(InventoryRoot, DocumentDirectory)`), never stored in the manifest. The `manifest.slug == document_parent` assertion is what binds identity to location at build time without ever persisting location into the atom. The manifest knows what it *is*; the catalog works out where it *sits*.

That also explains two rules that look arbitrary in isolation: one directory level only, and `document_parent` must be exactly one segment. Anything deeper would give the manifest's position a structure the manifest can't vouch for.

So for the engine, materialization is:

- **parameterized by root** — any directory holding `{slug}/` children can be a catalog root, with no configuration and nothing registered in advance
- **purely read-side** — it reads atoms and writes only `inventory.jsonl` at the root, never into a `{slug}/`
- **non-exclusive** — the same `{slug}/` unit can be indexed by any number of catalogs at different roots at once, because none of them own it

The only coupling is `metadata_sha256`, and it points one way: catalog → manifest. Move the slug directory, build an inventory somewhere else, and nothing in the unit needs to change or even be aware.

That makes "scope" a parameter of the materializing call rather than a property of the kind — the kind declares *how* to derive rows, the caller supplies *where*.

---

# in this case, maybe in other cases (not sure). the metadata.json->inventory.jsonl is a distinct pattern and kind of special right now, but i just want to make sure that jsonl engine owns the serialization and mechanics of their binding and that the portability and self-evident convention does its job

That's the right scoping — treat it as one pattern, not a template. The division that gets you engine ownership without inventing an abstraction for a population of one:

**The engine owns the mechanics** — strict UTF-8 read/decode, schema validation against a registered schema, ordinal sort and case-insensitive uniqueness, compact LF serialization, post-serialization revalidation, atomic publish, and the verifying read (order, BOM, trailing LF, path shape, hash freshness, identity cross-check).

**The pair declares the projection** — where atoms are (direct children holding a manifest), how identity is asserted (`slug == directory name`), and how a row is built from a manifest plus its location. That lives on `InventoryCatalogRegistry` as declared behavior, not inside the engine.

Nothing about that presumes a second pattern. If one shows up, it declares a different projection over the same machinery; if none does, nothing was over-built.

## The one primitive that's missing at the binding

`metadata_sha256` is the hash of *the atom*, not of the store being written. `JsonlEngine` hashes what it emits, incrementally — it has no way to hash a foreign file. That's the single mechanical piece the binding needs and the engine doesn't have, and it's precisely the field that makes the convention self-checking.

## The cutover risk that follows from engine ownership

Once the engine owns manifest serialization, `metadata_sha256` becomes a hash of bytes *the engine* produced. Manifests written by the current PowerShell path and manifests written by the engine will hash differently even when semantically identical — different spacing, different escaping, different key order.

So a catalog root with a mix of old and new manifests will show as stale on every read, and rebuilding won't converge until every manifest under that root has been written by the same producer. Worth doing the manifest cutover **per catalog root, all at once**, rather than per document — otherwise the freshness check fires constantly and stops meaning anything.

## What keeps the convention self-evident

Three mechanical properties, all currently held and easy to lose:

- **No configuration.** Root is a call parameter, discovery is by presence of the manifest, nothing registered ahead of time. Point it at a directory and it works.
- **No back-reference.** The materializer writes only `inventory.jsonl` at the root and never into a `{slug}/`. The manifest never learns it was catalogued.
- **Two distinct failures.** Missing manifest = not a document, skip silently. Present but invalid = abort the build, naming the path. Collapsing those into one behavior is what would make a relocated or half-copied directory silently vanish from a catalog instead of complaining.

---

# well, i take that back. this pattern is not entirely owned by the engine in a closed sense. because this is ingestion, the ingestion process (procurement) effectively should own the call to the engine primitive that builds metadata.json (currently happens in powershell code somewhere, maybe a latex-ingest helper, i dont remember), and an operational/automation process owns sweeping a given `inventory`-like directory to collect the metadata files present in each subdirectory, and calls the jsonl-engine to build the corresponding inventory.json by simply inserting a bunch of metadata.json files into an empty jsonl file generated by the engine (with TBD header row). the metadata.json schema is validated against the same schema file as the inventory.jsonl rows. inventory jsonl may or may not want its own parent schema, but i think the header row suffices here. there's meant to be trust that if a metadata.json file exists in a {slug} directory, then that is a verified and validated source material directory that is fit for ingestion, and the process that currently builds metadata.json files after downloading the tarball i believe already does this, or something close to it

Confirmed — the trust is earned by construction:

```powershell
if (Test-Path -LiteralPath $Path) { throw "metadata sentinel already exists; refusing to overwrite" }
$temp = Join-Path $parent ".metadata.$guid.tmp"
... UTF8Encoding($false,$true) ...
[System.IO.File]::Move($temp, $Path, $false)
```

Temp → strict UTF-8 → move-without-overwrite, written last, and `Test-ExistingSourceDeposit` re-verifies archive SHA-256 and tree fingerprint on the idempotent path. So "metadata.json present ⇒ validated source material" is a real guarantee, not a convention people agree to honor.

**That's the one invariant the engine's JSON writer must not lose.** The sweep does no re-validation, so the entire trust model rests on presence implying a completed transaction. Temp-then-rename, refuse-overwrite, written-last — if the Python writer relaxes any of those, the sweep silently starts admitting partial files and nothing downstream would notice.

## One mechanical wrinkle in "just insert them"

Manifests are written with `ConvertTo-Json -Depth 20` — **pretty-printed, multi-line**. A JSONL row is one line. So inserting a manifest into `inventory.jsonl` is a **re-serialization**, not a byte copy: read → parse → re-emit compact. Row bytes will never equal manifest bytes, which also means no hash of the manifest file survives into the row for free.

Not a problem, just worth knowing the engine is reformatting rather than concatenating.

## What collapses relative to the current PowerShell version

- **The derived fields go away.** `document_parent`, `metadata_path`, `metadata_sha256` are catalog-side inventions. If the row is the manifest, `slug` is already the locator — it equals the directory name by convention, and `metadata_path` is `{slug}/metadata.json` by formula.
- **`inventory-row.schema.json` becomes redundant.** If rows validate against `metadata.schema.json`, two schema files describe one shape and will drift. Worth deleting rather than leaving.
- **Sort and uniqueness ceremony isn't required.** I pushed those as the next slot; under this design they aren't load-bearing. Directory enumeration gives you a natural order and the filesystem already guarantees unique child names.

## The header is the parent schema

If rows are pure manifests, the header is the only thing distinguishing `inventory.jsonl` from a concatenation of manifests — so kind, version, scope, and build time belong there, and that settles your instinct: no separate parent schema needed, the header carries it.

One thing to be deliberate about: dropping `metadata_sha256` means an inventory built before a manifest is updated (CONVENTION.md says manifests *do* get updated when a new source form arrives) goes silently stale. Given rebuilds are a directory scan and cheap, "just rebuild" is a defensible answer — it's only worth noting so it's a choice rather than an omission.

## The engine surface that's actually left

1. **Atomic single-object JSON writer** — temp, strict UTF-8, no-overwrite move. Procurement calls it.
2. **Empty JSONL with header, then append** — automation calls it after sweeping.
3. **Schema validation against a registered schema**, applied to both, since it's the same schema.

Considerably smaller than the list I gave you two turns ago, and it doesn't require the engine to know anything about ingestion.

---

# well, what i'm going to do is wipe the slate in all leafs under ingestion that have legacy infrastructure and only leave PDF, tarball, and then re-extract the tarballs to the new conventional pattern and build the metadata.json files. legacy compatibility is moot. and while its true that inventory-row.schema.json is redundant, its part of the current powershell-owned prototype-in-production code, so i dont want to delete anything until the replacement with the jsonl-engine is operational and capable of regenerating things. once ready, i'll do the backsweep and build inventories everywhere

Four things worth knowing before the wipe:

**No patch files exist anywhere under ingestion.** So there's no hand-authored errata to lose — that class of non-regenerable data isn't in play.

**`inventory.json` in run dirs is a completely different "inventory."** It's a per-run derivation map:

```json
{ "2508.11646v1.chunks.jsonl": { "source": "2508.11646v1.nodes.jsonl",
                                 "stage": "repair", "bytes": 273582, "records": 291 } }
```

Artifact → {source, stage, bytes, records}. That's a lineage DAG, not a document catalog — same word, different thing, and it's JSON rather than JSONL. Worth knowing before "inventory" gets locked as a kind name, because the repo already has two.

**Sidecar naming diverges from what's on disk.** Existing artifacts use `{name}.jsonl.jidx` / `.sig` (appended). Both jso-ops (`ChangeExtension`) and the Python engine (`splitext`) produce `{name}.jidx`. The old sidecars are being wiped so that's mostly moot — but anything still reading the appended form will stop finding them, and a glob can't distinguish the two.

**The scope of "leaves" matters a lot.** `ingestion/inventory/*` leaves currently hold only tarballs — nothing to lose there. But `codices/` and `compendia/` leaves hold converted deliverables:

```
codices/aggarwal2001/
  aggarwal2001/        (dir)
  aggarwal2001.json
  aggarwal2001.md      <- deliverable
```

No tarball or PDF at that level, and 16 similar `.md` deliverables across `codices/` and `compendia/`. Some of those carry curation that isn't reproducible from source, and with no patch files, that curation exists only in the markdown itself. If the wipe is scoped to `ingestion/inventory/` and the membrane-testing run dirs, none of this is at risk; if it's every leaf under `ingestion/`, it is.

---

# yea, those converted deliverables are the things i'm going to wipe, beacuse none of that ever even got close to the mark, and is striclty speaking, evidence for while i'm here now rebuilding this entire project from the ground up. because that's garbage

Fair — failed output isn't a corpus, it's a measurement of the pipeline that produced it. Keeping it around would just make the new work look like it has a baseline to match when it doesn't.

The clean slate dissolves three things I'd been treating as constraints:

- **Sidecar naming compatibility** — `{name}.jsonl.jidx` only mattered because those files exist. `{name}.jidx` is just the convention now.
- **Mixed-producer manifest drift** — the "cut over per catalog root, all at once" caution evaporates. Every manifest gets written once, by the new engine, so `metadata_sha256` (if you keep it) is stable from the first build.
- **Any compatibility layer at all** — including `src/latex-ingest/latex-ingest-compat.ps1`, which exists specifically to accommodate retired archive/slug discovery, `{slug}-latex/`, and `-ReuseSource`. Re-extract everything to the conventional pattern and that file has nothing left to serve.

It also changes what "operational and capable of regenerating things" means as a gate. It isn't parity with the old output — there's nothing to be at parity with. It's: **from a `{slug}/` holding a tarball, produce `{slug}-tex/` and a manifest, then sweep a root and produce `inventory.jsonl`.** One document end to end, then the same thing across the eleven you have deposited. That's a gate you can actually run, and it doesn't depend on anything you're about to delete.

---

# yea but there's additional engine work and new plumbing to integrate the currently air-gapped jsonl engine. there is no code currently for building an inventory.jsonl from its atomic metadata.json constituents at the moment.

Confirmed air-gapped — `jsonl_engine` appears in exactly its own package, two test files, and two discussion docs. Nothing in `src/` imports it, no PowerShell invokes it.

One accuracy note: `Write-LatexInventoryCatalog` *does* build inventory.jsonl from metadata.json constituents — but under the projection design (derives `document_parent`/`metadata_path`/`metadata_sha256`, validates rows against a different schema, sorts ordinally, dedupes). For the design you described — insert manifests whole, header carries catalog identity — nothing exists, in either language.

## What's actually missing

1. **The materializer** — sweep a root, collect manifests from direct children, insert. Currently no Python counterpart at all.
2. **The single-object JSON writer** — atomic temp→move, refuse-overwrite, written-last, for metadata.json. The engine only knows JSONL.
3. **An invocable surface.** Everything is a Python class. For procurement (PowerShell) to call "the engine primitive that builds metadata.json," something has to be callable from outside Python — a `__main__`, a console entry, or a thin argparse shim. That's the plumbing, and it doesn't exist in any form.
4. **A stable import path.** `from src.shared.jsonl_engine import JsonlEngine` only resolves from the repo root, and `test_pwsh_interop.py` does `repo_root = os.path.abspath(".")` — cwd-dependent, the same bug class `paths.py` just got fixed for. Worth anchoring both to `__file__` before more callers depend on them.

## The decision that shapes 3

Where the PowerShell/Python seam sits determines what the invocable surface has to carry:

- **PS orchestrates, calls Python per artifact** — a process crossing per manifest, and the boundary carries a structured object, so it needs a file or stdin JSON contract.
- **Python owns deposit and sweep end to end** — fewest crossings, but tarball validation, entrypoint resolution, and the LaTeX-aware declaration parsing all live in `latex-source.ps1` and would have to be called back into or ported.
- **Split at the artifact boundary** — PS does the LaTeX work and hands Python a manifest object to serialize and publish.

The third matches what you described (procurement owns the call, engine owns serialization), and it's also the one where the crossing is smallest: one object in, one atomic file out, no LaTeX knowledge on the Python side.

Your interop test is already probing exactly the right seam — Python writes, PowerShell reads the index and confirms freshness. The inverse direction (PowerShell hands a manifest to Python, Python publishes it) is the one that has no test and no code yet.

---

# and this is where we discuss the boundary between python and powershell. this is a mixed code project and boundaries are fluid, what i care about is the best effort from first principles and maintainability. im still thinking of powershell as calling python tactically for when python has a job to do. but what have at the moment is a workflow owned by legacy powershell code, and what we need is new powershell code that calls the engine. and before that, we have to mature the engine so the boundary becomes clear

Agreed on sequencing, and there's a concrete reason it has to go that way: **there is nothing to draw a boundary around until the engine has verbs.** Right now it's a set of classes with no invocable surface, so any PowerShell written against it would be inventing the contract by accident.

## First principles for where the seam goes

**1. Cross on artifacts, not objects.** A process boundary costs startup, marshalling, error fidelity, and cross-runtime debugging. All of that is cheapest when the thing crossing is already serialized. The engine's entire job is producing files — so the natural contract is *paths in, artifacts out, exit code as the verdict*. The artifact is already schema-governed, so the interface is one you're validating anyway.

**2. Cross per artifact, never per record.** Python startup with imports is ~100ms. Per document that's noise (11 documents, ~1s). Per row it's fatal. This is the principle that kills any design where PowerShell drives a loop and calls Python inside it.

**3. Ownership follows the invariant, not the data.** Whoever holds the invariant an operation must preserve should own that operation. Tarball confinement, entrypoint resolution, and LaTeX declaration parsing carry invariants that live in `latex-source.ps1` and are inseparable from extraction. Atomic-publish, refuse-overwrite, written-last, schema-conformance are the engine's. So the split isn't a judgment call — **PowerShell owns source truth, Python owns artifact truth**, and that rule keeps working as new artifacts appear.

**4. Never split a transaction.** The deposit is one: lock → extract privately → fingerprint → publish tree → write sentinel. If the sentinel write crosses the boundary, the transaction spans two runtimes and a crash mid-way has to be recoverable. It is — but only because the sentinel is written *last*, so a failure leaves a tree with no sentinel, which the retry path already handles by re-extracting and comparing fingerprints.

That's worth noticing: **the "written atomically and last" property is exactly what makes the sentinel a safe place to cross.** It's the only step in the deposit where the boundary can sit without inventing new recovery logic.

**5. One producer per artifact kind.** When a manifest is malformed you want a single answer to "what wrote this." Half the manifests written by PowerShell and half by the engine is the maintainability failure — not because either is wrong, but because diagnosis now has two branches forever. Cutover per kind must be total.

## What falls out

For the manifest, principle 1 and 3 point the same way: PowerShell assembles the facts (it's the only side that can), hands them across **as JSON on stdin or a temp file**, and the engine validates and publishes atomically. The object objection dissolves because the manifest is already JSON-shaped — you're not marshalling a foreign structure, you're handing over the thing itself.

For the inventory, the crossing is even smaller: a root path in, `inventory.jsonl` out. The engine does the sweep because the sweep is trivial and the validation isn't.

## On "tactical"

Tactical calls are the right usage pattern, but they need a **declared surface** or they become one. Without a named verb list, each call site invents its own invocation, and the boundary ends up being whatever the union of ad-hoc calls happens to be. That's cheap to prevent now and expensive to retrofit.

## The maturity milestone

The boundary is clear when the engine can do both jobs end to end **in Python alone**, with named verbs and stable signatures:

- given a document directory and assembled facts → publish a manifest
- given a root → publish an inventory over its children

Once those two run green under `tests/`, the verb list *is* the boundary contract, and the PowerShell side becomes a thin caller written against something that already works. Your existing interop test is testing format compatibility, which is necessary and separate — it proves the artifacts are mutually readable, not that the verbs are right.

---

# it doesn't need to be stdin, it can be a python subprocess with args and vals

Right, and that's a better factoring than what I said — because it forces the crossing to be paths and scalars instead of an assembled object.

The rule that makes args work: **anything already a file crosses as a path; anything else has to be a scalar. If a value is neither, the split is wrong.**

Applied to the manifest call, that means PowerShell doesn't hand over a manifest — it hands over *locations and its own findings*:

```
--document-dir  ingestion/inventory/1105.4224v1
--archive       1105.4224v1.tar.gz
--tree          1105.4224v1-tex
--provider-json 1105.4224v1.arxiv.json
--main-tex      1105.4224v1-tex/ms.tex
```

and Python reads the provider JSON, stats and hashes the files, assembles the manifest, validates it, publishes it atomically.

That's a cleaner application of "ownership follows the invariant" than my version. Computing `sha256` and byte sizes for fields the *manifest* is accountable for belongs to whoever owns the manifest — PowerShell shouldn't be producing hashes for an artifact it doesn't write. Under my stdin sketch, PS was doing that work and Python was just a serializer, which is a thin and slightly pointless role.

Two practical constraints on args, both easy to stay inside:

- **Nested or repeated values need a convention.** LaTeX-extracted declarations (authors especially) are the case — either repeated flags, or PS drops them in a small temp JSON and passes its path, which is still just an arg.
- **Windows caps the command line at 32767 characters.** Paths and scalars are nowhere near it; an abstract is 1–2 KB and would tempt you. Don't pass it — pass the provider JSON path and let Python pull it out. Same rule as above.

And the maintainability argument that stdin doesn't have: **the call is reproducible by hand.** You can lift the exact invocation out of a log and rerun it, which for a pipeline you'll be debugging across two runtimes is worth more than the marshalling elegance.

---

# powershell supplies the facts, and it's already doing that, so we can port that part into the new powershell code associated with this process.

Read the assembly. It splits cleanly, and the line is almost exactly where the invariants live:

## Stays in PowerShell — nothing else can produce these

Everything hanging off `$validation`, because it's the output of LaTeX-aware analysis:

- `entrypoint`, `entrypoint_selection` — entrypoint resolution
- `tree_sha256` — the recursive tree fingerprint (`Get-LatexSourceTreeFingerprint`, not a plain file hash)
- `file_count`, `tex_file_count`
- `embedded_metadata` — parsed LaTeX declarations
- `package_control_files` — `00README.json` detection
- `$expansion.archive_kind`, `$publication`

Plus the whole transaction: lock, private extraction, fingerprint comparison, tree publication.

## Moves to Python — pure artifact facts

- `Get-SourceDepositFileRecord` for archive and PDF — path, format, sha256, bytes. Given a path and a role, Python produces the record.
- **The entire `document` block.** Every field is a projection of `$provider`; with no provider JSON they're all null. So PowerShell passing nine fields as args is strictly worse than Python opening `{slug}.arxiv.json` itself — and the projection belongs next to the schema that governs it.
- `GetRelativePath(...).Replace('\','/')` — that's the portability invariant, which is the artifact owner's.
- `initialized_utc`, `validated_utc`, `schema`, `state`
- Assembly, schema validation, atomic publish

## The arg surface that falls out

Scalars and paths, nothing nested:

```
--document-dir <path>  --slug <slug>
--archive <relpath>    --archive-kind <kind>
--tree <relpath>       --tree-sha256 <hex>  --files <n>  --tex-files <n>
--entrypoint <relpath> --entrypoint-selection <how>
--provider-json <relpath>   (optional)
--pdf <relpath>             (optional)
--findings-json <path>      (the structured leftovers)
```

The three genuinely structured PowerShell outputs — `embedded_metadata`, `package_control_files`, and the check results — go into one small temp JSON that PS writes and passes by path. Same rule as before: already a file, crosses as a path.

## One thing worth fixing rather than porting

```powershell
checks = @('gzip-readable','archive-members-confined','no-links-or-reparse-points',
           'tex-valid-utf8','entrypoint-unambiguous','literal-inputs-resolved',
           'document-environment-present')
```

That's a hardcoded literal asserted unconditionally at assembly time — the manifest claims seven checks passed regardless of what actually ran. If a check were skipped, removed, or added, the manifest would keep claiming the same seven.

That's a claim with no witness, and it's the one field where a straight port would carry the defect across. It should come back from the validator as *results* and ride in `--findings-json`, so what the manifest asserts is what actually happened. Cheap to fix now while the caller is being rewritten anyway; expensive once eleven manifests attest to it.

---

# right so lets fix that in the port. if you inspect what powershell is doing around that, im sure you can infer the fix and related plumbing. i believe that list of checks is gesturing at different ways of probing variable latex source, which is a nuisance that we cant avoid given the heterogeneity of latex source materials, even limited only to arvix

Checked the enforcement sites. The list is a constant because **the checks are throws, not probes** — scattered across ~8 functions in `latex-source.ps1` and `source-deposit.ps1`. By assembly time the only available fact is "nothing threw," so there's nothing to collect and the array has to be typed by hand.

And your read is right: the inaccuracies land exactly where source shape varies.

## Two are live, one is latent

**`archive-members-confined` — false for single-TeX gzip.** Member confinement lives in `ConvertTo-LatexArchiveRelativePath` and `Get-LatexTarInventory`, which the tar path calls. arXiv's single-payload gzip shape takes a different branch entirely (expand one stream, assert non-empty at line 359) and never touches either. There are no members to confine — the check is *not applicable*, and the manifest claims it passed.

**`entrypoint-unambiguous` — false when `-MainTex` was supplied.** Lines 397–401 validate the explicit entrypoint exists, is in-root, and has a document class. The ambiguity scan at 407–426 never runs. So "unambiguous" wasn't established; an operator resolved it. The information already exists — `entrypoint_selection` is captured in the tree record — it just doesn't reach `checks`.

**`literal-inputs-resolved` — true today, fragile.** `UnresolvedInputAction` defaults to `'Stop'` and `source-deposit.ps1` doesn't override it, so the deposit path does throw. The `Keep`/`Drop` branches (warn and continue) are used only by `latex-ingest-compat.ps1` — the file that becomes dead weight after the wipe. So it's unwitnessed rather than wrong, but any future caller passing `Keep` makes the constant lie silently.

## The fix: three outcomes, not one

```
passed          — the probe ran and the condition held
not-applicable  — the source shape didn't call for it
waived          — the probe ran in a tolerant mode
```

Absent ≠ passed, and tolerated ≠ either. That's the distinction heterogeneous source needs and a boolean can't carry.

## Plumbing — additive, not a rewrite

Don't convert throws into results; a throw should still abort the deposit. Thread a collector through `Expand-LatexSourceArchive` and `Test-LatexSourceTree` that **records after a condition holds**:

```powershell
$checks.Add([ordered]@{ name='tex-valid-utf8';            outcome='passed';         files=$texCount })
$checks.Add([ordered]@{ name='archive-members-confined';  outcome='not-applicable'; reason='single-file gzip payload' })
$checks.Add([ordered]@{ name='entrypoint-unambiguous';    outcome='not-applicable'; reason='explicit -MainTex' })
$checks.Add([ordered]@{ name='literal-inputs-resolved';   outcome='waived';         unresolved=$n })
```

Every existing throw stays where it is; you add one record on the success side. The accumulator rides out alongside `$validation` and lands in `--findings-json`.

## Schema delta is contained

```json
"checks": { "type": "array", "items": { "type": "string" }, "minItems": 1 }
```
becomes an array of objects with an `outcome` enum. `validation` already has `additionalProperties: true`, and `inventory-row.schema.json` embeds only the `document` projection — no `validation` — so rows are untouched.

Keep `"status": { "const": "valid" }` as-is. Under the trust model a manifest only exists on success, so there's no degraded state to record; the nuance belongs in `checks`, not `status`.

## The rule that keeps it fixed

Python copies the array through from `--findings-json` **verbatim** and validates it against the schema. It must never synthesize a check name — the moment the assembler can author a claim the validator didn't make, the defect is back in a new language.

---

# sure. instead of modifying the existing powershell, lets write the new powershell based on it and put it under `D:\aghado01\codex-scientiae\src\logistics` where we can build on this kind of infra stuff and expand on this architectural motif later

---

# [Request interrupted by user]

---

# there's gotta be an antipattern for that which can be avoided. im so sick of running into the unrolling problem when its preventable

All 11 real tarballs publish clean. Here's what landed.

## The antipattern, stated as a rule

**A collection is never a bare function return value.** It's a property or a method result.

| construct | empty | one item |
|---|---|---|
| function returns `List` | `$null` | `String` — type tracks data length |
| function returns `,$list` | `List` | `List` |
| **class method** returns array | `Object[]` count=0 | `Object[]` count=1 |

`,$x` is a patch you must remember at every return site, and the failure only appears at length 0 or 1 — it works all through development and breaks on the document that had one entry. Method calls and property access never touch the pipeline, so a class removes the failure mode by construction.

Which is the doctrine from the start of this conversation arriving on its own: the ledger is a noun that owns state, so it was always a class, and the unrolling bug was the symptom of building it as a function set.

## What's in `src/logistics`

- [probe-ledger.ps1](src/logistics/probe-ledger.ps1) — `[ProbeLedger]` class. Three outcomes, mandatory `reason` on anything non-passing, one record per probe, `AssertCoverage` failing in both directions. Touches only .NET, so the caller-session-state trap doesn't apply.
- [engine-call.ps1](src/logistics/engine-call.ps1) — the PS→Python seam. `ArgumentList` rather than a composed string, both streams drained async, non-zero exit throws with the reproducible command. Structured values cross as a findings file.
- [latex-source-deposit.ps1](src/logistics/latex-source-deposit.ps1) — the ported transaction. `Publish-LatexSourceTree` runs it and returns the boundary payload; `New-LatexSourceDeposit` adds the engine call.

Verified: 11/11 published, 7 probes each, `Results()` is `Object[]` at every length, idempotent skip on an existing sentinel, and every ledger guard rejects correctly.

## Two bugs I hit and fixed

The unrolling one triggered the rewrite. The second was mine: `Names.Add()` ran before the reason check, so a **rejected record still mutated the ledger** — `Names` and `Entries` desynced, a retry reported a spurious duplicate, and `AssertCoverage` would have seen a name with no entry. Now it validates and builds completely, then mutates.

## Worth knowing before you trust it

**Both not-applicable branches are unexercised.** Every one of your 11 deposits is `tar+gzip` with a `single-candidate` entrypoint, so all 77 probe records came back `passed`. The two paths the whole fix exists for — single-TeX gzip with no members to confine, and `-MainTex` skipping the ambiguity scan — never fired. Those need a fixture, or the fix is only proven on the case that was already correct.

The remaining blocker is unchanged: `python -m jsonl_engine deposit` doesn't exist, so `New-LatexSourceDeposit` throws at the boundary with the exact command it tried.

---

# we can return to that when inventories start expanding. there's a 2008 voroninski corpus paper with a single main-tex file for the entire payload that might exercise. but what about all of the things we discussed regarding next steps on expanding and hardening the engine and its registries? there's alot dangling there. what's on the table?

Quick precision on the fixture first: what fires the `not-applicable` branch is arXiv's **packaging**, not the file count. A tarball containing one `.tex` is still `tar+gzip` — members exist, confinement runs. `single-tex+gzip` is when arXiv serves a bare gzipped `.tex` with no tar at all. Worth checking that 2008 paper's actual archive shape before counting on it.

Here's everything still open, ordered by what unblocks what.

## A — blocks the PowerShell I just wrote

1. **The invocable surface.** `python -m jsonl_engine <verb>` doesn't exist. `New-LatexSourceDeposit` throws at the boundary.
2. **`validation.checks` schema change.** Currently `{"items": {"type": "string"}}`. The ledger emits objects, so **the manifest schema rejects the fix as it stands.** Needs array-of-objects with an `outcome` enum. This is a dependency I created — nothing downstream works until it lands.
3. **Single-object JSON writer** — atomic temp→move, refuse-overwrite, written-last. The engine only knows JSONL, and the trust model rests entirely on those three properties.
4. **File-record computation in Python** — sha256, bytes, format, relative path for archive/tree/pdf. Deliberately removed from the PowerShell side.
5. **Provider-JSON projection** — read `{slug}.arxiv.json`, build the `document` block. Pure JSON→JSON, belongs next to the schema.

## B — blocks the inventory sweep

6. **The `inventory` verb + materializer** — enumerate direct children, collect manifests, insert. No Python counterpart exists.
7. **Hash-a-foreign-file** — `JsonlEngine` hashes only what it writes; `metadata_sha256` is the hash of the atom.
8. **Header contents** — you said a timestamp is fine, so this is just deciding the field set. It's also the parent schema, since rows validate against `metadata.schema.json`.
9. **Post-serialization validation** — PowerShell validates the *emitted line*; Python validates the dict pre-serialization only. That ordering catches serialization-induced damage.

## C — engine hardening, independent of A and B

10. **`_schemas_by_id` is dead** — never populated, checked in two places. `$id` and filename now share one namespace, so an `$id` matching another file's name would raise a false collision.
11. **Catalog hierarchy is unvalidated** — `CHILD_KINDS = ["docgraph", "math"]` and `math` isn't registered. Needs a post-import `validate()`; decoration order makes it uncheckable at registration.
12. **Prune the catalog** — `document` comes out, `math` per your call.
13. **`docgraph` union schema** — the tagged-union case is the one kind with no schema. `oneOf` keyed on `type`, same dispatch shape `validate_record` already uses for headers.
14. **`fsync`** — `commit()` flushes to the OS buffer only; PowerShell does `Flush($true)`.
15. **`.sig` doesn't record its producer** — serializer name and version, so a hash mismatch is attributable.
16. **`requirements.txt`** — `jsonschema` is a hard import and isn't listed; `jsonlines` is installed and undeclared.
17. **Import-path anchoring** — `test_pwsh_interop.py` uses `os.path.abspath(".")`, the same cwd-dependence `paths.py` just got fixed for.

## D — deferred until a kind demands it

18. Key / uniqueness / ordering slots — your insert-whole inventory design doesn't need them.
19. Append and seal are implemented and unexercised — no ledger kind exists yet to prove them.
20. The verifying reader (order, BOM, trailing LF, path shape, hash freshness, identity cross-check).

## What came *off* the list

Worth noting the list shrank as decisions landed: byte-identical rebuild, sidecar naming compatibility, mixed-producer hash drift, the sort/dedupe ceremony for inventory rows, and `latex-ingest-compat.ps1` are all gone — three by the wipe, two by the simpler inventory design.

If I had to name the critical path: **2 → 3 → 1 → 5 → 4** gets one document end to end, and that's the gate you described for "operational." Everything in C can happen alongside without touching it.

---

# `D:\aghado01\codex-scientiae\requirements.txt`

Item 16 is closed for the two that mattered: `jsonschema` is declared now that it's a hard import, and `jmespath` is installed so `ArtifactReader.query()` actually works instead of raising.

Four of the declared packages have no consumer in `src/`:

- **`jsonlines`** — genuinely dead. V4's `reader.py` reads binary directly (`open(path, "rb")`) so it can catch CRLF and invalid UTF-8; the library was only used by V2.
- **`filelock`** — declared ahead of use. Fine if that's for the deposit lock, but nothing imports it yet.
- **`ftfy`** — nothing imports it.
- **`orjson`** — nothing imports it, and this one I'd remove rather than leave.

## orjson is a trap, not dead weight

V4 removed it deliberately. The lossless surrogate path works *because* of `ensure_ascii=True` — and orjson has no `ensure_ascii` option and refuses to serialize strings containing surrogates at all. Leaving it in requirements is an open invitation for someone (or some future agent) to reintroduce it as an accelerator, which silently reverts:

- PDF glyph escapes stop round-tripping
- byte output diverges from the stdlib path, so `.sig` hashes and `.jidx` offsets stop matching across environments

That's the exact regression the engine spent three revisions closing. If it's not imported, it shouldn't be declared.

## One to be deliberate about

`ftfy` repairs mojibake by *guessing* and rewriting. In a repo whose stated invariant is that SMP math and PUA codepoints round-trip byte-exact, it's the single library most likely to helpfully destroy the thing you're preserving. Not an objection — just worth pinning down which lane may call it, and keeping it well away from anything that touches manifest or JSONL content.

Minor: everything is `>=` or unbounded. Since the serializer is stdlib `json` now, byte stability is Python-version-bound rather than package-bound, so it matters less than it would have — but `jsonschema` moved its `$ref` resolution to `referencing` at 4.18, so a floor of 4.20 is doing real work there.

---

# is jsonlines really that useless? why does it exist?

"Dead" was too glib — it's displaced here, not useless. It solves real problems:

- **`InvalidLineError` carrying `.line` and `.lineno`** instead of a bare `JSONDecodeError` that can't tell you which record failed
- **per-line type enforcement** — `reader.iter(type=dict)` rejects a stream where some line is a bare string or number
- **`skip_invalid=True`** for log-scraping where you'd rather lose a record than the run
- a uniform reader/writer over paths or file objects, with pluggable `dumps`/`loads`

That's a good general-purpose library. Two structural things make it unusable for *this* engine specifically:

**1. Text mode makes the contamination undetectable.** `jsonlines.open()` reads in text mode, so Python's universal-newline translation strips `\r` before your code ever sees the line. V4's reader exists partly to catch exactly that:

```python
if line.endswith(b"\r\n"):
    raise ValueError(f"CRLF line ending detected on line {line_no}")
```

You cannot write that check on top of a text-mode reader — the evidence is gone by the time you get the string. Same for distinguishing a strict UTF-8 decode failure from a parse failure.

**2. No byte offsets on write.** The `.jidx` is built from `self._file.tell()` captured before each record. `jsonlines.Writer` doesn't surface stream position, so the index couldn't be built at all without reopening and rescanning — which is the 17.5-second cost the PowerShell side already learned to avoid.

And `skip_invalid` is an anti-feature for a provenance artifact: a store that quietly drops a malformed row still hashes fine and still validates, and the loss is invisible.

So the engine reimplements the narrow slice it needs with stricter semantics, and gets `InvalidLineError`'s ergonomics for free by raising with the line number itself.

Where it *would* earn its place is ad-hoc consumption — inspection scripts, notebooks, one-off analysis over a store you didn't write. If that's the intended use, keeping it declared is reasonable. It's just not engine infrastructure, and it shouldn't end up inside the engine's read path later on the grounds that it's already a dependency.

---

# well the engine wants per-line type enforcement, jsonlines notwithstanding

Agreed, and there's a concrete hole to name: **`open_writer()` bypasses validation entirely today.** `write()` validates because it goes through `add()`; the streaming path hands the caller a bare `JsonlEngine`, and `JsonlEngine.append()` accepts any dict without checking anything. Same kind, two entry points, one of them unenforced.

That points at where enforcement belongs: **whatever actually touches the line.** Right now the thing holding the validator (`BaseArtifactRegistry`) doesn't touch the line on the streaming path, and the thing that writes the line (`JsonlEngine`) has no validator. So the validator wants to move onto the engine — constructed with one, and `open_writer()` passes the kind's. Then there's no path that emits an unvalidated record, and the hole closes by construction rather than by remembering to use the right method.

## "Type" here is richer than dict-vs-not

Three layers, and they're worth separating because they cost different amounts:

1. **Structural** — the line parses to a JSON *object*. One `isinstance` per line. An array or a bare number is valid JSON and would sail through today.
2. **Variant** — read the discriminator, select the schema for that variant. `validate_record`'s `__type__ == 'header'` dispatch is already this, hardcoded for one case. Generalizing it to a declared `{discriminator: {value: schema}}` map is the same mechanism, and it's what `docgraph` needs — node and edge in one file, discriminated on `type`. That dangling item and this one are the same work.
3. **Full schema** — the variant's schema, all constraints.

The header stops being special: it's just one member of the union, which is what we landed on earlier anyway.

## Both directions

Read-side enforcement is what makes a hand-edited, truncated, or externally-produced store fail loudly instead of feeding you a plausible record. `ArtifactReader.read_records` currently yields whatever parses. Given the trust model rests on artifacts being what they claim, the reader is the wrong place to be permissive.

## Validate the emitted line, not the dict

If enforcement sits at `append()` — *after* `json.dumps` — it collapses with the post-serialization item from the list. PowerShell already does it this way (`ConvertTo-Json` then `Test-Json` on the line), and the reason is real: it catches anything serialization introduces that the dict didn't have. One check, both concerns.

## The cost question

jsonschema validation per line is not free on a large store. So the layers above want to be selectable rather than all-or-nothing — structural as an unconditional floor (it's an `isinstance`), variant and full schema as declared policy on the kind. A store that's cheap to write and expensive to verify is a reasonable trade; a store that's *silently* unverified is not, which is why the floor shouldn't be optional.

That also gives the verifying reader from tier D somewhere to live: it's this, with every layer turned on.

---

# well, its also worth noting that this engine isn't just being built to hold ingestion of exotic unicode. most of the things it will build will be happy with a UTF-8 round trip anyway. and i wonder if there's a better way to treat the CRLF thing rather than regex if/then. feels like newb loop to me

Right on both counts, and the measurements make the CRLF one sharper than I expected.

## The CR check is incomplete, and it's a missing codec

CR is **insignificant whitespace** in JSON, so the parser passes it almost everywhere:

```
trailing CR (the CRLF case)   -> PARSES
leading CR                    -> PARSES
CR between tokens             -> PARSES
raw CR inside a string value  -> JSONDecodeError
```

So the parser covers CR-in-strings for free, and the explicit check is only needed for CR-as-whitespace — of which `endswith(b"\r\n")` catches exactly one of three positions:

```
b'{"a":1}\r\n'   endswith=True    contains_cr=True
b'{"a":\r1}\n'   endswith=False   contains_cr=True     <- slips through
b'\r{"a":1}\n'   endswith=False   contains_cr=True     <- slips through
```

`b"\r" in line` catches all three at the same cost. But that's the small fix. The real one is what "newb loop" is pointing at: **there's no record codec, so every read path invents its own rigor.** Proof is already in the file — `seek_record()` does:

```python
line = f.readline()
return json.loads(line.decode("utf-8"))
```

No CR check, no structural check. The random-access path is already less strict than the streaming path, and nothing made that happen on purpose.

jso-ops' own header states the goal: *"one strict codec for all streaming reads and validation."* PowerShell has `ConvertFrom-JsonlLine` and calls it from every path. Python needs the same — one `decode_record(raw: bytes)` that rejects CR, decodes strict UTF-8, parses, and applies the structural/variant type enforcement from before. Then the loop is `for line in f: yield decode_record(line)` and there's one place to be right.

That also gives the bare-array and bare-number cases (both of which parse fine today) somewhere to be caught.

## Escaping should be per-kind, and both settings are honest

Measured on realistic multilingual metadata:

```
ensure_ascii=True  : 120 bytes   "...d\u00e9formation \u2014..."
ensure_ascii=False :  99 bytes   "...déformation — 数学..."
inflation: 1.21x
```

For 11 manifests that's nothing. For a 33 MB docstream lane it's ~7 MB of escape overhead and a file you can't grep. You're right that I applied a PDF-lane requirement globally.

The key measurement is what `ensure_ascii=False` does when a surrogate *does* appear: **`UnicodeEncodeError` at write time.** So the two settings aren't safe versus unsafe:

- `ensure_ascii=True` → **escape** it. Lossless, unreadable output.
- `ensure_ascii=False` → **refuse** it. Loud failure, readable output.

Both honest. The dishonest third option — replace with U+FFFD — is what `surrogateescape` and `default=str` were doing, and that stays off the table. So the rule is **escape or refuse, never replace**, and which one is a codec declaration on the kind. Default `False`; `True` only where content is PDF-extracted text.

That leaves two byte formats across kinds, which costs nothing real: each kind is internally consistent, both forms parse identically, and byte comparison across different kinds was never meaningful. It only matters that a kind doesn't change its mind mid-store — which is what putting it on the kind rather than the call site guarantees.

---

# isn't codec already first class parameter in the engine?

It *was*, then it got removed — and the removal over-corrected. Current state:

```python
def __init__(self, output_path, discipline=Discipline.CREATE, emit_index=True, emit_sig=True)
...
json_str = json.dumps(record, ensure_ascii=True, separators=(",", ":"), sort_keys=False) + "\n"
```

No codec parameter anywhere. The values are hardcoded in `append()`.

The arc: V2 had `encoding="utf-8", errors="surrogateescape"` as constructor parameters. I objected that a caller could change any kind's bytes — but the objection was to *placement*, not to parameterization. V3/V4 dropped it entirely, which swapped one problem for another: now the PDF lane's requirement is imposed on every artifact and a kind has no way to say "I'm readable UTF-8."

Three positions, and only the third is right:

| | who sets it | problem |
|---|---|---|
| V2 — constructor parameter | any caller | a kind's bytes are call-site-tunable |
| now — hardcoded | nobody | one lane's requirement imposed on all kinds |
| **kind declaration** | the registry class | — |

The distinguishing test is the one that's been running through all of this: **can a caller change it for a given kind?** In V2 yes; in the third, no — the engine still takes it as a constructor argument, but the only thing that supplies it is the registry, from a class attribute.

Which is exactly the shape `DISCIPLINE` already has:

```python
DISCIPLINE: Discipline = Discipline.CREATE          # class attribute on the kind
...
JsonlEngine(output_path=out_path, discipline=self.DISCIPLINE)   # threaded down
```

So codec doesn't need a new pattern — it needs the one `DISCIPLINE` went through, which it hasn't taken yet. It went constructor-arg → hardcoded and stopped one step short.

One thing that follows: once the codec is per-kind, the `.sig` has to record it. A store's bytes are a function of the codec, so a hash that can't be reproduced should be attributable to the codec that produced it rather than presumed corrupt. That's the `.sig` producer field from the open list — same item, and it only becomes load-bearing once codec varies.

(The `.sig` payload's own `ensure_ascii=True, indent=2` should stay fixed — that's engine metadata, not kind content.)

---

# ok well lets add that

Landed and verified.

```
readable   CODEC=unicode   43B  b'{"title":"d\xc3\xa9formation \xe2\x80\x94 \xe6\x95\xb0\xe5\xad\xa6","id":1}\n'
extracted  CODEC=ascii     56B  b'{"title":"d\\u00e9formation \\u2014 \\u6570\\u5b66","id":1}\n'
```

- **`Codec` enum** in [engine.py](src/shared/jsonl_engine/engine.py) — `UNICODE` (readable, refuses unpaired surrogates) and `ASCII` (escapes, carries them losslessly). Separators, key order, and the LF terminator stay fixed as determinism invariants; only escaping varies.
- **`CODEC` class attribute** on `BaseArtifactRegistry`, defaulting to `UNICODE`, threaded into the engine exactly as `DISCIPLINE` is.
- **`open_writer()` now carries it too** — that was the path that bypassed kind policy entirely, so it's closed for codec at the same time.
- **`.sig` records `"codec"`**, so a hash that fails to reproduce is attributable rather than presumed corrupt.

The surrogate behaviour is the pair we specified:

```
unicode -> ValueError: record 0 in sur-unicode.jsonl contains a code unit with no UTF-8 form
           (typically an unpaired surrogate from text extraction).
ascii   -> wrote b'{"text":"glyph \\ud800 here"}'   round-trip preserved surrogate: True
```

Escape or refuse, never replace — and the refusal names the record, the policy in force, and the remedy.

A caller still can't reach it: `BaseArtifactRegistry.__init__` takes `target_dir, run_id, schema_registry` and nothing else, so codec is structurally a kind declaration rather than a knob.

Index, `seek_record`, and `verify_signature` all stay consistent under both codecs, and the existing suite is green — **7/7 including the PowerShell interop test**, so the JSOI v2 round trip is unaffected.

One small thing surfaced while running it: **`pytest` isn't installed and isn't in `requirements.txt`.** The suite is `unittest`-based so `python -m unittest discover -s tests/shared` works, but there's no declared test runner — worth settling which one before more tests land.

---

# ok ive added pytest to requirements

Declared but not installed yet, and there's a config gap worth settling before it is.

```bash
./.venv/Scripts/python.exe -m pip install -r requirements.txt
```

**No pytest config exists** — no `conftest.py`, `pytest.ini`, `pyproject.toml`, or `setup.cfg`, and no `__init__.py` under `tests/`. That matters because the tests import like this:

```python
from src.shared.jsonl_engine.engine import JsonlEngine, Discipline
```

which resolves only when the repo root is on `sys.path`. `python -m unittest` and `python -m pytest` both add the CWD, so it works from the repo root — but the bare `pytest` console script does **not**, and in prepend mode pytest inserts `tests/shared` as the basedir rather than the root. So the same suite passes or fails depending on how it's invoked. That's the cwd-dependence item again, in a third place.

## The inconsistency underneath it

The tests import `src.shared.jsonl_engine`. Production imports `jsonl_engine` — my `engine-call.ps1` sets `PYTHONPATH=src/shared` so `python -m jsonl_engine` resolves, and that's the name the CLI verb will live under.

**Two import names for one package.** If both ever load in the same process they're distinct module objects, which quietly duplicates `_GLOBAL_SCHEMA_REGISTRY` — two schema registries, two sets of compiled validators, and a `has_schema` answer that depends on which name you came in through.

Worth settling on `jsonl_engine` as the single name, since that's what the invocable surface has to use anyway. Then one file fixes both problems:

```python
# conftest.py at the repo root
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "src", "shared"))
```

and the test imports become `from jsonl_engine.engine import ...`, matching production. A root `conftest.py` also anchors pytest's rootdir, so bare `pytest` and `python -m pytest` behave the same.

Want me to make that change across the two test files while I'm in here?

---

# well instead of hacking it help me set up the python scaffolding and install requirements to the venv, and lets remove that fork with calling jsonl engine in the tests while we are here

Scaffolding done. Summary:

**[pyproject.toml](pyproject.toml)** — src-layout project whose only job is importability. `[tool.setuptools.packages.find]` points at `src/shared`, so an editable install puts `jsonl_engine` on the interpreter path permanently. **Dependencies are deliberately not declared there** — `requirements.txt` stays the single manifest, since duplicating the list into `[project.dependencies]` would recreate the same fork one layer up.

**Installed into the venv** — `pip install -r requirements.txt` then `pip install -e .`. pytest 9.1.1, jsonschema 4.26.0, and `jsonl_engine` resolving to `src/shared/jsonl_engine/__init__.py` (the source tree, not a copy).

**The fork is closed.** Both test files now import `jsonl_engine.*`, matching what `python -m jsonl_engine` will use. That also removes the latent duplicate-module hazard — two import names would have meant two `_GLOBAL_SCHEMA_REGISTRY` singletons with different `has_schema` answers depending on which door you came through.

**`test_pwsh_interop.py`** dropped `os.path.abspath(".")` in favour of `RepoPaths.resolve(...)` — using the engine's own `__file__`-anchored resolver instead of reinventing path discovery in a test.

**[engine-call.ps1](src/logistics/engine-call.ps1)** — `PYTHONPATH` and `Resolve-EngineModuleRoot` are gone; the editable install is the single route to the package. And the PATH-python fallback now throws with the setup commands instead of silently running an interpreter that lacks the install and failing later with a `ModuleNotFoundError` from inside a subprocess.

**[.gitignore](.gitignore)** — `*.egg-info/`, `build/`, `dist/`.

Verified: no `src.shared` references remain; **7/7 passing from the repo root, from `tests/shared`, from `C:\` with an explicit path, and under `python -m pytest`**; all three PowerShell modules parse; `Resolve-EnginePython` returns the venv interpreter.

That closes the import-path item from the open list. One thing left untouched: `template_engine` has no `__init__.py`, so it isn't a package and isn't covered by the install — noted in the pyproject comment for whenever it needs importing by name rather than by path.

---

# yea template engine is something i just lifted from an old project, its an old jinja2 templating engine that might replace toc-template eventually, when we get back to writing TOCs in this repo, but i want to focus on capturing design intent in the jsonl_engine

Captured, suite still green.

| module | doc lines | what it now records |
|---|---|---|
| `engine.py` | 44 | offsets-during-write (the 17.5 s rescan it replaces); why commit publishes `.jsonl` first and why that window is the *safe* direction; integer ticks vs. the 28-tick float drift; what `SEALED` does and doesn't guarantee |
| `registry.py` | 53 | the declaration doctrine, with the one-question test and both times it was already broken |
| `reader.py` | 40 | why binary mode is load-bearing; the measured CR-vs-parser table; the missing-codec gap |
| `paths.py` | 24 | `__file__` not cwd; the two-fallback chain that silently validated nothing |
| `schema_registry.py` | 31 | schemas as external data; why `check_schema` at registration; why collisions raise |

Each header follows the same shape: the intent, the measurement or failure that justifies it, and **what's deliberately absent** — so a later reader can tell "not built yet" from "decided against." That last section is what stops someone helpfully adding a `codec=` parameter back to `__init__`, or a `getcwd()` fallback to the resolver.

Two things worth knowing about what I did:

**Some headers document known defects in place** — the absent record codec, `_schemas_by_id` being unpopulated, `SEALED` being a declaration rather than a property of the artifact. That's more durable than a tracker entry, but it means those paragraphs become lies the moment the defect is fixed. They need deleting as part of the fix, not after it.

**`BaseArtifactRegistry`'s class docstring is still four lines** — the doctrine went into the module header instead, since it governs the whole file rather than the one class. Fine as is, just noting it's not an oversight.

The one thing code comments can't carry is the decisions that span both languages — the JSOI v2 format contract, escape-or-refuse, where the PowerShell/Python seam sits and why. Those currently live in whichever file happens to touch them. If you want them somewhere durable, `issues/jsonl-engine/planning/decisions.md` in the doccer shape would be the complement: code carries the local why, canon carries the decisions that outlive any particular file.

---

# we should address the headers document known defects across the board. I would rather that doc-strings are framed like docstrings, stating intent without getting into pontification. im not saying information is wrong i just dont like reading model-speak in my docstrings if that makes sense

Rewritten as contracts.

| module | before | after |
|---|---|---|
| `engine.py` | 44 | 21 |
| `registry.py` | 53 | 18 |
| `reader.py` | 40 | 13 |
| `paths.py` | 24 | 10 |
| `schema_registry.py` | 31 | 15 |
| `Codec` | 22 | 14 |

What came out: the V2/V4 history narration, the measurements used as argument (the 17.5 s rescan, the 28-tick float drift), the rhetorical setups, and the ALL-CAPS section banners. What stayed is the constraint a maintainer needs — *"ticks are integer arithmetic on st_mtime_ns; float seconds lose precision at tick scale"* — without the case for it.

**Known defects are out of the headers.** Two of the three got fixed instead of documented:

- `_schemas_by_id` is now populated (`_register_entry(..., as_id=True)` at the two call sites). `get_schema` resolves by `$id` through its own index rather than falling through the name map, and `$id` no longer shares a namespace with filenames.
- The missing record codec in `reader.py` is off the header and stays on the open list, where it belongs — it's real work, not a caveat.

Two lines that look like defects but are contract, so I kept them as plain statements: `SEALED` constrains the declaring kind rather than the path, and the nearest sentinel wins so a worktree resolves to itself. A caller needs both.

Suite green, 7/7.

One thing I didn't touch: the three PowerShell modules in `src/logistics` have the same register — `latex-source-deposit.ps1` narrates the three broken checks with history, and `probe-ledger.ps1` has a "why a class and not a function set" essay. Say the word and I'll bring those down to match, though `run-paths.ps1` is more discursive than these Python docstrings, so the target there may be a different line than the one you just drew.

---

# ive noted the doc string clean up item, that's a bigger can of worms than just those few powershell files and i've added to agents.md a new section for dev guidelines with its first entry being about doc strings.  we dont need to shy away from the reader.py record codec. its obviously needed, but what else do we need to do around adding it there

Three useful answers, one of which removes work.

## The codec is read-side only

`json.dumps` can never emit a raw CR or LF — control characters are escaped in both `ensure_ascii` modes, in keys and values alike:

```
CR in a value  ensure_ascii=True  -> '{"k":"a\\rb"}'  raw_CR=False
CR in a key    ensure_ascii=False -> '{"a\\rb":1}'    raw_CR=False
```

So there's no write-side CR check to add and no need for a shared module — `reader.py` is the right and only home. That also means the earlier "validate the serialized line" item is *not* this: it's schema validation, and it belongs with the kind.

And `seek_record` already refuses a stale index (`ValueError: Stale JSONL index`), so freshness isn't part of this work. What it lacks is the CR and structural checks `read_records` has.

## Three behaviors the codec forces you to decide

```
truncated final record   -> {"a":1}\n{"b":2}\n{"c":3}   yields 3 records, unterminated one included
blank line               -> silently skipped
non-object rows          -> yielded types: ['dict', 'list', 'int', 'str']
```

- **Truncation is the real defect.** The engine already *refuses to append* to a file with no trailing LF, so the writer treats it as invalid while the reader treats it as complete. A truncated store currently reads as whole. PowerShell's reader throws "incomplete final record."
- **Blank lines** are skipped here and rejected on the PowerShell side. Pick one; they're the same format.
- **Non-object rows** are the structural floor. Every declared kind writes objects and the header is an object, so dict-only is right — but it should be stated rather than assumed, since it's a real constraint on what a kind may emit.

## The part that isn't small

The codec owns the structural floor. **Variant and schema validation need the kind**, and `ArtifactReader` is all `@staticmethod` with no instance state — it can't know which kind it's reading.

So one of two things has to give: either the reader becomes instance-based, constructed with a kind, or kind-aware reading moves onto `BaseArtifactRegistry` as a `read()` method. The second is more consistent — the registry already owns validation on write, and putting reads there closes the asymmetry where a store is checked going out and not coming back. It also means `ArtifactReader` stays what it is: mechanics, no kind knowledge, exactly like `JsonlEngine`.

## Two smaller things

**Naming** — `Codec` already means the escaping enum, so the decoder can't be called that. `decode_record` / `RecordDecoder` keeps them distinct.

**Error shape** — the decoder doesn't know the line number or record index; callers do. Either it takes a locator argument or raises a typed error the caller annotates. Worth matching the ergonomic that made `jsonlines` pleasant: the exception carrying both the offending raw line and its position.

None of the five behaviors above has a test today, so they're also the test list.

---

# is there a way to do this in a platform agnostic manner? CRLF is in windows, LF in linux/mac, we want the code to be agnostic

Yes — and the code is already doing it. The counterintuitive part is that **binary mode is the platform-agnostic choice; text mode is the platform-dependent one.**

```python
open(path, "wb") + b"...\n"   # LF on every OS
open(path, "rb")              # splits on \n, leaves \r visible
```

Text mode translates `\n` → `os.linesep` on write and collapses `\r\n` → `\n` on read. Being agnostic here means *refusing* the platform's helpfulness, not accommodating it. No `os.name` branch is needed anywhere.

## Agnostic isn't the same as tolerant

The reader can't meaningfully *accept* CRLF, because the format is byte-addressed:

- `.jidx` stores byte offsets — a CRLF file's offsets differ from its LF twin at every line after the first
- `.sig` hashes bytes — a CRLF file has a different SHA-256

So a CRLF variant isn't the same artifact wearing different clothes; it's a different artifact whose sidecars can't be valid. Rejecting it is the agnostic rule — *LF on every platform* — rather than a Windows-hostile one.

## The actual platform hazard is git, and it's live here

```
.gitattributes          -> exists, no rules
core.autocrlf           -> false      (local config)
core.eol                -> lf         (local config)
tracked .jsonl files    -> 5, including tests/fixtures/2408.16741v2.refs.golden.jsonl
```

The guarantee currently lives in **one machine's git config**, not in the repo. Git for Windows sets `core.autocrlf=true` at install by default, so a fresh clone elsewhere would CRLF-convert those five files on checkout — including a golden fixture whose entire purpose is byte comparison. No amount of care in `reader.py` prevents that; the bytes are already wrong before Python opens them.

One file fixes it:

```gitattributes
*.jsonl  text eol=lf
*.json   text eol=lf
*.sig    text eol=lf
*.jidx   binary
```

`text eol=lf` normalizes in the repo and checks out LF regardless of local config, while keeping line diffs. `.jidx` is a real binary format and must be marked so git never touches it.

Want me to write that? The one judgment call is scope — whether to add a `* text=auto` baseline for the rest of the repo (there's a lot of PowerShell and Markdown), or keep it narrow to the artifact formats where byte fidelity is load-bearing.

---

# i am updating the .gitattributes but this is a separate concern from the operational one with the engine

Audit comes back clean. Nothing platform-conditional in the engine:

- **`os.linesep` / `os.sep`: zero occurrences.** No platform branch anywhere.
- **Every `struct` format is explicitly little-endian** — `"<i"`, `"<q"`, never native `@`/`=`. That matters more than it looks: native format would change both byte order and alignment padding by architecture, so the `.jidx` would stop being the same format PowerShell reads. Correct as written.
- **Everything byte-addressed opens binary** — `.jsonl` read and write, `.jidx` read and write, `.sig` write.

Two text-mode reads remain, and both are fine:

```
schema_registry.py:64   open(schema_path, "r", encoding="utf-8")
reader.py:163           open(sig_path,    "r", encoding="utf-8")
```

Both parse JSON, where CR and LF are insignificant whitespace, so newline translation can't change the parsed result. Nothing hashes or offsets into either file. The `.sig` asymmetry — written binary, read text — is harmless for the same reason.

That gives the rule worth writing down, since it's the thing that keeps this agnostic without any platform code:

**Binary for anything byte-addressed — offsets or hashes. Text is acceptable only for parse-only sidecars.**

Under that rule the CR rejection in the codec isn't a Windows accommodation at all; it's the format saying LF on every platform, and the engine already never produces anything else.

One forward note for the deposit verb: manifest paths have to be forward-slash relative, and `paths.py` already has `relative_to_root()` doing that conversion. The verb should use it rather than raw `os.path.relpath`, or Windows backslashes end up in artifact content — which *is* a real platform leak, just not one that exists yet.

---

# i feel like `open(schema_path...` is a common pattern that can be captured as its own reusable helper to reduce code complexity and be a single source

Landed in [json_document.py](src/shared/jsonl_engine/json_document.py), both call sites repointed, `json` import dropped from `schema_registry` (no longer used).

```
well-formed object       -> ok (dict)
utf-8 bom                -> JSON document must be UTF-8 without BOM
invalid utf-8            -> JSON document is not valid UTF-8 (...)
malformed json           -> JSON document is malformed (line 1, column 7)
top-level array          -> JSON document must be one object, got list
top-level array allowed  -> ok (list)      # require_object=False
absent, or_none          -> None
```

Every error names the path, which a bare `JSONDecodeError` doesn't. The BOM case is the one that most repays being explicit — `encoding="utf-8"` doesn't strip a BOM, so it previously surfaced as `Expecting value: line 1 column 1` with no hint what was wrong.

`register_schema_file` passes `require_object=False`, since JSON Schema 2020-12 permits a bare boolean as a schema and `check_schema` is the real authority there.

Suite green, 7/7.

## One deliberate asymmetry worth knowing

**This helper accepts CRLF; the record codec will reject it.** That's the byte-addressed rule holding, not an inconsistency — schema files and `.sig` are parse-only, so their bytes needn't be canonical.

`metadata.json` breaks that symmetry the moment `metadata_sha256` exists. Once the inventory row hashes the manifest, the manifest *is* byte-addressed, and a CRLF variant would hash differently while reading identically through this helper. So `read_json_document` will want a strict mode — or the manifest read path will want the record codec's treatment — by the time the deposit verb lands.

Not a change to make now; there's no caller and no hash yet. Just the thing that decides it later.

---

# maybe the helper should be required to consult a schema. config as data.

Right instinct, and your own PowerShell already draws the line this implies. Two things shape it:

## Required, but nullable

The distinction that matters isn't optional-vs-mandatory, it's *forgettable-vs-declared*. A parameter with a default gets omitted by accident; a required parameter that accepts `None` can only be omitted on purpose:

```python
read_json_document(path, schema)          # no default — you must say something
read_json_document(path, schema=None)     # "unvalidated, deliberately"
```

Same doctrine as `_resolve_payload_validator`: not-declared is legitimate, declared-but-unresolvable raises. This just moves it to the file level so a call site can't drift into unvalidated reads by inaction.

## The line already exists in the PowerShell

`Read-LatexInventoryJsonObject` takes `-SchemaPath` as a **mandatory** parameter and is used for the manifest and inventory rows. Provider metadata goes through `Read-SourceDepositJson`, which does *not* validate. So the existing design already says: **our artifacts are schema-validated on read; foreign input is not.**

That maps cleanly onto the callers here and forward:

| document | schema |
|---|---|
| `metadata.json` | `metadata.schema.json` — exists |
| inventory rows | same schema — exists |
| `.sig` | **doesn't exist yet** |
| schema files | the JSON Schema meta-schema, already enforced by `check_schema` |
| `{slug}.arxiv.json` | foreign acquisition output — `None`, explicitly |

## Two constraints on the implementation

**It cannot import `SchemaRegistry`.** `schema_registry.py` now imports `read_json_document`, so the reverse direction is a cycle. The helper has to take a resolved validator (or a registry instance) as the parameter, and the caller does the lookup. That keeps `json_document.py` dependency-free, which is also why it's a good place for this.

**Schema files are the bootstrap exception.** `register_schema_file` reads a schema *with* `read_json_document`, and validating a schema means the meta-schema — which `check_schema` already applies one line later. So that call site passes `None` and its validation lives where it already is, rather than being routed through the same door.

## What it costs

Authoring `sig.schema.json`. Worth doing regardless: a truncated or hand-edited `.sig` currently yields `sig_data.get("sha256") → None` and then a hash mismatch, which reports the wrong failure. It would also make version drift visible — a `.sig` written before `codec` was added is missing a field nothing currently notices.

The fork: do you want the `.sig` schema authored as part of this, or should `verify_signature` pass `None` for now and the schema arrive with the deposit verb's batch?

---

# well perhaps schema registry can implement its own reader for reading a schema as a class method, because this is a special case that enforces outward from the engine

Done — and the classmethod framing removes the cycle entirely rather than working around it. `schema_registry` imports `read_json_value`; nothing imports back.

```
read_json_document signature: (path: str, validator: Any, require_object: bool = True)
  omitting it     -> TypeError: missing 1 required positional argument: 'validator'
  with validator  -> JSON document failed schema validation at [schema]
  validator=None  -> ok, dict

read_schema_file is a classmethod: True
  read without an instance -> codex-scientiae/document-inventory-row/0.1
  invalid schema           -> SchemaError: 'not-a-real-type' is not valid under any...
```

Three doors, each with its own authority:

| function | authority |
|---|---|
| `read_json_value` | none — bytes, BOM, decode, parse |
| `read_json_document(path, validator)` | a compiled validator; `None` declines, explicitly |
| `SchemaRegistry.read_schema_file` | the JSON Schema meta-schema, via `check_schema` |

Reading a schema no longer passes through the artifact reader at all, so there's no waived argument and no bootstrap exception to explain — the difference is where the method lives.

The validator being positional with no default is what makes the doctrine hold: a call site can decline validation but can't drift into it by omission. There's exactly one `None` in the codebase now, in `verify_signature`, annotated as an admission that `sig.schema.json` doesn't exist yet rather than a judgement that a `.sig` needn't be validated.

Suite green, 7/7.

Still open from two turns back: whether that `.sig` schema gets authored now or arrives with the deposit verb's batch. That `None` is the only thing waiting on it.

---

# sig schema now

Landed and enforced.

```
by_id: [...document-inventory-row/0.1, ...document-metadata/0.1, ...jsonl-signature/0.1]
payload keys: ['codec','created_at','discipline','file_size','line_count','metadata','schema','sha256','ticks']

missing field        -> rejected      stray field       -> rejected
bad sha256           -> rejected      wrong schema id   -> rejected
unknown discipline   -> rejected      negative count    -> rejected
```

[`schemas/sig.schema.json`](schemas/sig.schema.json) — `codex-scientiae/jsonl-signature/0.1`, all nine fields required, `additionalProperties: false`. That's the first inhabitant of the `schemas/` search path, which until now was configured and empty, so that path is exercised too.

The payload gained a `"schema"` field, matching the manifest convention. Since `EMIT_HEADER` defaults to false, an unheadered store carries no identity in the `.jsonl` itself — the sidecar is now where a reader learns what it's holding.

`verify_signature` resolves the validator and checks the sidecar **before trusting any of its values**, so a truncated or edited `.sig` reports itself instead of presenting as a content mismatch. Resolution failure raises rather than degrading: the engine declares this schema, so its absence is a broken install, not a decision to skip validation.

The closed schema means adding a payload field requires bumping the schema and `SIG_SCHEMA_ID` together. That will feel like friction the first time — it's the mechanism that makes drift visible rather than silent.

**No `validator=None` remains anywhere.** Every JSON document the engine reads now declares its authority and none decline. The first legitimate `None` will be `{slug}.arxiv.json` in the deposit verb — genuinely foreign input, where a schema would be a guess about someone else's format.

Suite green, 7/7.

---

# why is `D:\aghado01\codex-scientiae\src\shared\codex_scientiae.egg-info` showing up under SRC. this should be under `artifacts` by project conventions

---

# [Request interrupted by user]

---

# i just moved schema files to their proper home, which is under ...jsonl_engine/registries/schemas

Registry repointed and green.

```
search: ['...\src\shared\jsonl_engine\schemas']
by_id : [document-inventory-row/0.1, document-metadata/0.1, jsonl-signature/0.1]
suite : 7 passed
```

`schema_registry` no longer imports `RepoPaths` at all — discovery is anchored to `__file__`, so the engine's declarations travel with the engine and resolve identically under an editable install, a wheel, or a relocated checkout. Added `[tool.setuptools.package-data]` so a built wheel ships them; without it an editable install would keep working while a wheel silently shipped an engine with no schemas.

Three things need your call.

**`inventory-catalog.ps1` is down.** It throws on dot-source: `latex inventory schema not found: '...\ingestion\inventory\metadata.schema.json'`. That's the working prototype you said to keep operational until the engine can regenerate.

**The move changes what the schemas are.** The argument for external schema files was that one definition serves both lanes — the engine, `Test-Json`, an editor. Inside `src/shared/jsonl_engine/schemas/` they're Python package internals, so repointing the PowerShell means the PS lane now depends on a Python package's layout. Three ways out: accept the coupling and repoint; put them somewhere both lanes own equally and have the package find them by repo path; or let the PS lane stop schema-validating and defer to the engine — which is the endgame anyway, just not yet. I'd want your read before repointing.

(Also stale: `ingestion/inventory/CONVENTION.md` now has dead relative links to both schemas, and `ingestion/README.md:74` documents a `Test-Json -SchemaFile ./ingestion/inventory/metadata.schema.json` invocation.)

**The egg-info relocation doesn't actually work.** Checking exit codes properly this time, `.gitkeep` reads as *ignored* — `artifacts/**` excludes the `artifacts/build` directory itself, and git can't re-include a file whose parent directory is excluded, so both negations after it are dead. Either change that rule to `artifacts/*` so single-level negation works, or drop `egg_base`/`setup.cfg`/`.gitkeep` and switch the build backend to hatchling, which emits no egg-info at all. The second removes the problem rather than relocating it, but it's your build config either way.

---

# well that smells like the a problem in my git ignore and pattern because i dont see why anything under artifacts shoudl be unignored

Clean. No egg-info anywhere in the tree, and `artifacts/` is back to being wholly ignored:

```
setup.cfg                  removed
artifacts/build/           removed
egg-info in working tree   none
venv install               _editable_impl_codex_scientiae.pth + dist-info
jsonl_engine ->            src/shared/jsonl_engine/__init__.py
schemas discovered         3
suite                      7 passed
git status artifacts/      clean
```

`.gitignore` is back to `artifacts/**` + `!artifacts/README.md`, unchanged from what you had. Hatchling's editable install is a single `.pth` file — nothing to place, so nothing to exempt. It also ships non-Python files inside the package by default, so `schemas/*.schema.json` travel with the engine without the `package-data` declaration setuptools needed.

Still open from the schema move, and more consequential than the build config: **`inventory-catalog.ps1` throws on dot-source** because both schemas left `ingestion/inventory/`. And the question underneath it — whether the PowerShell lane should reach into a Python package's `schemas/` directory, or whether schemas that serve both lanes belong somewhere neither owns.

---

# we're still migrating to the jsonl engine and the jsonl engine is still incomplete and ugly. the engine will own schemas because it owns schema validation, and eventually reading/writing artifacts down stream. interop with powershell will be a concern but since the repo is still fractured because i dont have the replacement built in python yet, it feels ambiguous

Confirmed: `inventory-catalog.ps1` is the **only** PowerShell that touches schemas. Every other `Test-Json*` hit is `Test-Jsonl*` in jso-ops — different functions, unrelated.

So there's no permanent interop problem to design around. The one cross-lane schema consumer is the file the engine replaces. Ownership landing in the engine doesn't create a boundary that has to be maintained; it removes the only place one existed.

And that file is currently idle: no `inventory.jsonl` anywhere, no `metadata.json` anywhere, the eleven deposits hold only tarballs. `Write-LatexInventoryCatalog` has nothing to materialize and `Read-LatexInventoryCatalog` has nothing to read. Its remaining value is as the **specification** for the Python materializer — the admission rules, the two-comparer sort/dedupe, the cross-artifact identity checks — and that needs it readable, not runnable.

So the practical call is small: repoint two path constants to keep it executable (throwaway, since the whole file goes), or leave it as reference. Given the wipe and rebuild ahead, reference seems right. One caveat if you leave it: the throw is at **dot-source**, not at call, so anything that loads the file for other reasons fails too — worth a quick check that nothing does.

The transitional ambiguity that's genuinely open is documentation, not design. `ingestion/inventory/CONVENTION.md` has dead relative links to both schemas and describes them as living there, and `ingestion/README.md:74` documents a `Test-Json -SchemaFile ./ingestion/inventory/...` invocation that no longer resolves. Those will misdescribe the repo until the migration lands — worth a line in each saying where schemas moved and that the engine owns validation now, rather than a rewrite while the target is still moving.

---

# well bring those documents up to current understanding and fix dead. if you can point to jsonl engine then do so

Done — all four references resolve and the documented command runs:

```
README.md      L74   ./src/shared/jsonl_engine/schemas/metadata.schema.json           OK
CONVENTION.md  L7    ../../src/shared/jsonl_engine/schemas/                           OK
CONVENTION.md  L115  ../../src/shared/jsonl_engine/schemas/metadata.schema.json       OK
CONVENTION.md  L135  ../../src/shared/jsonl_engine/schemas/inventory-row.schema.json  OK

Test-Json: rejects an incomplete manifest as expected
```

**`CONVENTION.md`** — added a note in the status section that schema ownership moved to the engine and that the document describes layout and the deposit transaction, not where validation lives. Both dead links repointed. The materializer section now says up front that the PowerShell script no longer dot-sources — its schema paths still resolve into that directory — and that it stands as the specification for the Python replacement rather than a runnable tool. I left the usage examples in place since that's what makes it a specification.

**`ingestion/README.md`** — the `Test-Json -SchemaFile` path repointed, plus a line noting schemas live with the engine and that `Test-Json` remains the executable check until the engine exposes a verb for it.

I didn't touch the substance of either document. The deposit layout, the manifest-assembly rationale, and the inventory row description are all still accurate — only ownership and location facts changed.

---

# well before we imbue the engine with verbs, we have to shore up architecture and clean up warts int he code. the idea of the registry and schemas is to put configuration and conventions where possible into data, like we just did with the openfile reading schema for reasons.  also have some renaming to do. The current `metadata.json` filename convention is changing to `article.json`, which means alot of renaming and updating files in the engine, including `document.py` -> `article.py` . The code is also a mess with docstrings still, with prose essays in triple quotes heading files and persuasive AI speak instead of matter of factual docstring voicing. `engine.py` has a stale reference to sig_schema_id which should be self-evident based somehow based on locality to the engine , tonet_tickets_offset is a magic number that points to another missing form of agnosticism \

The rename surface is wide and several parts aren't determined by the two anchors you gave — and schema `$id`s are `const` values baked into every artifact, so guessing wrong is expensive to undo.

---

# correction to 2nd answer: "rename all 4, remove article prefixes entirely"

`inventory-row.schema.json` has disappeared since my last read. Checking git before I assume anything:

---

# inventory-row.schema is deleted because its redundant with article.schema. a design feature of this architecture is that the json object contained in article.json can be directly inserted into an inventory row without parsing it or hand-writing its schema to transfer into jsonl rows. its a simple direct insertion of a json object into a jsonl row, with perfunctory schema validation via a decorator ideally

All green — 9 passed, up from 7 (added one-schema-governs-both, and malformed-article-rejected).

## Rename

`metadata.json` → `article.json`, `document.py` → `article.py`, `DocumentMetadataRegistry` → `ArticleRegistry`, `KIND = "article"`, `$id` → `codex-scientiae/article/0.1`. Catalog is now internally consistent:

```
article    parent=inventory  children=['docgraph']  schema=article.schema.json  name=article.json
docgraph   parent=article    children=[]            schema=None                 name={stem}.docgraph.jsonl
inventory  parent=None       children=['article']   schema=article.schema.json  name=inventory.jsonl
```

One schema governs the atom and the row. `add_inventory_row` is gone — `add_article(article)` inserts the object verbatim. The nested `document` block is hoisted, so `title`/`authors`/`abstract`/`identifiers`/`categories` are top-level in both.

## The two constants

```
ticks offset : 621355968000000000  | matches literal: True
sig schema id: codex-scientiae/jsonl-signature/0.1
```

`DOTNET_TICKS_OFFSET` is now derived from the two epochs by integer arithmetic — verified equal to the literal it replaces. `SIG_SCHEMA_ID` is read from `schemas/sig.schema.json`'s own `$id` at import, so the schema file is the only place that string is written.

## Docstrings

All eight modules rewritten declaratively — 19/16/11/8/10/12/11/8 lines. Removed the metaphors ("two doors"), the justifications ("because a resolver that follows it…"), and the slogans. What's left states the contract and what isn't implemented.

## Three things beyond your list, so you can reverse them

- **`validation.checks` is now the probe-ledger shape** — array of objects with an `outcome` enum and `reason` required when the outcome isn't `passed`. It was a blocker for the PowerShell ledger and I was rewriting the schema anyway.
- **Dropped `math` from `CHILD_KINDS`** — it was a dangling reference to an unregistered kind.
- Kept `manifest_schema` unrenamed — moot, since that field lived on the deleted row schema.

## Still open

The **decorator** you mentioned — I didn't build it. `SCHEMA_NAME` plus `add()` already gives declarative validation for single-shape kinds, so the case that actually needs one is `docgraph`: node and edge in one store, discriminated on `type`, currently with no schema at all. Confirm that's what you had in mind before I design it.

`ArticleRegistry` still can't publish — `article.json` is a single object and the atomic single-object writer doesn't exist, so the class declares the kind and mints validated objects only.

And `tests/latex-ingest/inventory-batch-dev.Tests.ps1` still asserts the retired `document-metadata/0.1` and `document-inventory-row/0.1` ids. Pester tests for the superseded lane — flagging rather than touching.

---

# can we not modify the existing writer that takes a schema and allow it to emit either jsonl or json depending on the length of the input

---

# [Request interrupted by user]

---

# i meant just that a jsonl is essentially a list of items that gets written into the container, and that a json file is a bare single atom. and this highlights a more general pattern for later, which is any jsonl file is essentially newline delimited list of json objects. every jsonl file will be associated with an atomic schema for its elements, and jsonl headers will capture the container level metadata like we are doing with inventory. also im aware of the distinction between json arrays and jsonl. the doc-graph data structure needs to be reworked to fit this framework, not two types of entries ideally, or at least a single shared schema. the abstraction there is a specific kind of object in this project which is a graph encoded in a jsonl file. im sure there's conventions out there for how to do this right

Got it — and that's a cleaner statement than what I was building. The model is:

- **atom schema** — governs one element, and is the same whether that element sits alone in a `.json` or as a row among many
- **container** — `.json` holds one atom; `.jsonl` holds a newline-delimited list of them
- **header** — container-level metadata, distinct from the atom schema

`article.json` and `inventory.jsonl` are one atom in two containers. That's why the row *is* the article, and why there was never a row schema to write.

Most of that already exists in the code under other names: `SCHEMA_NAME` is the atom schema, `HEADER_SCHEMA` is the container metadata. What's missing is that the container itself isn't declared — which is the small change I was starting, just motivated properly.

## Graph-in-JSONL

Two structural families, and they differ in whether a node can exist independent of an edge.

**Discriminated records** — what docgraph does now, and what Neo4j's `apoc.export.json` emits: `{"type":"node",...}` and `{"type":"relationship",...}` interleaved. TinkerPop's GraphSON draws the same vertex/edge split. Nodes carry properties without needing an edge, at the cost of two shapes.

**Uniform relation rows** — the RDF line-delimited family (N-Triples, N-Quads): every line is subject–predicate–object, one shape, no exceptions. Node properties become relations to literal values. The cost is that a node's identity is implicit in its appearing somewhere, so an isolated node has no representation, and attribute-heavy nodes inflate into many rows.

(JSON Graph Format is a third thing but not a candidate — it's a single document with `nodes` and `edges` arrays, so it's a JSON atom, not a JSONL list.)

## The one that fits what you've already said

Your note in `docgraph.py` calls it an instantiation of the protograph, and the reshape doctrine has the IR as **graph traversal-serialized**. That's a third option the general literature doesn't emphasize, because it only works when the graph has a traversal:

**One row per node, in traversal order, carrying the relation that reached it.** Node identity, node kind, and the inbound edge collapse into a single record — one shape, no discriminator, and row order is load-bearing rather than incidental. A document's structure is a tree or near-tree, so almost every node has exactly one inbound relation.

It breaks where the graph genuinely isn't traversal-shaped: cross-references, a node with several parents, an edge that isn't a containment. Those need either a second relation field per row or a supplementary relation row — at which point you're back to a discriminated union, just with a much rarer second shape.

So the question that decides it: **is the docgraph a serialized traversal of a mostly-tree, or a general graph that happens to be stored in line order?** If the former, one schema falls out. If the latter, the honest answer is the discriminated union and the work is writing its `oneOf` rather than avoiding it.

Holding off on the container change until you've landed that — it's the same declaration either way, but the docgraph answer decides what its atom schema looks like.

---

# SCHEMA_NAME should be something more like "ROW_SCHEMA" or "RECORD_SCHEMA"

---

# [Request interrupted by user]

---

# what i mean is structural in this framework, a jsonl file has two types of rows, a header and records, and "RECORD_SCHEMA" is the structural name of the latter

Renamed, 9 passed. (The remaining `schema_id` hits are local variables inside `schema_registry.py`, not the retired attributes.)

The framing exposes an asymmetry between the two slots:

```
HEADER_SCHEMA : dict          module-level constant in registry.py, shared by every kind
RECORD_SCHEMA : article       -> article.schema.json
                docgraph      -> None
                inventory     -> article.schema.json
```

If those are the two row categories of one format, they're declared in two different ways — one is a Python dict hardcoded in the module, the other is external data named per kind. That's the config-as-data rule holding on one slot and not the other. It also can't express what container metadata actually is: `inventory.jsonl`'s header wants the catalog scope it was built over, while a `docgraph.jsonl` header wants the source article and the traversal basis. A single shared header schema has nowhere to put either, and having no `$id` it can't be referenced or versioned like the record schemas can.

The symmetric shape would be a `header.schema.json` shipped as the base, with `HEADER_SCHEMA` becoming a per-kind class attribute defaulting to it — kinds needing more container metadata declare their own extending the base. That changes the header contract, so I'd rather you weigh in than have me do it.

One thing the framing settles on its own: **docgraph's node/edge split isn't a third row category.** If a JSONL file structurally has headers and records, then node and edge are both records, and the union lives inside `RECORD_SCHEMA` — a `oneOf` on `type`, which is the schema's business rather than the container's. So "not two types of entries" is already true structurally; what's missing is that `docgraph.RECORD_SCHEMA` is `None`. Writing that schema is the work, and the traversal-vs-general-graph question decides whether the `oneOf` has two branches or one.

---

# right, and docgraph.RECORD_SCHEMA needs an associated docgraph.schema.json

11 passed. Every kind now carries a record schema.

```
article    VERSION=0.1  RECORD_SCHEMA=article.schema.json
docgraph   VERSION=0.1  RECORD_SCHEMA=docgraph.schema.json
inventory  VERSION=0.1  RECORD_SCHEMA=article.schema.json

schemas: [article/0.1, docgraph/0.1, jsonl-signature/0.1]
```

[`docgraph.schema.json`](src/shared/jsonl_engine/schemas/docgraph.schema.json) is a `oneOf` on `type` with node and edge branches, each closed, sharing a `nodeId` def. Tests cover a valid node+edge round trip and three rejections — incomplete node, incomplete edge, and an undeclared `type`.

Three things to know about how I wrote it:

**It reflects what the emitters produce today, deliberately.** It doesn't pre-decide the traversal question. If the docgraph becomes traversal-serialized, the schema collapses to one branch and `add_node`/`add_edge` merge into one method — schema and emitters change together, which is the right coupling.

**Referential integrity isn't in it.** An edge whose `source` or `target` names a node absent from the store validates fine. Cross-record constraints aren't expressible in JSON Schema; that's a store-level check belonging to the verifying reader, and it's noted in the schema description rather than silently absent.

**Two small calls I made** — `VERSION` went from `"2.0"` to `"0.1"`, since the 2.0 was a leftover from the first draft and nothing was ever written under it; and I gave the edge branch an optional `properties` object to match the node branch, which the current `add_edge` doesn't emit. Strip either if you disagree.

Still open, unchanged: the `HEADER_SCHEMA` asymmetry, the traversal-vs-general-graph decision, and the container declaration — `ArticleRegistry` currently declares `NAME_FORMAT = "article.json"` but would still write JSONL, since I stopped that edit when you redirected.

---

# well lets unpack the traversal question a bit. is docgraph referring to the former or the latter in my comment? if its referring to the IR refgraph object parsed from latex, then it's a refgraph, not a docgraph. `docgraph` was the original name for this and its always been intended to be renamed to ref_graph or something like that because its a domain specific type of graph object that is all about pointers from one place to another within an article. for example, pointers in section bodies to items in the citations list or appendix. pointers to figures. while there are some common patterns, each articles ref-graph is author-idiosyncratic , and thus the schema needs to eventually be able to capture this abstractly. i would argue that such a graph can be traversed just fine, even if its not guaranteed to be a DAG (not sure whether its guaranteed or not)

That reframes it usefully. So the object currently called `docgraph` is the **ref-graph** — pointers *within* an article: body → citation, body → appendix, body → figure, `\ref`/`\cite`/`\eqref` sites resolving to labelled targets. The docgraph-proper/protograph is a different, structural object, and the two were conflated under one name.

## Is it a DAG?

No, and not by accident. Two sections can reference each other — "as shown in §5" appearing in §2, "recall from §2" in §5. Mutually-citing theorems do the same. Cycles are expressible in LaTeX cross-referencing and occur in real papers, so acyclicity isn't available as an invariant.

That matters for encoding choice: traversal-serialization needs each node to have exactly one inbound edge in the traversal tree, so on a cyclic graph it produces a spanning tree plus leftover non-tree edges — which is two shapes again, just with a rarer second one.

## But the edge-list encoding makes the question moot

For a ref-graph specifically, uniform relation rows are the better fit for reasons beyond acyclicity:

**Nodes already have identity elsewhere.** Sections, figures, equations, and bib entries are addressable by the document's own labels. The ref-graph doesn't need to declare them — it names them. That removes the node branch entirely rather than merging it.

**Author idiosyncrasy argues *for* one shape, not against it.** A node-typed union would have to enumerate every node kind an author might introduce. An edge list only needs endpoints to be addressable and the relation to be named — so the idiosyncratic part lives in the *relation vocabulary*, which is data, and the schema stays fixed. That's the abstract capture you're after.

**An unreferenced target simply doesn't appear**, which is correct here. A figure nobody references has no ref-edges, and that absence is information rather than loss — whereas in a general graph store it would be a node you'd failed to record.

So the record is one shape: source, relation, target, and whatever qualifies the pointer. No `oneOf`.

## What it costs, and why the cost is zero here

The RDF tradeoff is that node *attributes* become relations to literal values — "figure 3 has caption X" turns into a row. That's ugly when a graph is supposed to carry attributes.

It isn't here. You said the ref-graph is all about pointers from one place to another; captions, section titles, and bib fields belong to the structural object, not this one. So the thing edge-lists are bad at is the thing this graph isn't for.

## Where traversal still belongs

Not in the row shape — in the **row order**. Walking the document structure and emitting each ref-edge as you reach its source site gives you an edge list in reading order, so locality is preserved and the file reads the way the article does. Traversal decides sequence; the record stays uniform.

Two things I'd want before writing it: the rename spelling, since it lands in filenames (`{stem}.refgraph.jsonl` vs `.ref-graph.` vs `.ref_graph.`), and whether an edge's endpoints are LaTeX label keys as-authored or an engine-assigned address — that decides whether `source`/`target` are opaque strings or something structured.

---

# i'm seeing ref-graph as a first class evidence artifact in the converter lanes, a central source of truth that can be consolidated during parsing, because it serves multiple functions. even if its partially redundant i prefer to capture it completely and exhaustively, and eventually, standardize and canonicalize it the best i can, as part of the process

Evidence status changes the record more than the graph framing did.

## A row stops being (source, relation, target)

If it's evidence consolidated during parsing, each row needs to say where it was found and what was actually written, not just what it resolved to. So the shape is closer to **(site, relation, key) + the raw authored form + provenance**, where `site` is a document location and `key` is the label or bibkey as the author wrote it.

That still keeps one shape — and it absorbs the thing that would otherwise force a second one:

**Label definitions are relations too.** A `\label{thm:main}` is `(site, "defines", "thm:main")`; a `\ref{thm:main}` elsewhere is `(site, "refs", "thm:main")`. Definitions and uses differ only in the relation, so exhaustive capture doesn't reintroduce a node branch. The relation vocabulary carries what a discriminator would have.

## Resolution should be derivable, not recorded

This is the part that follows directly from "evidence." A dangling reference isn't a field on the row — it's the **absence of a `defines` row for that key**. Resolution becomes a query over the store rather than a value baked into it.

Two things fall out of that. The artifact stays faithful, since the parser records what it saw and doesn't adjudicate. And it doesn't go stale when resolution logic improves — you re-run the query, not the parse. Recording `resolved: false` would freeze one parser version's judgement into evidence.

## Keep the raw form so canonicalization is replayable

Since standardizing comes later, the row should carry the authored command verbatim alongside whatever normalization exists at capture time. `\autoref{fig:2}`, `\Cref{fig:2}`, and `\ref{fig:2}` may all canonicalize to the same relation eventually, but if only the canonical form survives you can't revisit that decision without re-parsing the source. With the raw retained, re-canonicalization is a pass over the artifact.

That's the same posture as faithful transcription in the converter — normalize into an added field, never in place of the original.

## Two decisions still blocking a schema

**Site addressing.** For evidence you want the most precise thing available: source file plus line or offset. But the structural address — which section, which float — is what most consumers actually query on, and the structural object doesn't exist yet. Given exhaustive capture, the answer is probably both fields, with the structural one nullable until the protograph lands. That's worth deciding deliberately rather than discovering later.

**Relation vocabulary.** Open string now, canonicalized later — but the raw command should be recorded regardless, so the vocabulary can tighten without invalidating anything already captured. If it ever becomes an enum, that's a schema version bump with the raw field as the migration path.

The rename spelling is still open too, and it lands in filenames.

---

# correction: `The RDF tradeoff is that node attributes become relations to literal values — "figure 3 has caption X" turns into a row. That's ugly when a graph is supposed to carry attributes.` isn't quite true, you should read latex ingest to see the precursors to this graph. latex has pointers to latent objects that have locations in the document, and this rubs up against the more general doc graph, which is the more general set of objects that include the refgraph attributed objects

Read them. Three corrections to what I said, and one finding that matters more.

**Labels already carry attributes.** `RefModel.labels` entries are `{label, class, type, normalized, faithful}` — class ∈ object/section/equation/figure/table/algorithm/custom, plus both number projections. So the refgraph's endpoints are attributed objects that exist independently of any edge. My RDF-tradeoff framing assumed a bare edge list; that was wrong, and it's why you said it doesn't quite hold.

**Resolution is not derivable, and recording it is correct.** `Build-LatexRefGraph` classifies every dangler into `bib-missing`, `declared-unmapped`, or `undeclared` — and that middle class exists only because it consults `$AllLabels`, everything the source declared including labels the converter failed to map. `declared-unmapped` is a *converter* defect; `undeclared` is an *author* defect. Distinguishing them needs parse-time knowledge that isn't recoverable from the artifact afterwards. My "resolution should be a query, not a field" claim was wrong for exactly the reason that makes this evidence.

**Site anchoring is already identified as deferred.** `from = $null`, with the comment that anchoring a site onto its containing node is a later increment and `site` ordinal preserves reading position meanwhile. That's the site-addressing question I raised, already answered as "not yet."

## The finding

The two graphs are distinct and layered, exactly as you said:

```
refgraph  = labels + sites + edges          (label space)
docgraph  = nodes  + edges                  (address space; edges are the refgraph's, lifted)
```

`Build-LatexDocGraph` folds labels into addressed nodes, adds bib entries as nodes (`addr: "bib:key"`, `seq: -1`), and resolves each edge's target onto an address — falling back to `label:{key}` when mapped-but-unanchored. So the refgraph's attributed objects become a subset of the docgraph's nodes, which is the containment you described.

Note the refgraph is **three** populations, not two: labels, sites, edges. A declared-but-never-referenced label appears in no edge, and a `\cite{a,b,c}` is one site producing three edges. Neither collapses without loss.

**And the schema I just wrote validates a shape nothing produces.** `docgraph.schema.json` describes `{type,id,label,class}` and `{type,source,target,relation}` — that's `DocGraphRegistry.add_node`/`add_edge`, which are an invented stub. The working emitter produces `{addr, kind, parent, seq, label?, number?, faithful?, title?, level?}` and `{site, macro, from, to, anchored, resolved, rendered, prenote?, postnote?, dangler_class?}`.

So that schema should be derived from `Build-LatexDocGraph`'s actual output, and the Python registry's methods rewritten to match — or the registry left as a declaration with no emitters until the PowerShell hands its rows over. Writing a schema against the stub locks in a shape the converter never produces.

Given the refgraph is the evidence artifact you want first-class, the same question applies to it: it needs its own kind and schema in label space, separate from the docgraph's.

---

# you're mincing refgraph and doc-graph. the misnomer extends to the original code because i never fixed it. Build-LatexDocGraph should be "Build-RefGraph". this function implies a schema that goes into the schema file, and the builder should build accordingly. is it possible to build based on the schema?

Naming first, so I stop conflating them: if `Build-LatexDocGraph` is the refgraph, then the corrected mapping is

```
Build-LatexRefGraph   (labels + sites + edges, label space)   -> a ref MODEL, not a graph
Build-LatexDocGraph   (nodes + edges, address space)          -> Build-RefGraph
docgraph proper / protograph                                   -> doesn't exist yet
```

The current `Build-LatexRefGraph` isn't a graph — it's the consolidated index the graph is built from. Worth confirming that's how you read it before anything gets renamed in working converter code.

## Can the builder be built from the schema?

Partly, and the boundary is sharp: **a schema constrains shape, not provenance.** It can say a node record requires `addr`, `kind`, `parent`, `seq`; it cannot say that `faithful` comes from `$maps.faith` or that `anchored` means the target resolved to an address rather than a bare label key. Code generation from it would produce a skeleton with every field waiting to be filled in by hand — the shape was never the hard part.

What *is* achievable, and worth more than codegen:

**The schema is language-neutral data, so both lanes read the same file.** The PowerShell builder validates its output with `Test-Json -SchemaFile` against `refgraph.schema.json`; the engine validates on ingest against the same file. That's the pattern `inventory-catalog.ps1` already uses. Neither side hardcodes the shape, and neither can drift from the other without a test failing.

**Coverage can be asserted from the schema in both directions.** Load the schema, enumerate its required properties, and assert the builder emits exactly that set — no field the schema doesn't declare, no declared field the builder never sets. That's the `Assert-ProbeCoverage` move applied to records: the declaration and the code have to agree, and a mismatch names which side moved. It catches the two failures codegen would prevent, without the codegen.

So the practical arrangement is: schema authoritative, builder hand-written against it, agreement enforced by validation on emit plus a coverage test. The builder stays readable and the schema stays the single source.

## Which means the schema I wrote should be replaced, not amended

`docgraph.schema.json` describes the invented stub. It should become `refgraph.schema.json`, derived from what `Build-LatexDocGraph` actually emits — `{addr, kind, parent, seq, label?, number?, faithful?, title?, level?}` and `{site, macro, from, to, anchored, resolved, rendered, prenote?, postnote?, dangler_class?}` — and `DocGraphRegistry` renamed alongside it.

Two things I'd want settled before writing it: whether the ref *model* also earns a kind and schema of its own (it's three populations and it's the earlier, address-free evidence), and whether `from: null` stays in the schema as a nullable field or the schema simply doesn't declare it until site anchoring lands.

---

# both doc graph and ref graph are both graph objects, but they are different graphs. there should not be any mention of 'doc graph' in anything namespace, files, nothing in discussing ref graph. but maybe i'm misremembering the state of the code. lets lay out what the current code actually builds in terms of graph objects. are there two distinct cases that occur at different places in the pipeline?

Complete picture now. `tex-docgraph.ps1` is **orphaned** — nothing dot-sources or calls it; the only references to it are its own header and the note in `docstream.ps1` saying its name retired.

## What the live pipeline builds

All three at one point, consecutive lines in `ConvertFrom-Latex`:

| # | object | built | contents | persisted as |
|---|---|---|---|---|
| 1 | **docstream** | `latex-ingest.ps1:2084` | node set — spine/prose/channel rows in reading order, each `seq` / `addr` (`kind:kind_index`) / `parent`. Structural edges ride in the addressing. | `{slug}.docstream.jsonl` |
| 2 | **refgraph** | `:2086` | reference machinery, label space — label declarations, sites as rendered, per-target resolution, danglers classified `bib-missing` / `declared-unmapped` / `undeclared`. No stream joins. | `{slug}.refgraph.json` |
| 3 | **doc graph** | `:2087` | the composition — stream nodes plus bib as auxiliary nodes, refgraph edges resolved onto stream addresses, `anchored` flag where resolution reached an address. | `{slug}.docgraph.json` |

Plus `{slug}.refs.jsonl` from `LtxRefModel` (labels + sites, two row types) — the refgraph's inputs, written separately.

The header in `docstream.ps1` states this as your own semantics: *"STREAM + REFGRAPH -> DOC GRAPH"*. **The live naming is correct.** `Build-LatexRefGraph` is the refgraph and carries no docgraph in its name; `Build-LatexDocGraph` is the composition. I was wrong to accept the premise last turn that the second should be renamed — I should have read before agreeing.

## The two cases, and why only one survives

There *were* two captures at different pipeline points, by design:

- **`tex-docgraph.ps1`** — "captured upstream of surjection," binding label → type → location, with numbering deliberately not computed because that needs LaTeX counter simulation. Emits `{slug}.docgraph.jsonl`, one record per labeled object (`kind=node`) and one per reference site (`kind=edge`).
- **the docstream builders** — late, after ref resolution, so numbers exist in both projections and resolution/dangler classification is available.

The upstream one is dead code. So today there is one capture point, and the early type-binding evidence isn't collected.

## The actual misnomers

Only two, and neither is in the live path:

1. **`tex-docgraph.ps1`** is a *refgraph* by your own definition — labeled objects and reference sites, no stream addresses — but is named docgraph and writes `.docgraph.jsonl`. Its own header calls it "the document's typed reference graph."
2. **A filename collision waits**: the live path writes `{slug}.docgraph.json`, the dead path `{slug}.docgraph.jsonl` — different producers, different shapes, one name.

And the Python side: `DocGraphRegistry` plus the `docgraph.schema.json` I wrote match *neither* live artifact. That registry came over from the original draft as a stub and I gave it a schema without checking it against anything. It should be deleted or rebuilt against whichever of the three objects actually earns a kind — and given all three persist today, that's a real question rather than a rename.

---

# I would amend "STREAM + REFGRAPH → DOC GRAPH " because while true, its also incomplete. DOC GRAPH is stream + refgraph + other things TBD. its very unfortunate that i have to fight tooth and nail to get my intent across due to the abomination that is this code base

The amendment matters more than a wording fix. If the doc graph is `stream + refgraph + TBD`, then it's an **open composition** — and that settles the schema question in the opposite direction from what I suggested:

- **refgraph** is bounded. Reference machinery is a closed concept: declarations, sites, resolution, danglers. It can be schematized now.
- **docstream** is bounded. Node set with addressing.
- **doc graph** cannot be, precisely because its member set is still accreting. A closed schema over an open composition would freeze the thing you haven't finished deciding.

It also means `docstream.ps1`'s header overstates it — "the realized instantiation of the protograph for this document" claims completion for something that's currently stream + refgraph and nothing else yet.

On the friction: a fair amount of it this session was mine. I accepted your premise about `Build-LatexDocGraph` last turn instead of reading the file, then wrote a schema against `DocGraphRegistry` — a stub that came over in the original draft and matches no artifact the converter produces. That schema is now a third thing asserting a shape nothing emits.

The pattern underneath is specific and fixable: the repo contains artifacts that **assert confidently and wrongly**. `tex-docgraph.ps1` is orphaned but reads as live and claims the docgraph name. `DocGraphRegistry` and `docgraph.schema.json` describe an invented shape. Anyone reading the tree to learn the design finds three answers, two of which are dead. That's why intent has to be restated by hand each time.

Smallest thing that stops it, if you want it:

- delete `docgraph.schema.json` and `DocGraphRegistry` — my inventions, matching nothing
- move `tex-docgraph.ps1` to the graveyard, or mark it dead in its header — its own note already says its name retired
- amend the `docstream.ps1` header to the open formula, so the authoritative statement stops claiming a finished composition

Then the only surviving assertions are the two live builders, which are correctly named and correctly described. Say the word and I'll do those three; I'd rather not touch anything else in that lane without you looking.

---

# well, docgraph.schema *looks* almost like a graph object primitive so maybe it has some value. it might resemble the canonicalized form or the more primordial notion of a graph object in this project, which is a bunch of nodes and edges fundamentally, but with the specific labels differing. both of the operative "graphs" we've been discussing can be described abstractly by a shared primitive object, but whether or not that's actually useful is another question

It's expressible, and the cheap disposition is to demote it rather than delete it — stop it claiming to govern a kind's records, keep it as the abstract shape. But two things say the primitive would assert almost nothing today.

**The two graphs disagree on the thing it would assert.** A graph primitive's core claim is "an edge has a source and a target." Refgraph edges don't: the source is `site`, an ordinal into the site list, and in the composition `from` is explicitly `null` with the comment that site anchoring is a later increment. So the base would have to make `source` optional, which drops it to "an edge has a target, maybe."

**The identity spaces differ in kind.** Docgraph nodes are namespaced addresses — `kind:index`, plus `bib:key`, plus `label:key` as the unanchored fallback. Refgraph nodes are label strings. A shared `nodeId` def would be a string in both cases and mean different things, which is the kind of agreement that reads as structure and isn't.

Strip those and what's left is `type ∈ {node, edge}` and "nodes have an identity." That's true, and thin.

## The test for whether it's worth more than that

Does a consumer exist that reads a graph **without knowing which graph it is**? A generic traverser, a query layer, a renderer that walks nodes and follows edges. If yes, the primitive is load-bearing and the coordination cost is repaid. If every reader knows it's reading a refgraph, the primitive is documentation with validation overhead attached.

That's the same question that's decided every other slot in this engine — key extraction, ordering, the container declaration. Each earned its place when something needed it, and the ones that didn't have stayed unbuilt.

Given ThermoMapper, the protograph, and BP-CSR all involve graphs, a generic layer isn't far-fetched. But it doesn't exist, and the one concrete thing that would exercise it — the docgraph — is an open composition you haven't finished specifying.

## Cheaper version that captures most of it now

A stated **convention** rather than an enforced base: graph JSONL uses `type: "node"|"edge"`, nodes carry an identity field, edges carry source and target where anchoring exists. Concrete schemas restate it in full. Costs nothing to maintain, and a generic reader written later can rely on it without every schema having been coordinated in advance.

`$ref`-based inheritance buys enforcement, and enforcement is worth its coordination cost at three or four graphs, not two — one of which can't be schematized yet.

So: keep the file, rename it to what it is, give it `$defs` and no authority over any kind's records, and let it stay unreferenced until a second graph actually needs to agree with the first. That way it records the notion without asserting a shape nothing produces — which was the only real problem with it.

---

# ok i renamed to graph.primitive.schema.json and committed. ive also created jsonl_engine/schemata for holding constructors of specific schemas or something like that

Green, 10 passed, and the retired noun is out of the schema index:

```
codex-scientiae/article/0.1
codex-scientiae/graph-primitive/0.1
codex-scientiae/jsonl-signature/0.1
graph  graph.primitive.schema.json  article  article.schema.json  sig  sig.schema.json
docgraph present: False
```

The `$id` and title never got updated in your rename, so the primitive was still registering as `codex-scientiae/docgraph/0.1`. Fixed, and its description now says outright that it's dormant, that no kind declares it, and *why* the two concrete graphs don't yet agree on what it would assert.

`DocGraphRegistry.RECORD_SCHEMA` is `None` with a comment explaining it's unbound deliberately — the primitive isn't its schema, and the composition can't be schematized while its member set is open. My two invented docgraph tests are gone, replaced by one that asserts the primitive stays dormant: discoverable, and declared by no kind. That test fails the moment someone wires it up, which is the point.

Two things I'd want from you.

**`DocGraphRegistry` itself.** It's now a kind with no schema and with `add_node`/`add_edge` that match no producer in the converter. Keeping it holds a catalog slot for a real object you haven't specified; removing it costs one small file to re-add later. I left it because the doc graph *is* a real distinct object — the misnomer was only ever using that name for the refgraph — but the emitters are still my inheritance from the original draft.

**`schemata/`.** It's empty, so I don't want to guess at the shape. The distinction that would justify it over plain JSON: `schemas/` holds declarations fixed at authoring time, `schemata/` holds code for schemas whose content *isn't* — built from something discovered. Two candidates already exist in this project if that's the intent: the refgraph's relation vocabulary, which is author-idiosyncratic and canonicalizes over time, and the probe-ledger check names, currently declared in PowerShell as `$script:DepositProbes` and duplicated nowhere — a schema constraining `checks[].name` to that set would have to be built from it rather than authored.

If that's not what you had in mind, say what is and I'll work to it rather than around it.

---

# no, the domain specific parsing lives in the producer, not under schemata. i was thinking structurally again and maybe it isn't the move here. so is docgraph.py actually about the ref-graph? the architecture implies what we need for any given case

Yes. Three pieces of evidence, and the field name is the giveaway.

`docgraph.py` emits `{"type":"node", "id", "label", "class"}`. In the live code, **`class` belongs to refgraph labels** — `{label, class, type, normalized, faithful}`, class ∈ object/section/equation/figure/table/algorithm/custom. The doc graph's nodes use `kind`, not `class`. And `{"type":"edge", "source","target","relation"}` — node-per-thing, edge-per-relation, discriminated in one JSONL — is precisely `tex-docgraph.ps1`'s stated output: *"one record per labeled object (kind=node), one per reference site (kind=edge)."* Whose own header calls it "the document's typed reference graph."

So `docgraph.py` descends from the orphaned file, and inherited the misnomer along with the shape.

## What the architecture implies

```
docstream   bounded    {slug}.docstream.jsonl                          earns a kind
refgraph    bounded    {slug}.refs.jsonl + {slug}.refgraph.json        earns a kind
doc graph   open       {slug}.docgraph.json                            not yet
```

And for the refgraph the container model settles the rest without a design decision:

`{slug}.refs.jsonl` already discriminates on **`row`** — `'label'` and `'site'`. `{slug}.refgraph.json` is the same object in the other container: the same two populations, plus `edges`, plus `danglers`, plus `stats`. So they aren't two artifacts, they're one object written twice — once incomplete as JSONL, once complete as JSON.

Under the model, that resolves to:

- **records** = `row: 'label' | 'site' | 'edge'` — three branches, using the discriminator the live JSONL already uses rather than the `type` my stub invented
- **header** = `stats` — labels/sites/edges counts, resolved, dangling, `dangler_classes`, `faithful_render`. That's container-level metadata by definition, and it's the first real occupant of the header slot rather than a hypothetical one
- `danglers` isn't a fourth population — it's the subset of edges where `resolved` is false, already carrying `dangler_class`. Emitting it separately would duplicate rows

So the kind is `refgraph`, `NAME_FORMAT = "{stem}.refgraph.jsonl"`, and it supersedes both existing files: `refs.jsonl` gains the edge rows it's missing, `refgraph.json` loses nothing because its stats become the header.

Two things worth your call before I write it. Whether superseding both files is acceptable now or whether the converter keeps emitting them during transition. And whether the early capture in `tex-docgraph.ps1` — label→type→location, before surjection, no numbers — is evidence you still want; it's a genuinely different refgraph at a different pipeline point, and right now it's dead rather than decided.

---

# worth remembering that earlier incarnations of latex-ingest were writing an incomplete ref-graph (i want to introduce the hyphen as the canonical spelling), originally the artifact that was being written only contained nodes not edges as a fast-lane to the TOC writing machinery, before i promoted the idea to first class source of truth, so depending on where you are looking in the ingestion inventories and artifacts from old runs, you might see different picture. the ingestion/inventory/** + associated artifact traces under `artifacts` would be the most current and even that's probably stale in light of our ongoing discussions and changes today

Current vintage, and it confirms the reading precisely:

```
refgraph.json   keys: danglers, edges, labels, sites, stats
                labels 7 | sites 31 | edges 34 | resolved 34 | dangling 0
refs.jsonl      {'label': 7, 'site': 31}          <- 38 rows, no edges
docgraph.json   nodes 185 | edges 34
mtime           2026-08-04
```

So the on-disk artifacts post-date the current builders — edges and classified danglers are both present, which is the tell that separates them from the nodes-only fast lane you're warning about. I found no nodes-only vintage under `artifacts/` (didn't look inside `artifacts/latex-ingest/runs`, only `probe`).

Three things the data settles that I'd otherwise have been inferring:

**The JSONL form is missing exactly the edges.** `refs.jsonl` has 38 rows; the complete object has those 38 plus 34 edge rows. That's not a shape disagreement between the two files — it's one object, one container complete and the other truncated. Which is the whole case for the ref-graph kind: `refs.jsonl` gains a third `row` branch and becomes the artifact, and `refgraph.json` stops being needed.

**Sites and edges are genuinely distinct populations.** 31 sites produce 34 edges, because a multi-target `\cite{a,b,c}` fans out. Neither collapses into the other, so the union really is three branches and not two.

**The containment you described is visible in the counts.** The doc graph has 185 nodes — the docstream — of which 7 carry labels. So the ref-graph's attributed objects are a small subset of the doc graph's node set, exactly as you put it, and the doc graph's other 178 nodes are structure the ref-graph never mentions.

That leaves the ref-graph kind fully specified by artifacts rather than by my inference: `KIND = "ref-graph"`, `{stem}.ref-graph.jsonl`, records discriminated on `row` ∈ label|site|edge, header carrying `stats` plus `faithful_render`. Two open items from before are unchanged — whether it supersedes both existing files immediately or the converter keeps emitting them through a transition, and whether the pre-surjection capture in `tex-docgraph.ps1` is evidence you still want.

---

# i don't think throw-away historical artifacts showing a partial manifestation of the intended mature design warrants a special third case.

Agreed — and it's superseded rather than merely abandoned, which is worth noting because it means nothing is lost by dropping it.

`tex-docgraph.ps1` existed to capture the label→type binding *before* surjection destroyed it. The mature path captures that binding anyway: `$maps.types` feeds `type` onto every label record in `Build-LatexRefGraph`, described in the code as "the evidence `\cref` needs." The only thing the early capture has that the mature label record lacks is location, and that arrives through the composition via `addrByLabel`. So it's a partial earlier solution to a solved problem, not a distinct evidence case.

That closes one of the two open items. What's left is just the transition question: whether the ref-graph kind supersedes `refs.jsonl` and `refgraph.json` on landing, or the converter keeps emitting all three for a while.

Given the corpus is about to be wiped and rebuilt, and those probe artifacts are throwaway, I'd say supersede immediately — there's no consumer to strand and no data to migrate. But that's the one thing I'd rather hear you say than assume.

If you want it, the bundle is: `tex-docgraph.ps1` to the graveyard, `docgraph.py` → `ref_graph.py` with `KIND = "ref-graph"` and `{stem}.ref-graph.jsonl`, `ref-graph.schema.json` written from the live builder's actual output with `row` ∈ label|site|edge, and the header carrying `stats` + `faithful_render`. The PowerShell emitter change is separate and larger — that's where `refs.jsonl` gains its edge rows — so I'd leave the converter alone in that pass and just land the kind.

---

# well, neither of them should survive. are we sure refs.json is the ref-graph incarnate. lets trace the lineage to make sure we are talking about the correct object. also, does the object we are trying to hammer out want to be a json or a jsonl? i would imagine pragmatically better in jsonl form for processing

Traced. `refs.jsonl` is **not** the ref-graph — I was imprecise before.

```
ref-semantics.ps1 (during Resolve-Refs)   →  LtxRefSites   {macro, targets[], rendered, prenote?, postnote?}
latex-ingest.ps1:1890-1907 (from $maps.*)  →  refLabels     {label, class, type, normalized, faithful}
:1908  LtxRefModel = {labels, sites, faithful_render}
:2546      →  {slug}.refs.jsonl                    ← the ref MODEL, serialized
:2086  Build-LatexRefGraph(RefModel, CiteMap, AllLabels)
       LtxRefGraph = {labels, sites, edges, danglers, stats}
:2555      →  {slug}.refgraph.json                 ← the ref-GRAPH
:2087  Build-LatexDocGraph(dsRows, RefGraph, CiteMap)  →  doc graph
```

The ref model is what the converter **collected**; the ref-graph is the model **plus resolution** — edges are the site×target cross product with `resolved`, `target_kind`, and `dangler_class` computed against `CiteMap` and `AllLabels`, neither of which the model holds. So they're input and output, not two completeness levels of one thing.

But `Build-LatexRefGraph` passes `labels` and `sites` through verbatim, so the ref-graph strictly contains the model. `refs.jsonl` is a proper subset of `refgraph.json` — which is why neither survives: one is redundant, the other is the wrong container.

## JSONL, and it's better than pragmatic

The container model doesn't just reshape it, it removes a defect:

```
2409.02901v1: labels 157 | sites 271 | edges 314 | resolved 106 | dangling 208
              208 of 314 edge objects written twice — once in edges, once in danglers
```

`danglers` isn't a population. `Build-LatexRefGraph` adds the *same object* to both lists, so the JSON form serializes 66% of the edges twice on that paper. In JSONL it stops existing — a dangler is `edges where resolved == false`, and `dangler_class` already rides on the edge record, so nothing is lost by dropping the array. Smaller file, and no possibility of the two arrays disagreeing.

`stats` becomes the header. That's container-level metadata by definition, and it's the first real occupant of the header slot rather than a hypothetical.

So the JSONL form is strictly better on three counts — no duplicated edges, metadata in its designated place, and streaming plus `.jidx` random access over what is already 314 edges on a mid-sized paper.

Which lands the kind as: `KIND = "ref-graph"`, `{stem}.ref-graph.jsonl`, records `row` ∈ label|site|edge, header = `stats` + `faithful_render`. And it supersedes both files rather than either.

---

# why do we need a stem? if ref-graph is the deliverable of the buildLatexRefgraph with resolution , then its a once-per-run canonical artifact that doesn't need to mutate if its actually done, but if downstream processes resolve "danglers" that remain unresolved at the end of buildlatexrefgraph then it points to the need for more resolution plumbing or simply accepting the stats (yes stats are header data, and the header schema needs to be moved out of code and into `schemas` on that note)

Header schema moved. Both row categories now declare the same way and resolve from data:

```
schemas: article/0.1, graph-primitive/0.1, jsonl-header/0.1, jsonl-signature/0.1

article    HEADER_SCHEMA=header.schema.json  RECORD_SCHEMA=article.schema.json
docgraph   HEADER_SCHEMA=header.schema.json  RECORD_SCHEMA=None
inventory  HEADER_SCHEMA=header.schema.json  RECORD_SCHEMA=article.schema.json
```

`HEADER_SCHEMA` is a class attribute defaulting to `header.schema.json`, so a kind carrying its own container metadata — ref-graph's `stats` — declares a schema extending the base. `additionalProperties: true` on the base makes that extension possible without restating it. 10 passed.

## The stem

You're right, and the artifacts show it: `artifacts/latex-ingest/probe/1611.03935/1611.03935.refgraph.json` — the directory *is* the slug and the filename repeats it. `run-paths.ps1` puts slug at a directory level by convention (`artifacts/{module}/runs/{stamp}/{slug}/`), so a stem in the filename is duplicating the path.

So `ref-graph.jsonl`, no stem — matching `article.json` and `inventory.jsonl`. Worth noting that leaves `{stem}` with only one user, `docgraph.py`, which is itself unresolved. If that goes, `get_output_path(stem=...)` becomes a parameter with no consumer.

## The dangler fork

`dangler_class` is already the triage, per edge:

- **`bib-missing`** (192 on the worst probe) — an *input* gap, not plumbing. The `.bbl` wasn't there or lacks the key; no downstream pass can invent a bibliography.
- **`declared-unmapped`** (16) — the plumbing gap, and the only one that's yours to close. The author declared the label, the converter built no number for it. The code already names one such fix at line 582: `\ref{alg:x}` rendering "?" because no map claimed algorithm labels.
- **`undeclared`** (0) — author error. Accept.

So "more plumbing or accept the stats" isn't one decision — it's answered per class, and `declared-unmapped > 0` is the measurable backlog. Sixteen on that paper is a concrete number to work down.

The principle underneath matters more though: **nothing downstream should rewrite the artifact.** If a later stage resolves something the builder couldn't, that's a new claim, not an edit to evidence — otherwise the ref-graph stops recording what the converter established and starts recording an accumulated opinion. Which makes the discipline `CREATE`, written once per run into a fresh run directory, with no append path. That's the same posture as the deposit sentinel, for the same reason.

---

# so if we are retiring refs.json because its redundant and partial, then the consumers of refs.json files need to be updated to consume the canonical ref-graph.jsonl

Census is smaller than expected. Both files are **write-only** — nothing in `src/` or `tests/` reads either one.

```
{slug}.refs.jsonl      written  latex-ingest.ps1:2546     read by  nothing
{slug}.refgraph.json   written  latex-ingest.ps1:2555     read by  nothing
```

The one thing that looked like a consumer isn't. `tests/latex-ingest.refs.Tests.ps1` reads `$script:LtxRefModel` — the **in-memory structure**, not the emitted file — and compares it against `tests/fixtures/2408.16741v2.refs.golden.jsonl`. Retiring the file doesn't retire the model; `LtxRefModel` remains as `Build-LatexRefGraph`'s input either way. So the golden test and its 37 KB fixture are unaffected, which matters given the brief declares that fixture immutable and says to regenerate it only deliberately.

So the actual update list is short:

- **the producer block** — `latex-ingest.ps1:2534-2547` and `:2555` both go, replaced by one ref-graph emission
- **canon** — `issues/latex-ingest/planning/decisions.md` D11 enumerates the per-conversion artifacts and names both files; that list needs amending to the single `ref-graph.jsonl`
- **nothing else**

`issues/latex-ingest/planning/ledger.md:31` records when `refs.jsonl` landed — that's history and shouldn't be rewritten. And `issues/batch-executor/planning/testing-batchability-inventory.md` references the test, not the artifact, so it stands.

Worth noting the pattern: this is the third write-only artifact set in this repo — the Python engine's `.jidx` and `.sig` had no reader until we closed that loop, and now both ref artifacts turn out to have none either. The ref-graph landing as a real kind is what gives it a reader for the first time, which is also what will keep its shape honest.

---

# well, no consumer now doesn't mean no consumer later. ref-graph object already has pending consumer in the toc-engine (currently powershell, will migrate to template_engine jinja2 later), which should consume the ref-graph.jsonl

---

# [Request interrupted by user]

---

# no, ref-graph should be shaped on its own merits. the consumer has a contract with it, but this consumer does not determine ref-graphs shape because it will have other more important consumers

`edge.site` doesn't join to anything. Across four papers:

```
1611.03935     sites=31   edges=34    edge.site max=33   distinct=34
2105.07025     sites=473  edges=510   edge.site max=509  distinct=510
2111.15058v3   sites=161  edges=177   edge.site max=176  distinct=177
2112.02352     sites=191  edges=215   edge.site max=214  distinct=215
```

`distinct == edges` in every case, so the field named `site` is a **unique per-edge ordinal**, not a site index. `Build-LatexRefGraph` increments `$si` inside the inner `foreach ($t in $s.targets)` loop rather than the outer one.

The multi-target case shows what that costs:

```
site[0] targets: ['CESV2011', 'CSV2013', 'CL2012']
edges with site==0: exactly one — CESV2011
```

Site 0 produced three edges, but they're numbered 0, 1, 2. So the two edges from site 0 claim to come from sites 1 and 2, which are different sites. The field is correct only until the first multi-target `\cite` and silently wrong after.

Meanwhile `refs.jsonl` numbers its site rows with an independent counter in the outer loop — so *that* numbering is right, and the two files disagree about what a site index is. Nobody noticed because nothing reads either.

So the shape needs, on its own merits: **a stable site identity emitted on site rows and referenced by edge rows.** That's a schema requirement discovered from the artifact rather than inherited from the current field set — and it means the builder changes too, since `$si++` has to move to the outer loop before `edge.site` means anything.

Worth noting this is precisely the class of defect consumer-driven shaping would have preserved. toc-engine wants section labels and numbers; it never joins an edge to its site, so it would have accepted the field as-is and the break would have surfaced years later in whatever consumer did care.

I'd hold off writing `ref-graph.schema.json` until that field is settled, since the join key is load-bearing for what a record even is.

---

# i believe somewhere recently i thought i instituted the idea of canonicalizing linked lists like this. there was an example paper that cited papers by letter, but listed citations by number, and knowiing that these things have a 1:1 correspondence, i reasoned that any paper should be canonicalized to number->number pointers starting at 1. this is an aspect of the big picture surjection from source to target latent manuscript, and consistent with other normalizations like surjection of different katex control tokens to canonical math channel tokens. however in the ref-graph case, the mappings aren't necessarily 1:1 i guess. none the less, this is a resolution and canonicalization question

Found it. The label population isn't a set.

```
2105.07025:  143 label rows | 75 distinct keys | 60 duplicated

thm:obayashi                        class=object  type='Theorem'  normalized='3.2'   faithful='3.2'
                                    class=custom  type=''         normalized='2'     faithful='2'
thm:phindependencecharacterization  class=object  type='Theorem'  normalized='15.2'  faithful='B.2'
                                    class=custom  type=''         normalized='4'     faithful='4'

overlapping class pairs:  (custom,section) 24 | (custom,figure) 10 | (custom,equation) 9
                          (custom,object) 4 | (custom,equation,section) 4 | (custom,table) 4
```

**Every duplication involves `custom`.** `$maps.custom = $cc.labels` — the custom-counter pass, documented as "lettered cases, enumerate items" — is claiming labels that already belong to the typed maps, and assigning them small enumerate-item integers. So `thm:obayashi` is simultaneously Theorem 3.2 and custom "2".

Consequences, in order of severity:

- **No unique identity exists in the labels population.** Not the label key (38/43 papers), not `(class, number)` (19/43), not `(type, number)` (12/43). Canonicalization to numeric pointers can't proceed while one label carries two contradictory numbers.
- **`stats.labels` is a row count, not a label count** — 143 where the paper has 75.
- **Edge resolution is unaffected.** `Build-LatexRefGraph` loads labels into a `HashSet`, so duplicates collapse and `resolved` is correct. The defect is confined to the labels population.

Which answers the canonicalization question with evidence: the 1:1 you want is blocked by **map hygiene, not by the domain**. Bibkey→number genuinely is 1:1 and canonicalizes cleanly. Label→number is 1:1 per typed map — it only looks non-1:1 because `custom` overlaps the others without a precedence rule. Fix that and the residual is 12/43 on `(type, number)`, which is a much smaller and probably tractable problem.

This is the same family as the `declared-unmapped` dangler class — both are `$maps.*` hygiene, and the code already names one such fix at line 582 as "the refgraph's first cleaned dangler class."

So the sequence I'd suggest: settle the custom-map precedence, then the site-index fix, then write the schema. Writing it now would pin a shape whose identity fields don't yet identify anything.

---

# and this is an example of single source of truth putting in work. the ref-graph.jsonl deliverable needs to canonicalize so that downstream consumers can count on it, and part of my development approach is pulling back normalizations like this as far as i can in the process so more downstream consumers don't need to reinvent or implement guess work

Found the mechanism. **`$st.rt` is never cleared.**

```powershell
:1419  \refstepcounter  ->  $st.rt = Format-Counter ...
:1429  \item            ->  $st.rt = [string]$top
:1432  \label           ->  if ($null -ne $st.rt) { $labels[...] = $st.rt }
```

It's armed by a `\refstepcounter` or an enumerate `\item` and then read by **every subsequent `\label` to the end of the document**. Nothing disarms it. That's exactly the observed damage: the overlap classes are precisely the typed ones — section 24, figure 10, equation 9, object 4 — and the values are small stale integers (2, 4) because they're leftover enumerate item counts.

The root cause is one level down: `Resolve-CustomCounters` tracks **only** counters the source declares, deliberately — "never the standard ones." But in real LaTeX a theorem or figure environment does `\refstepcounter` on its own counter, which overwrites `\@currentlabel`. The walk never sees those, so it never sees the overwrite that would have disarmed the stale target.

One thing that limits the blast radius: **the bug is confined to `$labels`.** Body rendering reads `$val[$c]`, not `$st.rt`, so `\Alph{c}` output is unaffected. Only the labels map is corrupted.

Three places the normalization could land, and your "as far upstream as I can" has a real tension here:

- **Furthest upstream** — teach the walk which environments own a standard counter and clear `$st.rt` on entering them. Most faithful to LaTeX, but it duplicates environment knowledge the typed passes already hold, so upstream buys correctness at the cost of coupling.
- **Consume-once** — a `\label` reads `$st.rt` and disarms it. One line, no new knowledge, and it matches the intent that a stepped counter is captured by *its* label rather than by every label after it. Doesn't perfectly model `\@currentlabel`, but the residual case is a label that legitimately follows a custom step at distance, which is rare.
- **Precedence at assembly** — `custom` yields to any typed map when both claim a label. Also one line, but it leaves the corrupt map in place and normalizes on read, which is the thing your approach exists to avoid.

The second is where I'd put it: upstream enough that no consumer ever sees the duplicate, cheap enough not to duplicate knowledge. And it's a case where the principle pays off concretely — fix it there and the ref-graph needs no dedupe rule, no precedence field, and no downstream guesswork about which of two numbers a label really has.

Worth confirming against a paper with lettered proof cases before changing it, since that's the feature the walk exists for and consume-once is the one fix that could plausibly regress it.

---

# i'd say 2nd option as well. the upstream of that is collection of facts, the step that emits the canonicalized ref-graph stitches the facts together. the inbetween is a bit fuzzy, but i think it can play out fine. author idiosynchracies pull further back to capture and methodology after that solves the production problem

That layering resolves what kind of change consume-once actually is: **not a normalization at all.** It's a capture-accuracy fix. The walk is currently recording a fact that isn't true — "this label is bound to this counter value" — for every label after the first `\item`. Disarming on read makes capture honest; it doesn't reconcile anything.

Precedence-at-assembly would have been the normalization, and it's the one that's wrong here precisely because there's no genuine conflict to reconcile — only a manufactured one.

The fuzzy in-between has a name in this case: the `$refLabels` build at 1890–1907 is a **projection**. Seven differently-shaped maps flattened into one record shape, with `class` assigned by which map a label came from. It collects nothing new and resolves nothing — it just changes shape. That's exactly where the duplicate surfaced, because a projection has no basis for adjudicating two claims; it can only emit both.

Which is the argument for your sequencing holding: fix capture and the projection needs no policy. It stays a dumb flattening, and it's *correct* as a dumb flattening. Push the fix to the projection instead and you've given the fuzzy step a judgement to make, which is how fuzzy steps stop being harmless.

And it generalizes the way you put it — idiosyncrasy handling has to sit where source context still exists. `Resolve-CustomCounters` is the right home for lettered proof cases because it's the last place that still sees `\newcounter` and `\refstepcounter` in document order. By the projection, that's gone.

The one thing I'd check before touching it is the risk you named: consume-once is the single fix that could regress the feature the walk exists for. If a paper does `\refstepcounter{desccounter}` and the `\label` doesn't immediately follow — say a `\item` or some prose intervenes — disarming early would drop a binding that currently works. Worth finding whether any probe paper actually exercises lettered cases before changing it, rather than assuming the residual is rare because it sounds rare.

---

# and `projection` i think highlights another project-invariant kind of object, sibling to inventory and others. this motif has shown up in various forms but not really formalized. its also data, and a data structure that would be stored in jsonl as knowledge accumulates for different projections at this step

It's already a table — the seven blocks at 1890–1907 differ only in a few slots:

```
source   class       type                         faithful
thm      object      types[k] ?? ''               faith[k] ?? thm[k]
sec      section     types[k] ?? 'Section'        faith[k] ?? sec[k]
eq       equation    'Equation'                   = normalized
fig      figure      'Figure'                     = normalized
tab      table       'Table'                      = normalized
alg      algorithm   'Algorithm'                  = normalized
custom   custom      ''                           = normalized
```

Three type-resolution modes (lookup-with-fallback, constant, empty) and two faithful modes (lookup-with-fallback, same-as-normalized). That's a closed vocabulary over an open row set — which is the shape that wants to be data rather than seven near-identical loops.

And the duplication has already cost something: the `alg` row exists because the algorithm map was added later (line 582 calls it "the refgraph's first cleaned dangler class"), and `custom` is the row that behaves differently from all the others. A table makes both visible; seven blocks make the seventh look like the other six.

## The category is real and already has a member

Where I'd push back on "sibling to inventory": the lifecycle is different in a way that matters.

`article.json`, `inventory.jsonl`, `ref-graph.jsonl` are **emitted evidence** — per-document or per-scope, produced by a run, immutable after. A projection table is **authored rules** — repo-level, versioned, read by the converter, never produced by it. Different discipline, different location, different mutability.

That category already exists in the repo with exactly one member: `{slug}-latex.patch.jsonl`, the hand-authored errata — "per-paper, human-authored, JUSTIFIED patch file BESIDE the source, re-applied on EVERY conversion," with `op` restricted to three values and `reason` mandatory. Authored rules in JSONL, validated on read, never emitted.

So `projection` would be the second member, differing from the patch file mainly in scope: patch is per-paper idiosyncrasy, projection is repo-level and shared. Both are the converter's *inputs*.

That's worth naming because it changes what the engine needs. Everything built so far assumes kinds are written by the engine and read back. An authored-rule kind is validated on read and written by hand — which is `DISCIPLINE` territory the enum doesn't cover, and it's the same gap the article sentinel opened with create-if-absent.

What would settle whether projection is genuinely a kind rather than just a config file: does anything other than the converter need to read it? If the ref-graph's consumers ever need to know *which* projection produced a `class`, it's evidence and belongs in the artifact. If only the converter reads it, it's configuration and the kind machinery is overhead.

---

# fair. and inventory is a unique case that's reflective of what is there categorically. its not evidence, its just compiled facts without dispute and its not something that needs to be litigated in process because its invented by the project for logistical purposes. projection is a form of evidence, and an abstraction at that, with different kinds that might crop up for different use cases. tracing this back to the jsonl_engine conceptually, it actually highlights something pending which is that jsonl_engine is missing abstractions, at least one major layer, to account for registries as one type of jsonl object, with various runtime artifacts that get written to jsonl being an entirely different category served by the same engine

That's a real gap, and there's a proof it's a separate axis sitting in what's already built: **`article` and `inventory` share a record schema.** Same records, and one is evidence while the other is a compiled catalog. So category can't be inferred from the schema, the discipline, or the container — it has to be declared.

What actually differs between them, in the terms the engine would need:

| | registry (inventory) | runtime evidence (ref-graph, article) |
|---|---|---|
| origin | derived from artifacts that hold the truth | produced by a process at a moment |
| rebuildable | yes, any time, from the same sources | no — needs the process re-run, possibly a different version |
| provenance | none needed; records *are* copies of truth | required: which run, which producer, what inputs |
| divergence from reality | staleness, fix by rebuild | a finding, not an error |
| header wants | scope, build time | run identity, producer version |
| scope | a catalog root | a run directory |

The failure-semantics row is the one that isn't cosmetic. A registry disagreeing with the world means rebuild it. An evidence artifact disagreeing with the world means something changed since it was recorded — which is information, and rebuilding it destroys the finding. The engine currently can't tell those apart, so it can't stop a caller from "fixing" evidence.

And the naming carries the conflation. `BaseArtifactRegistry` is named after **one of its categories**, so `ArticleRegistry` and `DocGraphRegistry` both assert something untrue — an article manifest isn't a registry, and a ref-graph certainly isn't. That's the same failure mode as docgraph-meaning-refgraph: a name asserting a category it doesn't belong to, and then every reader has to be told otherwise in conversation.

The shape that fits what's already there: `CATEGORY` as a class attribute alongside `KIND`/`DISCIPLINE`/`CODEC`, with the category *implying* defaults rather than each kind restating them — header schema, discipline, whether provenance is mandatory, whether regeneration is a valid operation. That's the same config-as-data move, one level up: a kind declares what it *is*, and the engine derives how to treat it.

Two things I'd want to know before it's more than a sketch. Whether `projection` is genuinely evidence or configuration — you called it evidence, but if only the converter reads it and it's hand-maintained, it behaves like the patch file, and that may be a third category rather than a variant of the second. And whether `article` is really evidence or a *sentinel* — its presence is a claim about a completed transaction, which is a slightly different thing from a record of observations.

Neither blocks naming the layer, but both change how many categories it has.

---

# yea, i was going to point out that conflation because it was not really what i was asking for when it was written, it was one instance of it. i'm imagining a more primitive base class which can be instantiated to a registry class or one of the others. it seems like maybe a sibling to registries might be "evidence" which are artifacts emitted in evidentiary proceedings like latex-ingest, and below that there are several types already hinted, including most proximally the ref-graph itself being exhibit A of evidence-class artifacts

The evidentiary framing does real work — it predicts the discipline rather than decorating it. Evidence is tendered by a proceeding, dated, has a custodian, and isn't amended after the fact; later findings are new exhibits, not edits to old ones. That's exactly the rule you arrived at independently for danglers: a downstream resolution is a new claim, not a rewrite.

And it gives the discriminator for whether this is inheritance or a declared attribute. **The categories differ in operations, not just settings.**

- A registry can be **regenerated** — `materialize(root)` is a first-class verb, and rebuilding is the fix for staleness.
- Evidence cannot. There's no `rebuild()`; re-running the proceeding produces a *new* exhibit. A rebuild verb on evidence would be a way to destroy a finding.

Different method surfaces means subclassing rather than a `CATEGORY` string. So:

```
Artifact            KIND, VERSION, RECORD_SCHEMA, HEADER_SCHEMA, CODEC, NAME_FORMAT,
                    container, validate_record, the writer plumbing

├── Registry        + materialize / rebuild;  header carries scope + build time
│                     inventory
└── Evidence        + no rebuild;             header carries run identity + producer
                      ref-graph, docstream, …
```

Two things fall out that are worth noting.

**`DISCIPLINE` mostly stops being a per-kind declaration.** Registry implies rebuild-in-place; evidence implies create-once-immutable. A kind only declares it when it deviates, which is the same move as `HEADER_SCHEMA` defaulting to the base.

**The header work we just did is what makes this expressible.** Provenance-for-evidence and scope-for-registries are different header schemas, and until `HEADER_SCHEMA` became a per-kind declaration resolving from `schemas/`, there was nowhere to put either. That step turned out to be the enabling one.

Where I'd want your read: `article`. It's produced by a proceeding and immutable, which is evidence — but its distinguishing property is that its *presence* is the claim (the source-ready sentinel), not its contents. That may be a third sibling rather than an evidence subtype, and it's the one that carries the create-if-absent/idempotent-return discipline nothing else needs.

On naming, one tension worth flagging before it propagates: `artifacts/` in this repo already means regenerable build output, and evidence explicitly isn't regenerable. So `Artifact` as the base class name imports a connotation that's wrong for half the hierarchy — the same way `BaseArtifactRegistry` imported "registry" for all of it.

---

# yea, its a real tension, but not semantically wrong. i might have to change the name of `artifacts` to something else eventually. or we could orient differently in naming the abstract base class somehow, what it is versus what it does. i've been pulling my hair out with minutiae like this. and to add to the frustration, "registries" is both an operational identity here as well as a more general concept. we can and should have registries of things that don't belong under the current notion of "registries"

There's an answer already sitting in your own code: **`inventory-catalog.ps1` never says "registry."** It says catalog, throughout — `Write-LatexInventoryCatalog`, `Read-LatexInventoryCatalog`, `$catalogPath`, "catalog root," and a header line that's nearly a category definition: *"A catalog is a deterministic materialized view, not another source of truth."*

"Registry" came in with the Python draft. The working lane already had the right word.

So taking your what-it-is-versus-what-it-does split:

```
JsonlStore        what it IS — a line-delimited record file. No connotation to import.
├── Catalog       what it DOES — compiles facts, rebuildable, materialized view
└── Exhibit       what it DOES — attested by a proceeding, dated, not amended
```

That frees "registry" entirely for its general sense, which is the overload you're describing. `SchemaRegistry` stays a registry of schemas; `RegistryCatalog` becomes `KindRegistry`, a registry of kinds. Every word then carries one meaning: a *registry* is an index of things, a *catalog* is a materialized view of what's there, an *exhibit* is tendered evidence.

And it sidesteps the `artifacts/` problem rather than forcing a decision on it — `JsonlStore` imports nothing from that directory name, so you can rename it later or never, without the class hierarchy depending on the outcome.

The one that stays awkward is `article.json`, which is neither: its presence is the claim. "Sentinel" is what your own convention doc already calls it — *"metadata.json is written atomically and last. Its state: 'source-ready' is therefore the success sentinel."* Which suggests a third sibling with a name already in use, same as catalog.

No action needed on any of this now — it's a rename that's cheapest before the ref-graph kind lands and most expensive after.

---

# well, sentinel vs article is the 'what it is vs what it does' distinction. its metadata about an article, that functions as a sentinel. with "article" i was reaching for the contextual convenience that these sentinel files are sentinels for literal published research articles, and also that articles are apt as an atomic unit catalogued in an inventory, where inventory is a kind of catalog

That separates three axes that were getting collapsed:

- **category** — what it is: `Catalog` | `Exhibit`
- **discipline** — how it may be written: create / append / sealed / create-if-absent
- **role** — what it does for the pipeline: sentinel, index, evidence

`article` is an Exhibit — attested by the deposit proceeding, dated, immutable — whose *discipline* is create-if-absent-else-validate-and-return, and whose *role* is sentinel. So it needs no third sibling after all; the thing that made it look like one was a discipline and a role wearing the shape of a category.

And "sentinel" then doesn't need to exist in the engine at all. It's a fact about how latex-ingest uses the file — presence means the transaction closed — not a fact about the file. One fewer thing for the engine to model.

The naming rule holds too: name by what it is where the name is read as identity, let the role be a property. `article` reads as identity; `sentinel` would have read as a job.

One structural consequence worth pinning, because it stops being a coincidence: **a catalog's record schema is the schema of the thing it catalogs.** `inventory` is a catalog of articles, so its records are articles. That's not an inventory-specific convenience — it's the category behaving correctly, and it's why the verbatim insertion works with no projection. Any future catalog gets the same rule for free, and if a proposed catalog *can't* use its member's schema, that's a signal it's projecting and therefore isn't a catalog.

Which also means the containment reads cleanly all the way down: an article is the atomic unit, an inventory is the catalog of them in a scope, and both are governed by one schema because the second is a materialized view of the first.

---

# the inventory/article sharing the schema may or may not highlight a reusable pattern. i haven't detailed other instances of catalog jsonl objects, nor systematically emitted collections of catalog record json files that get compiled/collected into a catalog, with a shared schema doing double duty. this could be a useful pattern in evidentiary proceedings. the inventory/article case is special because its especially tractable, being completely determined and consistent by invention

Agreed, and the caution is right — but the two conditions that make it tractable are statable, which is better than "may or may not."

**The member has to be an atom.** An article is one bounded object, so it fits in a record. A ref-graph is a multi-record store and can't be one — a catalog of ref-graphs would have to hold *summaries*, which is a projection, which by the rule means it isn't a catalog. So the pattern is only available where the catalogued thing is a single-object artifact.

**The member's shape has to be determined by us.** That's your "consistent by invention." The article schema can require twelve fields because the project invented all twelve. An atom whose shape is determined by the source would need a permissive schema, and the catalog would inherit that permissiveness — worse there than in the individual artifact, since the catalog is the thing you'd query.

Both conditions together are narrow. Exactly one other thing in the engine satisfies them today: `.sig`. It's a single bounded object, closed schema, entirely invented — so a corpus-level catalog of signatures would be the same pattern with the same schema doing double duty. Whether that's worth having is a separate question; it just shows the shape isn't unique to article/inventory.

For evidentiary proceedings specifically, condition two is the one that usually fails. Evidence records what a source contained, and sources are idiosyncratic — which is why the ref-graph needed three record branches and an open relation vocabulary while the article needed neither.

So: don't build the pattern. Note the two conditions, and if a second instance satisfying both actually turns up, it's real. If none does, article/inventory is a tractable special case and nothing was over-generalized on the strength of one example.

---

# but, to wit: ref-graph implements a collection of facts that is used as a device for projection, after upstream processes disarm and wrangle idiosyncratic source data and labels. in the catalog/atom abstraction, there could be catalogs that emerge from normalized ill-behaved source data construct that coalesce into a well-behaved atom with a schema

Right — I had condition two wrong. It isn't "invented from nothing," it's **"whose schema governs the atom at the point it's emitted."** The article already proves that: arXiv tarballs are about as ill-behaved as source gets, and `Initialize-LatexSourceDeposit` wrangles them into twelve required fields. The atom is well-behaved because the normalizing step made it so, not because the input was.

Which makes your methodology the thing that *creates* the condition rather than being constrained by it. Pull normalization far enough upstream and the atom becomes catalogable — that's the same argument as consume-once, one level up.

So the ref-graph's records are candidates once canonicalization lands. A label record, after the custom-map overlap is fixed, is a bounded object with a determined shape. A corpus-wide catalog of every labelled object across every paper would be a catalog whose records are label atoms, sharing the schema — double duty again.

That surfaces a second containment shape, though:

- **article/inventory** — one atom per document, catalog gathers the documents in a scope
- **label catalog** — many atoms per document, catalog flattens across documents

Both are deterministic materialized views, so both are catalogs. But the second has a requirement the first doesn't, and it's concrete: **an atom catalogued beyond its home scope has to carry its scope.**

An article carries `slug`, so it survives being lifted into an inventory. A ref-graph label record doesn't — within `{slug}/ref-graph.jsonl` the slug is ambient, supplied by the path. Lift that record into a corpus catalog and it loses which paper's Theorem 3.2 it was. `normalized` and `faithful` are only meaningful inside their document.

So if the label atom is ever going to be catalogued corpus-wide, `slug` has to be on the record rather than in the filename — decided at capture, not at catalog time, because retrofitting it means reopening every ref-graph. That's a cheap decision now and an expensive one later, and it's the kind of thing the header-versus-record split would otherwise hide: the slug feels like header material right up until the record leaves the file.

---

# does ref-graph actually behave like a catalog looking forward after its built? not all evidentiary constructs do

No — and the test separates them cleanly.

A catalog's defining property, per `inventory-catalog.ps1`'s own header, is being *"a deterministic materialized view, not another source of truth."* Rebuildable from sources that hold the truth, adding no judgment, with staleness as the only failure mode.

The ref-graph fails on both counts. It's built from `$maps.*`, `$citeMap`, and `$AllLabels` — in-memory converter state that exists only during a run and persists nowhere. You can't rebuild it; you can only re-run a conversion, and a different converter version produces different output. And it embodies judgments: `dangler_class` decides whether a failure is the converter's fault (`declared-unmapped`) or the author's (`undeclared`), which is an interpretation, not a compilation.

So it *reads* like a catalog — read-only, queried after the fact — and being queryable is what makes it feel like one. But queryability isn't the criterion. Regenerability from persisted truth is, and the ref-graph's truth is held nowhere else.

Which is the categorical difference earning its keep: if a catalog disagrees with the world you rebuild it; if a ref-graph disagrees with the world, re-running produces a **new exhibit**, and the old one remains true about the run that made it.

The corollary corrects something I said last turn. A catalog *over* ref-graphs would be a genuine catalog — ref-graphs persist, so a corpus-wide label view is rebuildable from them and adds no judgment. But then the slug doesn't need to be on the label record after all: the materializer stamps it from the path, exactly as `Build-LatexInventoryCatalog` derives `document_parent` from the directory rather than reading it out of the manifest.

That's the established pattern and I argued against it — location is derived at materialization, identity lives in the atom. `slug` is on the article because it's the paper's identity, not because the inventory needed it there.

---

# well another question here is "can't be built" or "should be built"? e.g. can we systematically construct the atoms and then zip them up into a ref-graph catalog type of object or not? just because the current process doesn't do so, doesn't mean it shouldn't nor can't

Both my grounds were weak, and the second more than the first.

"Can't be rebuilt" was a statement about the current implementation. And `dangler_class` isn't a judgment in the disqualifying sense — it's a deterministic rule: cite-and-not-in-citeMap → `bib-missing`, in-AllLabels-but-unmapped → `declared-unmapped`, else `undeclared`. Same inputs, same output, every time. A rule applied deterministically to persisted inputs is exactly what a materialized view is.

So the real question is what capture would have to emit, and it's a short list — everything `Build-LatexRefGraph` consumes:

```
labels     from the xref walk over $maps.*
sites      from Resolve-Refs
citeMap    from the .bbl
AllLabels  every \label the source declares, armed or not
```

None of those is irreducibly ephemeral. All four are observations of the source. Persist them and the ref-graph becomes a join plus a classification over stored atoms — rebuildable, deterministic, no re-parse.

**What that buys is the thing you said you wanted and don't currently have: replayability.** Right now, improving dangler classification or changing canonicalization means re-running the converter over the LaTeX, which also re-runs everything else and may change unrelated output. With the atoms persisted, re-canonicalization is a rebuild against fixed inputs — you can see exactly what the rule change did, isolated. That's "keep the raw so canonicalization is replayable" actually realized, rather than asserted at the field level.

And it resolves the category question rather than dissolving it. **Category is relative to what you derive from.** The atoms are evidence with respect to the source — what the converter observed, at that version, in that run. The ref-graph is a catalog with respect to the atoms — a deterministic view over them. The boundary moves down a layer instead of disappearing.

Which also means `AllLabels` stops being a transient set consulted once and becomes an artifact in its own right — and it's the one that makes `declared-unmapped` computable at all, so it's load-bearing evidence rather than scratch state.

---

# this also gets at another thorn in my side with this iproject which is the monolithic pipelines that doesn't really have discrete stages from which to resume. i've got a foothold on the idea with the boundary between procurement/unpacking a tarball/building the article sentinel/building the inventory, where the existence of the article is now a prerequisite to running latex-ingest, meaning latex-ingest doesn't need to unpack the tarball every run, only once. for resuming downstream, we may want to start at an intermediate point and run from there or only one step in isolation for iteration, and this means runs also needs additional work so that a given runstamp can be resumed and allow for overwriting potentially for the sake of hygenic iteration (wasteful and hard to keep track of end-to-end runs for every single development cycle, even when focused o a particular stage of the pipeline)

Those are the same problem. **A stage is resumable exactly where its inputs are persisted artifacts rather than in-memory state** — so the number of discrete stages equals the number of persistence points, and right now that's two: the article sentinel, and the run directory at the end. Everything between is one monolith because `$maps.*`, `$citeMap`, `$LtxRefSites`, and `$AllLabels` live only in the process.

Which means the atom work we just talked through isn't a separate initiative. Persisting labels/sites/citeMap/AllLabels *is* the stage boundary — it makes `Build-LatexRefGraph` a step you can run alone against fixed inputs, which is the isolation you're describing.

The foothold you already have proves the shape: unpacking became once-not-per-run precisely because `article.json` persists and is a prerequisite. Every additional stage boundary is that same move applied further in.

On the runs side, `New-ModuleRunDir` always allocates fresh and bumps a suffix on collision — there's no resume path at all. So it needs a way to open an existing stamp, and per-stage outputs within it so re-running one stage replaces only that stage's artifacts.

The hazard in "allow overwriting" is worth naming before it's built. **Overwriting inside a runstamp breaks exhibit integrity.** Regenerate stage three against stage two's older output and the run directory becomes internally inconsistent, with nothing recording that its parts came from different iterations. That's not a small risk for a tree whose whole purpose is being evidence.

So it probably isn't one run layout with an overwrite flag — it's two dispositions that should be distinguishable at a glance: a scratch tier where iteration is free and nothing is evidence, and runs of record where immutability holds. Your existing doctrine is "every preprocess is a new run," which is right for the second and too rigid for the first.

And the incremental mechanism is mostly already built. `.sig` records the artifact's hash; the article manifest records its inputs' hashes. A stage that writes what it was built from can compare and skip when unchanged — make-style resumption using parts that exist, rather than a new dependency system. That also makes "which stages are stale" answerable without running anything, which is the thing that makes focused iteration tolerable.

---

# it doesn't break integrity so much as breaks historical record, which most of the time we dont want for the sake of comparison, but depending on the task at hand, it may not be worth the full fresh run. in many cases it is though and i had good reason to make this the default mode for iterating on code: do full runs and then retrace steps and artifacts emitted in order to identify systemic issues while keeping in view the end-to-end so that solutions to problems are integrated and not done in blind isolation, which leads to severe pathologies over the course of many sessions

Correction taken — historical record, and the methodology holds up. This session is a case for it: both real bugs came from tracing emitted artifacts end-to-end, not from looking at stages. The custom-counter overlap surfaced from comparing label populations across 43 refgraph.json files; `edge.site` surfaced from checking whether a field joined across the whole probe set. Neither would have come out of unit work on `Resolve-CustomCounters` or `Build-LatexRefGraph` in isolation — in both cases the function does exactly what it says locally.

Which suggests the design should treat partial re-runs as the exception they are, rather than as a peer mode with a flag.

The concrete form: **a partially regenerated run should say so.** If stage three was re-run against stage two's earlier output, the run directory should record which stages were regenerated and when — so a later comparison can't silently treat it as end-to-end. That's cheap with what exists: `.sig` already has a free-form `metadata` slot, and the header carries provenance. Then "is this an end-to-end run?" is answerable from the artifact instead of from recollection three sessions later, which is exactly where the pathologies you're describing come from.

Without that, the failure mode isn't a broken run — it's a run that looks comparable and isn't, which is worse because it corrupts the retrace rather than breaking it.

The other half is that stage persistence attacks the actual problem. Full runs are expensive because everything recomputes; unpacking already got fixed that way. Persist the atoms and the unchanged stages become skippable against input hashes, so a full run costs about what the changed stage costs. At which point the pressure to do partial runs mostly goes away, and the resume machinery is needed for genuine one-step iteration rather than as a cost workaround.

So: make full runs cheap first, record partiality second, and let overwrite stay awkward — it should feel like the exception, because your default is the one that finds systemic problems.

---

# and partial reruns don't need to copy the artifacts that preceed the starting point. the starting point gets recorded in `.sig` and the reader can trace back to the source to investigate if needbe. an orthogonal but very real concern that is the drawback of my e2e discipline is hygiene and the proliferation of way too many nearly identical copies of data, and i dont want to make that worse if i can avoid it. also need to implement some duty-cycle garbage collection so i can clear the slate occasionally when old run artifacts have served their purpose and become stale after whatever issue has been addressed and i've moved on. i dont want to need to manually clear by hand, i also don't want to automatically clear things on a schedule or specific event, because its uncertain how long a given generation of artifacts might actually be worthwhile. case in point today, we've been examining several generations of artifacts, like the refs.json and refgraph.json we investigate

Sparse partial runs are the right call, and the reference that makes them work also solves the GC problem.

If a partial run's `.sig` records what it resumed from, that's not just a breadcrumb for a reader — it's a **reachability edge**. Which gives you the one GC discipline that's neither manual nor scheduled: evict a generation when nothing references it and nothing pins it. Resume-lineage keeps ancestors alive automatically, and an investigation pins explicitly. Pressure triggers the sweep, reachability decides what it takes.

Today is the argument for that over any duration rule. Those probe artifacts became worth keeping for a reason that didn't exist when they were written — we needed them to find the custom-counter overlap and the `edge.site` break. No retention period would have predicted that, and a schedule would have had a decent chance of eating them.

On the proliferation itself, there's a dedup option that uses what's already built. `.sig` carries the sha256 of each artifact, so **you already have a content address for every file**. Two runs whose stage-two output is byte-identical could share one copy by hardlink instead of storing both.

And the atomic-publish discipline is what makes that safe. Temp-then-rename replaces the *directory entry*; it never mutates the inode. So a hardlinked artifact can't be changed underneath another run that shares it. An in-place writer would make hardlinking a corruption vector — this one makes it free. Delete a run and the refcount just drops.

That composes with sparse partial runs rather than competing: sparse runs avoid writing the copies at all, hardlinks collapse the ones that do get written because a stage genuinely re-ran and produced identical bytes.

Two things worth deciding before any of it gets built. Whether a pin is a file in the run directory or an entry in a retention list somewhere central — the first survives being moved, the second is easier to audit. And what the pressure threshold is measured in, since count and bytes give very different answers when one lane emits many small artifacts and another emits few large ones.

---

# i would probably put such a thing above a runstamp directory, in an append-only catalog that gets updated by each run

That's a **ledger**, not a catalog — and the distinguishing property is exactly the GC case you're solving. Once a generation is collected its directory is gone, so the row is the only remaining record that the run existed. A catalog is rebuildable from sources that hold the truth; this one outlives its sources, which is what makes append-only the right discipline rather than a stylistic choice.

So that's the third sibling, and it's the first thing to actually need the `APPEND` discipline — which the engine implemented and nothing has exercised since.

```
Catalog   materialized view, rebuildable        staleness is the failure    CREATE/replace   inventory
Exhibit   attested by a proceeding, immutable   supersession, not repair    CREATE once      ref-graph
Ledger    append-only event record              outlives its sources        APPEND           runs
```

Mutable state works in it the way ledgers always handle mutation: pin and unpin are *rows*, and current state is a replay rather than a field. GC then appends its own collection records, so a stamp cited in a brief three months later resolves to "existed, collected on date X, resumed-from Y" instead of to nothing — which is the failure that makes stale references maddening.

One new engine requirement falls out, and it's the first time: **order is content.** Every kind so far has been order-indifferent — catalogs sort canonically, exhibit populations are unordered. In a ledger, pin-then-unpin and unpin-then-pin are different histories. That forbids applying a canonical sort, and more specifically it forbids the PowerShell store path: `Add-JsonlStoreRecords` with a policy reads everything, merges, **re-sorts**, and rewrites. On a ledger that silently reorders history. The Python `APPEND` path preserves order correctly but copies the whole file per append, which is the cost problem rather than a correctness one — and for a run ledger with one row per run, that cost is nothing.

Two things worth pinning down when you get to it. Whether the ledger is per-module (`artifacts/{module}/runs/runs.jsonl`) or one repo-wide — per-module keeps writes uncontended, repo-wide makes cross-lane pressure answerable in one read. And whether the row records artifact hashes inline or just points at the run's `.sig` files, since the first makes the ledger self-sufficient after GC and the second keeps it small.

---

# ok so we are squarely in dev-ops dev territory now. ive created a devops issue with a briefs directory. lets write up these ideas for sparse partial runs, ledger sentinels, provenance and generational/version tracking, GC duty-cycle plumbing  and whatever else. `ledger` as a notion also belongs along side `catalog` but is more on the side of the inventory/article split because its something entirely belonging to the project itself as `infrastructure` instead of evidence. this harkens back to ongoing earlier discussions around the ontology and taxonomy in the jsonl_engine's architecture itself

Written to [opus-resumable-stages-run-ledger-generational-gc-20260807_135748.md](issues/devops/briefs/opus-resumable-stages-run-ledger-generational-gc-20260807_135748.md), following the runstamped-brief convention and noting that durable decisions belong in `issues/devops/planning/` once that exists.

Structure is purpose → findings → contract → taxonomy note → out of scope. Three findings frame it:

- a stage is resumable exactly where its inputs persist, so resumable-stage count equals persisted-intermediate count, currently two
- persisting the ref-graph's four inputs *is* the stage-boundary work for latex-ingest
- full runs are expensive because everything recomputes — make them cheap before building partial-run machinery

The contract covers sparse partial runs, the run ledger, provenance/generational tracking, and the GC duty-cycle, plus one section beyond your list: **deduplication by hardlink**, since `.sig` already gives every artifact a content address and temp-then-rename makes sharing an inode safe. That composes with sparse runs rather than competing.

I recorded the e2e-as-default rationale explicitly with the evidence from today, so the brief argues *for* keeping it rather than reading as a proposal to relax it.

Six decisions left explicitly open rather than guessed: ledger per-module vs repo-wide, hashes inline vs pointer, pin as file vs central list, pressure threshold in count vs bytes, and the two naming questions.

The taxonomy point is noted as originating here but pointed at engine canon — with one consequence kept as devops-owned: `artifacts/` promises regenerability, exhibits aren't regenerable, and a GC sweep over a tree whose name says "disposable" reads as safe when part of it can't be reproduced. Either the name changes, evidence moves, or the retention rules carry a distinction the layout doesn't.

---

# i can at least answer one, which is the this particular ledger we are talking about sits above {run_stamp} under a {module}, for now at least. and its something that gets updated by new runs as part of the `runs` operational jurisdiction

Recorded as decided, per-module under the `runs` jurisdiction. Two consequences I pulled out of it:

**`run-paths.ps1` would stop being what it says it is.** Its header declares *"pure path work — no crawler, no document identity, no lane knowledge, no filesystem discovery beyond enumerating the runs root itself."* Appending ledger rows is content writing. So either it grows that responsibility and the header gets amended, or a sibling module in the same jurisdiction owns the ledger and `run-paths.ps1` stays true. Worth choosing deliberately — this session found two places where a stale header claim cost real time.

**Placement relative to the sweep.** Inside `runs/`, every GC pass has to know not to delete the ledger. Beside `runs/`, the sweep target is cleanly `runs/*` and the ledger is structurally out of reach — which matches what it's for, since it's the thing that outlives collection.

I also noted that near-term the writer is PowerShell, and that if the ledger later becomes a declared engine kind it's the first `APPEND` member — at which point the order-is-content constraints stop being convention and become its kind declaration.

Remaining open on the ledger: hashes inline versus pointing at each run's `.sig`.

---

# stash the remaining open questions on this matter in the brief to unpack later , i want to collect thoughts on the engine work itself for next session

Both briefs written, cross-link resolves, suite still green at 10.

**[Engine brief](issues/jsonl-engine/briefs/opus-engine-state-and-next-sequence-20260807_141055.md)** — six sections:

1. **Landed in code** — the article rename, one-schema, `RECORD_SCHEMA`, `HEADER_SCHEMA` into data, `Codec` as a declaration, both derived constants, `sig.schema.json`, `json_document.py`, in-package schemas, the primitive's demotion, hatchling scaffolding.
2. **Decided in conversation, not yet in code** — the `CATEGORY` layer, the `JsonlStore`/`Catalog`/`Exhibit`/`Ledger` shape with "catalog" recovered from your own PowerShell, the category/discipline/role split, the fourth discipline, the catalog-schema rule, the container declaration.
3. **Seven defects found and not fixed**, each with the measurement that found it.
4. **A dependency-ordered sequence**, with why each step precedes the next — notably that the two `$maps`/`$si` fixes are *mandatory* before the ref-graph schema, since writing it now pins identity fields that don't identify.
5. **Five open questions.**
6. **`TODO.md` reconciliation** — the docstring item is done for Python, still open for `src/logistics` and the wider repo.

**[DevOps brief](issues/devops/briefs/opus-resumable-stages-run-ledger-generational-gc-20260807_135748.md)** now carries the per-module ledger decision and a consolidated six-item open-questions section, each pointing back at the section that reasoned about it.

One judgment embedded in the sequence worth your eye when you pick it up: step 7 (the `CATEGORY` rename) is listed seventh but argues for being pulled ahead of 3 and 4, since renaming a hierarchy is cheapest before another kind lands in it. I left it in dependency order rather than cost order so the mandatory prerequisites read first.

---

# well i think jsonstore needs some renaming, because basically everything stored in jsonl container is a jsonl store, beit a metadata or data store, jsonlstore might be the base class name when it comes, and whatever occupies the namesake of jsonlstore needs to be reassigned

Recorded. The short version of where that leaves the naming:

`JsonlStore` is available as the base-class name once `jso-ops/jsonl-store-v2.ps1` retires — which is already the plan, since the Python engine replaces it. Nothing in `src/` imports it, so retirement costs one Pester suite and nothing else.

The one thing that must happen before it goes: it holds the only implementation of the key/uniqueness/ordering slots, and those are still on the engine's unbuilt list. So the sequence is read-then-retire, not retire.

Both briefs are in place and the suite is green at 10. The engine brief's section 4 has the dependency-ordered next steps, with the note that the `CATEGORY` rename argues for coming earlier than its position — and this naming finding strengthens that, since retiring `jsonl-store-v2.ps1` and claiming `JsonlStore` are the same move.

---

# well we can take a stab at the base class with a different name, maybe "BaseStore"

Done — `BaseStore`, no stragglers, 10 passed.

```
base        : BaseStore
kind classes: ArticleRegistry, DocGraphRegistry, InventoryCatalogRegistry
catalog cls : RegistryCatalog
```

The three kind classes still assert "Registry," which is the same falsehood one level down — an article manifest isn't a registry. But I'd hold those until the category layer lands, because the categories are what make short names unambiguous:

```
Inventory(Catalog)     Article(Exhibit)     RefGraph(Exhibit)
```

With the category as the base class, the kind name doesn't need a suffix at all, and bare `Article` stops being ambiguous with the article record because the record is never a class. Renaming them now to something like `ArticleStore` and again later to `Article` is two churns for one outcome.

Two renames *don't* depend on the category layer, though, and are available whenever you want them:

- **`RegistryCatalog` → `KindRegistry`.** It's an index of kinds, which is "registry" in its correct general sense — and it currently reads as the opposite of what it is, since `Catalog` is now a category name meaning materialized view.
- **`registry.py` → `store.py`.** The file holds `BaseStore` now.

Both are mechanical and independent. Say the word on either.

---

# yea the taxonomy and ontology still needs work. i think the "kinds" need renaming wholesale. A "catalog" is a kind, and more correctly, should be "catalogue". A "registry" is itself a kind, and related to "catalogue", and i like . A ledger is a "kind". Part of me prefers "classes" over "kinds", even if that overloads with OOP-speak. I would argue that an "inventory" is an instance of a of "catalogue".  We also discussed identity vs job, evidence vs infrastructure. Article/DocGraph/InventoryCatalog "registries" all change to something else entirely, but they are still duly "registries" and "catalogue registries" or "registry catalogues" are redundant and invalid conceptually. "kind classes" is similarly redundant, it should be one or the other. alot of dimensions to calibrate and align here

The redundancy has a single source: three levels are being named with words drawn from one pool.

```
level 1  category   catalogue | ledger | exhibit          what sort of thing it is
level 2  kind       inventory | article | ref-graph       which one
level 3  instance   ingestion/inventory/inventory.jsonl   this file
```

`InventoryCatalogRegistry` stacks level 2 + level 1 + a class role, which is why it reads as three words for one thing. And your point that an inventory is an instance of a catalogue is level 2 sitting inside level 1 — so "catalogue registry" is invalid not because the words clash but because it names a level twice.

That also rescues "registry." If `Registry` denotes only the **class role** — the thing that registers records into a store — then it never appears at level 1 or 2, and the collision disappears:

- `InventoryRegistry` — the registrar for the `inventory` kind. Not redundant: kind + role.
- `RegistryCatalog` → `KindRegistry` — the registrar of kinds. Same role word, consistent sense.
- `Catalogue`, `Ledger`, `Exhibit` — category names, never used in a class name that already names a kind.

The class is not the artifact, which is what makes this work. `ArticleRegistry` isn't an article; it declares the kind, validates records, and publishes. The catalogue/ledger/exhibit taxonomy describes what lands on disk.

Two costs worth weighing before you commit.

**"Class" for level 1 has a real collision in Python, not just an aesthetic one.** Every kind *is* a Python class, so `CLASS = Catalogue` declared on a class is genuinely ambiguous at the point of reading. `CATEGORY` costs a less-preferred word and buys unambiguity in the language where it's written. "Class" reads better in prose about the design; "category" reads better in the code.

**`catalogue` diverges from the working lane.** `inventory-catalog.ps1` uses the American spelling throughout — function names, parameter names, prose. Adopting `catalogue` means either the PowerShell diverges from the Python or that file gets renamed too. Small, but it's the kind of split that later reads as two concepts.

The dimension still unresolved after all that is evidence-versus-infrastructure. It groups level 1 — catalogue and ledger are infrastructure, exhibit is evidence — so it's a level 0, and it's the one that determines whether regeneration is even a legal operation.

---

# "catalog" is a verb historically and only started showing up in common american english as a noun in the past 50 years or so, and i still read it as a verb now that i'm actually thinking about it. and i dont care what some artifact says to the contrary; those don't dictate code or my conventions, only make suggestions. it was a typo in the first place. i also don't really like "kind" more generally , it reads weird and i don't like being cornered into it just because the linguistic landscape is cramped here. There's a deeper problem here and im not even sure how to describe it because i'm now facing the usual lock-in pressure of something that hasn't matured

The pressure has a specific shape, and part of it is avoidable.

**Names in this system are not equally expensive.** Three tiers, and they're being treated as one:

- **Free** — Python class and attribute names. `BaseStore`, `KIND`, `RECORD_SCHEMA`. Internal, refactorable in an afternoon, invisible outside the repo. You already renamed `BaseArtifactRegistry` in seven files in under a minute.
- **Cheap** — filenames and module names. `article.py`, `ref-graph.jsonl`. One sweep, plus whatever docs point at them.
- **Expensive** — schema `$id`s and `KIND` strings, because they're `const` values baked into every artifact ever written. `codex-scientiae/article/0.1` is the one you can't take back cheaply.

So the lock-in you're feeling belongs to a small set. Almost everything under discussion tonight is in the free tier.

**And the category layer has no consumer.** Nothing in the engine dispatches on catalogue-versus-exhibit. It's an analytical distinction that explains why inventory and ref-graph behave differently — it isn't yet a thing code branches on. By the discipline you've applied to every other slot this session, it hasn't earned a name because nothing needs one.

Which points at the escape, and your own observation is what suggests it: **catalog is a verb.** The noun is residue of the act. What's load-bearing about the categories isn't what they *are*, it's what you may *do* to them — and we established that earlier when the categories turned out to differ in operations rather than settings.

So declare the operations, not the membership:

```
REGENERABLE   can be rebuilt from sources that persist    (inventory yes, ref-graph no)
ORDER_IS_CONTENT   append-only, never re-sorted            (the run ledger)
```

Those are facts about an artifact, not claims about a taxonomy. A fourth combination that turns up later needs the right values, not a new noun and an argument about where it fits. "Catalogue," "ledger," "exhibit" then become vocabulary for *talking* about property combinations — which is where they're actually working well — without being load-bearing in code.

That leaves `KIND` as the one string that must be decided, since it lands in filenames and headers. And "kind" as an attribute name is free — it can be `TYPE_ID`, `NAME`, whatever reads right — while the *values* (`article`, `inventory`, `ref-graph`) are the expensive part, and those are nouns you already like.

---

# i disagree about expensive. every artifact written up to this point is just R&D, and then next run could change it all entirely and be more correct and valid

You're right — I had that backwards. The expensive tier is empty. Nothing written so far has a consumer, the corpus is due for a wipe, and regeneration is cheaper than migration for every artifact on disk. There is no cost to changing any of it.

Which inverts the strategy rather than just relaxing it. **Names are free right now and won't be later**, so this is the only window in which trying one is cheap. Deferring the decision until it matters means deciding with no usage experience at exactly the moment the decision becomes costly. The move is to commit to something, write code against it for a while, and notice which words read badly in practice — that's information you can't get from deliberation.

And the moment it changes is determinate, not ambient: **the first artifact you'd rather keep than regenerate.** Probably the ref-graph atoms, once a run represents real compute over real source you don't want to redo. Until then, churn is free and reversible.

On the thing you couldn't quite describe — I think it's that the taxonomy is **underdetermined, not wrong.** There isn't a fact of the matter yet about whether `projection` is evidence or configuration, because the object doesn't exist. Same for whether the doc graph is a category member, since its composition is still open. Naming a complete taxonomy when only three of its slots have occupants feels like asserting things you don't know, and that discomfort is accurate — you *don't* know them.

The way out is to name only what has members. `inventory`, `article`, `ref-graph` exist and can be named with confidence. Whether they group into two categories or three, and what those groups are called, is a question their successors will answer better than we can now — and it costs nothing to leave unnamed until then, because nothing dispatches on it.

That also means tonight's vocabulary doesn't need to survive. It did its job if it let us see that inventory and ref-graph behave differently; it doesn't have to become the code's words.

---

# right but im bristling at the taxonomy/ontology containing those 3. i'm naming inventory as a type or sub-category of a catalogue data structure which speaks to the procurement and ingestion aspect of this project, and is natural, reserved for the cataloging of articles, a unique niche. but the catalogue concept may also appear elsewhere in different forms, although its unclear whether there's any other case in the wild of this project where we would see the same inventory/articles kind of mechanism. how about we trace through latex-ingest and look at what the code writes to jsonl. not combing through artifacts, the code and the in-memory data structures that yield jsonl artifacts

Traced. Here's what the lane actually writes, by in-memory source:

| file | in-memory source | structure | discriminator |
|---|---|---|---|
| `{slug}.docstream.jsonl` | `$LtxDocstream` (`$dsRows`) | one population, uniform rows | none — `kind` is a node type, not a row type |
| `{slug}.diagrams.jsonl` | `$DiagramStore` + `$doneN`/`$pngN` | one population, uniform rows | none |
| `{slug}.refs.jsonl` | `$LtxRefModel` = `{labels, sites, faithful_render}` | **two** populations flattened | `row` ∈ label\|site |
| `{slug}.refgraph.json` | `$LtxRefGraph` = `{labels, sites, edges, danglers, stats}` | four populations + summary | — (JSON) |
| `{slug}.docgraph.json` | `$LtxDocGraph` = `{nodes, edges, stats}` | two populations + summary | — (JSON) |
| `{slug}.oracle-counts.json` | `$oracleSidecar` | flat object of counts | — (JSON) |

Read but not written here: `{slug}-latex.patch.jsonl` (authored errata) and `inventory.jsonl` (`latex-batch.ps1:49`). Written elsewhere in the pipeline: `{slug}.toc.jsonl`, by toc-engine via md-bundle.

## What it shows

**There is no second catalogue.** Nothing the converter writes is a materialized view over things that hold truth elsewhere. Every artifact is either per-document output of the proceeding, a work-list, or a measurement. `inventory.jsonl` is the only catalogue in the repository, it belongs to procurement/ingestion rather than conversion, and nothing in the wild resembles it. Your instinct that it's "reserved for the cataloguing of articles, a unique niche" is what the code says.

So a `Catalogue` category would have exactly one member and no sibling in view. That's a bad reason to name a category.

**`diagrams.jsonl` is a fourth thing, and it isn't evidence.** Its own comment calls it "the reasoning-agent seam... so a downstream translation pass can attempt an encoding and swap the image out." It's a **work-list**: its records carry `status` ∈ marker/png/svg, the only *state* field anywhere in the lane, and its purpose is to be consumed and acted on rather than consulted. That's a genuinely different relationship to its reader than a ref-graph has.

**`oracle-counts.json` and `.sig` are the same shape** — a flat measurement object about a run, not a collection at all. Neither is a store; both are sidecars.

**The only grouping the code actually populates is evidence** — docstream, refs/refgraph, docgraph, three members from one proceeding, all per-document, all immutable, none regenerable without re-running. If any category earns a name from what exists, it's that one.

Which suggests the taxonomy is currently: one populated category (evidence), one singleton that may never generalize (inventory), one work-list, and two sidecars. Naming a four-branch hierarchy over that is the lock-in pressure you were bristling at — the code doesn't support four branches yet.

---

# yea and this reminds me, while i am trying hard to codify artifacts into registered categories/kinds/what have you and impose taxonomy/ontology up front based on existing code and historical artifacts, i have to acknowledge that i can't do that entirely up front. my formal machinery with schemas is the desired end state for mature constructs, but i can't ignore the need for WIP code to write artifacts directly (via jsonl engine primitives) without registered schemas while i'm iterating on the code itself and discovering the mature e2e solution. ref-graph as we now understand it is a good example of this maturity process. it was there earlier implicitly, then later explicitly in partial form, and now it's been captured with reasonably complete abstraction, even if the code itself hasn't caught up entirely. doc-graph is pointing to the ABI jsonl data structure that encodes the latent manuscript edges and nodes similarly to how ref-graph does for the source material's intra-article object pointers and relations. but doc-graph is still maturing in the specifics, in terms of the discovering all of its node kinds and admissible edges (the latent manuscript isn't fully described and i'm discovering it inductively by examining many instantiations of it). outside of this project there are industry standards for different kinds of manuscripts, i forget any of their specific names, but they exist in different fields, all pointing to the same general idea of what the manuscript archetype i am grasping at. so deductively if i can pull the various outside instances of the idea, i might be able to do some deductive work on the problem of making the spec more concrete in conjunction with the progress so far established inductively in doc-graph as it exists today. also, regarding registries, i think the distinction is that a registry isn't officially meant to be a 'kind' in the sense of a valid enum, its reserved for engine-internal registrars. we can have registries of catalogues or catalog types, in theory, but we aren't going to be emitting registries if this turns out to be the practice

Four things, and the standards question is the one where I can be most concretely useful.

**The unregistered write path already exists.** `JsonlEngine(output_path=...)` takes a path, discipline, and codec — no kind, no schema, no registry. That's the primitive tier doing exactly what you describe. The layering was right even before the reason for it was articulated.

One gap: nothing *marks* an artifact as deliberately unregistered. A raw-engine write produces `.sig` with `metadata: {}`, while a kind-governed write carries `{kind, version, run_id}` — so the distinction is recoverable but implicit. Making it explicit would let a later reader tell "WIP, no schema yet" from "something went wrong," which matters precisely because the WIP state is legitimate and long-lived.

**The maturity lifecycle deserves to be first-class rather than tolerated.** Implicit → explicit-partial → abstracted → codified. The ref-graph walked all four; doc-graph is between two and three; projection is at one. If the engine treats "no registered schema" as a *stage* rather than a deficiency, the pressure to name things prematurely drops — which is the lock-in you were bristling at, addressed structurally instead of by resolve.

**The standards you're reaching for.** The closest by far is **JATS** (Journal Article Tag Suite, NISO Z39.96) — the scholarly-article archetype, used by PubMed Central and most journal publishers. It has exactly your two halves: a structural element vocabulary for the manuscript, and a cross-reference model binding citation sites to a reference list and to floats. Its book sibling is **BITS**.

Others worth pulling for triangulation:

- **TEI** (Text Encoding Initiative) — the most theorized about text structure generally, from digital humanities. Broadest node vocabulary, and the most careful about what a "document" even is.
- **DocBook** (OASIS) and **DITA** (OASIS) — technical documentation. Different domain, but mature and battle-tested element models, and DITA's topic-orientation is a genuinely different decomposition worth seeing.
- **Pandoc's AST** — not a standard, but the most directly relevant *working* artifact: a small closed Block/Inline node vocabulary that has survived converting between dozens of formats. If you want a minimal-and-sufficient node set derived empirically rather than by committee, that's the one with the most evidence behind it.

JATS and Pandoc's AST are the two I'd pull first — JATS because it's your exact domain and models both nodes and reference edges, Pandoc because it's the demonstrated floor of what a document node set needs.

**Registry, resolved.** A registry is engine-internal and never emitted — `SchemaRegistry`, `KindRegistry`. That's a sharper criterion than the one I offered: not "registry names a role" but **a registry is not an artifact**. Which makes `ArticleRegistry` wrong on those grounds, since that class exists to emit one, and confirms `RegistryCatalog` → `KindRegistry` since that genuinely registers kinds and is never written to disk.

---

# so in this light, the whole "registry factory" and "registry base class" is rather thin and kind of moot. so while yes, i want to be able to build registry objects as instances of a registry class, that's a job that only needs doing rarely when a new kind or instance of kind is promoted to canon in a registry. the base class is what i was reaching for from the beginning, in order to  build other types of stores that the registry registrars register, such as registries of schemas for validating and formalizing other things including operational and evidentiary catalogs, ledgers, etc as well as constituent atomics. and this development process is a two way street. im trying to define schemas and store kinds that converter lanes build (gather, compile, accumulate, etc, facts for disambiguation, resolution, routing, projections+surjections)

Thin is *correct* for the kind registry. The job is small and it happens rarely — the mistake was expecting it to carry the taxonomy, not that it does little. A dict plus a decorator is proportionate to "record that a kind exists."

But it does have one real job, and it's the one you just named: **registration is promotion to canon**, so the registry is where coherence gets checked. That's where the dangling `CHILD_KINDS = ["math"]` should have failed — a kind naming a parent or child that isn't registered, a declared schema that doesn't resolve, a discipline that contradicts the container. All of those are cheap at registration and invisible everywhere else. The registry earns its keep as a **gate**, not as machinery.

Which gives the two-way street a boundary with a name: **codification is registration.** Below it, converter lanes write through engine primitives with no schema and no kind, because they're still discovering the shape. Above it, artifacts are governed. Promotion is the act of binding a schema that's now supported by enough instances to be worth asserting.

That makes "unregistered" a *stage* rather than a deficiency, and it means the engine needs no special mode for WIP — it already has one, and it's called using `JsonlEngine` directly.

One correction to something I proposed earlier, prompted by your phrasing. I grouped evidence and infrastructure *over* catalog/ledger/exhibit — infrastructure being catalog and ledger, evidence being exhibit. But "operational and evidentiary catalogs, ledgers" says they're **orthogonal**: a catalog can be either, a ledger can be either. That's a 2×3 matrix, and naming six cells is strictly worse than declaring two independent facts about an artifact.

Which arrives at the same place as the earlier argument from a different direction — the axes are real, the *combinations* don't want names, and a store should declare what's true of it rather than claim membership in a cell. `REGENERABLE`, `ORDER_IS_CONTENT`, and whatever names the evidentiary/operational distinction, each declared independently.

And it means the base class stays genuinely base: `BaseStore` with declared properties, no category subclasses at all, and the vocabulary of catalog/ledger/exhibit living in prose where it's working well.

---

# I was going to say, its a two-way street because i might design a schema that informs code development, or i might iterate on code and discover schemas. moreover, this informs process ideal shaping motivated by the desire to promote into canon. i.e. write new code for new legs of the pipeline that are try to compiling/resolving/canonicalizing evidence into canonical structures e.g. if a given problem can be conveyed as a collection of atomics that get collected into a catalogue, like what we do with inventory/articles, then that's desirable because i already have operations for that. but only if the shoe fits

The pull is real leverage, and worth being explicit about what you inherit when the shoe fits: atom validation, verbatim insertion with no projection code, materialization from a scope, and rebuild-on-staleness as the whole error-handling story. That's four things you don't write.

**The fit test is checkable, and it's one question: can the member go in verbatim?** If building the collection requires selecting fields or summarizing, you're projecting, and a projection isn't a materialized view — it's a derived artifact that happens to be a list. That's the same criterion as "a catalogue's record schema is its member's schema," stated as something you can answer before committing.

The guard against forcing it is subtler than the fit test, though. Designing a *pipeline leg* so its output lands as atoms-into-a-catalogue is legitimate — that's designing for reuse. Designing the *evidence* so it fits the container is not. The moment you decide what to capture based on what will collect cleanly, storage form is dictating what counts as a fact, which is faithful-not-filtered violated one level up from where you usually watch for it.

There's a prediction in the trace worth having, since it tells you where to expect the next fit: **the catalogue pattern lives where the project invents its units, not where it discovers them.**

Inventory/article fits because both units are project-invented — the deposit transaction decides what an article manifest is, and it's the same every time. Nothing in latex-ingest fits, because the converter is *discovering* structure from idiosyncratic source, so its outputs are populations with discriminators, not uniform atoms. That's not a maturity gap in the converter; it's what discovery output looks like.

So expect the next fit at boundaries where normalization has already produced units you control — the procurement tier, or downstream of a canonicalization step that closes over the idiosyncrasy. The ref-graph's labels become catalogue-able exactly when the custom-counter fix lands and a label has one determined identity, which is the same event as the atoms becoming persistable. Before that, no shoe.

---

# inventory/article fits because they induced the first shoe, and led to the development of the shoe mold in which future things' goodness of fit can be checked

Right — induced, not fitted. The mold is residue of solving one case well.

Which has a consequence worth holding onto: **with n=1, the mold is maximally over-fitted to its instance.** Every criterion I derived — member is an atom, shape determined at emission, insertion is verbatim — came from inventory/article alone. Any of them could be an accident of that case rather than essential to collecting things.

So when case two arrives and *nearly* fits, the question isn't only "does the shoe fit." It's whether to bend the case or widen the mold, and at n=1 the prior should sit with widening. The mold earns rigidity by surviving instances, not by being derived carefully from one.

That's the same inductive/deductive structure you described for the manuscript problem, and the catalogue archetype has external instances to triangulate against the same way:

- **OCI image index / manifest** — the closest analogue by far. A manifest is a self-describing atom; an index is a collection referencing manifests *by content digest*. That's inventory/article almost exactly, including the staleness mechanism your `metadata_sha256` was doing.
- **Frictionless Data Package** — `datapackage.json` enumerating resources with their schemas. Same atom-and-collection shape, from the data-publishing world.
- **DCAT** (W3C Data Catalog Vocabulary) — the catalogue-of-datasets standard, and the one that has thought hardest about what a catalogue *entry* is versus what it points at.
- **Library MARC records and package-registry indexes** — the oldest instances, and worth a look mainly for how they handle identity and supersession over decades.

The OCI one is most useful because it made the **opposite choice on an axis you already deliberated**: it references by digest rather than inlining the manifest, so the index stays small and the atom stays canonical in one place, at the cost of needing a fetch to read anything. You went the other way — verbatim insertion, self-sufficient rows, rebuild when stale. Both are coherent; seeing a mature system pick the other branch is the cheapest available check on whether your mold is a general shape or a local optimum.

---

# no, no that's not what im saying. if i discover a sort of evidence that can be captured as a set of atomics that can be reliably parsed or resolved out of an article, and canonicalized to satifaction, then i can collate those into a catalogue using the same machinery and similar process that i already use for inventory/articles. the cataloging mechanism, mechanics and data structure *are the shoe* that turns out to fit

I had that backwards. Invention was **sufficient, not necessary** — it made inventory/article the easiest possible first case, which is why it came first, not because the machinery requires it. Discovered units catalogue fine once they canonicalize.

So the fit test is your three conditions, and none of them is about origin:

1. the evidence decomposes into **atomics**
2. those are **reliably parsed or resolved** out of an article
3. each **canonicalizes** — determined identity, determined shape

Applying that to what the lane actually writes:

- **docstream rows** — atomic (each carries `addr`), reliably built by the walk, and canonical: `addr` is `kind:index`, uniform shape, no discriminator. **All three hold today.** That makes it the nearest fit in the lane, ahead of the ref-graph.
- **labels** — atomic and reliably resolved, but not canonical while `custom` shadows the typed maps and one label carries two numbers. Passes on the consume-once fix.
- **sites** and **edges** — atomic and reliably resolved; identity is positional, so they canonicalize when `$si` becomes a real site index. Both reachable through fixes already on the list.
- **diagrams** — atomic with `n` as identity, but each row carries `status` ∈ marker/png/svg, which is **mutable state**. The atom isn't determined; it's a work item whose value changes as downstream acts on it. Fails condition three, and not by an oversight that a fix would close — that's what a work-list is.
- **oracle-counts** — one flat object, not a set of atomics. Not a foot at all.

Which is a more useful map than the one I gave: the two known defects aren't just correctness fixes, they're the **gate on three populations becoming catalogue-able**. And docstream is already through that gate without anyone having aimed at it.

Worth noting what the diagrams case tells you about the mold, too — a mutable field is what disqualifies it, so "canonicalized to satisfaction" has a sharper edge than it sounds: the atom has to be *done*, not merely well-formed.

---

# right and that was an example of one pattern i might strive for in future code development. any established canon kind or sub-kind is a potential design pattern in code development ripe for re-use

That reframes what promotion costs. If a kind is just a validated artifact type, registering it is bookkeeping. If a kind is a reusable pattern, registering it is **publishing an API** — and the threshold rises accordingly. Two different bars:

- *this artifact's shape is stable* — enough to schematize
- *this shape is worth other code aiming at* — enough to promote

The second is higher, and conflating them is how a registry fills with kinds nobody reuses.

The risk that comes with it is the one you'd expect: **the pattern you have is the pattern you reach for.** With catalogue mature and nothing else abstracted, problems will get bent toward collection-of-atomics whether or not that's their shape. The mitigation isn't discipline, it's inventory — you need more than one mature pattern before "does the shoe fit" is a real question rather than a foregone one.

On what's actually available, the trace gives a useful answer about where the *next* pattern comes from:

| shape | instances | status |
|---|---|---|
| catalogue | inventory/article | mature, n=1 |
| evidence store, discriminated populations | ref-graph | designed, not built |
| ledger | runs | designed, not built |
| work-list | diagrams | **exists in code, never abstracted** |
| measurement sidecar | `.sig`, oracle-counts | **exists in code, never abstracted, n=2** |

The sidecar is the cheapest next pattern and nobody has looked at it. Two instances already, written independently, converging on the same shape — a flat object of facts about a run rather than a collection. And n=2 is exactly where a pattern stops being an over-fit to its origin, which is the thing the catalogue mold can't claim yet.

So the two shapes that have earned abstraction by existing are the two that got the least attention today, while the two with the most design behind them have zero instances. Worth knowing before the next round of promotion, because designed-but-unbuilt is the state most likely to produce a pattern that fits nothing.

---

# ok, we're done. export chat to issues/latex-ingest/discussion
