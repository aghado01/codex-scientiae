#requires -Version 7.0
# The LaTeX oracle converter spec (src/latex-ingest/latex-ingest.ps1) — the ground truth the pdf-converter lane is
# measured against, so a silent break here corrupts the benchmark. Coverage, in order:
#   - tokenization consistency + fence-only-if-monospace (algorithmic->nested list, verbatim->fence);
#   - figures: carry-out, PNG-terminal register (raster passthrough w/ alt text, un-rasterizable->marker);
#   - diagrams: unified DiagramStore, markers by kind;
#   - ENCODE-FIRST transpilers (xy-pic + tikzcd -> inline arrows / \begin{array}; bail = never guessed);
#   - MATH REGISTER: nesting-aware protection, positional \ensuremath/\raisebox, (?m) comment strip;
#   - MACROS: ordinal \Vect/\vect, glue guards, \let / \DeclarePairedDelimiter / \newcommand* / internals;
#   - custom counters (Case A/B + \ref resolution); KaTeX aliases (\mathds/\Bar);
#   - emission hygiene (body-position decls, amsart front-matter, quotes, table furniture);
#   - frontmatter/theorem-numbering/accents/biblatex (faithful-transcription hardening);
# External-process, run-addressing, and engine-backed audit contracts live in
# latex-ingest-integration.Tests.ps1 so this container remains the pure/converter seam.

