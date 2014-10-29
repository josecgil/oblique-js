#!/bin/sh
#Bundle & Minify ObliqueJS

function appendContentFromFileTo {
    echo "adding $1 to $2"
    addBlankLineTo $2
	echo "# $1" >> $2
    addBlankLineTo $2
	cat "$1" >> $2
}

function addBlankLineTo {
    echo >> $1
}

function generateJSWithSourceMaps {
    echo "generating JS with source maps from $1"
    coffee --map -c $1
}

function generateMinifiedJS {
    echo "minifing $1 to $2"
    uglifyjs $1 -c -o $2
}

function deleteFileIfPresent {
    echo "deleting $1"
    if [ -f $1 ]; then
        rm $1
    fi
}

function getSourceCoffeeFiles {
    result=`ls $1/*.coffee $1/Templates/*.coffee $1/Params/*.coffee`
}

function showInfo {
    echo
    echo "This script needs coffeescript & uglifyjs to work"
    echo "to install"
    echo "sudo npm install -g coffee-script"
    echo "sudo npm install -g uglify-js"
    echo
}

function createFileIfNotPresent() {
    echo "creating file $1"
    touch $1
}

createDirectoryIfNotPresent() {
    echo "creating directory $1"
    mkdir -p $1
}


function createOneBigCoffeeFile() {
    createFileIfNotPresent $NOT_MINIFIED_COFFEE_DEST_FILE
    getSourceCoffeeFiles $COFFEE_SRC_DIR
    for file in $result; do
        appendContentFromFileTo $file $NOT_MINIFIED_COFFEE_DEST_FILE
    done
}

function generateJSfromCoffee() {
    generateJSWithSourceMaps $NOT_MINIFIED_COFFEE_DEST_FILE
    generateMinifiedJS $NOT_MINIFIED_JS_DEST_FILE $MINIFIED_JS_DEST_FILE
}

function ResetDestinationDirectory() {
    deleteFileIfPresent $NOT_MINIFIED_COFFEE_DEST_FILE
    deleteFileIfPresent $MINIFIED_JS_DEST_FILE
    createDirectoryIfNotPresent $DEST_DIR
}


DEST_DIR="../dist"
NOT_MINIFIED_COFFEE_DEST_FILE="$DEST_DIR/oblique.coffee"
NOT_MINIFIED_JS_DEST_FILE="$DEST_DIR/oblique.js"
MINIFIED_JS_DEST_FILE="$DEST_DIR/oblique.min.js"
COFFEE_SRC_DIR="../src"

showInfo
ResetDestinationDirectory
createOneBigCoffeeFile
generateJSfromCoffee
