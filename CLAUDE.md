This repository uses a telescoping navigation mechanism in which higher-level CONTENTS.md files will point to nested CONTENTS.md files

See CONTENTS.md for structure and navigation during reconaissance tasks

`ingestion/gauntlet/` is the STANDARD TEST BATTERY for converter dev work (voroninski + ph-zigzag = calibration, mapper = out-of-sample transport): every figure-lane/converter increment gates against it via src/pdf-converter/Compare-FigureCounts.ps1. Charter + battery table in ingestion/gauntlet/CHARTER.md; forward plan in the latest issues/clustering/frontier-YYYYMMDD.md

The `codex-arxiv` MCP (`src/procurement/arxiv-server.ps1`, registered in `.mcp.json`) is the acquisition lane: it searches/fetches PDFs into `ingestion/_inbox` and hands off — the first of a planned web-fetcher family (sci-hub next) feeding a forthcoming from-scratch PdfPig-based, membrane-like transcription workflow that will coalesce variable paper formats into the codex-scientiae standard before the existing membrane repairs/publishes.

The **math register** — the `$…$`/`$$…$$` + semantic-LaTeX standard that every conversion lane targets — is specified in `issues/math-register/math-register-spec.md`. Read "The contract in brief" for the normative rules, Appendix C for shared terminology. It is a FORWARD spec for the post-reboot system: where it and current `src/` disagree, **the spec is the intent and the code is a migration delta** (notably `src/codex-membrane/normalize.ps1` still strips `\mathbb` by default, which the spec reverses — alphabet macros are notation, not styling).

PROJECT DOC STATUS: the converter stack is mid-reboot into `D:\aghado01\scriba-scientiae`. Treat all other existing project documentation (`.legacy/docs/STANDARDS.md`, membrane-era `src/`, older issue briefs) as **tentative first-attempt, not authority** — prior art to be mined, not law. Next-gen specs are being written by mining the conversational record; the math register is the first.

Since this project exists to inspire and guide development on other projects, user will often ask you to commit analysis and briefs to other projects particularly "ThermoMapper" aka "SPCX" aka the current ps.core.pwshspc `C:\Users\azrie\PDenv\UserGithub\PowerShellCore\ps.core.pwshspc`

User may also create snapshots for ease of inspection under `C:\Users\azrie\PDenv\UserGithub\project-snapshots` , in particular the SPCX (running codename for ps.core.pwshspc) snapshot folder there .
