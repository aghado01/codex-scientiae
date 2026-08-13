/**
 * TeXdig store emitter.
 *
 * Emits the Evidence Tier (sources.jsonl, entities.jsonl, claims.jsonl) and
 * Audit Tier (coverage.json, diagnostics.jsonl, summary.json) per the landed contract.
 * Slices are extracted directly from raw UTF-16 source strings (never printRaw).
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import type {
  SourceFileRecord,
  CensusEntity,
  PillarClaim,
  SourceCoverage,
  Diagnostic,
  CensusSummary,
  SourceId,
  SourceSpan,
} from "../core/types.ts";
import {
  CENSUS_SCHEMA_VERSION,
  CENSUS_DEFERRED_STORES,
  CENSUS_STORE_SCHEMAS,
  DiagnosticCodes,
} from "../core/types.ts";
import { sourceSpanContains, validateSourceSpan } from "../core/spans.ts";
import { computeSourceTreeSha256 } from "./source-fingerprint.ts";
import { compareCensusEntityWitnesses } from "./witness-equivalence.ts";

export interface EmitBundle {
  slug: string;
  treeSha256: string;
  entrypoint: SourceId;
  sources: SourceFileRecord[];
  entities: CensusEntity[];
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
  throw new Error(`TeXdig 0.2 emission invariant failed: ${message}`);
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
      requireEnum(value, "dialect", DEFINITION_DIALECTS, label);
      requireBoolean(value, "elaborable", label);
      requireEnum(value, "context", DECLARATION_CONTEXTS, label);
      requireEnum(value, "activation", DECLARATION_ACTIVATIONS, label);
      optionalString(value, "signatureRaw", label);
      optionalString(value, "argumentSpec", label);
      optionalSpan(value, "bodySpan", label);
      optionalString(value, "definedWithin", label);
      kindFields = [
        "definedName", "dialect", "signatureRaw", "argumentSpec", "bodySpan",
        "elaborable", "context", "activation", "definedWithin",
      ];
      break;
    case "environment-definition":
      requireString(value, "definedName", label);
      requireEnum(value, "mechanism", ENVIRONMENT_MECHANISMS, label);
      requireEnum(value, "context", DECLARATION_CONTEXTS, label);
      requireEnum(value, "activation", DECLARATION_ACTIVATIONS, label);
      optionalString(value, "signatureRaw", label);
      optionalString(value, "argumentSpec", label);
      optionalString(value, "counterRaw", label);
      optionalSpan(value, "beginBodySpan", label);
      optionalSpan(value, "endBodySpan", label);
      optionalString(value, "definedWithin", label);
      kindFields = [
        "definedName", "mechanism", "signatureRaw", "argumentSpec", "counterRaw",
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

  const entityIds = new Set<string>();
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

  const diagnosticCodes = new Set<string>(Object.values(DiagnosticCodes));
  const diagnosticsByEntity = new Map<string, Diagnostic[]>();
  for (const diagnostic of bundle.diagnostics) {
    if (!diagnosticCodes.has(diagnostic.code)) {
      failInvariant(`diagnostic uses unregistered code '${diagnostic.code}'`);
    }
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

  // 3. claims.jsonl
  const claimsPath = path.join(resolvedOutDir, "claims.jsonl");
  const claimsContent = bundle.claims.map(c => JSON.stringify(c)).join("\n") + (bundle.claims.length > 0 ? "\n" : "");
  fs.writeFileSync(claimsPath, claimsContent, { encoding: "utf-8" });

  // 4. coverage.json
  const coveragePath = path.join(resolvedOutDir, "coverage.json");
  fs.writeFileSync(coveragePath, JSON.stringify(bundle.coverage, null, 2) + "\n", { encoding: "utf-8" });

  // 5. diagnostics.jsonl
  const diagnosticsPath = path.join(resolvedOutDir, "diagnostics.jsonl");
  const diagContent = bundle.diagnostics.map(d => JSON.stringify(d)).join("\n") + (bundle.diagnostics.length > 0 ? "\n" : "");
  fs.writeFileSync(diagnosticsPath, diagContent, { encoding: "utf-8" });

  // 6. summary.json
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
