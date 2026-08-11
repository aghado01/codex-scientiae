% $Header: rmj-public.cls,v 1.2 2020/08/21 06:24:14 levy Exp levy $

% This is rmj-public.cls, the class file distributed by MSP for
% authors of articles in the Rocky Mountain Journal of Mathematics.
%
% Copying of this file is authorized only if either 
%   (1) you make absolutely no changes to your copy, including name; OR
%   (2) if you do make changes, you first rename it to some other name.
%
\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\def\parseRCS$Date#1: #2 #3$ $Revision#4: #5${#2 #5--}

\def\jabbrev{rmj}
\def\journalname{Rocky Mountain Journal of Mathematics}

\ProvidesClass{\jabbrev-public}[\parseRCS
   $Date: 2020/08/21 06:24:14 $
   $Revision: 1.2 $ 
   Public class for the \journalname]

\RequirePackage{xcolor}
\RequirePackage{times}
\RequirePackage{mathptmx}
\RequirePackage{amsfonts}
\let\cal\mathcal

\def\thepubyr{YEAR}
\def\thevolno{VOL}
\def\theissueno{ISSUE}
\def\@startpage{PAGE}
\def\fmtref#1{}
\let\doiprefix\jabbrev

\newif\ifdvi\dvitrue
\@ifundefined{pdfoutput}{}{\ifnum\pdfoutput>0 \dvifalse\fi}

\newif\ifcolorlinks % will the PDF or DVI file contain links?
\colorlinkstrue   
\DeclareOption{nolinking}
  {\colorlinksfalse}

\newif\ifproofs % will the output be in proofs-mode (ruler, etc)?
\proofstrue 
\DeclareOption{noproofs}
  {\proofsfalse} 

\newif\ifpulp      % will it be sent to the press?
\DeclareOption{pulp}
  {\colorlinksfalse\cropmarktrue\pulptrue\proofsfalse} 
\newif\ifcropmark                % will the output have cropmarks?
\DeclareOption{cropmark}
  {\cropmarktrue}
\DeclareOption{nocropmark}
  {\cropmarkfalse}
\newif\ifprint     % for (two-sided) printing?
\DeclareOption{print}
  {\printtrue\screenfalse\colorlinksfalse\proofsfalse} 
\newif\ifscreen    % for screen reading
\DeclareOption{screen}
  {\screentrue\printfalse\proofsfalse} 
\newif\ifoff       % article with offprint/offscreen covers
\DeclareOption{off}
  {\offtrue\proofsfalse}

\newif\ifbottomrule
\newif\ifedit
\DeclareOption{edit}
	{\screentrue\bottomruletrue\proofstrue\edittrue}
	
\newif\ifindentall % will theorems and 1st line of paper be indented?
\DeclareOption{indentall}{\indentalltrue}
\DeclareOption{dvipdfm}{\dvipdfmtrue} \newif\ifdvipdfm % passed to hyperref

% Options for paper size etc.: largely untested!
\DeclareOption{a4paper}{\paperheight 297mm\paperwidth 210mm
  \textheight 54.5pc }
\DeclareOption{letterpaper}{\paperheight 11in\paperwidth 8.5in }
\DeclareOption{landscape}{\@tempdima\paperheight
  \paperheight\paperwidth \paperwidth\@tempdima}
\DeclareOption{portrait}{}
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchfalse}
\DeclareOption{yesblackboxes}{\overfullrule5\p@ }
\DeclareOption{noblackboxes}{\overfullrule\z@ }
\newif\if@titlepage
\DeclareOption{titlepage}{\@titlepagetrue}
\DeclareOption{notitlepage}{\@titlepagefalse}
\newif\if@openright
\DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{nomath}{}
\DeclareOption{psamsfonts}{%
  \PassOptionsToPackage{psamsfonts}{amsfonts}%
  \PassOptionsToPackage{cmex10}{amsmath}}
\newif\iftagup
\DeclareOption{leqno}{%
  \taguptrue \PassOptionsToPackage{leqno}{amsmath}}
\DeclareOption{reqno}{%
  \tagupfalse \PassOptionsToPackage{reqno}{amsmath}}
