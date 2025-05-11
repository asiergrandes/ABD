#!/bin/bash

# Definir las variables
ENDPOINT="http://localhost:7200/repositories/abd"
QUERY="PREFIX dcat: <http://www.w3.org/ns/dcat#> SELECT * WHERE {{ GRAPH ?g { ?s dcat:theme 'museos' }}UNION {?s ?p ?o} }"

# Realizar la consulta SPARQL usando cURL con método POST
curl -X POST -H "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "query=$QUERY" \
    "$ENDPOINT"
