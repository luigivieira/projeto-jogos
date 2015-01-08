TEX=pdflatex
BIB=bibtex
OUTPUT_DIR=output
TEXMFOUTPUT=$(OUTPUT_DIR)

# Get the list of tex files
FILES := $(wildcard *.tex)
# Convert it to an "array" of individual targets without extension
MODULES := $(patsubst %.tex,%,$(FILES))

# Check if WIDE was set as on from command line (with the sintax: make [target]
# WIDE=on), and in that case set the aspect ratio accordingly
ifeq ($(WIDE),on)
ASPECTRATIO = "\def\classopts{,aspectratio=169}\input{$*}"
endif

# Definition of basic commands according to the operating system
$(info Target platform: $(OS))
ifeq ($(OS),Windows_NT)
	RM=del /s/q
	MD=mkdir
	SEP=\\
	CP=copy
else
	RM=rm -rf
	MD=mkdir -p
	SEP=/
	CP=cp
endif

# default target: compile all existing tex files
all: $(MODULES)

# smart target: compile each module defined in the "list" (either from the
# command line, like 'make aula1' or all existing from the wildcard in case
# of 'make all')
$(MODULES): % :
	$(info Aspect ration is: $(ASPECTRATIO))
ifeq ($(OS),Windows_NT)
	if not exist $(OUTPUT_DIR) $(MD) $(OUTPUT_DIR)
else
	$(MD) $(OUTPUT_DIR)
endif
	$(TEX) -output-directory $(OUTPUT_DIR) $(ASPECTRATIO) $*.tex
ifneq ("$(wildcard bibliography.bib)","")
	$(BIB) $(OUTPUT_DIR)$(SEP)$(FILE)
	$(TEX) -output-directory $(OUTPUT_DIR) $(ASPECTRATIO) $*.tex
endif
	$(TEX) -output-directory $(OUTPUT_DIR) $(ASPECTRATIO) $*.tex

clean:
	$(RM) $(OUTPUT_DIR)$(SEP)*.aux  $(OUTPUT_DIR)$(SEP)*.log\
    $(OUTPUT_DIR)$(SEP)*.toc $(OUTPUT_DIR)$(SEP)*.out\
    $(OUTPUT_DIR)$(SEP)*.blg $(OUTPUT_DIR)$(SEP)*.bbl\
    $(OUTPUT_DIR)$(SEP)*.nav $(OUTPUT_DIR)$(SEP)*.snm

clean_all: clean
	$(RM) $(OUTPUT_DIR)$(SEP)*.pdf
