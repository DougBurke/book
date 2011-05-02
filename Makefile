all: html/index.xhtml pdf/nlpwp.pdf

XML=xml/nlpwp.xml \
	xml/chap-words.xml \
	xml/chap-ngrams.xml \
	xml/chap-classification.xml \
	xml/chap-tagging.xml

BOOKXML=xml/nlpwp.xml

html/index.xhtml: $(XML)
	xmlto -o html/ -x xsl/html-chunk.xsl \
		--skip-validation xhtml $(BOOKXML)

pdf/nlpwp.fo: $(XML) xsl/fo.xsl
	xmlto -o pdf/ -x xsl/fo.xsl \
		--noautosize --skip-validation fo $(BOOKXML)

pdf-print/nlpwp.fo: $(XML) xsl/fo-print.xsl
	xmlto -o pdf-print -x xsl/fo-print.xsl \
		--noautosize --skip-validation fo $(BOOKXML)

%.pdf: %.fo
	fop $< $@
