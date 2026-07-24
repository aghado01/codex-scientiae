#requires -Version 7.0
<#
  src/audits/md-register.ps1 — the ONE markdown figure/image register, shared across emission lanes.

  Both converters end at the same corpus register (the pdfdig north star: pdfdig replicates an oracle
  run — issues/pdfdig-lane/pdfdig-ps-converter.md), so the register strings live in exactly one place:

    image     ![{kind}: {name}]({rel})                 kind ∈ figure | diagram
    caption   *{Text.}*                                italic paragraph, terminal punctuation enforced
                                                       (captions are sentences; also disarms MD036)
    marker    *[{kind}: {leaf} — {why}]*               the no-silent-failure channel: a figure that
                                                       could not be rendered/found is FLAGGED in place

  Extracted from the LaTeX oracle's Copy-LatexFigures emissions (byte-identical); the membrane finalize
  weave (pig lane) emits through the same three. Pure string builders — no I/O, no state.

    . ./md-register.ps1
#>

# ![figure: name](slug/name.png) — the image line. $Kind: 'figure' for captioned floats/assets,
# 'diagram' for inline/uncaptioned diagram crops; a parenthesized qualifier may ride the kind
# ('figure (pdf)') where the source format matters to the reader.
function Format-MdFigureImage([string]$Kind, [string]$Name, [string]$RelPath) {
    return "![${Kind}: ${Name}](${RelPath})"
}

# *Caption text.* — captions are sentences: terminal punctuation enforced (MD036 disarm rides on the
# trailing period). Returns $null for empty input (caller decides whether to emit anything at all).
function Format-MdFigureCaption([string]$Text) {
    $c = ([string]$Text).Trim()
    if (-not $c) { return $null }
    if ($c -notmatch '[.!?:]$') { $c += '.' }
    return "*$c*"
}

# *[figure (pdf): plot.pdf — PNG conversion pending]* — the flagged in-place marker for a figure that
# could not be resolved to a rendered image. Never silently dropped.
function Format-MdFigureMarker([string]$Kind, [string]$Leaf, [string]$Why) {
    return "*[${Kind}: ${Leaf} — ${Why}]*"
}
