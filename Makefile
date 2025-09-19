# Makefile for generating websites and pdfs from Agda sources

# Command to update all files generated from the default test modules:
#
# make all

##############################################################################
# PARAMETERS
#
# Name   Purpose                 Default
# ----------------------------------------------
# DIR    import include-path     agda
# ROOT   root module file        agda/index.lagda
# HTML   generated HTML files    docs/html
# MD     generated MD files      docs/md
# PDF    generated PDF files     docs/pdf
# LATEX  generated LATEX files   latex
# TEMP   temporary files         /tmp

# DEFAULTS for olivierfest-agda

DIR   := .
ROOT  := index.lagda
HTML  := docs/html
MD    := docs/md
PDF   := docs/pdf
LATEX := latex
TEMP  := /tmp

##############################################################################
# VARIABLES

SHELL=/bin/sh

# Shell commands for calling Agda:
AGDA := agda --include-path=$(DIR) --trace-imports=0

AGDA-CHECK := agda --include-path=$(DIR) --trace-imports=3

# Shell command for generating PDF from LaTeX:
PDFLATEX := pdflatex -shell-escape -interaction=nonstopmode

# Name of ROOT module:
NAME := $(subst /,.,$(subst $(DIR)/,,$(basename $(ROOT))))
# e.g., Test.All

# A single newline:
define NEWLINE


endef

