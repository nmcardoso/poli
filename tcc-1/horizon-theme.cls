\NeedsTeXFormat{LaTeX2e}[2009/09/24]
\ProvidesClass{horizon-theme}[v0.2]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}
\DeclareOption{a4}{\PassOptionsToPackage{a4paper, left=3cm, right=1.5cm, top=2.5cm, bottom=2.5cm, headsep=10pt, headheight=25pt}{geometry}}
\ExecuteOptions{a4,12pt}
\ProcessOptions\relax
\LoadClass{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{etex}
\RequirePackage[brazilian]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{csquotes}
\RequirePackage[style=authoryear-comp, natbib=true, backend=biber, maxcitenames=2]{biblatex}
\RequirePackage[hyperref, svgnames, x11names, table, dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage[most]{tcolorbox}
\RequirePackage{setspace}
\RequirePackage{xspace}
\RequirePackage{xcolor}
\RequirePackage{color}
\RequirePackage{calc}
\RequirePackage{printlen}
\RequirePackage{eso-pic}
\RequirePackage{adjustbox}
\RequirePackage{transparent}
\RequirePackage{afterpage}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{ragged2e}
\RequirePackage[symbol,bottom]{footmisc}
\RequirePackage[letterspace=400]{microtype}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{textcomp}
\RequirePackage{indentfirst}
\RequirePackage{framed}
\RequirePackage{caption}
\RequirePackage{booktabs}
\RequirePackage{lipsum}
\RequirePackage{fontawesome5}
\RequirePackage{booktabs}
\RequirePackage{makecell}
\RequirePackage{array}
\RequirePackage{multirow}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{siunitx}
\RequirePackage{enumerate}
\RequirePackage{gensymb}
\RequirePackage{url}
\RequirePackage{float}
\RequirePackage{pdfpages}
% \RequirePackage[round]{natbib}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage[most]{tcolorbox}
\RequirePackage[normalem]{ulem}
\RequirePackage{MnSymbol}
\RequirePackage[
    unicode=true,
    pdfencoding=unicode,
    plainpages=false,
    pdfpagelabels,
    bookmarksopen=true,
    breaklinks=true,
    %hyperfootnotes=false, % polui desnecessariamente com bordercolor
    hyperindex=false,
]{hyperref}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Font Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V1 Fonts
% \RequirePackage[scale=1.0]{sourcecodepro}
% \RequirePackage[mono=false]{mathpazo}

% V2 Fonts
% Uma boa fonte teletype
\RequirePackage[scale=0.85]{sourcecodepro}

% Uma ótima opção de família para o corpo do texto é a libertinus,
% similar (mas não igual) à Times, mas com suporte a Small Caps e
% outras qualidades. A fonte teletype da família é serifada, então
% é melhor definir outra; a opção "mono=false" faz o pacote não
% carregá-la, mantendo a escolha anterior.
\RequirePackage[mono=false]{libertinus}

\ifPDFTeX
    % A família libertinus por padrão não define uma fonte matemática
    % específica para pdfLaTeX; uma opção que funciona bem com ela:
    %\RequirePackage[libertine]{newtxmath}
    % Outra, provavelmente melhor:
    \RequirePackage[scale=1]{libertinust1math}
\fi

% Com LuaLaTeX/XeLaTeX, Libertinus configura também
% a fonte matemática; aqui só precisamos corrigir \mathit
\ifLuaTeX
    \setmathfontface\mathit{Libertinus Serif Italic}
\fi
\ifXeTeX
    % O nome de arquivo da fonte mudou na versão 2019-04-04
    \@ifpackagelater{libertinus-otf}{2019/04/03}
    {\setmathfontface\mathit{LibertinusSerif-Italic.otf}}
    {\setmathfontface\mathit{libertinusserif-italic.otf}}
\fi
\RequirePackage[fontsize=14pt]{scrextend}

% Vamos lembrar destas configurações
\let\LibertinusSerifFont\rmdefault
\let\LibertinusSansFont\sfdefault
\let\SourceCodeProFont\ttdefault
\let\LibertinusMDDefault\mddefault
\let\LibertinusBFDefault\bfdefault
\let\LibertinusUPdefault\updefault
\let\LibertinusITdefault\itdefault
\let\LibertinusSCdefault\scdefault
\let\LibertinusFamily\familydefault
\let\LibertinusSeries\seriesdefault
\let\LibertinusShape\shapedefault
% \let\LibertinusMDrm\mdseries@rm
% \let\LibertinusMDsf\mdseries@sf
% \let\LibertinusMDtt\mdseries@tt
% \let\LibertinusBFrm\bfseries@rm
% \let\LibertinusBFsf\bfseries@sf
% \let\LibertinusBFtt\bfseries@tt

% \RequirePackage{ebgaramond}

% Este comando é definido pela package url, que é carregada automaticamente
% por hyperref; ele faz URLs com fonte sem serifa ao invés de teletype
\urlstyle{sf}

% Melhorias e personalização do sublinhado com soul (comando \ul)
% \setul{1.4pt}{.5pt} % Distância e largura do sublinhado

% TODO: talvez usar "em" ao invés de pt?
% btul -> "Better Underline" (https://alexwlchan.net/2017/10/latex-underlines/ )
% Sublinhado sem cruzar as linhas descendentes dos caracteres
\RequirePackage[outline]{contour}
\contourlength{1.1pt}
\newcommand{\btul}[2][white]{%
    \contourlength{1.1pt}%
    \setul{1.4pt}{.5pt}%
    \ul{{\phantom{#2}}}% Faz o sublinhado; precisa das chaves adicionais!
    \llap{\contour{#1}{#2}}% Escreve o texto com fundo branco/colorido
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Attributes & Accessor Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shared Attributes
\def\setTitle#1{\def\@title{#1}}
\def\setUniversity#1{\def\@university{#1}}
\def\setFaculty#1{\def\@faculty{#1}}
\def\setDepartment#1{\def\@department{#1}}
\def\setAbstract#1{\def\@abstract{#1}}
\def\setFiguresPath#1{\def\@figuresPath{#1}}

% Cover Attributes
\def\setCoverTitle#1{\def\@coverTitle{#1}}
\def\setCoverMainLogo#1{\def\@coverMainLogo{#1}}
\def\setCoverBgLogo#1{\def\@coverBgLogo{#1}}
\def\setCoverLeftBox#1{\def\@coverLeftBox{#1}}
\def\setCoverRightBox#1{\def\@coverRightBox{#1}}

% Back Cover Attributes
\def\setBackCoverMainLogo#1{\def\@backCoverMainLogo{#1}}

% Compact Title Attributes
\def\setCompactLeftLogo#1{\def\@compactLeftLogo{#1}}
\def\setCompactRightLogo#1{\def\@compactRightLogo{#1}}
\def\setCompactAuthors#1{\def\@compactAuthors{#1}}
\def\setCompactInfo#1{\def\@compactInfo{#1}}

% Header Attributes
\def\setHeaderRight#1{\def\@headerRight{#1}}
\def\setHeaderLeft#1{\def\@headerLeft{#1}}

% Color Attributes
\newcommand\setPrimaryColor[2]{\definecolor{primaryColor}{#1}{#2}}
\newcommand\setSecondaryColor[2]{\definecolor{secondaryColor}{#1}{#2}}
\newcommand\setAccentColor[2]{\definecolor{accentColor}{#1}{#2}}

% Measures
\def\setBaseLineStretch#1{\def\@baseLineStretch{#1}}
\def\setParIndent#1{\setlength{\parindent}{#1}}
\def\setParSkip#1{\setlength{\parskip}{#1}}
\def\setBaseLineStretch#1{\renewcommand{\baselinestretch}{#1}}

\newcommand{\printTitle}{\@coverTitle}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shared Attributes
\setTitle{Report Title}
\setUniversity{University}
\setFaculty{Faculty}
\setDepartment{Department}
\setAbstract{Abstract}
\setFiguresPath{figures}

% Cover
\setCoverTitle{\@title}
\setCoverMainLogo{\@figuresPath/minerva.pdf}
\setCoverBgLogo{\@figuresPath/usp_pb.pdf}
\setCoverLeftBox{%
  {\large Techinical Report}\\[35pt]
  {\Large Natanael Magalhães Cardoso}\\[10pt]
}
\setCoverRightBox{%
  {\bf\Large \@university}\\[12pt]
  {\large \@faculty}\\[12pt]
  {\large \@department}
}

% Back Cover
\setBackCoverMainLogo{\@figuresPath/usp_branco.png}

% Compact Tittle
\setCompactLeftLogo{\@coverMainLogo}
\setCompactRightLogo{\@figuresPath/usp.pdf}
\setCompactAuthors{Natanael Magalhães Cardoso}
\setCompactInfo{Some Info}

% Header
\setHeaderRight{Right Header}
\setHeaderLeft{Left Header}

% Colors
\setPrimaryColor{RGB}{5, 52, 60}
\setAccentColor{RGB}{229, 138, 14}
\setSecondaryColor{HTML}{1c3d6f}

% Measures
\setBaseLineStretch{1.2}
\setParSkip{0.5em}
\setParIndent{1.2em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\thefootnote}{\arabic{footnote}}
\newcommand\fnAuthor[1]{%
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
  \footnote{#1}%
  \renewcommand{\thefootnote}{\arabic{footnote}}%
}

\newcommand\doubleRuleSep{%
  \setlength\doublerulesep{1.1pt}%
}

\newcommand\doubleTopRule{%
  \toprule[1.5pt]\midrule[0.3pt]%
}

\newcommand\doubleBottomRule{%
  \midrule[0.3pt]\toprule[1.5pt]%
}


% \horizonCover command
\newcommand\horizonCover{
  \titlepage
  \newgeometry{margin=0in}
%
% https://tex.stackexchange.com/q/463555
% https://tex.stackexchange.com/q/436017
% https://tex.stackexchange.com/q/99444
  \AddToShipoutPictureBG*{%
    \adjustbox{min width=0.5\paperwidth, max width={!}, min height={!}, max height=0.4\paperheight, viewport={0.45\width} {0.5\height} {1\width} {1\height},clip}{%
    \transparent{0.185}\includegraphics[keepaspectratio, angle=0]{figures/usp_pb.pdf}
    }
  }
%
  \newsavebox{\titlebox}
  \sbox{\titlebox}{\fcolorbox{accentColor}{accentColor}{%
  \noindent\begin{minipage}{\paperwidth}
    \centering
    \vspace*{10pt}
    \begin{minipage}{0.85\linewidth}
      \centering\setstretch{0.75}
      \fontsize{22}{36}\rmfamily\color{white}\textsc \@coverTitle
    \end{minipage}
    \vspace*{10pt}
  \end{minipage}}}
%
  \noindent\begin{minipage}{0.55\linewidth}
    \hspace*{0.2in}
    \includegraphics[width=1.6in]{\@coverMainLogo}
    \vspace*{-0.7in}
  \end{minipage}%
  \begin{minipage}{0.45\linewidth}
    \setlength{\fboxsep}{0pt}%
    \colorbox{primaryColor}{\parbox{\linewidth}{\vspace{2.7in}}\hspace*{\linewidth}}%
    \vspace{-1.1pt}
    \setlength{\fboxsep}{10pt}
    \setlength{\fboxrule}{0pt}
  \end{minipage}\\
%
  \usebox\titlebox
%
  \setlength{\fboxsep}{0pt}
  \noindent\begin{minipage}[t]{0.55\linewidth}
    \vspace*{-2.7in}
    \hspace*{0.25in}\begin{minipage}{0.9\linewidth}
      \@coverLeftBox
    \end{minipage}
  \end{minipage}
  \begin{minipage}{0.45\linewidth}
    \newsavebox{\lateralbox}
    \sbox{\lateralbox}{\begin{minipage}{0.85\linewidth}
      \color{white}\flushleft
      \@coverRightBox
    \end{minipage}}
    \colorbox{primaryColor}{
    \parbox{\linewidth}{\vspace{4.8in}
    \hspace*{4pt}
    \usebox\lateralbox\\
    \newlength{\lateralboxheight}
    \settoheight\lateralboxheight{\usebox\lateralbox}
    \vspace*{\dimexpr(\textheight-2.7in-4.8in-\ht\titlebox-\dp\titlebox-\ht\lateralbox-\dp\lateralbox)\relax}
    }}%
  \end{minipage}
  \restoregeometry
}

% \horizonBackCover command
\newcommand\horizonBackCover{
  \newpage%
  \thispagestyle{empty}%
  \newgeometry{margin=0in}%
  \noindent\colorbox{primaryColor}{%
  \parbox[]{\paperwidth}{\begin{minipage}[c][0.7\paperheight]{\paperwidth}
    \centering
    \includegraphics[width=0.6\textwidth, height=0.6\textwidth, keepaspectratio]{\@backCoverMainLogo} 
  \end{minipage}}
  }
  \noindent\colorbox{black}{
    \parbox{\paperwidth}{%
      \begin{minipage}[c][0.3\paperheight]{\paperwidth}
        \centering\color{white}
        {\bf\large \@university}\\[10pt]
        {\large \@faculty}\\[10pt]
        {\large \@department}
      \end{minipage}%
    }%
  }%
  \restoregeometry
}

% \horizonTitle command
\newcommand\horizonTitle{%
  \thispagestyle{plain}%
  \vspace*{0.1cm}%
  \noindent\begin{minipage}{0.84\linewidth}%
    \vspace*{-14.5mm}%
    \noindent\makebox[\linewidth]{\color{black!65}\rule{\dimexpr\linewidth-6pt\relax}{0.4pt}}
    \vspace*{-12mm}
    \vspace*{9mm}
  
    \begin{minipage}{0.19\linewidth}
      \includegraphics[width=\linewidth]{\@compactLeftLogo}
    \end{minipage}%
    \hfill%
    \noindent\fcolorbox{gray!25}{gray!25}{%
      \begin{minipage}{0.77\linewidth}
        \centering
        \vspace*{6pt}
        {\bf\Large\textsc{\@university}}\\[8pt]
        {\bf\large\textsc{\@faculty}}\\[8pt]
        {\@department}
        \vspace*{6pt}
      \end{minipage}}
    \vspace*{1mm}
  \end{minipage}%
  \hfill%
  \begin{minipage}[t]{0.142\linewidth}
    \vspace*{-27mm}
    \begin{flushright}
      \includegraphics[width=\linewidth]{\@compactRightLogo}
    \end{flushright}
  \end{minipage}

  \noindent\rule{\linewidth}{4pt}
  \begin{minipage}{1\textwidth}
    \vspace*{10mm}
    \noindent{\LARGE\RaggedRight\begin{spacing}{1.1}\@title\end{spacing}}
    \vspace*{4mm}
  \end{minipage}

  \noindent{\normalsize\RaggedRight \@compactAuthors}
}

% \horizonAbstract command
\newcommand\horizonAbstract{%
  \noindent{\color{black!65}\rule{\linewidth}{0.4pt}}\\[12pt]
  \parbox{\linewidth}{
    \begin{minipage}[t]{0.35\linewidth}
      {\lsstyle INFO}\\[-11pt]
      \noindent\makebox[\linewidth]{\color{gray}\rule{\linewidth}{0.4pt}}
      \@compactInfo
    \end{minipage}%
    \hfill%
    \begin{minipage}[t]{0.6\linewidth}
      {\lsstyle RESUMO}\\[-11pt]
      \noindent\makebox[\linewidth]{\color{gray}\rule{\linewidth}{0.4pt}}
      \@abstract
    \end{minipage}
  }\\[12pt]
  \noindent{\color{black!65}\rule{\linewidth}{0.4pt}}\\
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Styles Overcharge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\captionsetup[figure]{%
name={\noindent\rule[0pt]{4pt}{8.5pt}\hspace{3pt}Figura},%
labelfont={color=secondaryColor,bf},%
justification=justified,%
singlelinecheck=false%
}

\captionsetup[table]{%
name={\noindent\rule[0pt]{4pt}{8.5pt}\hspace{3pt}Tabela},%
labelfont={color=secondaryColor,bf},%
justification=justified,%
singlelinecheck=false%
}

% Header
\pagestyle{fancy}
\fancyhf{}
\fancyhead[R]{\bfseries\nouppercase{\textit{\@headerRight}}}
\fancyhead[L]{\bfseries\nouppercase{\@headerLeft}}
\renewcommand{\headrulewidth}{.2pt}
\renewcommand{\footrulewidth}{0pt}
\addtolength{\headheight}{.1pt}
\fancyfoot[C]{\thepage}

% Section
\titleformat{name=\section}[display]
  {\color{secondaryColor}\vspace*{-10mm}\bfseries\scshape\centering}
  {}{1ex}
  {\Large\titlerule\thesection.{ }}
  [\vspace{.6ex}\titlerule]
\titleformat{name=\section,numberless}[display]
  {\color{secondaryColor}\vspace*{-10mm}\bfseries\scshape\centering}
  {}{1ex}
  {\Large\titlerule}
  [\vspace{.6ex}\titlerule]

% Subsection
\titleformat{\subsection}
  {\color{secondaryColor}\normalfont\Large\bfseries\scshape}
  {\thesubsection.}{1em}{}
\titleformat{name=\subsection,numberless}[display]
  {\color{secondaryColor}\large\bfseries\scshape}
  {}{0ex}{}[]

% Subsubsection
\titleformat{\subsubsection}
  {\color{secondaryColor}\large\bfseries}{\thesubsubsection}{1em}{}

% Spacing
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{6pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{10pt}
\setlist[itemize]{noitemsep, topsep=-5pt, listparindent=\parindent}
\setlist[enumerate]{noitemsep, topsep=-5pt, listparindent=\parindent}
\setlength{\skip\footins}{18pt}

% Numeration
\renewcommand{\thesection}{\arabic{section}} 
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}}
\renewcommand{\labelenumiii}{\roman{enumiii}.}
\renewcommand\thetable{\arabic{table}}
\renewcommand\thefigure{\arabic{figure}}
\renewcommand\theequation{\arabic{equation}}

% Hyperlinks
\definecolor{defaultlinkcolor}{HTML}{1A3280}
\hypersetup{
  colorlinks,
  linkcolor=defaultlinkcolor,
  citecolor=defaultlinkcolor,
  urlcolor=defaultlinkcolor,
  % linkcolor={primaryColor!70!white!75!Blue},
  % citecolor={primaryColor!70!white!75!Blue},
  % urlcolor={primaryColor!70!white!75!Blue},
  allbordercolors=white,
}


% Citation
\renewcommand{\mkbibnamefamily}[1]{\textsc{#1}}
\renewcommand{\mkbibnamegiven}[1]{\textsc{#1}}
\DeclareCiteCommand{\cite}
  {\usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
   \printtext[bibhyperref]{\usebibmacro{cite}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

\DeclareCiteCommand*{\cite}
  {\usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
   \printtext[bibhyperref]{\usebibmacro{citeyear}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

\DeclareCiteCommand{\parencite}[\mkbibparens]
  {\usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
    \printtext[bibhyperref]{\usebibmacro{cite}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

\DeclareCiteCommand*{\parencite}[\mkbibparens]
  {\usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
    \printtext[bibhyperref]{\usebibmacro{citeyear}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

\DeclareCiteCommand{\footcite}[\mkbibfootnote]
  {\usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
  \printtext[bibhyperref]{ \usebibmacro{cite}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

\DeclareCiteCommand{\footcitetext}[\mkbibfootnotetext]
  {\usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
   \printtext[bibhyperref]{\usebibmacro{cite}}}
  {\multicitedelim}
  {\usebibmacro{postnote}}

\DeclareCiteCommand{\textcite}
  {\boolfalse{cbx:parens}}
  {\usebibmacro{citeindex}%
   \printtext[bibhyperref]{\usebibmacro{textcite}}}
  {\ifbool{cbx:parens}
     {\bibcloseparen\global\boolfalse{cbx:parens}}
     {}%
   \multicitedelim}
  {\usebibmacro{textcite:postnote}}
