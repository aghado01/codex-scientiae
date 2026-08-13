/**
 * TeXdig parser witness for LaTeX and .bbl files using unified-latex.
 *
 * Two entry points, wired by the CLI:
 *   1. discoverDefinitions — pass 1 over ONE file: find macro and environment
 *      definitions across all knowable dialects, contribute signatures.
 *   2. parseLatexWitness — pass 2 over one file without document-final
 *      signature injection. Census macro entities are physical control-
 *      sequence tokens; binding-dependent argument attachment belongs to the
 *      occurrence/elaboration tier and cannot use a last-definition-wins map.
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
  DeclarationActivation,
  DeclarationContext,
  Diagnostic,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import { isValidSourceSpan, sourceSpanContains } from "../core/spans.ts";
import type { Dependencies } from "../core/loader.ts";

export interface ParserMacroDef {
  commandName: string;
  definedName: string;
  dialect: DefinitionDialect;
  signatureRaw?: string;
  argumentSpec?: string;
  bodySpan?: SourceSpan;
  /** Full definition site; a hull over attached args when the parser's macro node stops at the csname. */
  span: SourceSpan;
  spanSynthesized: boolean;
  elaborable: boolean;
  context: DeclarationContext;
  activation: DeclarationActivation;
  definedWithin?: { kind: "macro-definition" | "environment-definition"; span: SourceSpan };
}

export interface ParserEnvDef {
  commandName: string;
  definedName: string;
  mechanism: "newtheorem" | "newenvironment" | "newfloat";
  signatureRaw?: string;
  argumentSpec?: string;
  counterRaw?: string;
  beginBodySpan?: SourceSpan;
  endBodySpan?: SourceSpan;
  span: SourceSpan;
  spanSynthesized: boolean;
  context: DeclarationContext;
  activation: DeclarationActivation;
  definedWithin?: { kind: "macro-definition" | "environment-definition"; span: SourceSpan };
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
  /**
   * Packages/classes this file summons (\usepackage, \RequirePackage,
   * \documentclass), each with the requesting site's span — the anchor for
   * configured-dialect declarations resolved from the ctan records.
   */
  requestedPackages: Map<string, SourceSpan>;
}

