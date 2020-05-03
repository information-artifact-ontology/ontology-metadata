# omo ontology Makefile
# Jie Zheng
#
# This Makefile is used to build artifacts
# for the OBO Metadata Ontology (OMO).
#

### Configuration
#
# prologue:
# <http://clarkgrubb.com/makefile-style-guide#toc2>

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

### Definitions
OBO     := http://purl.obolibrary.org/obo
IAO  	:= $(OBO)/IAO_
TODAY   := $(shell date +%Y-%m-%d)

### Directories
#
# This is a temporary place to put things.
build:
	mkdir -p $@


### ROBOT
#
# We use the official development version of ROBOT
build/robot.jar: | build
	curl -L -o $@ https://github.com/ontodev/robot/releases/download/v1.4.1/robot.jar

ROBOT := java -jar build/robot.jar

### Build
#
# Here we create a standalone OWL file appropriate for release.
# This involves annotating.

omo.owl: src/ontology/omo-edit.owl | build/robot.jar
	$(ROBOT) reason \
	--input $< \
	--reasoner HermiT \
	annotate \
	--ontology-iri "$(OBO)/omo.owl" \
	--version-iri "$(OBO)/omo/$(TODAY)/omo.owl" \
	--output $@

build/terms-report.csv: omo.owl src/sparql/terms-report.rq | build
	$(ROBOT) query --input $< --select $(word 2,$^) $@


### 
#
# Full build
.PHONY: all
all: omo.owl build/terms-report.csv

# Remove generated files
.PHONY: clean
clean:
	rm -rf build
