/**
 * TeXdig contract-tier DTOs consumed by downstream stages.
 *
 * Rows are compiled from physical census evidence and carry the source slices
 * required for interpretation. The deposit tree remains the evidence substrate.
 * The jsonl_engine schema registry is the normative emitted-store authority;
 * these types are the in-language DTO layer used by compilers and emitters.
 *
 * Linking convention: every discrete object's id is `{class}:{locator}` with
 * classes from ID_CLASSES below. The id string is the verbatim join key
 * everywhere — no re-keying; all joins are string equality. Content references
 * are ALWAYS the array form (text runs alternating with refs); a masked text
 * rendering is a debug view, never a stored artifact.
 *
 * Erasable-syntax TypeScript only (Node native type stripping).
 */

import type {
  DeclarationActivation,
  DeclarationContext,
  EntityId,
  SourceId,
  SourceSpan,
  SpanProvenance,
  MathCarrier,
  SignatureEvidence,
} from "./types.ts";

export const CONTRACT_SCHEMA_VERSION = "texdig-contract/0.3" as const;

// ---------------------------------------------------------------------------
// ID grammar
// ---------------------------------------------------------------------------

/**
 * Registered id classes and their store residency: the prefix alone tells a
 * consumer which artifact to open. Locators are span addresses into the frozen
 * tree (stable across runs over the same tree) unless noted.
 */
export const ID_CLASSES = {
  src: "sources.jsonl",
  ent: "entities.jsonl",
  walk: "walk.jsonl",
  zone: "zones.jsonl",
  def: "macros.jsonl",
  refitem: "references.jsonl",
  ptr: "pointers.jsonl",
  fm: "frontmatter.jsonl",
  /** Elaboration tier: per-site macro expansions, origin-chained to ent: ids. */
  exp: "expansion.jsonl",
  /** One execution occurrence of a physical source. */
  occ: "occurrences.jsonl",
  /** One chronological definition/binding event. */
  bind: "bindings.jsonl",
  /** One execution scope frame. */
  scope: "bindings.jsonl",
  /** One configured package/class summon. */
  summon: "bindings.jsonl",
  /** One declaration sighting that was deliberately not executed. */
  disposition: "bindings.jsonl",
  /** One binding-dependent invocation occurrence. */
  inv: "invocations.jsonl",
} as const;

export type IdClass = keyof typeof ID_CLASSES;

// ---------------------------------------------------------------------------
// Shared order space
// ---------------------------------------------------------------------------

/**
 * `seq` is one strict, bundle-local execution-event order space. It is never a
 * persistent identity; ids are route/site derived and do not contain seq.
 */
export type Seq = number;

// ---------------------------------------------------------------------------
// occurrences.jsonl — execution occurrences of physical sources
// ---------------------------------------------------------------------------

export interface SourceOccurrence {
  id: string; // occ:...
  sourceId: SourceId;
  parentOccurrenceId?: string;
  includeEntityId?: EntityId;
  includeChain: SourceId[];
  basis: "manifest-entrypoint" | "literal-directive";
  state: "entered" | "cycle-cut" | "deferred-context";
  enterSeq: Seq;
  exitSeq: Seq;
  cycleTargetOccurrenceId?: string;
  deferredReason?: "definition-body" | "conditional" | "argument-body" | "unknown-context";
}

export interface BindingSymbol {
  namespace: "control-sequence" | "environment";
  name: string;
}

export type BindingMeaning =
  | {
      kind: "declaration";
      entityId: EntityId;
      availability: "body" | "signature-only" | "opaque";
      signature: SignatureEvidence;
    }
  | { kind: "primitive"; name: string; signature: SignatureEvidence }
  | { kind: "captured"; sourceBindingEventId: string; signature: SignatureEvidence }
  | { kind: "character-token"; text: string; catcode: "unknown"; signature: SignatureEvidence }
  | { kind: "opaque"; entityId?: EntityId; reason: string; signature: SignatureEvidence }
  | { kind: "indeterminate"; reason: string; causeIds: string[]; signature: SignatureEvidence };

export interface ScopeFrame {
  rowType: "scope-frame";
  id: string; // scope:...
  kind: "global" | "document" | "brace-group" | "environment" | "begingroup";
  parentScopeId?: string;
  occurrenceId?: string;
  enterSeq: Seq;
  exitSeq?: Seq;
  status: "open" | "closed" | "unterminated" | "indeterminate";
  openSpan?: SourceSpan;
  closeSpan?: SourceSpan;
  openText?: string;
  closeText?: string;
}

