Yes—an MCP tool should be a protocol-facing projection of a capability, not the place where the capability lives.

A useful target shape is:

```text
src/
  mcps/
    runtime/                 # MCP-only shared framing, dispatch, errors, registration
    reader/
      server.ps1
      tools/
      schemas/
    librarian/
      server.ps1
      tools/
      schemas/
    scholar/
    latex-ingest/

  audits/
    math-render/
    ...

  shared/
  procurement/
  latex-ingest/
  md-postprocess/
  ...
```

The dependency direction should remain one-way:

```text
MCP server
  → MCP tool adapter
    → workflow/operation
      → algorithms and primitives
        → external payloads
```

The boundaries matter:

- `src/mcps/runtime` may know JSON-RPC, stdio framing, MCP errors, tool registration, and request dispatch—but nothing about papers, runs, audits, or conversion.
- `src/mcps/<name>/tools` owns MCP names, descriptions, input schemas, argument validation, and translation into operation calls.
- Domain operations live outside `mcps` and must remain callable from tests, batch jobs, scripts, or another MCP without starting a server.
- Algorithms should know neither workflows nor MCP concepts.
- Artifact placement belongs to the workflow/run being invoked; the MCP adapter merely supplies addressing and returns the result.
- Shared domain primitives belong outside `mcps`. Only primitives that are intrinsically MCP protocol machinery belong in `mcps/runtime`.

The current membrane server is a strong example of what needs separating: server startup, tool catalogue, document resolution, workflow orchestration, audits, conversion, publishing, and experimental harvesting are all composed in one file. During eviction, I would preserve very little of that shell directly. Instead, classify each handler as:

1. Protocol glue — rebuild under `src/mcps`.
2. Workflow policy — extract only if still wanted.
3. Reusable operation — recapture independently.
4. Algorithm or primitive — evaluate and retain on merit.
5. Product-specific behavior — evict with the shell.

This also gives us a good test boundary:

```text
tests/mcps/<server>/       MCP schemas, dispatch, envelopes, adapter behavior
tests/audits/              reusable audit contracts
tests/<operation>/         workflow behavior
tests/shared/              primitive laws and invariants
```

The key doctrine is: MCPs expose and coordinate capabilities; they do not own the reusable mechanics behind them. That should make future Reader, Librarian, Scholar, and latex-ingest MCPs much easier to assemble without repeating or disguising operations.
