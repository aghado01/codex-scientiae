"""Normative TeXdig 0.2 history and 0.3 schema-boundary checks."""

from __future__ import annotations

import pytest
from jsonschema import ValidationError

from jsonl_engine.schemas import SchemaCatalog


SCHEMAS = {
    "texdig-sources": "codex-scientiae/texdig-sources/0.2",
    "texdig-entities": "codex-scientiae/texdig-entities/0.2",
    "texdig-claims": "codex-scientiae/texdig-claims/0.2",
    "texdig-coverage": "codex-scientiae/texdig-coverage/0.2",
    "texdig-diagnostics": "codex-scientiae/texdig-diagnostics/0.2",
    "texdig-summary": "codex-scientiae/texdig-summary/0.2",
}

V03_SCHEMAS = {
    "texdig-entities-v03": "codex-scientiae/texdig-entities/0.3",
    "texdig-diagnostics-v03": "codex-scientiae/texdig-diagnostics/0.3",
    "texdig-summary-v03": "codex-scientiae/texdig-summary/0.3",
    "texdig-occurrences": "codex-scientiae/texdig-occurrences/0.3",
    "texdig-bindings": "codex-scientiae/texdig-bindings/0.3",
    "texdig-invocations": "codex-scientiae/texdig-invocations/0.3",
}


def _span(start: int = 0, end: int = 4) -> dict[str, object]:
    return {"sourceId": "main.tex", "startUtf16": start, "endUtf16": end}


def _v03_summary() -> dict[str, object]:
    return {
        "schema": "texdig-census/0.3",
        "slug": "fixture",
        "treeSha256": "0" * 64,
        "entrypoint": "main.tex",
        "stores": {
            "emitted": [
                "sources.jsonl",
                "entities.jsonl",
                "occurrences.jsonl",
                "bindings.jsonl",
                "invocations.jsonl",
                "claims.jsonl",
                "coverage.json",
                "diagnostics.jsonl",
                "summary.json",
            ],
            "deferred": [
                "expansion.jsonl",
                "walk.jsonl",
                "zones.jsonl",
                "macros.jsonl",
                "references.jsonl",
                "pointers.jsonl",
                "frontmatter.jsonl",
                "graph.jsonl",
            ],
        },
        "storeSchemas": {
            "sources.jsonl": SCHEMAS["texdig-sources"],
            "entities.jsonl": V03_SCHEMAS["texdig-entities-v03"],
            "occurrences.jsonl": V03_SCHEMAS["texdig-occurrences"],
            "bindings.jsonl": V03_SCHEMAS["texdig-bindings"],
            "invocations.jsonl": V03_SCHEMAS["texdig-invocations"],
            "claims.jsonl": SCHEMAS["texdig-claims"],
            "coverage.json": SCHEMAS["texdig-coverage"],
            "diagnostics.jsonl": V03_SCHEMAS["texdig-diagnostics-v03"],
            "summary.json": V03_SCHEMAS["texdig-summary-v03"],
        },
        "runtime": {"node": "v26.0.0"},
        "sourceCount": 1,
        "occurrenceCount": 1,
        "bindingRowCount": 1,
        "invocationCount": 1,
        "entityCounts": {"macro-invocation": 1},
        "agreementCounts": {"lexical-only": 1},
        "diagnosticCounts": {"warning": 1},
        "coverage": {
            "totalUtf16": 4,
            "claimedUtf16": 4,
            "residueUtf16": 0,
            "residueSegments": 0,
        },
    }


