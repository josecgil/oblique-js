#!/bin/sh
#Bundle & Minify ObliqueJS


cat ../src/oblique/*.js >../dist/oblique.js

cat ../src/oblique/*.js| uglifyjs -c -o ../dist/oblique.min.js