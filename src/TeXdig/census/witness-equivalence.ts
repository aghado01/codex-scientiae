/**
 * Kind-specific witness-equivalence policies for census fusion.
 *
 * A shared start offset is an index candidate, not proof of agreement. These
 * policies validate source, role, extent, and the semantic identity required
 * by each carrier kind before two instruments may be reported as agreed.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  CensusEntity,
  CensusKind,
  MathCarrier,
  WitnessRecord,
  WitnessSpanRole,
} from "../core/types.ts";
import {
  isValidSourceSpan,
  sourceSpanContains,
  sourceSpansEqual,
} from "../core/spans.ts";

export type WitnessEquivalencePolicy =
  | "control-sequence-token"
  | "definition-anchor"
  | "include-command-token"
  | "begin-fence-anchor"
  | "end-fence-anchor"
  | "environment-fences"
  | "math-carrier"
  | "bib-construct"
  | "bib-field-value"
  | "authority-only"
  | "entity-specific";

export interface WitnessSemantics {
  /** Control-sequence, environment, field, or declaration name. */
  name?: string;
  /** Dialect, directive, Bib construct type, or another policy-owned tag. */
  construct?: string;
  mode?: "inline" | "display";
  carrier?: MathCarrier;
}

export interface WitnessObservation extends WitnessRecord {
  semantics?: WitnessSemantics;
}

export type WitnessEquivalenceReason =
  | "equivalent"
  | "invalid-left-span"
  | "invalid-right-span"
  | "source-mismatch"
  | "role-mismatch"
  | "start-mismatch"
  | "end-mismatch"
  | "extent-mismatch"
  | "name-mismatch"
  | "construct-mismatch"
  | "mode-mismatch"
  | "carrier-mismatch"
  | "missing-semantic-detail"
  | "missing-independent-witness"
  | "single-authority-policy";

export interface WitnessEquivalenceResult {
  equivalent: boolean;
  reason: WitnessEquivalenceReason;
}

const EQUIVALENT: WitnessEquivalenceResult = {
  equivalent: true,
  reason: "equivalent",
};

function conflict(reason: Exclude<WitnessEquivalenceReason, "equivalent">): WitnessEquivalenceResult {
  return { equivalent: false, reason };
}

function carrierKey(carrier: MathCarrier): string {
  return carrier.form === "env" ? `env:${carrier.name}` : carrier.form;
}

function validatePair(
  left: WitnessObservation,
  right: WitnessObservation
): WitnessEquivalenceResult | undefined {
  if (!isValidSourceSpan(left.span)) return conflict("invalid-left-span");
  if (!isValidSourceSpan(right.span)) return conflict("invalid-right-span");
  if (left.span.sourceId !== right.span.sourceId) return conflict("source-mismatch");
  return undefined;
}

function requireRoles(
  left: WitnessObservation,
  right: WitnessObservation,
  role: WitnessSpanRole
): WitnessEquivalenceResult | undefined {
  if (left.spanRole !== role || right.spanRole !== role) return conflict("role-mismatch");
  return undefined;
}

function requireExactExtent(
  left: WitnessObservation,
  right: WitnessObservation
): WitnessEquivalenceResult | undefined {
  if (left.span.startUtf16 !== right.span.startUtf16) return conflict("start-mismatch");
  if (left.span.endUtf16 !== right.span.endUtf16) return conflict("end-mismatch");
  return undefined;
}

function requireName(
  left: WitnessObservation,
  right: WitnessObservation
): WitnessEquivalenceResult | undefined {
  if (left.semantics?.name === undefined || right.semantics?.name === undefined) {
    return conflict("missing-semantic-detail");
  }
  if (left.semantics.name !== right.semantics.name) return conflict("name-mismatch");
  return undefined;
}

function requireConstructWhenPresent(
  left: WitnessObservation,
  right: WitnessObservation
): WitnessEquivalenceResult | undefined {
  const leftConstruct = left.semantics?.construct;
  const rightConstruct = right.semantics?.construct;
  if (leftConstruct !== undefined && rightConstruct !== undefined && leftConstruct !== rightConstruct) {
    return conflict("construct-mismatch");
  }
  return undefined;
}