def _v03_specimens() -> dict[str, list[dict[str, object]]]:
    configured_span = _span(0, 16)
    scope_id = "scope:" + "1" * 64
    binding_id = "bind:" + "2" * 64
    occurrence_id = "occ:" + "3" * 64
    entity_id = "ent:macro-invocation@main.tex:16-20"
    configured_entity_id = "ent:macro-definition@configured/pkg:foo"
    return {
        "texdig-entities-v03": [
            {
                "id": configured_entity_id,
                "kind": "macro-definition",
                "definedName": "foo",
                "declarationCommand": "configured",
                "dialect": "configured",
                "signature": {"state": "known", "spec": "O{d} m"},
                "configuredPackage": "pkg",
                "elaborable": False,
                "context": "unknown",
                "activation": "configured",
                "span": configured_span,
                "spanProvenance": "parser",
                "witnesses": [
                    {
                        "witness": "configured",
                        "instrument": "unified-latex-ctan",
                        "span": configured_span,
                        "spanRole": "summon-anchor",
                        "detail": "pkg",
                    }
                ],
                "agreement": "agreed",
                "agreementBasis": "configured-declaration",
                "text": "\\usepackage{pkg}",
            }
        ],
        "texdig-diagnostics-v03": [
            {
                "code": "compile/binding-precondition",
                "severity": "warning",
                "message": "renew has no current binding",
                "sourceId": "main.tex",
                "span": _span(20, 24),
                "entityId": configured_entity_id,
                "occurrenceId": occurrence_id,
                "bindingId": binding_id,
            }
        ],
        "texdig-summary-v03": [_v03_summary()],
        "texdig-occurrences": [
            {
                "id": occurrence_id,
                "sourceId": "main.tex",
                "includeChain": ["main.tex"],
                "basis": "manifest-entrypoint",
                "state": "entered",
                "enterSeq": 0,
                "exitSeq": 8,
            }
        ],
        "texdig-bindings": [
            {
                "rowType": "scope-frame",
                "id": scope_id,
                "kind": "global",
                "enterSeq": 1,
                "exitSeq": 8,
                "status": "closed",
            },
            {
                "rowType": "binding-event",
                "id": binding_id,
                "seq": 2,
                "occurrenceId": occurrence_id,
                "executionScopeId": scope_id,
                "targetScopeId": scope_id,
                "symbol": {"namespace": "control-sequence", "name": "foo"},
                "cause": {
                    "kind": "configured",
                    "summonId": "summon:" + "4" * 64,
                    "entityId": configured_entity_id,
                },
                "operation": "configured-install",
                "effect": "installed",
                "installedMeaning": {
                    "kind": "declaration",
                    "entityId": configured_entity_id,
                    "availability": "signature-only",
                    "signature": {"state": "known", "spec": "O{d} m"},
                },
                "text": "\\usepackage{pkg}",
            },
        ],
        "texdig-invocations": [
            {
                "id": "inv:" + "5" * 64,
                "seq": 3,
                "occurrenceId": occurrence_id,
                "entityId": entity_id,
                "name": "foo",
                "siteKind": "control-sequence",
                "siteSpan": _span(16, 20),
                "binding": {
                    "state": "bound",
                    "bindingEventId": binding_id,
                    "signature": {"state": "known", "spec": "O{d} m"},
                },
                "span": _span(16, 25),
                "arguments": [
                    {
                        "slot": 0,
                        "kind": "optional",
                        "source": "explicit",
                        "delimiter": "bracket",
                        "span": _span(20, 22),
                        "contentSpan": _span(21, 21),
                    },
                    {
                        "slot": 1,
                        "kind": "mandatory",
                        "source": "explicit",
                        "delimiter": "brace",
                        "span": _span(22, 25),
                        "contentSpan": _span(23, 24),
                    },
                ],
                "status": "attached",
                "text": "\\foo[]{x}",
            }
        ],
    }


def test_texdig_schemas_are_discoverable_under_unique_names() -> None:
    catalog = SchemaCatalog()
    for name, schema_id in SCHEMAS.items():
        assert catalog.has_schema(name)
        assert catalog.get_schema(name)["$id"] == schema_id


def test_parsed_source_requires_text_length() -> None:
    validator = SchemaCatalog().get_validator("texdig-sources")
    source = {
        "id": "main.tex",
        "sha256": "0" * 64,
        "bytes": 10,
        "language": "latex",
        "role": "entrypoint",
        "parsed": True,
    }
    with pytest.raises(ValidationError):
        validator.validate(source)
    validator.validate({**source, "lengthUtf16": 10})
    with pytest.raises(ValidationError):
        validator.validate({**source, "language": "asset", "lengthUtf16": 10})


def test_entity_requires_evidence_basis_and_span_role() -> None:
    validator = SchemaCatalog().get_validator("texdig-entities")
    span = {"sourceId": "main.tex", "startUtf16": 0, "endUtf16": 4}
    entity = {
        "id": "ent:macro-invocation@main.tex:0-4",
        "kind": "macro-invocation",
        "name": "foo",
        "span": span,
        "spanProvenance": "lexical",
        "witnesses": [{"witness": "lexical", "span": span}],
        "agreement": "lexical-only",
        "agreementBasis": "single-authority",
        "text": "\\foo",
    }
    with pytest.raises(ValidationError):
        validator.validate(entity)
    entity["witnesses"][0]["spanRole"] = "token"
    validator.validate(entity)


def test_physical_macro_entity_rejects_binding_derived_arguments() -> None:
    validator = SchemaCatalog().get_validator("texdig-entities")
    span = {"sourceId": "main.tex", "startUtf16": 0, "endUtf16": 4}
    entity = {
        "id": "ent:macro-invocation@main.tex:0-4",
        "kind": "macro-invocation",
        "name": "foo",
        "span": span,
        "spanProvenance": "lexical",
        "witnesses": [{"witness": "lexical", "span": span, "spanRole": "token"}],
        "agreement": "lexical-only",
        "agreementBasis": "single-authority",
        "text": "\\foo",
        "argumentSpans": [],
    }
    with pytest.raises(ValidationError):
        validator.validate(entity)


