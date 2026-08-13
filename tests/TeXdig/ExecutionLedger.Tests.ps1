BeforeDiscovery {
    $script:ExecutionLedgerNodeAvailable = $null -ne (
        Get-Command node -CommandType Application -ErrorAction SilentlyContinue)
}

Describe 'TeXdig chronological execution ledger' -Tag 'TeXdig', 'ExecutionLedger' `
        -Skip:(-not $script:ExecutionLedgerNodeAvailable) {
    BeforeAll {
        $script:RepositoryRoot = (Resolve-Path -LiteralPath (
                Join-Path $PSScriptRoot '../..')).Path
        $script:NodePath = (Get-Command node -CommandType Application -ErrorAction Stop).Source
        $executionPath = (Resolve-Path -LiteralPath (
                Join-Path $script:RepositoryRoot 'src/TeXdig/compile/execution.ts')).Path
        $script:ExecutionModuleUri = ([Uri] $executionPath).AbsoluteUri

        function Invoke-ExecutionLedgerProbe {
            param([Parameter(Mandatory)] [string] $Script)

            $preamble = @'
import { compileExecution } from '__EXECUTION_MODULE__';

const span = (sourceId, startUtf16, endUtf16) =>
  ({ sourceId, startUtf16, endUtf16 });

function lineStart(raw, line) {
  const start = raw.indexOf(line);
  if (start < 0) throw new Error(`fixture line not found: ${line}`);
  return start;
}

function macroInvocation(raw, line, name, sourceId = "main.tex") {
  const lineOffset = lineStart(raw, line);
  const token = `\\${name}`;
  const tokenOffset = line.indexOf(token);
  if (tokenOffset < 0) throw new Error(`fixture token not found: ${token}`);
  const start = lineOffset + tokenOffset;
  const site = span(sourceId, start, start + token.length);
  return {
    id: `ent:macro-invocation@${sourceId}:${site.startUtf16}-${site.endUtf16}`,
    kind: "macro-invocation",
    name,
    span: site,
    spanProvenance: "lexical",
    witnesses: [{ witness: "lexical", span: site, spanRole: "token" }],
    agreement: "lexical-only",
    agreementBasis: "single-authority",
    text: token,
  };
}

function macroDefinition(raw, line, name, declarationCommand, dialect, spec, bodyNeedle) {
  const start = lineStart(raw, line);
  const site = span("main.tex", start, start + line.length);
  const bodyOffset = line.indexOf(bodyNeedle);
  if (bodyOffset < 0) throw new Error(`fixture body not found: ${bodyNeedle}`);
  const bodySpan = span(
    "main.tex",
    start + bodyOffset,
    start + bodyOffset + bodyNeedle.length
  );
  return {
    id: `ent:macro-definition@main.tex:${site.startUtf16}-${site.endUtf16}`,
    kind: "macro-definition",
    definedName: name,
    declarationCommand,
    dialect,
    signature: spec === undefined
      ? { state: "unknown", detail: "fixture meaning supplied by let capture" }
      : { state: "known", spec },
    bodySpan,
    elaborable: dialect !== "let",
    context: "document-flow",
    activation: "immediate",
    span: site,
    spanProvenance: "parser",
    witnesses: [{ witness: "parser", span: site, spanRole: "construct" }],
    agreement: "parser-only",
    agreementBasis: "single-authority",
    text: line,
  };
}

function chronologyFixture() {
  const lines = [
    "\\foo{U}",
    "\\newcommand{\\foo}[1]{old:#1}",
    "\\foo{A}",
    "\\renewcommand{\\foo}[2][d]{new:#1:#2}",
    "\\foo{B}",
    "\\foo[]{C}",
    "\\let\\alias=\\foo",
    "\\renewcommand{\\foo}[1]{latest:#1}",
    "\\alias{D}",
    "\\foo{E}",
    "\\cfg{before}",
    "\\usepackage{pkg}",
    "\\cfg{after}",
  ];
  const raw = `${lines.join("\n")}\n`;
  const entities = [
    macroInvocation(raw, lines[0], "foo"),
    macroDefinition(raw, lines[1], "foo", "newcommand", "newcommand", "m", "old:#1"),
    macroInvocation(raw, lines[2], "foo"),
    macroDefinition(raw, lines[3], "foo", "renewcommand", "renewcommand", "O{d} m", "new:#1:#2"),
    macroInvocation(raw, lines[4], "foo"),
    macroInvocation(raw, lines[5], "foo"),
    macroDefinition(raw, lines[6], "alias", "let", "let", undefined, "=\\foo"),
    macroDefinition(raw, lines[7], "foo", "renewcommand", "renewcommand", "m", "latest:#1"),
    macroInvocation(raw, lines[8], "alias"),
    macroInvocation(raw, lines[9], "foo"),
    macroInvocation(raw, lines[10], "cfg"),
    macroInvocation(raw, lines[11], "usepackage"),
    macroInvocation(raw, lines[12], "cfg"),
  ];

  const summonStart = lineStart(raw, lines[11]);
  const summonSite = span("main.tex", summonStart, summonStart + lines[11].length);
  const targetStart = summonStart + lines[11].indexOf("pkg");
  const configuredId = "ent:macro-definition@configured/pkg:cfg";
  entities.push({
    id: configuredId,
    kind: "macro-definition",
    definedName: "cfg",
    declarationCommand: "configured",
    dialect: "configured",
    signature: { state: "known", spec: "m" },
    configuredPackage: "pkg",
    elaborable: false,
    context: "unknown",
    activation: "configured",
    span: summonSite,
    spanProvenance: "parser",
    witnesses: [{
      witness: "configured",
      instrument: "unified-latex-ctan",
      span: summonSite,
      spanRole: "summon-anchor",
      detail: "pkg",
    }],
    agreement: "agreed",
    agreementBasis: "configured-declaration",
    text: lines[11],
  });

  return {
    slug: "execution-chronology",
    treeSha256: "a".repeat(64),
    entrypoint: "main.tex",
    entities,
    claims: [],
    includeEdges: [],
    configured: {
      summons: [{
        command: "usepackage",
        packageName: "pkg",
        targetOrdinal: 0,
        siteSpan: summonSite,
        targetSpan: span("main.tex", targetStart, targetStart + 3),
      }],
      declarations: [],
      unresolvedPackages: [],
    },
    rawContents: new Map([["main.tex", raw]]),
    deps: {
      ctan: {
        macroInfo: { latex2e: { usepackage: { signature: "o m" } } },
        environmentInfo: { latex2e: {} },
      },
    },
  };
}

function includeEntity(sourceId, raw, start) {
  const text = "\\input{leaf}";
  const site = span(sourceId, start, start + text.length);
  return {
    id: `ent:include@${sourceId}:${site.startUtf16}-${site.endUtf16}`,
    kind: "include",
    directive: "input",
    targetRaw: "leaf",
    resolvedSourceId: "leaf.tex",
    span: site,
    spanProvenance: "lexical",
    witnesses: [{ witness: "lexical", span: site, spanRole: "construct" }],
    agreement: "lexical-only",
    agreementBasis: "single-authority",
    text: raw.slice(site.startUtf16, site.endUtf16),
  };
}

function includeEdge(entity) {
  return {
    fromSourceId: entity.span.sourceId,
    toSourceId: "leaf.tex",
    command: "input",
    directive: "input",
    targetRaw: "leaf",
    span: entity.span,
    targetSpan: span(
      entity.span.sourceId,
      entity.span.startUtf16 + "\\input{".length,
      entity.span.endUtf16 - 1
    ),
  };
}

function routeFixture() {
  const mainRaw = "\\input{leaf}\\input{leaf}";
  const leafRaw = "\\input{leaf}";
  const mainFirst = includeEntity("main.tex", mainRaw, 0);
  const mainSecond = includeEntity("main.tex", mainRaw, "\\input{leaf}".length);
  const leafSelf = includeEntity("leaf.tex", leafRaw, 0);
  const entities = [mainFirst, mainSecond, leafSelf];
  return {
    slug: "execution-routes",
    treeSha256: "b".repeat(64),
    entrypoint: "main.tex",
    entities,
    claims: [],
    includeEdges: entities.map(includeEdge),
    configured: { summons: [], declarations: [], unresolvedPackages: [] },
    rawContents: new Map([["main.tex", mainRaw], ["leaf.tex", leafRaw]]),
    deps: {
      ctan: {
        macroInfo: { latex2e: { input: { signature: "m" } } },
        environmentInfo: { latex2e: {} },
      },
    },
  };
}

function deferredRouteFixture() {
  const lines = [
    "\\input{leaf}",
    "\\def\\input#1{shadow:#1}",
    "\\input{leaf}",
    "\\iftrue\\input{leaf}\\fi",
    "\\newcommand{\\hold}[1]{#1}",
    "\\hold{\\input{leaf}}",
  ];
  const mainRaw = `${lines.join("\n")}\n`;
  const leafRaw = "leaf\n";
  const includeStarts = [];
  let cursor = 0;
  while ((cursor = mainRaw.indexOf("\\input{leaf}", cursor)) >= 0) {
    includeStarts.push(cursor);
    cursor += "\\input{leaf}".length;
  }
  const includes = includeStarts.map((start) => includeEntity("main.tex", mainRaw, start));
  const inputDefinition = macroDefinition(
    mainRaw, lines[1], "input", "def", "def", "m", "shadow:#1"
  );
  const holdDefinition = macroDefinition(
    mainRaw, lines[4], "hold", "newcommand", "newcommand", "m", "#1"
  );
  const holdInvocation = macroInvocation(mainRaw, lines[5], "hold");
  const conditionalStart = lineStart(mainRaw, lines[3]);
  return {
    slug: "execution-deferred-routes",
    treeSha256: "c".repeat(64),
    entrypoint: "main.tex",
    entities: [
      includes[0],
      inputDefinition,
      includes[1],
      includes[2],
      holdDefinition,
      holdInvocation,
      includes[3],
    ],
    claims: [],
    includeEdges: includes.map(includeEdge),
    configured: { summons: [], declarations: [], unresolvedPackages: [] },
    rawContents: new Map([["main.tex", mainRaw], ["leaf.tex", leafRaw]]),
    deferredContexts: [{
      span: span("main.tex", conditionalStart, conditionalStart + lines[3].length),
      reason: "conditional",
    }],
    deps: {
      ctan: {
        macroInfo: { latex2e: { input: { signature: "m" } } },
        environmentInfo: { latex2e: {} },
      },
    },
  };
}
'@
            $program = ($preamble.Replace('__EXECUTION_MODULE__',
                    $script:ExecutionModuleUri)) + "`n" + $Script
            $output = @(& $script:NodePath --no-warnings --experimental-strip-types `
                    --input-type=module --eval $program 2>&1)
            $status = $LASTEXITCODE
            $global:LASTEXITCODE = 0
            if ($status -ne 0) {
                throw "Node execution-ledger probe failed ($status): $($output -join "`n")"
            }
            return ($output -join "`n") | ConvertFrom-Json -Depth 100
        }
    }

    It 'resolves redefinitions chronologically and preserves immutable let capture' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