\newif\ifctagsplit@
\DeclareOption{centertags}{%
  \ctagsplit@true \PassOptionsToPackage{centertags}{amsmath}}
\DeclareOption{tbtags}{%
  \ctagsplit@false \PassOptionsToPackage{tbtags}{amsmath}}
\newif\if@slantedgreek
\DeclareOption{slantedgreek}{\@slantedgreektrue}

\chardef\@currsizeindex=6
\widowpenalty=10000
\clubpenalty=10000
\brokenpenalty=10000
\newdimen\linespacing
\lineskip=1pt \lineskiplimit=1pt
\normallineskip=1pt \normallineskiplimit=1pt

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}

\ProcessOptions

\LoadClass[11pt,oneside,onecolumn]{amsart}

% we redefine 11pt to match the production dimensions
% \DeclareOption{11pt}{\def\@mainsize{12}\def\@ptsize{2}%
  \def\@typesizes{%
    \or{6.3}{8}\or{7.3}{10}\or{8.3}{11}\or{9.3}{12}\or{10.3}{13}%
    \or{11.3}{14}% normalsize
    \or{13}{17}\or{\@xviipt}{20}\or{\@xxpt}{24}%
    \or{\@xxvpt}{30}\or{\@xxvpt}{30}}%
  \normalsize \linespacing=\baselineskip
% }

\RequirePackage{microtype}

\headheight=10pt \headsep=16pt
\footskip=24pt
\topskip=10pt
\columnsep=10pt \columnseprule=0pt

\skip\footins=7pt plus11pt
\skip\@mpfootins=\skip\footins
\fboxsep=3pt \fboxrule=.4pt
\arrayrulewidth=.4pt    \doublerulesep=2pt
\labelsep=5pt           \arraycolsep=\labelsep
\tabcolsep=\labelsep    \tabbingsep=\labelsep
\floatsep=15pt plus 12pt    \dblfloatsep=15pt plus 12pt
\textfloatsep=\floatsep  \dbltextfloatsep=15pt plus 12pt
\intextsep=\floatsep
\@fptop=0pt plus1fil     \@dblfptop=0pt plus1fil
\@fpbot=0pt plus1fil     \@dblfpbot=0pt plus1fil
\@fpsep=8pt plus2fil     \@dblfpsep=8pt plus2fil\relax
\parskip=0pt \relax
\newdimen\normalparindent
\normalparindent=12pt
\parindent=\normalparindent
\partopsep=0pt \relax \parsep=0pt \relax \itemsep=0pt \relax
\@lowpenalty=51         \@medpenalty=151        \@highpenalty=301
\@beginparpenalty=-\@lowpenalty
\@endparpenalty=-\@lowpenalty
\@itempenalty=-\@lowpenalty

%%%%%% RUNNING HEADS

\def\hyp@r@anchor#1{\hypertarget{#1}{}}

\def\foliostyle{\normalfont}
\def\ps@empty{\let\@mkboth\@gobbletwo
  \def\@oddhead{\hyp@r@anchor{page.\thepage}{}} \let\@evenhead\@oddhead
  \let\@oddfoot\@empty \let\@evenfoot\@empty
  \global\topskip\normaltopskip}
\def\runhdfnt{\SMALL\scshape}
\def\ps@plain{\ps@empty
  \def\@oddfoot{\runhdfnt \hfil\foliostyle\thepage\hfil}% removed \scriptsize
  \let\@evenfoot\@oddfoot}
\def\ps@headings{\ps@empty
  \def\@evenhead{\runhdfnt
\rlap{\hyp@r@anchor{page.\thepage}\foliostyle\thepage}\hfil \leftmark{}{}\hfil}%
  \def\@oddhead{\runhdfnt \hfil
 \rightmark{}{}\hfil \llap{\hyp@r@anchor{page.\thepage}\foliostyle\thepage}}%
  \let\@mkboth\markboth
}

