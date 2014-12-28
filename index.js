(function() {
  var confPath, config, execPath, fs, load, loadSubmodule, mergeSubmodule, path;

  fs = require('fs');

  path = require('path');

  execPath = process.cwd();

  confPath = path.resolve(process.env.NODE_PATH + '/../config');

  config = null;

  mergeSubmodule = function(origin, sub) {
    var key, val;
    for (key in sub) {
      val = sub[key];
      if (origin[key] && typeof origin[key] === 'object' && typeof val === 'object') {
        mergeSubmodule(origin[key], val);
      } else {
        origin[key] = val;
      }
    }
    return origin;
  };

  loadSubmodule = function(path) {
    var directories, directory, file, files, list, mod, sub, _i, _j, _len, _len1;
    mod = {};
    if (!fs.existsSync("" + confPath + "/" + path)) {
      return mod;
    }
    list = fs.readdirSync("" + confPath + "/" + path);
    files = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        file = list[_i];
        if (fs.lstatSync("" + confPath + "/" + path + "/" + file).isFile()) {
          _results.push(file);
        }
      }
      return _results;
    })();
    directories = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        file = list[_i];
        if (fs.lstatSync("" + confPath + "/" + path + "/" + file).isDirectory()) {
          _results.push(file);
        }
      }
      return _results;
    })();
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      file = file.replace(/\.js$/, "");
      file = file.replace(/\.coffee$/, "");
      file = file.replace(/\.json$/, "");
      mod[file] = require("" + confPath + "/" + path + "/" + file);
    }
    for (_j = 0, _len1 = directories.length; _j < _len1; _j++) {
      directory = directories[_j];
      sub = {};
      sub[directory] = loadSubmodule("" + path + "/" + directory + "/");
      mergeSubmodule(mod, sub);
    }
    return mod;
  };

  load = function(mode) {
    var sub;
    mode || (mode = process.env.NODE_ENV || "development");
    config = require("" + confPath + "/" + mode);
    if (!fs.existsSync("" + confPath + "/" + mode + "/")) {
      return config;
    }
    sub = loadSubmodule("" + mode);
    return mergeSubmodule(config, sub);
  };

  load();

  config._load = load;

  module.exports = config;

}).call(this);
