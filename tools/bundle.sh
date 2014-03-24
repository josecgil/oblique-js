#!/bin/sh
#Bundle & Minify ObliqueJS

function appendContentFromFileTo {
    echo "adding $1 to $2 ..."
    addBlankLineTo $2
	echo "# $1" >> $2
    addBlankLineTo $2
	cat "$1" >> $2
}

function addBlankLineTo {
    echo >> $1
}

function generateJSWithSourceMaps {
    echo "generating JS with source maps from $1 ..."
    coffee --map -c $1
}

function generateMinifiedJS {
    echo "minifing $1 to $2 ..."
    uglifyjs $1 -c -o $2
}

function deleteFile {
    echo "deleting $1 ..."
    rm $1
}

function getSourceCoffeeFiles {
    result=`ls $1/*.coffee`
}

function showInfo {
    echo
    echo "This script needs coffeescript & uglifyjs to work"
    echo "to install"
    echo "sudo npm install -g coffee-script"
    echo "sudo npm install -g uglify-js"
    echo
}

NOT_MINIFIED_COFFEE_DEST_FILE="../dist/oblique.coffee"
NOT_MINIFIED_JS_DEST_FILE="../dist/oblique.js"
MINIFIED_JS_DEST_FILE="../dist/oblique.min.js"
COFFEE_SRC_DIR="../src/oblique"

showInfo
deleteFile $NOT_MINIFIED_COFFEE_DEST_FILE
deleteFile $MINIFIED_JS_DEST_FILE
getSourceCoffeeFiles $COFFEE_SRC_DIR
for file in $result; do
    appendContentFromFileTo $file $NOT_MINIFIED_COFFEE_DEST_FILE
done

generateJSWithSourceMaps $NOT_MINIFIED_COFFEE_DEST_FILE
generateMinifiedJS $NOT_MINIFIED_JS_DEST_FILE $MINIFIED_JS_DEST_FILE
