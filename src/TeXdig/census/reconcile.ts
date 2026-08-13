/**
 * TeXdig witness reconciliation and entity generator — the fusion pass.
 *
 * Every entity here is minted from the EVIDENCE OF BOTH WITNESSES where both
 * can see the site: the lexical scanner's sightings are matched against parser
 * sightings by position, agreement is computed (never assumed), and anything
 * one-sided carries a named diagnostic. Comment/verbatim strata are the one
 * deliberate exception: stratification precedes and masks the parse, so those
 * entities are stratify-witnessed by design — that is authority, not defect.
 *
 * Erasable-syntax TypeScript only (Node 26 native type stripping).
 */

import type {
  SourceId,
  SourceSpan,
  CensusEntity,
  WitnessRecord,
  WitnessSpanRole,
  AgreementState,
  AgreementBasis,
  SpanProvenance,
  Diagnostic,
  EnvironmentRole,
  EnvelopeMarkerKind,
  PillarClaim,
} from "../core/types.ts";
import { DiagnosticCodes } from "../core/types.ts";
import type { LexicalSighting } from "./scan-latex.ts";
import type { DiscoveryResult, WitnessResult, ParserSighting } from "./parse-latex.ts";
import type { ParseBibResult } from "./parse-bib.ts";
import type { StratificationResult } from "./stratify.ts";
import type { BibLexicalSighting } from "./scan-bib.ts";
import type { IncludeEdge } from "./source-graph.ts";
import {
  compareEnvironmentWitnesses,
  compareWitnesses,
} from "./witness-equivalence.ts";
import type {
  WitnessEquivalencePolicy,
  WitnessEquivalenceReason,
  WitnessSemantics,
} from "./witness-equivalence.ts";
import { sourceSpanContains } from "../core/spans.ts";

export interface ReconcileResult {
  sourceId: SourceId;
  entities: CensusEntity[];
  diagnostics: Diagnostic[];
  /** Entity-less pillar claims (multi-target include directives, blank runs). */
  extraClaims: PillarClaim[];
}

function mintEntityId(kind: string, span: SourceSpan): string {
  return `ent:${kind}@${span.sourceId}:${span.startUtf16}-${span.endUtf16}`;
}

// Small-vocabulary role classification, byte-exact per house doctrine —
// everything else stays `generic` for downstream elaboration.
const KNOWN_FLOAT_ENVS = new Set(["figure", "figure*", "table", "table*", "algorithm"]);
const KNOWN_MATH_ENVS = new Set([
  "equation", "equation*", "align", "align*", "gather", "gather*",
  "multline", "multline*", "flalign", "flalign*", "eqnarray", "eqnarray*",
  "alignat", "alignat*", "xalignat", "xalignat*", "xxalignat", "split",
  "aligned", "alignedat", "gathered", "multlined", "cases", "dcases", "dcases*",
]);
const KNOWN_VERBATIM_ENVS = new Set(["verbatim", "verbatim*", "lstlisting", "minted", "alltt"]);

function classifyEnvRole(envName: string): EnvironmentRole {
  if (envName === "thebibliography") return "bibliography";
  if (KNOWN_FLOAT_ENVS.has(envName)) return "float";
  if (KNOWN_MATH_ENVS.has(envName)) return "math";
  if (KNOWN_VERBATIM_ENVS.has(envName)) return "verbatim";
  return "generic";
}

const SECTIONING_COMMANDS = new Set([
  "section", "subsection", "subsubsection", "paragraph", "subparagraph",
]);

function classifyEnvelopeMarker(cmdName: string): EnvelopeMarkerKind | undefined {
  if (cmdName === "documentclass") return "documentclass";
  if (cmdName === "appendix") return "appendix";
  if (SECTIONING_COMMANDS.has(cmdName)) return "section";
  return undefined;
}

/**
 * Positional index over the lexical control-sequence sightings. The scanner's
 * kind labels are shallow typing, not identity — matching is by position and
 * csname; the reconciled entity's kind comes from the richer witness.
 */
const CS_SIGHTING_KINDS = new Set([
  "macro-invocation",
  "macro-definition",
  "environment-definition",
  "envelope-marker",
  "include",
]);

interface LexIndex {
  cs: Map<number, LexicalSighting>;
  envBegin: Map<number, LexicalSighting>;
  /** Environment-end fences indexed by their END offset (matches env node end). */
  envEndByEnd: Map<number, LexicalSighting>;
  math: Map<number, LexicalSighting>;
  consumed: Set<LexicalSighting>;
}

function lexicalTokenSpan(rawText: string, sighting: LexicalSighting): SourceSpan {
  if (sighting.span.startUtf16 >= sighting.span.endUtf16) return sighting.span;
  const startUtf16 = sighting.span.startUtf16;
  if (rawText[startUtf16] !== "\\") return sighting.span;
  let endUtf16 = startUtf16 + 1;
  const atName = Boolean(sighting.name?.includes("@"));
  const isLetter = (ch: string) => /[A-Za-z]/.test(ch) || (atName && ch === "@");
  if (endUtf16 < rawText.length && isLetter(rawText[endUtf16])) {
    while (endUtf16 < rawText.length && isLetter(rawText[endUtf16])) endUtf16++;
  } else if (endUtf16 < rawText.length) {
    endUtf16++;
  }
  return { sourceId: sighting.span.sourceId, startUtf16, endUtf16 };
}

function indexLexical(sightings: LexicalSighting[]): LexIndex {
  const idx: LexIndex = {
    cs: new Map(),
    envBegin: new Map(),
    envEndByEnd: new Map(),
    math: new Map(),
    consumed: new Set(),
  };
  for (const s of sightings) {
    // \begin{document}/\end{document} arrive as envelope-marker sightings but
    // are FENCES — route them to the fence maps before the cs-kind catch-all.
    if (s.detail === "begin:document") {
      idx.envBegin.set(s.span.startUtf16, s);
    } else if (s.detail === "end:document") {
      idx.envEndByEnd.set(s.span.endUtf16, s);
    } else if (CS_SIGHTING_KINDS.has(s.kind)) {
      idx.cs.set(s.span.startUtf16, s);
    } else if (s.kind === "environment-begin") {
      idx.envBegin.set(s.span.startUtf16, s);
    } else if (s.kind === "environment-end") {
      idx.envEndByEnd.set(s.span.endUtf16, s);
    } else if (s.kind === "math") {
      idx.math.set(s.span.startUtf16, s);
    }
  }
  return idx;
}