BeforeAll {
    . "$PSScriptRoot/../../src/latex-ingest/latex-ingest.ps1"

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
        $md | Should -BeLike '*- **if** $d(v) \geq \tau$ **then***'
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

Describe 'figures — carried out of the tarball, links live; diagram markers numbered by kind' {
    It 'numbers diagram markers by KIND so a weaving/render step can target them' {
        # tikzpicture + a NON-encodable tikzcd (single cell, no arrows) both fall to the flagged marker
        $t = '\begin{document}A \begin{tikzpicture}\draw (0,0);\end{tikzpicture} B \begin{tikzcd}X\end{tikzcd} C\end{document}'
        $m = ConvertFrom-Latex $t ''
        $m | Should -Match ([regex]::Escape(('*[diagram 1 ' + [char]0x2014 + ' tikzpicture, not rendered]*')))
        $m | Should -Match ([regex]::Escape(('*[diagram 2 ' + [char]0x2014 + ' tikzcd, not rendered]*')))
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
        It 'resolves an extensionless target, prefers the raster twin, copies it, rewrites the link with alt text' {
            $r = Copy-LatexFigures -Markdown 'see ![](figs/arch) here' -WorkDir $script:work -OutDir $script:out -Slug 'p1'
            $r.copied | Should -Be 1
            $r.png | Should -Be 1                                                # PNG is the terminal register
            $r.markdown | Should -Match ([regex]::Escape('![figure: arch](p1/arch.png)'))   # alt text = leaf name (MD045)
            Test-Path (Join-Path $script:out 'p1/arch.png') | Should -BeTrue
        }
        It 'an un-rasterizable PDF (here a 4-byte fake) becomes a FLAGGED marker, never a broken image tag' {
            # PNG is terminal: a real PDF -> PNG via MuPDF (covered end-to-end); a PDF that cannot rasterize
            # flags rather than emitting ![](x.pdf) (renders broken) or a silent plain link.
            $r = Copy-LatexFigures -Markdown '![](figs/flow.pdf)' -WorkDir $script:work -OutDir $script:out -Slug 'p1'
            $r.markdown | Should -Match ([regex]::Escape('*[figure (pdf): flow.pdf'))
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
}

Describe 'TikZ — source-authoritative diagram capture' {
    It 'stashes each non-encodable env into the UNIFIED DiagramStore with number + kind, captures preamble hints' {
        # single-cell tikzcd (no arrows) is not encodable -> falls to the store alongside the tikzpicture
        $t = '\usetikzlibrary{calc,external}\usetikzlibrary{cd,calc}\usepackage{tikz-cd}\begin{document}\begin{tikzpicture}\draw (0,0);\end{tikzpicture}\begin{tikzcd}A\end{tikzcd}\end{document}'
        $null = ConvertFrom-Latex $t ''
        $script:DiagramStore.Count | Should -Be 2
        $script:DiagramStore[0].kind | Should -Be 'tikzpicture'
        $script:DiagramStore[1].kind | Should -Be 'tikzcd'
        $script:TikzLibs | Should -Be 'calc,cd'          # deduped; 'external' (shell-escape caching) dropped
        $script:TikzPkgs.ContainsKey('tikz-cd') | Should -BeTrue
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
        $md | Should -Match '(?s)\$\$\s*\nd\(v\) \\geq \\tau\s*\n\$\$'   # \ge alias-canonicalized to \geq (register §4.3)
    }
}

Describe 'title extraction — optional [..] arg before the braced title (\title[short]{long})' {
    It 'Get-LatexCommandArg skips the optional bracket and returns the braced title' {
        Get-LatexCommandArg '\title[Short Running Head]{The Full Descriptive Title}' '\title' | Should -Be 'The Full Descriptive Title'
    }
    It 'still returns the title when there is no optional bracket' {
        Get-LatexCommandArg '\title{Just A Title}' '\title' | Should -Be 'Just A Title'
    }
    It 'ConvertFrom-Latex lifts an optional-arg title into the H1 (not "# (untitled)")' {
        $t = '\documentclass{article}\title[Short]{Enhancing Cluster Analysis}\begin{document}Body text.\end{document}'
        $out = ConvertFrom-Latex $t ''
        $out | Should -Match '(?m)^# Enhancing Cluster Analysis$'
        $out | Should -Not -Match ([regex]::Escape('# (untitled)'))
    }
}

Describe 'frontmatter — sn-jnl author metadata stripped, abstract + keywords kept' {
    BeforeAll {
        $tex = @'
\documentclass{article}
\begin{document}
\title[Short RH]{Full Title Here}
\author*[1]{\fnm{Ada} \sur{Lovelace}}\email{ada@x.test}
\author[2]{\fnm{Alan} \sur{Turing}}\email{alan@y.test}
\equalcont{These authors contributed equally.}
\affil[1]{\orgdiv{Dept}, \orgname{Uni}, \orgaddress{\city{Munich}, \country{Germany}}}
\abstract{We show a $\lambda$-calculus result of note.}
\keywords{Alpha, Beta, Gamma}
\maketitle
\section{Introduction}
Body text with no macros.
\end{document}
'@
        $script:fm = ConvertFrom-Latex $tex ''
    }
    It 'keeps the title as the H1' { $fm | Should -Match '(?m)^# Full Title Here$' }
    It 'keeps the abstract (with its inline math) as a section' {
        $fm | Should -Match '(?m)^## Abstract$'
        $fm | Should -Match ([regex]::Escape('$\lambda$-calculus'))
    }
    It 'emits keywords as a bold lead line' { $fm | Should -Match ([regex]::Escape('**Keywords:** Alpha, Beta, Gamma')) }
    It 'strips every author/affiliation metadata macro (no raw LaTeX leaks)' {
        foreach ($leak in '\title', '\author', '\affil', '\email', '\equalcont', '\fnm', '\sur', '\orgdiv') {
            $fm | Should -Not -Match ([regex]::Escape($leak))
        }
    }
}

Describe 'faithful-transcription hardening — hard-wrap reflow, toggle/box de-leaking, title hygiene, biblatex refs' {
    It 'reflows source hard-wraps into one flowing paragraph (STANDARDS §4)' {
        $tex = @'
\documentclass{article}
\title{T}
\begin{document}
This sentence is
wrapped across
three source lines.

A second paragraph stays separate.
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $out | Should -Match ([regex]::Escape('This sentence is wrapped across three source lines.'))
        $out | Should -Match ([regex]::Escape('A second paragraph stays separate.'))   # blank-line paragraph break preserved
    }
    It 'converts old-style {\em ..}/{\bf ..} switch toggles (not just \emph{..})' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}We call this {\em unfolding} and {\bf that}.\end{document}' ''
        $out | Should -Match ([regex]::Escape('*unfolding*'))
        $out | Should -Match ([regex]::Escape('**that**'))
        $out | Should -Not -Match ([regex]::Escape('{\em'))
    }
    It 'unwraps \fbox{\parbox{width}{..}} to its content (no frame/box leak)' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}\fbox{\parbox{\textwidth}{Framed content here.}}\end{document}' ''
        $out | Should -Match ([regex]::Escape('Framed content here.'))
        $out | Should -Not -Match ([regex]::Escape('\fbox'))
        $out | Should -Not -Match ([regex]::Escape('\parbox'))
    }
    It 'strips \thanks{..} from the H1 title' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{Real Title\thanks{Funded by grant 123.}}\begin{document}Body.\end{document}' ''
        $out | Should -Match '(?m)^# Real Title$'
        $out | Should -Not -Match ([regex]::Escape('Funded by grant'))
    }
    It 'recovers a manually-typeset \Large{..} title (command-first idiom)' {
        $out = ConvertFrom-Latex '\documentclass{article}\begin{document}\Large{ONE DIAMOND TO RULE THEM ALL\\}\normalsize Body text.\end{document}' ''
        $out | Should -Match '(?m)^# ONE DIAMOND TO RULE THEM ALL$'
        $out | Should -Not -Match ([regex]::Escape('# (untitled)'))
    }
    It 'bridges a biblatex/biber .bbl (\entry{}) into synthetic \bibitem references' {
        $bbl = @'
\entry{smith2020}{article}{}
  \name{author}{1}{}{%
    {{hash=x}{family={Smith},given={Jane}}}%
  }
  \field{title}{A Fine Result}
  \field{journaltitle}{J. Testing}
  \field{year}{2020}
\endentry
'@
        $syn = ConvertFrom-BiblatexBbl $bbl
        $syn | Should -Match ([regex]::Escape('\bibitem{smith2020}'))
        $syn | Should -Match ([regex]::Escape('Smith, Jane'))
        $syn | Should -Match ([regex]::Escape('A Fine Result'))
    }
    It 'numbers theorem-like envs per the \newtheorem counter model ([section] + shared + own counters) and resolves their \ref' {
        $tex = @'
\documentclass{article}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{definition}[theorem]{Definition}
\newtheorem{lemma}{Lemma}
\begin{document}
\section{First}\label{sec:one}
\begin{definition}\label{def:a} A widget. \end{definition}
\begin{theorem} Widgets exist. \label{thm:b}\end{theorem}
\begin{lemma}\label{lem:c} A helper. \end{lemma}
\section{Second}
By \cref{thm:b} and \cref{def:a} in \cref{sec:one}, plus \cref{lem:c}.
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $out | Should -Match ([regex]::Escape('**Definition 1.1.**'))   # shares theorem counter, within section
        $out | Should -Match ([regex]::Escape('**Theorem 1.2.**'))      # same shared/within counter, next
        $out | Should -Match ([regex]::Escape('**Lemma 1.**'))          # own counter, flat (no [section])
        # \cref carries the TARGET's type name — the sentence the paper actually reads. A bare "By 1.2 and
        # 1.1 in 1" was an assembly failure: cleveref generates the type at typeset time and it is content,
        # not furniture. Label AFTER the theorem statement (thm:b) still resolves.
        $out | Should -Match ([regex]::Escape('By theorem 1.2 and definition 1.1 in section 1, plus lemma 1.'))
        $out | Should -Not -Match '\?'
    }
    It 'ref-family contracts: \cref/\Cref type names, \ref/\labelcref bare, plural + conjunction, mixed types' {
        $tex = @'
\documentclass{article}
\usepackage{cleveref}
\newtheorem{theorem}{Theorem}
\newtheorem{corollary}{Corollary}
\begin{document}
\section{Alpha}\label{sec:a}
\begin{theorem}\label{thm:one} One. \end{theorem}
\begin{theorem}\label{thm:two} Two. \end{theorem}
\begin{corollary}\label{cor:one} Three. \end{corollary}
\begin{corollary}\label{cor:two} Four. \end{corollary}
lower \cref{thm:one} upper \Cref{thm:one} bare \ref{thm:one} explicit \labelcref{thm:one}
list \cref{thm:one,thm:two} plural \cref{cor:one,cor:two} mixed \cref{thm:one,sec:a}
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $out | Should -Match ([regex]::Escape('lower theorem 1'))          # \cref  -> lowercase type
        $out | Should -Match ([regex]::Escape('upper Theorem 1'))          # \Cref  -> capitalized
        $out | Should -Match ([regex]::Escape('bare 1'))                   # \ref   -> number only
        $out | Should -Match ([regex]::Escape('explicit 1'))               # \labelcref -> cleveref's DELIBERATE bare form
        $out | Should -Match ([regex]::Escape('list theorems 1 and 2'))    # same type collapses to one plural word
        $out | Should -Match ([regex]::Escape('plural corollaries 1 and 2'))  # y -> ies
        $out | Should -Match ([regex]::Escape('mixed theorem 1 and section 1'))# mixed types stay per-target
        $out | Should -Not -Match '\?'
    }
    It 'ref semantics probe: reports cleveref relevance so untyped sources are left alone' {
        $plain = "\documentclass{article}`n\begin{document}`nSee \ref{x} and \eqref{y}.`n\end{document}"
        $sem = Get-RefSemantics $plain
        $sem.cleveref_loaded | Should -BeFalse
        $sem.typed_sites | Should -Be 0
        $sem.relevant | Should -BeFalse                                    # nothing to type -> stage must not invent names
        $clever = "\documentclass{article}`n\usepackage{cleveref}`n\begin{document}`nSee \cref{x}.`n\end{document}"
        $sem2 = Get-RefSemantics $clever
        $sem2.cleveref_loaded | Should -BeTrue
        $sem2.relevant | Should -BeTrue
    }
    It 'resolves text-mode accents + ligatures in body PROSE (M\''{e}moli -> Mémoli)' {
        $tex = @'
