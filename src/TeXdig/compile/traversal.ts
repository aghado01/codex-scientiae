/**
 * TeXdig compile: the shared `seq` order space.
 *
 * Per contracts.ts, `seq` is ONE order space assigned during entrypoint
 * traversal across includes — walk nodes, zones, macro records, and pointer
 * sites are all order-comparable on the same scale, and macro shadowing
 * resolves on it. This module assigns it: depth-first through resolved
 * \input/\include edges in source order, enumerating span addresses.
 *
 * seq is a derived integer over span addresses: two objects at the same
 * address (overlays like an environment and its math carrier) deliberately
 * share one seq.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type { SourceId } from "../core/types.ts";
import type { IncludeEdge } from "../census/source-graph.ts";

export interface TraversalOrder {
  /** seq by `${sourceId}:${startUtf16}` address key. */
  seqByAddress: Map<string, number>;
  /** Files in first-reached order (diagnostic convenience). */
  fileOrder: SourceId[];
}

export function addressKey(sourceId: SourceId, startUtf16: number): string {
  return `${sourceId}:${startUtf16}`;
}

/**
 * Assign seq over the given span addresses.
 *
 * @param entrypoint      resolved entrypoint source id
 * @param startsBySource  every address wanting a seq, grouped per source
 * @param includeEdges    census include edges; only resolved \input/\include
 *                        edges into TRAVERSED sources recurse
 */
export function buildTraversalOrder(
  entrypoint: SourceId,
  startsBySource: Map<SourceId, number[]>,
  includeEdges: IncludeEdge[]
): TraversalOrder {
  const seqByAddress = new Map<string, number>();
  const fileOrder: SourceId[] = [];
  const visited = new Set<SourceId>();
  let counter = 0;

  const edgesBySource = new Map<SourceId, IncludeEdge[]>();
  for (const edge of includeEdges) {
    if (edge.directive !== "input" && edge.directive !== "include") continue;
    if (!edge.toSourceId) continue;
    const list = edgesBySource.get(edge.fromSourceId) || [];
    list.push(edge);
    edgesBySource.set(edge.fromSourceId, list);
  }
  for (const list of edgesBySource.values()) {
    list.sort((a, b) => a.span.startUtf16 - b.span.startUtf16);
  }

  function visit(sourceId: SourceId): void {
    if (visited.has(sourceId)) return; // one traversal per file (census reachability semantics)
    visited.add(sourceId);
    fileOrder.push(sourceId);

    const starts = [...(startsBySource.get(sourceId) || [])].sort((a, b) => a - b);
    const edges = edgesBySource.get(sourceId) || [];
    let edgeIdx = 0;

    for (const start of starts) {
      while (edgeIdx < edges.length && edges[edgeIdx].span.startUtf16 <= start) {
        const target = edges[edgeIdx].toSourceId!;
        // Assign the include site itself (it sits at the edge span start)
        // before descending, so the site precedes the included content.
        if (edges[edgeIdx].span.startUtf16 === start) {
          counter++;
          seqByAddress.set(addressKey(sourceId, start), counter);
        }
        visit(target);
        edgeIdx++;
      }
      const key = addressKey(sourceId, start);
      if (!seqByAddress.has(key)) {
        counter++;
        seqByAddress.set(key, counter);
      }
    }
    while (edgeIdx < edges.length) {
      visit(edges[edgeIdx].toSourceId!);
      edgeIdx++;
    }
  }

  visit(entrypoint);

  // Files unreachable by traversal (parsed .bbl arrives via \bibliography,
  // not \input) append after the traversal in stable name order: their
  // objects still need seq, explicitly AFTER the traversed document.
  const leftover = [...startsBySource.keys()]
    .filter((s) => !visited.has(s))
    .sort();
  for (const sourceId of leftover) {
    fileOrder.push(sourceId);
    for (const start of [...(startsBySource.get(sourceId) || [])].sort((a, b) => a - b)) {
      const key = addressKey(sourceId, start);
      if (!seqByAddress.has(key)) {
        counter++;
        seqByAddress.set(key, counter);
      }
    }
  }

  return { seqByAddress, fileOrder };
}
