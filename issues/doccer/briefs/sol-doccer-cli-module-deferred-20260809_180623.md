# Doccer CLI module brief — deferred public-composability lane

Runstamp 20260809_180623. **Status: implementation deferred; product and module boundary
committed.** This brief is the return packet for Doccer's public CLI module. It records what is
already decided, what the ThermoMapper `user-repl` snapshot contributes, which donor defects the
Doccer design must avoid, and the conditions for opening an implementation chip. Deferral is
sequencing, not optionality.

Inputs:

- [D13 in the decision canon](../planning/decisions.md);
- [current roadmap](../planning/roadmap.md);
- [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
- [material-basis and public-composability inquiry](../discussions/sol-doccer-material-basis-and-public-composability-20260806_105530.md);
- [ThermoMapper snapshot manifest](../../../../project-snapshots/ThermoMapper/src_20260701_122622_tree.md),
  especially the `user-repl` shards
  [s059](../../../../project-snapshots/ThermoMapper/src_20260701_122622_s059_user-repl.txt) through
  [s065](../../../../project-snapshots/ThermoMapper/src_20260701_122622_s065_user-repl.txt).

## 1. Disposition

Doccer will expose a public CLI as its own module over the declarative engine. The working shape is:

~~~text
CodexSci.Doccer          declarative engine module
        ↑ one-way dependency
CodexSci.Doccer.Cli      public command/application module (working name)
~~~

The engine owns carrier and operation semantics. The CLI calls those public contracts and never
reimplements them. Low-level values and operations that close their own contracts are intended to
be publicly stackable in process and eventually through the CLI. The CLI is therefore an eventual
product feature, not a diagnostic convenience whose existence still needs justification.

Implementation remains deferred because the first durable vertical slice, command grammar, wire
realization, and carrier-specific artifact identities are not frozen. The current brewery
`inspect`/`relate` commands remain disposable developer diagnostics. Their existence neither
satisfies nor constrains the future module.

The latent-manuscript node-stream schema gates document-stream command families. It does not gate
creating the CLI module or exposing an independently closed low-level carrier. A minimal
cross-process wire contract should precede and inform F2 persistence rather than wait for every
future persisted Doccer value.

## 2. Ownership boundary

| Declarative engine owns | CLI module owns |
|---|---|
| immutable carriers, basis and identity | argument, config, recipe, and session transport |
| named operations and their many-sorted signatures | mapping transport input to typed engine invocations |
| policies as explicit typed inputs | one-shot command routing and operation stacking |
| typed results, residuals, and refusal reasons | files, stdin/stdout, handles, and artifact location |
| validation and reference semantics | versioned wire DTOs and serializer contexts |
| public in-process composition | rehydration, presentation, diagnostics, and exit-code mapping |
| semantic fields that an artifact must retain | concrete artifact envelope and encoding |

Domain knowledge remains data: inventories, scope files, pattern stores, and explicit recipes.
Domain names and judgments do not become CLI verbs or flags merely because the module can load
them. PowerShell remains a site-local veneer and adapter layer over the engine or CLI.

The intended flow is:

~~~text
argv / config / recipe
        ↓
versioned CLI invocation
        ↓
public declarative engine operations
        ↓
typed result + residual
        ↓
reusable artifact / stream / human presentation
~~~

Human-readable output alone is not low-level composability. A command family that produces a
mask, vector, region, selection, map, or other reusable value must be able to emit an unambiguous
artifact or session handle that another command can consume without mining console prose.

## 3. What the ThermoMapper snapshot establishes

The July snapshot's `user-repl` directory contains 23 source files and approximately 176,885
source characters. Despite its name, it is a CLI rather than an interactive REPL:
`SubcommandRouter` dispatches `spc`, `hdbscan`, `extract`, and `graph-health` subcommands and
returns process exit codes.

The transferable patterns are:

- a separately owned command/application module over computational libraries;
- a small root router with named command families;
- programmatic session/result facades beneath command parsing;
- module-owned records and a source-generated JSON serialization context;
- presets and manifests treated as data;
- versioned run manifests that make later operations intelligible;
- rehydrate-and-derive commands such as `extract` and `graph-health`, rather than mandatory
  recomputation; and
- a distinction between the primary run and later artifact inspection or regeneration.

These patterns strengthen D13. In particular, derived commands should be peers of primary
commands. Doccer validation, conversion, projection, harvest, inspection, and artifact migration
should not all be hidden behind one monolithic “process document” task.

## 4. Donor defects become Doccer acceptance requirements

The snapshot is a design donor, not a template to copy. Its current disrepair is informative:

- `SpcCommand.cs` is about 45,592 source characters—roughly 26% of the entire module—and combines
  parsing, policy checks, configuration materialization, caching, engine invocation, resolver
  logic, artifact writes, and console presentation.
- Manual argument parsing, help, delimiter handling, dataset reconstruction, and graph rebuilding
  recur across commands.
- `SpcPreset.ApplyTo(SpcCommand.Options)` makes configuration mutate a command-private options bag
  instead of materializing a stable declarative request.
- `SpcUserSession.Run` couples computation to one fixed artifact bundle.
- Manifests serialize concrete engine objects and interfaces, coupling wire identity to runtime
  implementation types.
- Nominally immutable user records expose mutable jagged arrays without snapshot ownership.
- Graph fingerprints rely on host-endian `BitConverter` bytes, lack explicit segment framing, and
  do not stamp a portable algorithm/version/canonical serialization contract.
- Cache loading collapses missing, stale, incompatible, and corrupt artifacts into one Boolean
  miss.
- Broad exception catches collapse typed failures into one message and exit code while direct
  `Console` calls entangle execution with presentation.

The Doccer CLI therefore must:

- keep commands small by compiling transport input into a typed invocation before execution;
- share parsing and artifact primitives only where two command families agree on semantics;
- represent config and recipes as versioned data independent of private command classes;
- separate computation results from optional artifact materialization;
- expose intentional, versioned wire DTOs rather than serialize arbitrary implementation graphs;
- preserve immutable ownership at every public carrier boundary;
- stamp algorithm, version, basis, canonical serialization, and policy identity where relevant;
- distinguish absent, stale, incompatible, corrupt, refused, residual, and failed outcomes; and
- map typed diagnostics to machine and human output without making console text the contract.

ThermoMapper-facing repairs remain ThermoMapper's concern. This brief retains only the
Doccer-facing lift requirements.

## 5. Provisional module shape

The exact project and namespace layout is not frozen, but the responsibilities should remain
visible:

~~~text
CodexSci.Doccer.Cli
  Commands       transport parsing and root/subcommand routing
  Execution      invocation resolution and engine calls
  Artifacts      versioned DTOs, envelopes, serializers, and rehydration
  Presentation   stdout/stderr rendering and exit-code policy
  Sessions       optional handles or recipe execution for stacked operations
~~~

The central seam is a typed invocation or operation recipe:

~~~text
transport syntax -> Doccer invocation -> engine result -> artifact/presentation
~~~

The names and exact granularity remain open. The seam must nevertheless prevent a command class
from becoming the only place where an operation can be configured or composed.

Command families must keep Doccer sorts visible. A raw vector operation, a basis-stamped unit-mask
operation, `SpanSet` symmetric difference, and `ClaimSelection` symmetric difference may all use
bitwise machinery while remaining different public commands and artifacts. One untyped `xor`
surface would erase the carrier laws D25/D41/D42 preserve.

One-shot subcommands, declarative recipes, and long-lived handles are compatible possibilities.
A hybrid may be appropriate. That is a surface-design question; it does not reopen the commitment
to low-level CLI composition or the separate module.

## 6. Reactivation conditions

Open an implementation chip when all of the following are available:

1. one bounded command family has a stable public engine carrier and operation contract;
2. that family's cross-process artifact can state its carrier identity, basis/window where
   applicable, operation/policy stamp, result/residual sort, schema version, and physical-layout
   conventions that are intentionally public;
3. the material-basis decision has closed any address-unit or fidelity question the chosen family
   exposes;
4. a second-process round trip is specified: produce, persist or stream, consume, and compare with
   the in-process reference result;
5. stdout, stderr, diagnostics, and exit-code behavior are separable and testable; and
6. the selected vertical slice demonstrates real composition without requiring a domain-specific
   adapter or the latent-manuscript schema unless it is itself a document-stream command.

Candidate first slices include an existing stable carrier such as `SpanSet`/`ClaimSelection`, or a
later V0/V1 vector/mask family after its material-basis contract closes. Selection is deferred to
the activation chip; this brief does not silently choose one.

## 7. First implementation exit gate

The first durable CLI chip closes only when:

- the CLI is a separate project/module with a one-way reference to the engine;
- the same operation remains directly callable through the public engine API;
- command/config input materializes one typed invocation before engine execution;
- CLI flags have explicit precedence over config/recipe data without mutating an opaque parser
  object as the persisted contract;
- one reusable output artifact or stream round-trips across processes and rejects incompatible or
  stale input explicitly;
- artifact identity includes every semantic stamp required by the engine carrier;
- machine output is not mixed with human diagnostics;
- typed engine failures and residuals have deterministic exit/output behavior;
- at least one later command consumes the first command's output without parsing presentation
  text;
- no mutable backend storage escapes as an immutable public value; and
- decision canon, roadmap, workplan, README, packaging, and smoke tests agree with the delivered
  module.

## 8. Deferred design choices—not open product commitments

Still deferred:

- final project/package/executable naming;
- command-parser implementation and help generation;
- exact command-family grammar;
- explicit subcommands versus a small algebra expression versus declarative recipes;
- whether and where a session/handle protocol complements one-shot operation;
- the exact minimal JSONL envelope/schema required by D13, and whether later artifact families add
  framed JSON, binary, or hybrid encodings;
- copying versus borrowed read-only public views where a layout is intentionally exposed;
- the first durable vertical slice; and
- release/versioning cadence for the CLI module relative to the engine package.

Not deferred and not open:

- the CLI will be a public feature;
- it will be its own module over the declarative engine;
- the dependency points from CLI to engine only;
- low-level admitted capabilities are intended to be stackable;
- the engine remains the semantic source of truth;
- domain knowledge remains data rather than command semantics; and
- the CLI will not duplicate engine laws or make human-readable reports the only reusable output.

This brief should be reopened when the first bounded vertical slice satisfies §6. Until then it
preserves the module commitment and acceptance gates without inserting CLI implementation into the
K5–K8 critical path.
