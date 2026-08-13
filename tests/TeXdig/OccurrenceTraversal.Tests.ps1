BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:Node = (Get-Command node -ErrorAction Stop).Source
    $script:OccurrenceModule = Join-Path $script:RepositoryRoot 'src/TeXdig/compile/occurrences.ts'

    $script:OccurrencePreamble = @'
import { createHash } from "node:crypto";
import { pathToFileURL } from "node:url";
const { planSourceOccurrences } = await import(pathToFileURL(process.argv[1]).href);

const span = (sourceId, startUtf16, endUtf16) => ({ sourceId, startUtf16, endUtf16 });
const base = (id, sourceSpan) => ({
  id,
  span: sourceSpan,
  spanProvenance: "lexical",
  witnesses: [],
  agreement: "lexical-only",
  agreementBasis: "single-authority",
});
const site = (from, start, end, to, targetRaw = to, directive = "input") => {
  const sourceSpan = span(from, start, end);
  return {
    entity: {
      ...base(`ent:include@${from}:${start}-${end}`, sourceSpan),
      kind: "include",
      directive,
      targetRaw,
      resolvedSourceId: to,
    },
    edge: {
      fromSourceId: from,
      toSourceId: to,
      directive,
      targetRaw,
      span: sourceSpan,
      targetSpan: sourceSpan,
    },
  };
};
const macroDefinition = (sourceId, start, end, dialect = "newcommand") => ({
  ...base(`ent:macro-definition@${sourceId}:${start}-${end}`, span(sourceId, start, end)),
  kind: "macro-definition",
  definedName: "holder",
  declarationCommand: "newcommand",
  dialect,
  signature: { state: "known", spec: "" },
  elaborable: dialect !== "configured",
  context: "document-flow",
  activation: "immediate",
});
const plan = (entrypoint, sites, definitions = [], limits = {}) => planSourceOccurrences({
  entrypoint,
  entities: [...sites.map((item) => item.entity), ...definitions],
  includeEdges: sites.map((item) => item.edge),
  maxOccurrences: limits.maxOccurrences ?? 100,
  maxDepth: limits.maxDepth ?? 20,
});
const digest = (seed) => `occ:${createHash("sha256").update(seed, "utf8").digest("hex")}`;
const capture = (action) => {
  try {
    return { ok: true, value: action() };
  } catch (error) {
    return { ok: false, message: error instanceof Error ? error.message : String(error) };
  }
};
const output = (value) => console.log(JSON.stringify(value));
'@

    function Invoke-OccurrenceNode {
        param([Parameter(Mandatory)] [string] $Body)

        $probe = $script:OccurrencePreamble + "`n" + $Body
        $nativeOutput = @(& $script:Node --input-type=module -e $probe $script:OccurrenceModule 2>&1)
        $exitCode = $LASTEXITCODE
        $global:LASTEXITCODE = 0
        $text = ($nativeOutput | ForEach-Object { $_.ToString() }) -join "`n"
        if ($exitCode -ne 0) {
            throw "Occurrence probe failed ($exitCode): $text"
        }
        return $text | ConvertFrom-Json -Depth 40
    }
}

