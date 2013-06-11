fs = require 'fs'

execPath = process.cwd()
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
  return mod unless fs.existsSync "#{execPath}/config/#{path}"
  list = fs.readdirSync "#{execPath}/config/#{path}"
  files = (file for file in list when fs.lstatSync("#{execPath}/config/#{path}/#{file}").isFile())
  directories = (file for file in list when fs.lstatSync("#{execPath}/config/#{path}/#{file}").isDirectory())
  for file in files
    file = file.replace /\.js$/, ""
    file = file.replace /\.coffee$/, ""
    file = file.replace /\.json$/, ""
    mod[file] = require "#{execPath}/config/#{path}/#{file}"
  for directory in directories
    sub = {}
    sub[directory] = loadSubmodule "#{path}/#{directory}/"
    mergeSubmodule mod, sub
  mod


load = (mode)->
  mode ||= process.env.NODE_ENV || "development"
  config = require "#{execPath}/config/#{mode}"
  return unless fs.existsSync "#{execPath}/config/#{mode}/"
  sub = loadSubmodule "#{mode}"
  mergeSubmodule config, sub

load()
config._load = load

module.exports = config