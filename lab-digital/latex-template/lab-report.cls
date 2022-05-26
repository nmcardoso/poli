\NeedsTeXFormat{LaTeX2e}[2009/09/24]
\ProvidesClass{lab-report}[v0.0.1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{article}}
\DeclareOption{a4}{\PassOptionsToPackage{paperwidth=210mm,paperheight=297mm,right=3cm,left=3cm,top=3cm,bottom=3cm,headsep=10pt,headheight=25pt}{geometry}}
\ExecuteOptions{a4, 12pt}
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
% \RequirePackage{mathpazo} % font
% \RequirePackage{times} % font
% \RequirePackage{helvet}
% \renewcommand{\familydefault}{\sfdefault}
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
\RequirePackage{sectsty}
\RequirePackage{secdot}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\definecolor{primary}{RGB}{0, 100, 255}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Attributes & Accessor Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\setExpTitle#1{\def\@expTitle{#1}}
\def\setExpNumber#1{\def\@expNumber{#1}}
\def\setTeacher#1{\def\@teacher{#1}}
\def\setBancada#1{\def\@bancada{#1}}
\def\setTurma#1{\def\@turma{#1}}
\def\setDate#1{\def\@date{#1}}
\newcommand\setMemberOne[2]{\def\@memberOne{#1}\def\@nuspOne{#2}}
\newcommand\setMemberTwo[2]{\def\@memberTwo{#1}\def\@nuspTwo{#2}}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\frontpage}{
  \titlepage
  \begin{center}
    \large
    \begin{tabular}{|ll|}
      \hline
      {\bf Disciplina:} PCS 3335 - Laboratório Digital A & {}\\
      \hline
      {\bf Prof.:} \@teacher & {\bf Data:} \@date\\
      \hline
      {\bf Turma:} \@turma & {\bf Bancada:} \@bancada\\
      \hline
      {\bf Membros:} & {}\\
      \hline
      \@memberOne, nUSP: \@nuspOne & {}\\
      \hline
      \@memberTwo, nUSP: \@nuspTwo & {}\\
      \hline
    \end{tabular}
  \end{center}
  
  \vfill

  \begin{center}
    \includegraphics[width=0.4\textwidth]{poli}
  \end{center}

  \vfill

  \begin{center}
    \LARGE%
    \color{primary}%
    \bf
    Experiência \@expNumber\\[3mm]
    \@expTitle
  \end{center}

  \vfill
  
  \newpage
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fancy Style
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[R]{\thepage}

% Section Colors
\sectionfont{\color{primary}}
\subsectionfont{\color{primary}}
\subsubsectionfont{\color{primary}}

% Section dot
\sectiondot{subsection}
\sectiondot{subsubsection}

% hyperlinks
\hypersetup{
  colorlinks,
  linkcolor={blue!50!black},
  citecolor={blue!50!black},
  urlcolor={blue!80!black}
}

% Arabic footnotes
\renewcommand*{\thefootnote}{\arabic{footnote}}
