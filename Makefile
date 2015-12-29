###############################################################################
#
# Copyright 2015, Mariano Cerdeiro
# All rights reserved.
#
# This file is part of CIAA Firmware.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
###############################################################################
# books to be build
BOOKS				= firmware
# PDF Style
PDF_STYLE		= styles$(DS)params.xsl
# HTML Style
HTML_STYLE		= styles$(DS)params_html.xsl
# DOCBOOK Schema
DOCBOOK_SCHEMA	= schema$(DS)docbook.xsd
# OUTPUT Paths
OUT_DIR			= out
# DS
DS					= /
# Include the makefile of each book
include $(foreach BOOK, $(BOOKS), $(BOOK)$(DS)Makefile)
# Default rule is to make all books
all: $(foreach BOOK,$(BOOKS),\
	$(OUT_DIR)$(DS)$(BOOK)$(DS)forvalidation.xml	\
	$(OUT_DIR)$(DS)$(BOOK)$(DS)html$(DS)index.html \
	$(OUT_DIR)$(DS)$(BOOK)$(DS)pdf$(DS)$(BOOK).pdf)

.PHONY: directories

directories:
	$(foreach BOOK,$(BOOKS),mkdir -p $(OUT_DIR)$(DS)$(BOOK))

PNG_OUT	=	out/png

vpath %.png $(PNG_OUT)
vpath %.uml chapters/hisio/uml

png: $(PNG_FILES)

clean:
	rm -rf out/firmware


define valrule
$(OUT_DIR)$(DS)$(1):
	@echo Generating output dirs for $(1)
	mkdir -p $(OUT_DIR)$(DS)$(1)
	mkdir -p $(OUT_DIR)$(DS)$(1)$(DS)pdf
	mkdir -p $(OUT_DIR)$(DS)$(1)$(DS)html

$(OUT_DIR)$(DS)$(1)$(DS)forvalidation.xml: $(OUT_DIR)$(DS)$(1) $($(1)_DOCBOOK_FILES)
	@echo Creating forvalidation for $(1) with $(2)
	xmllint --noent $(2) > $(OUT_DIR)$(DS)$(1)$(DS)forvalidation.xml

$(1)_validate: $(OUT_DIR)$(DS)$(1)$(DS)forvalidation.xml
	@echo Validating $(1)
	xmllint --noout --schema $(DOCBOOK_SCHEMA) $(OUT_DIR)$(DS)$(1)$(DS)forvalidation.xml

$(1)_html: $(OUT_DIR)$(DS)$(1)$(DS)html $($(1)_DOCBOOK_FILES)
	@echo Generating HTML for $(1)
	xsltproc -o out$(DS)$(1)$(DS)html$(DS) $(HTML_STYLE) $($(1)_DOCBOOK_MFILE)
	cp styles/css/style.css $(OUT_DIR)$(DS)$(BOOK)$(DS)html$(DS)style.css

$(OUT_DIR)$(DS)$(1)$(DS)html$(DS)index.html: $(OUT_DIR)$(DS)$(1)$(DS)html $($(1)_DOCBOOK_FILES)
	@echo Generating HTML for $(1)
	xsltproc -o out$(DS)$(1)$(DS)html$(DS) $(HTML_STYLE) $($(1)_DOCBOOK_MFILE)
	cp styles/css/style.css $(OUT_DIR)$(DS)$(BOOK)$(DS)html$(DS)style.css

$(1)_pdf: $(OUT_DIR)$(DS)$(1)$(DS)pdf $($(1)_DOCBOOK_FILES)
	@echo Generating PDF for $(1)
	xsltproc $(PDF_STYLE) $($(1)_DOCBOOK_MFILE) > $(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(1).fo
	fop -c fop/fop.xml -fo $(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(1).fo -pdf $(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(1).pdf

$(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(BOOK).pdf: $(OUT_DIR)$(DS)$(1)$(DS)pdf $($(1)_DOCBOOK_FILES)
	@echo Generating PDF for $(1)
	xsltproc $(PDF_STYLE) $($(1)_DOCBOOK_MFILE) > $(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(1).fo
	fop -c fop/fop.xml -fo $(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(1).fo -pdf $(OUT_DIR)$(DS)$(1)$(DS)pdf$(DS)$(1).pdf

$(1)_all: $(1)_validate $(1)_html $(1)_pdf
endef

$(foreach BOOK, $(BOOKS), $(eval $(call valrule,$(BOOK),$($(BOOK)_DOCBOOK_MFILE))))

out/forvalidation.xml: $(DCBOOK_MFILE)
	xmllint --noent book.xml > out/forvalidation.xml

validate: out/forvalidation.xml
	xmllint --noout --schema schema/docbook.xsd out/forvalidation.xml

doc: out/forvalidation.xml
	xsltproc ./styles/params.xsl book.xml > out/pdf/book.fo
	fop -c fop/fop.xml -fo out/pdf/book.fo -pdf out/pdf/book.pdf
#	xsltproc ./style/docbook-xsl-1.78.1/fo/docbook.xsl book.xml > out/book.fo

html: out/forvalidation.xml out/html/style.css
	xsltproc -o out/html/ styles/params_html.xsl book.xml


out/html/style.css: styles/css/style.css
	cp styles/css/style.css out/html/style.css

epub: out/forvalidation.xml
	xsltproc -o out/epub/book.epub ./styles/params_epub.xsl book.xml

cp:
	cp out/pdf/book.pdf /var/www/soix/download/book_mace.pdf

spell:
	aspell --mode=sgml --lang=es check book.xml
	aspell --mode=sgml --lang=es check chapters/osek.xml


%.png : %.uml
	@echo ""
	@echo ==================================================
	@echo Converting $< to $@
	@echo ""
	java -jar plantuml.jar $< -o ../../$(PNG_OUT)

help:
	@echo validate................: validates the docbook xml agianst the schema
	@echo html....................: generates html output
	@echo doc.....................: generates pdf output
	@echo clean...................: cleans the project
	@echo spell...................: check spelling
