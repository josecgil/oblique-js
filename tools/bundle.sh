#!/bin/sh
#Bundle & Minify ObliqueJS

cat ../src/oblique/*.js| uglifyjs -c -o ../dist/oblique.min.js