\documentclass{article}
\title{T}
\begin{document}
Work by M\'{e}moli and M\"{o}bius; also G\"odel and stra\ss e.
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $out | Should -Match 'Mémoli'
        $out | Should -Match 'Möbius'
        $out | Should -Match 'Gödel'
        $out | Should -Match 'straße'
    }
    It 'cleans reference accents, ligatures, bibtex protective braces, and math \mbox' {
        $bbl = @'
\bibitem{x} Gor{\^o} Azumaya and H{\aa}vard {K}rull-{R}emak. $\ell^{\mbox{p}}$ spaces. 2020.
'@
        $refs = Get-LatexReferences $bbl @{ x = 1 }
        $refs | Should -Match 'Gorô'
        $refs | Should -Match 'Håvard'
        $refs | Should -Match 'Krull-Remak'
        $refs | Should -Match ([regex]::Escape('\text{p}'))
        $refs | Should -Not -Match ([regex]::Escape('\mbox'))
        $refs | Should -Not -Match ([regex]::Escape('{K}'))
    }
}

# =====================================================================================================
# ENCODE-FIRST doctrine (issues/archive/latex-math-oracle/latex-images.md): a diagram that CAN be semantic KaTeX math MUST
# be — image is the last resort. Deterministic rungs transpile provably-linear/orthogonal xy-pic + tikzcd;
# anything else BAILS to the diagram store (never a guessed encoding). These are the oracle's math spec.
# =====================================================================================================
Describe 'encode-first — xy-pic transpiler (Convert-XyDiagramSpan)' {
    It '1-D chain -> inline arrows, labels kept, stays REAL MATH (no diagram marker)' {
        Convert-XyDiagramSpan 'R = \xymatrix{ \bullet \ar[r] & \bullet \ar[r] & \bullet }' |
            Should -Be 'R = \bullet \longrightarrow \bullet \longrightarrow \bullet'
        Convert-XyDiagramSpan '\xymatrix{ 0 \ar[r]^f & K }' | Should -Be '0 \xrightarrow{f} K'
        # a gap double-booked by arrows from both sides is NOT a clean chain -> bail
        Convert-XyDiagramSpan '\xymatrix{ A \ar[r] & B \ar[l] }' | Should -BeNullOrEmpty
    }
    It '2-D orthogonal grid -> \begin{array}; vertical labels as SUPERSCRIPT (over) / subscript (under)' {
        $g = Convert-XyDiagramSpan '\xymatrix{A \ar[r]^f \ar[d]_g & B \ar[d]^h \\ C \ar[r]_k & D}'
        $g | Should -Match ([regex]::Escape('\begin{array}{ccc}'))
        $g | Should -Match ([regex]::Escape('A & \xrightarrow{f} & B'))
        $g | Should -Match ([regex]::Escape('\downarrow_{g}'))
        $g | Should -Match ([regex]::Escape('\downarrow^{h}'))
    }
    It 'BAILS ($null) on loops, diagonals — never a guessed encoding' {
        Convert-XyDiagramSpan '\xymatrix{\bullet \ar@(ur,ul)}' | Should -BeNullOrEmpty      # self-loop
        Convert-XyDiagramSpan '\xymatrix{A \ar[rd] & B}' | Should -BeNullOrEmpty            # diagonal
    }
    It 'in the full pipeline: an encodable inline xymatrix leaves NO diagram marker' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}The quiver $Q = \xymatrix{\bullet \ar[r] & \bullet}$ shown.\end{document}' ''
        $out | Should -Match ([regex]::Escape('$Q = \bullet \longrightarrow \bullet$'))
        $out | Should -Not -Match 'not rendered'
    }
}
Describe 'encode-first — tikzcd transpiler (Convert-TikzcdDiagram)' {
    It '1-D chain with quoted labels + maps-to style -> \xmapsto' {
        Convert-TikzcdDiagram '\begin{tikzcd} A \arrow[r, "f", maps to] & B \end{tikzcd}' |
            Should -Be 'A \xmapsto{f} B'
    }
    It 'accepts ONLY styles with exact KaTeX forms (hook/two heads/dashed); a swap places the label under' {
        Convert-TikzcdDiagram '\begin{tikzcd} A \arrow[r, hook] & B \end{tikzcd}' | Should -Be 'A \hookrightarrow B'
        Convert-TikzcdDiagram '\begin{tikzcd} A \arrow[r, "f" swap] & B \end{tikzcd}' | Should -Be 'A \xrightarrow[{f}]{} B'
    }
    It 'BAILS on diagonals, bends, Rightarrow, ampersand-replacement' {
        Convert-TikzcdDiagram '\begin{tikzcd} A \arrow[r, bend left] & B \end{tikzcd}' | Should -BeNullOrEmpty
        Convert-TikzcdDiagram '\begin{tikzcd} A \arrow[r, Rightarrow] & B \end{tikzcd}' | Should -BeNullOrEmpty
    }
    It '2-D square with vertical labels -> array (the real 2210/mapper form)' {
        $g = Convert-TikzcdDiagram '\begin{tikzcd} V_3 \arrow[r, "g"] & V_4 \\ V_1 \arrow[r, "f"] \arrow[u, "a"] & V_2 \arrow[u, "b"] \end{tikzcd}'
        $g | Should -Match ([regex]::Escape('\begin{array}{ccc}'))
        $g | Should -Match ([regex]::Escape('\uparrow^{a}'))
    }
}

