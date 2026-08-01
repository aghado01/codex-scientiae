# Doccer engine sketch

This directory contains the domain-neutral C# engine. It is intentionally separate from
Markdown, LaTeX, PDF, MCP, and workflow code: those systems may emit claims or consume views,
but none owns the interval substrate.

The implementation currently establishes these contracts:

- immutable, identified UTF-16 text masters with fingerprints and revisions;
- a total Unicode-scalar tiling and line topology, including explicit malformed-surrogate atoms;
- append-only collection followed by a frozen, columnar, overlap-preserving `SpanBatch`;
- normalized Boolean `SpanSet` projections bound to their originating master;
- all thirteen Allen interval relations and a reference relation join;
- deterministic priority-based laminar extraction, equal-geometry grouping, and crossing residue;
- declarative regex collection, including region-scoped matching that cannot bridge exclusions;
- intrinsic and declarative relation/impossibility validation.

This is an architectural sketch, not a claim that the Doccer specification is closed. Important
families deliberately remain absent until their contracts are specified completely:

- normalized-master/original-source `OffsetMap`, composition, and inversion;
- full character/line/multiline lift, group, and projection algebra;
- coalesced-run and windowed-density operations beyond `SpanSet` normalization;
- suppression bitmap and persisted batch formats;
- declarative inventory loading and validation schemas;
- indexed implementations for relational joins;
- the complete randomized law and Tier-1/2/3 acceptance suites.

Do not fill these gaps with consumer-specific shortcuts inside the engine. Extend the contracts and
laws first, then implement them here. Mask helpers belong above `SpanSet`; syntax recognition belongs
in external adapters or declarative inventories.

## Build boundaries

- `src/doccer`: engine source and public contracts.
- `brewery/doccer/Doccer.csproj`: reusable `CodexSci.Doccer.dll` recipe.
- `brewery/doccer/Doccer.Cli.csproj`: thin executable referencing that assembly.
- `brewery/doccer/Doccer.Tests.csproj`: dependency-free contract harness.
- `brewery/doccer/build-doccer.ps1`: verified refresh into `packages/doccer`.
- `artifacts`: compilation and test intermediates.
- `packages/doccer`: selectively refreshed reusable payload.

Run the contract harness with:

```powershell
dotnet run --project brewery/doccer/Doccer.Tests.csproj
```

Refresh the payload with:

```powershell
./brewery/doccer/build-doccer.ps1
```
