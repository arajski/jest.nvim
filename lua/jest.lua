local function get_current_file_path()
  return vim.api.nvim_eval('expand("%:p")')
end

local function create_window()
  vim.api.nvim_command('botright new')
end

local function run_jest(args)
  create_window()
  local t = {}
  table.insert(t, 'terminal yarn test')
  if args ~= nil then
    for _, v in pairs(args) do
      table.insert(t, v)
    end
  end

  local jest_cmd = table.concat(t, '')
  vim.api.nvim_command(jest_cmd)
end

local function test_project()
  run_jest()
end

local function test_file()
  local c_file = get_current_file_path()

  local args = {}
  table.insert(args, ' --runTestsByPath ' .. c_file)
  table.insert(args, ' --watch')
  run_jest(args)

end

local function test_single()
  local c_file = get_current_file_path()
  local line = vim.api.nvim_get_current_line()
  local _, _, test_name = string.find(line, "^%s*%a+%(['\"](.+)['\"]")

  if test_name ~= nil then

    local args = {}
    table.insert(args, ' --runTestsByPath ' .. c_file)
    table.insert(args, " -t='" .. test_name .. "'")
    table.insert(args, " --watch")
    run_jest(args)
  else
    print('ERR: Could not find test name. Place cursor on line with test name.')
  end
end

local function debug_single(args)
  local dap = require('dap')
  local c_file = get_current_file_path()
  local line = vim.api.nvim_get_current_line()

  local _, _, test_name = string.find(line, "^%s*%a+%(['\"](.+)['\"]")

  if test_name ~= nil then

    local runtimeArgs = {}

    table.insert(runtimeArgs, '--inspect-brk')
    table.insert(runtimeArgs, 'node_modules/.bin/jest')
    table.insert(runtimeArgs, c_file)
    table.insert(runtimeArgs, "-t='" .. test_name .. "'")
    local args = {}

    dap.run({
        type = 'node2',
        request = 'launch',
        cwd = vim.fn.getcwd(),
        webRoot = "${workspaceFolder}",
        runtimeArgs = runtimeArgs,
        args = args,
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
        port = 9229,
        outDir = '${workspaceFolder}/dist',
      })

    local widgets = require('dap.ui.widgets')
    local my_sidebar = widgets.sidebar(widgets.scopes)
    my_sidebar.open()

  else
    print('ERR: Could not find test name. Place cursor on line with test name.')
  end
end

return {
  testProject = test_project,
  testFile    = test_file,
  testSingle  = test_single,
  debugSingle = debug_single,
}
