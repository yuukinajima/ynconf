
{spawnSync} = require 'child_process'

node_envs = [undefined, 'development', 'test']
file_types = ['javascript', 'json', 'coffee', 'cson']

tasks = []
test_cases = []

# make task "test:load_file"
for file_type in file_types
  for node_env in node_envs
    do (file_type, node_env)->
      tasks.push {node_env,file_type}

for _task in tasks
  do (_task) ->
    test_case = "test:load_file:node_env:#{_task.node_env}:file_type:#{_task.file_type}"
    test_cases.push test_case
    task test_case, ->
      env = Object.create( process.env );
      env.NODE_ENV = _task.node_env if _task.node_env
      env.FILE_TYPE = _task.file_type
      val = spawnSync( 'mocha', ["./test/load_single_file.mocha.js"], {env} )

      console.log val.stdout?.toString()
      console.log val.stderr?.toString()

# make task "test:load_dir"
for node_env in node_envs
  do (node_env) ->
    test_case = "test:load_dir:node_env:#{node_env}"
    test_cases.push test_case
    task test_case, ->
      env = Object.create( process.env );
      env.NODE_ENV = node_env if node_env
      val = spawnSync( 'mocha', ["./test/load_dir.mocha.js"], {env} )

      console.log val.stdout?.toString()
      console.log val.stderr?.toString()

# make task "test:load_sub_dir"
do ()->
  test_case = "test:load_sub_dir"
  test_cases.push test_case
  task test_case, ->
    val = spawnSync( 'mocha', ["./test/load_sub_dir.mocha.js"] )

    console.log val.stdout?.toString()
    console.log val.stderr?.toString()


task "test:all", ->
  for test_case in test_cases
    console.info "run", test_case
    invoke test_case
