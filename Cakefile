fs     = require 'fs'
{exec} = require 'child_process'

inJsLibFiles = [
  'public/js/gmaps-noitehojestyles'
  'public/js/jquery.prettyPhoto'
  'public/js/parseuri'
  'public/js/geolocation'
  'public/js/app/history/json2'
  'public/js/app/history/amplify.store'
  'public/js/app/history/history.adapter.jquery'
  'public/js/app/history/history'
  'public/js/app/history/history.html4'
  'public/js/app/jquery.reject.min']

inCoffeeFiles = [
  'public/coffee/base'
  'public/coffee/map'
  'public/coffee/location'
  'public/coffee/search'
  'public/coffee/ordering'
  'public/coffee/prettyPhoto'
  'public/coffee/event_details'
  'public/coffee/app']

compilerPath                = 'tools/closure-compiler-20110502.jar'

outLibsJsFile               = 'public/js/app/compiled/libs.js'
outLibsJsMinifiedFile       = 'public/js/app/minified/libs.min.js'

outNoiteHojeCoffeeFile      = 'public/js/app/compiled/noitehoje.coffee'
outNoiteHojeJsFile          = 'public/js/app/compiled/noitehoje.js'
outNoiteHojeJsMinifiedFile  = 'public/js/app/minified/noitehoje.min.js'

task 'combine', 'Build single application file from source files', ->
  combineJsFiles = (inputfileNames, outputFileName) ->
    remaining = inputfileNames.length
    appContents = new Array remaining

    for file, index in inputfileNames then do (file, index) ->
      fs.readFile "#{file}.js", 'utf8', (err, fileContents) ->
        throw err if err
        appContents[index] = fileContents
        combineFiles() if --remaining is 0

    combineFiles = ->
      fs.writeFileSync outputFileName, appContents.join('\n\n')

  combineCoffeeFiles = (inputfileNames, outputFileName) ->
    remaining = inputfileNames.length
    appContents = new Array remaining

    for file, index in inputfileNames then do (file, index) ->
      fs.readFile "#{file}.coffee", 'utf8', (err, fileContents) ->
        throw err if err
        appContents[index] = fileContents
        compileCoffee() if --remaining is 0

    compileCoffee = ->
      fs.writeFile outputFileName, appContents.join('\n\n'), 'utf8', (err) ->
        throw err if err
        exec "coffee --compile #{outputFileName}", (err, stdout, stderr) ->
          throw err if err
          console.log stdout + stderr
          fs.unlink outputFileName, (err) ->
            throw err if err
            console.log 'Done.'

  combineJsFiles inJsLibFiles, outLibsJsFile
  combineCoffeeFiles inCoffeeFiles, outNoiteHojeCoffeeFile

task 'minify', 'Minify the resulting application file after build', ->
  minifyJs = (inputFile, outputFile) ->
    exec "java -jar '#{compilerPath}' --js #{inputFile} --js_output_file #{outputFile}", (err, stdout, stderr) ->
      throw err if err
      console.log stdout + stderr

  minifyJs outLibsJsFile, outLibsJsMinifiedFile
  minifyJs outNoiteHojeJsFile, outNoiteHojeJsMinifiedFile
