/**
 * TeXdig store emitter.
 *
 * Emits physical evidence, chronological execution-ledger, audit, and summary
 * stores for the landed TeXdig census contract.
 * Slices are extracted directly from raw UTF-16 source strings (never printRaw).
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { isDeepStrictEqual } from "node:util";
import type {
  SourceFileRecord,
  CensusEntity,
  PillarClaim,
  SourceCoverage,
  Diagnostic,
  CensusSummary,
  SignatureEvidence,
  SourceId,
  SourceSpan,
} from "../core/types.ts";
import type {
  BindingEvent,
  BindingRow,
  ConfiguredSummon,
  DeclarationDisposition,
  InvocationOccurrence,
  ScopeFrame,
  SourceOccurrence,
} from "../core/contracts.ts";
import {
  CENSUS_SCHEMA_VERSION,
  CENSUS_DEFERRED_STORES,
  CENSUS_STORE_SCHEMAS,
  DiagnosticCodes,
} from "../core/types.ts";
import { sourceSpanContains, validateSourceSpan } from "../core/spans.ts";
import {
  attachInvocationArguments,
  attachLiteralIncludeInvocation,
  type InvocationAttachmentResult,
} from "../compile/arguments.ts";
import { computeSourceTreeSha256 } from "./source-fingerprint.ts";
import { compareCensusEntityWitnesses } from "./witness-equivalence.ts";

export interface EmitBundle {
  slug: string;
  treeSha256: string;
  entrypoint: SourceId;
  sources: SourceFileRecord[];
  entities: CensusEntity[];
  occurrences: SourceOccurrence[];
  bindings: BindingRow[];
  invocations: InvocationOccurrence[];
  claims: PillarClaim[];
  coverage: SourceCoverage[];
  diagnostics: Diagnostic[];
  /** Exact one-read buffers for every deposited source, including binary assets. */
  rawBuffers: Map<SourceId, Buffer>;
  rawContents: Map<SourceId, string>;
  /** Exact Node runtime used for this bundle. */
  runtimeNode: string;
}

export function emitCensusBundle(bundle: EmitBundle, outDir: string): CensusSummary {
  validateCensusBundle(bundle);

  const resolvedOutDir = path.resolve(outDir);
  if (fs.existsSync(resolvedOutDir)) {
    throw new Error(`Refusing to overwrite existing TeXdig bundle '${resolvedOutDir}'`);
  }

  const outParent = path.dirname(resolvedOutDir);
  fs.mkdirSync(outParent, { recursive: true });
  const requestedStageParent = process.env.TEMP || process.env.TMP || outParent;
  const stageParent = path.parse(path.resolve(requestedStageParent)).root === path.parse(resolvedOutDir).root
    ? path.resolve(requestedStageParent)
    : outParent;
  fs.mkdirSync(stageParent, { recursive: true });
  const stageDir = fs.mkdtempSync(path.join(stageParent, ".texdig-publish-"));

  try {
    const summary = writeBundle(bundle, stageDir);
    fs.renameSync(stageDir, resolvedOutDir);
    return summary;
  } catch (error) {
    fs.rmSync(stageDir, { recursive: true, force: true });
    throw error;
  }
}

function failInvariant(message: string): never {
  throw new Error(`TeXdig 0.3 emission invariant failed: ${message}`);
}

function entityChildSpans(entity: CensusEntity): SourceSpan[] {
  const spans: SourceSpan[] = [];
  if ("bodySpan" in entity && entity.bodySpan) spans.push(entity.bodySpan);
  if ("beginBodySpan" in entity && entity.beginBodySpan) spans.push(entity.beginBodySpan);
  if ("endBodySpan" in entity && entity.endBodySpan) spans.push(entity.endBodySpan);
  if ("valueSpan" in entity && entity.valueSpan) spans.push(entity.valueSpan);
  if ("parts" in entity && entity.parts) spans.push(...entity.parts.map((part) => part.span));
  return spans;
}

const BASE_ENTITY_FIELDS = [
  "id", "kind", "span", "spanProvenance", "witnesses", "agreement", "agreementBasis",
] as const;
const WITNESS_KINDS = new Set(["lexical", "parser", "configured"]);
const WITNESS_SPAN_ROLES = new Set([
  "token", "construct", "begin-fence", "end-fence", "content", "value", "summon-anchor",
]);
const WITNESS_INSTRUMENTS = new Set(["unified-latex", "latex-utensils", "unified-latex-ctan"]);
const SPAN_PROVENANCE = new Set(["parser", "lexical", "synthesized-hull"]);
const AGREEMENTS = new Set(["agreed", "lexical-only", "parser-only", "conflict"]);
const AGREEMENT_BASES = new Set(["two-instrument", "single-authority", "configured-declaration"]);
const DEFINITION_DIALECTS = new Set([
  "newcommand", "renewcommand", "providecommand", "xparse", "math-operator",
  "paired-delimiter", "let", "def", "gdef", "edef", "xdef", "configured",
]);
const DECLARATION_CONTEXTS = new Set([
  "document-flow", "definition-body", "group-local", "conditional", "argument-body", "unknown",
]);
const DECLARATION_ACTIVATIONS = new Set(["immediate", "deferred", "configured", "unknown"]);
const ENVIRONMENT_MECHANISMS = new Set(["newtheorem", "newenvironment", "newfloat", "configured"]);
const ENVIRONMENT_ROLES = new Set(["float", "math", "verbatim", "bibliography", "generic"]);
const ENVELOPE_MARKERS = new Set([
  "documentclass", "begin-document", "end-document", "section", "appendix", "bibliography",
]);
const INCLUDE_DIRECTIVES = new Set([
  "input", "include", "bibliography", "addbibresource", "bibliographystyle",
]);
const BIB_VALUE_SHAPES = new Set(["text", "number", "abbreviation", "concat"]);