# =====================================================================================================
# MATH REGISTER — nesting-aware protection, positional wrappers, and the (?m) comment strip. The register
# discipline is the whole point of the oracle: math always tokenizes as math; prose never leaks into it.
# =====================================================================================================
Describe 'math register — nesting, positional wrappers, comment strip' {
    It 'text-bridged inner math in an INLINE span survives; inner $x$ normalizes to \(x\)' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}Let $f = \text{if $x>0$ then}$ hold.\end{document}' ''
        $out | Should -Match ([regex]::Escape('$f = \text{if \(x>0\) then}$'))
    }
    It '\ensuremath is POSITIONAL: unwrapped-keeping-group in math, PROMOTED to a span in prose' {
        # math position: {ab}^c group kept
        $inmath = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}Value $f(\ensuremath{ab}^c)$ here.\end{document}' ''
        $inmath | Should -Match ([regex]::Escape('$f({ab}^c)$'))
        # prose position: promoted to $..$ (never bare ASCII)
        $prose = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}The \ensuremath{\varepsilon}-net.\end{document}' ''
        $prose | Should -Match ([regex]::Escape('$\varepsilon$-net'))
    }
    It 'a text-mode box in math collapses its math payload back to the register (no stranded \( )' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}Op $\raisebox{2pt}{\(\nabla\)}_i$ acts.\end{document}' ''
        $out | Should -Not -Match ([regex]::Escape('\raisebox'))
        $out | Should -Not -Match ([regex]::Escape('\('))       # no text-mode delimiter stranded in math
        $out | Should -Match ([regex]::Escape('\nabla'))
    }
    It 'a mid-document TRAILING COMMENT (even one containing $$) is stripped, not swallowing prose' {
        # the mapper bug: without (?m) the commented $$ mispaired display math and ate the next paragraph
        $tex = @'
\documentclass{article}
\title{T}
\begin{document}
$$e_{ij}=1$$ % note: \text{and} $$ was here
The scheme has entry $A_{ij}$ following a distribution.
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $out | Should -Match ([regex]::Escape('The scheme has entry $A_{ij}$ following a distribution.'))
        $out | Should -Not -Match ([regex]::Escape('note:'))    # comment gone
        $out | Should -Not -Match '\\\('                        # prose NOT captured into a math span
    }
    It 'adjacent inline spans emit `$a$ $b$`, never an ambiguous mid-line $$' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}Both $a$ and $b$ here.\end{document}' ''
        # a real display fence is alone on its line; a mid-line $$ would be a scanner ambiguity
        ($out -split "`n" | Where-Object { $_ -match '\S\$\$\S' }).Count | Should -Be 0
    }
}

