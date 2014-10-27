if (Test-Path ../dist) {
    Remove-Item ../dist -recurse
}

New-Item ../dist/oblique.coffee -type file -force

Get-Content ../src/Params/*.coffee | Set-Content ../dist/oblique.coffee
Get-Content ../src/Templates/*.coffee | Add-Content ../dist/oblique.coffee
Get-Content ../src/*.coffee | Add-Content ../dist/oblique.coffee

coffee -c ../dist/oblique.coffee
uglifyjs ../dist/oblique.js -c -o ../dist/oblique.min.js