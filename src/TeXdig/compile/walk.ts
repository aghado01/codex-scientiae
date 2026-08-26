/**
 * TeXdig walk projection — the prose spine.
 *
 * Emits `walk.jsonl` (section | paragraph | anchor) and the minimal `zones.jsonl`
 * records anchors and inline refs point at. This is a PURE PROJECTION over
 * landed census stores: reading order comes from `SourceOccurrence`
 * enterSeq/exitSeq, hole locations come from `InvocationOccurrence.binding`,
 * and the fold consumes census entity kinds plus positive spine claims.
 *
 * No expansion. An unresolved invocation stays a hole and is never guessed.
 *
 * See issues/TeXdig/briefs/walk-projection-prose-spine-20260826_100238.md.
 *
 * Erasable-syntax TypeScript only (Node native type stripping).
 */

import { createHash } from "node:crypto";
import type {
  CensusEntity,
  EntityId,
  PillarClaim,
  SourceFileRecord,
  SourceId,
  SourceSpan,
} from "../core/types.ts";
import type {
  ContentPart,
  InvocationOccurrence,
  SourceOccurrence,
  WalkNode,
  ZoneKind,
  ZoneStub,
  ZoneUnresolved,
} from "../core/contracts.ts";

const WALK_ID_DOMAIN = "texdig/walk/0.4\n";
const ZONE_ID_DOMAIN = "texdig/zone/0.4\n";

export interface WalkInput {
  entities: CensusEntity[];
  claims: PillarClaim[];
  occurrences: SourceOccurrence[];
  invocations: InvocationOccurrence[];
  sources: SourceFileRecord[];
  rawContents: Map<SourceId, string>;
}

/** Per-occurrence walk-level ledger: prose + zones + residue tile the entered extent. */
export interface WalkCoverage {
  occurrenceId: string;
  sourceId: SourceId;
  lengthUtf16: number;
  /** Claimed into paragraph content or a section title. */
  proseUtf16: number;
  /** Claimed by a zone (anchored block or inline ref). */
  zoneUtf16: number;
  /** Subset of zoneUtf16 whose zone carries an `unresolved` verdict. */
  holeUtf16: number;
  /** Entered extent claimed by neither. */
  residueUtf16: number;
}

export interface WalkProjection {
  nodes: WalkNode[];
  zones: ZoneStub[];
  coverage: WalkCoverage[];
  /** holeUtf16 / lengthUtf16 across every entered occurrence. Falls as binding lands. */
  holeFraction: number;
}

function sha256Id(prefix: string, domain: string, seed: string): string {
  return `${prefix}:${createHash("sha256").update(domain + seed, "utf8").digest("hex")}`;
}

function compareOrdinal(left: string, right: string): number {
  return left < right ? -1 : left > right ? 1 : 0;
}

function spanLength(span: SourceSpan): number {
  return span.endUtf16 - span.startUtf16;
}

/** Sectioning level, deepest-last. `*` variants share their base level. */
const SECTION_LEVELS: Record<string, number> = {
  part: 0,
  chapter: 1,
  section: 2,
  subsection: 3,
  subsubsection: 4,
  paragraph: 5,
  subparagraph: 6,
};

function sectionLevel(command: string): number {
  const base = command.endsWith("*") ? command.slice(0, -1) : command;
  const level = SECTION_LEVELS[base];
  return level === undefined ? SECTION_LEVELS.section : level;
}

// ---------------------------------------------------------------------------
// Event stream
// ---------------------------------------------------------------------------

/**
 * `consumes` is the extent the event removes from the stream. A block anchor
 * consumes its whole body so interior entities and prose belong to the zone,
 * not the walk. An inline macro site consumes only its control-sequence token,
 * so argument prose keeps flowing into the paragraph.
 */
