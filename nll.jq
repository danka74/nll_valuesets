# input is a FHIR ValueSet for any of the Swedish National Drug List SNOMED CT reference sets
[
    .expansion.contains[] | # all concepts
    .code as $sctid | # save conceptId
    reduce .designation[] as $designation ({$sctid}; # for each concept reduce designations to object with sctid and relevant terms
        $designation.value as $term | # save term
        . + reduce ($designation.extension[] | select(.url == "http://snomed.info/fhir/StructureDefinition/designation-use-context") |
                        .extension[]) as $duc ({}; # reduce duc extensions to object with context-based terms
            if ($duc.url == "context" and $duc.valueCoding.code == "63461000052102") then . + {"professional": $term} 
            elif ($duc.url == "context" and $duc.valueCoding.code == "63451000052100") then . + {"patient": $term} 
            elif ($duc.url == "context" and $duc.valueCoding.code == "63491000052105") then . + {"abbreviation": $term} 
            elif ($duc.url == "context" and $duc.valueCoding.code == "63481000052108") then . + {"plural": $term} else . end
        )
    )
] | 
sort_by(.professional) |  # sort the list by professional term
.[] |
[ .sctid, .professional, .patient] | # output as tab-separated
@tsv