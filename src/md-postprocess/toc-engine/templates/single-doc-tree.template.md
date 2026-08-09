---
slug: "{{Header.slug}}"
title: "{{Header.title}}"
authors: "{{Header.authors}}"
doi: "{{Header.doi}}"
total_bytes: {{Header.total_bytes}}
section_count: {{Header.section_count}}
index_count: {{Header.index_count}}
generated_at: "{{Header.generated_at}}"
---

# Document Tree Manifest: {{Header.slug}}

> **Navigation:**
> This manifest indexes the structural sections of [`{{Header.source_file}}`]({{Header.source_path}}).
> Sections appear in reading order, each with a half-open byte span `[byte_start, byte_end)`.
>
> With the `codex-reader` MCP server mounted on this bundle: `read_section` takes an anchor and returns
> that section, `read_span` takes an arbitrary `[byte_start, byte_end)`, and `search_headings` finds one.
> Without it, the spans address `{{Header.source_file}}` directly and `{{Header.slug}}.toc.jsonl` carries
> the same index as one JSON object per line.
>
> Spans are addresses — for re-entering the document at a known place, not for deciding whether to go
> there. Extent says nothing about importance: a short section may carry the central result, and prose
> sections carry the rationale that makes the formal content intelligible.

## Payload

{{#each Payload}}
- `./{{label}}`
{{/each}}

## Table of Contents & Section Byte Spans

`section row metadata: section_link | level | byte_start | byte_end | byte_width (B)`

{{#each Sections}}
{{indent}}- [{{title}}]({{relative_link}})    {{level_tag}}    {{byte_start}}    {{byte_end}}    {{byte_width}}
{{/each}}

## Subject Index

Numbered objects this document states, in document order, each with the section that contains it.
This is inventory, not ranking — it says what is here, not what is worth reading.

{{#each Index}}
- **{{label}}** — [{{section}}]({{relative_link}})
{{/each}}
