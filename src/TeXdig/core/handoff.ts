/**
 * TeXdig stage-1 handoff-tier types — the durable artifact contract downstream
 * consumes. Compiled from the census/evidence tier; self-contained (inline
 * slices ride every row downstream interprets); the deposit tree is evidence
 * substrate, not part of the handoff.
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
  EntityId,
  SourceId,
  SourceSpan,
  SpanProvenance,
  MathCarrier,
} from "./types.ts";

export const HANDOFF_SCHEMA_VERSION = "texdig-handoff/0.1" as const;

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
} as const;

export type IdClass = keyof typeof ID_CLASSES;

// ---------------------------------------------------------------------------
// Shared order space
// ---------------------------------------------------------------------------

/**
 * `seq` is one shared order space assigned during entrypoint traversal across
 * includes, covering walk nodes, zones, macro records, and pointer sites alike
 * — any two discrete objects are order-comparable by a field they carry.
 * Macro shadowing resolution uses the same scale; a second scale would drift.
 *
 * seq is a derived integer over span addresses: rows also carry enough
 * traversal context (includeChain on walk nodes) that ordering is
 * reconstructible without trusting the integer.
 */
export type Seq = number;

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
  | "theorem-like";

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
  seq: Seq;
  definedName: string;
  dialect: string; // DefinitionDialect from the census entity
  signatureRaw?: string;
  /** Body extent and slice are knowable even when expansion is not (\def, \let). */
  bodySpan?: SourceSpan;
  bodyText?: string;
  elaborable: boolean;
  /** Direct definition dependencies (def: ids), for support-closure computation. */
  deps: string[];
  /**
   * sha256 of the normalized body — the document-independent identity a
   * cross-corpus specimen store needs; stamped at emission because it is
   * impossible to backfill consistently later.
   */
  fingerprint: string;
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