/** Compare two observations under one explicit carrier policy. */
export function compareWitnesses(
  policy: Exclude<WitnessEquivalencePolicy, "environment-fences">,
  left: WitnessObservation,
  right: WitnessObservation
): WitnessEquivalenceResult {
  const invalid = validatePair(left, right);
  if (invalid) return invalid;

  if (policy === "authority-only" || policy === "entity-specific") {
    return conflict("single-authority-policy");
  }

  if (policy === "definition-anchor") {
    const roles = new Set<WitnessSpanRole>([left.spanRole, right.spanRole]);
    if (!(roles.has("token") && roles.has("construct")) && roles.size !== 1) {
      return conflict("role-mismatch");
    }
    if (left.span.startUtf16 !== right.span.startUtf16) return conflict("start-mismatch");
    const named = left.semantics?.name !== undefined || right.semantics?.name !== undefined
      ? requireName(left, right)
      : undefined;
    if (named) return named;
    if (left.spanRole === right.spanRole) {
      const extent = requireExactExtent(left, right);
      if (extent) return extent;
    } else {
      const construct = left.spanRole === "construct" ? left : right;
      const token = left.spanRole === "token" ? left : right;
      if (!sourceSpanContains(construct.span, token.span)) return conflict("extent-mismatch");
    }
    const construct = requireConstructWhenPresent(left, right);
    return construct || EQUIVALENT;
  }

  if (policy === "begin-fence-anchor" || policy === "end-fence-anchor") {
    const expectedFence = policy === "begin-fence-anchor" ? "begin-fence" : "end-fence";
    const construct = left.spanRole === "construct" ? left : right.spanRole === "construct" ? right : undefined;
    const fence = left.spanRole === expectedFence ? left : right.spanRole === expectedFence ? right : undefined;
    if (!construct || !fence) return conflict("role-mismatch");
    if (!sourceSpanContains(construct.span, fence.span)) return conflict("extent-mismatch");
    if (
      policy === "begin-fence-anchor" &&
      construct.span.startUtf16 !== fence.span.startUtf16
    ) {
      return conflict("start-mismatch");
    }
    if (
      policy === "end-fence-anchor" &&
      construct.span.endUtf16 !== fence.span.endUtf16
    ) {
      return conflict("end-mismatch");
    }
    const name = requireName(left, right);
    return name || EQUIVALENT;
  }

  const requiredRole: WitnessSpanRole =
    policy === "bib-field-value" ? "value" : policy === "control-sequence-token" || policy === "include-command-token" ? "token" : "construct";
  const role = requireRoles(left, right, requiredRole);
  if (role) return role;
  const extent = requireExactExtent(left, right);
  if (extent) return extent;

  if (policy === "control-sequence-token" || policy === "include-command-token") {
    const name = requireName(left, right);
    if (name) return name;
    const construct = requireConstructWhenPresent(left, right);
    return construct || EQUIVALENT;
  }

  if (policy === "math-carrier") {
    if (!left.semantics?.mode || !right.semantics?.mode || !left.semantics.carrier || !right.semantics.carrier) {
      return conflict("missing-semantic-detail");
    }
    if (left.semantics.mode !== right.semantics.mode) return conflict("mode-mismatch");
    if (carrierKey(left.semantics.carrier) !== carrierKey(right.semantics.carrier)) {
      return conflict("carrier-mismatch");
    }
    return EQUIVALENT;
  }

  if (policy === "bib-construct") {
    if (!left.semantics?.construct || !right.semantics?.construct) {
      return conflict("missing-semantic-detail");
    }
    if (left.semantics.construct !== right.semantics.construct) {
      return conflict("construct-mismatch");
    }
    return EQUIVALENT;
  }

  const name = requireName(left, right);
  return name || EQUIVALENT;
}

/**
 * Compare one parser environment construct with independently scanned begin
 * and end fences. Both boundary equalities are required.
 */