# =====================================================================================================
# MACRO EXPANSION + ENRICHMENT — ordinal maps, glue guards, \let / paired-delims / starred defs, KaTeX
# aliases. These are where a silent break corrupts the math ground truth most quietly.
# =====================================================================================================
Describe 'macros — ordinal collisions, glue guards, enrichment forms' {
    It 'expands BOTH \Vect and \vect (case-sensitive; ordinal map, not a PS hashtable collision)' {
        $out = ConvertFrom-Latex '\documentclass{article}\newcommand{\Vect}{\mathbf{Vect}}\newcommand{\vect}{\mathbf{vec}}\title{T}\begin{document}$F:\Vect\to\vect$ done.\end{document}' ''
        $out | Should -Match ([regex]::Escape('\mathbf{Vect}'))
        $out | Should -Match ([regex]::Escape('\mathbf{vec}'))
        $out | Should -Not -Match ([regex]::Escape('\Vect'))
        $out | Should -Not -Match ([regex]::Escape('\vect'))
    }
    It 'GLUE GUARD: expansion never fuses a control word with an adjacent letter into a new command' {
        # \in followed by \chn->c must NOT become \inc (an undefined command born in the expander)
        $m = [ordered]@{}; $m['chn'] = [pscustomobject]@{ nargs = 0; opt = $null; body = 'c' }
        Expand-LatexMacros '\sigma\in\chn_{i}' $m | Should -Be '\sigma\in c_{i}'
    }
    It 'parses \let aliases (chain-resolved) and \DeclarePairedDelimiter' {
        $mac = Get-LatexMacros '\let\union\cup \let\intsec\intersect \let\intersect\cap \DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}'
        Expand-LatexMacros 'A\intsec B\union C' $mac | Should -Be 'A\cap B\cup C'
        Expand-LatexMacros '\ceil{x}' $mac | Should -Match ([regex]::Escape('\lceil x \rceil'))
    }
    It 'parses the starred \newcommand* form' {
        (Get-LatexMacros '\newcommand*{\R}{\mathbb{R}}').Contains('R') | Should -BeTrue
    }
    It 'SKIPS engine/drawing-internals bodies (pgf/@) so the NAME surfaces addressably, not soup' {
        (Get-LatexMacros '\newcommand{\pg}{\pgfpicture\pgfpathrectangle\endpgfpicture}').Contains('pg') | Should -BeFalse
    }
    It 'KaTeX aliases: \mathds->\mathbb, \Bar->\bar' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}$\mathds{1}$ and $\Bar{R}$.\end{document}' ''
        $out | Should -Match ([regex]::Escape('\mathbb{1}'))
        $out | Should -Match ([regex]::Escape('\bar{R}'))
        $out | Should -Not -Match ([regex]::Escape('\mathds'))
    }
}

