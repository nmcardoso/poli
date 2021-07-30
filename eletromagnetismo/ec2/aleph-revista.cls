%% --> Identificación de la clase
\NeedsTeXFormat{LaTeX2e}[2009/09/24]
\ProvidesClass{aleph-revista}[2021/05/12 v0.1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- Inicialización
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\@autor{}
\newcommand\@titulo{}
\newcommand\@tituloingles{}
\newcommand\@institucion{}
\newcommand\@correo{}
\newcommand\@fecha{}
\newcommand\@resumen{}
\newcommand\@abstract{}
\newcommand\@palabrasc{}
\newcommand\@keywords{}
\newcommand\@sangria{1.2em}
\newcommand\@volumen{}
\newcommand\@numero{}
\newcommand\@fechapubli{}
\newcommand\@periodouno{}
\newcommand\@periododos{}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- Opciones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Opciones borrador
\DeclareOption{draft}{\PassOptionsToClass{draft}{article}}
%%  Opciones de tama\~no de letra.
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}
% %% --> Declaración de un solo lado 
% \DeclareOption{oneside}{\PassOptionsToClass{oneside}{book}}
% %% --> Declaración de tamaños de página
\DeclareOption{a4}{
    \PassOptionsToPackage{paperwidth=210mm,paperheight=297mm,right=2.5cm,left=2.5cm,top=2 cm,bottom=2.25cm,headsep=10pt,
  headheight=28pt}{geometry}}
%% --> Declaración de doble columna 
% \DeclareOption{twocolumn}{
%     \PassOptionsToClass{twocolumn}{book}}
%%  Opciones predeterminadas son a4, 11pt, oneside
\ExecuteOptions{a4,11pt}
\ProcessOptions\relax
\LoadClass{article}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- Paquetes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Son necesarios los siguientes paquetes para dar formato al documento.
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[brazilian]{babel}
\RequirePackage{geometry}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{enumitem}
\RequirePackage{graphicx}
\RequirePackage[colorlinks,allcolors=.,breaklinks]{hyperref}
\AtBeginDocument{\urlstyle{sf}}
\RequirePackage{xcolor}
\RequirePackage{float}
\RequirePackage{fontawesome} 
\RequirePackage{titlesec} 
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
\RequirePackage{tocbasic}
\RequirePackage{nextpage}
\RequirePackage{booktabs}
\RequirePackage{mathpazo}
\RequirePackage[font={small},labelfont={color=seccolor,bf,small},
  justification=centerlast]{caption}
