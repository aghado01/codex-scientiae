/**
 * Chronological TeXdig binding state machine.
 *
 * Traversal owns execution order, physical-site interpretation, and the
 * monotone sequence allocator. This module owns scope lifetimes, operation
 * preconditions, current binding lookup, immutable capture, and restoration.
 * Stable caller keys address rows; sequence values never participate in ids.
 *
 * Erasable-syntax TypeScript only (Node native type stripping).
 */

import crypto from "node:crypto";
import type {
  BindingEvent,
  BindingMeaning,
  BindingRow,
  BindingSymbol,
  DeclarationDisposition,
  ScopeFrame,
  Seq,
} from "../core/contracts.ts";
import type { SourceSpan } from "../core/types.ts";

export interface BindingMachineOptions {
  /** Stable bundle identity; it namespaces deterministic row ids. */
  bundleKey: string;
  /** Caller-owned strict sequence allocator. */
  nextSeq: () => Seq;
}

export interface EnterDocumentInput {
  occurrenceId: string;
  /** Stable site identity within the occurrence, independent of seq. */
  siteKey: string;
  openSpan?: SourceSpan;
  openText?: string;
}

export interface EnterLocalScopeInput {
  kind: "brace-group" | "environment" | "begingroup";
  occurrenceId: string;
  /** Stable opening-site identity within the occurrence, independent of seq. */
  siteKey: string;
  openSpan?: SourceSpan;
  openText?: string;
}

export interface ExitScopeInput {
  occurrenceId?: string;
  closeSpan?: SourceSpan;
  closeText?: string;
  status?: "closed" | "unterminated" | "indeterminate";
}

type ExternalOperation = Exclude<BindingEvent["operation"], "let-capture" | "restore">;

export interface ApplyBindingInput {
  /** Stable execution-site identity within the occurrence, independent of seq. */
  eventKey: string;
  occurrenceId?: string;
  symbol: BindingSymbol;
  cause: BindingEvent["cause"];
  /** The caller maps declaration syntax to this operation. */
  operation: ExternalOperation;
  /** Candidate meaning; retained only when the operation changes current state. */
  meaning: BindingMeaning;
  /** Overrides the operation default for configured or other declared effects. */
  target?: "current" | "global";
  /** Exact declaration/summon slice for source-backed events. */
  text?: string;
}

export type LetCaptureSource =
  | { kind: "current-symbol"; symbol: BindingSymbol }
  | { kind: "binding-event"; bindingEventId: string }
  | { kind: "value"; meaning: BindingMeaning };

export interface CaptureLetInput {
  eventKey: string;
  occurrenceId?: string;
  symbol: BindingSymbol;
  cause: BindingEvent["cause"];
  source: LetCaptureSource;
  target?: "current" | "global";
  /** Exact let-assignment slice. */
  text?: string;
}

export interface RecordDispositionInput {
  eventKey: string;
  occurrenceId: string;
  entityId: string;
  reason: DeclarationDisposition["reason"];
  /** Exact declaration slice that was observed but did not execute. */
  text: string;
}

export type BindingLookup =
  | { state: "unbound" }
  | {
      state: "bound";
      bindingEventId: string;
      meaning: BindingMeaning;
    }
  | {
      state: "indeterminate";
      bindingEventId: string;
      meaning: Extract<BindingMeaning, { kind: "indeterminate" }>;
    };

interface StoredBinding {
  event: BindingEvent;
  meaning: BindingMeaning;
}

interface SavedBinding {
  symbol: BindingSymbol;
  prior?: StoredBinding;
}

interface ScopeState {
  row: ScopeFrame;
  /** Insertion order is first-assignment order and defines reverse restoration. */
  saves: Map<string, SavedBinding>;
}

function copy<T>(value: T): T {
  return structuredClone(value);
}

function requireText(value: string, label: string): void {
  if (typeof value !== "string" || value.length === 0) {
    throw new Error(`${label} must be a non-empty string`);
  }
}

function symbolKey(symbol: BindingSymbol): string {
  requireText(symbol.name, "binding symbol name");
  return `${symbol.namespace}\u0000${symbol.name}`;
}

