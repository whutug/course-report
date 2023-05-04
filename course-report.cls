%%
%%  Copyright (C) 2023 WHUTUG <https://github.com/whutug>
%% 
%%  This work may be distributed and/or modified under the
%%  conditions of the LaTeX Project Public License, either
%%  version 1.3c of this license or (at your option) any later
%%  version. The latest version of this license is in:
%% 
%%    http://www.latex-project.org/lppl.txt
%% 
%%  and version 1.3 or later is part of all distributions of
%%  LaTeX version 2008 or later.
%% 
%%  This work has the LPPL maintenance status `maintained'.
%% 
%%  The Current Maintainer of this work is Anbo Tao <hgwxtyz6910@gmail.com>.
%%
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3 , xparse , l3keys2e}
\ProvidesExplClass{course-report}{2023/02/05}{0.1}{course report template}

\msg_new:nnn { course-report } { engine-error }
  {
    Engine~ "#1"~ is~ not~ supported!\\\\
    This~ template~ requires~ either~ XeTeX~ or~ LuaTeX.
  }

\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      {
        \msg_fatal:nnx { course-report } { engine-error }
          { \c_sys_engine_str }
      }
  }

\sys_if_engine_xetex:T { \RequirePackage { etoolbox } }

%% 文档选项
\tl_new:N \g__csrep_option_codepkg_tl
\tl_new:N \g__csrep_option_theme_tl
\bool_new:N \g__csrep_option_twoside_bool
\bool_new:N \g__csrep_option_draft_bool

\clist_new:N \g__csrep_option_to_class_clist
\clist_gset:Nn \g__csrep_option_to_class_clist { fontset = none, a4paper }

\keys_define:nn { csrep / option }
  {
    codepkg .choices:nn = 
      { listings, minted, none }
      { \tl_gset_eq:NN \g__csrep_option_codepkg_tl \l_keys_choice_tl },
    codepkg .value_required:n = true,
    codepkg .initial:n        = none,

    theme .choices:nn =
      { fancy, plain }
      { \tl_gset_eq:NN \g__csrep_option_theme_tl \l_keys_choice_tl },
    theme .value_required:n = true,
    theme .initial:n        = fancy,

    zihao .choices:nn =
      { -4, 5 }
      { \clist_gput_right:Nx \g__csrep_option_to_class_clist { zihao = \l_keys_choice_tl } },

    oneside .value_forbidden:n = true,
    twoside .value_forbidden:n = true,
    oneside .code:n            =
      {
        \bool_gset_false:N   \g__csrep_option_twoside_bool
        \clist_gput_right:Nn \g__csrep_option_to_class_clist { oneside }
      },
    twoside .code:n            =
      {
        \bool_gset_true:N    \g__csrep_option_twoside_bool
        \clist_gput_right:Nn \g__csrep_option_to_class_clist { openright, twoside }
      },
    
    onecolumn .value_forbidden:n = true,
    twocolumn .value_forbidden:n = true,
    onecolumn .code:n            =
      {
        \clist_gput_right:Nn \g__csrep_option_to_class_clist { onecolumn }
      },
    twocolumn .code:n            =
      {
        \clist_gput_right:Nn \g__csrep_option_to_class_clist { twocolumn }
      },
    
    draft-graph .value_forbidden:n = true,
    draft-graph .code:n            =
      {
        \PassOptionsToPackage { draft } { graphicx }
      },

    draft .value_forbidden:n = true,
    draft .code:n            =
      {
        \bool_gset_true:N \g__csrep_option_draft_bool
        \clist_gput_right:Nn \g__csrep_option_to_class_clist { draft }
      }
  }
\ProcessKeysOptions { csrep / option }

\PassOptionsToPackage { no-math } { fontspec }

\PassOptionsToClass { \g__csrep_option_to_class_clist } { ctexrep }
\LoadClass { ctexrep }

\cs_new_protected:Npn \__csrep_clear_page:
  {
    \bool_if:NTF \g__csrep_option_twoside_bool
      { \cleardoublepage }
      { \clearpage }
  }


\tl_if_eq:NnT \g__csrep_option_theme_tl { fancy }
  {
    \ctexset
      {
        chapter =
          {
            number     = \arabic{chapter},
            beforeskip = 15pt,
            afterskip  = 25pt,
          },
        section =
          {
            name        = { \S },
            format      = \Large \normalfont \centering,
            titleformat = \sffamily,
            nameformat  = \bfseries,
          },
        subsubsection/format += \fbox,
      }
  }

%% 页面格式
\RequirePackage { geometry, fancyhdr, lastpage }
\RequirePackage [ dvipsnames ] { xcolor }
\geometry { 
  top        = 30mm,
  bottom     = 30mm,
  left       = 25mm,
  right      = 25mm,
  headheight = 2cm,
  headsep    = 4mm,
  footskip   = 12mm
}
\AtEndPreamble
  {
    \RequirePackage [ colorlinks ] { hyperref }
    \hypersetup
      {
        linkcolor       = BrickRed,
        citecolor       = Green,
        filecolor       = Mulberry,
        urlcolor        = NavyBlue,
        menucolor       = BrickRed,
        runcolor        = Mulberry,
        linkbordercolor = BrickRed,
        citebordercolor = Green,
        filebordercolor = Mulberry,
        urlbordercolor  = NavyBlue,
        menubordercolor = BrickRed,
        runbordercolor  = Mulberry,
        linktoc         = page
      }
  }
\tl_if_eq:NnT \g__csrep_option_theme_tl { fancy }
  {
    \fancypagestyle { plain }
      {
        \fancyhf { }
        \cfoot { -- \ \thepage / \pageref* { LastPage } \ -- }
        \renewcommand { \headrulewidth } { 0pt }
      }
    \fancypagestyle { frontpage }
      {
        \fancyhf { }
        \cfoot { -- \ \roman { page } \ -- }
        \renewcommand { \headrulewidth } { 0pt }
      }
    \bool_if:NTF \g__csrep_option_twoside_bool
      {
        \fancypagestyle { fancy }
          {
            \fancyhf { }
            \renewcommand { \headrulewidth } { 0.5pt }
            \fancyhead [ CO ] { { \itshape \leftmark } }
            \fancyhead [ CE ] { { \itshape \rightmark } }
            \cfoot { -- \ \thepage / \pageref* { LastPage } \ -- }
          }
      }
      {
        \fancypagestyle { fancy }
          {
            \fancyhf { }
            \renewcommand { \headrulewidth } { 0.5pt }
            \chead { { \itshape \leftmark } }
            \cfoot { -- \ \thepage / \pageref* { LastPage } \ -- }
          }
      }
  }
\tl_if_eq:NnT \g__csrep_option_theme_tl { plain }
  {
    \fancypagestyle { frontpage }
      { \fancyhf{} \renewcommand { \headrulewidth } { 0pt } }
    \fancypagestyle { fancy }
      { \fancyhf{} \pagestyle { headings } }
  }


%% 定义字体

\cs_new_protected:Npn \__csrep_set_font_default: { }
\cs_new_protected:Npn \__csrep_set_font_times:
  { \setmainfont { Times~ New~ Roman } }
\cs_new_protected:Npn \__csrep_set_font_xits:
  {
    \setmainfont { XITS }
      [
        Extension      = .otf,
        UprightFont    = * - Regular,
        BoldFont       = * - Bold,
        ItalicFont     = * - Italic,
        BoldItalicFont = * - BoldItalic
      ]
  }
\cs_new_protected:Npn \__csrep_set_font_termes:
  {
    \setmainfont { texgyretermes }
      [
        Extension      = .otf,
        UprightFont    = * - regular,
        BoldFont       = * - bold,
        ItalicFont     = * - italic,
        BoldItalicFont = * - bolditalic
      ]
  }
\cs_new_protected:Npn \__csrep_set_font_pagella:
  {
    \setmainfont { texgyrepagella }
      [
        Extension      = .otf,
        UprightFont    = * - regular,
        BoldFont       = * - bold,
        ItalicFont     = * - italic,
        BoldItalicFont = * - bolditalic
      ]
  }
\cs_new_protected:Npn \__csrep_set_font_libertinus:
  {
    \setmainfont { LibertinusSerif }
      [
        Extension      = .otf,
        UprightFont    = * - Regular,
        BoldFont       = * - Bold,
        ItalicFont     = * - Italic,
        BoldItalicFont = * - BoldItalic
      ]
  }
\cs_new_protected:Npn \__csrep_set_font_xcharter:
  {
    \setmainfont { XCharter }
      [
        Extension       = .otf,
        UprightFont     = * - Roman,
        BoldFont        = * - Bold,
        ItalicFont      = * - Italic,
        BoldItalicFont  = * - BoldItalic,
        SlantedFont     = * - Slanted,
        BoldSlantedFont = * - BoldSlanted
      ]
  }

\cs_new_protected:Npn \__csrep_set_math_font_default: { }
\cs_new_protected:Npn \__csrep_set_math_font_xits:
  {
    \setmathfont { XITSMath-Regular.otf } [ BoldFont = XITSMath-Bold.otf ]
  }
\cs_new_protected:Npn \__csrep_set_math_font_termes:
  {
    \setmathfont { texgyretermes-math.otf }
  }
\cs_new_protected:Npn \__csrep_set_math_font_pagella:
  {
    \setmathfont { texgyrepagella-math.otf }
  }
\cs_new_protected:Npn \__csrep_set_math_font_libertinus:
  {
    \setmathfont { LibertinusMath-Regular.otf } [Scale=MatchLowercase]
  }
\cs_new_protected:Npn \__csrep_set_math_font_xcharter:
  {
    \setmathfont { XCharter-Math.otf }
  }

\cs_new_protected:Npn \__csrep_set_cjk_font: {}
\cs_new_protected:Npn \__csrep_set_cjk_main_font:nn #1#2
  {
    \setCJKmainfont { #1 } [ #2 ]
    \newCJKfontfamily [ zhsong ] \songti { #1 } [ #2 ]
  }
\cs_new_protected:Npn \__csrep_set_cjk_sans_font:nn #1#2
  {
    \setCJKsansfont { #1 } [ #2 ]
    \newCJKfontfamily [ zhhei ] \heiti { #1 } [ #2 ]
  }
\cs_new_protected:Npn \__csrep_set_cjk_font_kaishu:nn #1#2
  {
    \newCJKfontfamily [ zhkai ] \kaishu { #1 } [ #2 ]
  }
\cs_new_protected:Npn \__csrep_set_cjk_mono_font:nn #1#2
  {
    \setCJKmonofont { #1 } [ #2 ]
    \newCJKfontfamily [ zhfs ] \fangsong { #1 } [ #2 ]
  }
\cs_new_protected:Npn \__csrep_set_cjk_font_sourcehan:
  {
    \__csrep_set_cjk_main_font:nn { Source~ Han~ Serif~ SC }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__csrep_set_cjk_sans_font:nn { Source~ Han~ Sans~ SC }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__csrep_set_cjk_font_kaishu:nn { FZKai-Z03 }
      {
        BoldFont       = *,
        ItalicFont     = *,
        BoldItalicFont = *
      }
    \__csrep_set_cjk_mono_font:nn { FZFangSong-Z02 } 
      {
        BoldFont       = *,
        ItalicFont     = *,
        BoldItalicFont = *
      }
  }
\cs_new_protected:Npn \__csrep_set_cjk_font_none: { }

\keys_define:nn { csrep / style }
  {
    font .choices:nn =
      { times, xits, xcharter, termes, pagella, libertinus, default }
      { \cs_gset_eq:Nc \__csrep_set_font: { __csrep_set_font_ \l_keys_choice_tl : } },
    font .value_required:n = true,
    font .initial:n = default,

    math-font .choices:nn =
      { xits, xcharter, termes, pagella, libertinus, default }
      { \cs_gset_eq:Nc \__csrep_set_math_font: { __csrep_set_math_font_ \l_keys_choice_tl : } },
    math-font .value_required:n = true,
    math-font .initial:n = default,

    cjk-font .choices:nn =
      { adobe, fandol, founder, mac, macnew, macold, ubuntu, windows, none, sourcehan }
      { 
        \tl_if_in:NnTF \l_keys_choice_tl { sourcehan }
          {
            \cs_gset_eq:Nc \__csrep_set_cjk_font: { __csrep_set_cjk_font_ \l_keys_choice_tl : }
          }
          {
            \exp_args:Nx \ctexset { fontset = \l_keys_choice_tl } 
          }
      },
    cjk-font .value_required:n = true,
    % cjk-font .initial:n = ctex
  }

\hook_gset_rule:nnnn { begindocument/before } { . } { < } { xeCJK }

% 在导言区末加载字体，保证其不被用户配置覆盖
\AtEndPreamble
  {
    \RequirePackage [ warnings-off = { mathtools-colon, mathtools-overbracket }, bold-style = ISO ] 
      { unicode-math }
    \__csrep_set_font:
    \__csrep_set_math_font:
    \__csrep_set_cjk_font:
  }

% 其他设置
\keys_define:nn { csrep / style }
  {
    graphics-path .code:n = { \graphicspath { #1 } },

    punct .choices:nn =
      { quanjiao, banjiao, kaiming, CCT }
      { \tl_gset_eq:NN \g__csrep_style_punct_tl \l_keys_choice_tl },
    punct .value_required:n = true,
    punct .initial:n        = quanjiao,
    punct .code:n = { \ctexset { punct = #1 } },

    today .choices:nn =
      { small, big, old }
      { \tl_gset_eq:NN \g__csrep_style_today_tl \l_keys_choice_tl },
    today .value_required:n = true,
    today .initial:n        = small,
    today .code:n = { \ctexset { today = #1 } },

    enname .value_forbidden:n = true,
    enname .code:n = 
      {
        \ctexset
          {
            contentsname    = Contents,
            listfigurename  = List~ of~ Figures,
            listtablename   = List~ of~ Tables,
            figurename      = Figure,
            tablename       = Table,
            abstractname    = Abstract,
            indexname       = Index,
            appendixname    = Appendix,
            bibname         = References,
            proofname       = Proof,
            part/name       = { Part\space },
            chapter/name    = { Chapter\space },
          }
      },

    fullwidth-stop .value_forbidden:n = true,
    fullwidth-stop .code:n =
      {
        \char_set_catcode_active:n { `。 }
        \char_set_active_eq:nN { `。 } ．
      },

    two-column-toc .value_forbidden:n = true,
    two-column-toc .code:n =
      {
        \RequirePackage{multicol}
        \renewcommand\cfttocprehook{\begin{multicols}{2}}
        \renewcommand\cfttocposthook{\end{multicols}}
      }
  }

%% 封面
% \bool_if:NTF \g__csrep_option_draft_bool 
%   {
%     \RequirePackage [draft] { graphicx }
%   }
%   {
%     \RequirePackage { graphicx }
%   }
\RequirePackage { graphicx }
\tl_new:N \g__csrep_info_csnumber_tl
\tl_new:N \g__csrep_info_cstype_tl
\tl_new:N \g__csrep_info_title_tl
\tl_new:N \g__csrep_info_subtitle_tl
\tl_new:N \g__csrep_info_badge_tl
\tl_new:N \g__csrep_info_academy_tl
\tl_new:N \g__csrep_info_major_tl
\tl_new:N \g__csrep_info_teacher_tl
\tl_new:N \g__csrep_info_class_tl
\tl_new:N \g__csrep_info_name_tl
\tl_new:N \g__csrep_info_id_tl
\tl_new:N \g__csrep_info_date_tl
\clist_new:N \g__csrep_info_addinfo_clist
\keys_define:nn { csrep / info }
  {
    csnumber .tl_gset:N    = \g__csrep_info_csnumber_tl,
    cstype   .tl_gset:N    = \g__csrep_info_cstype_tl,
    title    .tl_gset:N    = \g__csrep_info_title_tl,
    subtitle .tl_gset:N    = \g__csrep_info_subtitle_tl,
    badge    .tl_gset:N    = \g__csrep_info_badge_tl,
    academy  .tl_gset:N    = \g__csrep_info_academy_tl,
    major    .tl_gset:N    = \g__csrep_info_major_tl,
    teacher  .tl_gset:N    = \g__csrep_info_teacher_tl,
    class    .tl_gset:N    = \g__csrep_info_class_tl,
    name     .tl_gset:N    = \g__csrep_info_name_tl,
    id       .tl_gset:N    = \g__csrep_info_id_tl,
    date     .tl_gset:N    = \g__csrep_info_date_tl,
    addinfo  .clist_gset:N = \g__csrep_info_addinfo_clist,
  }
% 分散对齐函数
\cs_generate_variant:Nn \tl_map_inline:nn { x n }
\cs_new:Npn \__csrep_spread:x #1
  { \tl_map_inline:xn { #1 } { ##1 \hfill } \unskip }
% 添加信息函数
\cs_new:Npn \__csrep_info_add_tab:xx #1#2
  { \__csrep_spread:x { #1 } ： & \itshape~ #2 \\ [ -1mm ] \cline { 2-2 } }
\clist_new:N \l__csrep_info_addinfo_tmp_clist
% 创建封面
\cs_new_protected:Npn \__csrep_make_cover:
  {
    \begin { titlepage }
      \newgeometry { margin = 0in, onecolumn }
      \dim_set_eq:NN \parindent \c_zero_dim
      \dim_set_eq:NN \parskip \c_zero_dim
      \vspace* { 2cm }
      \group_begin:
        \zihao { -3 } \ttfamily 
        \hspace* { 2.5cm } 课程编号：\g__csrep_info_csnumber_tl \hfill 课程性质：\g__csrep_info_cstype_tl \hspace* { 2.5cm }
      \group_end:
      \vspace { 0pt plus 1.5fill }
      \tl_if_empty:NF \g__csrep_info_badge_tl
        {
          \begin { figure } [ h ]
          \centering
          \includegraphics [ width = 0.5\linewidth ] { \g__csrep_info_badge_tl }
          \end { figure }
        }
      \vspace { 0pt plus 1fill }
      \begin { center }
        \vbox:n 
          { 
            \centering \leavevmode \Huge \hbox~ spread~ 1em { \g__csrep_info_title_tl } \par
            \sffamily \huge \g__csrep_info_subtitle_tl
          }
      \end { center }
      \vspace { 0pt plus 1fill }
      \begin { center }
        \zihao { -2 }
        \begin { tabular } { c c }
          \tl_if_empty:NF \g__csrep_info_academy_tl
            { \__csrep_info_add_tab:xx { 学院 } { \g__csrep_info_academy_tl } }
          \tl_if_empty:NF \g__csrep_info_major_tl
            { \__csrep_info_add_tab:xx { 专业 } { \g__csrep_info_major_tl } }
          \tl_if_empty:NF \g__csrep_info_teacher_tl
            { \__csrep_info_add_tab:xx { 教师 } { \g__csrep_info_teacher_tl } }
          \tl_if_empty:NF \g__csrep_info_class_tl
            { \__csrep_info_add_tab:xx { 班级 } { \g__csrep_info_class_tl } }
          \tl_if_empty:NF \g__csrep_info_name_tl
            { \__csrep_info_add_tab:xx { 姓名 } { \g__csrep_info_name_tl } }
          \tl_if_empty:NF \g__csrep_info_id_tl
            { \__csrep_info_add_tab:xx { 学号 } { \g__csrep_info_id_tl } }
          \clist_if_empty:NF \g__csrep_info_addinfo_clist
            { 
              \clist_map_inline:Nn \g__csrep_info_addinfo_clist 
                {
                  \clist_gset:Nn \l__csrep_info_addinfo_tmp_clist { ##1 }
                  \__csrep_info_add_tab:xx
                    { \clist_item:Nn \l__csrep_info_addinfo_tmp_clist { 1 } }
                    { \clist_item:Nn \l__csrep_info_addinfo_tmp_clist { 2 } }
                }
            }
        \end { tabular }
      \end { center }
      \vspace { 0pt plus 1.5fill }
      \group_begin:
        \hfill \LARGE \g__csrep_info_date_tl \hfill
      \group_end:
      \vspace* { 3cm }
    \end { titlepage }
    \restoregeometry
    \__csrep_clear_page:
  }

%% 目录
\RequirePackage { tocloft }
\clist_map_inline:nn { toc , lof , lot }
  {
    \tl_set:cn { cft #1 title font } { \hfill \bfseries \zihao { 1 } }
    \tl_set:cn { cftafter #1 title } { \hfill }
    % 目录标题 黑体 1 号
    \clist_map_inline:nn { before , after }
      { \skip_zero:c { cft ##1 #1 title skip } }
  }
\skip_set:Nn \cftaftertoctitleskip { 0.5 \baselineskip }
\skip_set:Nn \cftbeforetoctitleskip { 0.5 \baselineskip }
\tl_set:Nn \cftsubsecnumwidth { 1em }
\tocloftpagestyle { frontpage }
% \cs_new_protected:Npn \__csrep_make_contents:
%   {
%     \__csrep_clear_page:
%     \pagestyle { frontpage }
%     \tableofcontents
%     \thispagestyle { frontpage }
%     \__csrep_clear_page:
%   }

%% 文档结构命令
% \AtBeginDocument{
%   \addtocontents { toc } { \protect \thispagestyle { frontpage } }
% }
\cs_set_protected:Npn \maketitle { \__csrep_make_cover: }
\cs_set_protected:Npn \cleardoublepage
  {
    \clearpage
    \if@twoside 
      \ifodd\c@page\else
      \begingroup
        \mbox{}
        \vspace*{\fill}
        \thispagestyle{empty}
        \newpage
        \if@twocolumn\mbox{}\newpage\fi
      \endgroup
      \fi
    \fi
  }

\bool_new:N \g__csrep_main_matter_bool

\cs_new_protected:Npn \frontmatter
  {
    \__csrep_clear_page:
    \bool_gset_false:N \g__csrep_main_matter_bool
    \pagenumbering { roman }
    \pagestyle { frontpage }
  }
\cs_new_protected:Npn \mainmatter
  {
    \__csrep_clear_page:
    \bool_gset_true:N \g__csrep_main_matter_bool
    \pagenumbering { arabic }
    \pagestyle { fancy }
  }
\cs_new_protected:Npn \backmatter
  {
    \__csrep_clear_page:
    \bool_gset_false:N \g__csrep_main_matter_bool
  }





%% 代码盒子
\tl_new:N \g__csrep_code_language_tl
\keys_define:nn { csrep / code }
  {
    language .tl_gset:N        = \g__csrep_code_language_tl,
    language .value_required:n = true,
    language .code:n           = {
      \def\kvtcb@minted@language{#1}
    }
  }

\tl_if_eq:NnF \g__csrep_option_codepkg_tl { none }
  {
    \RequirePackage { tcolorbox }
    \tcbuselibrary { xparse, skins, breakable }
    \cs_new:Npn \__csrep_define_color:nnn #1#2#3
      { \definecolor { #1 } { #2 } { #3 } }
    \tcbset
      {
        base/.style=
          {
            sharpish~ corners,
            enhanced,
            top          = 3pt,
            middle       = 3pt,
            bottom       = 3pt,
            boxrule    = 0pt,
            before~ skip = 0.5\baselineskip plus 0.1\baselineskip minus 0.1\baselineskip,
            after~ skip  = 0.5\baselineskip plus 0.1\baselineskip minus 0.1\baselineskip,
            toprule~ at~ break= 0pt,
            bottomrule~ at~ break = 0pt,
          }
      }
    \tl_if_eq:NnT \g__csrep_option_theme_tl { fancy }
      {
        \__csrep_define_color:nnn { border_color } { RGB } { 26, 40, 71 }
        \__csrep_define_color:nnn { back_color } { rgb } { 0.96, 0.96, 0.96 }
        \__csrep_define_color:nnn { line_number_color } { RGB } { 128, 0, 32 }
        \tcbset
          {
            common/.style=
              {
                base,
                colframe = border_color,
                colback  = back_color,
                toprule  = 4.5pt,
              }
          }
      }
    \tl_if_eq:NnT \g__csrep_option_theme_tl { plain }
      {
        \__csrep_define_color:nnn { border_color } { RGB } { 26, 40, 71 }
        \__csrep_define_color:nnn { back_color } { rgb } { 0.96, 0.96, 0.96 }
        \__csrep_define_color:nnn { line_number_color } { RGB } { 128, 0, 32 }
        \tcbset
          {
            common/.style=
              {
                base,
                toprule    = 0.5pt,
                bottomrule = 0.5pt,
                colframe   = border_color,
                colback    = back_color,
              }
          }
      }
  }
\tl_if_eq:NnT \g__csrep_option_codepkg_tl { listings }
  {
    \RequirePackage { listings }
    \tcbuselibrary { listings }
    \lstdefinestyle { common }
      {
        aboveskip        = 0pt,
        belowskip        = 0pt,
        numbers          = left, 
        numberstyle      = \footnotesize \color { line_number_color } \ttfamily,
        showspaces       = false,
        showtabs         = false,
        numbersep        = 3pt,
        showstringspaces = false,
        basicstyle       = \small \ttfamily,
        sensitive        = true,
        escapeinside     = {!@}{@!},
      }
    \exp_args:Nx \lstset { style = common, language = \g__csrep_code_language_tl }
  }
\tl_if_eq:NnT \g__csrep_option_codepkg_tl { minted }
  {
    \RequirePackage { minted }
    \tcbuselibrary { minted }
    \setminted {
      fontsize = \small, 
      linenos,
      numbersep=5pt, 
      escapeinside=||
    }
  }
\tl_if_eq:NnT \g__csrep_option_codepkg_tl { listings }
  {
    \DeclareTCBListing [ auto~ counter, number~ within = chapter ] { codebox } { O{}~ g~ t\label~ g }
      {
        common,
        enforce~ breakable,
        topsep~ at~ break = -1mm,
        listing~ engine = listings,
        IfValueTF = { #2 }
          {
            comment~ and~ listing,
            comment = { \sffamily \small ~ #2 }
          }
          {
            listing~ only
          },
        IfBooleanT = { #3 } { label = #4 },
        if~ odd~ page~ or~ oneside =
          {
            overlay =
            {
              \node [ anchor = south~ west, xshift = 1em, shape = rectangle, draw ] 
                at ( frame.south~ east ) { \footnotesize \thetcbcounter };
            }
          }
          {
            overlay =
            {
              \node [ anchor = south~ east, xshift = -1em, shape = rectangle, draw ] 
                at ( frame.south~ west ) { \footnotesize \thetcbcounter };
            }
          },
        listing~ options = {},
        #1
      }
    \DeclareTCBListing [ no~ counter ] { codebox* } { O{}~ g~ }
      {
        common,
        enforce~ breakable,
        topsep~ at~ break = -1mm,
        listing~ engine = listings,
        IfValueTF = { #2 }
          {
            comment~ and~ listing,
            comment = { \sffamily \small ~ #2 }
          }
          {
            listing~ only
          },
        listing~ options = {},
        #1
      }
    \DeclareTotalTCBox { \codeinline } { O{}~ m }
      {
        colback = back_color, verbatim, colframe = white, left = 0pt, right = 0pt
      }
      {
        \lstinline [ #1 ] ^#2^
      }
  }
\tl_if_eq:NnT \g__csrep_option_codepkg_tl { minted }
  {
    % 改变行号颜色
    \RenewDocumentCommand { \theFancyVerbLine } { } 
      { \textcolor{ line_number_color } { \tiny \sffamily \arabic { FancyVerbLine } } }
    \DeclareTCBListing [ auto~ counter, number~ within = chapter ] { codebox } { O{}~ g~ t\label~ g }
      {
        common,
        enforce~ breakable,
        topsep~ at~ break = -1mm,
        listing~ engine = minted,
        IfValueTF = { #2 }
          {
            comment~ and~ listing,
            comment = { \sffamily \small ~ #2 }
          }
          {
            listing~ only
          },
        IfBooleanT = { #3 } { label = #4 },
        if~ odd~ page~ or~ oneside =
          {
            overlay =
            {
              \node [ anchor = south~ west, xshift = 1em, shape = rectangle, draw ] 
                at ( frame.south~ east ) { \footnotesize \thetcbcounter };
            }
          }
          {
            overlay =
            {
              \node [ anchor = south~ east, xshift = -1em, shape = rectangle, draw ] 
                at ( frame.south~ west ) { \footnotesize \thetcbcounter };
            }
          },
        #1
      }
    \DeclareTCBListing [ no~ counter ] { codebox* } { O{}~ g~ }
      {
        common,
        enforce~ breakable,
        topsep~ at~ break = -1mm,
        listing~ engine = minted,
        IfValueTF = { #2 }
          {
            comment~ and~ listing,
            comment = { \sffamily \small ~ #2 }
          }
          {
            listing~ only
          },
        #1
      }
    \DeclareTotalTCBox { \codeinline } { O{}~ m~ m }
      {
        colback = back_color, verbatim, colframe = white, left = 0pt, right = 0pt
      }
      {
        \mintinline [ fontsize = \footnotesize, #1 ] { #2 } ^#3^
      }
  }
\AtEndPreamble
  { 
    \tl_if_eq:NnT \g__csrep_option_codepkg_tl { listings }
      {
        \tl_if_empty:NTF \g__csrep_code_language_tl
        {
          \lstset { style = common }
        }
        {
          \exp_args:Nx \lstset { style = common, language = \g__csrep_code_language_tl }
        }
      }
  }

%% 参考文献
\tl_new:N \g__csrep_bib_style_tl
\tl_new:N \g__csrep_bib_cite_style_tl
\clist_new:N \g__csrep_bib_bibliography_clist
\bool_new:N \g__csrep_bib_backend_bibtex_bool
\keys_define:nn { csrep / bib }
  {
    bibliography .clist_gset:N = \g__csrep_bib_bibliography_clist,

    backend .choice:,
    backend .value_required:n = true,
    backend / bibtex .code:n =
      { \bool_gset_true:N \g__csrep_bib_backend_bibtex_bool },
    backend / biblatex  .code:n =
      { \bool_gset_false:N \g__csrep_bib_backend_bibtex_bool },
    backend .initial:n = biblatex,

    style .choices:nn =
      { numerical, author-year, author-year-numbered }
      { \tl_gset_eq:NN \g__csrep_bib_style_tl \l_keys_choice_tl },
    style .value_required:n = true,
    style .initial:n        = numerical,
    
    cite-style .choices:nn =
      { numerical-super , numerical-inline , author-year }
      { \tl_gset_eq:NN \g__csrep_bib_cite_style_tl \l_keys_choice_tl },
    cite-style .value_required:n = true,
    cite-style .initial:n        = numerical-super,
  }

% biblatex 设置
\cs_new_protected:Npn \__csrep_bib_biblatex_pre_setup:
  {
    \clist_if_in:nVTF { numerical, author-year, author-year-numbered }
      \g__csrep_bib_style_tl
      {
        \tl_if_eq:NnTF \g__csrep_bib_style_tl { numerical }
          { \PassOptionsToPackage { bibstyle = gb7714-2015   } { biblatex } }
          { \PassOptionsToPackage { bibstyle = gb7714-2015ay } { biblatex } }
      }
      {
        \PassOptionsToPackage { bibstyle = \g__csrep_bib_style_tl } { biblatex }
      }
    \clist_if_in:nVTF { numerical-super , numerical-inline , author-year }
      \g__csrep_bib_cite_style_tl
      {
        \tl_if_eq:NnT \g__csrep_bib_cite_style_tl { numerical-inline }
          { \PassOptionsToPackage { citestyle = numeric-comp  } { biblatex } }
        \tl_if_eq:NnT \g__csrep_bib_cite_style_tl { numerical-super  }
          { \PassOptionsToPackage { citestyle = gb7714-2015   } { biblatex } }
        \tl_if_eq:NnT \g__csrep_bib_cite_style_tl { author-year }
          { \PassOptionsToPackage { citestyle = gb7714-2015ay } { biblatex } }
      }
      {
        \PassOptionsToPackage { citestyle = \g__csrep_bib_cite_style_tl }
          { biblatex }
      }
  }

\cs_new_protected:Npn \__csrep_bib_biblatex_post_setup:
  {
    \clist_if_empty:NF \g__csrep_bib_bibliography_clist
      { 
        \clist_map_function:NN \g__csrep_bib_bibliography_clist \addbibresource
      }
  }

% bibtex 设置
\msg_new:nnn { course-report } { cite-style~ invalid }
  {
    In~ the~ case~ of~ option~ ``bib/backend~ =~ bibtex'',\\
    ``bib/cite-style~ =~ #1''~ and~ ``bib/style~ =~ #2''~ cannot~ be~ used~ together!\\
    
    Please~ change~ option~ ``bib/style''~ or~ ``bib/cite-style'',~ or~ use~ ``bib/backend~ =~ biblatex''.
  }
\cs_new_protected:Npn \__csrep_bib_warning:
  {
    \msg_warning:nnxx { course-report } { cite-style~ invalid }
      { \g__csrep_bib_cite_style_tl }
      { \g__csrep_bib_style_tl }
  }

\cs_new_protected:Npn \__csrep_bib_bibtex_setup:
  {
    \clist_if_in:nVTF { numerical, author-year, author-year-numbered }
      \g__csrep_bib_style_tl
      {
        \tl_if_eq:NnTF \g__csrep_bib_style_tl { numerical }
          { 
            \RequirePackage [ sort & compress] { gbt7714 } 
            \bibliographystyle { gbt7714-numerical } 
            \clist_if_in:nVTF { numerical-super , numerical-inline }
              \g__csrep_bib_cite_style_tl
              {
                \tl_if_eq:NnT \g__csrep_bib_cite_style_tl { numerical-inline }
                  { \citestyle { numbers } }
              }
              { \__csrep_bib_warning: }
          }
          {
            \RequirePackage [ sort ] { gbt7714 } 
            \bibliographystyle { gbt7714-author-year } 
            \tl_if_eq:NnF \g__csrep_bib_cite_style_tl { author-year }
              { \__csrep_bib_warning: }
          }
        \skip_zero:N \bibsep
      }
      {
        \RequirePackage { natbib }
        \bibliographystyle { \g__csrep_bib_style_tl }
      }
  }

\BeforeBeginEnvironment { document }
  {
    \clist_if_empty:NF \g__csrep_bib_bibliography_clist
      {
        \bool_if:NTF \g__csrep_bib_backend_bibtex_bool
          {
            \__csrep_bib_bibtex_setup:
          }
          {
            \__csrep_bib_biblatex_pre_setup:
            \RequirePackage [ backend = biber ] { biblatex }
            \__csrep_bib_biblatex_post_setup:
          }
      }
  }

\cs_new_protected:Npn \__csrep_make_bibliography:
  {
    \clist_if_empty:NF \g__csrep_bib_bibliography_clist
      {
        \bool_if:NTF \g__csrep_bib_backend_bibtex_bool
          {
            \tl_if_eq:NnT \g__csrep_bib_style_tl { author-year-numbered }
              { \setcitestyle { numbers } }
            \exp_args:NV \bibliography \g__csrep_bib_bibliography_clist
          }
          {
            \tl_if_eq:NnTF \g__csrep_bib_style_tl { author-year-numbered }
              { \printbibliography [ heading = bibintoc , env = numerical ] }
              { \printbibliography [ heading = bibintoc ] }
          }
      }
  }

\cs_new:Npn \makebibliography { \__csrep_make_bibliography: }

% \AtEndEnvironment { document }
%   { \__csrep_make_bibliography: }

\keys_define:nn { csrep }
  {
    style .meta:nn = { csrep / style } { #1 },
    info  .meta:nn = { csrep / info } { #1 },
    bib   .meta:nn = { csrep / bib } { #1 },
    code  .meta:nn = { csrep / code } { #1 }
  }

\NewDocumentCommand { \csrepset } { m }
  { \keys_set:nn { csrep } {#1} }