const result = compileExecution(chronologyFixture());
const events = result.bindings.filter((row) => row.rowType === "binding-event");
const fooEvents = events.filter((row) =>
  row.symbol.name === "foo" && row.cause.kind === "physical-declaration");
const aliasEvent = events.find((row) => row.symbol.name === "alias");
const foo = result.invocations.filter((row) => row.name === "foo");
const alias = result.invocations.find((row) => row.name === "alias");
console.log(JSON.stringify({
  fooEffects: fooEvents.map((row) => `${row.operation}:${row.effect}`),
  firstStatus: foo[0].status,
  firstBound: foo[1].binding.bindingEventId,
  firstEvent: fooEvents[0].id,
  defaultCall: foo[2],
  emptyCall: foo[3],
  latestCall: foo[4],
  defaultEvent: fooEvents[1],
  latestEvent: fooEvents[2],
  aliasEvent,
  alias,
  diagnosticCodes: result.diagnostics.map((row) => row.code),
}));
'@

        ($probe.fooEffects -join '|') | Should -BeExactly (
            'new:installed|renew:installed|renew:installed')
        $probe.firstStatus | Should -BeExactly 'unbound'
        $probe.firstBound | Should -BeExactly $probe.firstEvent
        $probe.defaultCall.binding.bindingEventId | Should -BeExactly $probe.defaultEvent.id
        ($probe.defaultCall.arguments.source -join '|') | Should -BeExactly 'default|explicit'
        $probe.defaultCall.arguments[0].defaultText | Should -BeExactly 'd'
        $probe.defaultCall.text | Should -BeExactly '\foo{B}'
        $probe.emptyCall.binding.bindingEventId | Should -BeExactly $probe.defaultEvent.id
        ($probe.emptyCall.arguments.source -join '|') | Should -BeExactly 'explicit|explicit'
        $probe.emptyCall.arguments[0].contentSpan.startUtf16 |
            Should -Be $probe.emptyCall.arguments[0].contentSpan.endUtf16
        $probe.emptyCall.text | Should -BeExactly '\foo[]{C}'
        $probe.latestCall.binding.bindingEventId | Should -BeExactly $probe.latestEvent.id
        $probe.aliasEvent.operation | Should -BeExactly 'let-capture'
        $probe.aliasEvent.installedMeaning.kind | Should -BeExactly 'captured'
        $probe.aliasEvent.installedMeaning.sourceBindingEventId |
            Should -BeExactly $probe.defaultEvent.id
        $probe.alias.binding.bindingEventId | Should -BeExactly $probe.aliasEvent.id
        $probe.alias.binding.signature.spec | Should -BeExactly 'O{d} m'
        ($probe.alias.arguments.source -join '|') | Should -BeExactly 'default|explicit'
        $probe.defaultEvent.seq | Should -BeLessThan $probe.aliasEvent.seq
        $probe.aliasEvent.seq | Should -BeLessThan $probe.latestEvent.seq
        @($probe.diagnosticCodes).Count | Should -Be 0
    }

    It 'installs configured meanings only after the physical summon event' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
