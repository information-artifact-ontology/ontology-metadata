## Customize Makefile settings for omo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile


$(ONT)-disease.owl: $(ONT)-full.owl
	$(ROBOT) merge --input $< \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@
