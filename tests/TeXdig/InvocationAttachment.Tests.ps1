BeforeDiscovery {
    $script:InvocationAttachmentNodeAvailable = $null -ne (Get-Command node -ErrorAction SilentlyContinue)
}

Describe "TeXdig raw invocation attachment" -Tag "TeXdig", "InvocationAttachment" `
        -Skip:(-not $script:InvocationAttachmentNodeAvailable) {
    BeforeAll {
        $script:RepositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "../..")).Path
        $script:NodePath = (Get-Command node -CommandType Application -ErrorAction Stop).Source
        $modulePath = (Resolve-Path -LiteralPath (
                Join-Path $script:RepositoryRoot "src/TeXdig/compile/arguments.ts"
            )).Path
        $moduleUri = ([Uri]$modulePath).AbsoluteUri

        $probeScript = @'
import {
  attachInvocationArguments,
  attachLiteralIncludeInvocation,
  parseAttachmentSignature,
  parseKnownSignatureSpec,
} from "__ARGUMENTS__";

const known = (spec) => ({ state: "known", spec });
const site = (text, token = "\\foo") => {
  const startUtf16 = text.indexOf(token);
  if (startUtf16 < 0) throw new Error(`Missing site token ${token}.`);
  return {
    sourceId: "probe.tex",
    startUtf16,
    endUtf16: startUtf16 + token.length,
  };
};
const attach = (text, spec) => attachInvocationArguments(text, site(text), known(spec));
const view = (text, result) => ({
  text,
  result,
  spanText: text.slice(result.span.startUtf16, result.span.endUtf16),
  errorText: result.status === "malformed"
    ? text.slice(result.errorSpan.startUtf16, result.errorSpan.endUtf16)
    : undefined,
  arguments: result.arguments.map((argument) => ({
    ...argument,
    spanText: argument.span
      ? text.slice(argument.span.startUtf16, argument.span.endUtf16)
      : undefined,
    spanCodePoints: argument.span
      ? Array.from(text.slice(argument.span.startUtf16, argument.span.endUtf16),
          (character) => character.codePointAt(0).toString(16))
      : undefined,
    contentText: argument.contentSpan
      ? text.slice(argument.contentSpan.startUtf16, argument.contentSpan.endUtf16)
      : undefined,
  })),
});

const braceEmptyText = String.raw`\foo{}Z`;
const braceNestedText = String.raw`\foo{a{\}}b}Z`;
const unicodeText = "\\foo  😀Z";
const controlText = "\\foo  % ignored ] }\r\n \\bar Z";
const omittedOptionalText = "\\foo \t {x}tail";
const explicitOptionalText = String.raw`\foo[]Z`;
const nestedOptionalText = String.raw`\foo[a{]}[b]]tail`;
const absentDefaultText = String.raw`\foo Z`;
const explicitDefaultText = String.raw`\foo[]Z`;
const starText = String.raw`\foo  *Z`;
const starAbsentText = String.raw`\foo Z`;
const multiText = String.raw`\foo*[][x]\bar!`;
const missingText = "\\foo  % comment";
const unclosedBraceText = String.raw`\foo{x`;
const unclosedBracketText = String.raw`\foo[x`;
const incompleteControlText = "\\foo\\";
const deferredText = String.raw`\foo{x}`;
const atSensitiveText = String.raw`\foo\bar@baz`;
const atArgumentStart = atSensitiveText.indexOf(String.raw`\bar@baz`);
const literalBareText = String.raw`\input chapter.long-name.tex`;
const literalBareTarget = "chapter.long-name.tex";
const literalBareTargetStart = literalBareText.indexOf(literalBareTarget);
const literalBracedText = String.raw`\subfile{sub/chapter}`;
const literalBracedTarget = "sub/chapter";
const literalBracedTargetStart = literalBracedText.indexOf(literalBracedTarget);

let invalidSite;
try {
  attachInvocationArguments("\\foo", {
    sourceId: "probe.tex",
    startUtf16: 0,
    endUtf16: 5,
  }, known(""));
} catch (error) {
  invalidSite = { name: error.name, message: error.message };
}

console.log(JSON.stringify({
  signatures: {
    zero: parseKnownSignatureSpec(""),
    supported: parseKnownSignatureSpec(String.raw`m o O{{fallback}\{x\}} s`),
    unsupported: parseKnownSignatureSpec("m t+"),
    invalid: parseKnownSignatureSpec("O{broken"),
    custom: parseAttachmentSignature({ state: "custom-parser", detail: "package callback" }),
    unknown: parseAttachmentSignature({ state: "unknown", detail: "not declared" }),
  },
  attachments: {
    zero: view(String.raw`\foo tail`, attach(String.raw`\foo tail`, "")),
    braceEmpty: view(braceEmptyText, attach(braceEmptyText, "m")),
    braceNested: view(braceNestedText, attach(braceNestedText, "m")),
    unicode: view(unicodeText, attach(unicodeText, "m")),
    control: view(controlText, attach(controlText, "m")),
    optionalOmitted: view(omittedOptionalText, attach(omittedOptionalText, "o m")),
    optionalExplicit: view(explicitOptionalText, attach(explicitOptionalText, "o")),
    optionalNested: view(nestedOptionalText, attach(nestedOptionalText, "o")),
    defaultAbsent: view(absentDefaultText, attach(absentDefaultText, "O{}")),
    defaultExplicit: view(explicitDefaultText, attach(explicitDefaultText, "O{fallback}")),
    star: view(starText, attach(starText, "s")),
    starAbsent: view(starAbsentText, attach(starAbsentText, "s")),
    multi: view(multiText, attach(multiText, "s o O{fallback} m")),
    missing: view(missingText, attach(missingText, "m")),
    unclosedBrace: view(unclosedBraceText, attach(unclosedBraceText, "m")),
    unclosedBracket: view(unclosedBracketText, attach(unclosedBracketText, "o")),
    incompleteControl: view(incompleteControlText, attach(incompleteControlText, "m")),
    unsupported: view(deferredText, attach(deferredText, "m t+")),
    custom: view(deferredText, attachInvocationArguments(
      deferredText,
      site(deferredText),
      { state: "custom-parser", detail: "package callback" }
    )),
    atInside: view(atSensitiveText, attachInvocationArguments(
      atSensitiveText,
      site(atSensitiveText),
      known("m"),
      { controlSequenceSpans: [{
        sourceId: "probe.tex",
        startUtf16: atArgumentStart,
        endUtf16: atArgumentStart + String.raw`\bar@baz`.length,
      }] }
    )),
    atOutside: view(atSensitiveText, attachInvocationArguments(
      atSensitiveText,
      site(atSensitiveText),
      known("m"),
      { controlSequenceSpans: [{
        sourceId: "probe.tex",
        startUtf16: atArgumentStart,
        endUtf16: atArgumentStart + String.raw`\bar`.length,
      }] }
    )),
    atUnknown: view(atSensitiveText, attach(atSensitiveText, "m")),
    literalBare: view(literalBareText, attachLiteralIncludeInvocation(
      literalBareText,
      site(literalBareText, String.raw`\input`),
      {
        directiveSpan: {
          sourceId: "probe.tex", startUtf16: 0, endUtf16: literalBareText.length,
        },
        targetRaw: literalBareTarget,
        targetSpan: {
          sourceId: "probe.tex",
          startUtf16: literalBareTargetStart,
          endUtf16: literalBareTargetStart + literalBareTarget.length,
        },
      }
    )),
    literalBraced: view(literalBracedText, attachLiteralIncludeInvocation(
      literalBracedText,
      site(literalBracedText, String.raw`\subfile`),
      {
        directiveSpan: {
          sourceId: "probe.tex", startUtf16: 0, endUtf16: literalBracedText.length,
        },
        targetRaw: literalBracedTarget,
        targetSpan: {
          sourceId: "probe.tex",
          startUtf16: literalBracedTargetStart,
          endUtf16: literalBracedTargetStart + literalBracedTarget.length,
        },
      }
    )),
  },
  invalidSite,
}));
'@
        $probeScript = $probeScript.Replace("__ARGUMENTS__", $moduleUri)
        $output = & $script:NodePath --input-type=module --eval $probeScript 2>&1 | Out-String
        $status = $LASTEXITCODE
        $global:LASTEXITCODE = 0
        if ($status -ne 0) {
            throw "Node invocation-attachment probe failed ($status): $output"
        }
        $script:Probe = $output | ConvertFrom-Json -Depth 30
    }

    It "parses the supported signature vocabulary and preserves known zero" {
        $script:Probe.signatures.zero.status | Should -BeExactly "supported"
        @($script:Probe.signatures.zero.slots).Count | Should -Be 0

        $supported = $script:Probe.signatures.supported
        $supported.status | Should -BeExactly "supported"
        @($supported.slots).Count | Should -Be 4
        @($supported.slots.kind) | Should -Be @("mandatory", "optional", "optional-default", "star")
        $supported.slots[2].defaultText | Should -BeExactly '{fallback}\{x\}'

        $zero = $script:Probe.attachments.zero
        $zero.result.status | Should -BeExactly "attached"
        @($zero.arguments).Count | Should -Be 0
        $zero.spanText | Should -BeExactly '\foo'
    }

    It "defers custom, unknown, unsupported, and invalid signatures without partial attachment" {
        $script:Probe.signatures.custom.reason | Should -BeExactly "custom-parser"
        $script:Probe.signatures.unknown.reason | Should -BeExactly "unknown-signature"
        $script:Probe.signatures.unsupported.reason | Should -BeExactly "unsupported-signature"
        $script:Probe.signatures.unsupported.offset | Should -Be 2
        $script:Probe.signatures.invalid.reason | Should -BeExactly "invalid-signature"

        $unsupported = $script:Probe.attachments.unsupported
        $unsupported.result.status | Should -BeExactly "deferred"
        @($unsupported.arguments).Count | Should -Be 0
        $unsupported.spanText | Should -BeExactly '\foo'
        $script:Probe.attachments.custom.result.reason | Should -BeExactly "custom-parser"
    }

    It "attaches braced arguments with exact empty and nested content spans" {
        $empty = $script:Probe.attachments.braceEmpty
        $empty.result.status | Should -BeExactly "attached"
        $empty.arguments[0].delimiter | Should -BeExactly "brace"
        $empty.arguments[0].spanText | Should -BeExactly '{}'
        $empty.arguments[0].contentText | Should -BeExactly ''
        $empty.arguments[0].contentSpan.startUtf16 | Should -Be $empty.arguments[0].contentSpan.endUtf16
        $empty.spanText | Should -BeExactly '\foo{}'

        $nested = $script:Probe.attachments.braceNested
        $nested.arguments[0].spanText | Should -BeExactly '{a{\}}b}'
        $nested.arguments[0].contentText | Should -BeExactly 'a{\}}b'
    }

    It "attaches one bare Unicode code point or one control-sequence token after raw trivia" {
        $unicode = $script:Probe.attachments.unicode
        $unicode.arguments[0].delimiter | Should -BeExactly "bare-character"
        @($unicode.arguments[0].spanCodePoints) | Should -Be @('1f600')
        ($unicode.arguments[0].span.endUtf16 - $unicode.arguments[0].span.startUtf16) | Should -Be 2
        $unicode.result.span.startUtf16 | Should -Be 0
        $unicode.result.span.endUtf16 | Should -Be 8

        $control = $script:Probe.attachments.control
        $control.arguments[0].delimiter | Should -BeExactly "control-sequence"
        $control.arguments[0].spanText | Should -BeExactly '\bar'
        $control.spanText | Should -BeExactly "\foo  % ignored ] }`r`n \bar"
    }

    It "uses canonical token evidence for at-sign control-sequence boundaries" {
        $inside = $script:Probe.attachments.atInside
        $inside.result.status | Should -BeExactly "attached"
        $inside.arguments[0].spanText | Should -BeExactly '\bar@baz'
        $inside.spanText | Should -BeExactly '\foo\bar@baz'

        $outside = $script:Probe.attachments.atOutside
        $outside.result.status | Should -BeExactly "attached"
        $outside.arguments[0].spanText | Should -BeExactly '\bar'
        $outside.spanText | Should -BeExactly '\foo\bar'

        $unknown = $script:Probe.attachments.atUnknown
        $unknown.result.status | Should -BeExactly "deferred"
        $unknown.result.reason | Should -BeExactly "control-sequence-boundary-unavailable"
        @($unknown.arguments).Count | Should -Be 0
        $unknown.spanText | Should -BeExactly '\foo'
    }

    It "attaches exact bare and braced literal include filenames" {
        $bare = $script:Probe.attachments.literalBare
        $bare.result.status | Should -BeExactly "attached"
        $bare.spanText | Should -BeExactly '\input chapter.long-name.tex'
        $bare.arguments[0].kind | Should -BeExactly "until"
        $bare.arguments[0].delimiter | Should -BeExactly "none"
        $bare.arguments[0].spanText | Should -BeExactly 'chapter.long-name.tex'
        $bare.arguments[0].contentText | Should -BeExactly 'chapter.long-name.tex'

        $braced = $script:Probe.attachments.literalBraced
        $braced.result.status | Should -BeExactly "attached"
        $braced.spanText | Should -BeExactly '\subfile{sub/chapter}'
        $braced.arguments[0].kind | Should -BeExactly "mandatory"
        $braced.arguments[0].delimiter | Should -BeExactly "brace"
        $braced.arguments[0].spanText | Should -BeExactly '{sub/chapter}'
        $braced.arguments[0].contentText | Should -BeExactly 'sub/chapter'
    }

    It "distinguishes omitted, explicit-empty, and defaulted optional arguments" {
        $omitted = $script:Probe.attachments.optionalOmitted
        @($omitted.arguments).Count | Should -Be 2
        $omitted.arguments[0].source | Should -BeExactly "omitted"
        $omitted.arguments[0].delimiter | Should -BeExactly "none"
        $omitted.arguments[0].PSObject.Properties.Name | Should -Not -Contain "span"
        $omitted.arguments[1].spanText | Should -BeExactly '{x}'
        $omitted.spanText | Should -BeExactly "\foo `t {x}"

        $explicit = $script:Probe.attachments.optionalExplicit
        $explicit.arguments[0].source | Should -BeExactly "explicit"
        $explicit.arguments[0].spanText | Should -BeExactly '[]'
        $explicit.arguments[0].contentText | Should -BeExactly ''

        $defaulted = $script:Probe.attachments.defaultAbsent
        $defaulted.arguments[0].source | Should -BeExactly "default"
        $defaulted.arguments[0].defaultText | Should -BeExactly ''
        $defaulted.arguments[0].PSObject.Properties.Name | Should -Not -Contain "span"
        $defaulted.spanText | Should -BeExactly '\foo'

        $defaultExplicit = $script:Probe.attachments.defaultExplicit
        $defaultExplicit.arguments[0].source | Should -BeExactly "explicit"
        $defaultExplicit.arguments[0].PSObject.Properties.Name | Should -Not -Contain "defaultText"
    }

    It "balances bracket arguments and emits ordered star, optional, default, and mandatory slots" {
        $nested = $script:Probe.attachments.optionalNested
        $nested.arguments[0].spanText | Should -BeExactly '[a{]}[b]]'
        $nested.arguments[0].contentText | Should -BeExactly 'a{]}[b]'

        $star = $script:Probe.attachments.star
        $star.arguments[0].source | Should -BeExactly "explicit"
        $star.arguments[0].marker | Should -BeExactly '*'
        $star.arguments[0].spanText | Should -BeExactly '*'
        $script:Probe.attachments.starAbsent.arguments[0].source | Should -BeExactly "omitted"

        $multi = $script:Probe.attachments.multi
        @($multi.arguments.slot) | Should -Be @(0, 1, 2, 3)
        @($multi.arguments.source) | Should -Be @("explicit", "explicit", "explicit", "explicit")
        @($multi.arguments.spanText) | Should -Be @('*', '[]', '[x]', '\bar')
        $multi.spanText | Should -BeExactly '\foo*[][x]\bar'
    }

    It "returns bounded malformed evidence for missing and unclosed arguments" {
        $missing = $script:Probe.attachments.missing
        $missing.result.status | Should -BeExactly "malformed"
        $missing.result.reason | Should -BeExactly "missing-mandatory"
        $missing.result.slot | Should -Be 0
        $missing.result.errorSpan.startUtf16 | Should -Be $missing.text.Length
        $missing.result.errorSpan.endUtf16 | Should -Be $missing.text.Length
        $missing.spanText | Should -BeExactly '\foo'

        $brace = $script:Probe.attachments.unclosedBrace
        $brace.result.reason | Should -BeExactly "unclosed-brace"
        $brace.errorText | Should -BeExactly '{x'
        $brace.spanText | Should -BeExactly '\foo{x'

        $bracket = $script:Probe.attachments.unclosedBracket
        $bracket.result.reason | Should -BeExactly "unclosed-bracket"
        $bracket.errorText | Should -BeExactly '[x'

        $control = $script:Probe.attachments.incompleteControl
        $control.result.reason | Should -BeExactly "incomplete-control-sequence"
        $control.errorText | Should -BeExactly '\'
    }

    It "rejects a site span outside the supplied raw UTF-16 text" {
        $script:Probe.invalidSite.name | Should -BeExactly "RangeError"
        $script:Probe.invalidSite.message | Should -Match "bounded UTF-16 span"
    }
}
