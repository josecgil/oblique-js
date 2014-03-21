#!/bin/sh
#Bundle & Minify ObliqueJS


NOT_MINIFIED_DEST_FILE="dist/oblique.js"
MINIFIED_DEST_FILE="dist/oblique.min.js"
cat src/oblique/*.js >$NOT_MINIFIED_DEST_FILE

cat $NOT_MINIFIED_DEST_FILE| uglifyjs -c -o $MINIFIED_DEST_FILE