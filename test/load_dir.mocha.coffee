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

  it "read dir", () ->
    fs.symlinkSync "./test/many_types", "config"
    config = require '../index'
    for own key,val of config
      expect(val.lang).to.eql key
      if node_env
        expect(val.env).to.eql node_env
      else
        expect(val.env).to.eql "development"
