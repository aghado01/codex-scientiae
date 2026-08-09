# JSONL engine follow-up

## Deposit coverage

Focused source-deposit fixtures exercise both not-applicable branches: single-TeX gzip has no archive
members to confine, and explicit `-MainTex` selection does not claim an ambiguity scan ran. The current
staged corpus still consists of tar+gzip, single-candidate deposits, so those alternate outcomes have not
yet appeared in corpus-derived evidence.

The `deposit` verb is active through the shared client. It accepts the source transaction's scalar facts
and one staged findings document, validates the flat `codex-scientiae/article/0.1` object, and creates or
idempotently validates `article.json` without clobbering it. The PowerShell transaction holds the source
lock through that Python finalization step and requires exactly one result frame. Remaining work in this
section is representative corpus coverage, not activation or synthetic-fixture coverage of the verb.

## PowerShell compatibility

The manifest-backed `src/jsonl_engine-client` module is the only PowerShell process and
protocol owner for `python -m jsonl_engine`. `src/jsonl_engine/jso-shell.ps1` remains a
bounded compatibility importer for callers that still dot-source the former location; it does not
contain a second implementation. New callers import the module manifest directly.

The current protocol advertises 16 stable verbs. `validate-json <path> <schema>` is the authoritative
strict-document/shipped-schema boundary and returns one validated object. Latex conversion workers use it
with `article.schema.json`; batch planning stays process-free and performs only shallow admission checks.

`Find-JsonlRecord` retains the legacy positional or named `-Value` raw-JSON input, with
`-JsonValue` as an equivalent spelling. Typed PowerShell values use `-InputObject`. The legacy
`-AtSignature` and `-Unbounded` view switches remain compatibility spellings for the canonical
`-View Signed` and `-View Physical` choices.

## Documentation follow-up

The remaining PowerShell scripts in `src/logistics` still need a declarative-docstring pass.
`engine-call.ps1` is already retired; its process boundary moved to the shared client, and
`latex-source-deposit.ps1` now states the live ownership boundary. Review `probe-ledger.ps1` and
`run-paths.ps1` without reopening that decision.
