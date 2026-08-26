/**
 * TeXdig stage-1 census types — the working schema for the census/assembly stage.
 *
 * These shapes are the stage-1 contract: a closed, span-addressed inventory of every
 * knowable carrier on the source surface, reconciled between two witnesses, with
 * coverage accounting over every source file. Mechanical only — no expansion,
 * no interpretation. See ../README.md for the exit gates.
 *
 * Erasable-syntax TypeScript only: this file must run under Node's native type
 * stripping (unions and const objects, no enums/namespaces).
 */

/**
 * 0.4 adds the walk projection: `walk.jsonl` and the minimal `zones.jsonl`
 * leave the deferred set. Row shapes of the nine 0.3 stores are unchanged, so
 * their schema identities hold; `summary.json` moves because its store lists
 * are pinned by `const` in the validator.
 */
export const CENSUS_SCHEMA_VERSION = "texdig-census/0.4" as const;

/** Normative schema identities for every store emitted by the census. */
export const CENSUS_STORE_SCHEMAS = {
  "sources.jsonl": "codex-scientiae/texdig-sources/0.2",
  "entities.jsonl": "codex-scientiae/texdig-entities/0.3",
  "claims.jsonl": "codex-scientiae/texdig-claims/0.2",
  "coverage.json": "codex-scientiae/texdig-coverage/0.2",
  "diagnostics.jsonl": "codex-scientiae/texdig-diagnostics/0.3",
  "occurrences.jsonl": "codex-scientiae/texdig-occurrences/0.3",
  "bindings.jsonl": "codex-scientiae/texdig-bindings/0.3",
  "invocations.jsonl": "codex-scientiae/texdig-invocations/0.3",
  "walk.jsonl": "codex-scientiae/texdig-walk/0.4",
  "zones.jsonl": "codex-scientiae/texdig-zones/0.4",
  "summary.json": "codex-scientiae/texdig-summary/0.4",
} as const;

/** Contract-tier stores the census explicitly does not emit yet. */
export const CENSUS_DEFERRED_STORES = [
  "expansion.jsonl",
  "macros.jsonl",
  "references.jsonl",
  "pointers.jsonl",
  "frontmatter.jsonl",
  "graph.jsonl",
] as const;

// ---------------------------------------------------------------------------
// Source addressing
// ---------------------------------------------------------------------------

/** Forward-slash path relative to the deposited `{slug}-tex/` root. */
export type SourceId = string;

/**
 * Canonical coordinates are UTF-16 code units (JS-native parser positions).
 * Byte offsets are boundary projections computed at emission when a consumer
 * declares them; they are never a second source of truth.
 */
export interface SourceSpan {
  sourceId: SourceId;
  /** Inclusive start, UTF-16 code units. */
  startUtf16: number;
  /** Exclusive end, UTF-16 code units. */
  endUtf16: number;
}

export type SourceLanguage = "latex" | "bibtex" | "asset";

/**
 * Engine classification of each file in the deposited tree. The census parses
 * include-graph-reachable LaTeX, bibliography resources, and the .bbl sidecar.
 * Explicitly included class/style or extensionless targets acquire an
 * effective language and are parsed; unreached class/style/asset files remain
 * byte-inventoried. A .tex file reachable by no include edge is a diagnostic,
 * not a silent omission.
 */
export type SourceRole =
  | "entrypoint"
  | "included"
  | "bibliography-resource"
  | "bbl-sidecar"
  /**
   * .bst — BibTeX style programs; not LaTeX, consumed only by the bibtex
   * compiler. With a .bbl present their work is already baked in; in
   * bib-without-bbl trees the .bst is the ordering-policy EVIDENCE the
   * reference canon reads (via \bibliographystyle), not redundancy.
   */
  | "bibliography-style"
  | "class-or-style"
  | "asset"
  | "unreachable-tex";

/** One row of `sources.jsonl`. */
export interface SourceFileRecord {
  id: SourceId;
  sha256: string;
  /** Exact deposited byte length. */
  bytes: number;
  /** Defined only when the byte stream was decoded as text. */
  lengthUtf16?: number;
  language: SourceLanguage;
  role: SourceRole;
  /** True when stage 1 actually parsed and coverage-audited this file. */
  parsed: boolean;
}

// ---------------------------------------------------------------------------
// Witnesses and agreement
// ---------------------------------------------------------------------------

/**
 * `configured` marks declared evidence: a signature injected from lane
 * configuration (e.g. the pinned unified-latex-ctan package records) rather
 * than sighted by an instrument. Its span anchors the in-document site that
 * summoned the declaration (the \usepackage/\documentclass invocation).
 */
