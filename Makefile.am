###############################################################################
## Makefile for Tatar--English
###############################################################################

VERSION=0.1.0
LANG1=tat
LANG2=eng
PREFIX1=$(LANG1)-$(LANG2)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON =		\
	$(PREFIX1).automorf.bin	\
	$(PREFIX1).prob		\
	$(PREFIX1).rlx.bin	\
	$(PREFIX1).autobil.bin	\
	$(PREFIX1).autolex.bin	\
	$(PREFIX1).autogen.bin	\
	$(PREFIX1).autopgen.bin	\
	$(PREFIX1).t1x.bin	\
	$(PREFIX1).t2x.bin	\
	$(PREFIX1).t3x.bin

# This include defines goals for install-modes, .deps/.d, autobil.prefixes and .mode files:
@ap_include@

###############################################################################
## Monolingual transducers
###############################################################################

# -------------------
# Tatar analysis:
# -------------------

.deps/$(PREFIX1).autobil.prefixes: $(PREFIX1).autobil.bin .deps/.d
	lt-print $(PREFIX1).autobil.bin | sed 's/ /@_SPACE_@/g' > .deps/$(PREFIX1).autobil.att
	hfst-txt2fst -e ε <  .deps/$(PREFIX1).autobil.att > .deps/$(PREFIX1).autobil.hfst
	hfst-project -p upper .deps/$(PREFIX1).autobil.hfst > .deps/$(PREFIX1).autobil.upper
	echo " ?* " | hfst-regexp2fst > .deps/any-symbol.hfst
	hfst-concatenate -1 .deps/$(PREFIX1).autobil.upper -2 .deps/any-symbol.hfst -o .deps/$(PREFIX1).autobil.prefixes

.deps/$(LANG1).automorf.hfst: $(AP_SRC1)/$(LANG1).automorf.att.gz .deps/.d
	$(ZCAT) $< | hfst-txt2fst > $@

.deps/$(LANG1).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.att.gz .deps/.d
	@$(ZCAT) $< > $@.att
	lt-comp lr $@.att $@
	@rm $@.att

$(PREFIX1).automorf.bin: .deps/$(LANG1).automorf.hfst .deps/$(PREFIX1).autobil.prefixes
	hfst-compose-intersect -1 .deps/$(LANG1).automorf.hfst -2 .deps/$(PREFIX1).autobil.prefixes -o .deps/$(PREFIX1).automorf.trimmed
	hfst-fst2txt -i .deps/$(PREFIX1).automorf.trimmed -o .deps/$(PREFIX1).automorf.trimmed.att
	lt-comp lr .deps/$(PREFIX1).automorf.trimmed.att $@

# -------------------
# English generation:
# ---------------------

$(PREFIX1).autogen.bin: $(AP_SRC2)/$(LANG2).autogen.bin
	cp $< $@

###############################################################################
## Tagger models
###############################################################################

$(PREFIX1).prob: $(AP_SRC1)/$(LANG1).prob
	cp $< $@

###############################################################################
## Disambiguation rules
###############################################################################

$(PREFIX1).rlx.bin: $(AP_SRC1)/apertium-$(LANG1).$(LANG1).rlx
	cg-comp $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

###############################################################################
## Postgeneration dictionaries
###############################################################################

$(PREFIX1).autopgen.bin: $(AP_SRC2)/$(LANG2).autopgen.bin
	cp $< $@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=					\
		$(BASENAME).$(PREFIX1).lrx	\
		$(BASENAME).$(PREFIX1).dix	\
		$(BASENAME).$(PREFIX1).t1x	\
		$(BASENAME).$(PREFIX1).t2x	\
		$(BASENAME).$(PREFIX1).t3x	\
		modes.xml

###############################################################################
## Installation
###############################################################################

apertium_tat_engdir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_tat_eng_DATA=	\
	$(TARGETS_COMMON)				\
	$(BASENAME).$(PREFIX1).t1x			\
	$(BASENAME).$(PREFIX1).t2x			\
	$(BASENAME).$(PREFIX1).t3x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode \
	.deps/$(LANG1).automorf.bin

install-data-local: install-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

acceptance-test: all
	diff <(head -n `wc -l texts/birthRecord.refTranslation.csv | grep -o "[[:digit:]]\+"` texts/birthRecord.corrected.csv | apertium -u -d . tat-eng) texts/birthRecord.refTranslation.csv  | less

corpus-test: all
	mv texts/currentTranslation.csv texts/previousTranslation.csv
	cat texts/birthRecord.csv texts/marriageRecord.csv texts/divorceRecord.csv texts/deathRecord.csv | apertium -u -d . tat-eng > texts/currentTranslation.csv
	diff texts/previousTranslation.csv texts/currentTranslation.csv | less

non-destructuve-corpus-test: all
	diff -U0 texts/previousTranslation.csv texts/currentTranslation.csv | dwdiff --diff-input | less

non-destructuve-corpus-test-summary: all
	diff -U0 texts/previousTranslation.csv texts/currentTranslation.csv | dwdiff --diff-input | grep -v '^@' |sed 's/.*\[-//'|sed 's/+}.*//'  | sort | uniq -c |sort -nr | less
