/**
 * Chronological occurrence, binding, and invocation compilation for TeXdig.
 *
 * Physical census rows remain immutable evidence. This compiler replays every
 * source occurrence, owns the single execution sequence, interprets bindings,
 * and attaches arguments from the exact UTF-16 source stream.
 *
 * Erasable-syntax TypeScript only (Node native type stripping).
 */

import crypto from "node:crypto";

import type { IncludeEdge } from "../census/source-graph.ts";
import type { ConfiguredChannel } from "../census/configured.ts";
import type { ConfiguredSummonSite } from "../census/parse-latex.ts";
import type { Dependencies } from "../core/loader.ts";
import type {
  BindingMeaning,
  BindingRow,
  BindingSymbol,
  ConfiguredSummon,
  InvocationOccurrence,
  SourceOccurrence,
} from "../core/contracts.ts";
import type {
  CensusEntity,
  Diagnostic,
  EntityId,
  PillarClaim,
  SignatureEvidence,
  SourceId,
  SourceSpan,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import {
  attachInvocationArguments,
  attachLiteralIncludeInvocation,
} from "./arguments.ts";
import { BindingMachine } from "./binding-machine.ts";
import {
  planSourceOccurrences,
  type PlannedSourceOccurrence,
} from "./occurrences.ts";

export interface CompileExecutionInput {
  slug: string;
  treeSha256: string;
  entrypoint: SourceId;
  entities: readonly CensusEntity[];
  claims: readonly PillarClaim[];
  includeEdges: readonly IncludeEdge[];
  configured: ConfiguredChannel;
  rawContents: ReadonlyMap<SourceId, string>;
  deps: Dependencies;
  deferredContexts?: readonly {
    span: SourceSpan;
    reason: "conditional" | "argument-body" | "unknown-context";
  }[];
  maxOccurrences?: number;
  maxDepth?: number;
  maxEvents?: number;
}

export interface ExecutionCompilation {
  occurrences: SourceOccurrence[];
  bindings: BindingRow[];
  invocations: InvocationOccurrence[];
  diagnostics: Diagnostic[];
}

type DeferredContextReason = "conditional" | "argument-body" | "unknown-context";

interface DeferredContext {
  span: SourceSpan;
  reason: DeferredContextReason;
}

interface RuntimeItem {
  startUtf16: number;
  endUtf16: number;
  priority: number;
  key: string;
  kind:
    | "definition"
    | "summon"
    | "invocation"
    | "include"
    | "environment"
    | "environment-close"
    | "group-open"
    | "group-close";
  entity?: CensusEntity;
  summon?: ConfiguredSummonSite;
  child?: PlannedSourceOccurrence;
  span?: SourceSpan;
  /** Full construct extent when `span` is only an opening/closing fence. */
  governingSpan?: SourceSpan;
}

const BASELINE_SKIP = new Set([
  "newcommand", "renewcommand", "providecommand",
  "NewDocumentCommand", "RenewDocumentCommand", "ProvideDocumentCommand",
  "DeclareMathOperator", "DeclarePairedDelimiter",
  "def", "gdef", "edef", "xdef", "let",
  "newenvironment", "renewenvironment", "newtheorem", "newfloat",
]);

const FORCED_PRIMITIVE_SIGNATURES = new Map<string, string>([
  ["control-sequence\0documentclass", "o m"],
  ["control-sequence\0usepackage", "o m"],
  ["control-sequence\0RequirePackage", "o m"],
  ["control-sequence\0input", "m"],
  ["control-sequence\0include", "m"],
  ["control-sequence\0subfile", "m"],
  ["control-sequence\0begingroup", ""],
  ["control-sequence\0endgroup", ""],
]);

function fail(message: string): never {
  throw new Error(`Execution compiler: ${message}`);
}

function hashId(prefix: string, parts: readonly string[]): string {
  const hash = crypto.createHash("sha256");
  for (const part of parts) {
    hash.update(String(Buffer.byteLength(part, "utf8")));
    hash.update(":");
    hash.update(part, "utf8");
    hash.update(";");
  }
  return `${prefix}:${hash.digest("hex")}`;
}

function spanText(rawContents: ReadonlyMap<SourceId, string>, span: SourceSpan): string {
  const text = rawContents.get(span.sourceId);
  if (text === undefined) fail(`no decoded source text for '${span.sourceId}'`);
  if (
    !Number.isSafeInteger(span.startUtf16)
    || !Number.isSafeInteger(span.endUtf16)
    || span.startUtf16 < 0
    || span.endUtf16 < span.startUtf16
    || span.endUtf16 > text.length
  ) {
    fail(`invalid span ${span.sourceId}:${span.startUtf16}-${span.endUtf16}`);
  }
  return text.slice(span.startUtf16, span.endUtf16);
}

function tokenSpan(sourceId: SourceId, sourceText: string, startUtf16: number): SourceSpan {
  if (sourceText[startUtf16] !== "\\") {
    fail(`expected control sequence at ${sourceId}:${startUtf16}`);
  }
  let endUtf16 = startUtf16 + 1;
  const first = sourceText[endUtf16];
  if (first === undefined) endUtf16 = sourceText.length;
  else if (/[A-Za-z]/.test(first)) {
    endUtf16 += 1;
    while (endUtf16 < sourceText.length && /[A-Za-z]/.test(sourceText[endUtf16])) {
      endUtf16 += 1;
    }
  } else {
    const point = sourceText.codePointAt(endUtf16);
    endUtf16 += point !== undefined && point > 0xffff ? 2 : 1;
  }
  return { sourceId, startUtf16, endUtf16 };
}

function tokenName(sourceText: string, span: SourceSpan): string {
  return sourceText.slice(span.startUtf16 + 1, span.endUtf16);
}

function environmentFenceEvidence(
  entity: Extract<CensusEntity, { kind: "environment" }>,
  role: "begin-fence" | "end-fence",
  raw: string
): SourceSpan | undefined {
  const candidates = new Map<string, SourceSpan>();
  for (const witness of entity.witnesses) {
    if (witness.spanRole !== role) continue;
    const span = witness.span;
    if (
      span.sourceId !== entity.span.sourceId
      || span.startUtf16 < entity.span.startUtf16
      || span.endUtf16 > entity.span.endUtf16
      || span.endUtf16 > raw.length
      || (role === "begin-fence" && span.startUtf16 !== entity.span.startUtf16)
      || (role === "end-fence" && span.endUtf16 !== entity.span.endUtf16)
    ) {
      fail(`${role} witness escapes environment '${entity.id}'`);
    }
    candidates.set(`${span.startUtf16}:${span.endUtf16}`, span);
  }
  if (candidates.size > 1) fail(`environment '${entity.id}' has conflicting ${role} witnesses`);
  return candidates.values().next().value;
}

function environmentBeginSite(entity: Extract<CensusEntity, { kind: "environment" }>, raw: string): SourceSpan {
  const evidenced = environmentFenceEvidence(entity, "begin-fence", raw);
  if (evidenced) return evidenced;
  const prefix = `\\begin{${entity.name}}`;
  if (raw.slice(entity.span.startUtf16, entity.span.startUtf16 + prefix.length) !== prefix) {
    return tokenSpan(entity.span.sourceId, raw, entity.span.startUtf16);
  }
  return {
    sourceId: entity.span.sourceId,
    startUtf16: entity.span.startUtf16,
    endUtf16: entity.span.startUtf16 + prefix.length,
  };
}

function environmentEndSite(
  entity: Extract<CensusEntity, { kind: "environment" }>,
  raw: string
): SourceSpan | undefined {
  const evidenced = environmentFenceEvidence(entity, "end-fence", raw);
  if (evidenced) return evidenced;
  const suffix = `\\end{${entity.name}}`;
  const startUtf16 = raw.lastIndexOf(suffix, entity.span.endUtf16 - suffix.length);
  return startUtf16 < entity.span.startUtf16
    ? undefined
    : {
        sourceId: entity.span.sourceId,
        startUtf16,
        endUtf16: startUtf16 + suffix.length,
      };
}

function compareItems(left: RuntimeItem, right: RuntimeItem): number {
  return left.startUtf16 - right.startUtf16
    || left.priority - right.priority
    || left.endUtf16 - right.endUtf16
    || (left.key < right.key ? -1 : left.key > right.key ? 1 : 0);
}

function deferOccurrence(
  planned: PlannedSourceOccurrence,
  reason: NonNullable<SourceOccurrence["deferredReason"]>
): PlannedSourceOccurrence {
  return {
    id: planned.id,
    sourceId: planned.sourceId,
    parentOccurrenceId: planned.parentOccurrenceId,
    includeEntityId: planned.includeEntityId,
    includeChain: [...planned.includeChain],
    basis: planned.basis,
    state: "deferred-context",
    deferredReason: reason,
  };
}

function definitionSymbol(entity: Extract<CensusEntity, {
  kind: "macro-definition" | "environment-definition";
}>): BindingSymbol {
  return {
    namespace: entity.kind === "macro-definition" ? "control-sequence" : "environment",
    name: entity.definedName,
  };
}

function declarationOperation(entity: Extract<CensusEntity, {
  kind: "macro-definition" | "environment-definition";
}>): "new" | "renew" | "provide" | "assign" | "global-assign" | "expanded-assign" | "global-expanded-assign" | "let-capture" {
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

function declarationMeaning(entity: Extract<CensusEntity, {
  kind: "macro-definition" | "environment-definition";
}>): BindingMeaning {
  const hasBody = entity.kind === "macro-definition"
    ? entity.elaborable && entity.bodySpan !== undefined
    : entity.beginBodySpan !== undefined;
  if (hasBody || (entity.kind === "environment-definition" && entity.signature.state === "known")) {
    return {
      kind: "declaration",
      entityId: entity.id,
      availability: hasBody ? "body" : "signature-only",
      signature: structuredClone(entity.signature),
    };
  }
  return {
    kind: "opaque",
    entityId: entity.id,
    reason: `${entity.declarationCommand}-meaning-not-elaborated`,
    signature: structuredClone(entity.signature),
  };
}

function dispositionReason(entity: Extract<CensusEntity, {
  kind: "macro-definition" | "environment-definition";
}>): "definition-body" | "conditional" | "argument-body" | "unknown-context" | undefined {
  if (entity.activation === "immediate") return undefined;
  if (entity.context === "definition-body") return "definition-body";
  if (entity.context === "conditional") return "conditional";
  if (entity.context === "argument-body") return "argument-body";
  return "unknown-context";
}

function letCaptureSource(
  entity: Extract<CensusEntity, { kind: "macro-definition" }>,
  raw: string
): { kind: "current-symbol"; symbol: BindingSymbol } | { kind: "value"; meaning: BindingMeaning } {
  const bodySpan = entity.bodySpan;
  const body = bodySpan ? raw.slice(bodySpan.startUtf16, bodySpan.endUtf16) : "";
  let cursor = 0;
  while (cursor < body.length && /\s/.test(body[cursor])) cursor += 1;
  if (body[cursor] === "=") {
    cursor += 1;
    while (cursor < body.length && /\s/.test(body[cursor])) cursor += 1;
  }
  if (body[cursor] === "\\") {
    const absolute = bodySpan!.startUtf16 + cursor;
    const source = tokenSpan(entity.span.sourceId, raw, absolute);
    return {
      kind: "current-symbol",
      symbol: { namespace: "control-sequence", name: tokenName(raw, source) },
    };
  }
  if (cursor < body.length) {
    const width = (body.codePointAt(cursor) ?? 0) > 0xffff ? 2 : 1;
    return {
      kind: "value",
      meaning: {
        kind: "character-token",
        text: body.slice(cursor, cursor + width),
        catcode: "unknown",
        signature: { state: "known", spec: "" },
      },
    };
  }
  return {
    kind: "value",
    meaning: {
      kind: "opaque",
      entityId: entity.id,
      reason: "let-target-unavailable",
      signature: { state: "unknown", detail: "let-target-unavailable" },
    },
  };
}

function invocationCarrier(entity: CensusEntity, raw: string): {
  name: string;
  siteKind: InvocationOccurrence["siteKind"];
  siteSpan: SourceSpan;
  namespace: BindingSymbol["namespace"];
} | undefined {
  if (entity.kind === "macro-invocation") {
    return {
      name: entity.name,
      siteKind: "control-sequence",
      siteSpan: entity.span,
      namespace: "control-sequence",
    };
  }
  if (entity.kind === "include") {
    const siteSpan = tokenSpan(entity.span.sourceId, raw, entity.span.startUtf16);
    return {
      name: tokenName(raw, siteSpan),
      siteKind: "control-sequence",
      siteSpan,
      namespace: "control-sequence",
    };
  }
  if (entity.kind === "envelope-marker") {
    if (entity.marker === "begin-document" || entity.marker === "end-document") return undefined;
    const siteSpan = tokenSpan(entity.span.sourceId, raw, entity.span.startUtf16);
    return {
      name: entity.name ?? tokenName(raw, siteSpan),
      siteKind: "control-sequence",
      siteSpan,
      namespace: "control-sequence",
    };
  }
  if (entity.kind === "environment") {
    return {
      name: entity.name,
      siteKind: "environment-begin",
      siteSpan: environmentBeginSite(entity, raw),
      namespace: "environment",
    };
  }
  return undefined;
}

function candidateConfiguredEntities(
  entities: readonly CensusEntity[],
  packageName: string
): Extract<CensusEntity, { kind: "macro-definition" | "environment-definition" }>[] {
  return entities.filter((entity): entity is Extract<CensusEntity, {
    kind: "macro-definition" | "environment-definition";
  }> => (
    (entity.kind === "macro-definition" || entity.kind === "environment-definition")
    && entity.configuredPackage === packageName
  )).sort((left, right) => {
    const leftSymbol = definitionSymbol(left);
    const rightSymbol = definitionSymbol(right);
    return leftSymbol.namespace < rightSymbol.namespace ? -1
      : leftSymbol.namespace > rightSymbol.namespace ? 1
        : leftSymbol.name < rightSymbol.name ? -1
          : leftSymbol.name > rightSymbol.name ? 1
            : left.id < right.id ? -1 : left.id > right.id ? 1 : 0;
  });
}

/** Compile the promoted B-wave stores and their structured diagnostics. */
export function compileExecution(input: CompileExecutionInput): ExecutionCompilation {
  const maxEvents = input.maxEvents ?? 1_000_000;
  if (!Number.isSafeInteger(maxEvents) || maxEvents < 1) fail("maxEvents must be positive");

  const topology = planSourceOccurrences({
    entrypoint: input.entrypoint,
    entities: input.entities,
    includeEdges: input.includeEdges,
    deferredContexts: input.deferredContexts,
    maxOccurrences: input.maxOccurrences ?? 100_000,
    maxDepth: input.maxDepth ?? 512,
  });
  const plannedById = new Map(topology.occurrences.map((row) => [row.id, row]));
  const childrenByParent = new Map<string, PlannedSourceOccurrence[]>();
  for (const occurrence of topology.occurrences) {
    if (!occurrence.parentOccurrenceId) continue;
    const children = childrenByParent.get(occurrence.parentOccurrenceId) ?? [];
    children.push(occurrence);
    childrenByParent.set(occurrence.parentOccurrenceId, children);
  }

  const physicalEntities = input.entities.filter((entity) =>
    !(entity.kind === "macro-definition" && entity.dialect === "configured")
    && !(entity.kind === "environment-definition" && entity.mechanism === "configured")
  );
  const controlSequenceSpansBySource = new Map<SourceId, SourceSpan[]>();
  for (const entity of physicalEntities) {
    if (entity.kind !== "macro-invocation") continue;
    const spans = controlSequenceSpansBySource.get(entity.span.sourceId) ?? [];
    spans.push(entity.span);
    controlSequenceSpansBySource.set(entity.span.sourceId, spans);
  }
  const literalEdgesByEntityId = new Map<EntityId, IncludeEdge>();
  for (const edge of input.includeEdges) {
    if (edge.directive !== "input" && edge.directive !== "include") continue;
    const entityId = `ent:include@${edge.span.sourceId}:${edge.span.startUtf16}-${edge.span.endUtf16}`;
    const prior = literalEdgesByEntityId.get(entityId);
    if (prior) fail(`multiple literal include edges claim '${entityId}'`);
    literalEdgesByEntityId.set(entityId, edge);
  }
  const entitiesBySource = new Map<SourceId, CensusEntity[]>();
  for (const entity of physicalEntities) {
    const rows = entitiesBySource.get(entity.span.sourceId) ?? [];
    rows.push(entity);
    entitiesBySource.set(entity.span.sourceId, rows);
  }
  const deferredBySource = new Map<SourceId, DeferredContext[]>();
  for (const context of input.deferredContexts ?? []) {
    const rows = deferredBySource.get(context.span.sourceId) ?? [];
    rows.push(context);
    deferredBySource.set(context.span.sourceId, rows);
  }
  for (const rows of deferredBySource.values()) {
    rows.sort((left, right) =>
      (left.span.endUtf16 - left.span.startUtf16)
      - (right.span.endUtf16 - right.span.startUtf16)
    );
  }

  let seq = -1;
  const nextSeq = (): number => {
    seq += 1;
    if (seq >= maxEvents) fail(`maxEvents ${maxEvents} exceeded`);
    return seq;
  };
  const machine = new BindingMachine({
    bundleKey: `${input.slug}\0${input.treeSha256}`,
    nextSeq,
  });
  const occurrences: SourceOccurrence[] = [];
  const invocations: InvocationOccurrence[] = [];
  const diagnostics: Diagnostic[] = [];
  const loadedPackages = new Set<string>();

  const invocationIds = new Set<string>();
  const summonIds = new Set<string>();

  function baselineMeaning(name: string, namespace: BindingSymbol["namespace"]): BindingMeaning {
    const info = namespace === "control-sequence"
      ? input.deps.ctan.macroInfo.latex2e?.[name]
      : input.deps.ctan.environmentInfo.latex2e?.[name];
    const forced = FORCED_PRIMITIVE_SIGNATURES.get(`${namespace}\0${name}`);
    const signature: SignatureEvidence = info?.argumentParser !== undefined
      ? { state: "custom-parser", detail: `unified-latex-ctan/latex2e/${name}` }
      : { state: "known", spec: forced ?? info?.signature ?? "" };
    return { kind: "primitive", name, signature };
  }

  // Demand-filtered baseline: physical execution carriers only. Definition
  // formers install meanings through their declaration events, not baseline.
  const baselineSymbols = new Map<string, BindingSymbol>();
  for (const entity of physicalEntities) {
    const raw = input.rawContents.get(entity.span.sourceId);
    if (raw === undefined) continue;
    const carrier = invocationCarrier(entity, raw);
    if (!carrier || BASELINE_SKIP.has(carrier.name)) continue;
    const info = carrier.namespace === "control-sequence"
      ? input.deps.ctan.macroInfo.latex2e?.[carrier.name]
      : input.deps.ctan.environmentInfo.latex2e?.[carrier.name];
    const key = `${carrier.namespace}\0${carrier.name}`;
    if (info === undefined && !FORCED_PRIMITIVE_SIGNATURES.has(key)) continue;
    baselineSymbols.set(key, { namespace: carrier.namespace, name: carrier.name });
  }
  for (const symbol of [...baselineSymbols.values()].sort((a, b) => {
    const ak = `${a.namespace}\0${a.name}`;
    const bk = `${b.namespace}\0${b.name}`;
    return ak < bk ? -1 : ak > bk ? 1 : 0;
  })) {
    machine.apply({
      eventKey: `baseline:${symbol.namespace}:${symbol.name}`,
      symbol,
      cause: { kind: "baseline" },
      operation: "baseline-install",
      meaning: baselineMeaning(symbol.name, symbol.namespace),
    });
  }

  const root = plannedById.get(topology.rootOccurrenceId);
  if (!root) fail("occurrence plan has no root");
  const rootEnterSeq = nextSeq();
  const rootMaterialized: SourceOccurrence = {
    ...root,
    enterSeq: rootEnterSeq,
    exitSeq: rootEnterSeq,
  };
  occurrences.push(rootMaterialized);
  machine.enterDocument({ occurrenceId: root.id, siteKey: "document" });

  function compileInvocation(
    occurrence: PlannedSourceOccurrence,
    entity: CensusEntity,
    raw: string,
    deferredReason?: string
  ): InvocationOccurrence | undefined {
    const carrier = invocationCarrier(entity, raw);
    if (!carrier) return undefined;
    const symbol: BindingSymbol = { namespace: carrier.namespace, name: carrier.name };
    const id = hashId("inv", [occurrence.id, entity.id, carrier.siteKind]);
    if (invocationIds.has(id)) fail(`duplicate invocation id '${id}'`);
    invocationIds.add(id);
    const rowSeq = nextSeq();

    let row: InvocationOccurrence;
    if (deferredReason !== undefined) {
      row = {
        id, seq: rowSeq, occurrenceId: occurrence.id, entityId: entity.id,
        name: carrier.name, siteKind: carrier.siteKind, siteSpan: carrier.siteSpan,
        binding: { state: "deferred", reason: deferredReason },
        span: carrier.siteSpan, arguments: [], status: "deferred",
        text: spanText(input.rawContents, carrier.siteSpan),
      };
      diagnostics.push({
        code: DiagnosticCodes.InvocationDeferred,
        severity: "warning",
        message: `Invocation '${carrier.name}' is deferred in ${deferredReason}`,
        sourceId: carrier.siteSpan.sourceId,
        span: carrier.siteSpan,
        entityId: entity.id,
        occurrenceId: occurrence.id,
        invocationId: id,
      });
    } else {
      const lookup = machine.lookup(symbol);
      if (lookup.state === "unbound") {
      row = {
        id, seq: rowSeq, occurrenceId: occurrence.id, entityId: entity.id,
        name: carrier.name, siteKind: carrier.siteKind, siteSpan: carrier.siteSpan,
        binding: { state: "unbound" }, span: carrier.siteSpan, arguments: [],
        status: "unbound", text: spanText(input.rawContents, carrier.siteSpan),
      };
      } else if (lookup.state === "indeterminate") {
        row = {
          id, seq: rowSeq, occurrenceId: occurrence.id, entityId: entity.id,
          name: carrier.name, siteKind: carrier.siteKind, siteSpan: carrier.siteSpan,
          binding: {
            state: "indeterminate",
            causeIds: lookup.meaning.causeIds,
            detail: lookup.meaning.reason,
          },
          span: carrier.siteSpan, arguments: [], status: "indeterminate",
          text: spanText(input.rawContents, carrier.siteSpan),
        };
        diagnostics.push({
          code: DiagnosticCodes.InvocationDeferred,
          severity: "warning",
          message: `Invocation '${carrier.name}' has an indeterminate governing binding`,
          sourceId: carrier.siteSpan.sourceId,
          span: carrier.siteSpan,
          entityId: entity.id,
          occurrenceId: occurrence.id,
          bindingId: lookup.bindingEventId,
          invocationId: id,
        });
      } else {
        const governingPrimitive = primitiveNameForBindingEvent(lookup.bindingEventId);
        const literalEdge = entity.kind === "include" ? literalEdgesByEntityId.get(entity.id) : undefined;
        const attached = entity.kind === "include"
            && literalEdge !== undefined
            && governingPrimitive === literalEdge.command
            && (governingPrimitive === "input" || governingPrimitive === "include" || governingPrimitive === "subfile")
          ? attachLiteralIncludeInvocation(raw, carrier.siteSpan, {
              directiveSpan: entity.span,
              targetRaw: entity.targetRaw,
              targetSpan: literalEdge.targetSpan,
            })
          : attachInvocationArguments(raw, carrier.siteSpan, lookup.meaning.signature, {
              controlSequenceSpans: controlSequenceSpansBySource.get(carrier.siteSpan.sourceId),
            });
        if (attached.status === "attached") {
          row = {
            id, seq: rowSeq, occurrenceId: occurrence.id, entityId: entity.id,
            name: carrier.name, siteKind: carrier.siteKind, siteSpan: carrier.siteSpan,
            binding: {
              state: "bound",
              bindingEventId: lookup.bindingEventId,
              signature: structuredClone(lookup.meaning.signature),
            },
            span: attached.span,
            arguments: attached.arguments,
            status: "attached",
            text: spanText(input.rawContents, attached.span),
          };
        } else if (attached.status === "deferred") {
          row = {
            id, seq: rowSeq, occurrenceId: occurrence.id, entityId: entity.id,
            name: carrier.name, siteKind: carrier.siteKind, siteSpan: carrier.siteSpan,
            binding: {
              state: "bound",
              bindingEventId: lookup.bindingEventId,
              signature: structuredClone(lookup.meaning.signature),
            },
            span: attached.span, arguments: [], status: "deferred",
            text: spanText(input.rawContents, attached.span),
          };
          diagnostics.push({
            code: DiagnosticCodes.InvocationDeferred,
            severity: "warning",
            message: `Invocation '${carrier.name}' attachment deferred: ${attached.detail}`,
            sourceId: carrier.siteSpan.sourceId,
            span: carrier.siteSpan,
            entityId: entity.id,
            occurrenceId: occurrence.id,
            bindingId: lookup.bindingEventId,
            invocationId: id,
          });
        } else {
          row = {
            id, seq: rowSeq, occurrenceId: occurrence.id, entityId: entity.id,
            name: carrier.name, siteKind: carrier.siteKind, siteSpan: carrier.siteSpan,
            binding: {
              state: "bound",
              bindingEventId: lookup.bindingEventId,
              signature: structuredClone(lookup.meaning.signature),
            },
            span: attached.span, arguments: attached.arguments, status: "malformed",
            text: spanText(input.rawContents, attached.span),
          };
          diagnostics.push({
            code: DiagnosticCodes.InvocationMalformed,
            severity: "defect",
            message: `Invocation '${carrier.name}' is malformed: ${attached.detail}`,
            sourceId: carrier.siteSpan.sourceId,
            span: attached.errorSpan,
            entityId: entity.id,
            occurrenceId: occurrence.id,
            bindingId: lookup.bindingEventId,
            invocationId: id,
          });
        }
      }
    }
    invocations.push(row);
    return row;
  }

  function primitiveNameForBindingEvent(bindingEventId: string): string | undefined {
    let meaning = machine.meaningOf(bindingEventId);
    const seen = new Set<string>();
    while (meaning?.kind === "captured") {
      if (seen.has(meaning.sourceBindingEventId)) return undefined;
      seen.add(meaning.sourceBindingEventId);
      meaning = machine.meaningOf(meaning.sourceBindingEventId);
    }
    return meaning?.kind === "primitive" ? meaning.name : undefined;
  }

  function primitiveNameForInvocation(row: InvocationOccurrence | undefined): string | undefined {
    return row?.binding.state === "bound"
      ? primitiveNameForBindingEvent(row.binding.bindingEventId)
      : undefined;
  }

  function rememberArgumentContexts(
    row: InvocationOccurrence | undefined,
    contexts: DeferredContext[]
  ): void {
    if (!row || (row.status !== "attached" && row.status !== "malformed")) return;
    for (const argument of row.arguments) {
      if (argument.source !== "explicit" || !argument.contentSpan) continue;
      contexts.push({ span: argument.span ?? argument.contentSpan, reason: "argument-body" });
    }
  }

  function processSummon(
    occurrence: PlannedSourceOccurrence,
    summon: ConfiguredSummonSite,
    physicalEntity: CensusEntity,
    deferredReason?: string
  ): void {
    const id = hashId("summon", [
      occurrence.id,
      `${summon.siteSpan.sourceId}:${summon.siteSpan.startUtf16}-${summon.siteSpan.endUtf16}`,
      String(summon.targetOrdinal),
      summon.packageName,
    ]);
    if (summonIds.has(id)) fail(`duplicate configured summon id '${id}'`);
    summonIds.add(id);

    const raw = input.rawContents.get(physicalEntity.span.sourceId);
    if (raw === undefined) fail(`configured summon source '${physicalEntity.span.sourceId}' is unavailable`);
    const carrier = invocationCarrier(physicalEntity, raw);
    const lookup = carrier
      ? machine.lookup({ namespace: carrier.namespace, name: carrier.name })
      : { state: "unbound" as const };
    const governingPrimitive = lookup.state === "bound"
      ? primitiveNameForBindingEvent(lookup.bindingEventId)
      : undefined;
    const executionDeferred = deferredReason !== undefined
      || governingPrimitive !== summon.command;
    const candidates = candidateConfiguredEntities(input.entities, summon.packageName);
    let outcome: ConfiguredSummon["outcome"];
    if (executionDeferred) outcome = "indeterminate";
    else if (loadedPackages.has(summon.packageName)) outcome = "already-loaded";
    else if (candidates.length === 0) outcome = "unconfigured";
    else outcome = "loaded";
    const row: ConfiguredSummon = {
      rowType: "configured-summon",
      id,
      seq: nextSeq(),
      occurrenceId: occurrence.id,
      scopeId: machine.currentScopeId,
      physicalEntityId: physicalEntity.id,
      command: summon.command,
      targetOrdinal: summon.targetOrdinal,
      packageName: summon.packageName,
      siteSpan: summon.siteSpan,
      targetSpan: summon.targetSpan,
      optionsSpan: summon.optionsSpan,
      optionsText: summon.optionsText,
      text: spanText(input.rawContents, summon.siteSpan),
      outcome,
      candidateEntityIds: candidates.map((candidate) => candidate.id),
    };
    // ConfiguredSummon is a BindingRow and the state machine deliberately does
    // not know packages. Append through its detached ledger at integration.
    (configuredRows as BindingRow[]).push(row);

    if (outcome === "indeterminate") {
      diagnostics.push({
        code: DiagnosticCodes.BindingIndeterminate,
        severity: "warning",
        message: deferredReason !== undefined
          ? `Configured summon '${summon.packageName}' is deferred in ${deferredReason}`
          : `Configured summon '${summon.packageName}' has no governing package-load primitive`,
        sourceId: summon.siteSpan.sourceId,
        span: summon.siteSpan,
        entityId: physicalEntity.id,
        occurrenceId: occurrence.id,
      });
      return;
    }
    if (outcome === "already-loaded") return;
    loadedPackages.add(summon.packageName);
    if (outcome !== "loaded") return;
    for (const candidate of candidates) {
      const symbol = definitionSymbol(candidate);
      const existing = machine.lookup(symbol);
      const meaning: BindingMeaning = existing.state === "unbound"
        ? {
            kind: "declaration",
            entityId: candidate.id,
            availability: candidate.signature.state === "known" ? "signature-only" : "opaque",
            signature: structuredClone(candidate.signature),
          }
        : {
            kind: "indeterminate",
            reason: `configured provider '${summon.packageName}' collides with an existing binding`,
            causeIds: [
              ...(existing.state === "unbound" ? [] : [existing.bindingEventId]),
              candidate.id,
              id,
            ],
            signature: { state: "unknown", detail: "configured-provider-collision" },
          };
      const event = machine.apply({
        eventKey: `${id}:${candidate.id}`,
        occurrenceId: occurrence.id,
        symbol,
        cause: { kind: "configured", summonId: id, entityId: candidate.id },
        operation: "configured-install",
        meaning,
        target: "global",
        text: row.text,
      });
      if (event.effect === "indeterminate") {
        diagnostics.push({
          code: DiagnosticCodes.BindingIndeterminate,
          severity: "warning",
          message: `Configured declaration '${symbol.name}' is indeterminate after provider collision`,
          sourceId: summon.siteSpan.sourceId,
          span: summon.siteSpan,
          entityId: physicalEntity.id,
          occurrenceId: occurrence.id,
          bindingId: event.id,
        });
      }
    }
  }

  const configuredRows: BindingRow[] = [];

  function executeOccurrence(
    planned: PlannedSourceOccurrence,
    preentered?: SourceOccurrence
  ): void {
    const enterSeq = preentered?.enterSeq ?? nextSeq();
    const materialized: SourceOccurrence = preentered ?? { ...planned, enterSeq, exitSeq: enterSeq };
    if (!preentered) occurrences.push(materialized);
    if (planned.state !== "entered") {
      materialized.exitSeq = nextSeq();
      diagnostics.push({
        code: DiagnosticCodes.OccurrenceDeferred,
        severity: "warning",
        message: planned.state === "cycle-cut"
          ? `Occurrence cycle cut at '${planned.sourceId}'`
          : `Occurrence of '${planned.sourceId}' deferred in ${planned.deferredReason ?? "unknown"} context`,
        sourceId: planned.includeEntityId
          ? input.entities.find((entity) => entity.id === planned.includeEntityId)?.span.sourceId
          : planned.sourceId,
        entityId: planned.includeEntityId,
        occurrenceId: planned.id,
      });
      return;
    }

    const raw = input.rawContents.get(planned.sourceId);
    if (raw === undefined) fail(`entered source '${planned.sourceId}' has no decoded text`);
    const items: RuntimeItem[] = [];
    const environmentCloseIds = new Set<string>();
    const openedEnvironmentIds = new Set<string>();
    const dynamicDeferredContexts: DeferredContext[] = [];
    const staticDeferredContexts = deferredBySource.get(planned.sourceId) ?? [];
    const childByInclude = new Map(
      (childrenByParent.get(planned.id) ?? []).map((child) => [child.includeEntityId!, child])
    );

    function deferredReasonFor(item: RuntimeItem): DeferredContextReason | undefined {
      const span = item.governingSpan ?? item.span ?? item.summon?.siteSpan ?? item.entity?.span;
      if (!span) return undefined;
      const candidates = [...staticDeferredContexts, ...dynamicDeferredContexts]
        .filter((context) => {
          const directlyContained = context.span.startUtf16 <= span.startUtf16
            && span.endUtf16 <= context.span.endUtf16;
          const isArgumentFence = item.governingSpan !== undefined
            && context.reason === "argument-body"
            && span.startUtf16 <= context.span.startUtf16
            && context.span.endUtf16 <= span.endUtf16
            && context.span.startUtf16 - span.startUtf16 <= 1
            && span.endUtf16 - context.span.endUtf16 <= 1;
          return directlyContained || isArgumentFence;
        })
        .sort((left, right) =>
          (left.span.endUtf16 - left.span.startUtf16)
          - (right.span.endUtf16 - right.span.startUtf16)
        );
      return candidates[0]?.reason;
    }

    for (const entity of entitiesBySource.get(planned.sourceId) ?? []) {
      if (entity.kind === "macro-definition" || entity.kind === "environment-definition") {
        items.push({
          startUtf16: entity.span.startUtf16,
          endUtf16: entity.span.endUtf16,
          priority: 30,
          key: entity.id,
          kind: "definition",
          entity,
        });
      } else if (entity.kind === "include") {
        items.push({
          startUtf16: entity.span.startUtf16,
          endUtf16: entity.span.endUtf16,
          priority: 20,
          key: entity.id,
          kind: "include",
          entity,
          child: childByInclude.get(entity.id),
        });
      } else if (entity.kind === "environment") {
        if (entity.name === "document") continue;
        const beginSite = environmentBeginSite(entity, raw);
        const endSite = environmentEndSite(entity, raw);
        items.push({
          startUtf16: entity.span.startUtf16,
          endUtf16: entity.span.endUtf16,
          priority: 23,
          key: entity.id,
          kind: "environment",
          entity,
        });
        if (endSite && endSite.startUtf16 >= beginSite.endUtf16) {
          environmentCloseIds.add(entity.id);
          items.push({
            startUtf16: endSite.startUtf16,
            endUtf16: endSite.endUtf16,
            priority: 1,
            key: `${entity.id}:close`,
            kind: "environment-close",
            entity,
            span: endSite,
          });
        }
      } else if (invocationCarrier(entity, raw)) {
        items.push({
          startUtf16: entity.span.startUtf16,
          endUtf16: entity.span.endUtf16,
          priority: entity.kind === "macro-invocation" ? 21 : 22,
          key: entity.id,
          kind: "invocation",
          entity,
        });
      }
    }

    for (const summon of input.configured.summons) {
      if (summon.siteSpan.sourceId !== planned.sourceId) continue;
      const physical = (entitiesBySource.get(planned.sourceId) ?? []).find((entity) =>
        entity.span.startUtf16 === summon.siteSpan.startUtf16
        && (entity.kind === "macro-invocation" || entity.kind === "envelope-marker")
      );
      if (!physical) fail(`configured summon at ${planned.sourceId}:${summon.siteSpan.startUtf16} has no carrier`);
      items.push({
        startUtf16: summon.siteSpan.startUtf16,
        endUtf16: summon.siteSpan.endUtf16,
        priority: 100 + summon.targetOrdinal,
        key: `${physical.id}:${summon.targetOrdinal}:${summon.packageName}`,
        kind: "summon",
        entity: physical,
        summon,
      });
    }

    // Promote explicit parser groups only when they govern a proven local
    // declaration or span an include boundary. Runtime argument attachment
    // suppresses argument braces below before they can become scope frames.
    const groupClaims = input.claims.filter((claim) =>
      claim.role === "group" && claim.span.sourceId === planned.sourceId
    );
    const groupLocalDefinitions = items.filter((item) =>
      item.kind === "definition"
      && (item.entity!.kind === "macro-definition" || item.entity!.kind === "environment-definition")
      && item.entity!.context === "group-local"
    );
    const scopeAnchors = [
      ...groupLocalDefinitions,
      ...items.filter((item) => item.kind === "include"),
    ];
    const scopedGroups = new Map<string, SourceSpan>();
    for (const anchor of scopeAnchors) {
      const group = groupClaims
        .filter((claim) =>
          claim.span.startUtf16 <= anchor.startUtf16
          && anchor.endUtf16 <= claim.span.endUtf16
        )
        .sort((a, b) =>
          (a.span.endUtf16 - a.span.startUtf16) - (b.span.endUtf16 - b.span.startUtf16)
        )[0]?.span;
      if (group) scopedGroups.set(`${group.startUtf16}:${group.endUtf16}`, group);
    }
    for (const group of scopedGroups.values()) {
      items.push({
        startUtf16: group.startUtf16,
        endUtf16: group.startUtf16 + 1,
        priority: 0,
        key: `group:${group.startUtf16}-${group.endUtf16}:open`,
        kind: "group-open",
        span: { ...group, endUtf16: group.startUtf16 + 1 },
        governingSpan: group,
      });
      items.push({
        startUtf16: group.endUtf16 - 1,
        endUtf16: group.endUtf16,
        priority: 0,
        key: `group:${group.startUtf16}-${group.endUtf16}:close`,
        kind: "group-close",
        span: { ...group, startUtf16: group.endUtf16 - 1 },
        governingSpan: group,
      });
    }

    // Definition interiors are inert until elaboration activates them.
    const definitionSpans = items
      .filter((item) => item.kind === "definition")
      .map((item) => item.entity!.span);
    const filtered = items.filter((item) => {
      if (item.kind === "definition" || item.kind === "group-open" || item.kind === "group-close") return true;
      if (item.kind === "include" && item.child?.state === "deferred-context") return true;
      return !definitionSpans.some((span) =>
        span.startUtf16 <= item.startUtf16 && item.endUtf16 <= span.endUtf16
      );
    }).sort(compareItems);

    const executedCarriers = new Map<string, InvocationOccurrence | undefined>();
    for (const item of filtered) {
      const plannedReason = item.kind === "include" && item.child?.state === "deferred-context"
        ? item.child.deferredReason
        : undefined;
      const contextReason = plannedReason ?? deferredReasonFor(item);
      if (contextReason !== undefined) {
        if (item.kind === "group-open" || item.kind === "group-close" || item.kind === "environment-close") {
          continue;
        }
        if (item.kind === "definition") {
          const entity = item.entity as Extract<CensusEntity, {
            kind: "macro-definition" | "environment-definition";
          }>;
          machine.recordDisposition({
            eventKey: entity.id,
            occurrenceId: planned.id,
            entityId: entity.id,
            reason: contextReason,
            text: spanText(input.rawContents, entity.span),
          });
          continue;
        }
        if (item.kind === "summon") {
          processSummon(planned, item.summon!, item.entity!, contextReason);
          continue;
        }
        const carrier = invocationCarrier(item.entity!, raw);
        const carrierKey = carrier
          ? `${carrier.namespace}:${carrier.siteSpan.startUtf16}-${carrier.siteSpan.endUtf16}:${carrier.name}`
          : item.key;
        if (!executedCarriers.has(carrierKey)) {
          executedCarriers.set(
            carrierKey,
            compileInvocation(planned, item.entity!, raw, contextReason)
          );
        }
        if (item.kind === "include" && item.child) {
          executeOccurrence(
            item.child.state === "deferred-context"
              ? item.child
              : deferOccurrence(item.child, contextReason)
          );
        }
        continue;
      }

      if (item.kind === "group-open") {
        machine.enterScope({
          kind: "brace-group",
          occurrenceId: planned.id,
          siteKey: item.key,
          openSpan: item.span,
          openText: item.span ? spanText(input.rawContents, item.span) : undefined,
        });
      } else if (item.kind === "group-close") {
        if (machine.currentScopeKind === "brace-group") {
          machine.exitScope({
            occurrenceId: planned.id,
            closeSpan: item.span,
            closeText: item.span ? spanText(input.rawContents, item.span) : undefined,
          });
        } else {
          diagnostics.push({
            code: DiagnosticCodes.BindingIndeterminate,
            severity: "warning",
            message: `Brace-group close encountered while '${machine.currentScopeKind}' is active`,
            sourceId: item.span?.sourceId,
            span: item.span,
            occurrenceId: planned.id,
          });
        }
      } else if (item.kind === "environment-close") {
        if (item.entity && openedEnvironmentIds.has(item.entity.id)) {
          if (machine.currentScopeKind === "environment") {
            machine.exitScope({
              occurrenceId: planned.id,
              closeSpan: item.span,
              closeText: item.span ? spanText(input.rawContents, item.span) : undefined,
            });
            openedEnvironmentIds.delete(item.entity.id);
          } else {
            diagnostics.push({
              code: DiagnosticCodes.BindingIndeterminate,
              severity: "warning",
              message: `Environment close encountered while '${machine.currentScopeKind}' is active`,
              sourceId: item.span?.sourceId,
              span: item.span,
              entityId: item.entity.id,
              occurrenceId: planned.id,
            });
          }
        }
      } else if (item.kind === "definition") {
        const entity = item.entity as Extract<CensusEntity, {
          kind: "macro-definition" | "environment-definition";
        }>;
        const text = spanText(input.rawContents, entity.span);
        const reason = dispositionReason(entity);
        if (reason) {
          machine.recordDisposition({
            eventKey: entity.id,
            occurrenceId: planned.id,
            entityId: entity.id,
            reason,
            text,
          });
          continue;
        }
        const operation = declarationOperation(entity);
        let event;
        if (operation === "let-capture" && entity.kind === "macro-definition") {
          const source = letCaptureSource(entity, raw);
          event = machine.captureLet({
            eventKey: entity.id,
            occurrenceId: planned.id,
            symbol: definitionSymbol(entity),
            cause: { kind: "physical-declaration", entityId: entity.id, siteSpan: entity.span },
            source,
            text,
          });
        } else {
          event = machine.apply({
            eventKey: entity.id,
            occurrenceId: planned.id,
            symbol: definitionSymbol(entity),
            cause: { kind: "physical-declaration", entityId: entity.id, siteSpan: entity.span },
            operation: operation === "let-capture" ? "assign" : operation,
            meaning: declarationMeaning(entity),
            text,
          });
        }
        if (event.effect === "invalid-precondition") {
          diagnostics.push({
            code: DiagnosticCodes.BindingPrecondition,
            severity: "warning",
            message: `Declaration '${entity.definedName}' failed ${event.operation} precondition`,
            sourceId: entity.span.sourceId,
            span: entity.span,
            entityId: entity.id,
            occurrenceId: planned.id,
            bindingId: event.id,
          });
        }
      } else if (item.kind === "summon") {
        processSummon(planned, item.summon!, item.entity!);
      } else {
        const carrier = invocationCarrier(item.entity!, raw);
        const carrierKey = carrier
          ? `${carrier.namespace}:${carrier.siteSpan.startUtf16}-${carrier.siteSpan.endUtf16}:${carrier.name}`
          : item.key;
        let invocationRow = executedCarriers.get(carrierKey);
        if (!executedCarriers.has(carrierKey)) {
          invocationRow = compileInvocation(planned, item.entity!, raw);
          executedCarriers.set(carrierKey, invocationRow);
          rememberArgumentContexts(invocationRow, dynamicDeferredContexts);
        }
        if (item.kind === "environment") {
          const entity = item.entity as Extract<CensusEntity, { kind: "environment" }>;
          const openSpan = environmentBeginSite(entity, raw);
          if (environmentCloseIds.has(entity.id)) {
            machine.enterScope({
              kind: "environment",
              occurrenceId: planned.id,
              siteKey: entity.id,
              openSpan,
              openText: spanText(input.rawContents, openSpan),
            });
            openedEnvironmentIds.add(entity.id);
          } else {
            diagnostics.push({
              code: DiagnosticCodes.BindingIndeterminate,
              severity: "warning",
            message: `Environment '${entity.name}' has no closed scope fence`,
              sourceId: entity.span.sourceId,
              span: entity.span,
              entityId: entity.id,
              occurrenceId: planned.id,
            });
          }
        } else if (
          carrier?.namespace === "control-sequence"
          && carrier.name === "begingroup"
          && primitiveNameForInvocation(invocationRow) === "begingroup"
        ) {
          machine.enterScope({
            kind: "begingroup",
            occurrenceId: planned.id,
            siteKey: item.entity!.id,
            openSpan: carrier.siteSpan,
            openText: spanText(input.rawContents, carrier.siteSpan),
          });
        } else if (
          carrier?.namespace === "control-sequence"
          && carrier.name === "endgroup"
          && primitiveNameForInvocation(invocationRow) === "endgroup"
        ) {
          if (machine.currentScopeKind === "begingroup") {
            machine.exitScope({
              occurrenceId: planned.id,
              closeSpan: carrier.siteSpan,
              closeText: spanText(input.rawContents, carrier.siteSpan),
            });
          } else {
            diagnostics.push({
              code: DiagnosticCodes.BindingIndeterminate,
              severity: "warning",
              message: `\\endgroup encountered while '${machine.currentScopeKind}' is active`,
              sourceId: carrier.siteSpan.sourceId,
              span: carrier.siteSpan,
              entityId: item.entity!.id,
              occurrenceId: planned.id,
              invocationId: invocationRow?.id,
            });
          }
        }
        if (item.kind === "include" && item.child) {
          const primitive = primitiveNameForInvocation(invocationRow);
          executeOccurrence(
            primitive === "input" || primitive === "include" || primitive === "subfile"
              ? item.child
              : deferOccurrence(item.child, "unknown-context")
          );
        }
      }
    }
    if (planned.id === root.id) {
      while (machine.currentScopeKind !== "document" && machine.currentScopeKind !== "global") {
        const kind = machine.currentScopeKind;
        machine.exitScope({ occurrenceId: planned.id, status: "unterminated" });
        diagnostics.push({
          code: DiagnosticCodes.BindingIndeterminate,
          severity: "warning",
          message: `Unterminated '${kind}' scope at the end of execution`,
          sourceId: planned.sourceId,
          occurrenceId: planned.id,
        });
      }
      if (machine.currentScopeKind === "document") {
        machine.exitScope({ occurrenceId: planned.id });
      }
    }
    materialized.exitSeq = nextSeq();
  }

  executeOccurrence(root, rootMaterialized);
  machine.closeGlobal();

  const bindings = [...machine.rows(), ...configuredRows].sort((left, right) => {
    const leftSeq = "seq" in left ? left.seq : left.enterSeq;
    const rightSeq = "seq" in right ? right.seq : right.enterSeq;
    return leftSeq - rightSeq;
  });
  return { occurrences, bindings, invocations, diagnostics };
}