export type WitnessKind = "lexical" | "parser" | "configured";

/** Which extent a witness span claims. */
export type WitnessSpanRole =
  | "token"
  | "construct"
  | "begin-fence"
  | "end-fence"
  | "content"
  | "value"
  | "summon-anchor";

export interface WitnessRecord {
  witness: WitnessKind;
  span: SourceSpan;
  spanRole: WitnessSpanRole;
  /** Which instrument produced the sighting: unified-latex for LaTeX/.bbl, latex-utensils for .bib, unified-latex-ctan for configured declarations. */
  instrument?: "unified-latex" | "latex-utensils" | "unified-latex-ctan";
  /** Scanner rule or parser node type that produced this sighting. */
  detail?: string;
}

/**
 * Reconciliation state of one entity across the two witnesses. Anything other
 * than `agreed` must be accompanied by a diagnostic naming the discrepancy.
 */
export type AgreementState = "agreed" | "lexical-only" | "parser-only" | "conflict";

/** Evidence policy under which an agreement state was assigned. */
export type AgreementBasis =
  | "two-instrument"
  | "single-authority"
  | "configured-declaration";

/**
 * Parser macro-node positions exclude attached arguments and Argument wrappers
 * may be positionless, so full extents are sometimes computed as a hull from
 * control-sequence + argument-content spans. Synthesized spans must never be
 * mistaken for parser-given ones.
 */
export type SpanProvenance = "parser" | "lexical" | "synthesized-hull";

// ---------------------------------------------------------------------------
// Entity identity
// ---------------------------------------------------------------------------

/**
 * Deterministic address string under the shared id grammar (see contracts.ts
 * ID_CLASSES): physical sites use
 * `ent:{kind}@{sourceId}:{startUtf16}-{endUtf16}`. Configured declarations use
 * `ent:{definition-kind}@configured/{package}:{name}` because several package
 * declarations may share one in-document summon anchor. Because the deposited
 * tree is frozen and fingerprinted, span-addressed IDs are stable across runs
 * over the same tree, and the id string is the verbatim join key everywhere.
 * Later stages mint derived entities under their own classes, chaining back to
 * these via Origin.
 */
export type EntityId = string;

// ---------------------------------------------------------------------------
// Census entities (discriminated on `kind` — keep switches exhaustive)
// ---------------------------------------------------------------------------

interface CensusEntityBase {
  id: EntityId;
  span: SourceSpan;
  spanProvenance: SpanProvenance;
  witnesses: WitnessRecord[];
  agreement: AgreementState;
  agreementBasis: AgreementBasis;
}

/**
 * How a macro definition was declared. `configured` marks signatures injected
 * from lane configuration rather than discovered in the document; `def`-dialect
 * sites are detected and cataloged even though they are not elaborable.
 */
export type DefinitionDialect =
  | "newcommand"
  | "renewcommand"
  | "providecommand"
  | "xparse"
  | "math-operator"
  | "paired-delimiter"
  | "let"
  | "def"
  | "gdef"
  | "edef"
  | "xdef"
  | "configured";

/**
 * Argument syntax evidence carried by a declaration or configured meaning.
 * A known zero-argument signature is `{ state: "known", spec: "" }`; it is
 * deliberately distinct from missing or custom-parser evidence.
 */
export type SignatureEvidence =
  | { state: "known"; spec: string }
  | { state: "custom-parser"; detail: string }
  | { state: "unknown"; detail?: string };

/** Lexical execution context. `unknown` is used until ancestry proves a narrower claim. */
export type DeclarationContext =
  | "document-flow"
  | "definition-body"
  | "group-local"
  | "conditional"
  | "argument-body"
  | "unknown";

/** Execution-time status; `unknown` prevents a physical sighting from asserting binding semantics. */
export type DeclarationActivation = "immediate" | "deferred" | "configured" | "unknown";

/** Delimiter identity of a math carrier — `display` alone loses env identity. */
export type MathCarrier =
  | { form: "dollar" }
  | { form: "double-dollar" }
  | { form: "paren" }
  | { form: "bracket" }
  | { form: "env"; name: string };

/**
 * Small-vocabulary environment roles assigned during census. Everything not in
 * a known vocabulary stays `generic`; refinement is downstream elaboration.
 * `bibliography` marks the thebibliography carrier WHEREVER it occurs — in a
 * .bbl, or inline in an \input'ed .tex file; the bibliography is a carrier the
 * census finds, not a file role.
 */
export type EnvironmentRole = "float" | "math" | "verbatim" | "bibliography" | "generic";

