#requires -Version 7.0
# Sci-Hub DOI fetcher (scihub-get.ps1) — offline only: DOI slug, PDF-URL scraping (the §5-confirmed
# shapes), and captcha-gate detection. The network fetch (mirror rotation + download) is smoke-tested live.

BeforeAll {
    . "$PSScriptRoot/../src/scholar-core.ps1"
    . "$PSScriptRoot/../src/scihub-get.ps1"

    # The real sci-hub.ru shape from the recon: PDF as a protocol-relative storage URL, no iframe, latent
    # captcha JS that must NOT be read as a gate (a PDF is present).
    $script:RealPage = @'
<html><head><script>var captcha = {}; let data = {captcha: captcha};</script></head>
<body><div id="article"><embed type="application/pdf" src="//sci-hub.cat/storage/2024/753/hash/zomorodian2004.pdf#view=FitH"></div>
<button onclick="recite('plain')">cite</button></body></html>
'@
    $script:GatePage = @'
<html><body><p>To continue, solve the captcha</p><div class="g-recaptcha" data-sitekey="x"></div></body></html>
'@
    $script:RelPage = '<html><body><a href="/downloads/2024/01/10.1/paper.pdf?download=true">save</a></body></html>'
}

Describe 'ConvertTo-ScihubSlug' {
    It 'canonicalizes + filesystem-sanitizes a DOI' {
        ConvertTo-ScihubSlug 'https://doi.org/10.1007/S00454-004-1146-Y' | Should -Be '10.1007_s00454-004-1146-y'
        ConvertTo-ScihubSlug '10.1126/science.1099745'                    | Should -Be '10.1126_science.1099745'
    }
    It 'throws on an empty DOI' { { ConvertTo-ScihubSlug '  ' } | Should -Throw }
}

Describe 'Resolve-ScihubPdfUrl' {
    It 'lifts a protocol-relative storage PDF and makes it https (the recon shape)' {
        Resolve-ScihubPdfUrl -Html $script:RealPage -MirrorBase 'https://sci-hub.ru' |
            Should -Be 'https://sci-hub.cat/storage/2024/753/hash/zomorodian2004.pdf#view=FitH'
    }
    It 'resolves a mirror-relative download URL against the mirror' {
        Resolve-ScihubPdfUrl -Html $script:RelPage -MirrorBase 'https://sci-hub.ru' |
            Should -Be 'https://sci-hub.ru/downloads/2024/01/10.1/paper.pdf?download=true'
    }
    It 'returns null when no PDF is present' {
        Resolve-ScihubPdfUrl -Html $script:GatePage -MirrorBase 'https://sci-hub.ru' | Should -BeNullOrEmpty
    }
}

Describe 'Test-ScihubCaptchaGate' {
    It 'is FALSE when a PDF is present despite latent captcha JS' {
        Test-ScihubCaptchaGate -Html $script:RealPage -MirrorBase 'https://sci-hub.ru' | Should -BeFalse
    }
    It 'is TRUE when there is no PDF and an active captcha widget' {
        Test-ScihubCaptchaGate -Html $script:GatePage -MirrorBase 'https://sci-hub.ru' | Should -BeTrue
    }
}
