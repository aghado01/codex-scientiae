BeforeDiscovery {
    $script:WitnessFusionNodeAvailable = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
}

Describe "TeXdig witness fusion primitives" -Tag "TeXdig", "WitnessFusion" `
        -Skip:(-not $script:WitnessFusionNodeAvailable) {
    BeforeAll {
        $script:RepositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "../..")).Path
        $script:NodePath = (Get-Command node -CommandType Application -ErrorAction Stop).Source
        $script:ModuleUris = @{}
        foreach ($entry in @{
                Spans = "src/TeXdig/core/spans.ts"
                Equivalence = "src/TeXdig/census/witness-equivalence.ts"
                Loader = "src/TeXdig/core/loader.ts"
                ScanLatex = "src/TeXdig/census/scan-latex.ts"
                ParseLatex = "src/TeXdig/census/parse-latex.ts"
                Reconcile = "src/TeXdig/census/reconcile.ts"
                ScanBib = "src/TeXdig/census/scan-bib.ts"
                ParseBib = "src/TeXdig/census/parse-bib.ts"
            }.GetEnumerator()) {
            $resolved = (Resolve-Path -LiteralPath (Join-Path $script:RepositoryRoot $entry.Value)).Path
            $script:ModuleUris[$entry.Key] = ([Uri]$resolved).AbsoluteUri
        }
        $script:DepsRootJson = (Join-Path $script:RepositoryRoot "packages/node/node_modules") |
            ConvertTo-Json -Compress

        function Invoke-TeXdigNodeProbe {
            param([Parameter(Mandatory)] [string] $Script)

            $expanded = $Script
            foreach ($entry in $script:ModuleUris.GetEnumerator()) {
                $expanded = $expanded.Replace("__$($entry.Key.ToUpperInvariant())__", $entry.Value)
            }
            $expanded = $expanded.Replace("__DEPS_ROOT__", $script:DepsRootJson)
            $output = & $script:NodePath --input-type=module --eval $expanded 2>&1 | Out-String
            $status = $LASTEXITCODE
            $global:LASTEXITCODE = 0
            if ($status -ne 0) {
                throw "Node witness-fusion probe failed ($status): $output"
            }
            return $output | ConvertFrom-Json -Depth 30
        }

        $script:PrimitiveProbe = Invoke-TeXdigNodeProbe -Script @'
import {
  validateSourceSpan,
  sourceSpanContains,
  sourceSpanHull,
} from "__SPANS__";
import {
  compareEnvironmentWitnesses,
  compareWitnesses,
  equivalencePolicyForKind,
} from "__EQUIVALENCE__";

const span = (startUtf16, endUtf16, sourceId = "a.tex") =>
  ({ sourceId, startUtf16, endUtf16 });
const observation = (witness, role, start, end, semantics, sourceId = "a.tex") => ({
  witness,
  span: span(start, end, sourceId),
  spanRole: role,
  semantics,
});

const exactToken = compareWitnesses(
  "control-sequence-token",
  observation("parser", "token", 4, 8, { name: "foo" }),
  observation("lexical", "token", 4, 8, { name: "foo" })
);
const extentConflict = compareWitnesses(
  "math-carrier",
  observation("parser", "construct", 0, 9, { mode: "inline", carrier: { form: "paren" } }),
  observation("lexical", "construct", 0, 6, { mode: "inline", carrier: { form: "paren" } })
);
const environment = compareEnvironmentWitnesses(
  observation("parser", "construct", 10, 40, { name: "equation" }),
  observation("lexical", "begin-fence", 10, 26, { name: "equation" }),
  observation("lexical", "end-fence", 26, 40, { name: "equation" })
);

console.log(JSON.stringify({
  zero: validateSourceSpan(span(2, 2), 5),
  reversed: validateSourceSpan(span(3, 2), 5),
  pastEnd: validateSourceSpan(span(0, 6), 5),
  containedBoundary: sourceSpanContains(span(2, 5), span(5, 5)),
  crossSource: sourceSpanContains(span(0, 5), span(1, 2, "b.tex")),
  hull: sourceSpanHull([span(4, 8), span(1, 3), span(3, 5)]),
  mixedHull: sourceSpanHull([span(0, 1), span(1, 2, "b.tex")]),
  exactToken,
  extentConflict,
  environment,
  bibFieldPolicy: equivalencePolicyForKind("bib-field"),
  paragraphPolicy: equivalencePolicyForKind("paragraph-break"),
}));
'@

        $script:IntegrationProbe = Invoke-TeXdigNodeProbe -Script @'
import { loadDependencies } from "__LOADER__";
import { scanLatex } from "__SCANLATEX__";
import { discoverDefinitions, parseLatexWitness } from "__PARSELATEX__";
import { reconcileLatex, reconcileBib } from "__RECONCILE__";
import { scanBib } from "__SCANBIB__";
import { parseBib } from "__PARSEBIB__";

const deps = loadDependencies(__DEPS_ROOT__);
const emptyRegistry = { macros: {}, environments: {} };

function censusLatex(text, sourceId = "probe.tex", registry = emptyRegistry) {
  const discovery = discoverDefinitions(sourceId, text, deps);
  const scan = scanLatex(sourceId, text);
  const witness = parseLatexWitness(sourceId, text, deps, registry);
  const strat = { sourceId, strata: [], stratifiedText: text, diagnostics: [] };
  const reconciled = reconcileLatex(
    sourceId,
    text,
    strat,
    scan.sightings,
    discovery,
    witness,
    []
  );
  return { text, discovery, scan, witness, reconciled };
}

const changedArity = censusLatex(
  String.raw`\newcommand{\foo}[1]{A#1}
\foo{x}
\renewcommand{\foo}[2]{B#1#2}
\foo{y}{z}`,
  "arity.tex",
  { macros: { foo: { signature: "m m m m" } }, environments: {} }
);
const arityInvocations = changedArity.reconciled.entities
  .filter((entity) => entity.kind === "macro-invocation" && entity.name === "foo")
  .map((entity) => ({
    text: changedArity.text.slice(entity.span.startUtf16, entity.span.endUtf16),
    span: entity.span,
    agreement: entity.agreement,
  }));

const emptySyntax = censusLatex(
  String.raw`\newcommand{\foo}[1][]{}` + "\n" +
    String.raw`\newenvironment{emptyenv}[1][]{A#1}{}` + "\n" +
    String.raw`\foo{}`,
  "empty.tex"
);
const emptyMacro = emptySyntax.reconciled.entities.find(
  (entity) => entity.kind === "macro-definition" && entity.definedName === "foo"
);
const emptyEnvironment = emptySyntax.reconciled.entities.find(
  (entity) => entity.kind === "environment-definition" && entity.definedName === "emptyenv"
);
const emptyInvocation = emptySyntax.reconciled.entities.find(
  (entity) => entity.kind === "macro-invocation" && entity.name === "foo"
);

const localFrame = censusLatex(
  String.raw`\[\begin{cases}a&b\\c&d\end{cases}\]`,
  "local.tex"
);
const casesEnvironment = localFrame.reconciled.entities.find(
  (entity) => entity.kind === "environment" && entity.name === "cases"
);

const sameStart = censusLatex(String.raw`\(a\\)b\)`, "extent.tex");
const conflictedMath = sameStart.reconciled.entities.find(
  (entity) => entity.kind === "math" && entity.span.startUtf16 === 0
);

const spacedEnvironment = censusLatex(
  String.raw`\begin {equation}x\end {equation}`,
  "spaced.tex"
);

const nested = censusLatex(
  String.raw`\newcommand{\outer}{\newcommand{\inner}{x}}`,
  "nested.tex"
);
const inner = nested.reconciled.entities.find(
  (entity) => entity.kind === "macro-definition" && entity.definedName === "inner"
);

const unclassifiedLocal = censusLatex(
  String.raw`{\newcommand{\localonly}{x}}`,
  "scope.tex"
).reconciled.entities.find(
  (entity) => entity.kind === "macro-definition" && entity.definedName === "localonly"
);

const atOutside = censusLatex(String.raw`\foo@bar`, "catcode.tex");
const atInside = censusLatex(
  String.raw`\makeatletter\foo@bar\makeatother`,
  "makeat.tex"
);

const bibText = String.raw`@article(k,title="A (B")
@book(z,title="Z")`;
const bibParsed = parseBib("probe.bib", bibText, deps);
const bibReconciled = reconcileBib(
  "probe.bib",
  bibText,
  scanBib("probe.bib", bibText),
  bibParsed
);

const failingDeps = {
  ...deps,
  parse: {
    ...deps.parse,
    getParser: () => ({ parse: () => { throw new Error("planted parser failure"); } }),
  },
};
const failedParse = parseLatexWitness(
  "broken.tex",
  String.raw`\broken{`,
  failingDeps,
  emptyRegistry
);

console.log(JSON.stringify({
  arityInvocations,
  emptyMacro: emptyMacro && {
    signatureRaw: emptyMacro.signatureRaw,
    argumentSpec: emptyMacro.argumentSpec,
    bodySpan: emptyMacro.bodySpan,
    bodyText: emptySyntax.text.slice(emptyMacro.bodySpan.startUtf16, emptyMacro.bodySpan.endUtf16),
  },
  emptyEnvironment: emptyEnvironment && {
    signatureRaw: emptyEnvironment.signatureRaw,
    argumentSpec: emptyEnvironment.argumentSpec,
    endBodySpan: emptyEnvironment.endBodySpan,
    endBodyText: emptySyntax.text.slice(
      emptyEnvironment.endBodySpan.startUtf16,
      emptyEnvironment.endBodySpan.endUtf16
    ),
  },
  emptyInvocation: emptyInvocation && {
    text: emptySyntax.text.slice(emptyInvocation.span.startUtf16, emptyInvocation.span.endUtf16),
  },
  casesEnvironment,
  localDiagnostics: localFrame.reconciled.diagnostics,
  conflictedMath,
  spacedEnvironmentCount: spacedEnvironment.reconciled.entities.filter(
    (entity) => entity.kind === "environment" && entity.name === "equation"
  ).length,
  spacedMathCount: spacedEnvironment.reconciled.entities.filter(
    (entity) => entity.kind === "math" && entity.carrier.form === "env" && entity.carrier.name === "equation"
  ).length,
  inner,
  unclassifiedLocal,
  outsideNames: atOutside.scan.sightings.filter((site) => site.kind === "macro-invocation").map((site) => site.name),
  insideNames: atInside.scan.sightings.filter((site) => site.kind === "macro-invocation").map((site) => site.name),
  bibEntrySpans: bibReconciled.entities
    .filter((entity) => entity.kind === "bib-entry")
    .map((entity) => ({ start: entity.span.startUtf16, end: entity.span.endUtf16, agreement: entity.agreement })),
  bibFields: bibReconciled.entities
    .filter((entity) => entity.kind === "bib-field")
    .map((entity) => ({ agreement: entity.agreement, basis: entity.agreementBasis, witnesses: entity.witnesses.length })),
  bibBodiesContained: bibReconciled.entities
    .filter((entity) => entity.kind === "bib-entry")
    .every((entity) => entity.bodySpan && entity.bodySpan.startUtf16 >= entity.span.startUtf16 && entity.bodySpan.endUtf16 <= entity.span.endUtf16),
  failedParseDiagnostics: failedParse.diagnostics,
}));
'@
    }

    Context "Span algebra" {
        It "accepts empty bounded spans and rejects reversed or out-of-range spans" {
            $script:PrimitiveProbe.zero.valid | Should -BeTrue
            $script:PrimitiveProbe.reversed.code | Should -Be "end-before-start"
            $script:PrimitiveProbe.pastEnd.code | Should -Be "end-past-source"
        }

        It "contains zero-length boundary spans only on the same source" {
            $script:PrimitiveProbe.containedBoundary | Should -BeTrue
            $script:PrimitiveProbe.crossSource | Should -BeFalse
        }

        It "computes a same-source hull and refuses a mixed-source hull" {
            $script:PrimitiveProbe.hull.startUtf16 | Should -Be 1
            $script:PrimitiveProbe.hull.endUtf16 | Should -Be 8
            $script:PrimitiveProbe.mixedHull | Should -BeNullOrEmpty
        }
    }

    Context "Equivalence policy" {
        It "requires exact token extents" {
            $script:PrimitiveProbe.exactToken.equivalent | Should -BeTrue
        }

        It "rejects same-start math witnesses with different ends" {
            $script:PrimitiveProbe.extentConflict.equivalent | Should -BeFalse
            $script:PrimitiveProbe.extentConflict.reason | Should -Be "end-mismatch"
        }

        It "requires both matching environment boundaries" {
            $script:PrimitiveProbe.environment.equivalent | Should -BeTrue
        }

        It "routes Bib fields and paragraph breaks to explicit policies" {
            $script:PrimitiveProbe.bibFieldPolicy | Should -Be "bib-field-value"
            $script:PrimitiveProbe.paragraphPolicy | Should -Be "authority-only"
        }
    }

    Context "Physical LaTeX census regressions" {
        It "keeps invocations token-only when a later definition changes arity" {
            @($script:IntegrationProbe.arityInvocations).Count | Should -Be 2
            @($script:IntegrationProbe.arityInvocations.text) | Should -Be @("\foo", "\foo")
            @($script:IntegrationProbe.arityInvocations.agreement) | Should -Be @("agreed", "agreed")
        }

        It "preserves explicit empty defaults, bodies, and invocation arguments" {
            $script:IntegrationProbe.emptyMacro.signatureRaw | Should -Be "[1][]"
            $script:IntegrationProbe.emptyMacro.argumentSpec | Should -Be "O{}"
            $script:IntegrationProbe.emptyMacro.bodySpan.startUtf16 |
                Should -Be $script:IntegrationProbe.emptyMacro.bodySpan.endUtf16
            $script:IntegrationProbe.emptyMacro.bodyText | Should -BeExactly ""
            $script:IntegrationProbe.emptyEnvironment.signatureRaw | Should -Be "[1][]"
            $script:IntegrationProbe.emptyEnvironment.argumentSpec | Should -Be "O{}"
            $script:IntegrationProbe.emptyEnvironment.endBodySpan.startUtf16 |
                Should -Be $script:IntegrationProbe.emptyEnvironment.endBodySpan.endUtf16
            $script:IntegrationProbe.emptyEnvironment.endBodyText | Should -BeExactly ""
            $script:IntegrationProbe.emptyInvocation.text | Should -BeExactly "\foo"
        }

        It "never emits a local-frame environment body outside its entity" {
            $env = $script:IntegrationProbe.casesEnvironment
            $env | Should -Not -BeNullOrEmpty
            $env.bodySpan.startUtf16 | Should -BeGreaterOrEqual $env.span.startUtf16
            $env.bodySpan.endUtf16 | Should -BeLessOrEqual $env.span.endUtf16
        }

        It "reports same-start different-extent math evidence as conflict" {
            $script:IntegrationProbe.conflictedMath.agreement | Should -Be "conflict"
            @($script:IntegrationProbe.conflictedMath.witnesses | ForEach-Object { $_.span.endUtf16 } |
                Sort-Object -Unique).Count | Should -Be 2
        }

        It "retains whitespace-separated environment fences and their math overlay" {
            $script:IntegrationProbe.spacedEnvironmentCount | Should -Be 1
            $script:IntegrationProbe.spacedMathCount | Should -Be 1
        }

        It "marks definitions nested in definition programs as deferred" {
            $script:IntegrationProbe.inner.context | Should -Be "definition-body"
            $script:IntegrationProbe.inner.activation | Should -Be "deferred"
            $script:IntegrationProbe.inner.definedWithin | Should -Match "^ent:macro-definition@nested\.tex:"
        }

        It "does not assert activation or document flow when declaration scope is unclassified" {
            $script:IntegrationProbe.unclassifiedLocal.context | Should -Be "unknown"
            $script:IntegrationProbe.unclassifiedLocal.activation | Should -Be "unknown"
        }

        It "treats at-sign as a control letter only inside makeatletter state" {
            @($script:IntegrationProbe.outsideNames) | Should -Be @("foo")
            @($script:IntegrationProbe.insideNames) | Should -Contain "foo@bar"
        }
    }

    Context "Bib and diagnostic provenance regressions" {
        It "does not let parentheses in quoted Bib values swallow the next entry" {
            @($script:IntegrationProbe.bibEntrySpans).Count | Should -Be 2
            @($script:IntegrationProbe.bibEntrySpans.end) | Should -Be @(24, 43)
            @($script:IntegrationProbe.bibEntrySpans.agreement) | Should -Be @("agreed", "agreed")
            $script:IntegrationProbe.bibBodiesContained | Should -BeTrue
        }

        It "does not inherit parent-entry agreement onto parser-only Bib fields" {
            @($script:IntegrationProbe.bibFields).Count | Should -Be 2
            @($script:IntegrationProbe.bibFields.agreement | Select-Object -Unique) |
                Should -Be @("parser-only")
            @($script:IntegrationProbe.bibFields.basis | Select-Object -Unique) |
                Should -Be @("single-authority")
            @($script:IntegrationProbe.bibFields.witnesses | Select-Object -Unique) |
                Should -Be @(1)
        }

        It "attaches structured source identity to source-local parse failures" {
            @($script:IntegrationProbe.failedParseDiagnostics).Count | Should -Be 1
            $script:IntegrationProbe.failedParseDiagnostics[0].sourceId | Should -Be "broken.tex"
            $script:IntegrationProbe.failedParseDiagnostics[0].witness | Should -Be "parser"
        }
    }
}
