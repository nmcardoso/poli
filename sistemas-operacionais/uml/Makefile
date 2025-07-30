.PHONY: build


pdf: FORMAT = -tpdf
pdf: build


eps: FORMAT = -teps
eps: build


svg: FORMAT = -tsvg
svg: build


latex: FORMAT = -tlatex
latex: build


png: FORMAT = -tpng
png: build


build:
	plantuml -o out $(FORMAT) -progress *.puml


clean:
	rm -rf out
