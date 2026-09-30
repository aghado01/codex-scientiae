% Adapted from the Google DeepMind open-access paper template.
% Licensed under CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/).
% Modified for this manuscript: unused options and internal template content removed.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{googlecloud} %

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions
\LoadClass{extarticle}

\AtEndOfClass{\RequirePackage[tracking=smallcaps]{microtype}}
\RequirePackage[utf8]{inputenc}
\RequirePackage[english]{babel}
\RequirePackage{amsthm, amsmath, amsfonts, amssymb}
\RequirePackage{cmap}
\RequirePackage[T1]{fontenc}
\RequirePackage{url}
\RequirePackage[colorlinks=true, allcolors=blue]{hyperref}
\RequirePackage{pifont}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{textcomp} %
\RequirePackage[overload]{textcase}
\RequirePackage{graphicx}
\RequirePackage{colortbl}
\RequirePackage{booktabs}
\RequirePackage{changepage}
\RequirePackage{enumitem} %
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}  %
\RequirePackage{lastpage}  %
\RequirePackage{enumitem}
\setlist[itemize]{noitemsep}
\setlist[enumerate]{noitemsep}
\RequirePackage[explicit]{titlesec}
\RequirePackage{mdframed}
\RequirePackage{caption}
\RequirePackage{needspace}

\RequirePackage{XCharter}
\RequirePackage[xcharter,bigdelims,vvarbb]{newtxmath}

\RequirePackage[scaled=1.1]{zlmtt}

\RequirePackage[left=2.2cm,%
right=2.2cm,%
top=3cm,%
bottom=3cm,%
headheight=40pt,%
headsep=20pt,%
a4paper]{geometry}%
\setlength{\columnsep}{15pt} %
\setlength{\parskip}{0.5\baselineskip}

\newcommand{\titlefont}{\color{black}\normalfont\bfseries\fontsize{21}{23}\selectfont}

\newcommand{\absfont}{\bfseries\linespread{1.2}\fontsize{10}{12}\selectfont}


\newcommand{\footerfont}{\color{black}\normalfont\fontsize{8}{10}\selectfont}

\newcommand{\headingfont}{\color{black}\bfseries\fontsize{13}{14}\selectfont}

\newtoks\correspondingauthor


\setcounter{secnumdepth}{3}

\RequirePackage{authblk}
\setcounter{Maxaffil}{0}
\setlength{\affilsep}{0.2em}
\renewcommand\Authfont{\normalfont\bfseries\fontsize{9}{13}\selectfont}
\renewcommand\Affilfont{\normalfont\fontsize{8}{10}\selectfont}
\makeatletter
\renewcommand\AB@affilsepx{, \protect\Affilfont}
\makeatother
\renewcommand\Authands{ and }

\pagestyle{fancy}   %
\fancypagestyle{firststyle}{
  \fancyhead[L]{\includegraphics[width=60pt]{assets/google-cloud-logo.png}}
  \fancyhead[R,C]{}
  \fancyfoot[L]{\footerfont\itshape\the\correspondingauthor}
  \fancyfoot[R,C]{}
}

\fancyhead[L,R]{}
\makeatletter
\fancyhead[C]{\footerfont \@title}
\makeatother
\fancyfoot[C]{}
\fancyfoot[L]{
	\footerfont\bfseries\relax
}
\fancyfoot[R]{\footerfont \thepage}

\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{1pt}
\let\DefaultHeadRule\headrule
\let\DefaultFootRule\footrule
\renewcommand{\headrule}{\color{gray}\DefaultHeadRule}
\renewcommand{\footrule}{\textcolor{gray}{\DefaultFootRule}}

\renewenvironment{abstract}
{\par\noindent\\  \ignorespaces \bfseries}
{\par\bigskip}

\addto{\captionsenglish}{\renewcommand{\refname}{References}}

\def\xabstract{abstract}
\long\def\abstract#1\end#2{\def\two{#2}\ifx\two\xabstract
	\long\gdef\theabstract{\ignorespaces#1}
	\def\go{\end{abstract}}\else
\typeout{^^J^^J PLEASE DO NOT USE ANY \string\begin\space \string\end^^J
	COMMANDS WITHIN ABSTRACT^^J^^J}#1\end{#2}
\gdef\theabstract{\vskip12pt BADLY FORMED ABSTRACT: PLEASE DO
NOT USE {\tt\string\begin...\string\end} COMMANDS WITHIN
THE ABSTRACT\vskip12pt}\let\go\relax\fi
\go}

\makeatletter
\newcommand{\abscontent}{
	\noindent
	\parbox{\dimexpr\linewidth}{\absfont \theabstract}
	
}

\renewcommand{\maketitle}{\bgroup\setlength{\parindent}{0pt}
	\begin{adjustwidth}{0pt}{24pt}
		\begin{flushleft}
			{
				{\raggedright \titlefont \@title\par}%
				\vskip11pt
				{\raggedright \@author\par}
				\vskip20pt%
			}%
		\end{flushleft}
	\end{adjustwidth}
	\egroup
	{%
		{\abscontent}
	}%
	\thispagestyle{firststyle}
}%
\makeatother

\titleformat{\section}
{\large\bfseries\headingfont}
{\thesection.}
{0.5em}
{#1}
[]
\titleformat{name=\section,numberless}
{\large\bfseries\headingfont}
{}
{0em}
{#1}
[]
\titleformat{\subsection}
{\bfseries}
{\thesubsection.}
{0.5em}
{#1}
[]
\titleformat{\subsubsection}%
{\bfseries\itshape}
{\thesubsubsection.}
{0.5em}
{#1}
[]

\titlespacing*{\section}{0pc}{3ex plus4pt minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex plus3pt minus2pt}{2pt}
\titlespacing*{\subsubsection}{0pc}{2ex plus2.5pt minus1.5pt}{2pt}

\DeclareCaptionLabelSeparator{pipe}{ $\vert$ }%
\captionsetup{labelfont={}, %
labelsep=space,%
figurename=Figure,%
labelsep=pipe,
singlelinecheck=off,%
}