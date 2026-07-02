#requires -Version 7.0
# Tokenization consistency + fence-only-if-monospace through the LaTeX converter.
#
# One expression must produce ONE token stream wherever it appears: algorithmic pseudocode carries the
# same $-delimited, macro-expanded KaTeX-primitive math as body prose. And a markdown code fence is
# emitted ONLY for constructs the PDF really presents as monospace (verbatim/lstlisting/minted);
# algorithmic renders in the PDF as indented lines with bold keywords and live math, so it becomes a
# NESTED LIST (ordered iff the source asked for line numbers: \begin{algorithmic}[1]).
# Inside stashed code, % is not a comment and $ is not math — content survives byte-verbatim.

BeforeAll {
    . "$PSScriptRoot/../src/latex-ingest.ps1"

    $tex = @'
\documentclass{article}
\title{Tokens}
\newcommand{\A}{\mathbf{A}}
\begin{document}
Body math: $y_{i+1} = \A x_i^2$ inline, and display:
\begin{equation}
d(v) \ge \tau
\end{equation}
\begin{algorithm}
\caption{Neighbor update over $\mathcal{N}(v)$}
\begin{algorithmic}
\State $y_{i+1} \gets \A x_i^2$ \Comment{uses $\mathcal{N}(v)$}
\If{$d(v) \ge \tau$}
\State \Return $x_i$
\EndIf
\end{algorithmic}
\end{algorithm}
\begin{algorithmic}[1]
\While{$k < n$}
\State $k \gets k + 1$
\EndWhile
\end{algorithmic}
\begin{algorithm}
\caption{List-style pseudocode}
\begin{enumerate}
\item initialize $S \gets \emptyset$
\item grow $S$ greedily
\end{enumerate}
\end{algorithm}
\begin{lstlisting}[language=PowerShell]
$env:PATH -split ';' | Where-Object { $_ -match '%APPDATA%' }
\end{lstlisting}
\begin{verbatim}
raw $dollars$ and % percent survive
\end{verbatim}
\end{document}
'@
    $script:md = ConvertFrom-Latex $tex ''
}

Describe 'algorithmic -> nested list (never a fence): math live, keywords bold' {
    It 'emits a bold title line, not a fenced title' {
        $md | Should -Match '(?m)^\*\*Algorithm 1: Neighbor update over \$\\mathcal\{N\}\(v\)\$\*\*$'
        $md | Should -Not -Match '```text\s*\nAlgorithm'
    }
    It 'keeps $-delimited macro-expanded math verbatim in list items' {
        $md | Should -BeLike '*- $y_{i+1} \gets \mathbf{A} x_i^2$*'
    }
    It 'bolds scaffold keywords and nests by depth (2-space bullet indent)' {
        $md | Should -BeLike '*- **if** $d(v) \ge \tau$ **then***'
        $md | Should -Match '(?m)^  - \*\*return\*\* \$x_i\$$'
        $md | Should -Match '(?m)^- \*\*end if\*\*$'
    }
    It 'comment content keeps its math, italicized after the ▷ marker' {
        $md | Should -BeLike ('*' + [char]0x25B7 + ' [*]uses $\mathcal{N}(v)$[*]*')
    }
    It 'algorithmic[1] (source asked for line numbers) emits an ORDERED list' {
        $md | Should -BeLike '*1. **while** $k < n$ **do***'
        $md | Should -Match '(?m)^   1\. \$k \\gets k \+ 1\$$'
    }
    It 'algorithm math tokenizes IDENTICALLY to body math (macro-expanded, delimited)' {
        ([regex]::Matches($md, [regex]::Escape('\mathbf{A} x_i^2'))).Count | Should -BeGreaterOrEqual 2
    }
}

Describe 'algorithm floats — non-algorithmic content is preserved, not discarded' {
    It 'keeps enumerate-style pseudocode from inside the float' {
        $md | Should -BeLike '*[*]*Algorithm 2: List-style pseudocode[*]*'
        $md | Should -BeLike '*initialize $S \gets \emptyset$*'
        $md | Should -BeLike '*grow $S$ greedily*'
    }
}