# =====================================================================================================
# CUSTOM COUNTERS — \newcounter/\refstepcounter/\Alph + enumerate \item, resolved so lettered proof
# cases render (Case A/B/C) and \ref to them resolves instead of leaking "?".
# =====================================================================================================
Describe 'custom counters — Resolve-CustomCounters' {
    It 'Format-Counter is case-sensitive (Alph != alph): no "A a" double-emit' {
        Format-Counter 1 'Alph' | Should -Be 'A'
        Format-Counter 2 'alph' | Should -Be 'b'
        Format-Counter 4 'Roman' | Should -Be 'IV'
    }
    It 'resolves \Alph{c} to its letter and a \label bound to \refstepcounter to that value' {
        $tex = @'
\documentclass{article}\title{T}
\newcounter{dc}\renewcommand{\thedc}{\Alph{dc}}
\begin{document}
\refstepcounter{dc}Case \Alph{dc}\label{c:a} is first.
\refstepcounter{dc}Case \Alph{dc}\label{c:b} is second.
Then \ref{c:a} and \ref{c:b} hold.
\end{document}
'@
        $out = ConvertFrom-Latex $tex ''
        $out | Should -Match ([regex]::Escape('Case A'))
        $out | Should -Match ([regex]::Escape('Case B'))
        $out | Should -Match ([regex]::Escape('Then A and B hold.'))
        $out | Should -Not -Match ([regex]::Escape('\Alph'))
    }
}

