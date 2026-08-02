Claude feedback: One ingest note: the bibliography didn't resolve — citations are all [?] in the markdown, and the abstract block between title and Introduction came through empty, so latex-ingest dropped or displaced those (consistent with its under-strip tolerance). The benchmarks and runtime it cites (EvoAgentBench, GPT-5.2, OpenClaw) are past my knowledge cutoff, so I can't vouch for the baselines' representativeness — but the architectural argument stands on its own regardless of the leaderboard.

TODO: 0. Finish the latex-ingestion logic to yield a complete markdown transfer

- completness including reference sections and any other fidelity failures
- this will help define the shape of the latent manuscript

1. determine new markdown finalization standards

- byte spanned, hierarchical TOC
- TOC as a side car or front matter?

2. latex ingestion MCP

- exposing the latex-ingest workflow as mcp tools
- including batch processing
- agentic review, with or without subagent swarms
- more flexible filesystem operations

3. reader MCP

- tools for facilitating easy random-access, partial reads, etc based on TOC

Given a reader MCP, is there any need to create section

Also todo:

Study latex-ingest after completing v1 for retrospective examination and planning of V2 TexDig

- latent manuscript schema/shape/objects
- shape of the JSONL ABI measurement IR
