/**
 * TeXdig census source graph builder.
 *
 * One buffered inventory supplies file identities, the canonical tree
 * fingerprint, strict source decoding, and all downstream source text. Include
 * and bibliography resolution is literal, root-relative, and in-tree only.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { isUtf8 } from "node:buffer";
import type {
  SourceId,
  SourceFileRecord,
  SourceLanguage,
  IncludeDirective,
  SourceSpan,
  Diagnostic,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import { stratify, type StratificationResult } from "./stratify.ts";
import { scanDirectives } from "./scan-directives.ts";
import {
  compareSourcePaths,
  computeSourceTreeSha256,
  type SourceFingerprintRecord,
} from "./source-fingerprint.ts";

export interface IncludeEdge {
  fromSourceId: SourceId;
  toSourceId?: SourceId;
  directive: IncludeDirective;
  targetRaw: string;
  /** Full directive site: csname through closing brace / bare-word target. */
  span: SourceSpan;
  /** The individual target token, distinct from `span` for comma lists. */
  targetSpan: SourceSpan;
}

export interface SourceGraphResult {
  sources: SourceFileRecord[];
  sourcesMap: Map<SourceId, SourceFileRecord>;
  /** Exact one-read byte buffers for every inventoried source. */
  rawBuffers: Map<SourceId, Buffer>;
  rawContents: Map<SourceId, string>;
  stratifications: Map<SourceId, StratificationResult>;
  includeEdges: IncludeEdge[];
  diagnostics: Diagnostic[];
  /** Canonical fingerprint over the exact buffered inventory used by this graph. */
  treeSha256: string;
  treeFileCount: number;
  /** On-disk-cased entrypoint id, when the manifest entrypoint resolved. */
  entrypointResolved?: SourceId;
}

interface BufferedSource {
  relPath: SourceId;
  fullPath: string;
  ext: string;
  buffer: Buffer;
}

function normalizePosix(value: string): string {
  return value.replace(/\\/g, "/");
}

function computeSha256(buffer: Buffer): string {
  return crypto.createHash("sha256").update(buffer).digest("hex");
}

function getLanguage(ext: string): SourceLanguage {
  const lower = ext.toLowerCase();
  if (
    lower === ".tex" ||
    lower === ".bbl" ||
    lower === ".sty" ||
    lower === ".cls" ||
    lower === ".clo" ||
    lower === ".dtx" ||
    lower === ".ins"
  ) {
    return "latex";
  }
  if (lower === ".bib" || lower === ".bst") return "bibtex";
  return "asset";
}

function decodeUtf8(sourceId: SourceId, buffer: Buffer): string {
  if (!isUtf8(buffer)) {
    throw new Error(`Source '${sourceId}' is not valid UTF-8`);
  }
  // Buffer decoding preserves a leading U+FEFF and therefore the source's
  // exact JS-native coordinate space after validity has been established.
  return buffer.toString("utf8");
}

/**
 * Normalize a literal TeX target in the compile-root coordinate system.
 * Leading `./` is author syntax; every other dot segment and every platform-
 * specific or absolute spelling is rejected rather than smoothed over.
 */
function normalizeLiteralTarget(targetRaw: string): string | undefined {
  let candidate = targetRaw.trim();
  if (
    !candidate ||
    candidate.includes("\0") ||
    candidate.includes("\\") ||
    candidate.startsWith("/") ||
    /^[A-Za-z]:/.test(candidate) ||
    candidate.includes(":")
  ) {
    return undefined;
  }
  while (candidate.startsWith("./")) candidate = candidate.slice(2);
  if (!candidate) return undefined;
  const parts = candidate.split("/");
  if (parts.some((part) => !part || part === "." || part === "..")) return undefined;
  return parts.join("/");
}