function isRecord(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

function requireField(record: Record<string, unknown>, key: string, label: string): unknown {
  if (!Object.prototype.hasOwnProperty.call(record, key) || record[key] === undefined) {
    failInvariant(`${label} is missing required field '${key}'`);
  }
  return record[key];
}

function requireString(record: Record<string, unknown>, key: string, label: string, nonempty = true): string {
  const value = requireField(record, key, label);
  if (typeof value !== "string" || (nonempty && value.length === 0)) {
    failInvariant(`${label} has invalid string field '${key}'`);
  }
  return value;
}

function optionalString(record: Record<string, unknown>, key: string, label: string): void {
  if (record[key] !== undefined && typeof record[key] !== "string") {
    failInvariant(`${label} has invalid optional string field '${key}'`);
  }
}

function requireBoolean(record: Record<string, unknown>, key: string, label: string): void {
  if (typeof requireField(record, key, label) !== "boolean") {
    failInvariant(`${label} has invalid boolean field '${key}'`);
  }
}

function optionalBoolean(record: Record<string, unknown>, key: string, label: string): void {
  if (record[key] !== undefined && typeof record[key] !== "boolean") {
    failInvariant(`${label} has invalid optional boolean field '${key}'`);
  }
}

function requireEnum(
  record: Record<string, unknown>,
  key: string,
  values: ReadonlySet<string>,
  label: string
): string {
  const value = requireString(record, key, label);
  if (!values.has(value)) failInvariant(`${label} has invalid '${key}' value '${value}'`);
  return value;
}

function requireSpanShape(value: unknown, label: string): asserts value is SourceSpan {
  if (!isRecord(value) || typeof value.sourceId !== "string" ||
      !Number.isInteger(value.startUtf16) || !Number.isInteger(value.endUtf16)) {
    failInvariant(`${label} is not a source span`);
  }
}

function optionalSpan(record: Record<string, unknown>, key: string, label: string): void {
  if (record[key] !== undefined) requireSpanShape(record[key], `${label}.${key}`);
}

function requireInteger(
  record: Record<string, unknown>,
  key: string,
  label: string
): number {
  const value = requireField(record, key, label);
  if (!Number.isSafeInteger(value) || (value as number) < 0) {
    failInvariant(`${label} has invalid non-negative integer field '${key}'`);
  }
  return value as number;
}

function requireStringArray(
  record: Record<string, unknown>,
  key: string,
  label: string,
  nonemptyItems = true
): string[] {
  const value = requireField(record, key, label);
  if (!Array.isArray(value) || value.some((item) =>
    typeof item !== "string" || (nonemptyItems && item.length === 0)
  )) {
    failInvariant(`${label} has invalid string-array field '${key}'`);
  }
  return value as string[];
}

function assertAllowedFields(
  record: Record<string, unknown>,
  allowed: readonly string[],
  label: string
): void {
  const set = new Set(allowed);
  for (const key of Object.keys(record)) {
    if (!set.has(key)) failInvariant(`${label} has unsupported field '${key}'`);
  }
}

function sameSpan(left: SourceSpan, right: SourceSpan): boolean {
  return left.sourceId === right.sourceId
    && left.startUtf16 === right.startUtf16
    && left.endUtf16 === right.endUtf16;
}

function requireSignatureEvidence(record: Record<string, unknown>, key: string, label: string): void {
  const evidence = requireField(record, key, label);
  if (!isRecord(evidence)) failInvariant(`${label}.${key} is not an object`);
  const state = requireEnum(
    evidence,
    "state",
    new Set(["known", "custom-parser", "unknown"]),
    `${label}.${key}`
  );
  if (state === "known") requireString(evidence, "spec", `${label}.${key}`, false);
  if (state === "custom-parser") requireString(evidence, "detail", `${label}.${key}`);
  if (state === "unknown") optionalString(evidence, "detail", `${label}.${key}`);
  const allowed = state === "known" ? ["state", "spec"] : ["state", "detail"];
  for (const field of Object.keys(evidence)) {
    if (!allowed.includes(field)) failInvariant(`${label}.${key} has unsupported field '${field}'`);
  }
}

/** Reject runtime values that evade the compile-time CensusEntity union. */
function validateEntityShape(value: unknown): asserts value is CensusEntity {
  if (!isRecord(value)) failInvariant("entity row is not an object");
  const id = requireString(value, "id", "entity");
  const label = `entity '${id}'`;
  const kind = requireString(value, "kind", label);
  requireSpanShape(requireField(value, "span", label), `${label}.span`);
  requireEnum(value, "spanProvenance", SPAN_PROVENANCE, label);
  requireEnum(value, "agreement", AGREEMENTS, label);
  requireEnum(value, "agreementBasis", AGREEMENT_BASES, label);

  const witnesses = requireField(value, "witnesses", label);
  if (!Array.isArray(witnesses) || witnesses.length === 0) {
    failInvariant(`${label} has no witnesses`);
  }
  for (const witness of witnesses) {
    if (!isRecord(witness)) failInvariant(`${label} has a non-object witness`);
    const witnessLabel = `witness on ${label}`;
    requireEnum(witness, "witness", WITNESS_KINDS, witnessLabel);
    requireSpanShape(requireField(witness, "span", witnessLabel), `${witnessLabel}.span`);
    requireEnum(witness, "spanRole", WITNESS_SPAN_ROLES, witnessLabel);
    if (witness.instrument !== undefined &&
        (typeof witness.instrument !== "string" || !WITNESS_INSTRUMENTS.has(witness.instrument))) {
      failInvariant(`${witnessLabel} has invalid instrument`);
    }
    optionalString(witness, "detail", witnessLabel);
    for (const key of Object.keys(witness)) {
      if (!["witness", "span", "spanRole", "instrument", "detail"].includes(key)) {
        failInvariant(`${witnessLabel} has unsupported field '${key}'`);
      }
    }
  }

  let kindFields: string[];
  switch (kind) {
    case "macro-invocation":
      requireString(value, "name", label);
      optionalBoolean(value, "inMathMode", label);
      kindFields = ["name", "inMathMode"];
      break;
    case "macro-definition":
      requireString(value, "definedName", label);
      requireString(value, "declarationCommand", label);
      const dialect = requireEnum(value, "dialect", DEFINITION_DIALECTS, label);
      requireBoolean(value, "elaborable", label);
      requireEnum(value, "context", DECLARATION_CONTEXTS, label);
      requireEnum(value, "activation", DECLARATION_ACTIVATIONS, label);
      optionalString(value, "signatureRaw", label);
      optionalString(value, "argumentSpec", label);
      requireSignatureEvidence(value, "signature", label);
      optionalString(value, "configuredPackage", label);
      if (dialect === "configured" && typeof value.configuredPackage !== "string") {
        failInvariant(`${label} configured declaration has no provider package`);
      }
      optionalSpan(value, "bodySpan", label);
      optionalString(value, "definedWithin", label);
      kindFields = [
        "definedName", "declarationCommand", "dialect", "signatureRaw", "argumentSpec", "signature", "configuredPackage", "bodySpan",
        "elaborable", "context", "activation", "definedWithin",
      ];
      break;
    case "environment-definition":
      requireString(value, "definedName", label);
      requireString(value, "declarationCommand", label);
      const mechanism = requireEnum(value, "mechanism", ENVIRONMENT_MECHANISMS, label);
      requireEnum(value, "context", DECLARATION_CONTEXTS, label);
      requireEnum(value, "activation", DECLARATION_ACTIVATIONS, label);
      optionalString(value, "signatureRaw", label);
      optionalString(value, "argumentSpec", label);
      requireSignatureEvidence(value, "signature", label);
      optionalString(value, "configuredPackage", label);
      if (mechanism === "configured" && typeof value.configuredPackage !== "string") {
        failInvariant(`${label} configured declaration has no provider package`);
      }
      optionalString(value, "counterRaw", label);
      optionalSpan(value, "beginBodySpan", label);
      optionalSpan(value, "endBodySpan", label);
      optionalString(value, "definedWithin", label);
      kindFields = [
        "definedName", "declarationCommand", "mechanism", "signatureRaw", "argumentSpec", "signature", "configuredPackage", "counterRaw",
        "beginBodySpan", "endBodySpan", "context", "activation", "definedWithin",
      ];
      break;
    case "environment":
      requireString(value, "name", label);
      requireEnum(value, "role", ENVIRONMENT_ROLES, label);
      optionalSpan(value, "bodySpan", label);
      kindFields = ["name", "role", "bodySpan"];
      break;
    case "math": {
      requireEnum(value, "mode", new Set(["inline", "display"]), label);
      const carrier = requireField(value, "carrier", label);
      if (!isRecord(carrier)) failInvariant(`${label} has invalid carrier`);
      const form = requireEnum(carrier, "form", new Set(["dollar", "double-dollar", "paren", "bracket", "env"]), `${label}.carrier`);
      if (form === "env") requireString(carrier, "name", `${label}.carrier`);
      for (const key of Object.keys(carrier)) {
        if (key !== "form" && !(form === "env" && key === "name")) {
          failInvariant(`${label}.carrier has unsupported field '${key}'`);
        }
      }
      optionalString(value, "fenceEntityId", label);
      kindFields = ["mode", "carrier", "fenceEntityId"];
      break;
    }
    case "verbatim-inline":
      requireString(value, "delimiter", label);
      kindFields = ["delimiter"];
      break;
    case "comment":
    case "paragraph-break":
    case "bib-preamble":
      kindFields = [];
      break;
    case "include":
      requireEnum(value, "directive", INCLUDE_DIRECTIVES, label);
      requireString(value, "targetRaw", label, false);
      optionalString(value, "resolvedSourceId", label);
      kindFields = ["directive", "targetRaw", "resolvedSourceId"];
      break;
    case "envelope-marker":
      requireEnum(value, "marker", ENVELOPE_MARKERS, label);
      optionalString(value, "name", label);
      kindFields = ["marker", "name"];
      break;
    case "bib-entry":
      requireString(value, "entryType", label);
      optionalString(value, "citeKey", label);
      optionalSpan(value, "bodySpan", label);
      kindFields = ["entryType", "citeKey", "bodySpan"];
      break;
    case "bib-string":
      requireString(value, "abbreviationName", label);
      optionalSpan(value, "valueSpan", label);
      kindFields = ["abbreviationName", "valueSpan"];
      break;
    case "bib-comment":
      requireEnum(value, "commentForm", new Set(["explicit", "implicit"]), label);
      kindFields = ["commentForm"];
      break;
    case "bib-field": {
      requireString(value, "entryId", label);
      requireString(value, "fieldName", label);
      requireSpanShape(requireField(value, "valueSpan", label), `${label}.valueSpan`);
      requireEnum(value, "valueShape", BIB_VALUE_SHAPES, label);
      if (value.parts !== undefined) {
        if (!Array.isArray(value.parts)) failInvariant(`${label}.parts is not an array`);
        for (const part of value.parts) {
          if (!isRecord(part)) failInvariant(`${label}.parts contains a non-object`);
          requireSpanShape(requireField(part, "span", `${label}.part`), `${label}.part.span`);
          requireEnum(part, "shape", new Set(["text", "number", "abbreviation"]), `${label}.part`);
          for (const key of Object.keys(part)) {
            if (key !== "span" && key !== "shape") failInvariant(`${label}.part has unsupported field '${key}'`);
          }
        }
      }
      kindFields = ["entryId", "fieldName", "valueSpan", "valueShape", "parts"];
      break;
    }
    default:
      failInvariant(`${label} has unknown kind '${kind}'`);
  }

  const allowed = new Set<string>([...BASE_ENTITY_FIELDS, ...kindFields]);
  for (const key of Object.keys(value)) {
    if (!allowed.has(key)) failInvariant(`${label} has unsupported field '${key}'`);
  }
}

function validateOccurrenceShape(value: unknown): asserts value is SourceOccurrence {
  if (!isRecord(value)) failInvariant("occurrence row is not an object");
  const id = requireString(value, "id", "occurrence");
  const label = `occurrence '${id}'`;
  if (!id.startsWith("occ:")) failInvariant(`${label} has invalid id class`);
  requireString(value, "sourceId", label);
  const includeChain = requireStringArray(value, "includeChain", label);
  if (includeChain.length === 0) failInvariant(`${label} has an empty include chain`);
  const basis = requireEnum(value, "basis", new Set(["manifest-entrypoint", "literal-directive"]), label);
  const state = requireEnum(value, "state", new Set(["entered", "cycle-cut", "deferred-context"]), label);
  const enterSeq = requireInteger(value, "enterSeq", label);
  const exitSeq = requireInteger(value, "exitSeq", label);
  if (exitSeq < enterSeq) failInvariant(`${label} exits before it enters`);
  optionalString(value, "parentOccurrenceId", label);
  optionalString(value, "includeEntityId", label);
  optionalString(value, "cycleTargetOccurrenceId", label);
  if (value.deferredReason !== undefined) {
    requireEnum(
      value,
      "deferredReason",
      new Set(["definition-body", "conditional", "argument-body", "unknown-context"]),
      label
    );
  }
  const hasParent = typeof value.parentOccurrenceId === "string";
  const hasInclude = typeof value.includeEntityId === "string";
  if (basis === "manifest-entrypoint") {
    if (hasParent || hasInclude || includeChain.length !== 1) {
      failInvariant(`${label} has invalid root-route fields`);
    }
  } else if (!hasParent || !hasInclude || includeChain.length < 2) {
    failInvariant(`${label} has incomplete literal-route fields`);
  }
  if (state === "cycle-cut") {
    if (typeof value.cycleTargetOccurrenceId !== "string" || value.deferredReason !== undefined) {
      failInvariant(`${label} has incomplete cycle-cut evidence`);
    }
  } else if (state === "deferred-context") {
    if (typeof value.deferredReason !== "string" || value.cycleTargetOccurrenceId !== undefined) {
      failInvariant(`${label} has incomplete deferred-context evidence`);
    }
  } else if (value.cycleTargetOccurrenceId !== undefined || value.deferredReason !== undefined) {
    failInvariant(`${label} entered state carries cut/deferred evidence`);
  }
  assertAllowedFields(value, [
    "id", "sourceId", "parentOccurrenceId", "includeEntityId", "includeChain",
    "basis", "state", "enterSeq", "exitSeq", "cycleTargetOccurrenceId", "deferredReason",
  ], label);
}

function validateMeaningShape(value: unknown, label: string): void {
  if (!isRecord(value)) failInvariant(`${label} is not an object`);
  const kind = requireEnum(
    value,
    "kind",
    new Set(["declaration", "primitive", "captured", "character-token", "opaque", "indeterminate"]),
    label
  );
  requireSignatureEvidence(value, "signature", label);
  switch (kind) {
    case "declaration":
      requireString(value, "entityId", label);
      requireEnum(value, "availability", new Set(["body", "signature-only", "opaque"]), label);
      assertAllowedFields(value, ["kind", "entityId", "availability", "signature"], label);
      break;
    case "primitive":
      requireString(value, "name", label);
      assertAllowedFields(value, ["kind", "name", "signature"], label);
      break;
    case "captured":
      requireString(value, "sourceBindingEventId", label);
      assertAllowedFields(value, ["kind", "sourceBindingEventId", "signature"], label);
      break;
    case "character-token":
      requireString(value, "text", label);
      requireEnum(value, "catcode", new Set(["unknown"]), label);
      assertAllowedFields(value, ["kind", "text", "catcode", "signature"], label);
      break;
    case "opaque":
      requireString(value, "reason", label);
      optionalString(value, "entityId", label);
      assertAllowedFields(value, ["kind", "entityId", "reason", "signature"], label);
      break;
    case "indeterminate":
      requireString(value, "reason", label);
      requireStringArray(value, "causeIds", label);
      assertAllowedFields(value, ["kind", "reason", "causeIds", "signature"], label);
      break;
  }
}

function validateCauseShape(value: unknown, label: string): string {
  if (!isRecord(value)) failInvariant(`${label} is not an object`);
  const kind = requireEnum(
    value,
    "kind",
    new Set(["physical-declaration", "configured", "baseline", "scope-exit"]),
    label
  );
  if (kind === "physical-declaration") {
    requireString(value, "entityId", label);
    requireSpanShape(requireField(value, "siteSpan", label), `${label}.siteSpan`);
    assertAllowedFields(value, ["kind", "entityId", "siteSpan"], label);
  } else if (kind === "configured") {
    requireString(value, "summonId", label);
    requireString(value, "entityId", label);
    assertAllowedFields(value, ["kind", "summonId", "entityId"], label);
  } else if (kind === "scope-exit") {
    requireString(value, "scopeId", label);
    assertAllowedFields(value, ["kind", "scopeId"], label);
  } else {
    assertAllowedFields(value, ["kind"], label);
  }
  return kind;
}

function validateBindingRowShape(value: unknown): asserts value is BindingRow {
  if (!isRecord(value)) failInvariant("binding row is not an object");
  const rowType = requireEnum(
    value,
    "rowType",
    new Set(["scope-frame", "configured-summon", "binding-event", "declaration-disposition"]),
    "binding row"
  );
  const id = requireString(value, "id", `binding ${rowType}`);
  const label = `${rowType} '${id}'`;
  if (rowType === "scope-frame") {
    if (!id.startsWith("scope:")) failInvariant(`${label} has invalid id class`);
    const kind = requireEnum(
      value,
      "kind",
      new Set(["global", "document", "brace-group", "environment", "begingroup"]),
      label
    );
    requireInteger(value, "enterSeq", label);
    if (value.exitSeq !== undefined) requireInteger(value, "exitSeq", label);
    const status = requireEnum(value, "status", new Set(["open", "closed", "unterminated", "indeterminate"]), label);
    optionalString(value, "parentScopeId", label);
    optionalString(value, "occurrenceId", label);
    optionalSpan(value, "openSpan", label);
    optionalSpan(value, "closeSpan", label);
    optionalString(value, "openText", label);
    optionalString(value, "closeText", label);
    if (kind === "global") {
      if (value.parentScopeId !== undefined || value.occurrenceId !== undefined) {
        failInvariant(`${label} global frame has parent/occurrence fields`);
      }
    } else if (typeof value.parentScopeId !== "string" || typeof value.occurrenceId !== "string") {
      failInvariant(`${label} has no parent scope or occurrence`);
    }
    if (status === "closed" && value.exitSeq === undefined) failInvariant(`${label} closed frame has no exitSeq`);
    assertAllowedFields(value, [
      "rowType", "id", "kind", "parentScopeId", "occurrenceId", "enterSeq", "exitSeq",
      "status", "openSpan", "closeSpan", "openText", "closeText",
    ], label);
  } else if (rowType === "configured-summon") {
    if (!id.startsWith("summon:")) failInvariant(`${label} has invalid id class`);
    requireInteger(value, "seq", label);
    requireString(value, "occurrenceId", label);
    requireString(value, "scopeId", label);
    requireString(value, "physicalEntityId", label);
    requireEnum(value, "command", new Set(["documentclass", "usepackage", "RequirePackage"]), label);
    requireInteger(value, "targetOrdinal", label);
    requireString(value, "packageName", label);
    requireSpanShape(requireField(value, "siteSpan", label), `${label}.siteSpan`);
    requireSpanShape(requireField(value, "targetSpan", label), `${label}.targetSpan`);
    optionalSpan(value, "optionsSpan", label);
    optionalString(value, "optionsText", label);
    requireString(value, "text", label);
    requireEnum(value, "outcome", new Set(["loaded", "already-loaded", "unconfigured", "indeterminate"]), label);
    requireStringArray(value, "candidateEntityIds", label);
    assertAllowedFields(value, [
      "rowType", "id", "seq", "occurrenceId", "scopeId", "physicalEntityId", "command",
      "targetOrdinal", "packageName", "siteSpan", "targetSpan", "optionsSpan", "optionsText",
      "text", "outcome", "candidateEntityIds",
    ], label);
  } else if (rowType === "binding-event") {
    if (!id.startsWith("bind:")) failInvariant(`${label} has invalid id class`);
    requireInteger(value, "seq", label);
    optionalString(value, "occurrenceId", label);
    requireString(value, "executionScopeId", label);
    requireString(value, "targetScopeId", label);
    const symbol = requireField(value, "symbol", label);
    if (!isRecord(symbol)) failInvariant(`${label}.symbol is not an object`);
    requireEnum(symbol, "namespace", new Set(["control-sequence", "environment"]), `${label}.symbol`);
    requireString(symbol, "name", `${label}.symbol`);
    assertAllowedFields(symbol, ["namespace", "name"], `${label}.symbol`);
    const causeKind = validateCauseShape(requireField(value, "cause", label), `${label}.cause`);
    const operation = requireEnum(value, "operation", new Set([
      "new", "renew", "provide", "assign", "global-assign", "expanded-assign",
      "global-expanded-assign", "let-capture", "configured-install", "baseline-install", "restore",
    ]), label);
    const effect = requireEnum(value, "effect", new Set([
      "installed", "skipped-existing", "invalid-precondition", "restored", "indeterminate",
    ]), label);
    optionalString(value, "priorBindingEventId", label);
    optionalString(value, "restoredBindingEventId", label);
    optionalString(value, "text", label);
    if (value.installedMeaning !== undefined) validateMeaningShape(value.installedMeaning, `${label}.installedMeaning`);
    if (operation === "restore") {
      if (causeKind !== "scope-exit" || effect !== "restored") {
        failInvariant(`${label} has inconsistent restore operation`);
      }
    } else {
      if (value.restoredBindingEventId !== undefined) {
        failInvariant(`${label} carries restoredBindingEventId outside a restore operation`);
      }
      if (causeKind === "scope-exit" || effect === "restored") {
        failInvariant(`${label} has restore-only cause/effect on '${operation}'`);
      }
    }
    if (operation === "baseline-install" && causeKind !== "baseline") {
      failInvariant(`${label} baseline install has a non-baseline cause`);
    }
    if (operation === "configured-install" && causeKind !== "configured") {
      failInvariant(`${label} configured install has a non-configured cause`);
    }
    if (!["restore", "baseline-install", "configured-install"].includes(operation)
        && causeKind !== "physical-declaration") {
      failInvariant(`${label} physical operation has incompatible cause '${causeKind}'`);
    }
    const requiresMeaning = effect === "installed" || effect === "indeterminate";
    if (operation !== "restore" && requiresMeaning !== (value.installedMeaning !== undefined)) {
      failInvariant(`${label} effect and installed meaning disagree`);
    }
    assertAllowedFields(value, [
      "rowType", "id", "seq", "occurrenceId", "executionScopeId", "targetScopeId", "symbol",
      "cause", "operation", "effect", "priorBindingEventId", "restoredBindingEventId",
      "installedMeaning", "text",
    ], label);
  } else {
    if (!id.startsWith("disposition:")) failInvariant(`${label} has invalid id class`);
    requireInteger(value, "seq", label);
    requireString(value, "occurrenceId", label);
    requireString(value, "entityId", label);
    requireEnum(value, "reason", new Set(["definition-body", "conditional", "argument-body", "unknown-context"]), label);
    requireString(value, "text", label);
    assertAllowedFields(value, ["rowType", "id", "seq", "occurrenceId", "entityId", "reason", "text"], label);
  }
}

function validateInvocationShape(value: unknown): asserts value is InvocationOccurrence {
  if (!isRecord(value)) failInvariant("invocation row is not an object");
  const id = requireString(value, "id", "invocation");
  const label = `invocation '${id}'`;
  if (!id.startsWith("inv:")) failInvariant(`${label} has invalid id class`);
  requireInteger(value, "seq", label);
  requireString(value, "occurrenceId", label);
  requireString(value, "entityId", label);
  requireString(value, "name", label, false);
  requireEnum(value, "siteKind", new Set(["control-sequence", "environment-begin"]), label);
  requireSpanShape(requireField(value, "siteSpan", label), `${label}.siteSpan`);
  requireSpanShape(requireField(value, "span", label), `${label}.span`);
  requireString(value, "text", label, false);
  const status = requireEnum(value, "status", new Set(["attached", "unbound", "deferred", "indeterminate", "malformed"]), label);
  const binding = requireField(value, "binding", label);
  if (!isRecord(binding)) failInvariant(`${label}.binding is not an object`);
  const bindingState = requireEnum(binding, "state", new Set(["bound", "unbound", "indeterminate", "deferred"]), `${label}.binding`);
  if (bindingState === "bound") {
    requireString(binding, "bindingEventId", `${label}.binding`);
    requireSignatureEvidence(binding, "signature", `${label}.binding`);
    assertAllowedFields(binding, ["state", "bindingEventId", "signature"], `${label}.binding`);
    if (!["attached", "deferred", "malformed"].includes(status)) {
      failInvariant(`${label} bound state contradicts status '${status}'`);
    }
  } else if (bindingState === "indeterminate") {
    requireStringArray(binding, "causeIds", `${label}.binding`);
    requireString(binding, "detail", `${label}.binding`);
    assertAllowedFields(binding, ["state", "causeIds", "detail"], `${label}.binding`);
    if (status !== "indeterminate") failInvariant(`${label} indeterminate binding has status '${status}'`);
  } else if (bindingState === "deferred") {
    requireString(binding, "reason", `${label}.binding`);
    assertAllowedFields(binding, ["state", "reason"], `${label}.binding`);
    if (status !== "deferred") failInvariant(`${label} deferred binding has status '${status}'`);
  } else {
    assertAllowedFields(binding, ["state"], `${label}.binding`);
    if (status !== "unbound") failInvariant(`${label} unbound binding has status '${status}'`);
  }
  const args = requireField(value, "arguments", label);
  if (!Array.isArray(args)) failInvariant(`${label}.arguments is not an array`);
  for (const [index, argument] of args.entries()) {
    if (!isRecord(argument)) failInvariant(`${label}.arguments[${index}] is not an object`);
    const argLabel = `${label}.arguments[${index}]`;
    const slot = requireInteger(argument, "slot", argLabel);
    if (slot !== index) failInvariant(`${argLabel} is not in canonical slot order`);
    requireEnum(argument, "kind", new Set(["mandatory", "optional", "star", "token", "embellishment", "until"]), argLabel);
    const source = requireEnum(argument, "source", new Set(["explicit", "omitted", "default"]), argLabel);
    requireEnum(argument, "delimiter", new Set(["brace", "bracket", "bare-character", "control-sequence", "none"]), argLabel);
    optionalSpan(argument, "span", argLabel);
    optionalSpan(argument, "contentSpan", argLabel);
    optionalString(argument, "defaultText", argLabel);
    optionalString(argument, "marker", argLabel);
    optionalString(argument, "terminator", argLabel);
    if (source === "explicit" && argument.span === undefined) failInvariant(`${argLabel} explicit argument has no span`);
    if (source !== "explicit" && argument.span !== undefined) failInvariant(`${argLabel} synthetic argument has a span`);
    assertAllowedFields(argument, [
      "slot", "kind", "source", "delimiter", "span", "contentSpan", "defaultText", "marker", "terminator",
    ], argLabel);
  }
  assertAllowedFields(value, [
    "id", "seq", "occurrenceId", "entityId", "name", "siteKind", "siteSpan", "binding",
    "span", "arguments", "status", "text",
  ], label);
}

function validateDiagnosticShape(value: unknown): asserts value is Diagnostic {
  if (!isRecord(value)) failInvariant("diagnostic row is not an object");
  const code = requireEnum(value, "code", new Set(Object.values(DiagnosticCodes)), "diagnostic");
  const label = `diagnostic '${code}'`;
  requireEnum(value, "severity", new Set(["info", "warning", "defect"]), label);
  requireString(value, "message", label);
  for (const key of ["sourceId", "entityId", "occurrenceId", "bindingId", "invocationId"] as const) {
    if (value[key] !== undefined) requireString(value, key, label);
  }
  optionalSpan(value, "span", label);
  if (value.witness !== undefined) requireEnum(value, "witness", WITNESS_KINDS, label);
  assertAllowedFields(value, [
    "code", "severity", "message", "sourceId", "span", "entityId",
    "occurrenceId", "bindingId", "invocationId", "witness",
  ], label);
}

interface ExpectedInvocationCarrier {
  name: string;
  siteKind: InvocationOccurrence["siteKind"];
  siteSpan: SourceSpan;
}

function controlSequenceCarrierSpan(
  sourceId: SourceId,
  raw: string,
  startUtf16: number,
  label: string
): SourceSpan {
  if (raw[startUtf16] !== "\\") failInvariant(`${label} does not begin with a control sequence`);
  let endUtf16 = startUtf16 + 1;
  const first = raw[endUtf16];
  if (first === undefined) {
    endUtf16 = raw.length;
  } else if (/[A-Za-z]/.test(first)) {
    endUtf16 += 1;
    while (endUtf16 < raw.length && /[A-Za-z]/.test(raw[endUtf16])) endUtf16 += 1;
  } else {
    const point = raw.codePointAt(endUtf16);
    endUtf16 += point !== undefined && point > 0xffff ? 2 : 1;
  }
  return { sourceId, startUtf16, endUtf16 };
}

function controlSequenceName(raw: string, span: SourceSpan): string {
  return raw.slice(span.startUtf16 + 1, span.endUtf16);
}

function expectedInvocationCarrier(
  entity: CensusEntity,
  raw: string,
  label: string
): ExpectedInvocationCarrier {
  if (entity.kind === "macro-invocation") {
    const siteSpan = entity.span;
    const exact = raw.slice(siteSpan.startUtf16, siteSpan.endUtf16);
    const expected = `\\${entity.name}`;
    const parserScriptOperator = (entity.name === "^" || entity.name === "_") && exact === entity.name;
    if (exact !== expected && !parserScriptOperator) {
      failInvariant(`${label} contradicts its macro-invocation entity '${entity.id}' (${JSON.stringify(exact)} != ${JSON.stringify(expected)})`);
    }
    return { name: entity.name, siteKind: "control-sequence", siteSpan };
  }
  if (entity.kind === "include") {
    const witnessSpan = entity.witnesses.find((witness) => witness.spanRole === "token")?.span;
    const siteSpan = witnessSpan
      ?? controlSequenceCarrierSpan(entity.span.sourceId, raw, entity.span.startUtf16, label);
    const name = controlSequenceName(raw, siteSpan);
    const permitted = entity.directive === "include"
      ? new Set(["include", "subfile"])
      : new Set([entity.directive]);
    if (!permitted.has(name)) failInvariant(`${label} contradicts its include entity`);
    return { name, siteKind: "control-sequence", siteSpan };
  }
  if (entity.kind === "envelope-marker") {
    if (entity.marker === "begin-document" || entity.marker === "end-document") {
      failInvariant(`${label} names a non-invocable document fence`);
    }
    const siteSpan = entity.span;
    const exact = raw.slice(siteSpan.startUtf16, siteSpan.endUtf16);
    const expectedName = entity.name ?? controlSequenceName(raw, siteSpan);
    const baseName = expectedName.replace(/\*$/, "");
    if (exact !== `\\${baseName}`
        || (expectedName.endsWith("*") && raw[siteSpan.endUtf16] !== "*")) {
      failInvariant(`${label} contradicts its envelope-marker entity`);
    }
    return { name: expectedName, siteKind: "control-sequence", siteSpan };
  }
  if (entity.kind === "environment") {
    const siteSpan = entity.witnesses.find((witness) => witness.spanRole === "begin-fence")?.span;
    if (!siteSpan || !sourceSpanContains(entity.span, siteSpan)) {
      failInvariant(`${label} environment entity has no canonical begin-fence witness`);
    }
    const fence = raw.slice(siteSpan.startUtf16, siteSpan.endUtf16);
    const match = /^\\begin\s*\{([^}]*)\}$/.exec(fence);
    if (!match || match[1].trim() !== entity.name) {
      failInvariant(`${label} contradicts its environment begin fence`);
    }
    return { name: entity.name, siteKind: "environment-begin", siteSpan };
  }
  failInvariant(`${label} names non-invocable entity kind '${entity.kind}'`);
}

