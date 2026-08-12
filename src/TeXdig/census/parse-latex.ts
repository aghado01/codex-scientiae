/**
 * TeXdig parser witness for LaTeX and .bbl files using unified-latex.
 *
 * Runs two-pass parsing:
 * Pass 1: standard parse -> discover definitions & environment signatures
 * Pass 2: reparse with registered signatures -> extract parser witness sightings
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  WitnessRecord,
  DefinitionDialect,
} from "../core/types.ts";
import type { Dependencies } from "../core/loader.ts";

export interface ParserMacroDef {
  definedName: string;
  dialect: DefinitionDialect;
  signatureRaw?: string;
  bodySpan?: SourceSpan;
  span: SourceSpan;
  numArgs?: number;
  hasOptional?: boolean;
}

export interface ParserEnvDef {
  definedName: string;
  mechanism: "newtheorem" | "newenvironment" | "newfloat";
  signatureRaw?: string;
  counterRaw?: string;
  bodySpan?: SourceSpan;
  span: SourceSpan;
}

export interface ParserSighting {
  nodeType: string;
  name?: string;
  span?: SourceSpan;
  bodySpan?: SourceSpan;
  mode?: "inline" | "display";
  inMathMode?: boolean;
  argSpans?: SourceSpan[];
  rawNode?: any;
}

export interface ParseLatexResult {
  sourceId: SourceId;
  ast: any;
  sightings: ParserSighting[];
  macroDefinitions: ParserMacroDef[];
  envDefinitions: ParserEnvDef[];
  textRuns: SourceSpan[];
}

function extractNodeSpan(sourceId: SourceId, node: any): SourceSpan | undefined {
  if (node && node.position && node.position.start && node.position.end) {
    return {
      sourceId,
      startUtf16: node.position.start.offset,
      endUtf16: node.position.end.offset,
    };
  }
  return undefined;
}

function getArgContentSpan(sourceId: SourceId, arg: any): SourceSpan | undefined {
  if (!arg || !arg.content || arg.content.length === 0) {
    return undefined;
  }
  let minStart = Infinity;
  let maxEnd = -Infinity;

  for (const item of arg.content) {
    const s = extractNodeSpan(sourceId, item);
    if (s) {
      if (s.startUtf16 < minStart) minStart = s.startUtf16;
      if (s.endUtf16 > maxEnd) maxEnd = s.endUtf16;
    }
  }

  if (minStart !== Infinity && maxEnd !== -Infinity) {
    return { sourceId, startUtf16: minStart, endUtf16: maxEnd };
  }
  return undefined;
}

export function getEnvName(env: any): string {
  if (!env) return "";
  if (typeof env === "string") return env;
  if (typeof env === "object") {
    if (typeof env.content === "string") return env.content;
    if (Array.isArray(env.content)) {
      return env.content.map(getEnvName).join("");
    }
  }
  return String(env);
}

export function getMacroName(content: any): string {
  if (!content) return "";
  if (typeof content === "string") return content;
  if (typeof content === "object" && typeof content.content === "string") return content.content;
  return String(content);
}

export function parseLatex(
  sourceId: SourceId,
  rawText: string,
  deps: Dependencies
): ParseLatexResult {
  // -------------------------------------------------------------------------
  // Pass 1: Discover macro and environment definitions
  // -------------------------------------------------------------------------
  const defaultParser = deps.parse.getParser();
  let pass1Ast: any;
  try {
    pass1Ast = defaultParser.parse(rawText);
  } catch (e) {
    // If parse fails, return minimal AST
    pass1Ast = { type: "root", content: [] };
  }

  const macroDefs: ParserMacroDef[] = [];
  const envDefs: ParserEnvDef[] = [];

  const customMacros: Record<string, { signature: string }> = {};
  const customEnvs: Record<string, { signature: string }> = {};

  deps.visit.visit(pass1Ast, (node: any) => {
    if (!node) return;

    if (node.type === "macro") {
      const name = getMacroName(node.content);

      // Check \newcommand, \renewcommand, \providecommand
      if (
        name === "newcommand" ||
        name === "renewcommand" ||
        name === "providecommand"
      ) {
        const span = extractNodeSpan(sourceId, node) || {
          sourceId,
          startUtf16: 0,
          endUtf16: 0,
        };
        const args = node.args || [];
        // Typically: args[2] = macro name, args[3] = numArgs, args[4] = opt default, args[5] = body
        let definedName = "";
        let numArgs = 0;
        let hasOptional = false;

        const nameArg = args[2] || args[0];
        if (nameArg && nameArg.content && nameArg.content.length > 0) {
          const first = nameArg.content[0];
          definedName = getMacroName(first.content);
        }

        const numArg = args[3];
        if (numArg && numArg.content && numArg.content.length > 0) {
          const numStr = numArg.content.map((c: any) => getMacroName(c.content)).join("");
          numArgs = parseInt(numStr, 10) || 0;
        }

        const optArg = args[4];
        if (optArg && optArg.openMark === "[" && optArg.content && optArg.content.length > 0) {
          hasOptional = true;
        }

        const bodyArg = args[5] || args[args.length - 1];
        const bodySpan = bodyArg ? getArgContentSpan(sourceId, bodyArg) : undefined;

        let dialect: DefinitionDialect = "newcommand";
        if (name === "renewcommand") dialect = "renewcommand";
        if (name === "providecommand") dialect = "providecommand";

        if (definedName) {
          macroDefs.push({
            definedName,
            dialect,
            bodySpan,
            span,
            numArgs,
            hasOptional,
          });

          // Build signature string (e.g. 'o m' or 'm m')
          let sig = "";
          if (hasOptional) sig += "o ";
          const reqCount = hasOptional ? numArgs - 1 : numArgs;
          for (let k = 0; k < reqCount; k++) {
            sig += "m ";
          }
          if (sig.trim()) {
            customMacros[definedName] = { signature: sig.trim() };
          }
        }
      }

      // Check \newtheorem
      if (name === "newtheorem") {
        const span = extractNodeSpan(sourceId, node) || {
          sourceId,
          startUtf16: 0,
          endUtf16: 0,
        };
        const args = node.args || [];
        // Typically args[1] = env name
        let envName = "";
        const envArg = args[1] || args[0];
        if (envArg && envArg.content && envArg.content.length > 0) {
          envName = envArg.content.map((c: any) => getMacroName(c.content)).join("").trim();
        }

        if (envName) {
          envDefs.push({
            definedName: envName,
            mechanism: "newtheorem",
            span,
          });
          customEnvs[envName] = { signature: "o" }; // newtheorem environments take optional [Title]
        }
      }
    }
  });

  // -------------------------------------------------------------------------
  // Pass 2: Reparse with discovered signatures
  // -------------------------------------------------------------------------
  let ast: any;
  try {
    const configuredParser = deps.parse.getParser({
      macros: customMacros,
      environments: customEnvs,
    });
    ast = configuredParser.parse(rawText);
  } catch (e) {
    ast = pass1Ast;
  }

  // -------------------------------------------------------------------------
  // Collect sightings and text runs
  // -------------------------------------------------------------------------
  const sightings: ParserSighting[] = [];
  const textRuns: SourceSpan[] = [];

  deps.visit.visit(ast, (node: any, info: any) => {
    if (!node) return;

    const span = extractNodeSpan(sourceId, node);
    const inMathMode = info?.context?.inMathMode || false;

    if (node.type === "macro") {
      const argSpans: SourceSpan[] = [];
      if (node.args && Array.isArray(node.args)) {
        for (const arg of node.args) {
          const as = getArgContentSpan(sourceId, arg);
          if (as) argSpans.push(as);
        }
      }

      sightings.push({
        nodeType: "macro",
        name: getMacroName(node.content),
        span,
        inMathMode,
        argSpans: argSpans.length > 0 ? argSpans : undefined,
        rawNode: node,
      });
    } else if (node.type === "environment" || node.type === "mathenv") {
      const envName = getEnvName(node.env);
      sightings.push({
        nodeType: node.type,
        name: envName,
        span,
        inMathMode: inMathMode || node.type === "mathenv",
        rawNode: node,
      });
    } else if (node.type === "inlinemath") {
      sightings.push({
        nodeType: "inlinemath",
        mode: "inline",
        span,
        inMathMode: true,
        rawNode: node,
      });
    } else if (node.type === "displaymath") {
      sightings.push({
        nodeType: "displaymath",
        mode: "display",
        span,
        inMathMode: true,
        rawNode: node,
      });
    } else if (node.type === "comment") {
      sightings.push({
        nodeType: "comment",
        span,
        rawNode: node,
      });
    } else if (node.type === "string" || node.type === "whitespace" || node.type === "parbreak") {
      if (span && span.startUtf16 < span.endUtf16) {
        textRuns.push(span);
      }
    }
  });

  return {
    sourceId,
    ast,
    sightings,
    macroDefinitions: macroDefs,
    envDefinitions: envDefs,
    textRuns,
  };
}