def test_entity_union_rejects_unknown_kinds_and_missing_kind_fields() -> None:
    validator = SchemaCatalog().get_validator("texdig-entities")
    span = {"sourceId": "main.tex", "startUtf16": 0, "endUtf16": 4}

    def entity(kind: str, **fields: object) -> dict[str, object]:
        return {
            "id": f"ent:{kind}@main.tex:0-4",
            "kind": kind,
            "span": span,
            "spanProvenance": "lexical",
            "witnesses": [
                {"witness": "lexical", "span": span, "spanRole": "construct"}
            ],
            "agreement": "agreed",
            "agreementBasis": "single-authority",
            "text": "site",
            **fields,
        }

    specimens = {
        "macro-invocation": (entity("macro-invocation", name="foo"), "name"),
        "macro-definition": (
            entity(
                "macro-definition",
                definedName="foo",
                dialect="newcommand",
                elaborable=True,
                context="unknown",
                activation="unknown",
            ),
            "definedName",
        ),
        "environment-definition": (
            entity(
                "environment-definition",
                definedName="proof",
                mechanism="newenvironment",
                context="unknown",
                activation="unknown",
            ),
            "mechanism",
        ),
        "environment": (entity("environment", name="proof", role="generic"), "role"),
        "math": (entity("math", mode="inline", carrier={"form": "dollar"}), "carrier"),
        "verbatim-inline": (entity("verbatim-inline", delimiter="|"), "delimiter"),
        "comment": (entity("comment"), "kind"),
        "paragraph-break": (entity("paragraph-break"), "kind"),
        "include": (entity("include", directive="input", targetRaw="chapter"), "directive"),
        "envelope-marker": (entity("envelope-marker", marker="section"), "marker"),
        "bib-entry": (entity("bib-entry", entryType="article"), "entryType"),
        "bib-string": (entity("bib-string", abbreviationName="jmlr"), "abbreviationName"),
        "bib-preamble": (entity("bib-preamble"), "kind"),
        "bib-comment": (entity("bib-comment", commentForm="explicit"), "commentForm"),
        "bib-field": (
            entity(
                "bib-field",
                entryId="ent:bib-entry@main.tex:0-4",
                fieldName="title",
                valueSpan=span,
                valueShape="text",
            ),
            "fieldName",
        ),
    }

    for specimen, required_field in specimens.values():
        validator.validate(specimen)
        invalid = {**specimen}
        invalid.pop(required_field)
        with pytest.raises(ValidationError):
            validator.validate(invalid)

    with pytest.raises(ValidationError):
        validator.validate(entity("bogus"))


def test_token_only_envelope_marker_rejects_title_span() -> None:
    validator = SchemaCatalog().get_validator("texdig-entities")
    span = {"sourceId": "main.tex", "startUtf16": 0, "endUtf16": 8}
    marker = {
        "id": "ent:envelope-marker@main.tex:0-8",
        "kind": "envelope-marker",
        "marker": "section",
        "name": "section",
        "span": span,
        "titleSpan": {"sourceId": "main.tex", "startUtf16": 9, "endUtf16": 14},
        "spanProvenance": "lexical",
        "witnesses": [{"witness": "lexical", "span": span, "spanRole": "token"}],
        "agreement": "agreed",
        "agreementBasis": "single-authority",
        "text": "\\section",
    }
    with pytest.raises(ValidationError):
        validator.validate(marker)


def test_summary_requires_the_exact_emitted_schema_map() -> None:
    validator = SchemaCatalog().get_validator("texdig-summary")
    deferred = [
        "occurrences.jsonl",
        "bindings.jsonl",
        "invocations.jsonl",
        "expansion.jsonl",
        "walk.jsonl",
        "zones.jsonl",
        "macros.jsonl",
        "references.jsonl",
        "pointers.jsonl",
        "frontmatter.jsonl",
        "graph.jsonl",
    ]
    summary = {
        "schema": "texdig-census/0.2",
        "slug": "fixture",
        "treeSha256": "0" * 64,
        "entrypoint": "main.tex",
        "stores": {
            "emitted": [
                "sources.jsonl",
                "entities.jsonl",
                "claims.jsonl",
                "coverage.json",
                "diagnostics.jsonl",
                "summary.json",
            ],
            "deferred": deferred,
        },
        "storeSchemas": {
            filename: schema_id for filename, schema_id in (
                ("sources.jsonl", SCHEMAS["texdig-sources"]),
                ("entities.jsonl", SCHEMAS["texdig-entities"]),
                ("claims.jsonl", SCHEMAS["texdig-claims"]),
                ("coverage.json", SCHEMAS["texdig-coverage"]),
                ("diagnostics.jsonl", SCHEMAS["texdig-diagnostics"]),
                ("summary.json", SCHEMAS["texdig-summary"]),
            )
        },
        "runtime": {"node": "v26.0.0"},
        "sourceCount": 1,
        "entityCounts": {},
        "agreementCounts": {},
        "diagnosticCounts": {},
        "coverage": {
            "totalUtf16": 0,
            "claimedUtf16": 0,
            "residueUtf16": 0,
            "residueSegments": 0,
        },
    }
    validator.validate(summary)
    summary["storeSchemas"]["summary.json"] = "wrong"
    with pytest.raises(ValidationError):
        validator.validate(summary)

    summary["storeSchemas"]["summary.json"] = SCHEMAS["texdig-summary"]
    summary["stores"]["deferred"] = []
    with pytest.raises(ValidationError):
        validator.validate(summary)


