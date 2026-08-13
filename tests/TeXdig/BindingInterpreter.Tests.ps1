BeforeDiscovery {
    $script:BindingNodeAvailable = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
}

Describe 'TeXdig chronological binding interpreter' -Tag 'TeXdig', 'BindingInterpreter' `
        -Skip:(-not $script:BindingNodeAvailable) {
    BeforeAll {
        $script:RepositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '../..')).Path
        $script:NodePath = (Get-Command node -CommandType Application -ErrorAction Stop).Source
        $bindingPath = (Resolve-Path -LiteralPath (
                Join-Path $script:RepositoryRoot 'src/TeXdig/compile/binding-machine.ts')).Path
        $script:BindingModuleUri = ([Uri]$bindingPath).AbsoluteUri

        function Invoke-BindingNodeProbe {
            param([Parameter(Mandatory)] [string] $Script)

            $preamble = @'
import { BindingMachine } from '__BINDING_MACHINE__';

const span = (start = 0, end = start + 1) =>
  ({ sourceId: "main.tex", startUtf16: start, endUtf16: end });
const symbol = (name, namespace = "control-sequence") => ({ namespace, name });
const cause = (name, start = 0) => ({
  kind: "physical-declaration",
  entityId: `ent:macro-definition@main.tex:${start}-${start + 1}:${name}`,
  siteSpan: span(start, start + 1),
});
const declaration = (name, availability = "body", spec = "") => ({
  kind: "declaration",
  entityId: `ent:macro-definition@fixture:${name}`,
  availability,
  signature: { state: "known", spec },
});
const opaque = (name) => ({
  kind: "opaque",
  entityId: `ent:macro-definition@fixture:${name}`,
  reason: `body for ${name} is deliberately opaque`,
  signature: { state: "unknown", detail: "opaque fixture" },
});
const machine = (bundleKey = "fixture", start = -1) => {
  let seq = start;
  return new BindingMachine({ bundleKey, nextSeq: () => ++seq });
};
'@
            $program = ($preamble.Replace('__BINDING_MACHINE__', $script:BindingModuleUri)) +
                "`n" + $Script
            $output = @(& $script:NodePath --input-type=module --eval $program 2>&1)
            $status = $LASTEXITCODE
            $global:LASTEXITCODE = 0
            if ($status -ne 0) {
                throw "Node binding-machine probe failed ($status): $($output -join "`n")"
            }
            return ($output -join "`n") | ConvertFrom-Json -Depth 50
        }
    }

    It 'hashes stable scope and event ids independently of caller sequence values' {
        $probe = Invoke-BindingNodeProbe -Script @'
function run(start) {
  const m = machine("stable-bundle", start);
  m.enterDocument({ occurrenceId: "occ:root", siteKey: "document", openText: "\\begin{document}" });
  m.enterScope({ kind: "brace-group", occurrenceId: "occ:root", siteKey: "group@10", openText: "{" });
  m.enterScope({ kind: "environment", occurrenceId: "occ:root", siteKey: "environment@11", openText: "\\begin{x}" });
  m.enterScope({ kind: "begingroup", occurrenceId: "occ:root", siteKey: "begingroup@12", openText: "\\begingroup" });
  m.apply({
    eventKey: "definition@13",
    occurrenceId: "occ:root",
    symbol: symbol("x"),
    cause: cause("x", 13),
    operation: "assign",
    meaning: declaration("x"),
    text: "\\def\\x{x}",
  });
  m.exitScope({ occurrenceId: "occ:root", closeText: "\\endgroup" });
  m.exitScope({ occurrenceId: "occ:root", closeText: "\\end{x}" });
  m.exitScope({ occurrenceId: "occ:root", closeText: "}" });
  m.exitScope({ occurrenceId: "occ:root", closeText: "\\end{document}" });
  m.closeGlobal();
  const rows = m.rows();
  const scopes = rows.filter((row) => row.rowType === "scope-frame");
  const scopeIds = new Set(scopes.map((row) => row.id));
  return {
    ids: rows.map((row) => row.id),
    seqs: rows.map((row) => row.seq ?? row.enterSeq),
    scopeKinds: scopes.map((row) => row.kind),
    allScopesClosed: scopes.every((row) => row.status === "closed"),
    closedScopeRefs: rows
      .filter((row) => row.rowType === "binding-event")
      .every((row) => scopeIds.has(row.executionScopeId) && scopeIds.has(row.targetScopeId)),
  };
}
console.log(JSON.stringify({ low: run(-1), high: run(999) }));
'@

        ($probe.low.ids -join '|') | Should -BeExactly ($probe.high.ids -join '|')
        ($probe.low.seqs -join '|') | Should -Not -BeExactly ($probe.high.seqs -join '|')
        ($probe.low.scopeKinds -join '|') | Should -BeExactly (
            'global|document|brace-group|environment|begingroup')
        $probe.low.allScopesClosed | Should -BeTrue
        $probe.high.allScopesClosed | Should -BeTrue
        $probe.low.closedScopeRefs | Should -BeTrue
        $probe.high.closedScopeRefs | Should -BeTrue
    }

    It 'enforces new renew and provide against the current binding' {
        $probe = Invoke-BindingNodeProbe -Script @'
const m = machine();
m.enterDocument({ occurrenceId: "occ:root", siteKey: "document" });
const first = m.apply({ eventKey: "new-a", occurrenceId: "occ:root", symbol: symbol("a"), cause: cause("a", 1), operation: "new", meaning: declaration("a") });
const duplicate = m.apply({ eventKey: "new-a-again", occurrenceId: "occ:root", symbol: symbol("a"), cause: cause("a", 2), operation: "new", meaning: declaration("a2") });
const missingRenew = m.apply({ eventKey: "renew-missing", occurrenceId: "occ:root", symbol: symbol("missing"), cause: cause("missing", 3), operation: "renew", meaning: declaration("missing") });
const existingProvide = m.apply({ eventKey: "provide-a", occurrenceId: "occ:root", symbol: symbol("a"), cause: cause("a", 4), operation: "provide", meaning: declaration("provided-a") });
const freshProvide = m.apply({ eventKey: "provide-b", occurrenceId: "occ:root", symbol: symbol("b"), cause: cause("b", 5), operation: "provide", meaning: declaration("b") });
console.log(JSON.stringify({
  effects: [first.effect, duplicate.effect, missingRenew.effect, existingProvide.effect, freshProvide.effect],
  a: m.lookup(symbol("a")),
  b: m.lookup(symbol("b")),
  firstId: first.id,
}));
'@

        ($probe.effects -join '|') | Should -BeExactly (
            'installed|invalid-precondition|invalid-precondition|skipped-existing|installed')
        $probe.a.bindingEventId | Should -BeExactly $probe.firstId
        $probe.b.state | Should -BeExactly 'bound'
    }

    It 'saves only the first local assignment and restores symbols in reverse order' {
        $probe = Invoke-BindingNodeProbe -Script @'
const m = machine();
m.enterDocument({ occurrenceId: "occ:root", siteKey: "document" });
const baseA = m.apply({ eventKey: "base-a", symbol: symbol("a"), cause: cause("a", 1), operation: "assign", meaning: declaration("base-a") });
const baseB = m.apply({ eventKey: "base-b", symbol: symbol("b"), cause: cause("b", 2), operation: "assign", meaning: declaration("base-b") });
m.enterScope({ kind: "brace-group", occurrenceId: "occ:root", siteKey: "group@10" });
m.apply({ eventKey: "local-a-1", symbol: symbol("a"), cause: cause("a", 11), operation: "assign", meaning: declaration("local-a-1") });
m.apply({ eventKey: "local-b", symbol: symbol("b"), cause: cause("b", 12), operation: "assign", meaning: declaration("local-b") });
const localA2 = m.apply({ eventKey: "local-a-2", symbol: symbol("a"), cause: cause("a", 13), operation: "assign", meaning: declaration("local-a-2") });
const restores = m.exitScope({ occurrenceId: "occ:root" });
console.log(JSON.stringify({
  restoreNames: restores.map((row) => row.symbol.name),
  restoredIds: restores.map((row) => row.restoredBindingEventId),
  priorIds: restores.map((row) => row.priorBindingEventId),
  a: m.lookup(symbol("a")),
  b: m.lookup(symbol("b")),
  baseA: baseA.id,
  baseB: baseB.id,
  localA2: localA2.id,
}));
'@

        ($probe.restoreNames -join '|') | Should -BeExactly 'b|a'
        ($probe.restoredIds -join '|') | Should -BeExactly "$($probe.baseB)|$($probe.baseA)"
        $probe.priorIds[1] | Should -BeExactly $probe.localA2
        $probe.a.bindingEventId | Should -BeExactly $probe.baseA
        $probe.b.bindingEventId | Should -BeExactly $probe.baseB
    }

    It 'cancels pending restores on a global assignment and can save the new global value later' {
        $probe = Invoke-BindingNodeProbe -Script @'
const m = machine();
m.enterDocument({ occurrenceId: "occ:root", siteKey: "document" });
m.apply({ eventKey: "document-a", symbol: symbol("a"), cause: cause("a", 1), operation: "assign", meaning: declaration("document-a") });
m.enterScope({ kind: "brace-group", occurrenceId: "occ:root", siteKey: "group@10" });
m.apply({ eventKey: "local-a", symbol: symbol("a"), cause: cause("a", 11), operation: "assign", meaning: declaration("local-a") });
const globalA = m.apply({ eventKey: "global-a", symbol: symbol("a"), cause: cause("a", 12), operation: "global-assign", meaning: declaration("global-a") });
m.apply({ eventKey: "post-global-local-a", symbol: symbol("a"), cause: cause("a", 13), operation: "assign", meaning: declaration("post-global-local-a") });
const groupRestores = m.exitScope({ occurrenceId: "occ:root" });
const afterGroup = m.lookup(symbol("a"));
const documentRestores = m.exitScope({ occurrenceId: "occ:root" });
const afterDocument = m.lookup(symbol("a"));
console.log(JSON.stringify({
  globalId: globalA.id,
  groupRestoreCount: groupRestores.length,
  groupRestoredId: groupRestores[0]?.restoredBindingEventId,
  documentRestoreCount: documentRestores.length,
  afterGroup,
  afterDocument,
}));
'@

        $probe.groupRestoreCount | Should -Be 1
        $probe.groupRestoredId | Should -BeExactly $probe.globalId
        $probe.documentRestoreCount | Should -Be 0
        $probe.afterGroup.bindingEventId | Should -BeExactly $probe.globalId
        $probe.afterDocument.bindingEventId | Should -BeExactly $probe.globalId
    }

    It 'installs opaque meanings and honors caller-supplied local and global operation mapping' {
        $probe = Invoke-BindingNodeProbe -Script @'
const m = machine();
const globalScopeId = m.globalScopeId;
m.enterDocument({ occurrenceId: "occ:root", siteKey: "document" });
const documentScopeId = m.currentScopeId;
const original = m.apply({ eventKey: "new-x", symbol: symbol("x"), cause: cause("x", 1), operation: "new", meaning: declaration("x") });
const opaqueShadow = m.apply({ eventKey: "def-x", symbol: symbol("x"), cause: cause("x", 2), operation: "assign", meaning: opaque("x") });
const gdef = m.apply({ eventKey: "gdef-g", symbol: symbol("g"), cause: cause("g", 3), operation: "global-assign", meaning: opaque("g") });
const edef = m.apply({ eventKey: "edef-e", symbol: symbol("e"), cause: cause("e", 4), operation: "expanded-assign", meaning: opaque("e") });
const xdef = m.apply({ eventKey: "xdef-z", symbol: symbol("z"), cause: cause("z", 5), operation: "global-expanded-assign", meaning: opaque("z") });
console.log(JSON.stringify({
  originalId: original.id,
  shadowPrior: opaqueShadow.priorBindingEventId,
  currentX: m.lookup(symbol("x")),
  globalScopeId,
  documentScopeId,
  operations: [opaqueShadow.operation, gdef.operation, edef.operation, xdef.operation],
  targets: [opaqueShadow.targetScopeId, gdef.targetScopeId, edef.targetScopeId, xdef.targetScopeId],
}));
'@

        $probe.shadowPrior | Should -BeExactly $probe.originalId
        $probe.currentX.meaning.kind | Should -BeExactly 'opaque'
        ($probe.operations -join '|') | Should -BeExactly (
            'assign|global-assign|expanded-assign|global-expanded-assign')
        ($probe.targets -join '|') | Should -BeExactly (
            "$($probe.documentScopeId)|$($probe.globalScopeId)|" +
            "$($probe.documentScopeId)|$($probe.globalScopeId)")
    }

    It 'captures let meanings immutably by source event or direct token value' {
        $probe = Invoke-BindingNodeProbe -Script @'
const m = machine();
m.enterDocument({ occurrenceId: "occ:root", siteKey: "document" });
const source1 = m.apply({ eventKey: "source-1", symbol: symbol("source"), cause: cause("source", 1), operation: "assign", meaning: declaration("source-1", "body", "m") });
const alias = m.captureLet({ eventKey: "let-alias", symbol: symbol("alias"), cause: cause("alias", 2), source: { kind: "current-symbol", symbol: symbol("source") } });
m.apply({ eventKey: "source-2", symbol: symbol("source"), cause: cause("source", 3), operation: "assign", meaning: declaration("source-2", "body", "m m") });
const aliasByEvent = m.captureLet({ eventKey: "let-event", symbol: symbol("eventAlias"), cause: cause("eventAlias", 4), source: { kind: "binding-event", bindingEventId: source1.id } });
const token = { kind: "character-token", text: "x", catcode: "unknown", signature: { state: "known", spec: "" } };
m.captureLet({ eventKey: "let-token", symbol: symbol("tokenAlias"), cause: cause("tokenAlias", 5), source: { kind: "value", meaning: token } });
token.text = "mutated-after-capture";
console.log(JSON.stringify({
  source1: source1.id,
  aliasOperation: alias.operation,
  alias: m.lookup(symbol("alias")),
  eventAlias: m.lookup(symbol("eventAlias")),
  tokenAlias: m.lookup(symbol("tokenAlias")),
}));
'@

        $probe.aliasOperation | Should -BeExactly 'let-capture'
        $probe.alias.meaning.sourceBindingEventId | Should -BeExactly $probe.source1
        $probe.eventAlias.meaning.sourceBindingEventId | Should -BeExactly $probe.source1
        $probe.alias.meaning.signature.spec | Should -BeExactly 'm'
        $probe.tokenAlias.meaning.kind | Should -BeExactly 'character-token'
        $probe.tokenAlias.meaning.text | Should -BeExactly 'x'
    }

    It 'emits non-mutating dispositions and rejects a non-monotone caller sequence' {
        $probe = Invoke-BindingNodeProbe -Script @'
const m = machine();
m.enterDocument({ occurrenceId: "occ:root", siteKey: "document" });
const disposition = m.recordDisposition({
  eventKey: "nested-definition@10",
  occurrenceId: "occ:root",
  entityId: "ent:macro-definition@main.tex:10-20",
  reason: "definition-body",
  text: "\\newcommand{\\nested}{x}",
});
const before = m.lookup(symbol("nested"));
let monotoneError = "";
try {
  new BindingMachine({ bundleKey: "bad-seq", nextSeq: () => 0 }).enterDocument({ occurrenceId: "occ:bad", siteKey: "document" });
} catch (error) {
  monotoneError = String(error.message || error);
}
console.log(JSON.stringify({ disposition, before, monotoneError }));
'@

        $probe.disposition.rowType | Should -BeExactly 'declaration-disposition'
        $probe.disposition.id | Should -Match '^disposition:[0-9a-f]{64}$'
        $probe.disposition.text | Should -BeExactly '\newcommand{\nested}{x}'
        $probe.before.state | Should -BeExactly 'unbound'
        $probe.monotoneError | Should -Match 'strictly increasing'
    }
}
