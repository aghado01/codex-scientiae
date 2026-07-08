#requires -Version 7
# Crop-rect base computation (src/pdf-converter/pdfdig-images.ps1 :: Get-FigureCropBbox) — the B1
# painted-ink crop with the A2b interaction guard. visible_bbox tightens the render rect to painted ink
# where unpainted clip masks inflated the geometric bbox (crop-bbox-inflation.md class a), but the
# INTERSECTION with bbox must never let it re-expand past a deliberate bbox trim (A2b, class b white
# fill). Pure function — no raster / no node required.

BeforeAll {
    $repo = Split-Path $PSScriptRoot -Parent
    . (Join-Path $repo 'src/pdf-converter/pdfdig-images.ps1')
}

Describe 'pdfdig image crop base — Get-FigureCropBbox (B1 painted-ink crop)' {
    It 'returns the geometric bbox unchanged when no visible_bbox is present' {
        $bb = Get-FigureCropBbox @(100, 200, 300, 400) $null
        ($bb -join ',') | Should -Be '100,200,300,400'
    }

    It 'contracts to visible_bbox when it sits inside bbox (the class-a tighten, e.g. 1701 id4)' {
        # geometric union inflated by clip rects; painted ink is a strict inner box on every edge.
        $bb = Get-FigureCropBbox @(196.2, 592.29, 415.8, 708.34) @(199.36, 592.79, 410.47, 695.52)
        ($bb -join ',') | Should -Be '199.36,592.79,410.47,695.52'
    }

    It 'clamps visible_bbox to a trimmed bbox — never re-expands past A2b (1701 Fig 7 / class b)' {
        # A2b pulled bbox bottom UP to the caption top (495.26); the class-(b) white FILL drags
        # visible_bbox down to 398.78. Intersection must keep A2b's trimmed bottom, not the fill's.
        $bb = Get-FigureCropBbox @(132.6, 495.26, 459.53, 728.33) @(132.6, 398.78, 459.53, 728.33)
        ($bb -join ',') | Should -Be '132.6,495.26,459.53,728.33'
    }

    It 'intersects on every edge independently (tighten some, clamp others in one region)' {
        # visible tighter on left/top, but reaches below a trimmed bottom → clamp bottom, tighten L/T.
        $bb = Get-FigureCropBbox @(100, 200, 300, 400) @(120, 150, 300, 380)
        ($bb -join ',') | Should -Be '120,200,300,380'   # L=max(100,120), B=max(200,150), R=min, T=min(400,380)
    }

    It 'falls back to the geometric bbox on a degenerate/disjoint intersection' {
        # visible_bbox entirely below bbox (no vertical overlap) → empty intersection → geometric bbox.
        $bb = Get-FigureCropBbox @(100, 500, 300, 700) @(100, 100, 300, 400)
        ($bb -join ',') | Should -Be '100,500,300,700'
    }

    It 'returns a fresh array (does not alias or mutate the caller bbox)' {
        $src = @(10.0, 20.0, 30.0, 40.0)
        $bb  = Get-FigureCropBbox $src @(15.0, 20.0, 30.0, 35.0)
        $bb[0] = -999
        $src[0] | Should -Be 10.0   # caller's bbox untouched
    }
}
