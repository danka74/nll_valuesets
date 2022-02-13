#!/bin/sh

REFSET=$1

curl --silent --location --request GET "https://snowstorm-fhir.snomedtools.org/fhir/ValueSet/\$expand?url=http://snomed.info/sct/45991000052106?fhir_vs=refset/${REFSET}&includeDesignations=true&designation=sv&_format=json" | \
jq --raw-output --from-file nll.jq