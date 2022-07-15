\NeedsTeXFormat{LaTeX2e}[2009/09/24]
\ProvidesClass{horizon-theme}[v0.2]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}
\DeclareOption{a4}{\PassOptionsToPackage{paperwidth=210mm,paperheight=297mm,right=1.5cm,left=1.5cm,top=2cm,bottom=2.5cm,headsep=10pt,headheight=25pt}{geometry}}
\ExecuteOptions{a4,12pt}
\ProcessOptions\relax
\LoadClass{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{etex}
\RequirePackage[brazil]{babel}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage[most]{tcolorbox}
\RequirePackage{setspace}
\RequirePackage{lmodern}
\RequirePackage{mathpazo}
\RequirePackage{color}
\RequirePackage{xcolor}
\RequirePackage{calc}
\RequirePackage{printlen}
\RequirePackage{eso-pic}
\RequirePackage{adjustbox}
\RequirePackage{transparent}
\RequirePackage{afterpage}
\RequirePackage{xcolor}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{ragged2e}
\RequirePackage[symbol,bottom]{footmisc}
\RequirePackage[letterspace=400]{microtype}
\RequirePackage{amsmath}
\RequirePackage{textcomp}
\RequirePackage{amssymb}
\RequirePackage{indentfirst}
\RequirePackage{hyperref}
\RequirePackage{framed}
\RequirePackage{caption}
\RequirePackage{booktabs}

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
    \transparent{0.185}\includegraphics[keepaspectratio, angle=0]{\@coverBgLogo}
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
    \vspace*{-26mm}
    \begin{flushright}
      \includegraphics[width=0.97\linewidth]{\@compactRightLogo}
    \end{flushright}
  \end{minipage}

  \noindent\rule{\linewidth}{4pt}
  \begin{minipage}{0.9\textwidth}
    \vspace*{12mm}
    \noindent{\LARGE\RaggedRight \@title}
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

\captionsetup[subfigure]{%
name={\noindent\rule[0pt]{4pt}{8.5pt}\hspace{3pt}Figura},%
labelfont={color=secondaryColor,bf},%
justification=centering,%
singlelinecheck=true%
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
\hypersetup{
  colorlinks,
  linkcolor={primaryColor!90!white!85!blue},
  citecolor={primaryColor!90!white!85!blue},
  urlcolor={primaryColor!90!white!85!blue}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CUSTOM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\definecolor{mypurple}{RGB}{115,0,125}
\newcommand{\n}[1]{\overline{#1}}
\newcommand{\configCover}[3]{%
    \setFiguresPath{.}
    \setTitle{#3}
    \setUniversity{Universidade de São Paulo}
    \setFaculty{Escola Politécnica}
    \setDepartment{Departamento de Eng. de Computação e Sistemas Digitais}
    \setCoverMainLogo{minerva.pdf}
    \setCompactAuthors{Natanael Magalhães Cardoso, Renato Naves Fleury}
    \setHeaderRight{Escola Politécnica}
    \setHeaderLeft{PCS3335 - Laboratório Digital A}
    \setCoverLeftBox{%
      {\Large Experimento \##1}\\[2pt]
      {PCS3335 - Laboratório Digital A}\\[2pt]
      {#2}\\[45pt]
      {\large Natanael Magalhães Cardoso, 8914122}\\[5pt]
      {\large Renato Naves Fleury, 11805269}\\[45pt]
      {\normalsize Professor: }{\large Glauber de Bona}\\[5pt]
      {\normalsize Turma: }{\large 10}\\[5pt]
      {\normalsize Bancada: }{\large B3}\\[5pt]
    }%   
}
\newcommand{\carimboA}[1]{%
\setlength{\tabcolsep}{2pt}%
\renewcommand{\arraystretch}{0.75}%
\begin{tabular}{|ll|ll|}\hline
    \rowcolor{white}\tiny\sffamily\color{mypurple} Disciplina & \multicolumn{3}{l|}{\scriptsize\sffamily\color{mypurple} PCS3335 - Laboratório Digital A}\\\hline
    \rowcolor{white}\tiny\sffamily\color{mypurple} Professor & \multicolumn{3}{l|}{\scriptsize\sffamily\color{mypurple} Glauber de Bona}\\\hline
    \rowcolor{white}\tiny\sffamily\color{mypurple} Projeto & \multicolumn{3}{l|}{\scriptsize\sffamily\color{mypurple} #1}\\\hline
    \rowcolor{white}\tiny\sffamily\color{mypurple} Turma & \scriptsize\sffamily\color{mypurple} 10\hspace{60pt} & \tiny\sffamily\color{mypurple} Bancada & \scriptsize\sffamily\color{mypurple} 03\\\hline
    \rowcolor{white}\tiny\sffamily\color{mypurple} Membros & \multicolumn{3}{l|}{\scriptsize\sffamily\color{mypurple} N.M. Cardoso; R.N. Fleury}\\\hline
\end{tabular}%
}
\newcommand{\carimboB}[1]{%
\setlength{\tabcolsep}{2pt}%
\renewcommand{\arraystretch}{0.75}%
    \csvreader[head to column names, late after line=\\, table foot=\hline, before table=\scriptsize\sffamily, tabular=|llll|, table head=\hline\rowcolor{white}\bfseries\color{mypurple} Posição & \bfseries\color{mypurple} Comp. & \bfseries\color{mypurple} Vcc & \bfseries\color{mypurple} Gnd\\]{#1}{}%
    {\cellcolor{white}\color{mypurple}\csvcoli & \cellcolor{white}\color{mypurple}\csvcolii & \cellcolor{white}\color{mypurple}\csvcoliii & \cellcolor{white}\color{mypurple}\csvcoliv}%
}