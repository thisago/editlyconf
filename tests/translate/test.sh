#!/bin/bash
nim r ./src/editlyconf/translate.nim

x=`echo -ne "import std/json, editlyconf\nwriteFile \"out.json\", pretty "; cat tests/translate/out.nim`
echo "$x" > tests/translate/out.nim

nim r tests/translate/out.nim

node -e "var fs = require('fs');fs.readFile('tests/translate/in.json', 'utf8', (err, input) => {fs.readFile('tests/translate/in.json', 'utf8', (err, output) => {const parse = JSON.parse;console.assert(parse(input) == parse(output))})})"