export function compareEnvironmentWitnesses(
  parser: WitnessObservation,
  begin: WitnessObservation,
  end: WitnessObservation
): WitnessEquivalenceResult {
  if (parser.spanRole !== "construct" || begin.spanRole !== "begin-fence" || end.spanRole !== "end-fence") {
    return conflict("role-mismatch");
  }
  const first = validatePair(parser, begin);
  if (first) return first;
  const second = validatePair(parser, end);
  if (second) return second;
  if (parser.span.startUtf16 !== begin.span.startUtf16) return conflict("start-mismatch");
  if (parser.span.endUtf16 !== end.span.endUtf16) return conflict("end-mismatch");
  if (!sourceSpanContains(parser.span, begin.span) || !sourceSpanContains(parser.span, end.span)) {
    return conflict("extent-mismatch");
  }
  const parserName = parser.semantics?.name;
  if (parserName === undefined || begin.semantics?.name === undefined || end.semantics?.name === undefined) {
    return conflict("missing-semantic-detail");
  }
  if (parserName !== begin.semantics.name || parserName !== end.semantics.name) {
    return conflict("name-mismatch");
  }
  return EQUIVALENT;
}

/** Default policy routing for census kinds; callers refine entity-specific rows. */
export function equivalencePolicyForKind(kind: CensusKind): WitnessEquivalencePolicy {
  switch (kind) {
    case "macro-invocation":
      return "control-sequence-token";
    case "macro-definition":
    case "environment-definition":
      return "definition-anchor";
    case "include":
      return "include-command-token";
    case "envelope-marker":
      return "entity-specific";
    case "environment":
      return "environment-fences";
    case "math":
      return "math-carrier";
    case "bib-entry":
    case "bib-string":
    case "bib-preamble":
    case "bib-comment":
      return "bib-construct";
    case "bib-field":
      return "bib-field-value";
    case "comment":
    case "paragraph-break":
    case "verbatim-inline":
      return "authority-only";
    default: {
      const exhaustive: never = kind;
      return exhaustive;
    }
  }
}

/** Exact span identity remains available for policy-neutral assertions. */
export function witnessExtentsEqual(left: WitnessRecord, right: WitnessRecord): boolean {
  return sourceSpansEqual(left.span, right.span);
}

function normalizedWitnessName(witness: WitnessRecord): string | undefined {
  const detail = witness.detail;
  if (!detail) return undefined;
  return detail.startsWith("backfill:") ? detail.slice("backfill:".length) : detail;
}

function bibConstruct(entity: CensusEntity, witness: WitnessRecord): string | undefined {
  const detail = witness.detail;
  switch (entity.kind) {
    case "bib-entry":
      if (detail === `bib-entry:${entity.entryType}` || detail === `entry:${entity.entryType}`) {
        return `entry:${entity.entryType}`;
      }
      return detail;
    case "bib-string":
      return detail === "string" ? "bib-string" : detail;
    case "bib-preamble":
      return detail === "preamble" ? "bib-preamble" : detail;
    case "bib-comment":
      return detail === "comment" ? "bib-comment" : detail;
    default:
      return undefined;
  }
}

function lexicalMathSemantics(
  entity: Extract<CensusEntity, { kind: "math" }>,
  witness: WitnessRecord
): WitnessSemantics | undefined {
  if (witness.witness === "parser") {
    return { mode: entity.mode, carrier: entity.carrier };
  }
  switch (witness.detail) {
    case "dollar":
      return { mode: "inline", carrier: { form: "dollar" } };
    case "double-dollar":
      return { mode: "display", carrier: { form: "double-dollar" } };
    case "paren":
      return { mode: "inline", carrier: { form: "paren" } };
    case "bracket":
      return { mode: "display", carrier: { form: "bracket" } };
    default:
      return undefined;
  }
}

/**
 * Recheck the evidence serialized on one two-instrument entity. This is the
 * publication-boundary counterpart of reconciliation: it uses only fields
 * that survive into entities.jsonl and therefore cannot rely on transient AST
 * nodes or scanner objects.
 */
