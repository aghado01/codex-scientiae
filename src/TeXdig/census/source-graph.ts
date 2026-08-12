/**
 * TeXdig census source graph builder.
 *
 * Discovers files in the deposited tree, classifies file roles, resolves
 * the include and bibliography resource graph over stratified text,
 * detects casing mismatches, and identifies unreachable .tex sources.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import type {
  SourceId,
  SourceFileRecord,
  SourceLanguage,
  SourceRole,
  IncludeDirective,
  SourceSpan,
  Diagnostic,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import { stratify, type StratificationResult } from "./stratify.ts";

export interface IncludeEdge {
  fromSourceId: SourceId;
  toSourceId?: SourceId;
  directive: IncludeDirective;
  targetRaw: string;
  /** Full directive site: csname through closing brace / bare-word target. */
  span: SourceSpan;
  /** The individual target token — distinct from `span` for comma lists. */
  targetSpan: SourceSpan;
}

export interface SourceGraphResult {
  sources: SourceFileRecord[];
  sourcesMap: Map<SourceId, SourceFileRecord>;
  rawContents: Map<SourceId, string>;
  stratifications: Map<SourceId, StratificationResult>;
  includeEdges: IncludeEdge[];
  diagnostics: Diagnostic[];
  /** On-disk-cased entrypoint id, when the manifest entrypoint resolved. */
  entrypointResolved?: SourceId;
}

function normalizePosix(p: string): string {
  return p.replace(/\\/g, "/");
}

function computeSha256(buffer: Buffer): string {
  return crypto.createHash("sha256").update(buffer).digest("hex");
}

function getLanguage(ext: string): SourceLanguage {
  const lower = ext.toLowerCase();
  if (lower === ".tex" || lower === ".bbl" || lower === ".sty" || lower === ".cls" || lower === ".clo" || lower === ".dtx" || lower === ".ins") {
    return "latex";
  }
  if (lower === ".bib" || lower === ".bst") {
    return "bibtex";
  }
  return "asset";
}

