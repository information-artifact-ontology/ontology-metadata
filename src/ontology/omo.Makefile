## Customize Makefile settings for omo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

METADATA_TEMPLATE=../metadata/ontology-metadata.j2

$(ONT)-disease.owl: $(ONT)-full.owl
	$(ROBOT) merge --input $< \
		annotate --ontology-iri $(ONTBASE)/$@ $(ANNOTATE_ONTOLOGY_VERSION) --output $@.tmp.owl && mv $@.tmp.owl $@

tmp/metadata/:
	mkdir -p $@


tmp/metadata/%.yaml:
	wget https://raw.githubusercontent.com/OBOFoundry/OBOFoundry.github.io/master/ontology/$*.md -O $@.tmp
	tail -n +2 $@.tmp | sed -n '/---/q;p' > $@
.PRECIOUS: tmp/metadata/%.yaml

../metadata/obo/%.owl: tmp/metadata/%.yaml | tmp/metadata/
	j2 $(METADATA_TEMPLATE) $< > $@

x-%: ../metadata/obo/%.owl
	$(ROBOT) merge -I $(URIBASE)/$*.owl -i $< --include-annotations true -o $*.owl

tmp/metadata.json:
	wget https://obofoundry.org/registry/ontologies.jsonld -O $@
.PRECIOUS: tmp/metadata.json

obo-metadata: tmp/metadata.json
	#jq -c '.ontologies[] | .id' $< | while read ontology; do make ../metadata/obo/${ontology}.owl; done
	jq -r '.ontologies[] | [.id] | @tsv' $< | while IFS=$$'\t' read -r id ; do make ../metadata/obo/$${id}.owl; done