const result = compileExecution(chronologyFixture());
const cfg = result.invocations.filter((row) => row.name === "cfg");
const usepackage = result.invocations.find((row) => row.name === "usepackage");
const summon = result.bindings.find((row) => row.rowType === "configured-summon");
const install = result.bindings.find((row) =>
  row.rowType === "binding-event" && row.operation === "configured-install");
const scopes = new Map(result.bindings
  .filter((row) => row.rowType === "scope-frame")
  .map((row) => [row.id, row]));
console.log(JSON.stringify({ cfg, usepackage, summon, install,
  targetScopeKind: scopes.get(install.targetScopeId)?.kind }));
'@

        @($probe.cfg).Count | Should -Be 2
        $probe.cfg[0].status | Should -BeExactly 'unbound'
        $probe.cfg[1].status | Should -BeExactly 'attached'
        $probe.cfg[1].binding.bindingEventId | Should -BeExactly $probe.install.id
        $probe.usepackage.status | Should -BeExactly 'attached'
        $probe.usepackage.seq | Should -BeLessThan $probe.summon.seq
        $probe.cfg[0].seq | Should -BeLessThan $probe.summon.seq
        $probe.summon.seq | Should -BeLessThan $probe.install.seq
        $probe.install.seq | Should -BeLessThan $probe.cfg[1].seq
        $probe.summon.outcome | Should -BeExactly 'loaded'
        $probe.install.cause.summonId | Should -BeExactly $probe.summon.id
        $probe.summon.candidateEntityIds | Should -Contain $probe.install.cause.entityId
        $probe.targetScopeKind | Should -BeExactly 'global'
    }

    It 'replays repeated includes, cuts active-route cycles, and closes deterministic joins' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