function bindingSymbolKey(event: BindingEvent): string {
  return `${event.symbol.namespace}\0${event.symbol.name}`;
}

function sameBindingSymbol(left: BindingEvent, right: BindingEvent): boolean {
  return left.symbol.namespace === right.symbol.namespace && left.symbol.name === right.symbol.name;
}

function expectedDeclarationOperation(entity: Extract<CensusEntity, {
  kind: "macro-definition" | "environment-definition";
}>): BindingEvent["operation"] {
  switch (entity.declarationCommand) {
    case "renewcommand":
    case "RenewDocumentCommand":
    case "renewenvironment":
      return "renew";
    case "providecommand":
    case "ProvideDocumentCommand":
      return "provide";
    case "def":
      return "assign";
    case "gdef":
      return "global-assign";
    case "edef":
      return "expanded-assign";
    case "xdef":
      return "global-expanded-assign";
    case "let":
      return "let-capture";
    default:
      return "new";
  }
}

function assertEventSymbolMatchesEntity(
  event: BindingEvent,
  entity: Extract<CensusEntity, { kind: "macro-definition" | "environment-definition" }>,
  label: string
): void {
  const namespace = entity.kind === "macro-definition" ? "control-sequence" : "environment";
  if (event.symbol.namespace !== namespace || event.symbol.name !== entity.definedName) {
    failInvariant(`${label} symbol contradicts its declaration entity`);
  }
}

