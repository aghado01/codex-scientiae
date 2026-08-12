/**
 * TeXdig parser witness for LaTeX and .bbl files using unified-latex.
 *
 * Two entry points, wired by the CLI:
 *   1. discoverDefinitions — pass 1 over ONE file: find macro and environment
 *      definitions across all knowable dialects, contribute signatures.
 *   2. parseLatexWitness — pass 2 over one file with the DOCUMENT-GLOBAL
 *      signature registry merged from every parsed file's discovery: a
 *      preamble definition must inform argument attachment in every included
 *      file, not just the file that declared it.
 *
 * Both passes consume STRATIFIED text (comments and verbatim masked to
 * whitespace, offsets preserved): stratification precedes everything, and the
 * parser witness must never census a verbatim interior as LaTeX.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  DefinitionDialect,
  Diagnostic,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import type { Dependencies } from "../core/loader.ts";

export interface ParserMacroDef {
  definedName: string;
  dialect: DefinitionDialect;
  signatureRaw?: string;
  bodySpan?: SourceSpan;
  /** Full definition site; a hull over attached args when the parser's macro node stops at the csname. */
  span: SourceSpan;
  spanSynthesized: boolean;
  elaborable: boolean;
}

export interface ParserEnvDef {
  definedName: string;
  mechanism: "newtheorem" | "newenvironment" | "newfloat";
  signatureRaw?: string;
  counterRaw?: string;
  bodySpan?: SourceSpan;
  span: SourceSpan;
  spanSynthesized: boolean;
}

export interface SignatureRegistry {
  macros: Record<string, { signature: string }>;
  environments: Record<string, { signature: string }>;
}

export interface DiscoveryResult {
  sourceId: SourceId;
  macroDefs: ParserMacroDef[];
  envDefs: ParserEnvDef[];
  /** This file's signature contributions (unified-latex signature vocabulary). */
  registry: SignatureRegistry;
  /**
   * Start offsets of control-sequence tokens that ARE a definition site — the
   * defining command and the defined-name token. These are censused as the
   * definition entity, never additionally as macro-invocations (a definition's
   * name token is a mention, not a use).
   */
  definitionTokenStarts: Set<number>;
}

export interface ParserArgSpan {
  span: SourceSpan;
  /** True for real `{...}`/`[...]` args; false for implicit attachments (star tokens, list-item bodies) which must never stretch a hull. */
  bracketed: boolean;
}

export interface ParserSighting {
  nodeType: string;
  name?: string;
  span?: SourceSpan;
  /** Interior extent for environment nodes. */
  bodySpan?: SourceSpan;
  mode?: "inline" | "display";
  inMathMode?: boolean;
  args?: ParserArgSpan[];
}

export interface WitnessResult {
  sourceId: SourceId;
  sightings: ParserSighting[];
  textRuns: SourceSpan[];
  diagnostics: Diagnostic[];
}

// ---------------------------------------------------------------------------
// Node helpers
// ---------------------------------------------------------------------------

function nodeSpan(sourceId: SourceId, node: any): SourceSpan | undefined {
  if (node && node.position && node.position.start && node.position.end) {
    return {
      sourceId,
      startUtf16: node.position.start.offset,
      endUtf16: node.position.end.offset,
    };
  }
  return undefined;
}

/** Hull over the positioned content of one argument (Argument nodes carry no position of their own). */
function argContentSpan(sourceId: SourceId, arg: any): SourceSpan | undefined {
  if (!arg || !Array.isArray(arg.content) || arg.content.length === 0) return undefined;
  let minStart = Infinity;
  let maxEnd = -Infinity;
  for (const item of arg.content) {
    const s = nodeSpan(sourceId, item);
    if (s) {
      if (s.startUtf16 < minStart) minStart = s.startUtf16;
      if (s.endUtf16 > maxEnd) maxEnd = s.endUtf16;
    }
  }
  if (minStart === Infinity) return undefined;
  return { sourceId, startUtf16: minStart, endUtf16: maxEnd };
}

function isBracketed(arg: any): boolean {
  return arg && (arg.openMark === "{" || arg.openMark === "[");
}

