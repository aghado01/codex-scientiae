/**
 * TeXdig compile: macros.jsonl — the compiled definition store (contract tier).
 *
 * One row per census macro-definition entity, per contracts.ts MacroRecord:
 * seq on the shared order space, body slice + span (knowable even when
 * expansion is not — \def/\let bodies included), direct definition
 * dependencies as def: ids, and the normalized-body fingerprint stamped at
 * emission (document-independent identity for the cross-corpus specimen
 * store; impossible to backfill consistently later).
 *
 * Normalization for the fingerprint is mechanical and derived: whitespace
 * runs collapse to one space, trimmed. No printRaw, no interpretation.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import crypto from "node:crypto";
import type { CensusEntity, SourceId } from "../core/types.ts";
import type { MacroRecord } from "../core/contracts.ts";
import { addressKey } from "./traversal.ts";
import { scanLatex } from "../census/scan-latex.ts";

export function compileMacroRecords(
  entities: CensusEntity[],
  rawContents: Map<SourceId, string>,
  seqByAddress: Map<string, number>
): MacroRecord[] {
  const definitions = entities.filter(
    (e): e is CensusEntity & { kind: "macro-definition" } => e.kind === "macro-definition"
  );

  // def: ids are span-addressed like ent: ids; configured declarations keep
  // their pseudo-source locator so the id stays deterministic and unique.
  const defIdByEntityId = new Map<string, string>();
  const defIdsByName = new Map<string, { seq: number; defId: string }[]>();
  const records: MacroRecord[] = [];

  for (const def of definitions) {
    const isConfigured = def.dialect === "configured";
    const defId = isConfigured
      ? def.id.replace(/^ent:macro-definition@/, "def:")
      : `def:${def.span.sourceId}:${def.span.startUtf16}-${def.span.endUtf16}`;
    defIdByEntityId.set(def.id, defId);
    // Configured declarations sit BEFORE the traversal (seq -1): a document's
    // own definition always shadows a package declaration.
    const seq = isConfigured
      ? -1
      : seqByAddress.get(addressKey(def.span.sourceId, def.span.startUtf16)) ?? -1;
    const list = defIdsByName.get(def.definedName) || [];
    list.push({ seq, defId });
    defIdsByName.set(def.definedName, list);
  }

  for (const def of definitions) {
    const isConfigured = def.dialect === "configured";
    const raw = rawContents.get(def.span.sourceId);
    const bodyText =
      !isConfigured && def.bodySpan && raw
        ? raw.slice(def.bodySpan.startUtf16, def.bodySpan.endUtf16)
        : undefined;

    // Direct dependencies: control sequences lexically witnessed in the body
    // that resolve to an in-document definition, scoped at THIS definition's
    // own position on the shared scale (the governing definition preceding
    // it; call-time rebinding is a zone-level concern). Lexical scan keeps
    // this uniform across dialects (\def bodies included).
    const ownSeq = isConfigured
      ? -1
      : seqByAddress.get(addressKey(def.span.sourceId, def.span.startUtf16)) ?? -1;
    const deps: string[] = [];
    if (bodyText) {
      const seen = new Set<string>();
      for (const sighting of scanLatex(def.span.sourceId, bodyText).sightings) {
        const name = sighting.name || "";
        if (!name || name === def.definedName || seen.has(name)) continue;
        seen.add(name);
        const candidates = defIdsByName.get(name);
        if (candidates && candidates.length > 0) {
          const sorted = [...candidates].sort((a, b) => a.seq - b.seq);
          let governing = sorted.findLast((c) => c.seq < ownSeq);
          if (!governing) governing = sorted.at(-1)!; // forward reference: call-time binding
          deps.push(governing.defId);
        }
      }
      deps.sort();
    }

    const normalized = (bodyText ?? def.signatureRaw ?? "").replace(/\s+/g, " ").trim();
    const fingerprint = crypto.createHash("sha256").update(normalized, "utf8").digest("hex");

    records.push({
      id: defIdByEntityId.get(def.id)!,
      seq: ownSeq,
      definedName: def.definedName,
      dialect: def.dialect,
      signatureRaw: def.signatureRaw,
      bodySpan: def.bodySpan,
      bodyText,
      elaborable: def.elaborable,
      deps,
      fingerprint,
      entityId: def.id,
    });
  }

  records.sort((a, b) => a.seq - b.seq || a.id.localeCompare(b.id));
  return records;
}