export type EnvelopeMarkerKind =
  | "documentclass"
  | "begin-document"
  | "end-document"
  | "section"
  | "appendix"
  | "bibliography";

/**
 * `bibliographystyle` is a resource tie, not a file inclusion: it names the
 * ordering policy and is the only in-document link to an in-tree .bst. Source
 * order is not a cue — it may appear after \bibliography.
 */
export type IncludeDirective =
  | "input"
  | "include"
  | "bibliography"
  | "addbibresource"
  | "bibliographystyle";

export type CensusEntityCore =
  /**
   * A control-sequence site not claimed by a more specific kind below.
   * Definition-forming, include, and envelope-forming commands are recorded
   * under their specific kinds only; this is the generic remainder.
   */
  | (CensusEntityBase & {
      kind: "macro-invocation";
      /** Control-sequence name without the backslash. */
      name: string;
      inMathMode?: boolean;
      /**
       * `span` is the physical control-sequence token only. Binding-dependent
       * hulls and arguments belong to invocation occurrences in contracts.ts.
       */
    })
  | (CensusEntityBase & {
      kind: "macro-definition";
      /**
       * The DEFINED macro's name (e.g. `pair` for \newcommand{\pair}...).
       * Csnames are recorded byte-exact and case-sensitive; names outside
       * [A-Za-z]+ occur in the corpus (\1, starred operators, @-names under
       * \makeatletter) and must survive as join keys.
       */
      definedName: string;
      /** Physical declaration command, preserved independently of dialect. */
      declarationCommand: string;
      dialect: DefinitionDialect;
      /** Raw signature text as written, e.g. `[2][d]` or an xparse spec. */
      signatureRaw?: string;
      /** Normalized argument specification used by the argument grammar. */
      argumentSpec?: string;
      /** Authoritative tri-state signature evidence for occurrence attachment. */
      signature: SignatureEvidence;
      /** Provider name for configured declarations. */
      configuredPackage?: string;
      /**
       * Body extent is knowable even when expansion is not: \def/\let bodies
       * carry spans so pointer-hood and dependencies can be derived from
       * non-elaborable definitions (e.g. \def\secref, a redefined \eqref).
       */
      bodySpan?: SourceSpan;
      /** False for dialects the elaborator cannot expand (e.g. `def`): detected-when-knowable, elaborated later or never. */
      elaborable: boolean;
      context: DeclarationContext;
      activation: DeclarationActivation;
      definedWithin?: EntityId;
    })
  | (CensusEntityBase & {
      kind: "environment-definition";
      /** The DEFINED environment's name (e.g. `lemma` for \newtheorem{lemma}...). */
      definedName: string;
      /** Physical declaration command, preserved independently of mechanism. */
      declarationCommand: string;
      /** `configured` = declared by lane configuration (package/class records), not defined in parsed source. */
      mechanism: "newtheorem" | "newenvironment" | "newfloat" | "configured";
      signatureRaw?: string;
      argumentSpec?: string;
      signature: SignatureEvidence;
      configuredPackage?: string;
      /** Counter/numbering argument as written, for newtheorem. */
      counterRaw?: string;
      /** Beginning and ending programs of a newenvironment declaration. */
      beginBodySpan?: SourceSpan;
      endBodySpan?: SourceSpan;
      context: DeclarationContext;
      activation: DeclarationActivation;
      definedWithin?: EntityId;
    })
  | (CensusEntityBase & {
      kind: "environment";
      name: string;
      role: EnvironmentRole;
      /** Interior extent between \begin{...} and \end{...}, when both fences are witnessed. */
      bodySpan?: SourceSpan;
    })
  /**
   * Math carriers. A math environment (equation, align, ...) yields BOTH an
   * `environment` entity (the fence) and a `math` entity (the carrier) over the
   * same extent, cross-linked here — overlays, not a partition.
   */
  | (CensusEntityBase & {
      kind: "math";
      mode: "inline" | "display";
      carrier: MathCarrier;
      fenceEntityId?: EntityId;
    })
  | (CensusEntityBase & {
      kind: "verbatim-inline";
      /** The \verb delimiter character actually used. */
      delimiter: string;
    })
  | (CensusEntityBase & { kind: "comment" })
  | (CensusEntityBase & { kind: "paragraph-break" })
  | (CensusEntityBase & {
      kind: "include";
      directive: IncludeDirective;
      /** Target exactly as written in the source. */
      targetRaw: string;
      resolvedSourceId?: SourceId;
    })
  | (CensusEntityBase & {
      kind: "envelope-marker";
      marker: EnvelopeMarkerKind;
      /** Sectioning command name (`section`, `subsection*`, ...) when marker is `section`. */
      name?: string;
    })
  // --- BibTeX census entities (parser witness: latex-utensils) -------------
  // The bib language mirrors the LaTeX census: @string is its macro-definition,
  // crossref its inheritance, and field values re-enter unified-latex as LaTeX
  // fragments in cut 2. Census records sites and shapes only; resolution
  // (@string substitution, concat folding, crossref) is a join, not a census.
  | (CensusEntityBase & {
      kind: "bib-entry";
      /** Entry type as written, lowercased (`article`, `inproceedings`, ...). */
      entryType: string;
      citeKey?: string;
      /** Interior extent between the entry braces, when both are witnessed. */
      bodySpan?: SourceSpan;
    })
  | (CensusEntityBase & {
      kind: "bib-string";
      /** The DEFINED abbreviation name — the bib analogue of `macro-definition`. */
      abbreviationName: string;
      valueSpan?: SourceSpan;
    })
  | (CensusEntityBase & { kind: "bib-preamble" })
  /** Explicit @comment blocks and implicit inter-entry text (BibTeX ignores it; coverage must not). */
  | (CensusEntityBase & {
      kind: "bib-comment";
      commentForm: "explicit" | "implicit";
    })
  | (CensusEntityBase & {
      kind: "bib-field";
      /** The owning `bib-entry` (or `bib-string`) entity. */
      entryId: EntityId;
      /** Field name as written, lowercased. */
      fieldName: string;
      valueSpan: SourceSpan;
      valueShape: BibValueShape;
      /** For `concat`, the parts with their own spans and shapes, as latex-utensils exposes them. */
      parts?: { span: SourceSpan; shape: Exclude<BibValueShape, "concat"> }[];
    });

