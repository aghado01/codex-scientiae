BeforeAll {
    $script:RepositoryRoot = (Resolve-Path "$PSScriptRoot/../..").Path
    $script:Node = (Get-Command node -CommandType Application -ErrorAction Stop).Source
    $script:ClaimsModule = Join-Path $script:RepositoryRoot 'src/TeXdig/census/claims.ts'
}

Describe 'TeXdig pillar overlays' -Tag 'TeXdig', 'Claims' {
    It 'claims a float as both a fence and an envelope' {
        $probe = @'
import { pathToFileURL } from "node:url";
const { generatePillarClaims } = await import(pathToFileURL(process.argv[1]).href);
const span = { sourceId: "main.tex", startUtf16: 4, endUtf16: 20 };
const entity = {
  id: "ent:environment@main.tex:4-20",
  kind: "environment",
  name: "figure",
  role: "float",
  span,
  spanProvenance: "lexical",
  witnesses: [{ witness: "lexical", span, spanRole: "construct" }],
  agreement: "lexical-only",
  agreementBasis: "single-authority",
};
console.log(JSON.stringify(generatePillarClaims("main.tex", [entity], [], [])));
'@
        $claims = (& $script:Node --input-type=module -e $probe $script:ClaimsModule) |
            ConvertFrom-Json
        $global:LASTEXITCODE = 0

        @($claims).Count | Should -Be 2
        (@($claims.pillar | Sort-Object) -join '|') | Should -Be 'envelope|fence'
        @($claims.entityId | Select-Object -Unique).Count | Should -Be 1
        $claims[0].entityId | Should -Be 'ent:environment@main.tex:4-20'
    }

    It 'places explicit paragraph-break evidence on the spine' {
        $probe = @'
import { pathToFileURL } from "node:url";
const { generatePillarClaims } = await import(pathToFileURL(process.argv[1]).href);
const span = { sourceId: "main.tex", startUtf16: 8, endUtf16: 10 };
const entity = {
  id: "ent:paragraph-break@main.tex:8-10",
  kind: "paragraph-break",
  span,
  spanProvenance: "parser",
  witnesses: [{ witness: "parser", span, spanRole: "construct" }],
  agreement: "agreed",
  agreementBasis: "single-authority",
};
console.log(JSON.stringify(generatePillarClaims("main.tex", [entity], [], [])));
'@
        $claim = (& $script:Node --input-type=module -e $probe $script:ClaimsModule) |
            ConvertFrom-Json
        $global:LASTEXITCODE = 0

        $claim.pillar | Should -Be 'spine'
        $claim.role | Should -Be 'paragraph-break'
    }
}