Describe 'TeXdig occurrence topology planning' -Tag 'TeXdig', 'OccurrenceTraversal' {
    It 'mints exact route-derived ids and leaves execution sequence unassigned' {
        $result = Invoke-OccurrenceNode -Body @'
const first = site("main.tex", 20, 30, "b.tex", "b");
const second = site("main.tex", 0, 10, "a.tex", "a");
const result = plan("main.tex", [first, second]);
const rootExpected = digest("texdig-occurrence/0.3\0root\0main.tex\n");
const childExpected = digest(
  `texdig-occurrence/0.3\0child\0${rootExpected}\0ent:include@main.tex:0-10\0a.tex\n`
);
output({
  result,
  rootExpected,
  childExpected,
  traceKey: result.trace.map((event) => `${event.phase}:${event.sourceId}:${event.depth}`).join("|"),
});
'@

        $result.result.rootOccurrenceId | Should -Be $result.rootExpected
        $result.result.occurrences[1].id | Should -Be $result.childExpected
        (@($result.result.occurrences.sourceId) -join '|') | Should -Be 'main.tex|a.tex|b.tex'
        $result.result.occurrences[0].basis | Should -Be 'manifest-entrypoint'
        $result.result.occurrences[1].basis | Should -Be 'literal-directive'
        $result.result.occurrences[1].parentOccurrenceId | Should -Be $result.rootExpected
        $result.result.occurrences[1].includeEntityId | Should -Be 'ent:include@main.tex:0-10'
        @($result.result.occurrences[0].PSObject.Properties.Name) | Should -Not -Contain 'enterSeq'
        @($result.result.occurrences[0].PSObject.Properties.Name) | Should -Not -Contain 'exitSeq'
        $result.traceKey | Should -Be 'enter:main.tex:0|enter:a.tex:1|exit:a.tex:1|enter:b.tex:1|exit:b.tex:1|exit:main.tex:0'
    }

    It 'replays a completed wrapper and its outgoing physical edge for each route' {
        $result = Invoke-OccurrenceNode -Body @'
const result = plan("main.tex", [
  site("main.tex", 0, 10, "wrapper.tex", "wrapper-one"),
  site("main.tex", 20, 30, "wrapper.tex", "wrapper-two"),
  site("wrapper.tex", 0, 10, "leaf.tex", "leaf"),
]);
output(result);
'@

        (@($result.occurrences.sourceId) -join '|') | Should -Be 'main.tex|wrapper.tex|leaf.tex|wrapper.tex|leaf.tex'
        $result.occurrences[1].id | Should -Not -Be $result.occurrences[3].id
        $result.occurrences[2].id | Should -Not -Be $result.occurrences[4].id
        $result.occurrences[2].includeEntityId | Should -Be 'ent:include@wrapper.tex:0-10'
        $result.occurrences[4].includeEntityId | Should -Be 'ent:include@wrapper.tex:0-10'
        $result.occurrences[2].parentOccurrenceId | Should -Be $result.occurrences[1].id
        $result.occurrences[4].parentOccurrenceId | Should -Be $result.occurrences[3].id
        $result.trace.Count | Should -Be 10
    }

    It 'materializes distinct leaf routes through a diamond' {
        $result = Invoke-OccurrenceNode -Body @'
const result = plan("main.tex", [
  site("main.tex", 0, 10, "left.tex", "left"),
  site("main.tex", 20, 30, "right.tex", "right"),
  site("left.tex", 0, 10, "leaf.tex", "leaf"),
  site("right.tex", 0, 10, "leaf.tex", "leaf"),
]);
output(result);
'@

        (@($result.occurrences.sourceId) -join '|') | Should -Be 'main.tex|left.tex|leaf.tex|right.tex|leaf.tex'
        $result.occurrences[2].state | Should -Be 'entered'
        $result.occurrences[4].state | Should -Be 'entered'
        $result.occurrences[2].id | Should -Not -Be $result.occurrences[4].id
        (@($result.occurrences[2].includeChain) -join '>') | Should -Be 'main.tex>left.tex>leaf.tex'
        (@($result.occurrences[4].includeChain) -join '>') | Should -Be 'main.tex>right.tex>leaf.tex'
    }

    It 'cuts only an active-stack cycle and joins it to the nearest active occurrence' {
        $result = Invoke-OccurrenceNode -Body @'
const result = plan("main.tex", [
  site("main.tex", 0, 10, "a.tex", "a"),
  site("a.tex", 0, 10, "main.tex", "main"),
]);
output({
  result,
  traceKey: result.trace.map((event) => `${event.phase}:${event.state}:${event.sourceId}`).join("|"),
});
'@

        (@($result.result.occurrences.state) -join '|') | Should -Be 'entered|entered|cycle-cut'
        $result.result.occurrences[2].cycleTargetOccurrenceId | Should -Be $result.result.rootOccurrenceId
        (@($result.result.occurrences[2].includeChain) -join '>') | Should -Be 'main.tex>a.tex>main.tex'
        $result.traceKey | Should -Be 'enter:entered:main.tex|enter:entered:a.tex|enter:cycle-cut:main.tex|exit:cycle-cut:main.tex|exit:entered:a.tex|exit:entered:main.tex'
    }

    It 'defers includes contained by physical definition syntax without traversing their targets' {
        $result = Invoke-OccurrenceNode -Body @'
const hidden = site("main.tex", 10, 20, "hidden.tex", "hidden");
const live = site("main.tex", 50, 60, "live.tex", "live");
const deep = site("hidden.tex", 0, 10, "deep.tex", "deep");
const result = plan("main.tex", [hidden, live, deep], [
  macroDefinition("main.tex", 0, 40),
  macroDefinition("main.tex", 45, 70, "configured"),
]);
output(result);
'@

        (@($result.occurrences.sourceId) -join '|') | Should -Be 'main.tex|hidden.tex|live.tex'
        $result.occurrences[1].state | Should -Be 'deferred-context'
        $result.occurrences[1].deferredReason | Should -Be 'definition-body'
        $result.occurrences[1].includeEntityId | Should -Be 'ent:include@main.tex:10-20'
        $result.occurrences[2].state | Should -Be 'entered'
        @($result.occurrences.sourceId) | Should -Not -Contain 'deep.tex'
    }

    It 'is stable under entity and edge input permutation' {
        $result = Invoke-OccurrenceNode -Body @'
const sites = [
  site("main.tex", 20, 30, "right.tex", "right"),
  site("right.tex", 0, 10, "leaf.tex", "leaf-right"),
  site("main.tex", 0, 10, "left.tex", "left"),
  site("left.tex", 0, 10, "leaf.tex", "leaf-left"),
];
const normal = planSourceOccurrences({
  entrypoint: "main.tex",
  entities: sites.map((item) => item.entity),
  includeEdges: sites.map((item) => item.edge),
  maxOccurrences: 100,
  maxDepth: 20,
});
const permuted = planSourceOccurrences({
  entrypoint: "main.tex",
  entities: sites.map((item) => item.entity).reverse(),
  includeEdges: [sites[1].edge, sites[0].edge, sites[3].edge, sites[2].edge],
  maxOccurrences: 100,
  maxDepth: 20,
});
output({ equal: JSON.stringify(normal) === JSON.stringify(permuted), normal });
'@

        $result.equal | Should -BeTrue
        (@($result.normal.occurrences.sourceId) -join '|') | Should -Be 'main.tex|left.tex|leaf.tex|right.tex|leaf.tex'
    }

    It 'rejects missing, duplicate, noncanonical, and contradictory include joins' {
        $result = Invoke-OccurrenceNode -Body @'
const joined = site("main.tex", 0, 10, "a.tex", "a");
const invoke = (entities, edges) => planSourceOccurrences({
  entrypoint: "main.tex",
  entities,
  includeEdges: edges,
  maxOccurrences: 10,
  maxDepth: 5,
});
const wrongId = { ...joined.entity, id: "ent:include@main.tex:1-10" };
const wrongTarget = { ...joined.entity, resolvedSourceId: "b.tex" };
output({
  missing: capture(() => invoke([], [joined.edge])),
  duplicateEntity: capture(() => invoke([joined.entity, { ...joined.entity }], [joined.edge])),
  duplicateEdge: capture(() => invoke([joined.entity], [joined.edge, { ...joined.edge }])),
  noncanonical: capture(() => invoke([wrongId], [joined.edge])),
  contradictory: capture(() => invoke([wrongTarget], [joined.edge])),
});
'@

        $result.missing.ok | Should -BeFalse
        $result.missing.message | Should -Match 'no canonical physical entity'
        $result.duplicateEntity.message | Should -Match '2 physical entities'
        $result.duplicateEdge.message | Should -Match 'multiple executable edges claim'
        $result.noncanonical.message | Should -Match 'no canonical physical entity'
        $result.contradictory.message | Should -Match 'contradicts physical entity'
    }

    It 'refuses occurrence and depth overflow while ignoring nonexecution resource ties' {
        $result = Invoke-OccurrenceNode -Body @'
const first = site("main.tex", 0, 10, "a.tex", "a");
const second = site("a.tex", 0, 10, "b.tex", "b");
const unresolved = {
  fromSourceId: "main.tex",
  directive: "input",
  targetRaw: "missing",
  span: span("main.tex", 20, 30),
  targetSpan: span("main.tex", 20, 30),
};
const resource = {
  fromSourceId: "main.tex",
  toSourceId: "refs.bib",
  directive: "addbibresource",
  targetRaw: "refs.bib",
  span: span("main.tex", 40, 50),
  targetSpan: span("main.tex", 40, 50),
};
const bounded = (maxOccurrences, maxDepth) => planSourceOccurrences({
  entrypoint: "main.tex",
  entities: [first.entity, second.entity],
  includeEdges: [resource, second.edge, unresolved, first.edge],
  maxOccurrences,
  maxDepth,
});
output({
  accepted: bounded(3, 2),
  occurrences: capture(() => bounded(2, 2)),
  depth: capture(() => bounded(3, 0)),
  invalid: capture(() => bounded(0, 2)),
});
'@

        (@($result.accepted.occurrences.sourceId) -join '|') | Should -Be 'main.tex|a.tex|b.tex'
        $result.occurrences.message | Should -Match 'maxOccurrences 2 exceeded'
        $result.depth.message | Should -Match 'maxDepth 0 exceeded'
        $result.invalid.message | Should -Match 'maxOccurrences must be a safe integer'
    }

    It 'rejects malformed source and target span relationships' {
        $result = Invoke-OccurrenceNode -Body @'
const joined = site("main.tex", 0, 10, "a.tex", "a");
const invoke = (edge) => planSourceOccurrences({
  entrypoint: "main.tex",
  entities: [joined.entity],
  includeEdges: [edge],
  maxOccurrences: 10,
  maxDepth: 5,
});
output({
  sourceMismatch: capture(() => invoke({
    ...joined.edge,
    targetSpan: span("other.tex", 0, 10),
  })),
  targetEscape: capture(() => invoke({
    ...joined.edge,
    targetSpan: span("main.tex", 0, 11),
  })),
});
'@

        $result.sourceMismatch.message | Should -Match 'source does not agree with its spans'
        $result.targetEscape.message | Should -Match 'target span escapes its directive span'
    }
}
