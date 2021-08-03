# Compila o grafo para pdf

# make > 3.8
.DEFAULT_GOAL := svg


all:
	dot -Tsvg materias.gv -o materias.svg
	dot -Tpdf materias.gv -o materias.pdf

svg:
	dot -Tsvg materias.gv -o materias.svg


pdf:
	dot -Tpdf materias.gv -o materias.pdf