export interface ParserArgSpan {
  /** Full explicit source extent including delimiters. */
  span: SourceSpan;
  /** Interior source extent; explicit empty arguments are zero-length spans. */
  contentSpan: SourceSpan;
  delimiter: "brace" | "bracket";
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
  /**
   * Trusted group-node extents (braces included). Groups are parser-witnessed
   * fenced constructs; their spans claim as fence overlays so the braces of
   * unattached arguments (unknown-signature macros) are never silent residue.
   */
  groupSpans: SourceSpan[];
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

/**
 * Deep end of a node INCLUDING its attached arguments and their closing
 * delimiters: a macro node's own position stops at the csname, so a body
 * ending in `\mathsf{Ch}` would otherwise truncate before `{Ch}}`. Text-aware
 * so each bracketed level consumes exactly its own closer.
 */
function deepNodeEnd(text: string, node: any): number | undefined {
  const base = node?.position?.end?.offset;
  if (base === undefined) return undefined;
  let end = base;
  if (Array.isArray(node.args)) {
    for (const a of node.args) {
      if (!a || !Array.isArray(a.content)) continue;
      let argEnd: number | undefined;
      for (const c of a.content) {
        const e = deepNodeEnd(text, c);
        if (e !== undefined && (argEnd === undefined || e > argEnd)) argEnd = e;
      }
      if (argEnd === undefined) continue;
      const closer = a.openMark === "{" ? "}" : a.openMark === "[" ? "]" : undefined;
      if (closer && text[argEnd] === closer) argEnd++;
      if (argEnd > end) end = argEnd;
    }
  }
  return end;
}

/** Hull over the positioned content of one argument (Argument nodes carry no position of their own). */
function argContentSpan(sourceId: SourceId, arg: any, text?: string): SourceSpan | undefined {
  if (!arg || !Array.isArray(arg.content) || arg.content.length === 0) return undefined;
  let minStart = Infinity;
  let maxEnd = -Infinity;
  for (const item of arg.content) {
    const s = nodeSpan(sourceId, item);
    if (s) {
      if (s.startUtf16 < minStart) minStart = s.startUtf16;
      const deep = text !== undefined ? deepNodeEnd(text, item) : undefined;
      const e = deep !== undefined ? Math.max(s.endUtf16, deep) : s.endUtf16;
      if (e > maxEnd) maxEnd = e;
    }
  }
  if (minStart === Infinity) return undefined;
  return { sourceId, startUtf16: minStart, endUtf16: maxEnd };
}

function isBracketed(arg: any): boolean {
  return arg && (arg.openMark === "{" || arg.openMark === "[");
}

interface ArgumentEvidence {
  span: SourceSpan;
  contentSpan: SourceSpan;
  delimiter: "brace" | "bracket";
  raw: string;
  contentRaw: string;
}

function escapedAt(text: string, offset: number): boolean {
  let count = 0;
  for (let i = offset - 1; i >= 0 && text[i] === "\\"; i--) count++;
  return count % 2 === 1;
}

function closingDelimiterOffset(text: string, openAt: number, open: string, close: string): number | undefined {
  let depth = 1;
  for (let i = openAt + 1; i < text.length; i++) {
    if (escapedAt(text, i)) continue;
    if (text[i] === open) depth++;
    else if (text[i] === close) {
      depth--;
      if (depth === 0) return i;
    }
  }
  return undefined;
}

/**
 * Recover full and interior extents from the immutable source stream. Unified-
 * latex Argument wrappers are positionless, including explicit empty `{}` and
 * `[]` arguments, so positioned child hulls alone cannot represent them.
 */
function collectArgumentEvidence(
  sourceId: SourceId,
  text: string,
  node: any
): Map<any, ArgumentEvidence> {
  const evidence = new Map<any, ArgumentEvidence>();
  const args: any[] = Array.isArray(node?.args) ? node.args : [];
  let cursor = node?.position?.end?.offset;
  if (!Number.isInteger(cursor)) return evidence;

  for (const arg of args) {
    if (!isBracketed(arg)) continue;
    const open = arg.openMark as "{" | "[";
    const close = open === "{" ? "}" : "]";
    const childSpan = argContentSpan(sourceId, arg, text);
    const adjacentOpen = childSpan ? childSpan.startUtf16 - 1 : -1;
    const openAt = adjacentOpen >= cursor && text[adjacentOpen] === open
      ? adjacentOpen
      : childSpan
        ? -1
        : text.indexOf(open, cursor);
    if (openAt < 0) continue;
    const closeAt = closingDelimiterOffset(text, openAt, open, close);
    if (closeAt === undefined) continue;
    const span: SourceSpan = { sourceId, startUtf16: openAt, endUtf16: closeAt + 1 };
    const contentSpan: SourceSpan = {
      sourceId,
      startUtf16: openAt + 1,
      endUtf16: closeAt,
    };
    evidence.set(arg, {
      span,
      contentSpan,
      delimiter: open === "{" ? "brace" : "bracket",
      raw: text.slice(span.startUtf16, span.endUtf16),
      contentRaw: text.slice(contentSpan.startUtf16, contentSpan.endUtf16),
    });
    cursor = closeAt + 1;
  }
  return evidence;
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
  commandSpan: SourceSpan,
  evidence: Map<any, ArgumentEvidence>
): { span: SourceSpan; synthesized: boolean } {
  let end = commandSpan.endUtf16;
  for (const arg of evidence.values()) {
    if (arg.span.endUtf16 > end) end = arg.span.endUtf16;
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

/**
 * Signature string for n args (unified-latex/xparse vocabulary). An optional
 * arg WITH a declared default becomes `O{default}` — plain `o` would lose the
 * default and expansion of a default-taking macro would substitute emptiness.
 */
function buildSignature(numArgs: number, hasOptional: boolean, defaultRaw?: string): string {
  const parts: string[] = [];
  if (hasOptional) parts.push(defaultRaw !== undefined ? `O{${defaultRaw}}` : "o");
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
    requestedPackages: new Map(),
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
      const argumentEvidence = collectArgumentEvidence(sourceId, text, node);
      const evidenceFor = (arg: any): ArgumentEvidence | undefined => argumentEvidence.get(arg);

      // --- Package/class summons (configured-channel anchors) -------------
      if (name === "usepackage" || name === "RequirePackage" || name === "documentclass") {
        const payload = stringContentOfArg(braceArgs[0]);
        if (payload) {
          const { span } = definitionHull(sourceId, cmdSpan, argumentEvidence);
          for (const pkg of payload.split(",")) {
            const trimmed = pkg.trim();
            if (trimmed && !result.requestedPackages.has(trimmed)) {
              result.requestedPackages.set(trimmed, span);
            }
          }
        }
        continue;
      }

      // --- \newcommand family (parser-attached args) ---------------------
      if (name in NEWCOMMAND_FAMILY) {
        const nameNode = firstMacroInArg(braceArgs[0]);
        const definedName = nameNode ? getMacroName(nameNode) : stringContentOfArg(braceArgs[0]);
        if (!definedName) continue;
        const numArgs = parseInt(evidenceFor(bracketArgs[0])?.contentRaw.trim() || "", 10) || 0;
        const hasOptional = bracketArgs.length > 1;
        const defaultRaw = hasOptional ? evidenceFor(bracketArgs[1])?.contentRaw : undefined;
        const bodySpan = evidenceFor(braceArgs[1])?.contentSpan;
        const { span, synthesized } = definitionHull(sourceId, cmdSpan, argumentEvidence);
        markDefinitionTokens(node, nameNode);
        const sig = buildSignature(numArgs, hasOptional, defaultRaw);
        const signatureRaw = bracketArgs
          .map((arg) => evidenceFor(arg)?.raw || "")
          .join("") || undefined;
        result.macroDefs.push({
          commandName: name,
          definedName,
          dialect: NEWCOMMAND_FAMILY[name],
          signatureRaw,
          argumentSpec: sig || undefined,
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
          context: "unknown",
          activation: "unknown",
        });
        if (sig) result.registry.macros[definedName] = { signature: sig };
        continue;
      }

      // --- \DeclareMathOperator{\X}{body} ---------------------------------
      if (name === "DeclareMathOperator") {
        const nameNode = firstMacroInArg(braceArgs[0]);
        if (!nameNode) continue;
        const bodySpan = evidenceFor(braceArgs[1])?.contentSpan;
        const { span, synthesized } = definitionHull(sourceId, cmdSpan, argumentEvidence);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          commandName: name,
          definedName: getMacroName(nameNode),
          dialect: "math-operator",
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
          context: "unknown",
          activation: "unknown",
        });
        continue;
      }

      // --- \DeclarePairedDelimiter{\X}{left}{right} -----------------------
      if (name === "DeclarePairedDelimiter") {
        const nameNode = firstMacroInArg(braceArgs[0]);
        if (!nameNode) continue;
        const left = evidenceFor(braceArgs[1])?.contentSpan;
        const right = evidenceFor(braceArgs[2])?.contentSpan;
        const bodySpan = left && right
          ? { sourceId, startUtf16: left.startUtf16, endUtf16: right.endUtf16 }
          : left || right;
        const { span, synthesized } = definitionHull(sourceId, cmdSpan, argumentEvidence);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          commandName: name,
          definedName: getMacroName(nameNode),
          dialect: "paired-delimiter",
          argumentSpec: "s o m",
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
          context: "unknown",
          activation: "unknown",
        });
        result.registry.macros[getMacroName(nameNode)] = { signature: "s o m" };
        continue;
      }

      // --- xparse \NewDocumentCommand{\X}{spec}{body} ---------------------
      if (XPARSE_FAMILY.has(name)) {
        const nameNode = firstMacroInArg(braceArgs[0]);
        if (!nameNode) continue;
        const specEvidence = evidenceFor(braceArgs[1]);
        const signatureRaw = specEvidence?.contentRaw;
        const argumentSpec = signatureRaw?.replace(/\s+/g, " ").trim();
        const bodySpan = evidenceFor(braceArgs[2])?.contentSpan;
        const { span, synthesized } = definitionHull(sourceId, cmdSpan, argumentEvidence);
        markDefinitionTokens(node, nameNode);
        result.macroDefs.push({
          commandName: name,
          definedName: getMacroName(nameNode),
          dialect: "xparse",
          signatureRaw,
          argumentSpec: argumentSpec || undefined,
          bodySpan,
          span,
          spanSynthesized: synthesized,
          elaborable: true,
          context: "unknown",
          activation: "unknown",
        });
        // xparse specs use the same letter vocabulary unified-latex signatures
        // do; simple specs register directly, exotic ones are skipped.
        if (
          argumentSpec &&
          /^[somO](?:\{[^{}]*\})?(?:\s+[somO](?:\{[^{}]*\})?)*$/.test(argumentSpec)
        ) {
          result.registry.macros[getMacroName(nameNode)] = { signature: argumentSpec };
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
          // The \let TARGET is part of the definition site too: leaving it to
          // mint an invocation lets a registered arg-taking target swallow the
          // NEXT construct as its argument (observed: \let\a\b before another
          // \newcommand line).
          if (target && target.type === "macro") markDefinitionTokens(target, undefined);
          result.macroDefs.push({
            commandName: name,
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
            context: "unknown",
            activation: "unknown",
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
          const paramText = text.slice(nameSpan.endUtf16, g.startUtf16);
          if (paramText.length > 0) signatureRaw = paramText;
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
          commandName: name,
          definedName: getMacroName(nameNode),
          dialect: name as "def" | "gdef" | "edef" | "xdef",
          signatureRaw,
          bodySpan,
          span: { sourceId, startUtf16: cmdSpan.startUtf16, endUtf16 },
          spanSynthesized: false,
          elaborable: false,
          context: "unknown",
          activation: "unknown",
        });
        continue;
      }

      // --- Environment definitions ---------------------------------------
      if (name in ENVDEF_MECHANISMS) {
        const definedName = stringContentOfArg(braceArgs[0]);
        if (!definedName) continue;
        const mechanism = ENVDEF_MECHANISMS[name];
        const { span, synthesized } = definitionHull(sourceId, cmdSpan, argumentEvidence);
        markDefinitionTokens(node, undefined);

        if (mechanism === "newtheorem") {
          const counterEvidence = evidenceFor(bracketArgs[0]);
          result.envDefs.push({
            commandName: name,
            definedName,
            mechanism,
            counterRaw: counterEvidence?.contentRaw,
            span,
            spanSynthesized: synthesized,
            context: "unknown",
            activation: "unknown",
          });
          // Theorem-like environments take one optional [Title].
          result.registry.environments[definedName] = { signature: "o" };
        } else if (mechanism === "newenvironment") {
          const numArgs = parseInt(evidenceFor(bracketArgs[0])?.contentRaw.trim() || "", 10) || 0;
          const hasOptional = bracketArgs.length > 1;
          const defaultRaw = hasOptional ? evidenceFor(bracketArgs[1])?.contentRaw : undefined;
          const sig = buildSignature(numArgs, hasOptional, defaultRaw);
          const signatureRaw = bracketArgs
            .map((arg) => evidenceFor(arg)?.raw || "")
            .join("") || undefined;
          result.envDefs.push({
            commandName: name,
            definedName,
            mechanism,
            signatureRaw,
            argumentSpec: sig || undefined,
            beginBodySpan: evidenceFor(braceArgs[1])?.contentSpan,
            endBodySpan: evidenceFor(braceArgs[2])?.contentSpan,
            span,
            spanSynthesized: synthesized,
            context: "unknown",
            activation: "unknown",
          });
          if (sig) result.registry.environments[definedName] = { signature: sig };
        } else {
          result.envDefs.push({
            commandName: name,
            definedName,
            mechanism,
            span,
            spanSynthesized: synthesized,
            context: "unknown",
            activation: "unknown",
          });
        }
        continue;
      }
    }
  });

  // A declaration physically nested in another declaration's program is not
  // active while the outer definition is merely read. Record the nearest
  // containing definition so later occurrence compilation can activate it at
  // execution time instead of installing it document-globally.
  type DefinitionRef = {
    kind: "macro-definition" | "environment-definition";
    value: ParserMacroDef | ParserEnvDef;
    bodies: SourceSpan[];
  };
  const definitionRefs: DefinitionRef[] = [
    ...result.macroDefs.map((value) => ({
      kind: "macro-definition" as const,
      value,
      bodies: value.bodySpan ? [value.bodySpan] : [],
    })),
    ...result.envDefs.map((value) => ({
      kind: "environment-definition" as const,
      value,
      bodies: [value.beginBodySpan, value.endBodySpan].filter(
        (span): span is SourceSpan => span !== undefined
      ),
    })),
  ];
  for (const child of definitionRefs) {
    let parent: DefinitionRef | undefined;
    let parentWidth = Infinity;
    for (const candidate of definitionRefs) {
      if (candidate === child) continue;
      for (const body of candidate.bodies) {
        if (!sourceSpanContains(body, child.value.span)) continue;
        const width = body.endUtf16 - body.startUtf16;
        if (width < parentWidth) {
          parent = candidate;
          parentWidth = width;
        }
      }
    }
    if (parent) {
      child.value.context = "definition-body";
      child.value.activation = "deferred";
      child.value.definedWithin = { kind: parent.kind, span: parent.value.span };
    }
  }

  return result;
}