type WalkEvent =
  | { at: number; consumes: SourceSpan; rank: number; kind: "body-begin" }
  | { at: number; consumes: SourceSpan; rank: number; kind: "body-end" }
  | { at: number; consumes: SourceSpan; rank: number; kind: "section"; command: string; titleSpan?: SourceSpan }
  | { at: number; consumes: SourceSpan; rank: number; kind: "paragraph-break" }
  | { at: number; consumes: SourceSpan; rank: number; kind: "block"; zoneKind: ZoneKind }
  | { at: number; consumes: SourceSpan; rank: number; kind: "inline"; zoneKind: ZoneKind; unresolved?: ZoneUnresolved }
  | { at: number; consumes: SourceSpan; rank: number; kind: "include"; entityId: EntityId }
  | { at: number; consumes: SourceSpan; rank: number; kind: "prose" };

/**
 * Rank breaks ties at one offset. Lower runs first: a section command must be
 * seen before the prose of its own title, and a block fence before its interior.
 */
const RANK_BODY = 0;
const RANK_SECTION = 1;
const RANK_BLOCK = 2;
const RANK_INCLUDE = 3;
const RANK_PARAGRAPH_BREAK = 4;
const RANK_INLINE = 5;
const RANK_PROSE = 6;

function compareEvents(a: WalkEvent, b: WalkEvent): number {
  return a.at - b.at
    || b.consumes.endUtf16 - a.consumes.endUtf16
    || a.rank - b.rank
    || compareOrdinal(a.kind, b.kind);
}

// ---------------------------------------------------------------------------
// Projection
// ---------------------------------------------------------------------------

