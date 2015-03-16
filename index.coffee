fs = require 'fs'
path = require 'path'

CSON = require 'cson'
coffee = require 'coffee-script'

execPath = process.cwd()
confPath = path.resolve(process.env.NODE_PATH + '/../config')
LoadFileFormats = ['json', 'js', 'coffee', 'cson']


loadCoffeeScriptFile = (file_path) ->
  coffee.eval fs.readFileSync(file_path).toString()

loadCSONFile = (file_path) ->
  CSON.load file_path

loader = (file_path) ->
  {ext} = path.parse file_path
  parser = null
  switch ext
    when '.json' then parser = require
    when '.js' then parser = require
    when '.coffee' then parser = loadCoffeeScriptFile
    when '.cson' then parser = loadCSONFile
  parser file_path

loadDir = (path_name) ->
  answer = {}
  list = fs.readdirSync "#{path_name}"
  files = (file for file in list when fs.statSync("#{path_name}/#{file}").isFile())
  directories = (file for file in list when fs.statSync("#{path_name}/#{file}").isDirectory())

  names = {}
  config_names = (path.parse("#{path_name}/#{file}").name for file in files).concat directories
  for name in config_names
    if names[name]
      throw new Error "Duplicate config object #{name}"
    else
      names[name] = true

  for file in files
    file_path = path.resolve path_name, file
    {name} = path.parse file_path
    answer[name] = loader file_path

  for directory in directories
    answer[directory] = loadDir path.resolve path_name, directory
  answer

class Config
  _load: (mode) -> new Config mode
  constructor: (mode) ->
    mode || = process.env.NODE_ENV
    mode || = "development"
    loaded = false
    tmp = {}
    for format in LoadFileFormats
      if fs.existsSync("#{confPath}/#{mode}.#{format}") and fs.statSync("#{confPath}/#{mode}.#{format}").isFile()
        if loaded
          throw new Error "Duplicate config object #{name}"
        tmp = loader "#{confPath}/#{mode}.#{format}"
        loaded = true

    if fs.existsSync("#{confPath}/#{mode}") and fs.statSync("#{confPath}/#{mode}").isDirectory()
      if loaded
        throw new Error "Duplicate config object #{name}"
      tmp = loadDir "#{confPath}/#{mode}"
      loaded = true

    unless loaded
      console.error "config file dosen't exist"
    for key, val of tmp
      @[key] = val


module.exports = new Config