export interface ConfiguredSummon {
  rowType: "configured-summon";
  id: string; // summon:...
  seq: Seq;
  occurrenceId: string;
  scopeId: string;
  physicalEntityId: EntityId;
  command: "documentclass" | "usepackage" | "RequirePackage";
  targetOrdinal: number;
  packageName: string;
  siteSpan: SourceSpan;
  targetSpan: SourceSpan;
  optionsSpan?: SourceSpan;
  optionsText?: string;
  text: string;
  outcome: "loaded" | "already-loaded" | "unconfigured" | "indeterminate";
  candidateEntityIds: EntityId[];
}

export interface BindingEvent {
  rowType: "binding-event";
  id: string; // bind:...
  seq: Seq;
  occurrenceId?: string;
  executionScopeId: string;
  targetScopeId: string;
  symbol: BindingSymbol;
  cause:
    | { kind: "physical-declaration"; entityId: EntityId; siteSpan: SourceSpan }
    | { kind: "configured"; summonId: string; entityId: EntityId }
    | { kind: "baseline" }
    | { kind: "scope-exit"; scopeId: string };
  operation:
    | "new"
    | "renew"
    | "provide"
    | "assign"
    | "global-assign"
    | "expanded-assign"
    | "global-expanded-assign"
    | "let-capture"
    | "configured-install"
    | "baseline-install"
    | "restore";
  effect:
    | "installed"
    | "skipped-existing"
    | "invalid-precondition"
    | "restored"
    | "indeterminate";
  priorBindingEventId?: string;
  restoredBindingEventId?: string;
  installedMeaning?: BindingMeaning;
  /** Exact declaration/summon slice for source-backed events. */
  text?: string;
}

export interface DeclarationDisposition {
  rowType: "declaration-disposition";
  id: string; // disposition:...
  seq: Seq;
  occurrenceId: string;
  entityId: EntityId;
  reason: "definition-body" | "conditional" | "argument-body" | "unknown-context";
  text: string;
}

export type BindingRow = ScopeFrame | ConfiguredSummon | BindingEvent | DeclarationDisposition;

export type ArgumentKind =
  | "mandatory"
  | "optional"
  | "star"
  | "token"
  | "embellishment"
  | "until";

export type ArgumentDelimiter =
  | "brace"
  | "bracket"
  | "bare-character"
  | "control-sequence"
  | "none";

export interface ArgumentAttachment {
  slot: number;
  kind: ArgumentKind;
  source: "explicit" | "omitted" | "default";
  delimiter: ArgumentDelimiter;
  /** Full source extent including delimiters, when source syntax exists. */
  span?: SourceSpan;
  /** Interior extent; may be zero-length for an explicit empty argument. */
  contentSpan?: SourceSpan;
  defaultText?: string;
  marker?: string;
  terminator?: string;
}

export interface InvocationOccurrence {
  id: string; // inv:...
  seq: Seq;
  occurrenceId: string;
  entityId: EntityId;
  name: string;
  siteKind: "control-sequence" | "environment-begin";
  /** Canonical physical token/begin-fence anchor. */
  siteSpan: SourceSpan;
  binding:
    | { state: "bound"; bindingEventId: string; signature: SignatureEvidence }
    | { state: "unbound" }
    | { state: "indeterminate"; causeIds: string[]; detail: string }
    | { state: "deferred"; reason: string };
  /** Binding-dependent syntax hull at this occurrence. */
  span: SourceSpan;
  arguments: ArgumentAttachment[];
  status: "attached" | "unbound" | "deferred" | "indeterminate" | "malformed";
  /** Exact binding-dependent invocation hull slice. */
  text: string;
}

/** Content is stored ONLY in this array form. Refs are verbatim ids. */
export type ContentPart = { text: string } | { ref: string };

// ---------------------------------------------------------------------------
// walk.jsonl — traversal-serialized document structure
// ---------------------------------------------------------------------------

export type WalkNode =
  | {
      id: string; // walk:...
      seq: Seq;
      kind: "section";
      /** Sectioning command name as written: section, subsection*, ... */
      command: string;
      level: number;
      title: ContentPart[];
      span: SourceSpan;
      /** Include stack from entrypoint to the file holding this node. */
      includeChain: SourceId[];
    }
  | {
      id: string;
      seq: Seq;
      kind: "paragraph";
      content: ContentPart[];
      span: SourceSpan;
      includeChain: SourceId[];
    }
  | {
      id: string;
      seq: Seq;
      /** Placement anchor for a zone that interrupts the prose flow (floats, display math, verbatim blocks). */
      kind: "anchor";
      zone: string; // zone:...
      span: SourceSpan;
      includeChain: SourceId[];
    };

