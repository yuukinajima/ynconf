// Generated by CoffeeScript 1.9.1
var expect, file_type, fs, node_env,
  hasProp = {}.hasOwnProperty;

fs = require('fs');

require('mocha');

expect = require('chai').expect;

node_env = process.env.NODE_ENV;

file_type = process.env.FILE_TYPE;

describe("config read test", function() {
  before(function() {
    try {
      return fs.unlinkSync("config");
    } catch (_error) {}
  });
  after(function() {
    try {
      return fs.unlinkSync("config");
    } catch (_error) {}
  });
  return it("read dir", function() {
    var config, env, key, results, sub_config, val;
    fs.symlinkSync("./test/sub_dir", "config");
    config = require('../index');
    results = [];
    for (env in config) {
      sub_config = config[env];
      results.push((function() {
        var results1;
        results1 = [];
        for (key in sub_config) {
          if (!hasProp.call(sub_config, key)) continue;
          val = sub_config[key];
          expect(val.lang).to.eql(key);
          results1.push(expect(val.env).to.eql(env));
        }
        return results1;
      })());
    }
    return results;
  });
});