export function buildSourceGraph(treeDir: string, entrypointRel: string): SourceGraphResult {
  const resolvedTreeDir = path.resolve(treeDir);
  const normalizedEntrypoint = normalizeLiteralTarget(normalizePosix(entrypointRel));

  // 1. Enumerate portable file addresses, then impose canonical ordinal order.
  const discovered: { relPath: SourceId; fullPath: string; ext: string }[] = [];
  function walk(directory: string) {
    for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
      const fullPath = path.join(directory, entry.name);
      if (entry.isDirectory()) {
        walk(fullPath);
      } else if (entry.isFile()) {
        const relPath = normalizePosix(path.relative(resolvedTreeDir, fullPath));
        discovered.push({ relPath, fullPath, ext: path.extname(entry.name) });
      } else {
        throw new Error(`Source tree contains a non-regular entry at '${fullPath}'`);
      }
    }
  }
  walk(resolvedTreeDir);
  if (discovered.length === 0) throw new Error(`Source tree is empty: '${resolvedTreeDir}'`);
  discovered.sort((left, right) => compareSourcePaths(left.relPath, right.relPath));

  // The deposit producer currently rejects collisions with .NET
  // OrdinalIgnoreCase. JavaScript has no exact equivalent for the full Unicode
  // repertoire, so this index preserves the established JS case-folding
  // behavior rather than silently narrowing the manifest's Unicode path
  // contract. ASCII TeX paths agree; full comparer parity is deferred.
  const lowerToActualPath = new Map<string, SourceId>();
  for (const file of discovered) {
    const portableKey = file.relPath.toLowerCase();
    const prior = lowerToActualPath.get(portableKey);
    if (prior !== undefined && prior !== file.relPath) {
      throw new Error(
        `Source tree contains duplicate or case-colliding paths: '${prior}' and '${file.relPath}'`
      );
    }
    lowerToActualPath.set(portableKey, file.relPath);
  }

  // 2. Buffer and fingerprint every file exactly once. Decoding is an
  // eligibility consequence below: only reached/parsed text must be valid
  // UTF-8. Unreached typed files remain byte-attested inventory.
  const buffered = new Map<SourceId, BufferedSource>();
  const rawBuffers = new Map<SourceId, Buffer>();
  const rawContents = new Map<SourceId, string>();
  const stratifications = new Map<SourceId, StratificationResult>();
  const diagnostics: Diagnostic[] = [];
  const fileRecords: SourceFileRecord[] = [];
  const fileRecordsMap = new Map<SourceId, SourceFileRecord>();
  const fingerprintRecords: SourceFingerprintRecord[] = [];

  for (const file of discovered) {
    const buffer = fs.readFileSync(file.fullPath);
    const measured: BufferedSource = { ...file, buffer };
    buffered.set(file.relPath, measured);
    rawBuffers.set(file.relPath, buffer);

    const sha256 = computeSha256(buffer);
    const language = getLanguage(file.ext);

    const record: SourceFileRecord = {
      id: file.relPath,
      sha256,
      bytes: buffer.length,
      language,
      role: "asset",
      parsed: false,
    };
    fileRecords.push(record);
    fileRecordsMap.set(file.relPath, record);
    fingerprintRecords.push({ path: file.relPath, bytes: buffer.length, sha256 });
  }
  const treeSha256 = computeSourceTreeSha256(fingerprintRecords);

  function ensureText(sourceId: SourceId, language: "latex" | "bibtex"): string {
    const record = fileRecordsMap.get(sourceId);
    const source = buffered.get(sourceId);
    if (!record || !source) throw new Error(`Resolved source '${sourceId}' is absent from inventory`);
    let text = rawContents.get(sourceId);
    if (text === undefined) {
      text = decodeUtf8(sourceId, source.buffer);
      rawContents.set(sourceId, text);
      record.lengthUtf16 = text.length;
    }
    record.language = language;
    return text;
  }

  function ensureLatexSource(sourceId: SourceId): StratificationResult {
    const existing = stratifications.get(sourceId);
    if (existing) return existing;
    const source = buffered.get(sourceId);
    if (!source) throw new Error(`Resolved LaTeX source '${sourceId}' is absent from inventory`);
    const text = ensureText(sourceId, "latex");
    const result = stratify(sourceId, text, {
      dialect: source.ext.toLowerCase() === ".bbl" ? "biblatex-bbl" : "latex",
    });
    stratifications.set(sourceId, result);
    diagnostics.push(...result.diagnostics);
    return result;
  }

  // 3. Resolve the include/resource graph from the manifest entrypoint.
  const includeEdges: IncludeEdge[] = [];
  const reachableTex = new Set<SourceId>();
  const referencedBibs = new Set<SourceId>();
  const referencedBsts = new Set<SourceId>();

  function resolveTargetFile(
    targetRaw: string,
    allowedExts: readonly string[]
  ): { resolvedId?: SourceId; caseMismatch: boolean } {
    const normalized = normalizeLiteralTarget(targetRaw);
    if (!normalized) return { caseMismatch: false };

    const probes = [normalized];
    for (const ext of allowedExts) {
      if (!normalized.toLowerCase().endsWith(ext.toLowerCase())) probes.push(normalized + ext);
    }
    for (const probe of probes) {
      const actualPath = lowerToActualPath.get(probe.toLowerCase());
      if (actualPath !== undefined) {
        return { resolvedId: actualPath, caseMismatch: actualPath !== probe };
      }
    }
    return { caseMismatch: false };
  }

  function scanIncludes(sourceId: SourceId) {
    if (reachableTex.has(sourceId)) return;
    reachableTex.add(sourceId);
    const stratification = ensureLatexSource(sourceId);

    for (const sighting of scanDirectives(sourceId, stratification.stratifiedText)) {
      for (const target of sighting.targets) {
        let allowedExts: readonly string[] = [];
        if (sighting.directive === "input" || sighting.directive === "include") {
          allowedExts = [".tex"];
        } else if (
          sighting.directive === "bibliography" ||
          sighting.directive === "addbibresource"
        ) {
          allowedExts = [".bib"];
        } else if (sighting.directive === "bibliographystyle") {
          allowedExts = [".bst"];
        }

        const { resolvedId, caseMismatch } = resolveTargetFile(target.targetRaw, allowedExts);
        if (caseMismatch && resolvedId) {
          diagnostics.push({
            code: DiagnosticCodes.IncludeCaseMismatch,
            severity: "warning",
            message: `Include target '${target.targetRaw}' resolved with case mismatch to on-disk file '${resolvedId}'`,
            span: sighting.span,
          });
        }
        if (!resolvedId) {
          diagnostics.push({
            code: DiagnosticCodes.UnresolvedInclude,
            severity: "warning",
            message: `Unresolved include target '${target.targetRaw}' in directive \\${sighting.command}`,
            span: sighting.span,
          });
        }

        includeEdges.push({
          fromSourceId: sourceId,
          toSourceId: resolvedId,
          directive: sighting.directive,
          targetRaw: target.targetRaw,
          span: sighting.span,
          targetSpan: target.targetSpan,
        });

        if (!resolvedId) continue;
        if (sighting.directive === "input" || sighting.directive === "include") {
          scanIncludes(resolvedId);
        } else if (
          sighting.directive === "bibliography" ||
          sighting.directive === "addbibresource"
        ) {
          ensureText(resolvedId, "bibtex");
          referencedBibs.add(resolvedId);
        } else if (sighting.directive === "bibliographystyle") {
          referencedBsts.add(resolvedId);
        }
      }
    }
  }

  const entrypointActual = normalizedEntrypoint
    ? lowerToActualPath.get(normalizedEntrypoint.toLowerCase())
    : undefined;
  if (entrypointActual) {
    if (entrypointActual !== normalizedEntrypoint) {
      diagnostics.push({
        code: DiagnosticCodes.IncludeCaseMismatch,
        severity: "warning",
        message: `Manifest entrypoint '${entrypointRel}' resolved with case mismatch to on-disk file '${entrypointActual}'`,
      });
    }
    scanIncludes(entrypointActual);
  } else {
    diagnostics.push({
      code: DiagnosticCodes.EntrypointMissing,
      severity: "defect",
      message: `Manifest entrypoint '${entrypointRel}' does not resolve to any file in the deposited tree`,
    });
  }

  const expectedBbl = entrypointActual?.replace(/\.tex$/i, ".bbl");
  const expectedBblActual = expectedBbl
    ? lowerToActualPath.get(expectedBbl.toLowerCase())
    : undefined;
  if (expectedBblActual) ensureLatexSource(expectedBblActual);

  // 4. Classify roles only after effective languages and reachability are known.
  for (const record of fileRecords) {
    const ext = path.extname(record.id).toLowerCase();
    if (entrypointActual && record.id === entrypointActual) {
      record.role = "entrypoint";
      record.parsed = true;
    } else if (reachableTex.has(record.id)) {
      record.role = "included";
      record.parsed = true;
    } else if (expectedBblActual && record.id === expectedBblActual) {
      record.role = "bbl-sidecar";
      record.parsed = true;
    } else if (ext === ".bbl") {
      record.role = "bbl-sidecar";
      diagnostics.push({
        code: DiagnosticCodes.UnreachableSource,
        severity: "warning",
        message: `.bbl '${record.id}' does not match the entrypoint jobname sidecar ('${expectedBbl ?? "no entrypoint"}'); the compiler would not read it — inventoried unparsed`,
      });
    } else if (referencedBibs.has(record.id)) {
      record.role = "bibliography-resource";
      record.parsed = true;
    } else if (ext === ".bib") {
      record.role = "bibliography-resource";
      diagnostics.push({
        code: DiagnosticCodes.UnreachableSource,
        severity: "warning",
        message: `.bib '${record.id}' is not referenced by any \\bibliography/\\addbibresource directive — inventoried unparsed`,
      });
    } else if (referencedBsts.has(record.id)) {
      record.role = "bibliography-style";
    } else if (ext === ".bst") {
      record.role = "bibliography-style";
      diagnostics.push({
        code: DiagnosticCodes.UnreachableSource,
        severity: "warning",
        message: `.bst '${record.id}' is not referenced by any \\bibliographystyle directive`,
      });
    } else if (ext === ".cls" || ext === ".sty" || ext === ".clo") {
      record.role = "class-or-style";
    } else if (ext === ".tex") {
      record.role = "unreachable-tex";
      diagnostics.push({
        code: DiagnosticCodes.UnreachableSource,
        severity: "warning",
        message: `TeX file '${record.id}' is not reachable from entrypoint include graph`,
      });
    } else {
      record.role = "asset";
    }

    if (!record.parsed) continue;
    if (record.lengthUtf16 === undefined) {
      throw new Error(`Parsed source '${record.id}' lacks a decoded UTF-16 length`);
    }
    if (record.language === "latex") {
      if (!rawContents.has(record.id) || !stratifications.has(record.id)) {
        throw new Error(`Parsed LaTeX source '${record.id}' lacks decoded/stratified text`);
      }
    } else if (record.language === "bibtex") {
      if (!rawContents.has(record.id)) {
        throw new Error(`Parsed BibTeX source '${record.id}' lacks decoded text`);
      }
    } else {
      throw new Error(`Parsed source '${record.id}' has unsupported language 'asset'`);
    }
  }

  return {
    sources: fileRecords,
    sourcesMap: fileRecordsMap,
    rawBuffers,
    rawContents,
    stratifications,
    includeEdges,
    diagnostics,
    treeSha256,
    treeFileCount: fileRecords.length,
    entrypointResolved: entrypointActual,
  };
}
