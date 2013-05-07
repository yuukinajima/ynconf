fs = require 'fs'

config = null

load = (mode)->
  mode ||= process.env.NODE_ENV || "development"
  config = require "../../config/#{mode}"

  return unless fs.existsSync "./config/#{mode}/"
  files = fs.readdirSync "./config/#{mode}/"
  for file in files
    file = file.replace /\.js$/, ""
    file = file.replace /\.coffee$/, ""
    file = file.replace /\.json$/, ""
    config[file] = require "../../config/#{mode}/#{file}"

load()
config._load = load

module.exports = config