# Target files:
HTML-FILES := $(sort $(HTML)/$(ROOT:lagda=html) \
		$(subst $(TEMP)/,$(HTML)/,$(shell \
		rm -f $(TEMP)/*.html; \
		$(AGDA) --html --html-dir=$(TEMP) $(ROOT); \
		ls $(TEMP)/*.html)))
# e.g., docs/html/Agda.Primitive.html docs/html/Test.All.html docs/html/Test.Sub.Base.html

# Names of modules imported (perhaps indirectly) by ROOT:
IMPORT-NAMES := $(subst $(HTML)/,,$(basename $(HTML-FILES)))
# e.g., Agda.Primitive Test.All Test.Sub.Base

# Paths of modules imported (perhaps indirectly) by ROOT:
IMPORT-PATHS := $(subst .,/,$(IMPORT-NAMES))
# e.g., Agda/Primitive Test/All Test/Sub/Base

# Names of modules in DIR:
MODULE-NAMES := $(sort $(subst /,.,$(subst $(DIR)/,,$(basename $(shell \
		find $(DIR) -name '*.lagda')))))
# e.g., Test Test.All Test.Sub.Base Test.Sub.Not-Imported

# Names of imported modules in DIR:
AGDA-NAMES := $(filter $(MODULE-NAMES),$(IMPORT-NAMES))
# e.g., Test.All Test.Sub.Base

# Paths of imported modules in DIR:
AGDA-PATHS := $(subst .,/,$(AGDA-NAMES))
# e.g., Test/All Test/Sub/Base

# Agda source files:
AGDA-FILES := $(addprefix $(DIR)/,$(addsuffix .lagda,$(AGDA-PATHS)))
# e.g., agda/Test/All.lagda agda/Test/Sub/Base.lagda

# Target files:
MD-FILES := $(addprefix $(MD)/,$(addsuffix /index.md,$(IMPORT-PATHS)))
# e.g., docs/md/Agda/Primitive.md docs/md/Test/All.md docs/md/Test/Sub/Base.md

# Target files:
LATEX-FILES := $(addprefix $(LATEX)/,$(addsuffix .tex,$(AGDA-PATHS)))
# e.g., latex/Test/All.tex latex/Test/Sub/Base.tex

LATEX-INPUTS := $(foreach p,$(AGDA-PATHS),$(NEWLINE)\pagebreak[3]$(NEWLINE)\section{$(subst /,.,$(p))}\input{$(p)})
# e.g., \n\section{index}\input{index}\n\section{Test.index}\input{Test/index}...

AGDA-STYLE := conor

# LaTeX packages provided by Agda-Material are in the project root:
AGDA-CUSTOM := $(patsubst %/,../,$(LATEX)/)agda-custom
UNICODE := $(patsubst %/,../,$(LATEX)/)unicode

define LATEXDOC
\\documentclass[a4paper]{article}
\\usepackage{parskip}
\\usepackage[T1]{fontenc}
\\usepackage{microtype}
\\DisableLigatures[-]{encoding = T1, family = tt* }
\\usepackage{hyperref}

\\usepackage[$(AGDA-STYLE)]{agda}
\\usepackage{$(UNICODE)}
\\usepackage{$(AGDA-CUSTOM)}

\\title{$(NAME)}
\\begin{document}
\\maketitle
\\tableofcontents
\\newpage
$(LATEX-INPUTS)

\\end{document}
endef

##############################################################################
# RULES

.PHONY: help
export HELP
help:
	@echo "$$HELP"

.PHONY: debug
export DEBUG
debug:
	@echo "$$DEBUG"

# Clean and regenerate the OlivierFest-Agda website:

.PHONY: website
website:
	@echo Clean...
	@$(MAKE) clean
	@rm -f ScmQE.pdf
	@echo Check Agda code...
	@$(MAKE) check
	@echo Generate LaTeX code...
	@$(MAKE) latex
	@cp ScmQE.tex latex/ScmQE.All.doc.tex
	@cp ScmQE.bib latex/
	@echo Generate PDF...
	@$(MAKE) pdf ROOT=ScmQE/All.lagda
	@cp docs/pdf/ScmQE.All.pdf ScmQE.pdf
	@echo Generate website...
	@$(MAKE) html
	@$(MAKE) md
	@echo ... all finished
	@echo Run make serve to preview the generated webite

# Check Agda source files:

.PHONY: check
check:
	@$(AGDA-CHECK) $(ROOT) | grep $(shell pwd)

# Generate HTML web pages:

.PHONY: html
html: $(HTML-FILES)

$(HTML-FILES) &:: $(AGDA-FILES)
	@$(AGDA) --html --html-dir=$(HTML) $(ROOT)

# Generate Markdown sources for web pages:

.PHONY: md
md: $(MD-FILES)

# `agda --html --html-highlight=code ROOT.lagda` produces highlighted HTML files
# from plain `agda` and literate `lagda` source files. However, the extension is
# `tex` for HTML produced from `lagda` files. It is `html` for `agda` files, but
# needs to be wrapped in `<pre class="Agda">...</pre>` tags.

# The links in the files assume they are all in the same directory, and that the
# files have extension `.html`. Adjusting them to hierarchical links with
# directory URLs involves replacing the dots in the basenames of the files by
# slashes, prefixing the href by the relative path to the top of the hierarchy,
# and appending a slash to the file path. All URLs that start with A-Z or a-z
# are assumed to be links to modules, and adjusted (also in the prose of
# literate Agda source files).

# The links generated by Agda always start with the file name. This could be
# omitted for local links where the id is in the same file. Similarly, the
# links to modules in the same directory could be optimized.

$(MD-FILES) &:: $(AGDA-FILES)
	@$(AGDA) --html --html-highlight=code --html-dir=$(MD) $(ROOT)
	@for FILE in $(MD)/*; do \
	  BASENAME=$${FILE%.*}; \
	  MDPATH=$${BASENAME//./\/}; \
	  MDFILE=$$MDPATH/index.md; \
	  RELATIVE=`echo $$BASENAME | sd '^$(MD)/' '.' | sd '\.[^.]*' '../'`; \
	  export MDFILE; \
	  case $$FILE in \
	    *.html) \
	      sd '\A' '<pre class="Agda">' $$FILE; \
	      sd '\z' '</pre>' $$FILE;; \
	  esac; \
	  case $$FILE in \
	    *.html | *.tex) \
	      sd '(href="[A-Za-z][^"]*)\.html' '$$1/' $$FILE; \
	      while grep -q 'href="[A-Z][^".]*\.' $$FILE; do \
	        sd '(href="[A-Za-z][^".]*)\.' '$$1/' $$FILE; \
	      done; \
	      sd 'href="([A-Za-z])' "href=\"$$RELATIVE\$$1" $$FILE; \
	      mkdir -p `dirname $$MDFILE`; \
	      printf "%s\ntitle: %s\nhide: toc\n%s\n\n# %s\n\n" \
	             "---" \
		     `basename $$MDPATH` \
		     "---" \
		     $${BASENAME##*/} > $$MDFILE; \
	      cat $$FILE >> $$MDFILE;; \
	  esac; \
	  case $$FILE in \
	    *.html | *.tex | */Agda.css) \
	      rm $$FILE;; \
	  esac \
	done

# Generate LaTeX source files for use in latex documents:

.PHONY: latex
latex: $(LATEX-FILES)

$(LATEX-FILES): $(LATEX)/%.tex: $(DIR)/%.lagda
	@$(AGDA) --latex --latex-dir=$(LATEX) $<

# Generate a LaTeX document to format the generated LaTeX files:

.PHONY: doc
doc: $(LATEX)/$(NAME).doc.tex

export LATEXDOC
$(LATEX)/$(NAME).doc.tex:
	@echo "$$LATEXDOC" > $@

# Generate a PDF using $(PDFLATEX)

.PHONY: pdf
pdf: $(PDF)/$(NAME).pdf

$(PDF)/$(NAME).pdf: $(LATEX)/$(NAME).doc.tex $(LATEX-FILES) $(LATEX)/agda.sty $(LATEX)/$(AGDA-CUSTOM).sty $(LATEX)/$(UNICODE).sty
	@cd $(LATEX); \
	  $(PDFLATEX) $(NAME).doc.tex; \
	  $(PDFLATEX) $(NAME).doc.tex; \
	  rm -f $(NAME).doc.{aux,log,out,ptb,toc}
	mkdir -p $(PDF) && mv -f $(LATEX)/$(NAME).doc.pdf $(PDF)/$(NAME).pdf

# Serve the generated website for a local preview

.PHONY: serve
serve:
	@mkdocs serve

# Update and build the website, then deploy it on GitHub Pages from the gh-pages branch

.PHONY: deploy
deploy:
	@mkdocs gh-deploy --force

# Remove all files generated from ROOT

.PHONY: clean clean-html clean-md clean-latex clean-pdf
clean: clean-html clean-md clean-latex clean-pdf

clean-html:
	@rm -rf $(HTML-FILES)

clean-md:
	@rm -rf $(MD-FILES)

clean-latex:
	@rm -rf $(LATEX-FILES) $(LATEX)/$(NAME).doc.{aux,log,out,ptb,tex,toc}

clean-pdf:
	@rm -rf $(PDF)/$(NAME).pdf

# Texts

define HELP

make check
  Test the Agda code
make website
  Generate a website listing the Agda code
make serve
  Browse the website locally
make deploy
  Deploy the website on GitHub Pagess 
make help
  Display this information

endef

define DEBUG

DIR:          $(DIR)
ROOT:         $(ROOT)
NAME:         $(NAME)

IMPORT-NAMES (1-5): $(wordlist 1, 5, $(IMPORT-NAMES))

IMPORT-PATHS (1-5): $(wordlist 1, 5, $(IMPORT-PATHS))

MODULE-NAMES (1-5): $(wordlist 1, 5, $(MODULE-NAMES))

AGDA-NAMES:   $(AGDA-NAMES)

AGDA-PATHS:   $(AGDA-PATHS)

AGDA-FILES:   $(AGDA-FILES)

HTML-FILES (1-5):   $(wordlist 1, 5, $(HTML-FILES))

MD-FILES (1-5):     $(wordlist 1, 5, $(MD-FILES))

LATEXDOC:

$(LATEXDOC)

LATEX-FILES:  $(LATEX-FILES)

LATEX-INPUTS:
$(LATEX-INPUTS)

AGDA-CUSTOM:  $(AGDA-CUSTOM)

endef