// ---------------------------------------------------------------------------
// zones.jsonl — compiled, closure-sealed content units
// ---------------------------------------------------------------------------

export type ZoneKind =
  | "math-inline"
  | "math-display"
  | "diagram"
  | "verbatim"
  | "float"
  | "theorem-like"
  /** A control-sequence site the walk did not expand. A hole only when `unresolved` is present. */
  | "macro-site"
  /** An include the traversal did not enter (cycle cut or deferred context): a missing subtree. */
  | "unentered-source";

/**
 * Why a zone's content is not knowable at this tier. Presence of this field is
 * the definition of a HOLE — `macro-site` without it is a bound site awaiting
 * expansion, not a gap in knowledge. Hole extents are what `holeFraction`
 * measures, and it must fall monotonically as the binding tier lands.
 */
export interface ZoneUnresolved {
  reason: "unbound" | "indeterminate" | "deferred" | "unentered-source";
  /** Control-sequence name, or the source id of the subtree not entered. */
  name?: string;
  /** Verbatim `bind:` causes from `invocations.jsonl` for the indeterminate case. */
  causeIds?: string[];
  detail?: string;
}

/**
 * W2 minimal zone: everything the walk projection can mint deterministically.
 * The Cut-2 zones tier GROWS these same `zone:` ids with `closure`, `names`,
 * `isolable`, and `validation` — it does not create new ones. See `Zone` below
 * for the grown form.
 */
export interface ZoneStub {
  id: string; // zone:...
  seq: Seq;
  kind: ZoneKind;
  span: SourceSpan;
  /** Exact source slice — never printRaw, never expanded. */
  text: string;
  unresolved?: ZoneUnresolved;
}

/**
 * Per-name binding verdict. `bound-out-of-scope` is the third state agy's
 * review forced: the name binds in an in-tree file stage 1 deliberately does
 * not parse (.sty/.cls), which is not "unresolved" — calling it that would
 * poison isolability and validation for every natbib/acl paper.
 */
export type NameBinding = "bound" | "bound-out-of-scope" | "unresolved";

/** Three-state verdict with recorded reason; downstream must not trust a bare boolean that silently improves later. */
export interface Verdict {
  verdict: boolean | null;
  reason: string;
  version: string;
}

export type ValidationStatus = "pass" | "fail" | "unsupported-by-validator" | "skipped";

export interface ZoneValidation {
  status: ValidationStatus;
  instrument?: "katex" | "tikz-render";
  detail?: string;
  version?: string;
}

export interface Zone {
  id: string; // zone:...
  seq: Seq;
  kind: ZoneKind;
  span: SourceSpan;
  spanProvenance: SpanProvenance;
  /** Exact source slice — never printRaw, never expanded. */
  text: string;
  /** Composite zones (float with caption, theorem body) expose interior structure in the same array form. */
  content?: ContentPart[];
  carrier?: MathCarrier;
  /** Direct control-sequence names used, each with its binding verdict. */
  names: { name: string; binding: NameBinding; target?: string }[];
  /** Transitive closure of in-document definitions required (def: ids). */
  closure: string[];
  context: { inMathMode?: boolean; environments: string[] };
  isolable: Verdict;
  validation: ZoneValidation;
  /** Census provenance. */
  entityId: EntityId;
}

// ---------------------------------------------------------------------------
// macros.jsonl — compiled definition store
// ---------------------------------------------------------------------------

export interface MacroRecord {
  id: string; // def:...
  defines: "macro" | "environment";
  definedName: string;
  dialect: string; // DefinitionDialect from the census entity
  signatureRaw?: string;
  argumentSpec?: string;
  /** Body extent and slice are knowable even when expansion is not (\def, \let). */
  bodySpan?: SourceSpan;
  bodyText?: string;
  elaborable: boolean;
  /** Lexical control-sequence names in the body; bindings resolve per use. */
  nameRefs: string[];
  /**
   * sha256 of the normalized body — the document-independent identity a
   * cross-corpus specimen store needs; stamped at emission because it is
   * impossible to backfill consistently later.
   */
  bodyFingerprint?: string;
  context: DeclarationContext;
  activation: DeclarationActivation;
  definedWithin?: EntityId;
  entityId: EntityId;
}