# =====================================================================================================
# EMISSION HYGIENE (Tier-1) — body-position declarations, amsart front-matter, quotes, table furniture.
# Invisible to the math-render extractor (not math spans) — the class the eyeball audit surfaced.
# =====================================================================================================
Describe 'emission hygiene — declarations, front-matter, quotes, tables' {
    It 'strips body-position \newcommand declarations (which else self-mangle under expansion)' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}Text. \newcommand{\lefti}{\vartriangleleft} More $\lefti$ text.\end{document}' ''
        $out | Should -Not -Match ([regex]::Escape('\newcommand'))
        $out | Should -Match ([regex]::Escape('\vartriangleleft'))   # the macro still expands at use sites
    }
    It 'strips amsart front-matter (\address / \makeatletter blocks)' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}\address{Dept, Uni}\makeatletter\@namedef{x}{y}\makeatother Body.\end{document}' ''
        $out | Should -Not -Match ([regex]::Escape('\address'))
        $out | Should -Not -Match ([regex]::Escape('\makeatletter'))
        $out | Should -Match 'Body.'
    }
    It 'converts a LaTeX single-quote `word'' without leaking a backtick code span' {
        $out = ConvertFrom-Latex "\documentclass{article}\title{T}\begin{document}We call it ``a `switch' operation.\end{document}" ''
        $out | Should -Not -Match '`switch'
    }
    It 'tables: strips \cmidrule and the \\[Nex] row-spacing that used to break rows open' {
        $out = ConvertFrom-Latex '\documentclass{article}\title{T}\begin{document}\begin{tabular}{ll}\cmidrule{1-2} a & b \\[0.5ex] c & d \end{tabular}\end{document}' ''
        $out | Should -Not -Match ([regex]::Escape('\cmidrule'))
        $out | Should -Not -Match ([regex]::Escape('[0.5ex]'))
    }
}