function lexicalSpanRole(s: LexicalSighting): WitnessSpanRole {
  if (s.detail?.startsWith("begin:")) return "begin-fence";
  if (s.detail?.startsWith("end:")) return "end-fence";
  if (s.kind === "math" || s.kind === "comment" || s.kind === "verbatim") return "construct";
  return "token";
}

function lexWitness(s: LexicalSighting, spanRole: WitnessSpanRole = lexicalSpanRole(s)): WitnessRecord {
  return { witness: "lexical", span: s.span, spanRole, detail: s.detail || s.name };
}

function parserWitness(
  span: SourceSpan,
  detail: string,
  spanRole: WitnessSpanRole = "token"
): WitnessRecord {
  return { witness: "parser", instrument: "unified-latex", span, spanRole, detail };
}

export function reconcileLatex(
  sourceId: SourceId,
  rawText: string,
  strat: StratificationResult,
  lexSightings: LexicalSighting[],
  discovery: DiscoveryResult,
  witness: WitnessResult,
  includeEdges: IncludeEdge[]
): ReconcileResult {
  const entities: CensusEntity[] = [];
  const diagnostics: Diagnostic[] = [...witness.diagnostics];
  const extraClaims: PillarClaim[] = [];
  const lex = indexLexical(lexSightings);

  function tokenWitness(s: LexicalSighting): WitnessRecord {
    return {
      witness: "lexical",
      span: lexicalTokenSpan(rawText, s),
      spanRole: "token",
      detail: s.detail || s.name,
    };
  }

  function containedDerivedSpan(
    owner: SourceSpan,
    candidate: SourceSpan | undefined,
    label: string,
    entityId: string
  ): SourceSpan | undefined {
    if (!candidate || sourceSpanContains(owner, candidate)) return candidate;
    diagnostics.push({
      code: DiagnosticCodes.InvalidSpan,
      severity: "defect",
      message: `Discarded ${label} span outside its owning entity`,
      sourceId,
      entityId,
      witness: "parser",
    });
    return undefined;
  }

  /** Record the fusion outcome for one entity and its side diagnostic. */
  function fuse(
    parserW: WitnessRecord | undefined,
    lexS: LexicalSighting | undefined,
    policy: Exclude<WitnessEquivalencePolicy, "environment-fences">,
    parserSemantics?: WitnessSemantics,
    lexicalSemantics?: WitnessSemantics
  ): {
    witnesses: WitnessRecord[];
    agreement: AgreementState;
    agreementBasis: AgreementBasis;
    reason?: WitnessEquivalenceReason;
  } {
    const witnesses: WitnessRecord[] = [];
    if (parserW) witnesses.push(parserW);
    let lexicalW: WitnessRecord | undefined;
    if (lexS) {
      lexicalW = policy === "control-sequence-token" || policy === "include-command-token"
        ? tokenWitness(lexS)
        : lexWitness(lexS);
      witnesses.push(lexicalW);
      lex.consumed.add(lexS);
    }
    if (parserW && lexicalW) {
      const comparison = compareWitnesses(
        policy,
        { ...parserW, semantics: parserSemantics },
        { ...lexicalW, semantics: lexicalSemantics }
      );
      return {
        witnesses,
        agreement: comparison.equivalent ? "agreed" : "conflict",
        agreementBasis: "two-instrument",
        reason: comparison.reason,
      };
    }
    return {
      witnesses,
      agreement: parserW ? "parser-only" : "lexical-only",
      agreementBasis: "single-authority",
    };
  }

  function disagreementDiagnostic(
    entityId: string,
    agreement: AgreementState,
    span: SourceSpan,
    what: string,
    reason?: WitnessEquivalenceReason
  ) {
    if (agreement === "agreed") return;
    diagnostics.push({
      code: DiagnosticCodes.WitnessDisagreement,
      severity: agreement === "conflict" ? "warning" : "info",
      message: `${what} witnessed ${agreement === "parser-only" ? "by the parser only" : agreement === "lexical-only" ? "by the lexical scanner only" : `with conflicting evidence (${reason || "policy mismatch"})`}`,
      sourceId,
      span,
      entityId,
      witness: agreement === "parser-only" ? "parser" : "lexical",
    });
  }

  // -------------------------------------------------------------------------
  // 1. Strata entities: stratify is the authority for comments and verbatim —
  //    they are masked from both downstream witnesses BY DESIGN, so a single
  //    stratify witness is complete evidence, not a disagreement.
  // -------------------------------------------------------------------------
  const strataStarts = new Set<number>();
  for (const s of strat.strata) strataStarts.add(s.span.startUtf16);
  for (const s of strat.strata) {
    if (s.kind === "comment") {
      entities.push({
        id: mintEntityId("comment", s.span),
        kind: "comment",
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [{ witness: "lexical", span: s.span, spanRole: "construct", detail: "stratify:comment" }],
        agreement: "agreed",
        agreementBasis: "single-authority",
      });
    } else if (s.kind === "verbatim-inline") {
      entities.push({
        id: mintEntityId("verbatim-inline", s.span),
        kind: "verbatim-inline",
        delimiter: s.delimiter || "|",
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [{ witness: "lexical", span: s.span, spanRole: "construct", detail: "stratify:verbatim-inline" }],
        agreement: "agreed",
        agreementBasis: "single-authority",
      });
    } else if (s.kind === "verbatim") {
      const envName = s.envName || "verbatim";
      const beginLen = `\\begin{${envName}}`.length;
      const endLen = `\\end{${envName}}`.length;
      const interiorStart = s.span.startUtf16 + beginLen;
      const interiorEnd = s.span.endUtf16 - endLen;
      entities.push({
        id: mintEntityId("environment", s.span),
        kind: "environment",
        name: envName,
        role: "verbatim",
        bodySpan: interiorEnd >= interiorStart
          ? { sourceId, startUtf16: interiorStart, endUtf16: interiorEnd }
          : undefined,
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [
          { witness: "lexical", span: s.span, spanRole: "construct", detail: `stratify:verbatim:${envName}` },
          {
            witness: "lexical",
            span: { sourceId, startUtf16: s.span.startUtf16, endUtf16: interiorStart },
            spanRole: "begin-fence",
            detail: `begin:${envName}`,
          },
          {
            witness: "lexical",
            span: { sourceId, startUtf16: interiorEnd, endUtf16: s.span.endUtf16 },
            spanRole: "end-fence",
            detail: `end:${envName}`,
          },
        ],
        agreement: "agreed",
        agreementBasis: "single-authority",
      });
    }
  }

  // -------------------------------------------------------------------------
  // 2. Definition entities from discovery (parser witness), fused with the
  //    lexical sighting at the defining command's own position. Every token
  //    the discovery marked as part of a definition site (command + defined
  //    name) is consumed here: the name token is the definition's evidence,
  //    not a stray control sequence.
  // -------------------------------------------------------------------------
  for (const start of discovery.definitionTokenStarts) {
    const s = lex.cs.get(start);
    if (s) lex.consumed.add(s);
  }
  for (const mdef of discovery.macroDefs) {
    const spanProv: SpanProvenance = mdef.spanSynthesized ? "synthesized-hull" : "parser";
    const lexS = lex.cs.get(mdef.span.startUtf16);
    const { witnesses, agreement, agreementBasis, reason } = fuse(
      parserWitness(mdef.span, mdef.dialect, "construct"),
      lexS,
      "definition-anchor",
      { name: mdef.commandName },
      { name: lexS?.name }
    );
    const id = mintEntityId("macro-definition", mdef.span);
    if (mdef.spanSynthesized) {
      diagnostics.push({
        code: DiagnosticCodes.SpanSynthesized,
        severity: "info",
        message: `Synthesized definition hull for \\${mdef.definedName}`,
        sourceId,
        span: mdef.span,
        entityId: id,
      });
    }
    entities.push({
      id,
      kind: "macro-definition",
      definedName: mdef.definedName,
      declarationCommand: mdef.declarationCommand,
      dialect: mdef.dialect,
      signatureRaw: mdef.signatureRaw,
      argumentSpec: mdef.argumentSpec,
      signature: mdef.signature,
      bodySpan: containedDerivedSpan(mdef.span, mdef.bodySpan, "macro body", id),
      elaborable: mdef.elaborable,
      context: mdef.context,
      activation: mdef.activation,
      definedWithin: mdef.definedWithin
        ? mintEntityId(mdef.definedWithin.kind, mdef.definedWithin.span)
        : undefined,
      span: mdef.span,
      spanProvenance: spanProv,
      witnesses,
      agreement,
      agreementBasis,
    });
    disagreementDiagnostic(id, agreement, mdef.span, `Macro definition \\${mdef.definedName}`, reason);
  }

  for (const edef of discovery.envDefs) {
    const spanProv: SpanProvenance = edef.spanSynthesized ? "synthesized-hull" : "parser";
    const lexS = lex.cs.get(edef.span.startUtf16);
    const { witnesses, agreement, agreementBasis, reason } = fuse(
      parserWitness(edef.span, edef.mechanism, "construct"),
      lexS,
      "definition-anchor",
      { name: edef.commandName },
      { name: lexS?.name }
    );
    const id = mintEntityId("environment-definition", edef.span);
    if (edef.spanSynthesized) {
      diagnostics.push({
        code: DiagnosticCodes.SpanSynthesized,
        severity: "info",
        message: `Synthesized definition hull for environment '${edef.definedName}'`,
        sourceId,
        span: edef.span,
        entityId: id,
      });
    }
    entities.push({
      id,
      kind: "environment-definition",
      definedName: edef.definedName,
      declarationCommand: edef.declarationCommand,
      mechanism: edef.mechanism,
      signatureRaw: edef.signatureRaw,
      argumentSpec: edef.argumentSpec,
      signature: edef.signature,
      counterRaw: edef.counterRaw,
      beginBodySpan: containedDerivedSpan(edef.span, edef.beginBodySpan, "environment begin body", id),
      endBodySpan: containedDerivedSpan(edef.span, edef.endBodySpan, "environment end body", id),
      context: edef.context,
      activation: edef.activation,
      definedWithin: edef.definedWithin
        ? mintEntityId(edef.definedWithin.kind, edef.definedWithin.span)
        : undefined,
      span: edef.span,
      spanProvenance: spanProv,
      witnesses,
      agreement,
      agreementBasis,
    });
    disagreementDiagnostic(id, agreement, edef.span, `Environment definition '${edef.definedName}'`, reason);
  }

  // -------------------------------------------------------------------------
  // 3. Include entities from the source-graph edges — the resolution evidence
  //    (targetRaw, resolvedSourceId) lives HERE, in the artifact, not in a
  //    discarded in-memory structure.
  // -------------------------------------------------------------------------
  const includeSiteStarts = new Set<number>();
  const edgesBySite = new Map<number, IncludeEdge[]>();
  for (const edge of includeEdges) {
    includeSiteStarts.add(edge.span.startUtf16);
    const list = edgesBySite.get(edge.span.startUtf16) || [];
    list.push(edge);
    edgesBySite.set(edge.span.startUtf16, list);
  }

  const parserByStart = new Map<number, ParserSighting>();
  for (const ps of witness.sightings) {
    if (ps.nodeType === "macro" && ps.span) parserByStart.set(ps.span.startUtf16, ps);
  }

  for (const [siteStart, edges] of edgesBySite) {
    const lexS = lex.cs.get(siteStart);
    const ps = parserByStart.get(siteStart);
    const multi = edges.length > 1;
    for (const edge of edges) {
      const span = multi ? edge.targetSpan : edge.span;
      const parserW = ps?.span ? parserWitness(ps.span, edge.directive) : undefined;
      const lexicalW = lexS ? tokenWitness(lexS) : undefined;
      const comparison = parserW && lexicalW
        ? compareWitnesses(
            "include-command-token",
            { ...parserW, semantics: { name: ps?.name, construct: edge.directive } },
            { ...lexicalW, semantics: { name: lexS.name, construct: edge.directive } }
          )
        : undefined;
      const witnesses = [parserW, lexicalW].filter((w): w is WitnessRecord => w !== undefined);
      const agreement: AgreementState = comparison
        ? comparison.equivalent ? "agreed" : "conflict"
        : parserW ? "parser-only" : "lexical-only";
      const agreementBasis: AgreementBasis = parserW && lexicalW ? "two-instrument" : "single-authority";
      const reason = comparison?.reason;
      const id = mintEntityId("include", span);
      entities.push({
        id,
        kind: "include",
        directive: edge.directive,
        targetRaw: edge.targetRaw,
        resolvedSourceId: edge.toSourceId,
        span,
        spanProvenance: ps ? "parser" : "lexical",
        witnesses,
        agreement,
        agreementBasis,
      });
      disagreementDiagnostic(id, agreement, span, `Include directive \\${edge.directive}`, reason);
    }
    if (lexS) lex.consumed.add(lexS);
    if (multi) {
      // Per-target entities carry token spans; one entity-less claim keeps the
      // directive's own characters covered.
      extraClaims.push({
        pillar: "envelope",
        span: edges[0].span,
        role: "include-directive",
      });
    }
    // \bibliography is BOTH an include tie and an envelope marker — overlays,
    // not a partition.
    if (edges[0].directive === "bibliography") {
      const span = edges[0].span;
      const parserW = ps?.span ? parserWitness(ps.span, "bibliography") : undefined;
      const lexicalW = lexS ? tokenWitness(lexS) : undefined;
      const comparison = parserW && lexicalW
        ? compareWitnesses(
            "include-command-token",
            { ...parserW, semantics: { name: ps?.name, construct: "bibliography" } },
            { ...lexicalW, semantics: { name: lexS.name, construct: "bibliography" } }
          )
        : undefined;
      const witnesses = [parserW, lexicalW].filter((w): w is WitnessRecord => w !== undefined);
      const agreement: AgreementState = comparison
        ? comparison.equivalent ? "agreed" : "conflict"
        : parserW ? "parser-only" : "lexical-only";
      const agreementBasis: AgreementBasis = parserW && lexicalW ? "two-instrument" : "single-authority";
      const id = mintEntityId("envelope-marker", span);
      entities.push({
        id,
        kind: "envelope-marker",
        marker: "bibliography",
        name: "bibliography",
        span,
        spanProvenance: ps ? "parser" : "lexical",
        witnesses,
        agreement,
        agreementBasis,
      });
      disagreementDiagnostic(
        id,
        agreement,
        span,
        "Bibliography envelope marker",
        comparison?.reason
      );
    }
  }

  // -------------------------------------------------------------------------
  // 4. Parser sightings → entities, each fused with its lexical counterpart.
  // -------------------------------------------------------------------------
  for (const ps of witness.sightings) {
    if (!ps.span) continue;

    if (ps.nodeType === "paragraph-break") {
      entities.push({
        id: mintEntityId("paragraph-break", ps.span),
        kind: "paragraph-break",
        span: ps.span,
        spanProvenance: "parser",
        witnesses: [parserWitness(ps.span, "parbreak", "construct")],
        agreement: "agreed",
        agreementBasis: "single-authority",
      });
    } else if (ps.nodeType === "macro") {
      const name = ps.name || "";
      const start = ps.span.startUtf16;
      // Definition sites and include sites are already censused above; bare
      // begin/end macro nodes are fence debris the environment pass owns.
      if (discovery.definitionTokenStarts.has(start)) continue;
      if (includeSiteStarts.has(start)) continue;
      if (name === "begin" || name === "end") continue;

      // Physical census identity is the control-sequence token. Arguments are
      // binding-dependent occurrence data and never stretch this entity span.
      const span = ps.span;
      const spanProv: SpanProvenance = "parser";

      const lexS = lex.cs.get(start);
      const { witnesses, agreement, agreementBasis, reason } = fuse(
        parserWitness(ps.span, name, "token"),
        lexS,
        "control-sequence-token",
        { name },
        { name: lexS?.name }
      );

      const envMarker = classifyEnvelopeMarker(name);
      if (envMarker) {
        // Starred sectioning keeps its star in the recorded command name.
        const starred = rawText[ps.span.endUtf16] === "*";
        const markerName = starred ? `${name}*` : name;
        const id = mintEntityId("envelope-marker", span);
        entities.push({
          id,
          kind: "envelope-marker",
          marker: envMarker,
          name: markerName,
          span,
          spanProvenance: spanProv,
          witnesses,
          agreement,
          agreementBasis,
        });
        disagreementDiagnostic(id, agreement, span, `Envelope marker \\${markerName}`, reason);
      } else {
        const id = mintEntityId("macro-invocation", span);
        entities.push({
          id,
          kind: "macro-invocation",
          name,
          inMathMode: ps.inMathMode,
          span,
          spanProvenance: spanProv,
          witnesses,
          agreement,
          agreementBasis,
        });
        disagreementDiagnostic(id, agreement, span, `Control sequence \\${name}`, reason);
      }
    } else if (ps.nodeType === "environment" || ps.nodeType === "mathenv") {
      const name = ps.name || "";
      const span = ps.span;
      const role = classifyEnvRole(name);

      const beginS = lex.envBegin.get(span.startUtf16);
      const endS = lex.envEndByEnd.get(span.endUtf16);
      const parserW = parserWitness(span, `${ps.nodeType}:${name}`, "construct");
      const witnesses: WitnessRecord[] = [parserW];
      if (beginS) {
        witnesses.push(lexWitness(beginS, "begin-fence"));
        lex.consumed.add(beginS);
      }
      if (endS) {
        witnesses.push(lexWitness(endS, "end-fence"));
        lex.consumed.add(endS);
      }
      let agreement: AgreementState;
      let agreementReason: WitnessEquivalenceReason | undefined;
      if (beginS && endS) {
        const comparison = compareEnvironmentWitnesses(
          { ...parserW, semantics: { name } },
          { ...lexWitness(beginS, "begin-fence"), semantics: { name: beginS.name } },
          { ...lexWitness(endS, "end-fence"), semantics: { name: endS.name } }
        );
        agreement = comparison.equivalent ? "agreed" : "conflict";
        agreementReason = comparison.reason;
      } else {
        agreement = beginS || endS ? "conflict" : "parser-only";
        agreementReason = beginS || endS ? "extent-mismatch" : undefined;
      }
      const agreementBasis: AgreementBasis = beginS || endS ? "two-instrument" : "single-authority";

      const envId = mintEntityId("environment", span);
      const bodySpan = beginS && endS && beginS.name === name && endS.name === name &&
          beginS.span.endUtf16 <= endS.span.startUtf16
        ? containedDerivedSpan(
            span,
            {
              sourceId,
              startUtf16: beginS.span.endUtf16,
              endUtf16: endS.span.startUtf16,
            },
            "environment body",
            envId
          )
        : undefined;
      entities.push({
        id: envId,
        kind: "environment",
        name,
        role,
        bodySpan,
        span,
        spanProvenance: "parser",
        witnesses,
        agreement,
        agreementBasis,
      });
      disagreementDiagnostic(envId, agreement, span, `Environment '${name}'`, agreementReason);

      if (role === "math" || ps.nodeType === "mathenv") {
        const mathId = mintEntityId("math", span);
        entities.push({
          id: mathId,
          kind: "math",
          mode: "display",
          carrier: { form: "env", name },
          fenceEntityId: envId,
          span,
          spanProvenance: "parser",
          witnesses,
          agreement,
          agreementBasis,
        });
        disagreementDiagnostic(
          mathId,
          agreement,
          span,
          `Math environment carrier '${name}'`,
          agreementReason
        );
      }

      if (name === "document") {
        // The document fences are envelope markers in their own right.
        if (beginS) {
          const markerParserW = parserWitness(span, "environment:document", "construct");
          const markerLexW = lexWitness(beginS, "begin-fence");
          const comparison = compareWitnesses(
            "begin-fence-anchor",
            { ...markerParserW, semantics: { name } },
            { ...markerLexW, semantics: { name: beginS.name } }
          );
          const markerId = mintEntityId("envelope-marker", beginS.span);
          const markerAgreement = comparison.equivalent ? "agreed" as const : "conflict" as const;
          entities.push({
            id: markerId,
            kind: "envelope-marker",
            marker: "begin-document",
            span: beginS.span,
            spanProvenance: "lexical",
            witnesses: [markerParserW, markerLexW],
            agreement: markerAgreement,
            agreementBasis: "two-instrument",
          });
          disagreementDiagnostic(
            markerId,
            markerAgreement,
            beginS.span,
            "Begin-document envelope marker",
            comparison.reason
          );
        }
        if (endS) {
          const markerParserW = parserWitness(span, "environment:document", "construct");
          const markerLexW = lexWitness(endS, "end-fence");
          const comparison = compareWitnesses(
            "end-fence-anchor",
            { ...markerParserW, semantics: { name } },
            { ...markerLexW, semantics: { name: endS.name } }
          );
          const markerId = mintEntityId("envelope-marker", endS.span);
          const markerAgreement = comparison.equivalent ? "agreed" as const : "conflict" as const;
          entities.push({
            id: markerId,
            kind: "envelope-marker",
            marker: "end-document",
            span: endS.span,
            spanProvenance: "lexical",
            witnesses: [markerParserW, markerLexW],
            agreement: markerAgreement,
            agreementBasis: "two-instrument",
          });
          disagreementDiagnostic(
            markerId,
            markerAgreement,
            endS.span,
            "End-document envelope marker",
            comparison.reason
          );
        }
      }
    } else if (ps.nodeType === "verb") {
      // Verb forms the stratifier's conservative rule rejected (space-delimited
      // \verb in biblatex .bbl fields). Strata keep authority where they fired.
      const span = ps.span;
      if (strataStarts.has(span.startUtf16)) continue;
      const id = mintEntityId("verbatim-inline", span);
      entities.push({
        id,
        kind: "verbatim-inline",
        delimiter: ps.name || " ",
        span,
        spanProvenance: "parser",
        witnesses: [parserWitness(span, "verb", "construct")],
        agreement: "parser-only",
        agreementBasis: "single-authority",
      });
      disagreementDiagnostic(id, "parser-only", span, "Inline verbatim (\\verb)");
    } else if (ps.nodeType === "inlinemath" || ps.nodeType === "displaymath") {
      const span = ps.span;
      const lexS = lex.math.get(span.startUtf16);
      const rawSlice = rawText.slice(span.startUtf16, span.endUtf16);
      const form = ps.nodeType === "inlinemath"
        ? (rawSlice.startsWith("\\(") ? "paren" as const : "dollar" as const)
        : (rawSlice.startsWith("\\[") ? "bracket" as const : "double-dollar" as const);
      const lexicalForm = lexS?.detail === "double-dollar" ? "double-dollar" as const
        : lexS?.detail === "paren" ? "paren" as const
        : lexS?.detail === "bracket" ? "bracket" as const
        : "dollar" as const;
      const mode = ps.nodeType === "inlinemath" ? "inline" as const : "display" as const;
      const { witnesses, agreement, agreementBasis, reason } = fuse(
        parserWitness(span, ps.nodeType, "construct"),
        lexS,
        "math-carrier",
        { mode, carrier: { form } },
        { mode: lexS?.mode, carrier: { form: lexicalForm } }
      );
      const id = mintEntityId("math", span);
      entities.push({
        id,
        kind: "math",
        mode,
        carrier: { form },
        span,
        spanProvenance: "parser",
        witnesses,
        agreement,
        agreementBasis,
      });
      disagreementDiagnostic(id, agreement, span, `Math carrier (${form})`, reason);
    }
  }

  // -------------------------------------------------------------------------
  // 5. Leftover lexical sightings: what the scanner saw and the parser did
  //    not. Fence sightings pair into lexical-only environments; the rest mint
  //    lexical-only entities. Every one carries a named diagnostic.
  // -------------------------------------------------------------------------
  const leftoverBegins: LexicalSighting[] = [];
  const leftoverEnds: LexicalSighting[] = [];
  for (const s of lexSightings) {
    if (lex.consumed.has(s)) continue;
    if (s.kind === "environment-begin") leftoverBegins.push(s);
    else if (s.kind === "environment-end") leftoverEnds.push(s);
  }

  // Pair leftover fences by name, innermost-first.
  const openStack: LexicalSighting[] = [];
  const pairedEnds = new Set<LexicalSighting>();
  const allLeftoverFences = [...leftoverBegins, ...leftoverEnds].sort(
    (a, b) => a.span.startUtf16 - b.span.startUtf16
  );
  for (const s of allLeftoverFences) {
    if (s.kind === "environment-begin") {
      openStack.push(s);
      continue;
    }
    let matched = false;
    for (let k = openStack.length - 1; k >= 0; k--) {
      if (openStack[k].name === s.name) {
        const begin = openStack[k];
        openStack.splice(k, 1);
        pairedEnds.add(s);
        lex.consumed.add(begin);
        lex.consumed.add(s);
        const span: SourceSpan = {
          sourceId,
          startUtf16: begin.span.startUtf16,
          endUtf16: s.span.endUtf16,
        };
        const id = mintEntityId("environment", span);
        const bodySpan: SourceSpan | undefined = begin.span.endUtf16 <= s.span.startUtf16
          ? { sourceId, startUtf16: begin.span.endUtf16, endUtf16: s.span.startUtf16 }
          : undefined;
        const role = classifyEnvRole(begin.name || "");
        const lexicalWitnesses = [lexWitness(begin), lexWitness(s)];
        entities.push({
          id,
          kind: "environment",
          name: begin.name || "",
          role,
          bodySpan,
          span,
          spanProvenance: "lexical",
          witnesses: lexicalWitnesses,
          agreement: "lexical-only",
          agreementBasis: "single-authority",
        });
        if (role === "math") {
          const mathId = mintEntityId("math", span);
          entities.push({
            id: mathId,
            kind: "math",
            mode: "display",
            carrier: { form: "env", name: begin.name || "" },
            fenceEntityId: id,
            span,
            spanProvenance: "lexical",
            witnesses: lexicalWitnesses,
            agreement: "lexical-only",
            agreementBasis: "single-authority",
          });
          disagreementDiagnostic(
            mathId,
            "lexical-only",
            span,
            `Math environment carrier '${begin.name}'`
          );
        }
        disagreementDiagnostic(id, "lexical-only", span, `Environment '${begin.name}'`);
        matched = true;
        break;
      }
    }
    if (!matched) {
      diagnostics.push({
        code: DiagnosticCodes.UnmatchedEnd,
        severity: "warning",
        message: `\\end{${s.name}} without a witnessed \\begin`,
        sourceId,
        span: s.span,
        witness: "lexical",
      });
      lex.consumed.add(s);
      mintUnmatchedFence(s, "end");
    }
  }
  for (const begin of openStack) {
    diagnostics.push({
      code: DiagnosticCodes.UnmatchedBegin,
      severity: "warning",
      message: `\\begin{${begin.name}} without a witnessed \\end`,
      sourceId,
      span: begin.span,
      witness: "lexical",
    });
    lex.consumed.add(begin);
    mintUnmatchedFence(begin, "begin");
  }

  /** An unmatched fence is still a witnessed control-sequence SITE: the
      diagnostic is the finding, the entity claims the bytes. */
  function mintUnmatchedFence(s: LexicalSighting, csname: "begin" | "end") {
    const ps = parserByStart.get(s.span.startUtf16);
    const tokenSpan: SourceSpan = {
      sourceId,
      startUtf16: s.span.startUtf16,
      endUtf16: s.span.startUtf16 + csname.length + 1,
    };
    const lexicalW: WitnessRecord = {
      witness: "lexical",
      span: tokenSpan,
      spanRole: "token",
      detail: csname,
    };
    const parserW = ps?.span ? parserWitness(ps.span, csname, "token") : undefined;
    const witnesses: WitnessRecord[] = [lexicalW];
    if (parserW) witnesses.unshift(parserW);
    const comparison = parserW
      ? compareWitnesses(
          "control-sequence-token",
          { ...parserW, semantics: { name: ps?.name } },
          { ...lexicalW, semantics: { name: csname } }
        )
      : undefined;
    const agreement: AgreementState = comparison
      ? comparison.equivalent ? "agreed" : "conflict"
      : "lexical-only";
    const id = mintEntityId("macro-invocation", tokenSpan);
    entities.push({
      id,
      kind: "macro-invocation",
      name: csname,
      span: tokenSpan,
      spanProvenance: "lexical",
      witnesses,
      agreement,
      agreementBasis: parserW ? "two-instrument" : "single-authority",
    });
    disagreementDiagnostic(id, agreement, tokenSpan, `Unmatched \\${csname} fence`, comparison?.reason);
  }

  // Sorted text runs for the script-operator yield rule below.
  const sortedRuns = [...witness.textRuns].sort((a, b) => a.startUtf16 - b.startUtf16);
  function insideTextRun(pos: number): boolean {
    let lo = 0;
    let hi = sortedRuns.length - 1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      if (sortedRuns[mid].startUtf16 <= pos) {
        if (pos < sortedRuns[mid].endUtf16) return true;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return false;
  }

  for (const s of lexSightings) {
    if (lex.consumed.has(s)) continue;
    // `^`/`_` are macros only in math mode; where the parser witnessed the
    // position as TEXT, the scanner's shallow guess yields to the parser —
    // the site is spine, not a control sequence.
    if ((s.name === "^" || s.name === "_") && insideTextRun(s.span.startUtf16)) {
      lex.consumed.add(s);
      continue;
    }
    if (CS_SIGHTING_KINDS.has(s.kind)) {
      const id = mintEntityId("macro-invocation", s.span);
      entities.push({
        id,
        kind: "macro-invocation",
        name: s.name || "",
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [lexWitness(s)],
        agreement: "lexical-only",
        agreementBasis: "single-authority",
      });
      disagreementDiagnostic(id, "lexical-only", s.span, `Control sequence \\${s.name}`);
    } else if (s.kind === "math") {
      const id = mintEntityId("math", s.span);
      const form = s.detail === "double-dollar" ? "double-dollar" as const
        : s.detail === "paren" ? "paren" as const
        : s.detail === "bracket" ? "bracket" as const
        : "dollar" as const;
      entities.push({
        id,
        kind: "math",
        mode: s.mode || "inline",
        carrier: { form },
        span: s.span,
        spanProvenance: "lexical",
        witnesses: [lexWitness(s)],
        agreement: "lexical-only",
        agreementBasis: "single-authority",
      });
      disagreementDiagnostic(id, "lexical-only", s.span, `Math carrier (${form})`);
    }
    // Remaining kinds (comment/verbatim sightings) are dormant when the
    // scanner consumes stratified text; strata already own those entities.
  }

  // -------------------------------------------------------------------------
  // 6. Catcode arbitration. Between \makeatletter and \makeatother, `@` IS a
  //    letter: the stateful lexical scanner reads @-names correctly there,
  //    while unified-latex tokenizes catcode-naively
  //    (\m@th → \m + "@th"). A name conflict inside such a region where the
  //    lexical reading extends the parser reading across an `@` is resolved
  //    FOR the lexical witness — by region evidence, not preference.
  // -------------------------------------------------------------------------
  const regionEvents: { start: number; kind: "on" | "off" }[] = [];
  for (const ent of entities) {
    if (ent.kind !== "macro-invocation") continue;
    if (ent.name === "makeatletter") regionEvents.push({ start: ent.span.startUtf16, kind: "on" });
    else if (ent.name === "makeatother") regionEvents.push({ start: ent.span.startUtf16, kind: "off" });
  }
  if (regionEvents.length > 0) {
    regionEvents.sort((a, b) => a.start - b.start);
    const regions: { from: number; to: number }[] = [];
    let openAt: number | null = null;
    for (const ev of regionEvents) {
      if (ev.kind === "on" && openAt === null) openAt = ev.start;
      else if (ev.kind === "off" && openAt !== null) {
        regions.push({ from: openAt, to: ev.start });
        openAt = null;
      }
    }
    if (openAt !== null) regions.push({ from: openAt, to: rawText.length });
    const inRegion = (pos: number) => regions.some((r) => pos >= r.from && pos < r.to);

    const arbitratedOldIds = new Set<string>();
    for (const ent of entities) {
      if (ent.agreement !== "conflict" || ent.kind !== "macro-invocation") continue;
      if (!inRegion(ent.span.startUtf16)) continue;
      const lexW = ent.witnesses.find((w) => w.witness === "lexical");
      const lexName = lexW?.detail || "";
      // The parser's reading must be a PROPER PREFIX of the lexical @-name:
      // unified-latex truncates csnames near #-parameter tokens (\m@th → m@t
      // or m), while the scanner reads byte-exactly. @-names are only
      // plausible readings inside the region — that is the evidence gate.
      if (
        !lexW ||
        !lexName.includes("@") ||
        !lexName.startsWith(ent.name) ||
        lexName.length <= ent.name.length
      ) {
        continue;
      }

      arbitratedOldIds.add(ent.id);
      ent.name = lexName;
      ent.span = lexW.span;
      ent.spanProvenance = "lexical";
      ent.agreement = "agreed";
      ent.agreementBasis = "two-instrument";
      ent.id = mintEntityId("macro-invocation", ent.span);
      diagnostics.push({
        code: DiagnosticCodes.CatcodeArbitrated,
        severity: "info",
        message: `\\${lexName}: catcode-naive parser tokenization yielded to the lexical reading inside a \\makeatletter region`,
        sourceId,
        span: ent.span,
        entityId: ent.id,
      });
    }
    if (arbitratedOldIds.size > 0) {
      for (let i = diagnostics.length - 1; i >= 0; i--) {
        const d = diagnostics[i];
        if (
          d.code === DiagnosticCodes.WitnessDisagreement &&
          d.entityId &&
          arbitratedOldIds.has(d.entityId)
        ) {
          diagnostics.splice(i, 1);
        }
      }
    }
  }

  return { sourceId, entities, diagnostics, extraClaims };
}

// ---------------------------------------------------------------------------
// BibTeX reconciliation
// ---------------------------------------------------------------------------

export function reconcileBib(
  sourceId: SourceId,
  rawText: string,
  lexSightings: BibLexicalSighting[],
  parseResult: ParseBibResult
): ReconcileResult {
  const entities: CensusEntity[] = [];
  const diagnostics: Diagnostic[] = [...parseResult.diagnostics];
  const extraClaims: PillarClaim[] = [];

  const lexByStart = new Map<number, BibLexicalSighting>();
  const consumed = new Set<BibLexicalSighting>();
  for (const s of lexSightings) {
    if (s.detail !== "implicit-comment" && s.detail !== "implicit-blank") {
      lexByStart.set(s.span.startUtf16, s);
    }
  }

  function fuseBib(
    span: SourceSpan,
    detail: string,
    construct: string
  ): {
    witnesses: WitnessRecord[];
    agreement: AgreementState;
    agreementBasis: AgreementBasis;
    reason?: WitnessEquivalenceReason;
  } {
    const parserW: WitnessRecord = {
      witness: "parser",
      instrument: "latex-utensils",
      span,
      spanRole: "construct",
      detail,
    };
    const witnesses: WitnessRecord[] = [parserW];
    const lexS = lexByStart.get(span.startUtf16);
    if (lexS) {
      const lexicalW: WitnessRecord = {
        witness: "lexical",
        span: lexS.span,
        spanRole: "construct",
        detail: lexS.detail || lexS.kind,
      };
      witnesses.push(lexicalW);
      consumed.add(lexS);
      const comparison = compareWitnesses(
        "bib-construct",
        { ...parserW, semantics: { construct } },
        { ...lexicalW, semantics: { construct: lexS.kind === "bib-entry" ? `entry:${lexS.entryType}` : lexS.kind } }
      );
      return {
        witnesses,
        agreement: comparison.equivalent ? "agreed" : "conflict",
        agreementBasis: "two-instrument",
        reason: comparison.reason,
      };
    }
    return { witnesses, agreement: "parser-only", agreementBasis: "single-authority" };
  }

  function bibDisagreement(
    entityId: string,
    agreement: AgreementState,
    span: SourceSpan,
    what: string,
    reason?: WitnessEquivalenceReason
  ) {
    if (agreement === "agreed") return;
    diagnostics.push({
      code: DiagnosticCodes.WitnessDisagreement,
      severity: "info",
      message: `${what} witnessed ${agreement === "parser-only" ? "by the parser only" : agreement === "lexical-only" ? "by the lexical scanner only" : `with conflicting evidence (${reason || "policy mismatch"})`}`,
      sourceId,
      span,
      entityId,
      witness: agreement === "parser-only" ? "parser" : "lexical",
    });
  }

  for (const entry of parseResult.entries) {
    const { witnesses, agreement, agreementBasis, reason } = fuseBib(
      entry.span,
      `bib-entry:${entry.entryType}`,
      `entry:${entry.entryType}`
    );
    const entryId = mintEntityId("bib-entry", entry.span);
    entities.push({
      id: entryId,
      kind: "bib-entry",
      entryType: entry.entryType,
      citeKey: entry.citeKey,
      bodySpan: entry.bodySpan,
      span: entry.span,
      spanProvenance: "parser",
      witnesses,
      agreement,
      agreementBasis,
    });
    bibDisagreement(entryId, agreement, entry.span, `Bib entry @${entry.entryType}`, reason);

    // Fields are independently evidenced rows. A parent entry's lexical
    // witness cannot be inherited as field agreement.
    for (const field of entry.fields) {
      const fieldId = mintEntityId("bib-field", field.valueSpan);
      entities.push({
        id: fieldId,
        kind: "bib-field",
        entryId,
        fieldName: field.fieldName,
        valueSpan: field.valueSpan,
        valueShape: field.valueShape,
        parts: field.parts,
        span: field.valueSpan,
        spanProvenance: "parser",
        witnesses: [
          {
            witness: "parser",
            instrument: "latex-utensils",
            span: field.valueSpan,
            spanRole: "value",
            detail: `bib-field:${field.fieldName}`,
          },
        ],
        agreement: "parser-only",
        agreementBasis: "single-authority",
      });
      bibDisagreement(fieldId, "parser-only", field.valueSpan, `Bib field '${field.fieldName}'`);
    }
  }

  for (const str of parseResult.strings) {
    const { witnesses, agreement, agreementBasis, reason } = fuseBib(str.span, "bib-string", "bib-string");
    const id = mintEntityId("bib-string", str.span);
    entities.push({
      id,
      kind: "bib-string",
      abbreviationName: str.abbreviationName,
      valueSpan: str.valueSpan,
      span: str.span,
      spanProvenance: "parser",
      witnesses,
      agreement,
      agreementBasis,
    });
    bibDisagreement(id, agreement, str.span, "Bib @string", reason);
  }

  for (const pre of parseResult.preambles) {
    const { witnesses, agreement, agreementBasis, reason } = fuseBib(pre.span, "bib-preamble", "bib-preamble");
    const id = mintEntityId("bib-preamble", pre.span);
    entities.push({
      id,
      kind: "bib-preamble",
      span: pre.span,
      spanProvenance: "parser",
      witnesses,
      agreement,
      agreementBasis,
    });
    bibDisagreement(id, agreement, pre.span, "Bib @preamble", reason);
  }

  for (const comm of parseResult.comments) {
    const { witnesses, agreement, agreementBasis, reason } = fuseBib(comm.span, "bib-comment", "bib-comment");
    const id = mintEntityId("bib-comment", comm.span);
    entities.push({
      id,
      kind: "bib-comment",
      commentForm: "explicit",
      span: comm.span,
      spanProvenance: "parser",
      witnesses,
      agreement,
      agreementBasis,
    });
    bibDisagreement(id, agreement, comm.span, "Bib @comment", reason);
  }

  for (const lexS of lexSightings) {
    if (lexS.detail === "implicit-comment") {
      // Inter-entry text: BibTeX ignores it, so the lexical scanner is the
      // only possible instrument — single-witness by design.
      entities.push({
        id: mintEntityId("bib-comment", lexS.span),
        kind: "bib-comment",
        commentForm: "implicit",
        span: lexS.span,
        spanProvenance: "lexical",
        witnesses: [{ witness: "lexical", span: lexS.span, spanRole: "construct", detail: "implicit-comment" }],
        agreement: "agreed",
        agreementBasis: "single-authority",
      });
    } else if (lexS.detail === "implicit-blank") {
      // Whitespace between entries: claimed, never an entity.
      extraClaims.push({ pillar: "spine", span: lexS.span, role: "blank-run" });
    } else if (!consumed.has(lexS)) {
      // The scanner saw an @-construct the parser did not report.
      const id = mintEntityId(lexS.kind, lexS.span);
      if (lexS.kind === "bib-entry") {
        entities.push({
          id,
          kind: "bib-entry",
          entryType: lexS.entryType || "",
          citeKey: lexS.citeKey,
          span: lexS.span,
          spanProvenance: "lexical",
          witnesses: [{ witness: "lexical", span: lexS.span, spanRole: "construct", detail: lexS.detail || "bib-entry" }],
          agreement: "lexical-only",
          agreementBasis: "single-authority",
        });
      } else if (lexS.kind === "bib-string") {
        entities.push({
          id,
          kind: "bib-string",
          abbreviationName: lexS.abbreviationName || "",
          span: lexS.span,
          spanProvenance: "lexical",
          witnesses: [{ witness: "lexical", span: lexS.span, spanRole: "construct", detail: "bib-string" }],
          agreement: "lexical-only",
          agreementBasis: "single-authority",
        });
      } else if (lexS.kind === "bib-preamble") {
        entities.push({
          id,
          kind: "bib-preamble",
          span: lexS.span,
          spanProvenance: "lexical",
          witnesses: [{ witness: "lexical", span: lexS.span, spanRole: "construct", detail: "bib-preamble" }],
          agreement: "lexical-only",
          agreementBasis: "single-authority",
        });
      } else {
        entities.push({
          id,
          kind: "bib-comment",
          commentForm: lexS.commentForm || "explicit",
          span: lexS.span,
          spanProvenance: "lexical",
          witnesses: [{ witness: "lexical", span: lexS.span, spanRole: "construct", detail: lexS.detail || "bib-comment" }],
          agreement: "lexical-only",
          agreementBasis: "single-authority",
        });
      }
      bibDisagreement(id, "lexical-only", lexS.span, `Bib construct @${lexS.entryType || lexS.kind}`);
    }
  }

  return { sourceId, entities, diagnostics, extraClaims };
}