Describe 'verbatim-family -> tagged fences, byte-verbatim (fence-only-if-monospace)' {
    It 'lstlisting maps language= to the fence tag and keeps $ and % intact' {
        $md | Should -Match '(?s)```powershell\s*\n\$env:PATH -split '';'' \| Where-Object \{ \$_ -match ''%APPDATA%'' \}\s*\n```'
    }
    It 'bare verbatim becomes a text fence with content untouched by comment-strip and math-protect' {
        $md | Should -Match '(?s)```text\s*\nraw \$dollars\$ and % percent survive\s*\n```'
    }
}

Describe 'figures — carried out of the tarball, links live; TikZ markers numbered' {
    It 'numbers TikZ diagram markers so a weaving step can target them' {
        $t = '\begin{document}A \begin{tikzpicture}\draw (0,0);\end{tikzpicture} B \begin{tikzcd}X\end{tikzcd} C\end{document}'
        $m = ConvertFrom-Latex $t ''
        $m | Should -Match ([regex]::Escape(('*[diagram 1 ' + [char]0x2014 + ' TikZ source, not rendered]*')))
        $m | Should -Match ([regex]::Escape(('*[diagram 2 ' + [char]0x2014 + ' TikZ source, not rendered]*')))
    }
    Context 'Copy-LatexFigures (unit, fake workdir)' {
        BeforeEach {
            $script:work = Join-Path ([System.IO.Path]::GetTempPath()) ("figtest-" + [guid]::NewGuid().ToString('N'))
            $script:out  = Join-Path $script:work '_out'
            New-Item -ItemType Directory -Force -Path (Join-Path $script:work 'figs'), $script:out | Out-Null
            [System.IO.File]::WriteAllBytes((Join-Path $script:work 'figs/arch.png'), [byte[]](137, 80, 78, 71))
            [System.IO.File]::WriteAllBytes((Join-Path $script:work 'figs/arch.pdf'), [byte[]](37, 80, 68, 70))
            [System.IO.File]::WriteAllBytes((Join-Path $script:work 'figs/flow.pdf'), [byte[]](37, 80, 68, 70))
        }
        AfterEach { Remove-Item -LiteralPath $script:work -Recurse -Force -ErrorAction SilentlyContinue }
        It 'resolves an extensionless target, prefers the raster twin, copies it, rewrites the link' {
            $r = Copy-LatexFigures -Markdown 'see ![](figs/arch) here' -WorkDir $script:work -OutDir $script:out -Slug 'p1'
            $r.copied | Should -Be 1
            $r.markdown | Should -Match ([regex]::Escape('![](p1/arch.png)'))
            Test-Path (Join-Path $script:out 'p1/arch.png') | Should -BeTrue
        }
        It 'a vector-only figure becomes a plain (clickable) link, not a broken image tag' {
            $r = Copy-LatexFigures -Markdown '![](figs/flow.pdf)' -WorkDir $script:work -OutDir $script:out -Slug 'p1'
            $r.markdown | Should -Match ([regex]::Escape('[figure (pdf): flow.pdf](p1/flow.pdf)'))
            $r.markdown | Should -Not -Match ([regex]::Escape('![](p1/flow.pdf)'))
        }
        It 'a missing target degrades to an addressable marker and is counted' {
            $r = Copy-LatexFigures -Markdown '![](figs/nope)' -WorkDir $script:work -OutDir $script:out -Slug 'p1'
            $r.missing | Should -Be 1
            $r.markdown | Should -Match ([regex]::Escape(('*[figure: nope ' + [char]0x2014 + ' source file not found]*')))
        }
        It 'web URLs pass through untouched' {
            $r = Copy-LatexFigures -Markdown '![](https://x.test/a.png)' -WorkDir $script:work -OutDir $script:out -Slug 'p1'
            $r.markdown | Should -Be '![](https://x.test/a.png)'
            $r.copied | Should -Be 0
        }
    }
    It 'end-to-end: figures survive the tarball workdir cleanup' -Skip:(-not (Get-Command tar -CommandType Application -ErrorAction SilentlyContinue)) {
        $root = Join-Path ([System.IO.Path]::GetTempPath()) ("e2e-" + [guid]::NewGuid().ToString('N'))
        $src = Join-Path $root 'src'; $out = Join-Path $root 'out'
        New-Item -ItemType Directory -Force -Path (Join-Path $src 'figs'), $out | Out-Null
        [System.IO.File]::WriteAllBytes((Join-Path $src 'figs/arch.png'), [byte[]](137, 80, 78, 71))
        [System.IO.File]::WriteAllText((Join-Path $src 'main.tex'), '\documentclass{article}\begin{document}Fig: \includegraphics{figs/arch}\end{document}', [System.Text.UTF8Encoding]::new($false))
        Push-Location $src; tar -czf (Join-Path $root 'p.tar.gz') .; Pop-Location
        $r = Invoke-ArxivLatexToMarkdown -TarGz (Join-Path $root 'p.tar.gz') -Slug 'p.latex' -OutDir $out
        $r.figures | Should -Be 1
        (Get-Content (Join-Path $out 'p.latex.md') -Raw) | Should -Match ([regex]::Escape('![](p.latex/arch.png)'))
        Test-Path (Join-Path $out 'p.latex/arch.png') | Should -BeTrue
        # the unpacked tex is a PERSISTED run artifact beside the tarball ({dir}/.runs/{stamp}/tex),
        # not a deleted temp dir — downstream consumers (math bank, skeleton) re-read it
        $r.tex | Should -BeLike (Join-Path $root '.runs' '*' 'tex')
        Test-Path (Join-Path $r.tex 'main.tex') | Should -BeTrue
        Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Describe 'TikZ — source-authoritative diagram rendering' {
    It 'stashes each env with number + kind, and captures preamble hints (externalization filtered)' {
        $t = '\usetikzlibrary{calc,external}\usetikzlibrary{cd,calc}\usepackage{tikz-cd}\begin{document}\begin{tikzpicture}\draw (0,0);\end{tikzpicture}\begin{tikzcd}A\end{tikzcd}\end{document}'
        $null = ConvertFrom-Latex $t ''
        $script:TikzStore.Count | Should -Be 2
        $script:TikzStore[1].env | Should -Be 'tikzcd'
        $script:TikzLibs | Should -Be 'calc,cd'          # deduped; 'external' (shell-escape caching) dropped
        $script:TikzPkgs.ContainsKey('tikz-cd') | Should -BeTrue
    }
    It 'renders a tikzpicture and a tikzcd to real SVGs' -Skip:(-not (Test-Path "$PSScriptRoot/../tools/tikz-render/node_modules/node-tikzjax")) {
        $out = Join-Path ([System.IO.Path]::GetTempPath()) ("tikz-" + [guid]::NewGuid().ToString('N'))
        $rep = Invoke-TikzRender -OutDir $out -Jobs @(
            @{ id = 'a'; source = '\begin{tikzpicture}\draw[->] (0,0) -- (1,1) node[right] {$x_i$};\end{tikzpicture}' }
            @{ id = 'b'; source = '\begin{tikzcd}A \arrow[r] & B\end{tikzcd}'; texPackages = @{ 'tikz-cd' = '' } })
        $rep.ok | Should -Be 2
        (Get-Content (Join-Path $out 'a.svg') -Raw) | Should -BeLike '<svg*'
        Remove-Item -LiteralPath $out -Recurse -Force -ErrorAction SilentlyContinue
    }
    It 'a diagram that fails to compile is a per-job result, never a batch failure' -Skip:(-not (Test-Path "$PSScriptRoot/../tools/tikz-render/node_modules/node-tikzjax")) {
        $out = Join-Path ([System.IO.Path]::GetTempPath()) ("tikz-" + [guid]::NewGuid().ToString('N'))
        $rep = Invoke-TikzRender -OutDir $out -Jobs @(
            @{ id = 'bad'; source = '\begin{tikzpicture}\undefinedcmd\end{tikzpicture}' }
            @{ id = 'good'; source = '\begin{tikzpicture}\draw (0,0) -- (1,0);\end{tikzpicture}' })
        $rep.ok | Should -Be 1
        @($rep.results | Where-Object id -eq 'bad')[0].ok | Should -BeFalse
        Test-Path (Join-Path $out 'good.svg') | Should -BeTrue
        Remove-Item -LiteralPath $out -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Describe 'pipeline hygiene' {
    It 'no placeholder leaks' {
        $md | Should -Not -Match '@@LMATH\d+@@'
        $md | Should -Not -Match '@@ALG\d+@@'
        $md | Should -Not -Match '@@VERB\d+@@'
    }
    It 'body math (inline + display) is unaffected' {
        $md | Should -BeLike '*$y_{i+1} = \mathbf{A} x_i^2$*'
        $md | Should -Match '(?s)\$\$\s*\nd\(v\) \\ge \\tau\s*\n\$\$'
    }
}