function physicalControlSequenceSpans(
  entities: readonly CensusEntity[],
  sourceId: SourceId
): SourceSpan[] {
  const keyed = new Map<string, SourceSpan>();
  for (const entity of entities) {
    if (entity.span.sourceId !== sourceId || entity.kind !== "macro-invocation") continue;
    keyed.set(`${entity.span.startUtf16}:${entity.span.endUtf16}`, entity.span);
  }
  return [...keyed.values()].sort((left, right) =>
    left.startUtf16 - right.startUtf16 || left.endUtf16 - right.endUtf16
  );
}

function replayInvocationAttachment(
  entity: CensusEntity,
  raw: string,
  siteSpan: SourceSpan,
  signature: SignatureEvidence,
  controlSequenceSpans: readonly SourceSpan[],
  governingPrimitive: string | undefined
): InvocationAttachmentResult {
  const carrierName = controlSequenceName(raw, siteSpan);
  if (entity.kind === "include"
      && governingPrimitive === carrierName
      && (carrierName === "input" || carrierName === "include" || carrierName === "subfile")) {
    return attachLiteralIncludeInvocation(raw, siteSpan, {
      directiveSpan: entity.span,
      targetRaw: entity.targetRaw,
    });
  }
  return attachInvocationArguments(raw, siteSpan, signature, { controlSequenceSpans });
}

/**
 * Validate the complete in-memory bundle before the first publication write.
 * These checks intentionally reject corrupt evidence instead of clipping or
 * repairing it at the output boundary.
 */
