Read "The contract in brief" for the normative rules, Appendix C for shared terminology. It is a FORWARD spec for the post-reboot system: where it and current `src/` disagree, **the spec is the intent and the code is a migration delta**. The mechanical core is now IMPLEMENTED in `src/math-register.ps1` (`ConvertTo-RegisterMath`: `\operatorname`→`\mathrm`, alias surjection, §4.2 furniture, glyph→control-sequence), serialized through by both lanes; the old `\mathbb` stripping is reversed everywhere (alphabet macros are notation, not styling). Spec Appendix A's delta table predates this landing.

PROJECT DOC STATUS: the converter stack is mid-reboot into `D:\aghado01\scriba-scientiae`. Treat all other existing project documentation (`.legacy/docs/STANDARDS.md`, membrane-era `src/`, older issue briefs) as **tentative first-attempt, not authority** — prior art to be mined, not law. Next-gen specs are being written by mining the conversational record; the math register is the first.

This repository uses a telescoping navigation mechanism in which higher-level CONTENTS.md files will point to nested CONTENTS.md files

See CONTENTS.md for structure and navigation during reconaissance tasks

`ingestion/gauntlet/` is the STANDARD TEST BATTERY for converter dev work (voroninski + ph-zigzag = calibration, mapper = out-of-sample transport): every figure-lane/converter increment gates against it via src/pdf-converter/Compare-FigureCounts.ps1. Charter + battery table in ingestion/gauntlet/CHARTER.md; forward plan in the latest issues/clustering/frontier-YYYYMMDD.md
