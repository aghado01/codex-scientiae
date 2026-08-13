/**
 * Route-derived source-occurrence topology for TeXdig execution planning.
 *
 * The planner records physical include routes, replay, cycle cuts, and
 * definition-body deferrals. Execution-event sequence assignment is performed
 * by the later materializer that interleaves binding and invocation events.
 *
 * Erasable-syntax TypeScript only (Node native type stripping).
 */

import { createHash } from "node:crypto";

import type { IncludeEdge } from "../census/source-graph.ts";
import type { SourceOccurrence } from "../core/contracts.ts";
import type {
  CensusEntity,
  EntityId,
  SourceId,
  SourceSpan,
} from "../core/types.ts";

const ROOT_ID_DOMAIN = "texdig-occurrence/0.3\0root\0";
const CHILD_ID_DOMAIN = "texdig-occurrence/0.3\0child\0";

/** A source occurrence before execution-event sequence assignment. */
export type PlannedSourceOccurrence = Omit<SourceOccurrence, "enterSeq" | "exitSeq">;

/** Deterministic depth-first boundary used by the execution materializer. */
export interface OccurrenceTraceEvent {
  phase: "enter" | "exit";
  occurrenceId: string;
  sourceId: SourceId;
  state: PlannedSourceOccurrence["state"];
  depth: number;
}

export interface PlanSourceOccurrencesInput {
  entrypoint: SourceId;
  entities: readonly CensusEntity[];
  includeEdges: readonly IncludeEdge[];
  deferredContexts?: readonly {
    span: SourceSpan;
    reason: "conditional" | "argument-body" | "unknown-context";
  }[];
  /** Maximum number of rows, including cycle cuts and deferred contexts. */
  maxOccurrences: number;
  /** Maximum route depth. The entrypoint has depth zero. */
  maxDepth: number;
}

export interface OccurrenceTopologyPlan {
  rootOccurrenceId: string;
  /** Preorder rows. Parent rows always precede their children. */
  occurrences: PlannedSourceOccurrence[];
  /** Balanced depth-first boundaries with adjacent boundaries for leaf rows. */
  trace: OccurrenceTraceEvent[];
}

interface JoinedIncludeEdge {
  edge: IncludeEdge & { toSourceId: SourceId };
  includeEntityId: EntityId;
}

function fail(message: string): never {
  throw new Error(`Occurrence topology: ${message}`);
}

function assertRoutePart(value: string, label: string): void {
  if (typeof value !== "string" || value.length === 0) {
    fail(`${label} must be a non-empty string`);
  }
  if (value.includes("\0")) {
    fail(`${label} must not contain NUL`);
  }
}

function assertLimit(value: number, label: string, minimum: number): void {
  if (!Number.isSafeInteger(value) || value < minimum) {
    fail(`${label} must be a safe integer greater than or equal to ${minimum}`);
  }
}

function assertSpan(span: SourceSpan, label: string): void {
  if (!span || typeof span !== "object") fail(`${label} is missing`);
  assertRoutePart(span.sourceId, `${label}.sourceId`);
  if (
    !Number.isSafeInteger(span.startUtf16)
    || !Number.isSafeInteger(span.endUtf16)
    || span.startUtf16 < 0
    || span.endUtf16 < span.startUtf16
  ) {
    fail(`${label} is not a valid UTF-16 half-open span`);
  }
}

function sameSpan(left: SourceSpan, right: SourceSpan): boolean {
  return left.sourceId === right.sourceId
    && left.startUtf16 === right.startUtf16
    && left.endUtf16 === right.endUtf16;
}

function containsSpan(container: SourceSpan, contained: SourceSpan): boolean {
  return container.sourceId === contained.sourceId
    && container.startUtf16 <= contained.startUtf16
    && contained.endUtf16 <= container.endUtf16;
}

function compareOrdinal(left: string, right: string): number {
  return left < right ? -1 : left > right ? 1 : 0;
}

function compareJoinedEdges(left: JoinedIncludeEdge, right: JoinedIncludeEdge): number {
  const a = left.edge;
  const b = right.edge;
  return a.span.startUtf16 - b.span.startUtf16
    || a.span.endUtf16 - b.span.endUtf16
    || a.targetSpan.startUtf16 - b.targetSpan.startUtf16
    || a.targetSpan.endUtf16 - b.targetSpan.endUtf16
    || compareOrdinal(left.includeEntityId, right.includeEntityId)
    || compareOrdinal(a.toSourceId, b.toSourceId)
    || compareOrdinal(a.directive, b.directive)
    || compareOrdinal(a.targetRaw, b.targetRaw);
}