function project(result) {
  const occurrenceIds = new Set(result.occurrences.map((row) => row.id));
  const entityIds = new Set(routeFixture().entities.map((row) => row.id));
  const scopes = result.bindings.filter((row) => row.rowType === "scope-frame");
  const scopeIds = new Set(scopes.map((row) => row.id));
  const bindingIds = new Set(result.bindings
    .filter((row) => row.rowType === "binding-event")
    .map((row) => row.id));
  const seqs = [];
  for (const row of result.occurrences) seqs.push(row.enterSeq, row.exitSeq);
  for (const row of result.bindings) {
    if (row.rowType === "scope-frame") seqs.push(row.enterSeq, row.exitSeq);
    else seqs.push(row.seq);
  }
  for (const row of result.invocations) seqs.push(row.seq);
  seqs.sort((a, b) => a - b);
  const dense = seqs.every((value, index) => value === index);
  const occurrenceJoins = result.occurrences.every((row) =>
    (!row.parentOccurrenceId || occurrenceIds.has(row.parentOccurrenceId)) &&
    (!row.cycleTargetOccurrenceId || occurrenceIds.has(row.cycleTargetOccurrenceId)) &&
    (!row.includeEntityId || entityIds.has(row.includeEntityId)));
  const bindingJoins = result.bindings.every((row) => {
    if (row.rowType === "scope-frame") {
      return (!row.parentScopeId || scopeIds.has(row.parentScopeId)) &&
        (!row.occurrenceId || occurrenceIds.has(row.occurrenceId));
    }
    if (row.rowType === "binding-event") {
      return scopeIds.has(row.executionScopeId) && scopeIds.has(row.targetScopeId) &&
        (!row.occurrenceId || occurrenceIds.has(row.occurrenceId));
    }
    return occurrenceIds.has(row.occurrenceId);
  });
  const invocationJoins = result.invocations.every((row) =>
    occurrenceIds.has(row.occurrenceId) && entityIds.has(row.entityId) &&
    (row.binding.state !== "bound" || bindingIds.has(row.binding.bindingEventId)));
  const leafEntered = result.occurrences.filter((row) =>
    row.sourceId === "leaf.tex" && row.state === "entered");
  const repeatedPhysical = result.invocations.filter((row) =>
    row.entityId === "ent:include@leaf.tex:0-12");
  return {
    states: result.occurrences.map((row) => row.state),
    leafEnteredIds: leafEntered.map((row) => row.id),
    cycleTargets: result.occurrences
      .filter((row) => row.state === "cycle-cut")
      .map((row) => row.cycleTargetOccurrenceId),
    repeatedInvocationIds: repeatedPhysical.map((row) => row.id),
    repeatedOccurrenceIds: repeatedPhysical.map((row) => row.occurrenceId),
    allScopesClosed: scopes.every((row) => row.status === "closed"),
    dense,
    uniqueSeqs: new Set(seqs).size === seqs.length,
    occurrenceJoins,
    bindingJoins,
    invocationJoins,
  };
}
const first = compileExecution(routeFixture());
const second = compileExecution(routeFixture());
console.log(JSON.stringify({
  first: project(first),
  deterministic: JSON.stringify(first) === JSON.stringify(second),
}));
'@

        ($probe.first.states -join '|') | Should -BeExactly (
            'entered|entered|cycle-cut|entered|cycle-cut')
        @($probe.first.leafEnteredIds).Count | Should -Be 2
        $probe.first.leafEnteredIds[0] | Should -Not -BeExactly $probe.first.leafEnteredIds[1]
        ($probe.first.cycleTargets -join '|') | Should -BeExactly (
            $probe.first.leafEnteredIds -join '|')
        @($probe.first.repeatedInvocationIds).Count | Should -Be 2
        $probe.first.repeatedInvocationIds[0] |
            Should -Not -BeExactly $probe.first.repeatedInvocationIds[1]
        $probe.first.repeatedOccurrenceIds[0] |
            Should -Not -BeExactly $probe.first.repeatedOccurrenceIds[1]
        $probe.first.allScopesClosed | Should -BeTrue
        $probe.first.dense | Should -BeTrue
        $probe.first.uniqueSeqs | Should -BeTrue
        $probe.first.occurrenceJoins | Should -BeTrue
        $probe.first.bindingJoins | Should -BeTrue
        $probe.first.invocationJoins | Should -BeTrue
        $probe.deterministic | Should -BeTrue
    }

    It 'defers conditional and argument-body tokens and does not traverse a shadowed input primitive' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