\let\sectionname\@empty
\let\subsectionname\@empty
\let\subsubsectionname\@empty
\let\paragraphname\@empty
\let\subparagraphname\@empty
\def\leftmark{\expandafter\@firstoftwo\topmark{}{}}
\def\rightmark{\expandafter\@secondoftwo\botmark{}{}}
\def\ps@firstpage{\ps@plain}
\long\def\@nilgobble#1\@nil{}
\let\@nil\relax
\def\markboth#1#2{%
  \begingroup
    \@temptokena{{#1}{#2}}\xdef\@themark{\the\@temptokena}%
    \mark{\the\@temptokena}%
  \endgroup
  \if@nobreak\ifvmode\nobreak\fi\fi}
\def\ps@myheadings{\ps@headings \let\@mkboth\@gobbletwo}
\newskip\normaltopskip
\normaltopskip=10pt \relax
\let\sectionmark\@gobble
\let\subsectionmark\@gobble
\let\subsubsectionmark\@gobble
\let\paragraphmark\@gobble

\@namedef{subjclassname@2020}{%
  \textup{2020} Mathematics Subject Classification}
\renewcommand*\subjclass[2][2020]{%
  \def\@subjclass{#2}%
  \@ifundefined{subjclassname@#1}{%
    \ClassWarning{\@classname}{Unknown edition (#1) of Mathematics
      Subject Classification; using '1991'.}%
  }{%
    \@xp\let\@xp\subjclassname\csname subjclassname@#1\endcsname
  }%
}

\ifoff
  \@ifundefined{pdfoutput}
    {\@latex@warning{Option OFF needs PDFLATEX !}\@@end}
    {\RequirePackage{graphicx}}
  \ifprint\else
    \ifscreen\else
      @latex@warning{Option OFF needs either SCREEN or PRINT selected}%
      \@@end
    \fi
  \fi
\fi


\def\makecoveralone%
  {\makeoffcover\def\enddoc@text{}}
\def\makeoffcover{%
  \thispagestyle{empty}
  \vbox to \textheight{\vss 
    \centerline{\Huge\bf ISSUE COVER} 
  \vss}\eject
  \setcounter{page}{-1}
  \ifprint\thispagestyle{empty}\quad\vfill\eject\fi
}
\newenvironment{offcover}[2]% #1 -> offprint img; #2 -> offscreen img
  {\findmonth
  \bgroup% isolator
  \thispagestyle{empty}%
  \hrule height\z@
  \vskip-\topmargin
  \vskip-1in
  \vskip-\headheight
  \headheight=\z@
  \vskip-\headsep% move to top margin
  %
  \@ifempty{#1}{}{%
    \@tempdima=\oddsidemargin
    \advance\@tempdima by1in
    \moveleft\@tempdima% move to left margin
    \vbox to\z@{\hbox to\z@{%
      \ifprint% set backgrounds
          \includegraphics
          [width=\paperwidth,height=\paperheight]
          {#1}%
      \else
          \includegraphics
          [width=\paperwidth,height=\paperheight]
          {#2}%
      \fi
    \hss}\vss}
    }%
  \hrule height\z@
}{%
  \eject
  \egroup% end isolator
  \setcounter{page}{-1}
  \ifprint\thispagestyle{empty}\quad\vfill\eject\fi
}

\def\@prepheadcontent{%
  \uppercasenonmath\shorttitle
  \ifx\@empty\shortauthors \let\shortauthors\shorttitle
  \else \andify\shortauthors \uppercasenonmath\shortauthors\fi 
  }
  
\def\volumenumber#1{\def\thevolno{#1}\volumenumberhook}\def\thevolno{}
\def\volumenumberhook{}
\def\issuenumber#1{\def\theissueno{#1}\issuenumberhook}\def\theissueno{}
\def\issuenumberhook{}
\let\papercode\@gobble%metadata field used only by other processors
\def\thepaperno{00}
\newcommand{\papernumber}[1]{\@ifempty{#1}%
  {\def\thepaperno{00}}%
  {\xdef\thepaperno{\ifnum#1 >9 \else0\fi#1}}}
 
\def\msplink{http://msp.org}
\def\homelink{http://msp.org/}
\def\issuelink{https://doi.org/\doiprefix.\thepubyr.\thevolno-\theissueno}
\def\paperlink{\homelink/vol/\thevolno/\theissueno/\thepaperno.html}

\def\doilink{https://doi.org/\doiprefix.\thepubyr.\thevolno.\@startpage}

\def\thelogo{\vbox{
  \moveright.025in
  \vbox{\hsize=.75\textwidth\parindent=\z@
  	\scriptsize
	\href{\homelink}
      {\hskip-.5pt\scshape\expandafter\uppercase\expandafter{\journalname}}%
    \par
    \href{\issuelink}
      {Vol.~\thevolno, No.~\theissueno, \thepubyr}
    \par\vskip5pt
    \tiny
    \textsf{\hskip.5pt\href{\doilink}{\doilink}}
    }
  }}

% by default the logo is placed on the left
\def\logobox{\vbox to44pt{\hbox to\textwidth{\tiny\thelogo\hss}\vss}}

\def\setsubjclass{%
  \ifx\@schemes\@gobble\else 
    \@footnotetext{\@setsubjclass}%
  \fi
}
\def\setkeywords{%
  \ifx\@empty\@keywords\else 
    \@footnotetext{\@setkeywords}%
  \fi
}

\def\@maketitle{%
  \let\@makefnmark\relax  \let\@thefnmark\relax
  \normalfont\normalsize
  \ifx\@empty\thankses\else\@footnotetext{\def\par{\let\par\@par}\@setthanks}\fi
  \@mkboth{\@nx\shortauthors}{\@nx\shorttitle}%
  \logobox
  \ifindentall\parindent\z@\fi %paper title is a trivlist, hence indented
  \hypertarget{TITLEPAGE}{}% make a target usable by the volume ToC
  \@settitle
  \ifx\@empty\authors \else \@setauthors \fi
  \ifx\@empty\@dedicatory \else \@setdedicatory \fi
  \@setabstract
  \setsubjclass
  \setkeywords
  \normalsize
  \@postmaketitle
} % end \@maketitle

\def\@postmaketitle{
  \if@titlepage
    \newpage
  \else
    \dimen@12\p@ \advance\dimen@-\baselineskip
    \vskip\dimen@ plus 14\p@\relax
  \fi
}

%%%%%%%%%%% LIST ENVIRONMENTS STUFF

%%%%%%%%%%% SECTIONING COMMANDS

\def\allsectionsname{Section}
\def\@startsection#1#2#3#4#5#6{%
 \edef\object@type{Section\romannumeral#2}%
 \if@noskipsec \leavevmode \fi
 \par \@tempskipa #4\relax
 \@afterindenttrue
 \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa
   \ifindentall\else\@afterindentfalse\fi\fi 
 \if@nobreak \everypar{}\else
     \addpenalty\@secpenalty\addvspace\@tempskipa\fi
 \@ifstar{\@dblarg{\@sect{#1}{\@m}{#3}{#4}{#5}{#6}}}%
         {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}%
}
\def\@secnumfont{\bfseries}

\newcounter{toclink}\setcounter{toclink}{\m@ne}
\def\sectnumberpunct{.}
\def\secttitlepunct{.}
\def\sectnumberspacing{\enspace}
\def\@sect#1#2#3#4#5#6[#7]#8{\stepcounter{toclink}%
  \edef\@toclevel{\ifnum#2=\@m 0\else\number#2\fi}%
  \ifnum #2>\c@secnumdepth \let\@secnumber\@empty
  \else \@xp\let\@xp\@secnumber\csname the#1\endcsname\fi
 \ifnum #2>\c@secnumdepth
   \let\@svsec\@empty
 \else
    \refstepcounter{#1}%
    \edef\@svsec{\ifnum#2<\@m
       \@ifundefined{#1name}{}{%
         \ignorespaces\csname #1name\endcsname\space}\fi
       \@nx\textup{%
      \@nx\@secnumfont
         \csname the#1\endcsname\sectnumberpunct}\sectnumberspacing
    }%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@ % then this is not a run-in section heading
    \begingroup #6\relax\hyp@r@anchor{sectunit\thetoclink}%
    \@hangfrom{\hskip #3\relax\@svsec}{\interlinepenalty\@M #8\par}%
    \endgroup
    \csname#1mark\endcsname{#7}%
    \ifnum#2>\@m \else \@tocwrite{#1}{\protect\href{\hyper@hash sectunit\thetoclink}{#7}}\fi
  \else
  \def\@svsechd{\hyp@r@anchor{sectunit\thetoclink}#6\hskip #3\@svsec
    \@ifnotempty{#8}{\ignorespaces#8\unskip
       \@addpunct\secttitlepunct}%
     % .toc file gets everything allowed by bookmarksdepth, which is assumed
     % at least as high as tocdepth.  Then tocdepth controls what gets printed.
        \ifnum#2>\Hy@bookmarksdepth \else 
     \@tocwrite{#1}{\protect\href{\hyper@hash sectunit\thetoclink}{#7}}\fi
  }%
  \fi
  \global\@nobreaktrue
  \def\@tempa{#7}\ifx\@tempa\@empty %use #5 again after 
  % Use \@tempskipa if it's positive (i.e., it encodes a vertical skip)
  % or if the (sub)section title is nonempty or if the paper is pre-2009
     \ifdim\@tempskipa>\z@\@xsect{\@tempskipa}\else
     \@xsect{\untitledsubsectionskip}\fi\else\@xsect{\@tempskipa}\fi}
\let\untitledsubsectionskip\z@
\let\@ssect\relax

\renewcommand\thepart          {\Roman{part}}
\renewcommand\thesection       {\arabic{section}}
\renewcommand\thesubsection    {\thesection.\arabic{subsection}}
\renewcommand\thesubsubsection {\thesubsection .\arabic{subsubsection}}
\renewcommand\theparagraph     {\thesubsubsection.\arabic{paragraph}}
\setcounter{secnumdepth}{3}
\def\partname{Part}
\def\part{\@startsection{part}{0}%
  \z@{\linespacing\@plus\linespacing}{.5\linespacing}%
  {\normalfont\large\bfseries\centering}}
\def\specialsection{\@startsection{section}{1}%
  \z@{\linespacing\@plus\linespacing}{.5\linespacing}%
  {\normalfont\Large\bfseries\raggedright}}
\def\section{\@startsection{section}{1}%
  \z@{-12.9pt plus -2.5pt minus -2pt}{8pt}%
  {\normalfont\bfseries\centering\boldmath}}
\def\subsection{\@startsection{subsection}{2}%
  \z@{-9pt plus -2.5pt minus -3pt}{-6.001\p@\@plus2\p@}%was {-3pt}
  {\it\bfseries\boldmath}}
\def\subsubsection{\@startsection{subsubsection}{3}%
  \z@{-6pt plus -2.5pt minus -3pt}{-6.001\p@\@plus2\p@}%
  {\it}}
\def\paragraph{\@startsection{paragraph}{4}%
  \z@\z@{-\fontdimen2\font}%
  \normalfont\itshape}
\def\subparagraph{\@startsection{subparagraph}{5}%
  \z@\z@{-\fontdimen2\font}%
  \normalfont\itshape}
\def\appendix{\par\c@section\z@ \c@subsection\z@
   \let\sectionname\appendixname
   \def\thesection{\@Alph\c@section}}
\def\appendixname{Appendix}
\def\@Roman#1{\@xp\@slowromancap
  \romannumeral#1@}%
\def\@slowromancap#1{\ifx @#1% then terminate
  \else
    \if i#1I\else\if v#1V\else\if x#1X\else\if l#1L\else\if
    c#1C\else\if m#1M\else#1\fi\fi\fi\fi\fi\fi
    \@xp\@slowromancap
  \fi
}
\def\partmark#1{}

\setcounter{tocdepth}{1}
\def\contentsstyle{\small\advance\hsize-3pc \leftskip3pc }%indent on both sides

%%%%%%%%%%% BIBLIOGRAPHY

%%%%%%%%%%% INDEX, FOOTNOTES etc.

%%%%%%%%%%% FLOATS

%%%%%%%%%%% HYPERREF STUFF

\RequirePackage{amssymb}

\RequirePackage{hyperref}
\def\HyPsd@CatcodeWarning#1{}
\def\HyPsd@RemoveSpaceWarning#1{}
\def\HyPsd@ReplaceSpaceWarning#1{}

\definecolor{linkblue}{rgb}{0,0,.65}

\hypersetup{%
  pageanchor=false,% false to avoid repeated anchor,
  hypertexnames=false,% so no conflict when we have Theorem 1 twice
  bookmarksdepth=3,% we don't support level-4 sectioning
  pdfnewwindow=true,%
  plainpages=false,%
}
\ifcolorlinks
  \hypersetup{%
    colorlinks=true,%
    linkcolor=linkblue,%
    citecolor=linkblue,%
    filecolor=linkblue,%
    menucolor=linkblue,%
    urlcolor=linkblue,%
  }
\else
  \hypersetup{%
    colorlinks=false,%
    linkcolor=black,% for super-prudent similarity
    citecolor=black,%
    filecolor=black,%
    menucolor=black,%
    urlcolor=black,%
  }
  \AtBeginDocument{%
    % everything before 2013 is assumed typeset with TL2008 with hyperref 6.75l
    % everything else is assumed typeset with previous year's TL (>=2012)
    % (unless forced otherwise by an explicit \texlive command)
    \@ifundefined{@texlive@yr}% defined by \texlive in metadata of paper
      {\ifnum\thepubyr<2013 \@old@print@true \else\@old@print@false \fi}
      {\ifnum\@texlive@yr<2012 \@old@print@true \else\@old@print@false \fi}%

    \hypersetup{hidelinks}% not available in hyperref 6.75l
  }
\fi

\AtBeginDocument{%
  \def\@currentHref{Doc-Start}  % make sure there's a hyperlabel at top of doc
}%

%%%%%%%%%%% CROSS-REFERENCES

%%%%%%%%%%% ENVIRONMENTS

\pagenumbering{arabic}
\pagestyle{headings}
\thispagestyle{plain}

%%%%%% PAGE AND TEXT DIMENSIONS

% set textframe dimensions
  \textwidth=38pc 
  \textheight=51pc 

\advance\textheight by\footskip
% Note: \textheight is, for now, the height of the *whole* text frame;
% the actual \textheight is computed in \calclayout.

% set page dimensions for options [print] and [screen]
\newdimen\printpaperwidth % also used for placing cropmarks!
\newdimen\printpaperheight 
\newdimen\screenpaperwidth % to be used by mspcover.cls, someday
\newdimen\screenpaperheight

  \printpaperwidth=8in
  \printpaperheight=10.5in
  \screenpaperwidth=500bp
  \screenpaperheight=705bp

% Warning:
% if a class changes the values of \printpaperwidth or \printpaperheight, 
% it must also run \calccropmark (or \calclayout).

% standard page dimensions
\paperwidth=8.5in
\paperheight=11in

% set special page dimensions, for options [pulp], [screen], [print]
\ifpulp
  \paperwidth=652bp
  \paperheight=832bp
\fi
\ifscreen
  \paperwidth=\screenpaperwidth
  \paperheight=\screenpaperheight
\fi
\ifprint
  \paperwidth=\printpaperwidth
  \paperheight=\printpaperheight
\fi
\relax

% set adjustment for \topmargin
\newdimen\topmarginadjust
\ifpulp
  \topmarginadjust=9.03pt
\fi
\ifscreen
    \topmarginadjust=10.54pt
\fi
\ifprint
    \topmarginadjust=10.03pt
\fi
\relax

\newdimen\viewshift
\viewshift=\z@

\ifedit
		\paperheight=615bp
		\paperwidth=520bp
		\topmarginadjust=7pt
		\viewshift=-31pt
\fi


% set odd/even asymmetry for printing & pulp
\newdimen\asymmetry 
  \asymmetry=\z@

\def\calclayout{%
  % warning: when calling \calclayout, 
  % \textheight must be the total height of the textframe, 
  % including header and footer!
  
  % extract actual \textheight from total height of textframe
  \advance\textheight by-\headheight
  \advance\textheight by-\headsep
  \advance\textheight by-\footskip
    
  % set vertical skip (text on page)
  \topmargin=\paperheight
  \advance\topmargin by-\headheight
  \advance\topmargin by-\headsep
  \advance\topmargin by-\textheight
  \advance\topmargin by-\footskip% was missing before
  \divide\topmargin by\tw@
  \advance\topmargin by-1in
  %\advance\topmargin by-1.01pt% backwards compatibility
  
  \advance\topmargin by\topmarginadjust
  
  % set horizontal skip (text on page)
  \oddsidemargin=\paperwidth
  \advance\oddsidemargin by-\textwidth
  \divide\oddsidemargin by\tw@
  \advance\oddsidemargin by-1in
  \evensidemargin=\oddsidemargin
  \ifprint
    \advance\oddsidemargin by\asymmetry
    \advance\evensidemargin by-\asymmetry
  \fi
  \ifpulp
    \advance\oddsidemargin by\asymmetry
    \advance\evensidemargin by-\asymmetry
  \fi
  \advance\oddsidemargin by\viewshift
  \advance\evensidemargin by\viewshift
  
  % TeX paper dimensions become PDF page dimensions
  \pdfpagewidth=\paperwidth
  \pdfpageheight=\paperheight
  \relax
}
% \calclayout will be enriched below with cropmark-parameter computations
\calclayout

%%%%%%%%%%% BIBLIO STUFF (MR etc.)

%%%%%%%%%%% FONT MANAGEMENT

\tracinglostchars=2  % Flags non-existent things like \mathbb{k}

%%%%%%%%%%% MARGINPARS

%%%%%%%%%%% MATH STUFF

%%%%%%%%%%% LANGUAGE RENAMING (OVERWRITES BABEL)

%%%%%%%%%%% MISCELLANEOUS

\begingroup  \catcode `[= 1 \catcode`]=2 \catcode `\{=12 \catcode `\}=12
\gdef\semiverbatim[
\def\dospecials[\do\ \do\{\do\}\do\$\do\&\do\#\do\^\do\_\do\%\do\~]
\gdef\@xverbatim##1\end{verbatim}[##1\end[verbatim]]
\gdef\@sxverbatim##1\end{verbatim*}[##1\end[verbatim*]]
]
\endgroup

% Usage: \msplogo{10pt}.  The color is inherited from the surrounding text.
% The dimensions of the logo are 2x3 times the dimension in braces.
%
\def\msplogo#1{\hbox{%
        \vbox{\hrule height #1 width #1\vskip #1\hrule height #1 width #1}%
        \vbox{\hrule height #1 width #1\vskip #1}}}

%%%%%% CROPMARKS

% Uses dimensions \printpaperwith and \printpaperheight
% if class modifies \printpaper..., it must recalculate or reset 
% the next two as well (or run \calccropmark or \calclayout)
\newdimen\@papervmargin 
\newdimen\@paperhmargin 

\def\calccropmark{%
  \@papervmargin=1in  % may be overridden by class
  \advance\@papervmargin by-20bp% pulp paper is now bigger
  \@paperhmargin=-\printpaperwidth
  \advance\@paperhmargin by\oddsidemargin
  \advance\@paperhmargin by\evensidemargin
  \advance\@paperhmargin by\textwidth
  \divide\@paperhmargin by\tw@
  \relax
}
\calccropmark
\g@addto@macro\calclayout\calccropmark

% Definition of \ticks
%
\def\vtick{\vrule width.4pt height20pt depth0pt}
\def\Vtick{\vrule width.4pt height0pt depth20pt}
\def\htick{\vrule width20pt height.4pt depth0pt}
\def\Htick{\vrule width20pt height0pt depth.4pt}
%
\def\setcropmarks{\vbox to 0pt{\offinterlineskip
  \kern-\@papervmargin
  \kern-30.4pt % compensate for cropmark height: 20pt + 10pt space + .4pt
  \vskip 0.25in 
  \hbox to \printpaperwidth{\llap{\vtick}\hfil\rlap{\vtick}}
  \kern10pt
  \hbox to \printpaperwidth{\llap{\htick\kern10pt}\hfil\rlap{\kern10pt\htick}}
  \kern\printpaperheight
  \hbox to \printpaperwidth{\llap{\Htick\kern10pt}\hfil\rlap{\kern10pt\Htick}}
  \kern10pt
  \hbox to \printpaperwidth{\llap{\Vtick}\hfil\rlap{\Vtick}}%
  \vss
}}

%
% Modify Latex's \@outputpage: see \ifcropmark, \ifproofs
%

\def\@outputpage{%
\begingroup           % the \endgroup is put in by \aftergroup
  \let \protect \noexpand
  \global\let\@@if@newlist\if@newlist \global\@newlistfalse
  \@resetactivechars
  \@parboxrestore
  \shipout \vbox{%
    \set@typeset@protect
    \aftergroup \endgroup
    \aftergroup \set@typeset@protect
                                % correct? or just restore by ending
                                % the group?
  \if@specialpage
    \global\@specialpagefalse\@nameuse{ps@\@specialstyle}%
  \fi
  \if@twoside
    \ifodd\count\z@ \let\@thehead\@oddhead \let\@thefoot\@oddfoot
         \let\@themargin\oddsidemargin 
    \else \let\@thehead\@evenhead
       \let\@thefoot\@evenfoot \let\@themargin\evensidemargin 
    \fi
  \fi
  \reset@font
  \normalsize
  \normalsfcodes
  \let\label\@gobble
  \let\index\@gobble
  \let\glossary\@gobble
  \baselineskip\z@skip \lineskip\z@skip \lineskiplimit\z@
    \@begindvi
      \ifcropmark
        \moveright\@paperhmargin\setcropmarks\nointerlineskip
      \fi
    \vskip \topmargin
    \moveright\@themargin \vbox {%
      \setbox\@tempboxa \vbox to\headheight{%
        \vfil
        \color@hbox
          \normalcolor
          \hb@xt@\textwidth{\@thehead}%
        \color@endbox
        }%                        %% 22 Feb 87
      \dp\@tempboxa \z@
      \box\@tempboxa
      \vskip \headsep
      \box\@outputbox
      \ifproofs{\ruler@pic\ifbottomrule\vskip.1pt\hrule\null\vskip-.5pt\fi}\fi
      \baselineskip \footskip
      \color@hbox
        \normalcolor
        \hb@xt@\textwidth{\@thefoot}%
      \color@endbox
      }%
    }%
  \global\let\if@newlist\@@if@newlist
  \global \@colht \textheight
  \stepcounter{page}%
  \let\firstmark\botmark
}

\newcount\linec@unt 
\def\halftick{\llap{\the\linec@unt$^{\mskip1mu\hbox{\Tiny 1}}\mskip-3mu$/$_{\mskip-1mu\hbox{\Tiny 2}\,}$}}
\def\ruler@pic{\let\leavevmode\relax  % bizarrely, \leavevmode
  \color{red}\linec@unt=0           % can be triggered by \color in pdf mode
  \tiny\sf\offinterlineskip
  \vbox to 0pt{
    \vss
    \hbox{Submitted to \journalname\ - NOT THE PUBLISHED VERSION}
    \vskip\headheight \vskip\headsep \vskip10pt
    \loop
      \ifdim\textheight>\the\linec@unt\linespacing 
      \advance\linec@unt by 1 
      \vskip\linespacing 
      \setbox\z@\vbox to 0pt{%
        \vss
        \hbox to 0pt{%
          \hss
          \raise.06\linespacing\hbox to 1em{\hss\the\linec@unt}\hskip-1em
          \lower.39\linespacing\hbox to2em{%
            \color{blue}%
%            \ifnum\linec@unt=1  \halftick\fi % give a hint about 1/2
%            \ifnum\linec@unt=20 \halftick\fi
%            \ifnum\linec@unt=39 \halftick\fi
            \vrule height .15\linespacing depth -.13\linespacing 
              width \ifbottomrule 3em \else 1.5em\fi
            \hss}}
        }\ht\z@\z@ \dp\z@\z@ \box\z@
    \repeat
  }
}

%%
%% End of file `msp.cls'.