\RequirePackage{listings}
\RequirePackage{tcolorbox}
\RequirePackage[portuguese,onelanguage,vlined,linesnumbered]{algorithm2e}
\renewcommand{\algocf@captiontext}[2]{\textcolor{seccolor}{#1:} \small#2} 

\renewcommand{\@titleprefix}{%
    \refstepcounter{\algocf@float}%
    \AlTitleSty{\AlTitleFnt\@algocf@titleofalgoname\ \expandafter\csname the\algocf@float\endcsname\algocf@typo: }%
  }%
\RequirePackage{etoolbox}
\RequirePackage[babel]{csquotes}
% \RequirePackage[style=apa,backend=biber]{biblatex}
\usepackage[citestyle=authoryear,natbib=true,backend=bibtex]{biblatex}
% \DeclareLanguageMapping{spanish}{spanish-apa}
\DefineBibliographyStrings{spanish}{%
  andothers = {et al\adddot},
}
\DefineBibliographyExtras{spanish}
    {\setcounter{smartand}{1}% or some other value
     \let\lbx@finalnamedelim=\lbx@es@smartand
     \let\lbx@finallistdelim=\lbx@es@smartand}

\DefineBibliographyExtras{spanish}{%
  \setcounter{smartand}{1}%
  \renewbibmacro*{name:delim:apa:family-given}[1]{%
    \ifnumgreater{\value{listcount}}{\value{liststart}}
      {\ifboolexpr{
         test {\ifnumless{\value{listcount}}{\value{liststop}}}
         or
         test \ifmorenames
      }
         {\printdelim{multinamedelim}}
         {\lbx@finallistdelim{#1}}}
      {}}%
}
\setlength{\bibhang}{\@sangria}  
        
%% Nuevos comandos
\newcommand{\asoimat}{\textsc{a}\hspace{-0.2ex}\textsc{s}\hspace{-0.19ex}\textsc{o}\textit{i}\textsc{m}\hspace{-0.16ex}\textsc{a}\hspace{-0.5ex}\textsc{t}%
}
\newcommand{\cencabezado}{\rule{\textwidth}{2pt}}
\newcommand{\autor}[1]{\renewcommand\@autor{\bfseries #1}}
\newcommand{\titulo}[1]{\renewcommand\@titulo{\bfseries #1}}
\newcommand{\tituloingles}[1]{\renewcommand\@tituloingles{\bfseries #1}}
\newcommand{\institucion}[1]{\renewcommand\@institucion{#1}}
\newcommand{\correo}[1]{\renewcommand\@correo{#1}}
\newcommand{\fecha}[1]{\renewcommand\@fecha{#1}}
\newcommand{\resumen}[1]{\renewcommand\@resumen{#1}}
\newcommand{\palabrasc}[1]{\renewcommand\@palabrasc{#1}}
\renewcommand{\abstract}[1]{\renewcommand\@abstract{#1}}
\newcommand{\keywords}[1]{\renewcommand\@keywords{#1}}
\newcommand{\volumen}[1]{\renewcommand\@volumen{#1}}
\newcommand{\numero}[1]{\renewcommand\@numero{#1}}
\newcommand{\fechapubli}[1]{\renewcommand\@fechapubli{#1}}
\newcommand{\periodouno}[1]{\renewcommand\@periodouno{#1}}
\newcommand{\periododos}[1]{\renewcommand\@periododos{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Estilos de títulos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --> Estilo de secciones numeradas
\titleformat{name=\section}[display]
  {\color{seccolor}\vspace*{-10mm}\bfseries\scshape\centering}
    {}{1ex}
    {\Large\titlerule%\vspace{.3ex}
    \thesection.\
     }
    [\vspace{.9ex}\titlerule]
%% --> Estilo de secciones no numeradas
\titleformat{name=\section,numberless}[display]
  {\color{seccolor}\vspace*{-10mm}\bfseries\scshape\centering}
    {}{1ex}
    {\Large\titlerule\vspace{.3ex}
     }
    [\vspace{.9ex}\titlerule]
%% --> Estilo de subsecciones numeradas
\titleformat{\subsection}
    {\color{sseccolor}\normalfont\Large\bfseries\scshape}{\thesubsection.}{1em}{}
%% --> Estilo de subsecciones no numeradas
\titleformat{name=\subsection,numberless}[display]
    {\color{sseccolor}\large\bfseries\scshape}
    {}{0ex}{}[]
%% --> Estilo de subsubsecciones numeradas
\titleformat{\subsubsection}
    {\color{sseccolor}\large\bfseries}{\thesubsubsection}{1em}{}
%% Espacios de los títulos
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{10pt}
%% Modificación del nivel de la tabla de contenidos
\setcounter{tocdepth}{2}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Definición de comandos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Encabezado y pie de p\'agina
\pagestyle{fancy}
\fancyhf{}
\fancyhead[R]{\bfseries\nouppercase{\textit{N. M. Cardoso}}}
\fancyhead[L]{\bfseries\nouppercase{PTC3213 - Eletromagnetismo}}
\renewcommand{\headrulewidth}{.2pt}
\renewcommand{\footrulewidth}{0pt}
\addtolength{\headheight}{.1pt}
\fancyfoot[C]{\thepage}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Memebrete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\membrete{%
    \vspace*{-14.5mm}
    \noindent\rule{\textwidth}{2pt}
    \vspace*{-12mm}
    \begin{center}
    
    \ifdefstrequal{\@tituloingles}{}{
    \Huge\bfseries\scshape\@titulo
    }{
    \Huge\bfseries\scshape\@titulo\\
    \Large \itshape \@tituloingles   
    }%
    \end{center}
    \vspace*{-6mm}
    \rule{\textwidth}{0.8pt}
    
    \begin{center}\color{seccolor}
    \@autor
    \end{center}
    
    \begin{flushleft}\small
    \begingroup
    \itshape
    \@institucion
    \endgroup\\[2mm]
    % \faEnvelopeO\ \@correo\\[2mm]
    \textcolor{seccolor}{\textbf{Professor:}} Murilo Hiroaki Seko \\[2mm]
    \textcolor{seccolor}{\textbf{Data de submissão:}} \@fecha
    \end{flushleft}
    
    \begingroup
    \small
    \ifdefstring{\@abstract}{}{\small
    % \noindent\textcolor{seccolor}{\textbf{\textsc{Resumo:}}} \@resumen\\[1mm]
    % \noindent\textcolor{seccolor}{\textbf{Palabras clave:}} \@palabrasc
    }{
    % \noindent\textcolor{seccolor}{\textbf{\textsc{Resumo:}}} \@resumen\\[1mm]
    % \noindent\textcolor{seccolor}{\textbf{Palabras clave:}} \@palabrasc 
    
    \noindent\textcolor{seccolor}{\textbf{\textsc{Resumo:}}} \@abstract%\\[1mm]
    % \noindent\textcolor{seccolor}{\textbf{Key Words:}} \@keywords
    }%
    
    \endgroup
    \noindent\rule{\textwidth}{2pt}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Variables internas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  La siguiente es la lista de las variables internas utilizadas para el formato.
\newcommand\@interlineado{1.2}
\newcommand\@espaciop{0.5em}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- Colores predeterminados
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\definecolor{sseccolor}{HTML}{1c3d6f}
\definecolor{seccolor}{HTML}{1c3d6f}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Definici\'on de comandos de datos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Interlineado
\newcommand{\interlineado}[1]{\renewcommand\@interlineado{#1}}
%% Espaciado entre párrafos
\newcommand{\espaciop}[1]{\renewcommand\@espaciop{#1}}
%% Sangria
\newcommand{\sangria}[1]{\renewcommand\@sangria{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% --- Estilo p\'agina
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Modificaci\'on del título de las referencias
% \renewcommand\bibname{Referencias}
%%  Interlineado
\renewcommand{\baselinestretch}{\@interlineado}
%% Numeraci\'on de las secciones y subsecciones
\renewcommand{\thesection}{\arabic{section}} 
\renewcommand{\thesubsection}{\arabic{section}.\arabic{subsection}} 
%% Modificaci\'on de las etiquetas de enumeraciones
\renewcommand{\labelenumiii}{\roman{enumiii}.}
%% Espaciado de listas y enumeraciones
\setlist[itemize]{noitemsep, topsep=-5pt, listparindent=\parindent}
\setlist[enumerate]{noitemsep,topsep=-5pt, listparindent=\parindent}
%% Definiciones de medidas
\setlength{\parindent}{\@sangria}
\setlength{\parskip}{\@espaciop}
%% Estilo de contadores de tabla
\renewcommand\thetable{\arabic{table}}
\renewcommand\thefigure{\arabic{figure}}
\renewcommand\theequation{\arabic{equation}}
%% Modificación de la bibliografía
\renewcommand*{\nameyeardelim}{\addcomma\space}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Definici\'on de ambientes matemáticos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newtheoremstyle{estiloteorema}%
    {9pt}{9pt}{\slshape}{0pt}{\color{seccolor}\bfseries\scshape}{.}{ }{}
\theoremstyle{estiloteorema}
\newtheorem{teo}{Teorema}
\newtheorem{prop}{Proposición}
\newtheorem{lem}{Lema}
\newtheorem{axioma}{Axioma}
% \theoremstyle{definition}
\newtheorem{defi}{Definción}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Definici\'on de ambiente para algoritmos y códigos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\lstset{
  basicstyle=\scriptsize\sffamily,
  numberstyle=\color{gray},
  stringstyle=\color[HTML]{933797},
  commentstyle=\color[HTML]{228B22}\sffamily,
  showstringspaces=false,
  breaklines=true,
  prebreak=\mbox{{\color{gray}\tiny$\searrow$}},
  numbers=left,
  xleftmargin=15pt,
  inputencoding=utf8,
  extendedchars=true,
  literate={á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1,
}
\SetKwProg{Fn}{Función}{\string:}{}
\SetAlFnt{\footnotesize}
\SetAlCapNameFnt{\small}
\SetAlCapFnt{\small}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Otros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\lstlistingname}{Código}
\newcommand{\email}[1]{\href{mailto:#1}{\nolinkurl{#1}}}
\endinput