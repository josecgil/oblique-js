if (Test-Path ../dist) {
    Remove-Item ../dist -recurse
}

New-Item ../dist/oblique.coffee -type file -force

Get-Content ../src/*.coffee | Set-Content ../dist/oblique.coffee
coffee -c ../dist/oblique.coffee
uglifyjs ../dist/oblique.js -c -o ../dist/oblique.min.js