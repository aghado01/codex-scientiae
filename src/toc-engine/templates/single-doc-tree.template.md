---
slug: "{{Header.slug}}"
title: "{{Header.title}}"
authors: "{{Header.authors}}"
doi: "{{Header.doi}}"
total_bytes: {{Header.total_bytes}}
section_count: {{Header.section_count}}
generated_at: "{{Header.generated_at}}"
---

# Document Tree Manifest: {{Header.slug}}

> **Agent Inspection Guidance:**
> This manifest indexes the structural sections of [`{{Header.source_file}}`]({{Header.source_path}}).
> Each section carries a closed byte span `[byte_start, byte_end)`. To inspect a specific section
> without loading the whole document, use `view_file` with `ContentOffset = byte_start` and `Length = byte_width`.

## Payload

{{#each Payload}}
- `./{{label}}`
{{/each}}

## Table of Contents & Section Byte Spans

`section row metadata: section_link | level | byte_start | byte_end | byte_width (B)`

{{#each Sections}}
{{indent}}- [{{title}}]({{relative_link}})    {{level_tag}}    {{byte_start}}    {{byte_end}}    {{byte_width}}
{{/each}}