/** Persisted entity rows add the exact raw source slice at emission. */
export type PersistedCensusEntity = CensusEntityCore & { text: string };

/** In-memory physical entity evidence before the emitter adds `text`. */
export type CensusEntity = CensusEntityCore;

/** Value shapes latex-utensils distinguishes; `abbreviation` sites are binding-join inputs in cut 2. */
export type BibValueShape = "text" | "number" | "abbreviation" | "concat";

export type CensusKind = CensusEntity["kind"];

// ---------------------------------------------------------------------------
// Pillar claims and coverage
// ---------------------------------------------------------------------------

export type Pillar = "envelope" | "spine" | "fence";

/**
 * One row of `claims.jsonl`. Spine claims are POSITIVE claims (text runs
 * witnessed lexically and/or as parser string/whitespace nodes) — the spine is
 * never defined as the complement of the other pillars, so residue stays a
 * real signal rather than a vacuous zero.
 *
 * The pillar vocabulary spans both languages: in .bib sources, entries,
 * @string, and @preamble claim as `fence`; inter-entry implicit-comment runs
 * claim as `spine`; `envelope` does not occur.
 */
export interface PillarClaim {
  pillar: Pillar;
  entityId?: EntityId;
  span: SourceSpan;
  /** Claim-specific label, e.g. `text-run`, `blank-run`, `float`, `fence`. */
  role: string;
}

export interface SourceCoverage {
  sourceId: SourceId;
  lengthUtf16: number;
  claimedUtf16: number;
  residueUtf16: number;
  /** Every unclaimed span — the seed of the defect-directed recovery queue. */
  residue: SourceSpan[];
}

// ---------------------------------------------------------------------------
// Diagnostics
// ---------------------------------------------------------------------------

export type DiagnosticSeverity = "info" | "warning" | "defect";

/**
 * Registered diagnostic codes — grow this registry, never emit free-string
 * codes. A code nobody registered is itself a defect.
 */