// ---------------------------------------------------------------------------
// Pass 2: physical witness parse
// ---------------------------------------------------------------------------

export function parseLatexWitness(
  sourceId: SourceId,
  text: string,
  deps: Dependencies,
  _registry: SignatureRegistry
): WitnessResult {
  const diagnostics: Diagnostic[] = [];
  let ast: any = null;

  try {
    // A document-final registry cannot represent redefinition order, include
    // occurrences, or scope. Injecting it here lets a later signature rewrite
    // the AST shape of an earlier invocation. The census therefore parses the
    // physical token stream with the baseline grammar only.
    ast = deps.parse.getParser().parse(text);
  } catch (err: any) {
    diagnostics.push({
      code: DiagnosticCodes.LatexParseError,
      severity: "defect",
      message: `unified-latex failed to parse this source: ${err?.message || err}`,
      sourceId,
      witness: "parser",
    });
    return { sourceId, sightings: [], textRuns: [], groupSpans: [], diagnostics };
  }

  const sightings: ParserSighting[] = [];
  const textRuns: SourceSpan[] = [];
  const groupSpans: SourceSpan[] = [];
  let reportedUntrustedParserSpan = false;

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
    const candidate: SourceSpan = { sourceId, startUtf16: ns, endUtf16: ne };
    if (!isValidSourceSpan(candidate, text.length)) return false;
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
    if (node.position && !trusted && !reportedUntrustedParserSpan) {
      reportedUntrustedParserSpan = true;
      diagnostics.push({
        code: DiagnosticCodes.UntrustedParserSpan,
        severity: "warning",
        message: `Discarded one or more containment-inconsistent unified-latex positions (first node: ${String(node.type || "node")})`,
        sourceId,
        witness: "parser",
      });
    }

    if (node.type === "macro") {
      const args: ParserArgSpan[] = [];
      for (const arg of collectArgumentEvidence(sourceId, text, node).values()) {
        if (isValidSourceSpan(arg.span, text.length)) {
          args.push({ span: arg.span, contentSpan: arg.contentSpan, delimiter: arg.delimiter });
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
        inMathMode: inMathMode || node.type === "mathenv",
      });
    } else if (node.type === "verb") {
      // unified-latex accepts verb forms the stratifier's conservative rule
      // does not (space-delimited \verb in biblatex .bbl fields).
      sightings.push({ nodeType: "verb", name: node.escape || "", span });
    } else if (node.type === "inlinemath") {
      sightings.push({ nodeType: "inlinemath", mode: "inline", span, inMathMode: true });
    } else if (node.type === "displaymath") {
      sightings.push({ nodeType: "displaymath", mode: "display", span, inMathMode: true });
    } else if (node.type === "parbreak") {
      sightings.push({ nodeType: "paragraph-break", span });
    } else if (node.type === "string" || node.type === "whitespace") {
      if (span && span.startUtf16 < span.endUtf16) {
        textRuns.push(span);
      }
    } else if (node.type === "group") {
      if (span && span.startUtf16 < span.endUtf16) {
        groupSpans.push(span);
      }
    }
  });

  return { sourceId, sightings, textRuns, groupSpans, diagnostics };
}
