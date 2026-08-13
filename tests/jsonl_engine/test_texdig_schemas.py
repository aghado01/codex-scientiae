"""Normative TeXdig 0.2 schema registration and boundary checks."""

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