export function validateCensusBundle(bundle: EmitBundle): void {
  if (!/^[0-9a-f]{64}$/.test(bundle.treeSha256)) {
    failInvariant("treeSha256 is not a lowercase SHA-256 digest");
  }

  const sources = new Map<SourceId, SourceFileRecord>();
  let previousSourceId: SourceId | undefined;
  for (const source of bundle.sources) {
    if (previousSourceId !== undefined && previousSourceId >= source.id) {
      failInvariant(`sources are not in unique ordinal path order at '${source.id}'`);
    }
    if (sources.has(source.id)) failInvariant(`duplicate source '${source.id}'`);
    if (!/^[0-9a-f]{64}$/.test(source.sha256)) {
      failInvariant(`source '${source.id}' has an invalid SHA-256 digest`);
    }
    if (!Number.isSafeInteger(source.bytes) || source.bytes < 0) {
      failInvariant(`source '${source.id}' has invalid byte length`);
    }
    if (source.parsed && source.lengthUtf16 === undefined) {
      failInvariant(`parsed source '${source.id}' has no UTF-16 length`);
    }
    if (source.parsed && source.language === "asset") {
      failInvariant(`parsed source '${source.id}' has asset language`);
    }
    if (source.lengthUtf16 !== undefined &&
        (!Number.isInteger(source.lengthUtf16) || source.lengthUtf16 < 0)) {
      failInvariant(`source '${source.id}' has invalid UTF-16 length`);
    }
    const buffer = bundle.rawBuffers.get(source.id);
    if (!Buffer.isBuffer(buffer)) {
      failInvariant(`source '${source.id}' has no exact deposited byte buffer`);
    }
    if (buffer.length !== source.bytes) {
      failInvariant(`source '${source.id}' byte length does not match its exact buffer`);
    }
    const bufferSha256 = crypto.createHash("sha256").update(buffer).digest("hex");
    if (bufferSha256 !== source.sha256) {
      failInvariant(`source '${source.id}' SHA-256 does not match its exact buffer`);
    }

    const raw = bundle.rawContents.get(source.id);
    if (source.parsed && raw === undefined) {
      failInvariant(`parsed source '${source.id}' has no decoded source text`);
    }
    if ((source.lengthUtf16 === undefined) !== (raw === undefined)) {
      failInvariant(`source '${source.id}' decoded text and UTF-16 length disagree`);
    }
    if (raw !== undefined && source.lengthUtf16 !== raw.length) {
      failInvariant(`source '${source.id}' UTF-16 length does not match decoded text`);
    }
    if (raw !== undefined && !Buffer.from(raw, "utf8").equals(buffer)) {
      failInvariant(`source '${source.id}' decoded UTF-8 text does not match its exact buffer`);
    }
    sources.set(source.id, source);
    previousSourceId = source.id;
  }
  for (const sourceId of bundle.rawBuffers.keys()) {
    if (!sources.has(sourceId)) failInvariant(`exact byte buffer names unknown source '${sourceId}'`);
  }
  for (const sourceId of bundle.rawContents.keys()) {
    if (!sources.has(sourceId)) failInvariant(`decoded text names unknown source '${sourceId}'`);
  }
  const computedTreeSha256 = computeSourceTreeSha256(
    bundle.sources.map((source) => ({ path: source.id, bytes: source.bytes, sha256: source.sha256 }))
  );
  if (computedTreeSha256 !== bundle.treeSha256) {
    failInvariant(`treeSha256 does not match the canonical source-record aggregate`);
  }
  if (!sources.has(bundle.entrypoint)) {
    failInvariant(`entrypoint '${bundle.entrypoint}' is absent from sources`);
  }
  const entrypoints = bundle.sources.filter((source) => source.role === "entrypoint");
  if (entrypoints.length !== 1 || entrypoints[0].id !== bundle.entrypoint || !entrypoints[0].parsed) {
    failInvariant(`entrypoint '${bundle.entrypoint}' is not the sole parsed entrypoint source`);
  }

  function assertSpan(span: SourceSpan, label: string): void {
    const source = sources.get(span.sourceId);
    if (!source) failInvariant(`${label} names unknown source '${span.sourceId}'`);
    if (source.lengthUtf16 === undefined || !bundle.rawContents.has(source.id)) {
      failInvariant(`${label} names source '${span.sourceId}' without decoded bounded text`);
    }
    const result = validateSourceSpan(span, source.lengthUtf16);
    if (!result.valid) failInvariant(`${label} has invalid span (${result.code})`);
  }

  function assertExactText(span: SourceSpan, text: string, label: string): void {
    assertSpan(span, label);
    const raw = bundle.rawContents.get(span.sourceId)!;
    if (raw.slice(span.startUtf16, span.endUtf16) !== text) {
      failInvariant(`${label} text does not equal its exact source slice`);
    }
  }

  const eventSeqs = new Map<number, string>();
  function claimEventSeq(seq: number, label: string): void {
    const prior = eventSeqs.get(seq);
    if (prior) failInvariant(`execution seq ${seq} is shared by ${prior} and ${label}`);
    eventSeqs.set(seq, label);
  }

  const entityIds = new Set<string>();
  const entitiesById = new Map<string, CensusEntity>();
  for (const candidate of bundle.entities as unknown[]) {
    validateEntityShape(candidate);
    const entity = candidate;
    assertSpan(entity.span, `entity '${entity.id}'`);
    const expectedId = `ent:${entity.kind}@${entity.span.sourceId}:${entity.span.startUtf16}-${entity.span.endUtf16}`;
    const configuredId = /^ent:(macro-definition|environment-definition)@configured\/[^:]+:.+$/.test(entity.id);
    if (entity.agreementBasis === "configured-declaration") {
      if (!configuredId) failInvariant(`configured entity '${entity.id}' has an invalid declaration id`);
    } else if (entity.id !== expectedId) {
      failInvariant(`entity id '${entity.id}' does not match its physical span`);
    }
    if (entityIds.has(entity.id)) failInvariant(`duplicate entity '${entity.id}'`);
    entityIds.add(entity.id);
    entitiesById.set(entity.id, entity);
    if (entity.witnesses.length === 0) failInvariant(`entity '${entity.id}' has no witnesses`);
    if (entity.agreementBasis === "two-instrument") {
      const witnessKinds = new Set(entity.witnesses.map((witness) => witness.witness));
      if (!witnessKinds.has("lexical") || !witnessKinds.has("parser")) {
        failInvariant(`entity '${entity.id}' claims two-instrument evidence without lexical and parser witnesses`);
      }
    }
    if (entity.agreementBasis === "configured-declaration" &&
        !entity.witnesses.some((witness) => witness.witness === "configured")) {
      failInvariant(`configured entity '${entity.id}' has no configured witness`);
    }
    if (entity.agreementBasis === "configured-declaration" && entity.agreement !== "agreed") {
      failInvariant(`configured entity '${entity.id}' is not agreed`);
    }
    const witnessKinds = new Set(entity.witnesses.map((witness) => witness.witness));
    if (entity.agreement === "parser-only" &&
        (entity.agreementBasis !== "single-authority" || witnessKinds.size !== 1 || !witnessKinds.has("parser"))) {
      failInvariant(`entity '${entity.id}' has inconsistent parser-only evidence`);
    }
    if (entity.agreement === "lexical-only" &&
        (entity.agreementBasis !== "single-authority" || witnessKinds.size !== 1 || !witnessKinds.has("lexical"))) {
      failInvariant(`entity '${entity.id}' has inconsistent lexical-only evidence`);
    }
    if (entity.agreement === "conflict" && entity.agreementBasis !== "two-instrument") {
      failInvariant(`entity '${entity.id}' reports conflict without two-instrument evidence`);
    }
    for (const witness of entity.witnesses) {
      assertSpan(witness.span, `witness on '${entity.id}'`);
      if (witness.span.sourceId !== entity.span.sourceId) {
        failInvariant(`witness on '${entity.id}' crosses source boundaries`);
      }
    }
    for (const child of entityChildSpans(entity)) {
      assertSpan(child, `child span on '${entity.id}'`);
      if (!sourceSpanContains(entity.span, child)) {
        failInvariant(`child span on '${entity.id}' is not contained by the entity`);
      }
    }
  }

  const occurrenceIds = new Set<string>();
  const occurrencesById = new Map<string, SourceOccurrence>();
  for (const candidate of bundle.occurrences as unknown[]) {
    validateOccurrenceShape(candidate);
    const occurrence = candidate;
    if (occurrenceIds.has(occurrence.id)) failInvariant(`duplicate occurrence '${occurrence.id}'`);
    occurrenceIds.add(occurrence.id);
    occurrencesById.set(occurrence.id, occurrence);
    if (!sources.has(occurrence.sourceId)) {
      failInvariant(`occurrence '${occurrence.id}' names unknown source '${occurrence.sourceId}'`);
    }
    if (occurrence.includeChain[0] !== bundle.entrypoint
        || occurrence.includeChain.at(-1) !== occurrence.sourceId) {
      failInvariant(`occurrence '${occurrence.id}' has an inconsistent include chain`);
    }
    claimEventSeq(occurrence.enterSeq, `occurrence '${occurrence.id}' enter`);
    claimEventSeq(occurrence.exitSeq, `occurrence '${occurrence.id}' exit`);
  }
  const roots = bundle.occurrences.filter((occurrence) => occurrence.basis === "manifest-entrypoint");
  if (roots.length !== 1 || roots[0].sourceId !== bundle.entrypoint || roots[0].parentOccurrenceId) {
    failInvariant("occurrences do not have exactly one manifest entrypoint root");
  }
  for (const occurrence of bundle.occurrences) {
    if (occurrence.basis === "manifest-entrypoint") continue;
    const parent = occurrencesById.get(occurrence.parentOccurrenceId!);
    if (!parent) failInvariant(`occurrence '${occurrence.id}' names unknown parent occurrence`);
    const include = entitiesById.get(occurrence.includeEntityId!);
    if (!include || include.kind !== "include") {
      failInvariant(`occurrence '${occurrence.id}' names a non-include carrier`);
    }
    if (include.span.sourceId !== parent.sourceId || include.resolvedSourceId !== occurrence.sourceId) {
      failInvariant(`occurrence '${occurrence.id}' contradicts its include carrier`);
    }
    const expectedChain = [...parent.includeChain, occurrence.sourceId];
    if (expectedChain.length !== occurrence.includeChain.length
        || expectedChain.some((part, index) => part !== occurrence.includeChain[index])) {
      failInvariant(`occurrence '${occurrence.id}' route does not extend its parent`);
    }
    if (!(parent.enterSeq < occurrence.enterSeq && occurrence.exitSeq < parent.exitSeq)) {
      failInvariant(`occurrence '${occurrence.id}' interval is not nested inside its parent`);
    }
    if (occurrence.cycleTargetOccurrenceId) {
      let cursor: SourceOccurrence | undefined = parent;
      let found = false;
      while (cursor) {
        if (cursor.id === occurrence.cycleTargetOccurrenceId && cursor.sourceId === occurrence.sourceId) {
          found = true;
          break;
        }
        cursor = cursor.parentOccurrenceId
          ? occurrencesById.get(cursor.parentOccurrenceId)
          : undefined;
      }
      if (!found) failInvariant(`occurrence '${occurrence.id}' cycle target is not an active ancestor`);
    }
  }

  const bindingIds = new Set<string>();
  const scopesById = new Map<string, ScopeFrame>();
  const summonsById = new Map<string, ConfiguredSummon>();
  const bindingEventsById = new Map<string, BindingEvent>();
  const dispositionsById = new Map<string, DeclarationDisposition>();
  let previousBindingPrimarySeq = -1;
  for (const candidate of bundle.bindings as unknown[]) {
    validateBindingRowShape(candidate);
    const row = candidate;
    if (bindingIds.has(row.id)) failInvariant(`duplicate binding-row id '${row.id}'`);
    bindingIds.add(row.id);
    const primarySeq = row.rowType === "scope-frame" ? row.enterSeq : row.seq;
    if (primarySeq <= previousBindingPrimarySeq) {
      failInvariant(`binding rows are not in strict execution order at '${row.id}'`);
    }
    previousBindingPrimarySeq = primarySeq;
    claimEventSeq(primarySeq, `binding row '${row.id}'`);
    if (row.rowType === "scope-frame") {
      scopesById.set(row.id, row);
      if (row.exitSeq !== undefined) claimEventSeq(row.exitSeq, `scope '${row.id}' exit`);
    } else if (row.rowType === "configured-summon") {
      summonsById.set(row.id, row);
    } else if (row.rowType === "binding-event") {
      bindingEventsById.set(row.id, row);
    } else {
      dispositionsById.set(row.id, row);
    }
  }
  for (const scope of scopesById.values()) {
    if (scope.parentScopeId && !scopesById.has(scope.parentScopeId)) {
      failInvariant(`scope '${scope.id}' names unknown parent '${scope.parentScopeId}'`);
    }
    if (scope.occurrenceId && !occurrenceIds.has(scope.occurrenceId)) {
      failInvariant(`scope '${scope.id}' names unknown occurrence '${scope.occurrenceId}'`);
    }
    if (scope.openSpan) {
      assertExactText(scope.openSpan, scope.openText ?? "", `scope '${scope.id}' open span`);
      const occurrence = scope.occurrenceId ? occurrencesById.get(scope.occurrenceId) : undefined;
      if (occurrence && occurrence.sourceId !== scope.openSpan.sourceId) {
        failInvariant(`scope '${scope.id}' opening crosses occurrence source`);
      }
    }
    if (scope.closeSpan) assertExactText(scope.closeSpan, scope.closeText ?? "", `scope '${scope.id}' close span`);
  }
  const globalScopes = [...scopesById.values()].filter((scope) => scope.kind === "global");
  const documentScopes = [...scopesById.values()].filter((scope) => scope.kind === "document");
  if (globalScopes.length !== 1 || documentScopes.length !== 1) {
    failInvariant("bindings require exactly one global and one document scope");
  }
  for (const summon of summonsById.values()) {
    if (!occurrenceIds.has(summon.occurrenceId) || !scopesById.has(summon.scopeId)) {
      failInvariant(`summon '${summon.id}' has a dangling occurrence/scope join`);
    }
    const carrier = entitiesById.get(summon.physicalEntityId);
    if (!carrier || !["macro-invocation", "envelope-marker"].includes(carrier.kind)) {
      failInvariant(`summon '${summon.id}' names an invalid physical carrier`);
    }
    assertExactText(summon.siteSpan, summon.text, `summon '${summon.id}' site`);
    if (!sourceSpanContains(summon.siteSpan, summon.targetSpan)) {
      failInvariant(`summon '${summon.id}' target escapes its site`);
    }
    assertSpan(summon.targetSpan, `summon '${summon.id}' target`);
    if (summon.optionsSpan) {
      assertSpan(summon.optionsSpan, `summon '${summon.id}' options`);
      if (!sourceSpanContains(summon.siteSpan, summon.optionsSpan)) {
        failInvariant(`summon '${summon.id}' options escape its site`);
      }
      const raw = bundle.rawContents.get(summon.optionsSpan.sourceId)!;
      const optionSlice = raw.slice(summon.optionsSpan.startUtf16, summon.optionsSpan.endUtf16);
      if (summon.optionsText !== undefined && !optionSlice.includes(summon.optionsText)) {
        failInvariant(`summon '${summon.id}' options text contradicts its span`);
      }
    }
    for (const entityId of summon.candidateEntityIds) {
      const candidate = entitiesById.get(entityId);
      if (!candidate || !(
        (candidate.kind === "macro-definition" || candidate.kind === "environment-definition")
        && candidate.configuredPackage === summon.packageName
      )) {
        failInvariant(`summon '${summon.id}' has invalid candidate '${entityId}'`);
      }
    }
  }
  for (const event of bindingEventsById.values()) {
    if (!scopesById.has(event.executionScopeId) || !scopesById.has(event.targetScopeId)) {
      failInvariant(`binding event '${event.id}' has a dangling scope join`);
    }
    if (event.occurrenceId && !occurrenceIds.has(event.occurrenceId)) {
      failInvariant(`binding event '${event.id}' names unknown occurrence`);
    }
    if (event.priorBindingEventId && !bindingEventsById.has(event.priorBindingEventId)) {
      failInvariant(`binding event '${event.id}' names unknown prior binding`);
    }
    if (event.restoredBindingEventId && !bindingEventsById.has(event.restoredBindingEventId)) {
      failInvariant(`binding event '${event.id}' names unknown restored binding`);
    }
    if (event.cause.kind === "physical-declaration") {
      const entity = entitiesById.get(event.cause.entityId);
      if (!entity || !["macro-definition", "environment-definition"].includes(entity.kind)
          || !sameSpan(entity.span, event.cause.siteSpan)) {
        failInvariant(`binding event '${event.id}' has invalid physical declaration cause`);
      }
      const declaration = entity as Extract<CensusEntity, {
        kind: "macro-definition" | "environment-definition";
      }>;
      assertEventSymbolMatchesEntity(event, declaration, `binding event '${event.id}'`);
      if (event.operation !== expectedDeclarationOperation(declaration)) {
        failInvariant(`binding event '${event.id}' operation contradicts its declaration command`);
      }
      if (!event.occurrenceId) failInvariant(`binding event '${event.id}' physical cause has no occurrence`);
      if (event.text !== undefined) assertExactText(event.cause.siteSpan, event.text, `binding event '${event.id}'`);
      if (event.installedMeaning?.kind === "declaration") {
        if (event.installedMeaning.entityId !== declaration.id
            || !isDeepStrictEqual(event.installedMeaning.signature, declaration.signature)) {
          failInvariant(`binding event '${event.id}' declaration meaning contradicts its cause entity`);
        }
      } else if (event.installedMeaning?.kind === "opaque" && event.installedMeaning.entityId !== undefined) {
        if (event.installedMeaning.entityId !== declaration.id
            || (event.operation !== "let-capture"
              && !isDeepStrictEqual(event.installedMeaning.signature, declaration.signature))) {
          failInvariant(`binding event '${event.id}' opaque meaning contradicts its cause entity`);
        }
      }
    } else if (event.cause.kind === "configured") {
      const summon = summonsById.get(event.cause.summonId);
      const candidate = entitiesById.get(event.cause.entityId);
      if (!summon || !summon.candidateEntityIds.includes(event.cause.entityId)
          || !candidate || !(candidate.kind === "macro-definition" || candidate.kind === "environment-definition")) {
        failInvariant(`binding event '${event.id}' has invalid configured cause`);
      }
      assertEventSymbolMatchesEntity(event, candidate, `binding event '${event.id}'`);
      if (event.text !== summon.text) failInvariant(`binding event '${event.id}' text differs from its summon`);
      if (event.installedMeaning?.kind === "declaration"
          && (event.installedMeaning.entityId !== candidate.id
            || !isDeepStrictEqual(event.installedMeaning.signature, candidate.signature))) {
        failInvariant(`binding event '${event.id}' configured meaning contradicts its candidate entity`);
      }
    } else if (event.cause.kind === "baseline") {
      if (event.installedMeaning?.kind !== "primitive"
          || event.installedMeaning.name !== event.symbol.name) {
        failInvariant(`binding event '${event.id}' baseline meaning contradicts its symbol`);
      }
    } else if (event.cause.kind === "scope-exit") {
      const exitedScope = scopesById.get(event.cause.scopeId);
      if (!exitedScope) failInvariant(`binding event '${event.id}' has unknown exit scope`);
      if (event.executionScopeId !== exitedScope.id || event.targetScopeId !== exitedScope.parentScopeId) {
        failInvariant(`binding event '${event.id}' restore scopes contradict its exit cause`);
      }
    }
    const meaning = event.installedMeaning;
    if (meaning?.kind === "declaration") {
      if (!entitiesById.has(meaning.entityId)) failInvariant(`binding event '${event.id}' meaning has unknown entity`);
    } else if (meaning?.kind === "captured") {
      const captured = bindingEventsById.get(meaning.sourceBindingEventId);
      if (!captured || captured.seq >= event.seq) failInvariant(`binding event '${event.id}' has invalid captured meaning`);
    } else if (meaning?.kind === "opaque" && meaning.entityId && !entitiesById.has(meaning.entityId)) {
      failInvariant(`binding event '${event.id}' opaque meaning has unknown entity`);
    }
    if (event.operation === "restore") {
      const restored = event.restoredBindingEventId
        ? bindingEventsById.get(event.restoredBindingEventId)
        : undefined;
      if (event.restoredBindingEventId && (
        !restored
        || restored.seq >= event.seq
        || !sameBindingSymbol(event, restored)
        || restored.installedMeaning === undefined
      )) {
        failInvariant(`binding event '${event.id}' has invalid restored binding correlation`);
      }
      if ((restored === undefined) !== (event.installedMeaning === undefined)
          || (restored && !isDeepStrictEqual(event.installedMeaning, restored.installedMeaning))) {
        failInvariant(`binding event '${event.id}' restore meaning contradicts restored binding`);
      }
    }
  }
  for (const disposition of dispositionsById.values()) {
    if (!occurrenceIds.has(disposition.occurrenceId)) {
      failInvariant(`disposition '${disposition.id}' names unknown occurrence`);
    }
    const entity = entitiesById.get(disposition.entityId);
    if (!entity || !["macro-definition", "environment-definition"].includes(entity.kind)) {
      failInvariant(`disposition '${disposition.id}' names an invalid declaration`);
    }
    assertExactText(entity.span, disposition.text, `disposition '${disposition.id}'`);
  }

  function primitiveNameForBindingEvent(bindingEventId: string): string | undefined {
    let meaning = bindingEventsById.get(bindingEventId)?.installedMeaning;
    const seen = new Set<string>();
    while (meaning?.kind === "captured") {
      if (seen.has(meaning.sourceBindingEventId)) return undefined;
      seen.add(meaning.sourceBindingEventId);
      meaning = bindingEventsById.get(meaning.sourceBindingEventId)?.installedMeaning;
    }
    return meaning?.kind === "primitive" ? meaning.name : undefined;
  }

  const invocationIds = new Set<string>();
  const invocationsById = new Map<string, InvocationOccurrence>();
  let previousInvocationSeq = -1;
  for (const candidate of bundle.invocations as unknown[]) {
    validateInvocationShape(candidate);
    const invocation = candidate;
    if (invocationIds.has(invocation.id)) failInvariant(`duplicate invocation '${invocation.id}'`);
    invocationIds.add(invocation.id);
    invocationsById.set(invocation.id, invocation);
    if (invocation.seq <= previousInvocationSeq) failInvariant(`invocations are not in strict execution order at '${invocation.id}'`);
    previousInvocationSeq = invocation.seq;
    claimEventSeq(invocation.seq, `invocation '${invocation.id}'`);
    const occurrence = occurrencesById.get(invocation.occurrenceId);
    const entity = entitiesById.get(invocation.entityId);
    if (!occurrence || !entity || occurrence.state !== "entered") {
      failInvariant(`invocation '${invocation.id}' has a dangling or non-entered carrier occurrence`);
    }
    if (occurrence.sourceId !== invocation.siteSpan.sourceId || entity.span.sourceId !== invocation.siteSpan.sourceId) {
      failInvariant(`invocation '${invocation.id}' crosses its occurrence/entity source`);
    }
    assertSpan(invocation.siteSpan, `invocation '${invocation.id}' site`);
    const raw = bundle.rawContents.get(invocation.siteSpan.sourceId)!;
    const carrier = expectedInvocationCarrier(entity, raw, `invocation '${invocation.id}'`);
    if (invocation.name !== carrier.name
        || invocation.siteKind !== carrier.siteKind
        || !sameSpan(invocation.siteSpan, carrier.siteSpan)) {
      failInvariant(`invocation '${invocation.id}' contradicts its exact physical carrier`);
    }
    assertExactText(invocation.span, invocation.text, `invocation '${invocation.id}' hull`);
    if (!sourceSpanContains(invocation.span, invocation.siteSpan)) {
      failInvariant(`invocation '${invocation.id}' hull does not contain its site`);
    }
    const canonicalWitness = entity.witnesses.some((witness) =>
      (witness.spanRole === "token" || witness.spanRole === "begin-fence")
      && sameSpan(witness.span, invocation.siteSpan)
    );
    if (!canonicalWitness) failInvariant(`invocation '${invocation.id}' site has no canonical entity witness`);
    for (const argument of invocation.arguments) {
      if (argument.span) {
        assertSpan(argument.span, `argument on invocation '${invocation.id}'`);
        if (!sourceSpanContains(invocation.span, argument.span)) {
          failInvariant(`argument on invocation '${invocation.id}' escapes its hull`);
        }
      }
      if (argument.contentSpan) {
        assertSpan(argument.contentSpan, `argument content on invocation '${invocation.id}'`);
        if (!argument.span || !sourceSpanContains(argument.span, argument.contentSpan)) {
          failInvariant(`argument content on invocation '${invocation.id}' escapes its argument`);
        }
      }
    }
    if (invocation.binding.state === "bound") {
      const event = bindingEventsById.get(invocation.binding.bindingEventId);
      if (!event || event.seq >= invocation.seq || !event.installedMeaning) {
        failInvariant(`invocation '${invocation.id}' has an invalid governing binding`);
      }
      if (!isDeepStrictEqual(event.installedMeaning.signature, invocation.binding.signature)) {
        failInvariant(`invocation '${invocation.id}' signature differs from its governing binding`);
      }
    }
  }

  const currentBindings = new Map<string, BindingEvent>();
  const executionTimeline: ({ kind: "binding"; row: BindingEvent } | {
    kind: "invocation";
    row: InvocationOccurrence;
  })[] = [
    ...[...bindingEventsById.values()].map((row) => ({ kind: "binding" as const, row })),
    ...[...invocationsById.values()].map((row) => ({ kind: "invocation" as const, row })),
  ].sort((left, right) => left.row.seq - right.row.seq);

  for (const item of executionTimeline) {
    if (item.kind === "binding") {
      const event = item.row;
      const key = bindingSymbolKey(event);
      const prior = currentBindings.get(key);
      if (event.priorBindingEventId !== prior?.id) {
        failInvariant(`binding event '${event.id}' prior binding contradicts chronological state`);
      }
      if (event.operation === "restore") {
        const restored = event.restoredBindingEventId
          ? bindingEventsById.get(event.restoredBindingEventId)
          : undefined;
        if (restored) currentBindings.set(key, restored);
        else currentBindings.delete(key);
      } else if (event.effect === "installed" || event.effect === "indeterminate") {
        if (!event.installedMeaning
            || (event.effect === "indeterminate") !== (event.installedMeaning.kind === "indeterminate")) {
          failInvariant(`binding event '${event.id}' effect contradicts its installed meaning`);
        }
        currentBindings.set(key, event);
      }
      continue;
    }

    const invocation = item.row;
    const namespace = invocation.siteKind === "environment-begin" ? "environment" : "control-sequence";
    const key = `${namespace}\0${invocation.name}`;
    const current = currentBindings.get(key);
    const raw = bundle.rawContents.get(invocation.siteSpan.sourceId)!;
    const tokenOnly = sameSpan(invocation.span, invocation.siteSpan)
      && invocation.arguments.length === 0
      && invocation.text === raw.slice(invocation.siteSpan.startUtf16, invocation.siteSpan.endUtf16);

    if (invocation.binding.state === "bound") {
      if (!current || current.id !== invocation.binding.bindingEventId
          || !current.installedMeaning || current.installedMeaning.kind === "indeterminate") {
        failInvariant(`invocation '${invocation.id}' does not name its current governing binding`);
      }
      if (!isDeepStrictEqual(current.installedMeaning.signature, invocation.binding.signature)) {
        failInvariant(`invocation '${invocation.id}' signature contradicts chronological binding state`);
      }
      const entity = entitiesById.get(invocation.entityId)!;
      const replayed = replayInvocationAttachment(
        entity,
        raw,
        invocation.siteSpan,
        invocation.binding.signature,
        physicalControlSequenceSpans(bundle.entities, invocation.siteSpan.sourceId),
        primitiveNameForBindingEvent(invocation.binding.bindingEventId)
      );
      if (replayed.status !== invocation.status
          || !sameSpan(replayed.span, invocation.span)
          || !isDeepStrictEqual(replayed.arguments, invocation.arguments)
          || invocation.text !== raw.slice(replayed.span.startUtf16, replayed.span.endUtf16)) {
        failInvariant(`invocation '${invocation.id}' attachment contradicts exact source and signature`);
      }
    } else {
      if (!tokenOnly) {
        failInvariant(`invocation '${invocation.id}' non-bound state is not token-only`);
      }
      if (invocation.binding.state === "unbound" && current !== undefined) {
        failInvariant(`invocation '${invocation.id}' reports unbound despite a current binding`);
      }
      if (invocation.binding.state === "indeterminate") {
        const meaning = current?.installedMeaning;
        if (!meaning || meaning.kind !== "indeterminate"
            || !isDeepStrictEqual(invocation.binding.causeIds, meaning.causeIds)
            || invocation.binding.detail !== meaning.reason) {
          failInvariant(`invocation '${invocation.id}' indeterminate evidence contradicts current binding state`);
        }
      }
    }
  }

  if (eventSeqs.size > 0) {
    const maxSeq = Math.max(...eventSeqs.keys());
    if (eventSeqs.size !== maxSeq + 1) {
      failInvariant(`execution event sequence is not contiguous from 0 through ${maxSeq}`);
    }
  }

  for (const claim of bundle.claims) {
    assertSpan(claim.span, `claim '${claim.role}'`);
    if (claim.entityId && !entityIds.has(claim.entityId)) {
      failInvariant(`claim '${claim.role}' names unknown entity '${claim.entityId}'`);
    }
  }

  const coverageBySource = new Map<SourceId, SourceCoverage>();
  for (const coverage of bundle.coverage) {
    const source = sources.get(coverage.sourceId);
    if (!source) failInvariant(`coverage names unknown source '${coverage.sourceId}'`);
    if (coverageBySource.has(coverage.sourceId)) {
      failInvariant(`duplicate coverage for '${coverage.sourceId}'`);
    }
    if (!source.parsed) failInvariant(`unparsed source '${coverage.sourceId}' has coverage`);
    if (coverage.lengthUtf16 !== source.lengthUtf16) {
      failInvariant(`coverage length for '${coverage.sourceId}' differs from its source record`);
    }
    if (coverage.claimedUtf16 + coverage.residueUtf16 !== coverage.lengthUtf16) {
      failInvariant(`coverage totals for '${coverage.sourceId}' do not partition the source`);
    }
    let residueUtf16 = 0;
    let priorResidueEnd = -1;
    for (const span of coverage.residue) {
      assertSpan(span, `coverage residue for '${coverage.sourceId}'`);
      if (span.sourceId !== coverage.sourceId) {
        failInvariant(`coverage residue for '${coverage.sourceId}' crosses source boundaries`);
      }
      if (span.startUtf16 < priorResidueEnd) {
        failInvariant(`coverage residue for '${coverage.sourceId}' overlaps or is out of order`);
      }
      residueUtf16 += span.endUtf16 - span.startUtf16;
      priorResidueEnd = span.endUtf16;
    }
    if (residueUtf16 !== coverage.residueUtf16) {
      failInvariant(`coverage residue total for '${coverage.sourceId}' is inconsistent`);
    }
    coverageBySource.set(coverage.sourceId, coverage);
  }
  for (const source of bundle.sources) {
    if (source.parsed !== coverageBySource.has(source.id)) {
      failInvariant(`parsed/coverage bijection failed for '${source.id}'`);
    }
  }

  const diagnosticsByEntity = new Map<string, Diagnostic[]>();
  const diagnosticsByOccurrence = new Map<string, Diagnostic[]>();
  const diagnosticsByBinding = new Map<string, Diagnostic[]>();
  const diagnosticsByInvocation = new Map<string, Diagnostic[]>();
  for (const candidate of bundle.diagnostics as unknown[]) {
    validateDiagnosticShape(candidate);
    const diagnostic = candidate;
    if (diagnostic.span) assertSpan(diagnostic.span, `diagnostic '${diagnostic.code}'`);
    if (diagnostic.span && diagnostic.sourceId && diagnostic.span.sourceId !== diagnostic.sourceId) {
      failInvariant(`diagnostic '${diagnostic.code}' has inconsistent source identity`);
    }
    if (diagnostic.sourceId && !sources.has(diagnostic.sourceId)) {
      failInvariant(`diagnostic '${diagnostic.code}' names unknown source '${diagnostic.sourceId}'`);
    }
    if (diagnostic.entityId && !entityIds.has(diagnostic.entityId)) {
      failInvariant(`diagnostic '${diagnostic.code}' names unknown entity '${diagnostic.entityId}'`);
    }
    if (diagnostic.entityId) {
      const linked = diagnosticsByEntity.get(diagnostic.entityId) || [];
      linked.push(diagnostic);
      diagnosticsByEntity.set(diagnostic.entityId, linked);
    }
    if (diagnostic.occurrenceId) {
      if (!occurrenceIds.has(diagnostic.occurrenceId)) {
        failInvariant(`diagnostic '${diagnostic.code}' names unknown occurrence '${diagnostic.occurrenceId}'`);
      }
      const linked = diagnosticsByOccurrence.get(diagnostic.occurrenceId) || [];
      linked.push(diagnostic);
      diagnosticsByOccurrence.set(diagnostic.occurrenceId, linked);
    }
    if (diagnostic.bindingId) {
      if (!bindingEventsById.has(diagnostic.bindingId)) {
        failInvariant(`diagnostic '${diagnostic.code}' names unknown binding '${diagnostic.bindingId}'`);
      }
      const linked = diagnosticsByBinding.get(diagnostic.bindingId) || [];
      linked.push(diagnostic);
      diagnosticsByBinding.set(diagnostic.bindingId, linked);
    }
    if (diagnostic.invocationId) {
      if (!invocationIds.has(diagnostic.invocationId)) {
        failInvariant(`diagnostic '${diagnostic.code}' names unknown invocation '${diagnostic.invocationId}'`);
      }
      const linked = diagnosticsByInvocation.get(diagnostic.invocationId) || [];
      linked.push(diagnostic);
      diagnosticsByInvocation.set(diagnostic.invocationId, linked);
    }
  }

  for (const entity of bundle.entities) {
    const linkedDiagnostics = diagnosticsByEntity.get(entity.id) || [];
    if (entity.agreement !== "agreed" && linkedDiagnostics.length === 0) {
      failInvariant(`non-agreed entity '${entity.id}' has no entity-linked diagnostic`);
    }
    if (entity.agreement === "agreed" && entity.agreementBasis === "two-instrument") {
      const comparison = compareCensusEntityWitnesses(entity);
      const arbitrated = linkedDiagnostics.some(
        (diagnostic) => diagnostic.code === DiagnosticCodes.CatcodeArbitrated
      );
      if (!comparison.equivalent && !arbitrated) {
        failInvariant(`entity '${entity.id}' claims agreement from non-equivalent witnesses (${comparison.reason})`);
      }
    }
  }
  for (const occurrence of bundle.occurrences) {
    if (occurrence.state !== "entered" && !(diagnosticsByOccurrence.get(occurrence.id)?.length)) {
      failInvariant(`cut/deferred occurrence '${occurrence.id}' has no linked diagnostic`);
    }
  }
  for (const event of bindingEventsById.values()) {
    if (["invalid-precondition", "indeterminate"].includes(event.effect)
        && !(diagnosticsByBinding.get(event.id)?.length)) {
      failInvariant(`degraded binding event '${event.id}' has no linked diagnostic`);
    }
  }
  for (const invocation of bundle.invocations) {
    if (["deferred", "indeterminate", "malformed"].includes(invocation.status)
        && !(diagnosticsByInvocation.get(invocation.id)?.length)) {
      failInvariant(`degraded invocation '${invocation.id}' has no linked diagnostic`);
    }
  }
}

