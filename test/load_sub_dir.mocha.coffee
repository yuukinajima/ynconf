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
    fs.symlinkSync "./test/sub_dir", "config"
    config = require '../index'
    for env, sub_config of config
      for own key,val of sub_config
        expect(val.lang).to.eql key
        expect(val.env).to.eql env
