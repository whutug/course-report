\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{course-report-doc}[2023/04/09 template for course-report doc]

\PassOptionsToPackage{fontset=none}{ctex}
\LoadClass{ctxdoc}

\setCJKmainfont{Source Han Serif SC}[
  UprightFont = *-Regular,
  BoldFont    = *-Bold,
  ItalicFont  = FZKai-Z03
]
\newCJKfontfamily[zhsong]\songti{Source Han Serif SC}[
  UprightFont = *-Regular,
  BoldFont    = *-Bold
]
\setCJKsansfont{Source Han Sans SC}[
  UprightFont = *-Regular,
  BoldFont    = *-Bold
]
\newCJKfontfamily[zhhei]\heiti{Source Han Sans SC}[
  UprightFont = *-Regular,
  BoldFont    = *-Bold
]
\setCJKmonofont{FZFangSong-Z02}[
  AutoFakeSlant = 0.1667
]
\newCJKfontfamily[zhfs]\fangsong{FZFangSong-Z02}
\newCJKfontfamily[zhkai]\kaishu{FZKai-Z03}
\setsansfont{Asap}[
  UprightFont = * Regular,
  BoldFont = * Bold,
  ItalicFont = * Italic
]
\setmonofont{Ubuntu Mono}[
  UprightFont = *-Regular,
  BoldFont = *-Bold,
  ItalicFont = *-Italic
]

\RequirePackage{listings,geometry,fancyhdr,tcolorbox}
\tcbuselibrary{listings,raster,breakable,skins}
\tcbset{listing engine=listings}
\lstset{
  frame=single,
  framerule=.6pt,
  framexleftmargin=3pt,
  basicstyle=\small\ttfamily,
  escapechar=|
}
\geometry{
  bottom=1in
}
\fancypagestyle{fancy}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \cfoot{\thepage}
}
\pagestyle{fancy}
\newcommand{\default}[1]{\textbf{\textup{#1}}}
\newcommand{\tnNoIdx}[1]{\tn[no-index]{#1}}
\tcbset{
  listing options={frame=none},
  righthand ratio=0.5,
  pdf comment,
  sharp corners,
  left=6pt,
  right=6pt,
  middle=3pt,
  bottom=0pt,
  top=0pt,
  boxsep=0pt,
  boxrule=.6pt,
  fontupper=\small,
  colframe=black,colback=white,
  inputlst/.style 2 args={
    listing side comment,
    listing file={#1},
    comment style={graphics pages={#2},colframe=gray}
  }
}

\newcommand{\bibtex}{Bib\TeX}
\newcommand{\biber}{biber}

\RequirePackage[sort&compress]{gbt7714}
\bibliographystyle{gbt7714-numerical}

\def\bibname{参考文献}
\renewenvironment{thebibliography}[1]
     {\section{\bibname}
      \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}

\newcommand{\urlprefix}{\newline\hbox{}\hfill}
\let\oldurl=\url
\renewcommand\url[1]{{\small\oldurl{#1}}}
\newcommand{\myurl}[2]{{\small {\kaishu #1}：\url{#2}}}
\newcommand\CTANurl[2]{{
   \small\textit{#1}：\href{https://mirror.ctan.org/#2}{\texttt{CTAN://#2}}}}

\RequirePackage[symbol]{footmisc}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}

\endinput