function physicalIncludeEntityId(span: SourceSpan): EntityId {
  return `ent:include@${span.sourceId}:${span.startUtf16}-${span.endUtf16}`;
}

function sha256Id(seed: string): string {
  return `occ:${createHash("sha256").update(seed, "utf8").digest("hex")}`;
}

function rootOccurrenceId(sourceId: SourceId): string {
  return sha256Id(`${ROOT_ID_DOMAIN}${sourceId}\n`);
}

function childOccurrenceId(
  parentOccurrenceId: string,
  includeEntityId: EntityId,
  sourceId: SourceId
): string {
  return sha256Id(
    `${CHILD_ID_DOMAIN}${parentOccurrenceId}\0${includeEntityId}\0${sourceId}\n`
  );
}

function physicalDefinitionSpans(entities: readonly CensusEntity[]): Map<SourceId, SourceSpan[]> {
  const result = new Map<SourceId, SourceSpan[]>();
  for (const entity of entities) {
    const physicalMacro = entity.kind === "macro-definition" && entity.dialect !== "configured";
    const physicalEnvironment = entity.kind === "environment-definition"
      && entity.mechanism !== "configured";
    if (!physicalMacro && !physicalEnvironment) continue;

    assertSpan(entity.span, `definition entity ${entity.id} span`);
    const spans = result.get(entity.span.sourceId) ?? [];
    spans.push(entity.span);
    result.set(entity.span.sourceId, spans);
  }
  for (const spans of result.values()) {
    spans.sort((a, b) => a.startUtf16 - b.startUtf16 || b.endUtf16 - a.endUtf16);
  }
  return result;
}

function joinExecutableEdges(
  entities: readonly CensusEntity[],
  includeEdges: readonly IncludeEdge[]
): Map<SourceId, JoinedIncludeEdge[]> {
  const includeEntitiesById = new Map<EntityId, CensusEntity[]>();
  for (const entity of entities) {
    if (entity.kind !== "include") continue;
    const rows = includeEntitiesById.get(entity.id) ?? [];
    rows.push(entity);
    includeEntitiesById.set(entity.id, rows);
  }

  const claimedEntityIds = new Set<EntityId>();
  const bySource = new Map<SourceId, JoinedIncludeEdge[]>();
  for (const edge of includeEdges) {
    if (edge.directive !== "input" && edge.directive !== "include") continue;
    if (edge.toSourceId === undefined) continue;

    assertRoutePart(edge.fromSourceId, "include edge fromSourceId");
    assertRoutePart(edge.toSourceId, "include edge toSourceId");
    assertRoutePart(edge.targetRaw, "include edge targetRaw");
    assertSpan(edge.span, `include edge ${edge.fromSourceId} span`);
    assertSpan(edge.targetSpan, `include edge ${edge.fromSourceId} targetSpan`);
    if (edge.span.sourceId !== edge.fromSourceId || edge.targetSpan.sourceId !== edge.fromSourceId) {
      fail(`include edge source does not agree with its spans at ${edge.fromSourceId}:${edge.span.startUtf16}`);
    }
    if (!containsSpan(edge.span, edge.targetSpan)) {
      fail(`include target span escapes its directive span at ${edge.fromSourceId}:${edge.span.startUtf16}`);
    }

    const includeEntityId = physicalIncludeEntityId(edge.span);
    const candidates = includeEntitiesById.get(includeEntityId) ?? [];
    if (candidates.length === 0) {
      fail(`resolved include edge has no canonical physical entity ${includeEntityId}`);
    }
    if (candidates.length !== 1) {
      fail(`resolved include edge has ${candidates.length} physical entities for ${includeEntityId}`);
    }
    const entity = candidates[0];
    if (entity.kind !== "include") fail(`entity ${includeEntityId} is not an include`);
    assertSpan(entity.span, `include entity ${includeEntityId} span`);
    if (
      !sameSpan(entity.span, edge.span)
      || entity.directive !== edge.directive
      || entity.targetRaw !== edge.targetRaw
      || entity.resolvedSourceId !== edge.toSourceId
    ) {
      fail(`include edge evidence contradicts physical entity ${includeEntityId}`);
    }
    if (claimedEntityIds.has(includeEntityId)) {
      fail(`multiple executable edges claim physical entity ${includeEntityId}`);
    }
    claimedEntityIds.add(includeEntityId);

    const joined: JoinedIncludeEdge = {
      edge: edge as IncludeEdge & { toSourceId: SourceId },
      includeEntityId,
    };
    const rows = bySource.get(edge.fromSourceId) ?? [];
    rows.push(joined);
    bySource.set(edge.fromSourceId, rows);
  }

  for (const rows of bySource.values()) rows.sort(compareJoinedEdges);
  return bySource;
}