const fixture = deferredRouteFixture();
const result = compileExecution(fixture);
const inputInvocations = result.invocations.filter((row) => row.name === "input");
const children = result.occurrences.filter((row) => row.parentOccurrenceId);
console.log(JSON.stringify({
  invocationStatuses: inputInvocations.map((row) => row.status),
  invocationBindingStates: inputInvocations.map((row) => row.binding.state),
  childStates: children.map((row) => row.state),
  childReasons: children.map((row) => row.deferredReason ?? null),
  diagnostics: result.diagnostics.map((row) => row.code),
}));
'@

        ($probe.invocationStatuses -join '|') |
            Should -BeExactly 'attached|attached|deferred|deferred'
        ($probe.invocationBindingStates -join '|') |
            Should -BeExactly 'bound|bound|deferred|deferred'
        ($probe.childStates -join '|') |
            Should -BeExactly 'entered|deferred-context|deferred-context|deferred-context'
        ($probe.childReasons -join '|') |
            Should -BeExactly '|unknown-context|conditional|argument-body'
        @($probe.diagnostics | Where-Object { $_ -eq 'compile/occurrence-deferred' }).Count |
            Should -Be 3
        @($probe.diagnostics | Where-Object { $_ -eq 'compile/invocation-deferred' }).Count |
            Should -Be 2
    }

    It 'attaches complete literal input and subfile filenames and enters their resolved occurrences' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
