PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

INSERT {
  ?property oboInOwl:is_metadata_tag "true"^^xsd:boolean .
}
WHERE {
  ?property rdf:type owl:AnnotationProperty .
}