/** First macro node in an argument's content, if any (the `\pair` of `{\pair}`). */
function firstMacroInArg(arg: any): any | undefined {
  if (!arg || !Array.isArray(arg.content)) return undefined;
  for (const item of arg.content) {
    if (item && item.type === "macro") return item;
  }
  return undefined;
}

/** Concatenated string content of an argument (`{myenv}` → "myenv"). */
function stringContentOfArg(arg: any): string {
  if (!arg || !Array.isArray(arg.content)) return "";
  let out = "";
  for (const item of arg.content) {
    if (item && item.type === "string" && typeof item.content === "string") out += item.content;
  }
  return out.trim();
}

function getMacroName(node: any): string {
  if (!node) return "";
  if (typeof node.content === "string") return node.content;
  return String(node.content ?? "");
}

export function getEnvName(env: any): string {
  if (!env) return "";
  if (typeof env === "string") return env;
  if (typeof env === "object") {
    if (typeof env.content === "string") return env.content;
    if (Array.isArray(env.content)) return env.content.map(getEnvName).join("");
  }
  return String(env);
}

/**
 * Definition-site full extent: the command node's span, stretched over every
 * bracketed argument's content, plus the closing delimiter actually present in
 * the text. Implicit args never stretch a hull (that is how `\bibitem`'s
 * item-body attachment would swallow a whole bibliography item).
 */
function definitionHull(
  sourceId: SourceId,
  text: string,
  commandSpan: SourceSpan,
  args: any[]
): { span: SourceSpan; synthesized: boolean } {
  let end = commandSpan.endUtf16;
  for (const arg of args || []) {
    if (!isBracketed(arg)) continue;
    const cs = argContentSpan(sourceId, arg);
    if (!cs) continue;
    let argEnd = cs.endUtf16;
    if (argEnd < text.length && (text[argEnd] === "}" || text[argEnd] === "]")) {
      argEnd++;
    }
    if (argEnd > end) end = argEnd;
  }
  const synthesized = end > commandSpan.endUtf16;
  return {
    span: { sourceId, startUtf16: commandSpan.startUtf16, endUtf16: end },
    synthesized,
  };
}

// ---------------------------------------------------------------------------
// Pass 1: definition discovery
// ---------------------------------------------------------------------------

const NEWCOMMAND_FAMILY: Record<string, DefinitionDialect> = {
  newcommand: "newcommand",
  renewcommand: "renewcommand",
  providecommand: "providecommand",
};

const XPARSE_FAMILY = new Set([
  "NewDocumentCommand",
  "RenewDocumentCommand",
  "ProvideDocumentCommand",
]);

const DEF_PRIMITIVES = new Set(["def", "gdef", "edef", "xdef"]);

const ENVDEF_MECHANISMS: Record<string, "newtheorem" | "newenvironment" | "newfloat"> = {
  newtheorem: "newtheorem",
  newenvironment: "newenvironment",
  renewenvironment: "newenvironment",
  newfloat: "newfloat",
};

/** Recursively visit every content array (root, groups, environments, math, argument contents) with sibling context. */
function walkContentArrays(nodes: any, visitArray: (arr: any[]) => void): void {
  if (!Array.isArray(nodes)) return;
  visitArray(nodes);
  for (const n of nodes) {
    if (!n || typeof n !== "object") continue;
    if (Array.isArray(n.content)) walkContentArrays(n.content, visitArray);
    if (Array.isArray(n.args)) {
      for (const a of n.args) {
        if (a && Array.isArray(a.content)) walkContentArrays(a.content, visitArray);
      }
    }
  }
}

function isWhitespaceNode(n: any): boolean {
  return n && (n.type === "whitespace" || n.type === "parbreak" || n.type === "comment");
}

/** Signature string for n args with/without a leading optional (unified-latex vocabulary). */
function buildSignature(numArgs: number, hasOptional: boolean): string {
  const parts: string[] = [];
  if (hasOptional) parts.push("o");
  const mandatory = hasOptional ? numArgs - 1 : numArgs;
  for (let k = 0; k < mandatory; k++) parts.push("m");
  return parts.join(" ");
}