/**
 * Plans occurrence routes without assigning the shared execution `seq` space.
 * Completed sources may be replayed; only a target on the active route is cut.
 */
export function planSourceOccurrences(input: PlanSourceOccurrencesInput): OccurrenceTopologyPlan {
  assertRoutePart(input.entrypoint, "entrypoint");
  assertLimit(input.maxOccurrences, "maxOccurrences", 1);
  assertLimit(input.maxDepth, "maxDepth", 0);

  const definitionsBySource = physicalDefinitionSpans(input.entities);
  const deferredBySource = new Map<SourceId, {
    span: SourceSpan;
    reason: "conditional" | "argument-body" | "unknown-context";
  }[]>();
  for (const context of input.deferredContexts ?? []) {
    assertSpan(context.span, "deferred context span");
    const rows = deferredBySource.get(context.span.sourceId) ?? [];
    rows.push(context);
    deferredBySource.set(context.span.sourceId, rows);
  }
  const edgesBySource = joinExecutableEdges(input.entities, input.includeEdges);
  const occurrences: PlannedSourceOccurrence[] = [];
  const trace: OccurrenceTraceEvent[] = [];
  const activeBySource = new Map<SourceId, string>();
  const occurrenceIds = new Set<string>();

  function append(
    sourceId: SourceId,
    depth: number,
    includeChain: SourceId[],
    parentOccurrenceId?: string,
    via?: JoinedIncludeEdge
  ): void {
    if (depth > input.maxDepth) {
      fail(`maxDepth ${input.maxDepth} exceeded by route to ${sourceId}`);
    }
    if (occurrences.length >= input.maxOccurrences) {
      fail(`maxOccurrences ${input.maxOccurrences} exceeded by route to ${sourceId}`);
    }

    const id = parentOccurrenceId && via
      ? childOccurrenceId(parentOccurrenceId, via.includeEntityId, sourceId)
      : rootOccurrenceId(sourceId);
    if (occurrenceIds.has(id)) fail(`duplicate or colliding occurrence route id ${id}`);
    occurrenceIds.add(id);

    const deferredByDefinition = via !== undefined && (definitionsBySource.get(via.edge.fromSourceId) ?? [])
      .some((span) => containsSpan(span, via.edge.span));
    const deferredContext = via === undefined ? undefined : (deferredBySource.get(via.edge.fromSourceId) ?? [])
      .filter((context) => containsSpan(context.span, via.edge.span))
      .sort((left, right) =>
        (left.span.endUtf16 - left.span.startUtf16) - (right.span.endUtf16 - right.span.startUtf16)
      )[0];
    const deferredReason = deferredByDefinition ? "definition-body" : deferredContext?.reason;
    const deferred = deferredReason !== undefined;
    const cycleTargetOccurrenceId = deferred ? undefined : activeBySource.get(sourceId);
    const state: PlannedSourceOccurrence["state"] = deferred
      ? "deferred-context"
      : cycleTargetOccurrenceId
        ? "cycle-cut"
        : "entered";

    const occurrence: PlannedSourceOccurrence = {
      id,
      sourceId,
      includeChain,
      basis: via ? "literal-directive" : "manifest-entrypoint",
      state,
      ...(parentOccurrenceId ? { parentOccurrenceId } : {}),
      ...(via ? { includeEntityId: via.includeEntityId } : {}),
      ...(cycleTargetOccurrenceId ? { cycleTargetOccurrenceId } : {}),
      ...(deferredReason ? { deferredReason } : {}),
    };
    occurrences.push(occurrence);
    trace.push({ phase: "enter", occurrenceId: id, sourceId, state, depth });

    if (state === "entered") {
      activeBySource.set(sourceId, id);
      try {
        for (const child of edgesBySource.get(sourceId) ?? []) {
          append(
            child.edge.toSourceId,
            depth + 1,
            [...includeChain, child.edge.toSourceId],
            id,
            child
          );
        }
      } finally {
        activeBySource.delete(sourceId);
      }
    }

    trace.push({ phase: "exit", occurrenceId: id, sourceId, state, depth });
  }

  append(input.entrypoint, 0, [input.entrypoint]);
  return {
    rootOccurrenceId: occurrences[0].id,
    occurrences,
    trace,
  };
}
