fs   = require 'fs'
path = require 'path'

execPath = process.cwd()
confPath = path.resolve(process.env.NODE_PATH + '/../config')
config = null


mergeSubmodule = (origin, sub)->
  for key, val of sub
    if origin[key] and typeof origin[key] == 'object' and typeof val == 'object'
      mergeSubmodule origin[key], val
    else
      origin[key] = val
  origin


loadSubmodule = (path)->
  mod = {}
  return mod unless fs.existsSync "#{confPath}/#{path}"
  list = fs.readdirSync "#{confPath}/#{path}"
  files = (file for file in list when fs.lstatSync("#{confPath}/#{path}/#{file}").isFile())
  directories = (file for file in list when fs.lstatSync("#{confPath}/#{path}/#{file}").isDirectory())
  for file in files
    file = file.replace /\.js$/, ""
    file = file.replace /\.coffee$/, ""
    file = file.replace /\.json$/, ""
    mod[file] = require "#{confPath}/#{path}/#{file}"
  for directory in directories
    sub = {}
    sub[directory] = loadSubmodule "#{path}/#{directory}/"
    mergeSubmodule mod, sub
  mod


load = (mode)->
  mode ||= process.env.NODE_ENV || "development"
  config = require "#{confPath}/#{mode}"
  return config unless fs.existsSync "#{confPath}/#{mode}/"
  sub = loadSubmodule "#{mode}"
  mergeSubmodule config, sub

load()
config._load = load

module.exports = config
