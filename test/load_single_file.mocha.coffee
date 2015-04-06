fs = require 'fs'
require 'mocha'
{expect} = require 'chai'

node_env = process.env.NODE_ENV
file_type = process.env.FILE_TYPE

describe "config read test", ->
  before ->
    try fs.unlinkSync "config"
  after ->
    try fs.unlinkSync "config"

  it "read config file #{node_env}, #{file_type}", () ->
    fs.symlinkSync "./test/#{file_type}", "config"
    config = require '../index'
    if node_env
      expect(config.env).to.eql node_env
    else
      expect(config.env).to.eql "development"
    expect(config.lang).to.eql file_type