// ---------------------------------------------------------------------------
// references.jsonl — canonical reference items
// ---------------------------------------------------------------------------

/**
 * The canonical ordinal is ALWAYS normalized: 1-based, order of first citation
 * appearance (shared seq space). The paper's own register — alpha labels,
 * compiled list position — is preserved beside it as evidence, never as the
 * canonical index. When canonical ordinals and source labels correspond 1:1
 * the reindex is clean; deviations are findings.
 */
export type OrdinalBasis = "appearance" | "list-order-fallback" | "list-appended";

export type ReferenceFieldSource = "bib" | "bbl" | "inline-thebibliography" | "provider";

export interface ReferenceItem {
  id: string; // refitem:...
  ordinal: number;
  ordinalBasis: OrdinalBasis;
  cited: boolean;
  firstCitationSeq?: Seq;
  /** The paper's own label form where witnessed (e.g. "[ABC09]", bibitem option). */
  sourceLabel?: string;
  /** Position in the compiled/inline list where one exists. */
  listPosition?: number;
  citeKeys: string[];
  identifiers: { doi?: string; arxiv?: string; url?: string };
  /** Structured fields, each valued with per-field provenance under the registered merge policy. */
  fields: Record<string, { value: string; source: ReferenceFieldSource; span?: SourceSpan }>;
  /** Formatted item text from the compiled list, when witnessed. */
  formattedText?: string;
}

// ---------------------------------------------------------------------------
// pointers.jsonl — label declarations and pointer sites
// ---------------------------------------------------------------------------

export type PointerRecord =
  | {
      id: string; // ptr:...
      kind: "label-declaration";
      key: string;
      /** What the label attaches to (zone:/walk:/ent: id). */
      attachesTo?: string;
      span: SourceSpan;
      seq: Seq;
    }
  | {
      id: string;
      kind: "pointer-site";
      /**
       * Command as written. Pointer-hood is derived transitively from macro
       * definition bodies, not from a fixed vocabulary — \secref defined via
       * \def, and even a redefined \eqref, must land here.
       */
      command: string;
      pointerClass: "citation" | "internal-ref";
      keys: string[];
      resolvedTargets: string[]; // refitem: or ptr:(label-declaration) ids
      unresolvedKeys: string[];
      span: SourceSpan;
      seq: Seq;
    };

// ---------------------------------------------------------------------------
// frontmatter.jsonl — span-anchored declared metadata
// ---------------------------------------------------------------------------

/**
 * Span-anchored rows, not flat strings: gate 3 applies to frontmatter too.
 * The \author blob stays one row; splitting it into an author list is
 * interpretation and lives downstream.
 */
export interface FrontmatterRecord {
  id: string; // fm:...
  kind: "title" | "author-blob" | "date" | "abstract" | "declaration";
  /** Declaration command for kind "declaration" (e.g. keywords, thanks). */
  command?: string;
  span: SourceSpan;
  text: string;
  seq: Seq;
}

// ---------------------------------------------------------------------------
// graph.jsonl — relational projection (graph-primitive-aligned)
// ---------------------------------------------------------------------------

/**
 * Mechanically derived at emission from the other stores; asserts nothing new,
 * so it can never disagree with them. Row shapes conform to
 * codex-scientiae/graph-primitive/0.1: both ends anchored, address-valued
 * identities — the two properties the legacy refgraph lacked. To be registered
 * against the primitive, not left as an unregistered convention.
 *
 * The relation vocabulary is canon-in-formation: the kind/relation superset is
 * the owner's design surface. Entries here are a working set to strike,
 * rename, and extend — not an ontology.
 */
export const RELATIONS = {
  Contains: "contains",
  Precedes: "precedes",
  Refs: "refs",
  Requires: "requires",
  BindsTo: "binds-to",
  DeclaresLabel: "declares-label",
  TargetsLabel: "targets-label",
  Cites: "cites",
  InheritsCrossref: "inherits-crossref",
  WitnessedBy: "witnessed-by",
  AttachesTo: "attaches-to",
} as const;

export type RelationKind = (typeof RELATIONS)[keyof typeof RELATIONS];

export type GraphRow =
  | {
      type: "node";
      id: string;
      label: string;
      class: IdClass;
      properties?: Record<string, unknown>;
    }
  | {
      type: "edge";
      source: string;
      target: string;
      relation: RelationKind;
      properties?: Record<string, unknown>;
    };