def test_diagnostic_code_must_be_registered() -> None:
    validator = SchemaCatalog().get_validator("texdig-diagnostics")
    validator.validate(
        {
            "code": "census/residue",
            "severity": "warning",
            "message": "one uncovered unit",
            "sourceId": "main.tex",
        }
    )
    with pytest.raises(ValidationError):
        validator.validate(
            {
                "code": "census/unregistered",
                "severity": "warning",
                "message": "unknown code",
            }
        )


def test_texdig_v03_schemas_are_discoverable_under_unique_names() -> None:
    catalog = SchemaCatalog()
    for name, schema_id in V03_SCHEMAS.items():
        assert catalog.has_schema(name)
        assert catalog.get_schema(name)["$id"] == schema_id


def test_texdig_v03_schema_specimens_cover_every_promoted_store() -> None:
    catalog = SchemaCatalog()
    specimens = _v03_specimens()
    assert set(specimens) == set(V03_SCHEMAS)
    for name, rows in specimens.items():
        validator = catalog.get_validator(name)
        for row in rows:
            validator.validate(row)


def test_texdig_v03_correlated_unions_are_closed() -> None:
    catalog = SchemaCatalog()
    specimens = _v03_specimens()

    configured_entity = {**specimens["texdig-entities-v03"][0]}
    configured_entity.pop("configuredPackage")
    with pytest.raises(ValidationError):
        catalog.get_validator("texdig-entities-v03").validate(configured_entity)

    root_occurrence = {**specimens["texdig-occurrences"][0]}
    root_occurrence["parentOccurrenceId"] = "occ:" + "9" * 64
    with pytest.raises(ValidationError):
        catalog.get_validator("texdig-occurrences").validate(root_occurrence)

    configured_event = {**specimens["texdig-bindings"][1]}
    configured_event["operation"] = "restore"
    with pytest.raises(ValidationError):
        catalog.get_validator("texdig-bindings").validate(configured_event)

    attached_invocation = {**specimens["texdig-invocations"][0]}
    attached_invocation["status"] = "unbound"
    with pytest.raises(ValidationError):
        catalog.get_validator("texdig-invocations").validate(attached_invocation)

    summary = _v03_summary()
    summary["entityCounts"]["future-kind"] = 1
    with pytest.raises(ValidationError):
        catalog.get_validator("texdig-summary-v03").validate(summary)


def test_texdig_invocation_argument_sources_are_correlated() -> None:
    validator = SchemaCatalog().get_validator("texdig-invocations")
    invocation = _v03_specimens()["texdig-invocations"][0]

    explicit = invocation["arguments"][0]
    explicit_without_span = {
        **invocation,
        "arguments": [{key: value for key, value in explicit.items() if key != "span"}],
    }
    with pytest.raises(ValidationError):
        validator.validate(explicit_without_span)

    defaulted = {
        "slot": 0,
        "kind": "optional",
        "source": "default",
        "delimiter": "none",
        "defaultText": "d",
    }
    validator.validate({**invocation, "arguments": [defaulted]})

    for corrupt in (
        {**defaulted, "source": "omitted"},
        {**defaulted, "span": _span(16, 17)},
        {
            "slot": 0,
            "kind": "optional",
            "source": "omitted",
            "delimiter": "bracket",
        },
        {
            "slot": 0,
            "kind": "optional",
            "source": "omitted",
            "delimiter": "none",
            "contentSpan": _span(16, 16),
        },
    ):
        with pytest.raises(ValidationError):
            validator.validate({**invocation, "arguments": [corrupt]})

    unbound_with_arguments = {
        **invocation,
        "binding": {"state": "unbound"},
        "status": "unbound",
    }
    with pytest.raises(ValidationError):
        validator.validate(unbound_with_arguments)
