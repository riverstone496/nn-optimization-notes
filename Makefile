# make          : 全体版と章別のPDFを生成
# make chapters : sec/ に章別のPDFを生成
# make main.pdf : 全体版のみ生成
# make sec/02-mirror-descent.pdf : 指定した章のみ生成
LATEXMK = latexmk
LATEXFLAGS = -lualatex -interaction=nonstopmode -halt-on-error -cd
# LuaLaTeXのキャッシュはプロジェクト内に保存する。
export TEXMFVAR := $(CURDIR)/.tex-cache
export TEXMFCACHE := $(TEXMFVAR)
export LC_ALL := C
CHAPTER_SOURCES := $(sort $(wildcard sec/*.tex))
CHAPTER_PDFS := $(CHAPTER_SOURCES:.tex=.pdf)
BIB_SOURCES := $(wildcard *.bib)

.PHONY: all chapters
all: main.pdf chapters

chapters: $(CHAPTER_PDFS)

main.pdf: main.tex $(CHAPTER_SOURCES) $(BIB_SOURCES) | .tex-cache
	$(LATEXMK) $(LATEXFLAGS) main.tex

sec/%.pdf: sec/%.tex main.tex $(BIB_SOURCES) | .tex-cache
	$(LATEXMK) $(LATEXFLAGS) $<

.tex-cache:
	mkdir -p $@