function hashId(prefix: string, parts: readonly string[]): string {
  const hash = crypto.createHash("sha256");
  for (const part of parts) {
    hash.update(String(Buffer.byteLength(part, "utf8")));
    hash.update(":");
    hash.update(part, "utf8");
    hash.update(";");
  }
  return `${prefix}:${hash.digest("hex")}`;
}

/**
 * Stateful interpreter for already ordered binding actions.
 *
 * The class deliberately has no knowledge of source traversal, declaration
 * discovery, configured-package resolution, or artifact publication.
 */
export class BindingMachine {
  readonly globalScopeId: string;

  private readonly bundleKey: string;
  private readonly nextSeqCallback: () => Seq;
  private readonly output: BindingRow[] = [];
  private readonly scopes = new Map<string, ScopeState>();
  private readonly scopeStack: string[] = [];
  private readonly current = new Map<string, StoredBinding>();
  private readonly events = new Map<string, BindingEvent>();
  private readonly rowIds = new Set<string>();
  private lastSeq = -1;
  private documentOpened = false;
  private closed = false;

  constructor(options: BindingMachineOptions) {
    requireText(options.bundleKey, "bundleKey");
    if (typeof options.nextSeq !== "function") {
      throw new Error("nextSeq must be a function");
    }
    this.bundleKey = options.bundleKey;
    this.nextSeqCallback = options.nextSeq;
    this.globalScopeId = hashId("scope", [this.bundleKey, "global"]);

    const global: ScopeFrame = {
      rowType: "scope-frame",
      id: this.globalScopeId,
      kind: "global",
      enterSeq: this.takeSeq(),
      status: "open",
    };
    this.addScope(global);
    this.scopeStack.push(global.id);
  }

  get currentScopeId(): string {
    const id = this.scopeStack.at(-1);
    if (!id) throw new Error("binding machine has no open scope");
    return id;
  }

  get currentScopeKind(): ScopeFrame["kind"] {
    return this.scopes.get(this.currentScopeId)!.row.kind;
  }

  /** A detached copy of every row emitted so far. */
  rows(): BindingRow[] {
    return copy(this.output);
  }

  /** Current binding at the interpreter cursor. */
  lookup(symbol: BindingSymbol): BindingLookup {
    const stored = this.current.get(symbolKey(symbol));
    if (!stored) return { state: "unbound" };
    const meaning = copy(stored.meaning);
    if (meaning.kind === "indeterminate") {
      return {
        state: "indeterminate",
        bindingEventId: stored.event.id,
        meaning,
      };
    }
    return {
      state: "bound",
      bindingEventId: stored.event.id,
      meaning,
    };
  }

  /** Meaning installed by a resident binding event, independent of current scope. */
  meaningOf(bindingEventId: string): BindingMeaning | undefined {
    const event = this.events.get(bindingEventId);
    return event?.installedMeaning ? copy(event.installedMeaning) : undefined;
  }

  enterDocument(input: EnterDocumentInput): ScopeFrame {
    this.ensureOpen();
    if (this.documentOpened || this.currentScopeId !== this.globalScopeId) {
      throw new Error("document scope may be entered exactly once from the global scope");
    }
    requireText(input.occurrenceId, "document occurrenceId");
    const row = this.makeScope(
      "document",
      input.siteKey,
      input.occurrenceId,
      input.openSpan,
      input.openText
    );
    this.documentOpened = true;
    return copy(row);
  }

  enterScope(input: EnterLocalScopeInput): ScopeFrame {
    this.ensureOpen();
    if (!this.documentOpened || this.currentScopeId === this.globalScopeId) {
      throw new Error("local scope requires an open document scope");
    }
    requireText(input.occurrenceId, "scope occurrenceId");
    const row = this.makeScope(
      input.kind,
      input.siteKey,
      input.occurrenceId,
      input.openSpan,
      input.openText
    );
    return copy(row);
  }

