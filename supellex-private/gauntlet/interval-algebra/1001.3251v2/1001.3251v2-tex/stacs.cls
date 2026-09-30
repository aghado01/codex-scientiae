%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Modification log of stacs.cls
%%
%% 2007/06/05 v0.1 based on lmcs.cls (itself based on amsart.cls and 
%% inspired by jair.sty)
%% 2007/07/16 v0.2 fixed multiple authors, proclamations, section 
%% styles, etc
%% 2007/08/02 v0.3 fixed style of numbering of sections (with the 
%% help of Lukasz Kaiser and Michael Ummels)
%% 2007/09/10 v0.4 fixed erroneous year of ACM subject classification
%% 2007/12/15 v0.5 fixed conflict with some "algorithm" packages 
%% (removed the definition of the algorithm environment), and added 
%% the stacs logo on foot of first page
%% 2008/03/08 v1.0 added the possibility of attributing several 
%% affiliations to each author; merged the proceedings and submission 
%% style files.
%% 
%%                Mamadou Kante and Pascal Weil
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Modification log of lmcs.cls
%%
%% 2004/03/25 v0.1 based on amsart.cls, inspired by jair.sty 
%% 2004/09/01 v0.2 based on amsart.cls
%% 2004/10/12 v0.3 based on amsart.cls
%% 2004/12/16 v0.4 based on amsart.cls
%% 2005/01/24 v0.5 based on amsart.cls
%% 2005/03/10 v0.6 based on amsart.cls
%% 2006/07/24 v0.7 based on amsart.cls
%%                
%%                 Juergen Koslowski, Stefan Milius
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{stacs}
	      [2007/09/10 v1.0 STACS Layout Editor Class]
	      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% options of the class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifproceedings
% 
\DeclareOption{submitted}{\proceedingsfalse}
\DeclareOption{proceedings}{\proceedingstrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsart}}
\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% included packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[11pt,reqno]{amsart}
\usepackage{helvet,url,cclicenses}
\usepackage{epsf}
\usepackage{graphicx}
\usepackage{ifthen,shortvrb}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   		Use of this class, cf. also stacs-smp.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This class builds upon the amsart class of AMS-LaTeX and requires use
% of LaTeX 2e. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Start of the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% \documentclass{stacs} 
%
% without any options followed optionally by
%
% \usepackage{package1,package2,...}
%
% loading additional macro packages you may wish to use, (eg, xypic, etc.)
% (This also is the place to define further theorem-environments, in case
% those provided by default do not suffice, cf. below.)
%
% \begin{document}
% \title[short_title]{real title}
%
% and a list of author information of the form
%
% \author[ref1]{short_author_1}{Author 1}
% \address[ref1]{address 1}
% \email{author1@email1}
% \urladdr{http://www.institute1.sw}
% \thanks{thanks 1}
%
% \author[ref2]{short_author_2}{Author 2}
% \address[ref2]{address 2}
% \email{author2@email2}
% \urladdr{http://www.institute2.sw}
% \thanks{thanks 2}
%
% The \email, \urladdr and \thanks fields are optional.  The \thanks
% fields appear in footnotes on the title page, the addresses and
% email information appear below the title.  The optional arguments to
% the short_title and short_author arguments determine a running head
% on the odd and even pages, respectively.
%
% A list of keywords is mandatory; an ACM Subject classification is
% strongly recommended; these appear in footnotes on the title page,
% preceeding any \thanks fields.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Body of the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We encourage the use of LaTeX's crossreferencing capabilities with the
% \label and \ref commands, for sections, subsections, theorems etc., and
% displayed equations and figures.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		Theorems, Definitions etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The following theorem-like environments are available.  The
% numbering is consecutive within sections.
%
% thm or theorem         Theorem
% cor  or corollary        Corollary
% lem  or lemma          Lemma
% prop or proposition   Proposition
% asm or assumption    Assumption
%
% defi or definition      Definition
% rem or remark          Remark
% rems or remarks       Remarks (intended for use with itemized remarks)
% exa or example        Example
% exas or examples     Examples (intended for use with itemized examples)
% conj or conjecture   Conjecture
% conv or convention  Convention
% prob or problem      Problem
% oprob                     Open Problem
% algo    Algorithm
% obs or observation  Observation
%
% If you require additional environments, you can add them before
% \begin{document} by means of
%
% \theoremstyle{plain}\newtheorem{env}[thm]{Environment}
%
% or
%
% \theoremstyle{definition}\newtheorem{env}[thm]{Environment}
%
% In the first case the font within the new environment will be italicised.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Proofs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Proofs start with a \url{\proof} command, and end with a \url{\qed}
% command. The latter produces the end-of-proof box.
%
% \proof ... \qed
%
% In itemized or enumerated proofs the \qed command has to occur BEFORE 
% \end{itemize} or \end{enumerate} to ensure proper placement of the box:
%
% \proof
% \begin{itemize}
% \item[(1)] ...
% \item[(2)] ...
% ...
% \item[(n)] ... \qed
% \end{itemize}
%
% Similarly, the box may be used within theorem environments, when no
% explicit proof is given:
%
% \begin{thm} ... \qed \end{thm}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		Itemized or enumerated environments and proofs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% By default, the first item of an itemized (or enumerated) environment
% or proof appears inlined on the same line as the environment title.
% This can be prevented by placing \hfill before the itemization, e.g.:
%
% \begin{thm}\label{T:abc}\hfill
% \begin{itemize} ...
%
% \proof\hfill
% \begin{itemize} ...


%
%		End of the paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Acknowledgements should be placed in a non-numbered section:
%
% \section*{Acknowledgement}
%
% The bibliography starts with
% 
% \begin{thebibliography}{key}
% 
% where ``key'' is the longest key expected to occur and it ends with
% 
% \end{thebibliography}
% 
% It can use alphanumeric keys, with entries as
% 
% \bibitem[KW07]{cite_key} Author. Title.  {\em Journal} etc
% 
% or with automatically numbered keys, with entries as
% 
% \bibitem{cite_key} Author. Title.  {\em Journal} etc
% 
%
% Optionally, appendices can be inserted after the bibliography by
% means of
%
% \end{thebibliography}
% \appendix
% \section{} % Appendix A
% \section{} % Appendix B
% % etc.
% \end{document}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                   actual macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\count255=\the\catcode`\@ \catcode`\@=11 \edef\catc@de{\the\count255}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                 added from LMCS.cls

\newif\ifsuPer \suPertrue
\def\rsuper#1{\ifsuPer${\,}^{\MakeLowercase #1}$\fi}%
\def\lsuper#1{\ \hskip-2 pt\ifsuPer\llap{${}^{\MakeLowercase #1}\ $\fi}}%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%  for definition of author %%%%%%%%% 

\def\xnamedef#1#2{\expandafter\xdef\csname #1\endcsname{#2}}
\def\@exname#1{\expandafter\csname #1\endcsname}

\newcounter{authcounter}
\setcounter{authcounter}{1}


%%%%%%%%%%% from amsart.cls %%%%%%%%%%%%%%%
%% up to stacs.cls v0.5, the \author command allowed for only one
%% affiliation per author
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\author}[3][]{\@author#1\zzz{#2}{#3}}

\def\@author#1\zzz#2#3{%
  \let\@listupp\@empty
  \@for\@tmpauthor:={#1}\do{%
    \ifthenelse{\equal{\expandafter \csname @if\@tmpauthor \endcsname}{``1''}}{%
    }%
	   {%
	 \xnamedef{@\@tmpauthor}{\theauthcounter}
	 \xnamedef{@if\@tmpauthor}{``1''}
	 \stepcounter{authcounter}
	   }%
  }%
  \@for\@tmpauthor:={#1}\do{%
    \ifx\@empty\@listupp
    \xdef\@listupp{\csname @\@tmpauthor\endcsname}%
    \else
    \xdef\@listupp{\@listupp,\csname @\@tmpauthor\endcsname}%
    \fi
  }%

  \ifx\@empty\authors
  \protected@xdef\authors{#3\rsuper{\@listupp}}%
  \else
  \protected@xdef\authors{\authors\and#3\rsuper{\@listupp}}
  \g@addto@macro\addresses{\author{}{}}%
  \fi
  \@ifnotempty{#2}{%
    \ifx\@empty\shortauthors
    \gdef\shortauthors{#2}%
    \else
    \g@addto@macro\shortauthors{\and#2}%
    \fi
  }
}%



\renewcommand{\address}[2][]{
  \@ifempty{#1}{\g@addto@macro\addresses{\address{}{#2}}}

  \@ifnotempty{#1}{\g@addto@macro\addresses{\address{}{\lsuper{\protect\
  \@exname{@#1}\relax}#2}}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\titlecomment#1{\def\@titlecomment{#1}}
\let\@titlecomment=\@empty
\renewcommand{\sfdefault}{phv}
\renewcommand*\subjclass[2][1991]{%
  \def\@subjclass{#2}%
  \@ifundefined{subjclassname@#1}{%
    \ClassWarning{\@classname}{Unknown edition (#1) of ACM
      Subject Classification; using '1991'.}%
  }{%
    \@xp\let\@xp\subjclassname\csname subjclassname@2000\endcsname
  }%
}
\@namedef{subjclassname@2000}{1998 ACM Subject Classification}
\newcommand{\revisionname}{Revision Note}
\newbox\revisionbox
\newenvironment{revision}{%
  \ifx\maketitle\relax
    \ClassWarning{\@classname}{Revision should precede
      \protect\maketitle\space in STACS documentclasses; reported}%
  \fi
  \global\setbox\revisionbox=\vtop \bgroup
    \normalfont\Small
    \list{}{\labelwidth\z@
      \leftmargin3pc \rightmargin\leftmargin
      \listparindent\normalparindent \itemindent\z@
      \parsep\z@ \@plus\p@
      \let\fullwidthdisplay\relax
    }%
    \item[\hskip\labelsep\scshape\revisionname.]%
}{%
  \endlist\egroup
  \ifx\@setrevision\relax \@setrevisiona \fi
}
\def\@setrevision{\@setrevisiona \global\let\@setrevision\relax}
\def\@setrevisiona{%
  \ifvoid\revisionbox
  \else
    \skip@20\p@ \advance\skip@-\lastskip
    \advance\skip@-\baselineskip \vskip\skip@
    \box\revisionbox
    \prevdepth\z@ % because \revisionbox is a vtop
    \bigskip\hrule\medskip
  \fi
}
\def\@setsubjclass{%
  {\itshape\subjclassname:}\enspace\@subjclass\@addpunct.}
\def\@setkeywords{%
  {\itshape \keywordsname:}\enspace \@keywords\@addpunct.}
% \def\@settitlecomment{\@titlecomment\@addpunct.}
\def\@maketitle{%
  \normalfont\normalsize
  \let\@makefnmark\relax  \let\@thefnmark\relax
  \ifx\@empty\@date\else \@footnotetext{\@setdate}\fi
  \ifx\@empty\@subjclass\else \@footnotetext{\@setsubjclass}\fi
  \ifx\@empty\@keywords\else \@footnotetext{\@setkeywords}\fi
%   \ifx\@empty\@titlecomment\else \@footnotetext{\@settitlecomment}\fi
  \ifx\@empty\thankses\else \@footnotetext{%
    \def\par{\let\par\@par}\@setthanks\par}\fi
  \@mkboth{\@nx\shortauthors}{\@nx\shorttitle}%
  \global\topskip12\p@\relax % 5.5pc   "   "   "     "     "
  \topskip42 pt\@settitle
  \ifx\@empty\authors \else \@setauthors \fi
  \@setaddresses
  \ifx\@empty\@dedicatory
  \else
    \baselineskip18\p@
    \vtop{\centering{\footnotesize\itshape\@dedicatory\@@par}%
      \global\dimen@i\prevdepth}\prevdepth\dimen@i
  \fi
  \endfront@text
  \bigskip\hrule\medskip
  \@setrevision
  \@setabstract
  \vskip-\bigskipamount
  \normalsize
  \if@titlepage
    \newpage
  \else
    \dimen@34\p@ \advance\dimen@-\baselineskip
    \vskip\dimen@\relax
  \fi
}
\def\@setaddresses{\par
  \nobreak \begingroup
\footnotesize
  \def\author##1{\nobreak\addvspace\bigskipamount}%
  \def\\{\unskip, \ignorespaces}%
  \interlinepenalty\@M
  \def\address##1##2{\begingroup
    \par\addvspace\bigskipamount\noindent\narrower
    \@ifnotempty{##1}{(\ignorespaces##1\unskip) }%
    {\ignorespaces##2}\par\endgroup}%
  \def\curraddr##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\indent{\itshape Current address}%
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      ##2\par}\endgroup}%
  \def\email##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\indent{\itshape E-mail address}%
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      \url{##2}\par}\endgroup}%
  \def\urladdr##1##2{\begingroup
    \@ifnotempty{##2}{\nobreak\indent{\itshape URL}%
      \@ifnotempty{##1}{, \ignorespaces##1\unskip}\/:\space
      \ttfamily##2\par}\endgroup}%
  \addresses
  \endgroup
}
\copyrightinfo{}{}

\newinsert\copyins
\skip\copyins=3pc
\count\copyins=1000 % magnification factor, 1000 = 100%
\dimen\copyins=.5\textheight % maximum allowed per page

\renewcommand{\topfraction}{0.95}   % let figure take up nearly whole page
\renewcommand{\textfraction}{0.05}  % let figure take up nearly whole page

%% Specify the dimensions of each page

\setlength{\oddsidemargin}{.25 in}  %   Note \oddsidemargin = \evensidemargin
\setlength{\evensidemargin}{.25 in}
\setlength{\marginparwidth}{0.07 true in}
\setlength{\topmargin}{-0.3 in}
\addtolength{\headheight}{1.84 pt}
\addtolength{\headsep}{0.25in}
\addtolength{\voffset}{0.7 in}
\setlength{\textheight}{8.5 true in}  % Height of text (including footnotes & figures)
\setlength{\textwidth}{6.0 true in}   % Width of text line.
\setlength{\parindent}{20 pt}   % Width of text line.
\widowpenalty=10000
\clubpenalty=10000
\@twosidetrue \@mparswitchtrue \def\ds@draft{\overfullrule 5pt}
\raggedbottom

%% Pagestyle
%% Defines the pagestyle for the title page.
%% Usage: \stacsheading{year}{pages}{city}
\ifproceedings
\def\stacsheading#1#2#3{\def\ps@firstpage{\let\@mkboth\@gobbletwo%
\def\@oddhead{%
\hbox{%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox{\textsf{Symposium on Theoretical Aspects of Computer 
    Science #1 (#3), pp. #2}\hfil}
    %\hbox{\textsf{Vol.~#1 (#2), pp. #3}}
    \hbox{\textsf{www.stacs-conf.org}}
    \rlap{\vrule width\hsize depth .4 pt}}}\hfill
    }
\def\@evenhead{}\def\@evenfoot{}}%
\thispagestyle{firstpage}}

\def\endfront@text{%
\insert\copyins{\hsize\textwidth
      \fontsize{6}{7\p@}\normalfont\upshape
      \vskip-1cm\noindent
\hbox{
{\includegraphics[height=1.2cm]{STACS-logo-full.eps}}}
\hfill
\hbox{
  \vbox{\fontsize{6}{8 pt}\vss%\baselineskip=6 pt\vss
    \hbox{\textsf{\,\,\copyright\quad \shortauthors}\hfil}
    \hbox{\cC\ \textsf{Creative Commons Attribution-NoDerivs License}\hfil}}}
}%
}
% \def\endfront@text{}

\def\enddoc@text{\nobreak%
\insert\copyins{\hsize.57\textwidth
\vbox to 0pt{%
      \fontsize{6}{7\p@}\normalfont\upshape
      \everypar{}%
      \noindent
  \textsf{This work is licensed under the Creative Commons
  Attribution-NoDerivs License. To view a copy of this license, visit
  \url{http://creativecommons.org/licenses/by-nd/3.0/}.}\vss}
      \par
      \kern\z@}%
}
% \def\enddoc@text{}
\else
\def\stacsheading#1#2#3{\def\ps@firstpage{\let\@mkboth\@gobbletwo%
\def\@oddhead{%
\hbox{%
  \vbox to 30 pt{\scriptsize\vfill
    \hbox{\textsf{Submitted to the Symposium on Theoretical Aspects of Computer 
    Science}\hfil}
    %\hbox{\textsf{Vol.~#1 (#2), pp. #3}}
    \hbox{\textsf{www.stacs-conf.org}}
    \rlap{\vrule width\hsize depth .4 pt}}}\hfill
    }
\def\@evenhead{}\def\@evenfoot{}}%
\thispagestyle{firstpage}}

\def\endfront@text{%
\insert\copyins{\hsize\textwidth
      \fontsize{6}{7\p@}\normalfont\upshape
      \vskip-1cm\noindent
\hbox{
{\includegraphics[height=1.2cm]{STACS-logo-full.eps}}}
\hfill
\hbox{
  \vbox{\fontsize{6}{8 pt}\vss%\baselineskip=6 pt\vss
    \hbox{\textsf{\copyright\quad \shortauthors}\hfil}
    \hbox{\textsf{Confidential --- submitted to STACS}\hfil}}}
}%
}
% \def\endfront@text{}

\def\enddoc@text{\nobreak%
\insert\copyins{\hsize.69\textwidth
\vbox to 0pt{%
      \fontsize{6}{7\p@}\normalfont\upshape
      \everypar{}%
  \noindent \textsf{If accepted for publication by STACS, this work
  will be licensed under the Creative Commons Attribution-NoDerivs
  License.  To view a copy of this license, visit
  \url{http://creativecommons.org/licenses/by-nd/3.0/}.}\vss} \par
      \kern\z@}%
}
% \def\enddoc@text{}
\fi

%% Defines the pagestyle for the rest of the pages
%% Usage: \ShortHeadings{Minimizing Conflicts}{Minton et al}
%%	  \ShortHeadings{short title}{short authors}

\def\firstpageno#1{\setcounter{page}{#1}}
\def\ShortHeadings#1#2{\def\ps@stacsps{\let\@mkboth\@gobbletwo%
\def\@oddhead{\hfill {\small\sc #1} \hfill}%
\def\@oddfoot{\hfill \small\rm \thepage \hfill}%
\def\@evenhead{\hfill {\small\sc #2} \hfill}%
\def\@evenfoot{\hfill \small\rm \thepage \hfill}}%
\pagestyle{stacsps}}

%% MISCELLANY

\def\@startsection#1#2#3#4#5#6{\bigskip%
 \if@noskipsec \leavevmode \fi
 \par \@tempskipa #4\relax
 \@afterindenttrue
 \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
 \if@nobreak \everypar{}\else
     \addpenalty\@secpenalty\addvspace\@tempskipa\fi
 \@ifstar{\@dblarg{\@sect{#1}{\@m}{#3}{#4}{#5}{#6}}}%
	 {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}%
}

\def\@secnumfont{}
\def\section{\@startsection{section}{1}%
  \z@{.7\linespacing\@plus\linespacing}{.5\linespacing}%
  {\large\bfseries}}

\def\subsection{\@startsection{subsection}{2}%
  \z@{.5\linespacing\@plus\linespacing}{.5\linespacing}%
  {\normalfont\bfseries}}


\def\figurecaption#1#2{\noindent\hangindent 40pt
		       \hbox to 36pt {\small\sl #1 \hfil}
		       \ignorespaces {\small #2}}
% Figurecenter prints the caption title centered.
\def\figurecenter#1#2{\centerline{{\sl #1} #2}}
\def\figurecenter#1#2{\centerline{{\small\sl #1} {\small #2}}}

%
%  Allow ``hanging indents'' in long captions
%
\long\def\@makecaption#1#2{
   \vskip 10pt 
   \setbox\@tempboxa\hbox{#1: #2}
   \ifdim \wd\@tempboxa >\hsize               % IF longer than one line:
       \begin{list}{#1:}{
       \settowidth{\labelwidth}{#1:}
       \setlength{\leftmargin}{\labelwidth}
       \addtolength{\leftmargin}{\labelsep}
	}\item #2 \end{list}\par   % Output in quote mode
     \else                                    %   ELSE  center.
       \hbox to\hsize{\hfil\box\@tempboxa\hfil}  
   \fi}


% Define strut macros for skipping spaces above and below text in a
% tabular environment.
\def\abovestrut#1{\rule[0in]{0in}{#1}\ignorespaces}
\def\belowstrut#1{\rule[-#1]{0in}{#1}\ignorespaces}

%%% Theorem environments

% the following environments switch to a slanted font:
\theoremstyle{plain}

\newtheorem{thm}{Theorem}[section]
\newtheorem{theorem}[thm]{Theorem}
\newtheorem{cor}[thm]{Corollary}
\newtheorem{corollary}[thm]{Corollary}
\newtheorem{lem}[thm]{Lemma}
\newtheorem{lemma}[thm]{Lemma}
\newtheorem{prop}[thm]{Proposition}
\newtheorem{proposition}[thm]{Proposition}
\newtheorem{asm}[thm]{Assumption}
\newtheorem{assumption}[thm]{Assumption}

% the following environments keep the roman font:
\theoremstyle{definition}

\newtheorem{rem}[thm]{Remark}
\newtheorem{remark}[thm]{Remark}
\newtheorem{rems}[thm]{Remarks}
\newtheorem{remarks}[thm]{Remarks}
\newtheorem{exa}[thm]{Example}
\newtheorem{example}[thm]{Example}
\newtheorem{exas}[thm]{Examples}
\newtheorem{examples}[thm]{Examples}
\newtheorem{defi}[thm]{Definition}
\newtheorem{definition}[thm]{Definition}
\newtheorem{conv}[thm]{Convention}
\newtheorem{convention}[thm]{Convention}
\newtheorem{conj}[thm]{Conjecture}
\newtheorem{conjecture}[thm]{Conjecture}
\newtheorem{prob}[thm]{Problem}
\newtheorem{problem}[thm]{Problem}
\newtheorem{oprob}[thm]{Open Problem}
\newtheorem{algo}[thm]{Algorithm}
\newtheorem{obs}[thm]{Observation}
\newtheorem{observation}[thm]{Observation}
\newtheorem{qu}[thm]{Question}

\numberwithin{equation}{section}

% end-of-proof sign, to appear at right margin
% Paul Taylor and Chris Thompson, Cambridge, 1986
%
\def\pushright#1{{%        set up
   \parfillskip=0pt            % so \par doesn't push #1 to left
   \widowpenalty=10000         % so we dont break the page before #1
   \displaywidowpenalty=10000  % ditto
   \finalhyphendemerits=0      % TeXbook exercise 14.32
  %
  %                 horizontal
   \leavevmode                 % \nobreak means lines not pages
   \unskip                     % remove previous space or glue
   \nobreak                    % don't break lines
   \hfil                       % ragged right if we spill over
   \penalty50                  % discouragement to do so
   \hskip.2em                  % ensure some space
   \null                       % anchor following \hfill
   \hfill                      % push #1 to right
   {#1}                        % the end-of-proof mark (or whatever)
  %
  %                   vertical
   \par}}                      % build paragraph

%% \def\qEd{{\lower1 pt\hbox{\vbox{\hrule\hbox{\vrule\kern4 pt
%%     \vbox{\kern4 pt\hbox{\hss}\kern4 pt}\kern4 pt\vrule}\hrule}}}}
\def\qEd{\rule{1ex}{1ex}}
\def\qed{\pushright{\qEd}
    \penalty-700 \par\addvspace{\medskipamount}}

\newenvironment{Proof}[1][\proofname]{\par
  \pushQED{\qed}%
  \normalfont \topsep6\p@\@plus6\p@\relax
  \trivlist
  \item[\hskip\labelsep
	\itshape
    #1]\ignorespaces
}{%
  \popQED\endtrivlist\@endpefalse
}
% Bibliographystyle

\bibliographystyle{alpha}

\endinput