export function compareCensusEntityWitnesses(entity: CensusEntity): WitnessEquivalenceResult {
  const parser = entity.witnesses.find((witness) => witness.witness === "parser");
  const lexical = entity.witnesses.find((witness) => witness.witness === "lexical");
  if (!parser || !lexical) return conflict("missing-independent-witness");

  switch (entity.kind) {
    case "macro-invocation":
      return compareWitnesses(
        "control-sequence-token",
        { ...parser, semantics: { name: normalizedWitnessName(parser) } },
        { ...lexical, semantics: { name: normalizedWitnessName(lexical) } }
      );
    case "macro-definition":
    case "environment-definition":
      return compareWitnesses("definition-anchor", parser, lexical);
    case "include":
      return compareWitnesses(
        "include-command-token",
        { ...parser, semantics: { name: normalizedWitnessName(parser), construct: entity.directive } },
        { ...lexical, semantics: { name: normalizedWitnessName(lexical), construct: entity.directive } }
      );
    case "envelope-marker": {
      if (entity.marker === "begin-document" || entity.marker === "end-document") {
        const role = entity.marker === "begin-document" ? "begin-fence" : "end-fence";
        const fence = entity.witnesses.find(
          (witness) => witness.witness === "lexical" && witness.spanRole === role
        );
        if (!fence) return conflict("missing-independent-witness");
        return compareWitnesses(
          entity.marker === "begin-document" ? "begin-fence-anchor" : "end-fence-anchor",
          { ...parser, semantics: { name: "document" } },
          { ...fence, semantics: { name: "document" } }
        );
      }
      return compareWitnesses(
        "control-sequence-token",
        { ...parser, semantics: { name: normalizedWitnessName(parser) } },
        { ...lexical, semantics: { name: normalizedWitnessName(lexical) } }
      );
    }
    case "environment": {
      const begin = entity.witnesses.find(
        (witness) => witness.witness === "lexical" && witness.spanRole === "begin-fence"
      );
      const end = entity.witnesses.find(
        (witness) => witness.witness === "lexical" && witness.spanRole === "end-fence"
      );
      if (!begin || !end) return conflict("missing-independent-witness");
      return compareEnvironmentWitnesses(
        { ...parser, semantics: { name: entity.name } },
        { ...begin, semantics: { name: entity.name } },
        { ...end, semantics: { name: entity.name } }
      );
    }
    case "math": {
      if (entity.carrier.form === "env") {
        const begin = entity.witnesses.find(
          (witness) => witness.witness === "lexical" && witness.spanRole === "begin-fence"
        );
        const end = entity.witnesses.find(
          (witness) => witness.witness === "lexical" && witness.spanRole === "end-fence"
        );
        if (!begin || !end) return conflict("missing-independent-witness");
        return compareEnvironmentWitnesses(
          { ...parser, semantics: { name: entity.carrier.name } },
          { ...begin, semantics: { name: entity.carrier.name } },
          { ...end, semantics: { name: entity.carrier.name } }
        );
      }
      const parserSemantics = lexicalMathSemantics(entity, parser);
      const lexicalSemantics = lexicalMathSemantics(entity, lexical);
      if (!parserSemantics || !lexicalSemantics) return conflict("missing-semantic-detail");
      return compareWitnesses(
        "math-carrier",
        { ...parser, semantics: parserSemantics },
        { ...lexical, semantics: lexicalSemantics }
      );
    }
    case "bib-entry":
    case "bib-string":
    case "bib-preamble":
    case "bib-comment":
      return compareWitnesses(
        "bib-construct",
        { ...parser, semantics: { construct: bibConstruct(entity, parser) } },
        { ...lexical, semantics: { construct: bibConstruct(entity, lexical) } }
      );
    case "bib-field":
      return compareWitnesses(
        "bib-field-value",
        { ...parser, semantics: { name: normalizedWitnessName(parser) } },
        { ...lexical, semantics: { name: normalizedWitnessName(lexical) } }
      );
    case "verbatim-inline":
    case "comment":
    case "paragraph-break":
      return conflict("single-authority-policy");
    default: {
      const exhaustive: never = entity;
      return exhaustive;
    }
  }
}
