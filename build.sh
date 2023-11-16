ROOT=~/data/red_kgr

echo "* Generate RDF graph (Turtle format) from Tabtree source files"
# $ROOT/scripts/generators/compile_turtle.sh
compile-ttl.rkt "$ROOT/source/main.tree" "$ROOT/turtle/red_kgr.ttl"

echo "* Validate Turtle code"
ttl $ROOT/turtle/red_kgr.ttl

echo "* Search graph patterns via SPARQL query"
echo "** YouTube bloggers by subscribers"
arq --data $ROOT/turtle/red_kgr.ttl --query $ROOT/sparql/all_yt_bloggers.rq --results=CSV > $ROOT/shiny/csv/yt_bloggers.csv

echo "** Find guest bloggers"
arq --data $ROOT/turtle/red_kgr.ttl --query $ROOT/sparql/guest_bloggers.rq --results=CSV > $ROOT/shiny/csv/guest_bloggers.csv

echo "* Deploy an app to shinyapps.io"
$ROOT/shiny/deploy.R