export function projectWalk(input: WalkInput): WalkProjection {
  const sourceLengths = new Map<SourceId, number>();
  for (const source of input.sources) {
    if (typeof source.lengthUtf16 === "number") sourceLengths.set(source.id, source.lengthUtf16);
  }

  const entitiesBySource = new Map<SourceId, CensusEntity[]>();
  for (const entity of input.entities) {
    const list = entitiesBySource.get(entity.span.sourceId);
    if (list) list.push(entity);
    else entitiesBySource.set(entity.span.sourceId, [entity]);
  }

  const proseBySource = new Map<SourceId, PillarClaim[]>();
  for (const claim of input.claims) {
    if (claim.pillar !== "spine") continue;
    if (claim.role !== "text-run" && claim.role !== "blank-run") continue;
    const list = proseBySource.get(claim.span.sourceId);
    if (list) list.push(claim);
    else proseBySource.set(claim.span.sourceId, [claim]);
  }

  // Occurrence tree, and the invocation replay keyed per (occurrence, entity).
  const childrenByParent = new Map<string, SourceOccurrence[]>();
  const roots: SourceOccurrence[] = [];
  for (const occ of input.occurrences) {
    if (occ.parentOccurrenceId === undefined) {
      roots.push(occ);
      continue;
    }
    const list = childrenByParent.get(occ.parentOccurrenceId);
    if (list) list.push(occ);
    else childrenByParent.set(occ.parentOccurrenceId, [occ]);
  }
  roots.sort((a, b) => a.enterSeq - b.enterSeq || compareOrdinal(a.id, b.id));
  for (const list of childrenByParent.values()) {
    list.sort((a, b) => a.enterSeq - b.enterSeq || compareOrdinal(a.id, b.id));
  }

  const invocationsByOccurrence = new Map<string, InvocationOccurrence[]>();
  const invocationByEntitySite = new Map<string, InvocationOccurrence>();
  for (const inv of input.invocations) {
    const list = invocationsByOccurrence.get(inv.occurrenceId);
    if (list) list.push(inv);
    else invocationsByOccurrence.set(inv.occurrenceId, [inv]);
    invocationByEntitySite.set(`${inv.occurrenceId}|${inv.entityId}`, inv);
  }

  const nodes: WalkNode[] = [];
  const zones: ZoneStub[] = [];
  const coverage: WalkCoverage[] = [];
  const zoneById = new Map<string, ZoneStub>();
  let seq = 0;

  // Open-paragraph state, threaded across the traversal so an include boundary
  // does not silently split a paragraph that continues in the parent file.
  let openContent: ContentPart[] = [];
  let openStart: SourceSpan | undefined;
  let openEnd: SourceSpan | undefined;
  let openOccurrence: SourceOccurrence | undefined;

  function mintZone(
    occ: SourceOccurrence,
    kind: ZoneKind,
    span: SourceSpan,
    unresolved?: ZoneUnresolved
  ): ZoneStub {
    const id = sha256Id(
      "zone",
      ZONE_ID_DOMAIN,
      `${occ.id}|${span.sourceId}|${span.startUtf16}-${span.endUtf16}|${kind}`
    );
    const existing = zoneById.get(id);
    if (existing) return existing;
    const raw = input.rawContents.get(span.sourceId);
    const zone: ZoneStub = {
      id,
      seq: seq++,
      kind,
      span,
      text: raw === undefined ? "" : raw.slice(span.startUtf16, span.endUtf16),
    };
    if (unresolved) zone.unresolved = unresolved;
    zoneById.set(id, zone);
    zones.push(zone);
    return zone;
  }

  function mintWalkId(occ: SourceOccurrence, kind: string, span: SourceSpan): string {
    return sha256Id(
      "walk",
      WALK_ID_DOMAIN,
      `${occ.id}|${kind}|${span.sourceId}|${span.startUtf16}-${span.endUtf16}`
    );
  }

  function closeParagraph(): void {
    if (openStart === undefined || openEnd === undefined || openOccurrence === undefined) {
      openContent = [];
      openStart = undefined;
      openEnd = undefined;
      openOccurrence = undefined;
      return;
    }
    const hasText = openContent.some(
      (part) => "ref" in part || ("text" in part && part.text.trim().length > 0)
    );
    if (hasText) {
      const span: SourceSpan = {
        sourceId: openStart.sourceId,
        startUtf16: openStart.startUtf16,
        endUtf16: openEnd.endUtf16,
      };
      nodes.push({
        id: mintWalkId(openOccurrence, "paragraph", span),
        seq: seq++,
        kind: "paragraph",
        content: openContent,
        span,
        includeChain: [...openOccurrence.includeChain],
      });
    }
    openContent = [];
    openStart = undefined;
    openEnd = undefined;
    openOccurrence = undefined;
  }

  function appendContent(occ: SourceOccurrence, span: SourceSpan, part: ContentPart): void {
    // A paragraph belongs to one occurrence; an include boundary closes it.
    if (openOccurrence !== undefined && openOccurrence.id !== occ.id) closeParagraph();
    if (openStart === undefined) {
      openStart = span;
      openOccurrence = occ;
    }
    openEnd = span;
    openContent.push(part);
  }

  function buildEvents(occ: SourceOccurrence): WalkEvent[] {
    const events: WalkEvent[] = [];
    const entities = entitiesBySource.get(occ.sourceId) ?? [];
    // A math environment yields both an `environment` fence and a `math` carrier
    // over the same extent (contract: overlays, not a partition). Emit one anchor.
    const mathCarrierSpans = new Set<string>();
    for (const entity of entities) {
      if (entity.kind === "math") {
        mathCarrierSpans.add(`${entity.span.startUtf16}-${entity.span.endUtf16}`);
      }
    }

    for (const entity of entities) {
      const span = entity.span;
      switch (entity.kind) {
        case "envelope-marker": {
          if (entity.marker === "begin-document") {
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_BODY, kind: "body-begin" });
            break;
          }
          if (entity.marker === "end-document") {
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_BODY, kind: "body-end" });
            break;
          }
          if (entity.marker !== "section") break;
          const command = entity.name ?? "section";
          const inv = invocationByEntitySite.get(`${occ.id}|${entity.id}`);
          let consumes = span;
          let titleSpan: SourceSpan | undefined;
          if (inv) {
            consumes = inv.span;
            for (const arg of inv.arguments) {
              if (arg.kind === "mandatory" && arg.source === "explicit" && arg.contentSpan) {
                titleSpan = arg.contentSpan;
                break;
              }
            }
          }
          events.push({ at: span.startUtf16, consumes, rank: RANK_SECTION, kind: "section", command, titleSpan });
          break;
        }
        case "paragraph-break":
          events.push({ at: span.startUtf16, consumes: span, rank: RANK_PARAGRAPH_BREAK, kind: "paragraph-break" });
          break;
        case "environment": {
          if (entity.role === "float") {
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_BLOCK, kind: "block", zoneKind: "float" });
          } else if (entity.role === "verbatim") {
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_BLOCK, kind: "block", zoneKind: "verbatim" });
          } else if (entity.role === "math") {
            // Deduped against the co-extensive math carrier below.
            if (!mathCarrierSpans.has(`${span.startUtf16}-${span.endUtf16}`)) {
              events.push({ at: span.startUtf16, consumes: span, rank: RANK_BLOCK, kind: "block", zoneKind: "math-display" });
            }
          } else if (entity.bodySpan) {
            // Generic and bibliography environments: consume the FENCES only.
            // Their interiors are ordinary prose and must keep flowing — what
            // the environment MEANS is a binding question, not a walk question.
            const beginFence: SourceSpan = {
              sourceId: span.sourceId,
              startUtf16: span.startUtf16,
              endUtf16: entity.bodySpan.startUtf16,
            };
            const endFence: SourceSpan = {
              sourceId: span.sourceId,
              startUtf16: entity.bodySpan.endUtf16,
              endUtf16: span.endUtf16,
            };
            if (spanLength(beginFence) > 0) {
              events.push({ at: beginFence.startUtf16, consumes: beginFence, rank: RANK_INLINE, kind: "inline", zoneKind: "macro-site" });
            }
            if (spanLength(endFence) > 0) {
              events.push({ at: endFence.startUtf16, consumes: endFence, rank: RANK_INLINE, kind: "inline", zoneKind: "macro-site" });
            }
          } else {
            // No witnessed interior: the whole extent is opaque, not prose.
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_BLOCK, kind: "block", zoneKind: "macro-site" });
          }
          break;
        }
        case "macro-definition":
        case "environment-definition":
          // Definition bodies are programs, never prose.
          events.push({ at: span.startUtf16, consumes: span, rank: RANK_BLOCK, kind: "block", zoneKind: "macro-site" });
          break;
        case "math":
          if (entity.mode === "display") {
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_BLOCK, kind: "block", zoneKind: "math-display" });
          } else {
            events.push({ at: span.startUtf16, consumes: span, rank: RANK_INLINE, kind: "inline", zoneKind: "math-inline" });
          }
          break;
        case "verbatim-inline":
          events.push({ at: span.startUtf16, consumes: span, rank: RANK_INLINE, kind: "inline", zoneKind: "verbatim" });
          break;
        case "include":
          events.push({ at: span.startUtf16, consumes: span, rank: RANK_INCLUDE, kind: "include", entityId: entity.id });
          break;
        default:
          break;
      }
    }

    // Macro sites are per-occurrence: the same source replayed twice can bind
    // differently, so holes are read from this occurrence's invocations.
    for (const inv of invocationsByOccurrence.get(occ.id) ?? []) {
      if (inv.siteKind !== "control-sequence") continue;
      const unresolved = unresolvedFor(inv);
      // Consume the binding-dependent HULL, not just the token. Whether a
      // macro passes its argument through as prose is exactly what binding
      // decides, so the walk must not launder argument text into the spine.
      // The hull's source text is preserved on the zone; C1 expansion replaces
      // the zone with real content and the hole fraction falls.
      const hull = spanLength(inv.span) > 0 ? inv.span : inv.siteSpan;
      events.push({
        at: hull.startUtf16,
        consumes: hull,
        rank: RANK_INLINE,
        kind: "inline",
        zoneKind: "macro-site",
        unresolved,
      });
    }

    for (const claim of proseBySource.get(occ.sourceId) ?? []) {
      events.push({ at: claim.span.startUtf16, consumes: claim.span, rank: RANK_PROSE, kind: "prose" });
    }

    events.sort(compareEvents);
    return events;
  }

  function unresolvedFor(inv: InvocationOccurrence): ZoneUnresolved | undefined {
    switch (inv.binding.state) {
      case "bound":
        return undefined;
      case "unbound":
        return { reason: "unbound", name: inv.name };
      case "indeterminate":
        return { reason: "indeterminate", name: inv.name, causeIds: [...inv.binding.causeIds] };
      case "deferred":
        return { reason: "deferred", name: inv.name, detail: inv.binding.reason };
      default:
        return undefined;
    }
  }

  function emitAnchor(occ: SourceOccurrence, zone: ZoneStub): void {
    closeParagraph();
    nodes.push({
      id: mintWalkId(occ, "anchor", zone.span),
      seq: seq++,
      kind: "anchor",
      zone: zone.id,
      span: zone.span,
      includeChain: [...occ.includeChain],
    });
  }

  function walkOccurrence(occ: SourceOccurrence, claimed: Map<SourceId, number[]>, inBodyInitial: boolean): void {
    const children = childrenByParent.get(occ.id) ?? [];
    const childByIncludeEntity = new Map<EntityId, SourceOccurrence[]>();
    for (const child of children) {
      if (child.includeEntityId === undefined) continue;
      const list = childByIncludeEntity.get(child.includeEntityId);
      if (list) list.push(child);
      else childByIncludeEntity.set(child.includeEntityId, [child]);
    }

    const raw = input.rawContents.get(occ.sourceId);
    const events = buildEvents(occ);
    let cursor = 0;
    let inBody = inBodyInitial;
    // Body extent is the ledger's denominator: the walk claims the manuscript,
    // not the preamble, so preamble bytes are not residue against it.
    let bodyOpenAt = inBodyInitial ? 0 : -1;
    const closeBody = (endAt: number): void => {
      if (bodyOpenAt < 0) return;
      let counters = claimed.get(occ.sourceId);
      if (!counters) {
        counters = [0, 0, 0, 0];
        claimed.set(occ.sourceId, counters);
      }
      counters[3] += Math.max(0, endAt - bodyOpenAt);
      bodyOpenAt = -1;
    };

    for (const event of events) {
      if (event.at < cursor) continue;
      // The preamble is not the manuscript. Everything before \begin{document}
      // and after \end{document} is macros/frontmatter-tier material, and its
      // argument text is not prose.
      if (event.kind === "body-begin") {
        inBody = true;
        if (bodyOpenAt < 0) bodyOpenAt = event.consumes.endUtf16;
        cursor = event.consumes.endUtf16;
        continue;
      }
      if (event.kind === "body-end") {
        closeParagraph();
        inBody = false;
        closeBody(event.consumes.startUtf16);
        cursor = event.consumes.endUtf16;
        continue;
      }
      if (!inBody) continue;
      switch (event.kind) {
        case "section": {
          closeParagraph();
          const title: ContentPart[] = [];
          if (event.titleSpan && raw !== undefined) {
            title.push({ text: raw.slice(event.titleSpan.startUtf16, event.titleSpan.endUtf16) });
          }
          nodes.push({
            id: mintWalkId(occ, "section", event.consumes),
            seq: seq++,
            kind: "section",
            command: event.command,
            level: sectionLevel(event.command),
            title,
            span: event.consumes,
            includeChain: [...occ.includeChain],
          });
          // T20: title content is inside the ledger like body prose.
          if (event.titleSpan) recordClaim(claimed, occ.sourceId, event.titleSpan, "prose");
          cursor = event.consumes.endUtf16;
          break;
        }
        case "paragraph-break":
          closeParagraph();
          cursor = event.consumes.endUtf16;
          break;
        case "block": {
          const zone = mintZone(occ, event.zoneKind, event.consumes);
          emitAnchor(occ, zone);
          recordClaim(claimed, occ.sourceId, event.consumes, "zone");
          cursor = event.consumes.endUtf16;
          break;
        }
        case "inline": {
          const zone = mintZone(occ, event.zoneKind, event.consumes, event.unresolved);
          appendContent(occ, event.consumes, { ref: zone.id });
          recordClaim(claimed, occ.sourceId, event.consumes, event.unresolved ? "hole" : "zone");
          cursor = event.consumes.endUtf16;
          break;
        }
        case "include": {
          const targets = childByIncludeEntity.get(event.entityId) ?? [];
          if (targets.length === 0) {
            cursor = event.consumes.endUtf16;
            break;
          }
          for (const child of targets) {
            if (child.state === "entered") {
              // Reached from inside the body, so the whole included file is body.
              walkOccurrence(child, claimed, true);
              continue;
            }
            // Cycle cuts and deferred contexts are whole missing subtrees, not
            // guesses: anchor the hole at the directive that would have entered.
            const zone = mintZone(occ, "unentered-source", event.consumes, {
              reason: "unentered-source",
              name: child.sourceId,
              detail: child.state === "cycle-cut" ? "cycle-cut" : (child.deferredReason ?? "deferred-context"),
            });
            emitAnchor(occ, zone);
            recordClaim(claimed, occ.sourceId, event.consumes, "hole");
          }
          cursor = event.consumes.endUtf16;
          break;
        }
        case "prose": {
          if (raw === undefined) break;
          const text = raw.slice(event.consumes.startUtf16, event.consumes.endUtf16);
          if (text.length === 0) break;
          appendContent(occ, event.consumes, { text });
          recordClaim(claimed, occ.sourceId, event.consumes, "prose");
          cursor = event.consumes.endUtf16;
          break;
        }
      }
    }

    // An included file ends without \end{document}; its body runs to EOF.
    closeBody(sourceLengths.get(occ.sourceId) ?? cursor);
  }

  // claimed[sourceId] is a flat triple-counter [prose, zone, hole] accumulator.
  function recordClaim(
    claimed: Map<SourceId, number[]>,
    sourceId: SourceId,
    span: SourceSpan,
    bucket: "prose" | "zone" | "hole"
  ): void {
    let counters = claimed.get(sourceId);
    if (!counters) {
      counters = [0, 0, 0, 0];
      claimed.set(sourceId, counters);
    }
    const length = spanLength(span);
    if (bucket === "prose") counters[0] += length;
    else if (bucket === "zone") counters[1] += length;
    else {
      counters[1] += length;
      counters[2] += length;
    }
  }

  // A deposit censused without \begin{document} (a bare fragment) has no
  // preamble to exclude; treat the whole tree as body rather than emitting
  // nothing at all.
  let hasBodyMarker = false;
  for (const entity of input.entities) {
    if (entity.kind === "envelope-marker" && entity.marker === "begin-document") {
      hasBodyMarker = true;
      break;
    }
  }

  for (const root of roots) {
    if (root.state !== "entered") continue;
    const claimed = new Map<SourceId, number[]>();
    walkOccurrence(root, claimed, !hasBodyMarker);
    closeParagraph();
    for (const [sourceId, counters] of [...claimed.entries()].sort((a, b) => compareOrdinal(a[0], b[0]))) {
      // Denominator is the BODY extent walked, not the whole file.
      const lengthUtf16 = counters[3];
      const proseUtf16 = counters[0];
      const zoneUtf16 = counters[1];
      const holeUtf16 = counters[2];
      coverage.push({
        occurrenceId: root.id,
        sourceId,
        lengthUtf16,
        proseUtf16,
        zoneUtf16,
        holeUtf16,
        residueUtf16: Math.max(0, lengthUtf16 - proseUtf16 - zoneUtf16),
      });
    }
  }

  let totalLength = 0;
  let totalHole = 0;
  for (const row of coverage) {
    totalLength += row.lengthUtf16;
    totalHole += row.holeUtf16;
  }

  return {
    nodes,
    zones,
    coverage,
    holeFraction: totalLength === 0 ? 0 : totalHole / totalLength,
  };
}

/**
 * The reading test: concatenate paragraph content in seq order. Refs render as
 * their zone's source text so the spine reads as prose; this is a debug view,
 * never a stored artifact.
 */
export function readWalkProse(projection: WalkProjection): string {
  const zoneText = new Map<string, string>();
  for (const zone of projection.zones) zoneText.set(zone.id, zone.text);
  const parts: string[] = [];
  for (const node of [...projection.nodes].sort((a, b) => a.seq - b.seq)) {
    if (node.kind === "section") {
      const title = node.title.map((p) => ("text" in p ? p.text : "")).join("");
      parts.push(`${"#".repeat(node.level + 1)} ${title}`);
    } else if (node.kind === "paragraph") {
      parts.push(node.content.map((p) => ("text" in p ? p.text : (zoneText.get(p.ref) ?? ""))).join(""));
    }
  }
  return parts.join("\n\n");
}