export function discoverDefinitions(
  sourceId: SourceId,
  text: string,
  deps: Dependencies
): DiscoveryResult {
  const result: DiscoveryResult = {
    sourceId,
    macroDefs: [],
    envDefs: [],
    registry: { macros: {}, environments: {} },
    definitionTokenStarts: new Set(),
  };

  let ast: any;
  try {
    ast = deps.parse.getParser().parse(text);
  } catch {
    // The witness pass reports the parse failure; discovery just has nothing.
    return result;
  }

  const markDefinitionTokens = (commandNode: any, nameNode: any) => {
    const cSpan = nodeSpan(sourceId, commandNode);
    if (cSpan) result.definitionTokenStarts.add(cSpan.startUtf16);
    const nSpan = nodeSpan(sourceId, nameNode);
    if (nSpan) result.definitionTokenStarts.add(nSpan.startUtf16);
  };

  walkContentArrays(ast.content, (arr) => {
    for (let i = 0; i < arr.length; i++) {
      const node = arr[i];
      if (!node || node.type !== "macro") continue;
      const name = getMacroName(node);
      const cmdSpan = nodeSpan(sourceId, node);
      if (!cmdSpan) continue;

      const args: any[] = Array.isArray(node.args) ? node.args : [];
      const braceArgs = args.filter((a) => a && a.openMark === "{");
      const bracketArgs = args.filter((a) => a && a.openMark === "[");

      // --- \newcommand family (parser-attached args) ---------------------
      if (name in NEWCOMMAND_FAMILY) {
        const nameNode = firstMacroInArg(braceArgs[0]);
        const definedName = nameNode ? getMacroName(nameNode) : stringContentOfArg(braceArgs[0]);
        if (!definedName) continue;
        const numArgs = parseInt(stringContentOfArg(bracketArgs[0]), 10) || 0;
        const hasOptional = bracketArgs.length > 1;
        const bodySpan = argContentSpan(sourceId, braceArgs[1]);
        const { span, synthesized } = definitionHull(sourceId, text, cmdSpan, args);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          definedName,
          dialect: NEWCOMMAND_FAMILY[name],
          signatureRaw: buildSignature(numArgs, hasOptional) || undefined,
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
        });
        const sig = buildSignature(numArgs, hasOptional);
        if (sig) result.registry.macros[definedName] = { signature: sig };
        continue;
      }

      // --- \DeclareMathOperator{\X}{body} ---------------------------------
      if (name === "DeclareMathOperator") {
        const nameNode = firstMacroInArg(braceArgs[0]);
        if (!nameNode) continue;
        const bodySpan = argContentSpan(sourceId, braceArgs[1]);
        const { span, synthesized } = definitionHull(sourceId, text, cmdSpan, args);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          definedName: getMacroName(nameNode),
          dialect: "math-operator",
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
        });
        continue;
      }

      // --- \DeclarePairedDelimiter{\X}{left}{right} -----------------------
      if (name === "DeclarePairedDelimiter") {
        const nameNode = firstMacroInArg(braceArgs[0]);
        if (!nameNode) continue;
        const left = argContentSpan(sourceId, braceArgs[1]);
        const right = argContentSpan(sourceId, braceArgs[2]);
        const bodySpan = left && right
          ? { sourceId, startUtf16: left.startUtf16, endUtf16: right.endUtf16 }
          : left || right;
        const { span, synthesized } = definitionHull(sourceId, text, cmdSpan, args);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          definedName: getMacroName(nameNode),
          dialect: "paired-delimiter",
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
        });
        // Paired delimiters take one starred/sized use form; registering `o m`
        // would misparse common `\ceil{x}` and `\ceil*{x}` alike — leave
        // attachment to the generic path.
        continue;
      }

      // --- xparse \NewDocumentCommand{\X}{spec}{body} ---------------------
      if (XPARSE_FAMILY.has(name)) {
        const nameNode = firstMacroInArg(braceArgs[0]);
        if (!nameNode) continue;
        const specSpan = argContentSpan(sourceId, braceArgs[1]);
        const signatureRaw = specSpan
          ? text.slice(specSpan.startUtf16, specSpan.endUtf16).trim()
          : undefined;
        const bodySpan = argContentSpan(sourceId, braceArgs[2]);
        const { span, synthesized } = definitionHull(sourceId, text, cmdSpan, args);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          definedName: getMacroName(nameNode),
          dialect: "xparse",
          signatureRaw,
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
        });
        // xparse specs use the same letter vocabulary unified-latex signatures
        // do; simple specs register directly, exotic ones are skipped.
        if (signatureRaw && /^[somO\s{}\w]*$/.test(signatureRaw)) {
          const simple = signatureRaw.replace(/\s+/g, " ").trim();
          if (/^[som]( [som])*$/.test(simple)) {
            result.registry.macros[getMacroName(nameNode)] = { signature: simple };
          }
        }
        continue;
      }

      // --- TeX primitives: \def\X<params>{body}, \let\X\Y -----------------
      if (DEF_PRIMITIVES.has(name) || name === "let") {
        let j = i + 1;
        while (j < arr.length && isWhitespaceNode(arr[j])) j++;
        const nameNode = arr[j];
        if (!nameNode || nameNode.type !== "macro") continue;
        const nameSpan = nodeSpan(sourceId, nameNode);
        if (!nameSpan) continue;

        if (name === "let") {
          // \let\X\Y or \let\X=\Y
          let k = j + 1;
          while (
            k < arr.length &&
            (isWhitespaceNode(arr[k]) ||
              (arr[k].type === "string" && String(arr[k].content).trim() === "="))
          ) {
            k++;
          }
          const target = arr[k];
          const targetSpan = target ? nodeSpan(sourceId, target) : undefined;
          markDefinitionTokens(node, nameNode);
          result.macroDefs.push({
            definedName: getMacroName(nameNode),
            dialect: "let",
            bodySpan: targetSpan,
            span: {
              sourceId,
              startUtf16: cmdSpan.startUtf16,
              endUtf16: targetSpan ? targetSpan.endUtf16 : nameSpan.endUtf16,
            },
            spanSynthesized: false,
            elaborable: false,
          });
          continue;
        }

        // \def family: parameter text runs to the first group; the group is the body.
        let k = j + 1;
        let bodyNode: any = null;
        while (k < arr.length) {
          const n = arr[k];
          if (n && n.type === "group") {
            bodyNode = n;
            break;
          }
          if (n && n.type === "parbreak") break; // parameter text cannot span a paragraph break
          k++;
        }
        let bodySpan: SourceSpan | undefined;
        let endUtf16 = nameSpan.endUtf16;
        let signatureRaw: string | undefined;
        if (bodyNode) {
          const g = nodeSpan(sourceId, bodyNode)!;
          bodySpan = { sourceId, startUtf16: g.startUtf16 + 1, endUtf16: g.endUtf16 - 1 };
          endUtf16 = g.endUtf16;
          const paramText = text.slice(nameSpan.endUtf16, g.startUtf16).trim();
          if (paramText) signatureRaw = paramText;
        } else {
          // Single-token body (\def\x\y): the next non-whitespace node.
          let m = j + 1;
          while (m < arr.length && isWhitespaceNode(arr[m])) m++;
          const single = arr[m] ? nodeSpan(sourceId, arr[m]) : undefined;
          if (single) {
            bodySpan = single;
            endUtf16 = single.endUtf16;
          }
        }
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          definedName: getMacroName(nameNode),
          dialect: "def",
          signatureRaw,
          bodySpan,
          span: { sourceId, startUtf16: cmdSpan.startUtf16, endUtf16 },
          spanSynthesized: false,
          elaborable: false,
        });
        continue;
      }

      // --- Environment definitions ---------------------------------------
      if (name in ENVDEF_MECHANISMS) {
        const definedName = stringContentOfArg(braceArgs[0]);
        if (!definedName) continue;
        const mechanism = ENVDEF_MECHANISMS[name];
        const { span, synthesized } = definitionHull(sourceId, text, cmdSpan, args);
        markDefinitionTokens(node, undefined);

        if (mechanism === "newtheorem") {
          const counterSpan = argContentSpan(sourceId, bracketArgs[0]);
          result.envDefs.push({
            definedName,
            mechanism,
            counterRaw: counterSpan
              ? text.slice(counterSpan.startUtf16, counterSpan.endUtf16)
              : undefined,
            span,
            spanSynthesized: synthesized,
          });
          // Theorem-like environments take one optional [Title].
          result.registry.environments[definedName] = { signature: "o" };
        } else if (mechanism === "newenvironment") {
          const numArgs = parseInt(stringContentOfArg(bracketArgs[0]), 10) || 0;
          const hasOptional = bracketArgs.length > 1;
          const bodySpan = argContentSpan(sourceId, braceArgs[1]);
          result.envDefs.push({
            definedName,
            mechanism,
            signatureRaw: buildSignature(numArgs, hasOptional) || undefined,
            bodySpan,
            span,
            spanSynthesized: synthesized,
          });
          const sig = buildSignature(numArgs, hasOptional);
          if (sig) result.registry.environments[definedName] = { signature: sig };
        } else {
          result.envDefs.push({
            definedName,
            mechanism,
            span,
            spanSynthesized: synthesized,
          });
        }
        continue;
      }
    }
  });

  return result;
}

