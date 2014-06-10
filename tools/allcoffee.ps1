Get-Content ../src/oblique/*.coffee | Set-Content ../dist/oblique.coffee
coffee --map -c ../dist/oblique.coffee
uglifyjs ../dist/oblique.js -c -o ../dist/oblique.min.js