  /**
   * Close the current document/local frame. Local values restore in reverse
   * first-assignment order before the scope's exit sequence is allocated.
   */
  exitScope(input: ExitScopeInput = {}): BindingEvent[] {
    this.ensureOpen();
    const scopeId = this.currentScopeId;
    if (scopeId === this.globalScopeId) {
      throw new Error("use closeGlobal() to close the global scope");
    }
    const scope = this.scopes.get(scopeId)!;
    const parentScopeId = scope.row.parentScopeId;
    if (!parentScopeId || !this.scopes.has(parentScopeId)) {
      throw new Error(`scope '${scopeId}' has no resident parent scope`);
    }

    const restores: BindingEvent[] = [];
    const saved = [...scope.saves.entries()].reverse();
    for (const [key, entry] of saved) {
      const before = this.current.get(key);
      const event: BindingEvent = {
        rowType: "binding-event",
        id: hashId("bind", [this.bundleKey, "restore", scopeId, key]),
        seq: this.takeSeq(),
        occurrenceId: input.occurrenceId ?? scope.row.occurrenceId,
        executionScopeId: scopeId,
        targetScopeId: parentScopeId,
        symbol: copy(entry.symbol),
        cause: { kind: "scope-exit", scopeId },
        operation: "restore",
        effect: "restored",
        priorBindingEventId: before?.event.id,
        restoredBindingEventId: entry.prior?.event.id,
        installedMeaning: entry.prior ? copy(entry.prior.meaning) : undefined,
      };
      this.addBindingEvent(event);
      restores.push(copy(event));
      if (entry.prior) this.current.set(key, entry.prior);
      else this.current.delete(key);
    }

    scope.row.closeSpan = input.closeSpan ? copy(input.closeSpan) : undefined;
    scope.row.closeText = input.closeText;
    scope.row.exitSeq = this.takeSeq();
    scope.row.status = input.status ?? "closed";
    this.scopeStack.pop();
    return restores;
  }

  /** Close the already-restored global frame and prevent further actions. */
  closeGlobal(): ScopeFrame {
    this.ensureOpen();
    if (this.currentScopeId !== this.globalScopeId) {
      throw new Error("all document/local scopes must close before the global scope");
    }
    const global = this.scopes.get(this.globalScopeId)!;
    global.row.exitSeq = this.takeSeq();
    global.row.status = "closed";
    this.scopeStack.pop();
    this.closed = true;
    return copy(global.row);
  }

  /** Apply a caller-classified declaration/configured/baseline operation. */
  apply(input: ApplyBindingInput): BindingEvent {
    return this.transition(input);
  }

  /** Install the exact meaning observed at the let assignment site. */
  captureLet(input: CaptureLetInput): BindingEvent {
    this.ensureOpen();
    let meaning: BindingMeaning;
    if (input.source.kind === "value") {
      meaning = copy(input.source.meaning);
    } else {
      const sourceEvent = input.source.kind === "current-symbol"
        ? this.current.get(symbolKey(input.source.symbol))?.event
        : this.events.get(input.source.bindingEventId);
      meaning = sourceEvent?.installedMeaning
        ? {
            kind: "captured",
            sourceBindingEventId: sourceEvent.id,
            signature: copy(sourceEvent.installedMeaning.signature),
          }
        : {
            kind: "opaque",
            reason: "let-target-unbound-at-capture",
            signature: { state: "unknown", detail: "let-target-unbound-at-capture" },
          };
    }

    return this.transition({
      eventKey: input.eventKey,
      occurrenceId: input.occurrenceId,
      symbol: input.symbol,
      cause: input.cause,
      operation: "assign",
      meaning,
      target: input.target,
      text: input.text,
    }, "let-capture");
  }

  /** Record a declaration sighting that did not execute. */
  recordDisposition(input: RecordDispositionInput): DeclarationDisposition {
    this.ensureOpen();
    requireText(input.eventKey, "disposition eventKey");
    requireText(input.occurrenceId, "disposition occurrenceId");
    requireText(input.entityId, "disposition entityId");
    requireText(input.text, "disposition text");
    const row: DeclarationDisposition = {
      rowType: "declaration-disposition",
      id: hashId("disposition", [
        this.bundleKey,
        "disposition",
        input.occurrenceId,
        input.eventKey,
      ]),
      seq: this.takeSeq(),
      occurrenceId: input.occurrenceId,
      entityId: input.entityId,
      reason: input.reason,
      text: input.text,
    };
    this.addRow(row);
    return copy(row);
  }