// ---------------------------------------------------------------------------
// Pass 2: witness parse with the document-global registry
// ---------------------------------------------------------------------------

export function parseLatexWitness(
  sourceId: SourceId,
  text: string,
  deps: Dependencies,
  registry: SignatureRegistry
): WitnessResult {
  const diagnostics: Diagnostic[] = [];
  let ast: any = null;

  try {
    ast = deps.parse
      .getParser({ macros: registry.macros, environments: registry.environments })
      .parse(text);
  } catch (err: any) {
    diagnostics.push({
      code: DiagnosticCodes.LatexParseError,
      severity: "warning",
      message: `Parse with document signature registry failed (${err?.message || err}); retrying without registry`,
    });
    try {
      ast = deps.parse.getParser().parse(text);
    } catch (err2: any) {
      diagnostics.push({
        code: DiagnosticCodes.LatexParseError,
        severity: "defect",
        message: `unified-latex failed to parse this source: ${err2?.message || err2}`,
      });
      return { sourceId, sightings: [], textRuns: [], diagnostics };
    }
  }

  const sightings: ParserSighting[] = [];
  const textRuns: SourceSpan[] = [];

  /**
   * unified-latex reparses some constructs (alignment environments like
   * `cases`) with positions in a LOCAL coordinate frame — offsets that exist
   * but lie about where the node sits in the file. A span is trusted only if
   * its whole positioned ancestor chain is containment-consistent; untrusted
   * spans are dropped so the site's true position comes from the lexical
   * witness instead of minting an entity at a corrupted offset.
   */
  function spanTrusted(node: any, parents: any): boolean {
    if (!node.position) return false;
    const ns = node.position.start.offset;
    const ne = node.position.end.offset;
    const chain = Array.isArray(parents) ? parents : [];
    for (const p of chain) {
      // Macro ancestors are exempt: their positions exclude attached
      // arguments by design (that is what hull synthesis exists for).
      if (!p || !p.position || p.type === "macro") continue;
      if (ns < p.position.start.offset || ne > p.position.end.offset) return false;
    }
    return true;
  }

  deps.visit.visit(ast, (node: any, info: any) => {
    if (!node) return;
    const trusted = spanTrusted(node, info?.parents);
    const span = trusted ? nodeSpan(sourceId, node) : undefined;
    const inMathMode = info?.context?.inMathMode || false;

    if (node.type === "macro") {
      const args: ParserArgSpan[] = [];
      if (Array.isArray(node.args)) {
        for (const arg of node.args) {
          const cs = argContentSpan(sourceId, arg);
          if (cs) args.push({ span: cs, bracketed: isBracketed(arg) });
        }
      }
      sightings.push({
        nodeType: "macro",
        name: getMacroName(node),
        span,
        inMathMode,
        args: args.length > 0 ? args : undefined,
      });
    } else if (node.type === "environment" || node.type === "mathenv") {
      sightings.push({
        nodeType: node.type,
        name: getEnvName(node.env),
        span,
        bodySpan: argContentSpan(sourceId, node),
        inMathMode: inMathMode || node.type === "mathenv",
      });
    } else if (node.type === "inlinemath") {
      sightings.push({ nodeType: "inlinemath", mode: "inline", span, inMathMode: true });
    } else if (node.type === "displaymath") {
      sightings.push({ nodeType: "displaymath", mode: "display", span, inMathMode: true });
    } else if (node.type === "string" || node.type === "whitespace" || node.type === "parbreak") {
      if (span && span.startUtf16 < span.endUtf16) {
        textRuns.push(span);
      }
    }
  });

  return { sourceId, sightings, textRuns, diagnostics };
}