export function buildSourceGraph(treeDir: string, entrypointRel: string): SourceGraphResult {
  const resolvedTreeDir = path.resolve(treeDir);
  const normalizedEntrypoint = normalizePosix(entrypointRel);

  // 1. Enumerate all files in the tree
  const onDiskFiles: { relPath: string; fullPath: string; ext: string }[] = [];

  function walk(dir: string) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(fullPath);
      } else if (entry.isFile()) {
        const relPath = normalizePosix(path.relative(resolvedTreeDir, fullPath));
        const ext = path.extname(entry.name);
        onDiskFiles.push({ relPath, fullPath, ext });
      }
    }
  }

  walk(resolvedTreeDir);

  // Map of lowercase relative path -> actual on-disk relative path
  const lowerToActualPath = new Map<string, string>();
  for (const f of onDiskFiles) {
    lowerToActualPath.set(f.relPath.toLowerCase(), f.relPath);
  }

  const rawContents = new Map<SourceId, string>();
  const stratifications = new Map<SourceId, StratificationResult>();
  const fileBuffers = new Map<SourceId, Buffer>();
  const diagnostics: Diagnostic[] = [];

  // Read contents, compute SHA and UTF-16 length
  const fileRecords: SourceFileRecord[] = [];
  const fileRecordsMap = new Map<SourceId, SourceFileRecord>();

  for (const f of onDiskFiles) {
    const buffer = fs.readFileSync(f.fullPath);
    fileBuffers.set(f.relPath, buffer);
    const sha256 = computeSha256(buffer);
    const language = getLanguage(f.ext);

    let lengthUtf16 = 0;
    if (language === "latex" || language === "bibtex") {
      try {
        const text = buffer.toString("utf-8");
        rawContents.set(f.relPath, text);
        lengthUtf16 = text.length;
        if (f.ext.toLowerCase() === ".tex" || f.ext.toLowerCase() === ".bbl") {
          const strat = stratify(f.relPath, text);
          stratifications.set(f.relPath, strat);
          diagnostics.push(...strat.diagnostics);
        }
      } catch (err) {
        // Fallback length
        lengthUtf16 = buffer.length;
      }
    } else {
      lengthUtf16 = buffer.length;
    }

    const record: SourceFileRecord = {
      id: f.relPath,
      sha256,
      lengthUtf16,
      language,
      role: "asset", // Initial default, refined below
      parsed: false,
    };
    fileRecords.push(record);
    fileRecordsMap.set(f.relPath, record);
  }

  // 2. Resolve Include Graph starting from Entrypoint
  const includeEdges: IncludeEdge[] = [];
  const reachableTex = new Set<SourceId>();
  const referencedBibs = new Set<SourceId>();
  const referencedBsts = new Set<SourceId>();

  function resolveTargetFile(fromSourceId: SourceId, targetRaw: string, allowedExts: string[]): { resolvedId?: SourceId; caseMismatch: boolean } {
    const trimmed = targetRaw.trim();
    if (!trimmed) return { caseMismatch: false };

    const containingDir = path.posix.dirname(fromSourceId);
    const candidates: string[] = [];

    // Candidate 1: relative to containing file
    const relToContaining = containingDir === "." ? trimmed : path.posix.join(containingDir, trimmed);
    candidates.push(relToContaining);

    // Candidate 2: relative to root
    if (containingDir !== ".") {
      candidates.push(trimmed);
    }

    for (const cand of candidates) {
      // Try exact, then with each allowed extension
      const probeList = [cand];
      for (const ext of allowedExts) {
        if (!cand.toLowerCase().endsWith(ext.toLowerCase())) {
          probeList.push(cand + ext);
        }
      }

      for (const probe of probeList) {
        const lowerProbe = probe.toLowerCase();
        if (lowerToActualPath.has(lowerProbe)) {
          const actualPath = lowerToActualPath.get(lowerProbe)!;
          const caseMismatch = actualPath !== probe;
          return { resolvedId: actualPath, caseMismatch };
        }
      }
    }

    return { caseMismatch: false };
  }

  // Matches: \input{foo}, \input foo, \include{foo}, \subfile{foo}, \bibliography{foo,bar}, \addbibresource{foo.bib}, \bibliographystyle{plain}
  const DIRECTIVE_PATTERN = /\\(input|include|subfile|bibliography|addbibresource|bibliographystyle)(?:\{([^}]+)\}|\s+([a-zA-Z0-9_./\-]+))/g;

  function scanIncludes(sourceId: SourceId) {
    if (reachableTex.has(sourceId)) return;
    reachableTex.add(sourceId);

    const strat = stratifications.get(sourceId);
    const textToScan = strat ? strat.stratifiedText : rawContents.get(sourceId);
    if (!textToScan) return;

    // A fresh regex per call: scanIncludes recurses into included files, and a
    // shared lastIndex would be clobbered by the nested scan, rescanning the
    // parent from position 0 and duplicating every edge and diagnostic.
    const directiveRegex = new RegExp(DIRECTIVE_PATTERN.source, "g");
    let match: RegExpExecArray | null;

    while ((match = directiveRegex.exec(textToScan)) !== null) {
      const dirName = match[1];
      const targetPayload = match[2] || match[3] || "";
      const matchStart = match.index;
      const matchEnd = match.index + match[0].length;
      const span: SourceSpan = {
        sourceId,
        startUtf16: matchStart,
        endUtf16: matchEnd,
      };
      // Offset of the payload within the match: after "{" for the braced form,
      // at the tail for the bare-word form.
      const payloadStart = match[2] !== undefined
        ? matchStart + match[0].indexOf("{") + 1
        : matchEnd - targetPayload.length;

      let directive: IncludeDirective;
      if (dirName === "input") directive = "input";
      else if (dirName === "include" || dirName === "subfile") directive = "include";
      else if (dirName === "bibliography") directive = "bibliography";
      else if (dirName === "addbibresource") directive = "addbibresource";
      else if (dirName === "bibliographystyle") directive = "bibliographystyle";
      else continue;

      // Comma-separated targets (e.g. \bibliography{main,extra}), each with its
      // own token span inside the payload.
      const rawTargets: { targetRaw: string; targetSpan: SourceSpan }[] = [];
      let cursor = 0;
      for (const piece of targetPayload.split(",")) {
        const leading = piece.length - piece.trimStart().length;
        const targetRaw = piece.trim();
        if (targetRaw) {
          const tokenStart = payloadStart + cursor + leading;
          rawTargets.push({
            targetRaw,
            targetSpan: {
              sourceId,
              startUtf16: tokenStart,
              endUtf16: tokenStart + targetRaw.length,
            },
          });
        }
        cursor += piece.length + 1; // +1 for the comma
      }

      for (const { targetRaw, targetSpan } of rawTargets) {
        let allowedExts: string[] = [];
        if (directive === "input" || directive === "include") {
          allowedExts = [".tex"];
        } else if (directive === "bibliography" || directive === "addbibresource") {
          allowedExts = [".bib", ".tex"];
        } else if (directive === "bibliographystyle") {
          allowedExts = [".bst"];
        }

        const { resolvedId, caseMismatch } = resolveTargetFile(sourceId, targetRaw, allowedExts);

        if (caseMismatch && resolvedId) {
          diagnostics.push({
            code: DiagnosticCodes.IncludeCaseMismatch,
            severity: "warning",
            message: `Include target '${targetRaw}' resolved with case mismatch to on-disk file '${resolvedId}'`,
            span,
          });
        }

        if (!resolvedId) {
          diagnostics.push({
            code: DiagnosticCodes.UnresolvedInclude,
            severity: "warning",
            message: `Unresolved include target '${targetRaw}' in directive \\${dirName}`,
            span,
          });
        }

        includeEdges.push({
          fromSourceId: sourceId,
          toSourceId: resolvedId,
          directive,
          targetRaw,
          span,
          targetSpan,
        });

        if (resolvedId) {
          if (directive === "input" || directive === "include") {
            scanIncludes(resolvedId);
          } else if (directive === "bibliography" || directive === "addbibresource") {
            referencedBibs.add(resolvedId);
          } else if (directive === "bibliographystyle") {
            referencedBsts.add(resolvedId);
          }
        }
      }
    }
  }

  // Resolve the entrypoint. A missing entrypoint is a defect that stops the
  // census from meaning anything — never a silent no-op; a casing mismatch is
  // the same finding class as any include-case mismatch.
  const entrypointActual = lowerToActualPath.get(normalizedEntrypoint.toLowerCase());
  if (entrypointActual) {
    if (entrypointActual !== normalizedEntrypoint) {
      diagnostics.push({
        code: DiagnosticCodes.IncludeCaseMismatch,
        severity: "warning",
        message: `Manifest entrypoint '${normalizedEntrypoint}' resolved with case mismatch to on-disk file '${entrypointActual}'`,
      });
    }
    scanIncludes(entrypointActual);
  } else {
    diagnostics.push({
      code: DiagnosticCodes.EntrypointMissing,
      severity: "defect",
      message: `Manifest entrypoint '${normalizedEntrypoint}' does not resolve to any file in the deposited tree`,
    });
  }

  // 3. Classify Roles for all discovered files
  for (const record of fileRecords) {
    const ext = path.extname(record.id).toLowerCase();

    if (entrypointActual && record.id === entrypointActual) {
      record.role = "entrypoint";
      record.parsed = true;
    } else if (reachableTex.has(record.id)) {
      record.role = "included";
      record.parsed = true;
    } else if (ext === ".bbl") {
      record.role = "bbl-sidecar";
      record.parsed = true;
    } else if (ext === ".bib") {
      record.role = "bibliography-resource";
      record.parsed = true;
    } else if (ext === ".bst") {
      record.role = "bibliography-style";
      record.parsed = false;
    } else if (ext === ".cls" || ext === ".sty" || ext === ".clo") {
      record.role = "class-or-style";
      record.parsed = false;
    } else if (ext === ".tex") {
      record.role = "unreachable-tex";
      record.parsed = false;
      diagnostics.push({
        code: DiagnosticCodes.UnreachableSource,
        severity: "warning",
        message: `TeX file '${record.id}' is not reachable from entrypoint include graph`,
      });
    } else {
      record.role = "asset";
      record.parsed = false;
    }
  }

  return {
    sources: fileRecords,
    sourcesMap: fileRecordsMap,
    rawContents,
    stratifications,
    includeEdges,
    diagnostics,
    entrypointResolved: entrypointActual,
  };
}
