#!/bin/sh
#Bundle & Minify ObliqueJS


NOT_MINIFIED_DEST_FILE="dist/oblique.js"
MINIFIED_DEST_FILE="dist/oblique.min.js"
SRC_DIR="src/oblique"
coffee -c $SRC_DIR/*.coffee
cat $SRC_DIR/*.js >$NOT_MINIFIED_DEST_FILE
cat $NOT_MINIFIED_DEST_FILE| uglifyjs -c -o $MINIFIED_DEST_FILE