function literalInclude(raw, start, command, target, directive, toSourceId, braced) {
  const token = `\\${command}`;
  const text = braced ? `${token}{${target}}` : `${token} ${target}`;
  const site = span("main.tex", start, start + text.length);
  const tokenSite = span("main.tex", start, start + token.length);
  const targetStart = start + text.indexOf(target);
  const entity = {
    id: `ent:include@main.tex:${site.startUtf16}-${site.endUtf16}`,
    kind: "include",
    directive,
    targetRaw: target,
    resolvedSourceId: toSourceId,
    span: site,
    spanProvenance: "lexical",
    witnesses: [{ witness: "lexical", span: tokenSite, spanRole: "token", detail: command }],
    agreement: "lexical-only",
    agreementBasis: "single-authority",
    text,
  };
  return {
    entity,
    edge: {
      fromSourceId: "main.tex",
      toSourceId,
      command,
      directive,
      targetRaw: target,
      span: site,
      targetSpan: span("main.tex", targetStart, targetStart + target.length),
    },
  };
}

const firstText = String.raw`\input chapter.long-name.tex`;
const secondText = String.raw`\subfile{sub/chapter}`;
const raw = `${firstText}\n${secondText}\n`;
const first = literalInclude(raw, 0, "input", "chapter.long-name.tex", "input", "chapter.tex", false);
const second = literalInclude(
  raw,
  firstText.length + 1,
  "subfile",
  "sub/chapter",
  "include",
  "sub/chapter.tex",
  true
);
const result = compileExecution({
  slug: "literal-includes",
  treeSha256: "d".repeat(64),
  entrypoint: "main.tex",
  entities: [first.entity, second.entity],
  claims: [],
  includeEdges: [first.edge, second.edge],
  configured: { summons: [], declarations: [], unresolvedPackages: [] },
  rawContents: new Map([
    ["main.tex", raw],
    ["chapter.tex", ""],
    ["sub/chapter.tex", ""],
  ]),
  deps: { ctan: { macroInfo: { latex2e: {} }, environmentInfo: { latex2e: {} } } },
});
console.log(JSON.stringify({
  invocations: result.invocations.map((row) => ({
    name: row.name,
    status: row.status,
    text: row.text,
    argument: row.arguments[0],
    argumentText: row.arguments[0]?.span
      ? raw.slice(row.arguments[0].span.startUtf16, row.arguments[0].span.endUtf16)
      : null,
    contentText: row.arguments[0]?.contentSpan
      ? raw.slice(row.arguments[0].contentSpan.startUtf16, row.arguments[0].contentSpan.endUtf16)
      : null,
  })),
  enteredSources: result.occurrences
    .filter((row) => row.state === "entered")
    .map((row) => row.sourceId),
}));
'@

        @($probe.invocations).Count | Should -Be 2
        $probe.invocations[0].name | Should -BeExactly 'input'
        $probe.invocations[0].status | Should -BeExactly 'attached'
        $probe.invocations[0].text | Should -BeExactly '\input chapter.long-name.tex'
        $probe.invocations[0].argument.kind | Should -BeExactly 'until'
        $probe.invocations[0].argument.delimiter | Should -BeExactly 'none'
        $probe.invocations[0].argumentText | Should -BeExactly 'chapter.long-name.tex'
        $probe.invocations[0].contentText | Should -BeExactly 'chapter.long-name.tex'
        $probe.invocations[1].name | Should -BeExactly 'subfile'
        $probe.invocations[1].status | Should -BeExactly 'attached'
        $probe.invocations[1].text | Should -BeExactly '\subfile{sub/chapter}'
        $probe.invocations[1].argument.kind | Should -BeExactly 'mandatory'
        $probe.invocations[1].argument.delimiter | Should -BeExactly 'brace'
        $probe.invocations[1].argumentText | Should -BeExactly '{sub/chapter}'
        $probe.invocations[1].contentText | Should -BeExactly 'sub/chapter'
        ($probe.enteredSources -join '|') |
            Should -BeExactly 'main.tex|chapter.tex|sub/chapter.tex'
    }

    It 'anchors spaced environment arguments and scope closure to canonical fence evidence' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