  private transition(
    input: ApplyBindingInput,
    operationOverride?: "let-capture"
  ): BindingEvent {
    this.ensureOpen();
    requireText(input.eventKey, "binding eventKey");
    const key = symbolKey(input.symbol);
    const prior = this.current.get(key);
    const targetMode = input.target ?? this.defaultTarget(input.operation);
    const targetScopeId = targetMode === "global" ? this.globalScopeId : this.currentScopeId;

    let effect: BindingEvent["effect"];
    if (input.operation === "new" && prior) effect = "invalid-precondition";
    else if (input.operation === "renew" && !prior) effect = "invalid-precondition";
    else if (input.operation === "provide" && prior) effect = "skipped-existing";
    else effect = input.meaning.kind === "indeterminate" ? "indeterminate" : "installed";

    const changesState = effect === "installed" || effect === "indeterminate";
    const event: BindingEvent = {
      rowType: "binding-event",
      id: hashId("bind", [
        this.bundleKey,
        "event",
        input.occurrenceId ?? "",
        input.eventKey,
      ]),
      seq: this.takeSeq(),
      occurrenceId: input.occurrenceId,
      executionScopeId: this.currentScopeId,
      targetScopeId,
      symbol: copy(input.symbol),
      cause: copy(input.cause),
      operation: operationOverride ?? input.operation,
      effect,
      priorBindingEventId: prior?.event.id,
      installedMeaning: changesState ? copy(input.meaning) : undefined,
      text: input.text,
    };
    this.addBindingEvent(event);

    if (changesState) {
      if (targetMode === "global") {
        this.cancelPendingRestores(key);
      } else {
        this.saveFirstAssignment(key, input.symbol, prior);
      }
      this.current.set(key, { event, meaning: copy(input.meaning) });
    }
    return copy(event);
  }

  private makeScope(
    kind: ScopeFrame["kind"],
    siteKey: string,
    occurrenceId: string,
    openSpan?: SourceSpan,
    openText?: string
  ): ScopeFrame {
    requireText(siteKey, "scope siteKey");
    const parentScopeId = this.currentScopeId;
    const row: ScopeFrame = {
      rowType: "scope-frame",
      id: hashId("scope", [
        this.bundleKey,
        kind,
        parentScopeId,
        occurrenceId,
        siteKey,
      ]),
      kind,
      parentScopeId,
      occurrenceId,
      enterSeq: this.takeSeq(),
      status: "open",
      openSpan: openSpan ? copy(openSpan) : undefined,
      openText,
    };
    this.addScope(row);
    this.scopeStack.push(row.id);
    return row;
  }

  private defaultTarget(operation: ExternalOperation): "current" | "global" {
    return operation === "global-assign" ||
        operation === "global-expanded-assign" ||
        operation === "baseline-install"
      ? "global"
      : "current";
  }

  private saveFirstAssignment(
    key: string,
    symbol: BindingSymbol,
    prior: StoredBinding | undefined
  ): void {
    const scope = this.scopes.get(this.currentScopeId)!;
    if (scope.row.kind === "global" || scope.saves.has(key)) return;
    scope.saves.set(key, { symbol: copy(symbol), prior });
  }

  private cancelPendingRestores(key: string): void {
    for (const scopeId of this.scopeStack) {
      this.scopes.get(scopeId)?.saves.delete(key);
    }
  }

  private takeSeq(): Seq {
    const seq = this.nextSeqCallback();
    if (!Number.isSafeInteger(seq) || seq < 0 || seq <= this.lastSeq) {
      throw new Error(`nextSeq must return strictly increasing non-negative safe integers (got ${seq})`);
    }
    this.lastSeq = seq;
    return seq;
  }

  private addScope(row: ScopeFrame): void {
    if (this.scopes.has(row.id)) throw new Error(`duplicate scope id '${row.id}'`);
    this.addRow(row);
    this.scopes.set(row.id, { row, saves: new Map() });
  }

  private addBindingEvent(event: BindingEvent): void {
    this.addRow(event);
    this.events.set(event.id, event);
  }

  private addRow(row: BindingRow): void {
    if (this.rowIds.has(row.id)) throw new Error(`duplicate binding row id '${row.id}'`);
    this.rowIds.add(row.id);
    this.output.push(row);
  }

  private ensureOpen(): void {
    if (this.closed) throw new Error("binding machine is closed");
  }
}