function writeBundle(bundle: EmitBundle, resolvedOutDir: string): CensusSummary {

  // 1. sources.jsonl
  const sourcesPath = path.join(resolvedOutDir, "sources.jsonl");
  const sourcesContent = bundle.sources.map(s => JSON.stringify(s)).join("\n") + (bundle.sources.length > 0 ? "\n" : "");
  fs.writeFileSync(sourcesPath, sourcesContent, { encoding: "utf-8" });

  // 2. entities.jsonl (with inline raw slice)
  const entitiesPath = path.join(resolvedOutDir, "entities.jsonl");
  const entityRows = bundle.entities.map(ent => {
    const raw = bundle.rawContents.get(ent.span.sourceId);
    let textSlice = "";
    if (raw) {
      textSlice = raw.slice(ent.span.startUtf16, ent.span.endUtf16);
    }
    return JSON.stringify({
      ...ent,
      text: textSlice,
    });
  });
  const entitiesContent = entityRows.join("\n") + (entityRows.length > 0 ? "\n" : "");
  fs.writeFileSync(entitiesPath, entitiesContent, { encoding: "utf-8" });

  // 3. occurrences.jsonl
  const occurrencesPath = path.join(resolvedOutDir, "occurrences.jsonl");
  const occurrencesContent = bundle.occurrences.map(row => JSON.stringify(row)).join("\n")
    + (bundle.occurrences.length > 0 ? "\n" : "");
  fs.writeFileSync(occurrencesPath, occurrencesContent, { encoding: "utf-8" });

  // 4. bindings.jsonl
  const bindingsPath = path.join(resolvedOutDir, "bindings.jsonl");
  const bindingsContent = bundle.bindings.map(row => JSON.stringify(row)).join("\n")
    + (bundle.bindings.length > 0 ? "\n" : "");
  fs.writeFileSync(bindingsPath, bindingsContent, { encoding: "utf-8" });

  // 5. invocations.jsonl
  const invocationsPath = path.join(resolvedOutDir, "invocations.jsonl");
  const invocationsContent = bundle.invocations.map(row => JSON.stringify(row)).join("\n")
    + (bundle.invocations.length > 0 ? "\n" : "");
  fs.writeFileSync(invocationsPath, invocationsContent, { encoding: "utf-8" });

  // 6. claims.jsonl
  const claimsPath = path.join(resolvedOutDir, "claims.jsonl");
  const claimsContent = bundle.claims.map(c => JSON.stringify(c)).join("\n") + (bundle.claims.length > 0 ? "\n" : "");
  fs.writeFileSync(claimsPath, claimsContent, { encoding: "utf-8" });

  // 7. coverage.json
  const coveragePath = path.join(resolvedOutDir, "coverage.json");
  fs.writeFileSync(coveragePath, JSON.stringify(bundle.coverage, null, 2) + "\n", { encoding: "utf-8" });

  // 8. diagnostics.jsonl
  const diagnosticsPath = path.join(resolvedOutDir, "diagnostics.jsonl");
  const diagContent = bundle.diagnostics.map(d => JSON.stringify(d)).join("\n") + (bundle.diagnostics.length > 0 ? "\n" : "");
  fs.writeFileSync(diagnosticsPath, diagContent, { encoding: "utf-8" });

  // 9. summary.json
  let totalUtf16 = 0;
  let claimedUtf16 = 0;
  let residueUtf16 = 0;
  let residueSegments = 0;

  for (const cov of bundle.coverage) {
    totalUtf16 += cov.lengthUtf16;
    claimedUtf16 += cov.claimedUtf16;
    residueUtf16 += cov.residueUtf16;
    residueSegments += cov.residue.length;
  }

  const entityCounts: Record<string, number> = {};
  for (const ent of bundle.entities) {
    entityCounts[ent.kind] = (entityCounts[ent.kind] || 0) + 1;
  }

  const agreementCounts: Record<string, number> = {};
  for (const ent of bundle.entities) {
    agreementCounts[ent.agreement] = (agreementCounts[ent.agreement] || 0) + 1;
  }

  const diagnosticCounts: Record<string, number> = {};
  for (const d of bundle.diagnostics) {
    diagnosticCounts[d.severity] = (diagnosticCounts[d.severity] || 0) + 1;
  }

  const summary: CensusSummary = {
    schema: CENSUS_SCHEMA_VERSION,
    slug: bundle.slug,
    treeSha256: bundle.treeSha256,
    entrypoint: bundle.entrypoint,
    stores: {
      emitted: [
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
      // Runtime-derived 0.1 stores are deliberately withdrawn until occurrence-
      // aware binding and attachment can emit honest 0.2 replacements.
      deferred: [...CENSUS_DEFERRED_STORES],
    },
    storeSchemas: { ...CENSUS_STORE_SCHEMAS },
    runtime: { node: bundle.runtimeNode },
    sourceCount: bundle.sources.length,
    occurrenceCount: bundle.occurrences.length,
    bindingRowCount: bundle.bindings.length,
    invocationCount: bundle.invocations.length,
    entityCounts,
    agreementCounts,
    diagnosticCounts,
    coverage: {
      totalUtf16,
      claimedUtf16,
      residueUtf16,
      residueSegments,
    },
  };

  const summaryPath = path.join(resolvedOutDir, "summary.json");
  fs.writeFileSync(summaryPath, JSON.stringify(summary, null, 2) + "\n", { encoding: "utf-8" });

  return summary;
}