export const DiagnosticCodes = {
  WitnessDisagreement: "census/witness-disagreement",
  UnmatchedBegin: "census/unmatched-begin",
  UnmatchedEnd: "census/unmatched-end",
  UnterminatedVerbatim: "census/unterminated-verbatim",
  UnterminatedMath: "census/unterminated-math",
  SpanSynthesized: "census/span-synthesized",
  UnresolvedInclude: "census/unresolved-include",
  UnknownEnvironment: "census/unknown-environment",
  OpaqueRegion: "census/opaque-region",
  Residue: "census/residue",
  UnreachableSource: "census/unreachable-source",
  BibParseError: "census/bib-parse-error",
  BibDuplicateKey: "census/bib-duplicate-key",
  /** \input{Introduction} resolving to introduction.tex: on-disk casing wins, and the paper does not build on Linux — a finding, not something to smooth over. */
  IncludeCaseMismatch: "census/include-case-mismatch",
  OrdinalLabelMismatch: "census/ordinal-label-mismatch",
  /** The manifest entrypoint does not resolve to a file in the deposited tree — the census cannot start; nothing is smoothed over with a guess. */
  EntrypointMissing: "census/entrypoint-missing",
  /** The deposited tree no longer matches its manifest (file count drift): the frozen tree was modified after deposit, and attribution to the recorded sha256 would be a lie. */
  TreeManifestMismatch: "census/tree-manifest-mismatch",
  SourceDecodeError: "census/source-decode-error",
  InvalidSpan: "census/invalid-span",
  UntrustedParserSpan: "census/untrusted-parser-span",
  InvalidClaim: "census/invalid-claim",
  /** Summoned packages with no configured signature record — the curation queue for the configured channel, not an error. */
  ConfiguredGap: "census/configured-gap",
  /** The latex-utensils backfill instrument could not parse this source; lexical-only sites stay single-witness. */
  BackfillUnavailable: "census/backfill-unavailable",
  /** unified-latex threw on a parsed source: the parser witness is absent for the whole file, and every entity there is lexical-only by defect, not design. */
  LatexParseError: "census/latex-parse-error",
  /** A witness conflict resolved by catcode evidence: inside a \makeatletter region the lexical reading of an @-name is authoritative and the catcode-naive parser tokenization yields. */
  CatcodeArbitrated: "census/catcode-arbitrated",
  OccurrenceDeferred: "compile/occurrence-deferred",
  OccurrenceLimitExceeded: "compile/occurrence-limit-exceeded",
  BindingPrecondition: "compile/binding-precondition",
  BindingIndeterminate: "compile/binding-indeterminate",
  InvocationDeferred: "compile/invocation-deferred",
  InvocationMalformed: "compile/invocation-malformed",
  /** An expansion site retained expandable names after substitution — dangling parameters or unexpandable interior. */
  ExpansionIncomplete: "elaborate/expansion-incomplete",
  /** An expansion site failed to reach a fixed point within the round bound — self-referential or mutually recursive definitions. */
  ExpansionNonConverging: "elaborate/expansion-non-converging",
} as const;

export type DiagnosticCode = (typeof DiagnosticCodes)[keyof typeof DiagnosticCodes];

export interface Diagnostic {
  code: DiagnosticCode;
  severity: DiagnosticSeverity;
  message: string;
  /** Structured file identity for source-local diagnostics without a usable span. */
  sourceId?: SourceId;
  span?: SourceSpan;
  entityId?: EntityId;
  occurrenceId?: string;
  bindingId?: string;
  invocationId?: string;
  witness?: WitnessKind;
}

// ---------------------------------------------------------------------------
// Run summary
// ---------------------------------------------------------------------------

export interface CensusSummary {
  schema: typeof CENSUS_SCHEMA_VERSION;
  slug: string;
  /** The deposit's frozen tree fingerprint this census is attributed to. */
  treeSha256: string;
  entrypoint: SourceId;
  /**
   * Which stores this run emitted and which the cut deliberately defers —
   * absence of a contract-tier store is a statement, not an accident.
   */
  stores: {
    emitted: string[];
    deferred: (typeof CENSUS_DEFERRED_STORES)[number][];
  };
  /** Per-store normative schema identities. */
  storeSchemas: Record<string, string>;
  runtime: {
    node: string;
  };
  sourceCount: number;
  occurrenceCount: number;
  bindingRowCount: number;
  invocationCount: number;
  entityCounts: Partial<Record<CensusKind, number>>;
  agreementCounts: Partial<Record<AgreementState, number>>;
  diagnosticCounts: Partial<Record<DiagnosticSeverity, number>>;
  coverage: {
    totalUtf16: number;
    claimedUtf16: number;
    residueUtf16: number;
    residueSegments: number;
  };
  /**
   * Walk-level ledger. `holeFraction` is the tracked quality signal: it must
   * fall monotonically as the binding tier lands and never rise. A rise is a
   * regression in binding coverage, not a change in the corpus.
   */
  walk: {
    sectionCount: number;
    paragraphCount: number;
    anchorCount: number;
    zoneCount: number;
    /** Zones carrying an `unresolved` verdict. */
    holeCount: number;
    enteredUtf16: number;
    proseUtf16: number;
    zoneUtf16: number;
    holeUtf16: number;
    residueUtf16: number;
    holeFraction: number;
  };
}
