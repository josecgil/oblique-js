#!/bin/sh
#Bundle & Minify ObliqueJS

NOT_MINIFIED_COFFEE_DEST_FILE="dist/oblique.coffee"
NOT_MINIFIED_JS_DEST_FILE="dist/oblique.js"
MINIFIED_DEST_FILE="dist/oblique.min.js"
SRC_DIR="src/oblique"

function addFileTo {
    echo "adding $1 to $NOT_MINIFIED_COFFEE_DEST_FILE..."
	echo "# $1" >> $2
	cat "$1" >> $2
}

function addBlankLineTo {
    echo "adding blank line to $1..."
    echo > $1
}

function generateJSWithSourceMaps {
    echo "generating JS with source maps from $1..."
    coffee --map -c $1
}

function generateMinifiedJS {
    echo "minifing $1 to $2..."
    uglifyjs $1 -c -o $2
}

function deleteFile {
    echo "deleting $1..."
    rm $1
}


addBlankLineTo $NOT_MINIFIED_COFFEE_DEST_FILE

sourceCoffeeFiles=`ls $SRC_DIR/*.coffee`
for file in $sourceCoffeeFiles; do
    addFileTo $file $NOT_MINIFIED_COFFEE_DEST_FILE
done

generateJSWithSourceMaps $NOT_MINIFIED_COFFEE_DEST_FILE
generateMinifiedJS $NOT_MINIFIED_JS_DEST_FILE $MINIFIED_DEST_FILE
