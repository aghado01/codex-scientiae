# probes/

Standing **measurement instruments** for the converter dev loop: calibration probes, ablation
harnesses, and diagnostics. Everything here is run-and-eyeball — human-read output, no
assertions — but it is NOT scratch: these files are tracked, cited by path from config `_doc`
strings, engine comments, and the frontier briefs, and their **headers carry the iteration
records** that justify the knob values they calibrated (the calibrate-before-implement
protocol's durable evidence).

Relocated from `scratch/` 2026-07-15: the probes had accumulated in the junk drawer by
precedent and were being force-added past its gitignore — the ritual that marked them as
misfiled. `scratch/` is now purely ephemeral (temp artifacts, one-off throwaway scripts,
never committed); anything that **asserts** lives in `tests/`.

Conventions:

- One probe per calibration/diagnostic question; the header states the question, the method,
  and the locked verdict (the iteration record — v1/v2/v3 with what each falsified).
- Probes reach the repo via `$PSScriptRoot/..` (same depth as `tests/`); heavy temp output
  goes to the system temp dir or `scratch/`, never beside the probe.
- A probe whose verdict is superseded keeps its record (history is the point); a probe that
  becomes a standing gate harness (e.g. `banded-ablation.ps1`) stays here — promotion to
  `tests/` happens only if it grows assertions.
- Historical briefs under `issues/` may still cite the old `scratch/{name}.ps1` paths; those
  are left as written (same precedent as the gauntlet move) — resolve by filename.