const definitionText = String.raw`\newenvironment{foo}[1]{}{}`;
const useText = String.raw`\begin {foo}{x}body\end {foo}`;
const raw = `${definitionText}\n${useText}\n`;
const definitionSpan = span("main.tex", 0, definitionText.length);
const useStart = definitionText.length + 1;
const environmentSpan = span("main.tex", useStart, useStart + useText.length);
const beginText = String.raw`\begin {foo}`;
const endText = String.raw`\end {foo}`;
const beginSpan = span("main.tex", useStart, useStart + beginText.length);
const endStart = useStart + useText.indexOf(endText);
const endSpan = span("main.tex", endStart, endStart + endText.length);
const entities = [{
  id: `ent:environment-definition@main.tex:0-${definitionText.length}`,
  kind: "environment-definition",
  definedName: "foo",
  declarationCommand: "newenvironment",
  mechanism: "newenvironment",
  signature: { state: "known", spec: "m" },
  context: "document-flow",
  activation: "immediate",
  span: definitionSpan,
  spanProvenance: "parser",
  witnesses: [{ witness: "parser", span: definitionSpan, spanRole: "construct" }],
  agreement: "parser-only",
  agreementBasis: "single-authority",
  text: definitionText,
}, {
  id: `ent:environment@main.tex:${environmentSpan.startUtf16}-${environmentSpan.endUtf16}`,
  kind: "environment",
  name: "foo",
  role: "generic",
  bodySpan: span("main.tex", beginSpan.endUtf16, endSpan.startUtf16),
  span: environmentSpan,
  spanProvenance: "parser",
  witnesses: [
    { witness: "parser", span: environmentSpan, spanRole: "construct" },
    { witness: "lexical", span: beginSpan, spanRole: "begin-fence", detail: "begin:foo" },
    { witness: "lexical", span: endSpan, spanRole: "end-fence", detail: "end:foo" },
  ],
  agreement: "agreed",
  agreementBasis: "two-instrument",
  text: useText,
}];
const result = compileExecution({
  slug: "spaced-environment",
  treeSha256: "e".repeat(64),
  entrypoint: "main.tex",
  entities,
  claims: [],
  includeEdges: [],
  configured: { summons: [], declarations: [], unresolvedPackages: [] },
  rawContents: new Map([["main.tex", raw]]),
  deps: { ctan: { macroInfo: { latex2e: {} }, environmentInfo: { latex2e: {} } } },
});
const invocation = result.invocations.find((row) => row.name === "foo");
const frame = result.bindings.find((row) =>
  row.rowType === "scope-frame" && row.kind === "environment");
