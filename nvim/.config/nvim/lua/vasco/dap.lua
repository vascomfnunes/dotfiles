-- DAP
--

local status_ok, dap = pcall(require, 'dap')

if not status_ok then
  return
end

require('dapui').setup()
require('nvim-dap-virtual-text').setup {}

local mason_path = string.format('%s/mason/', vim.fn.stdpath 'data')

vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'LspDiagnosticsSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'LspDiagnosticsSignInformation', linehl = '', numhl = '' })
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = ' ', texthl = 'LspDiagnosticSignWarning', linehl = '', numhl = '' }
)

-- dap.set_log_level 'TRACE'

-- dap.defaults.fallback.external_terminal = {
--   command = os.getenv 'HOME' .. '/homebrew/bin/kitty',
--   args = { '-e' },
-- }
--
-- dap.defaults.fallback.force_external_terminal = true

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.adapters.ruby = {
  type = 'executable',
  command = 'bundle',
  args = { 'exec', 'readapt', 'stdio' },
}

-- Chrome needs to be in remote debugging mode before starting debugging:
-- '~/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args -remote-debugging-port=9222'
dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = { mason_path .. 'packages/chrome-debug-adapter/out/src/chromeDebug.js' },
}

dap.configurations.javascript = {
  {
    type = 'chrome',
    name = 'Javascript (Chrome)',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.typescript = {
  {
    type = 'chrome',
    name = 'Typescript (Chrome)',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.javascriptreact = {
  {
    type = 'chrome',
    name = 'Javascript React (Chrome)',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.typescriptreact = {
  {
    type = 'chrome',
    name = 'Typescript React (Chrome)',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.ruby = {
  {
    type = 'ruby',
    request = 'launch',
    name = 'Rails',
    program = 'bundle',
    programArgs = { 'exec', 'rails', 's' },
    useBundler = true,
  },
}
