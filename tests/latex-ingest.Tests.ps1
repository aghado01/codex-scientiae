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