console.log(JSON.stringify({
  invocation,
  argumentText: invocation?.arguments[0]?.span
    ? raw.slice(invocation.arguments[0].span.startUtf16, invocation.arguments[0].span.endUtf16)
    : null,
  siteText: invocation ? raw.slice(invocation.siteSpan.startUtf16, invocation.siteSpan.endUtf16) : null,
  frame,
  diagnostics: result.diagnostics.map((row) => row.message),
}));
'@

        $probe.invocation.status | Should -BeExactly 'attached'
        $probe.invocation.text | Should -BeExactly '\begin {foo}{x}'
        $probe.siteText | Should -BeExactly '\begin {foo}'
        $probe.argumentText | Should -BeExactly '{x}'
        $probe.frame.status | Should -BeExactly 'closed'
        $probe.frame.openText | Should -BeExactly '\begin {foo}'
        $probe.frame.closeText | Should -BeExactly '\end {foo}'
        @($probe.diagnostics | Where-Object { $_ -match 'no closed scope fence' }).Count |
            Should -Be 0
    }

    It 'uses the arbitrated makeatletter token as one mandatory argument occurrence' {
        $probe = Invoke-ExecutionLedgerProbe -Script @'
const lines = [
  String.raw`\newcommand{\foo}[1]{#1}`,
  String.raw`\makeatletter`,
  String.raw`\foo\bar@baz`,
  String.raw`\makeatother`,
];
const raw = `${lines.join("\n")}\n`;
const foo = macroInvocation(raw, lines[2], "foo");
const atToken = macroInvocation(raw, lines[2], "bar@baz");
const result = compileExecution({
  slug: "makeatletter-argument",
  treeSha256: "f".repeat(64),
  entrypoint: "main.tex",
  entities: [
    macroDefinition(raw, lines[0], "foo", "newcommand", "newcommand", "m", "#1"),
    macroInvocation(raw, lines[1], "makeatletter"),
    foo,
    atToken,
    macroInvocation(raw, lines[3], "makeatother"),
  ],
  claims: [],
  includeEdges: [],
  configured: { summons: [], declarations: [], unresolvedPackages: [] },
  rawContents: new Map([["main.tex", raw]]),
  deps: {
    ctan: {
      macroInfo: {
        latex2e: { makeatletter: { signature: "" }, makeatother: { signature: "" } },
      },
      environmentInfo: { latex2e: {} },
    },
  },
});
const fooInvocation = result.invocations.find((row) => row.entityId === foo.id);
const atInvocation = result.invocations.find((row) => row.entityId === atToken.id);
console.log(JSON.stringify({
  foo: fooInvocation,
  fooArgumentText: fooInvocation?.arguments[0]?.span
    ? raw.slice(fooInvocation.arguments[0].span.startUtf16, fooInvocation.arguments[0].span.endUtf16)
    : null,
  at: atInvocation,
  atDiagnostics: result.diagnostics.filter((row) => row.entityId === atToken.id),
}));
'@

        $probe.foo.status | Should -BeExactly 'attached'
        $probe.foo.text | Should -BeExactly '\foo\bar@baz'
        $probe.fooArgumentText | Should -BeExactly '\bar@baz'
        $probe.at.status | Should -BeExactly 'deferred'
        $probe.at.binding.state | Should -BeExactly 'deferred'
        $probe.at.binding.reason | Should -BeExactly 'argument-body'
        @($probe.atDiagnostics).Count | Should -Be 1
        $probe.atDiagnostics[0].code | Should -BeExactly 'compile/invocation-deferred'
    }
}
