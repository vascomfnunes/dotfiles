-- DAP
--

local status_ok, dap = pcall(require, 'dap')

if not status_ok then
  return
end

require('dapui').setup()
require('nvim-dap-virtual-text').setup {}

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

dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Debug Jest Tests',
    runtimeExecutable = 'node',
    runtimeArgs = {
      './node_modules/jest/bin/jest.js',
      '--runInBand',
    },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
  },
}

dap.configurations.typescript = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Debug Jest Tests',
    runtimeExecutable = 'node',
    runtimeArgs = { '--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest' },
    args = { '${file}', '--runInBand', '--coverage', 'false' },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
    sourceMaps = true,
    port = 9229,
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
  },
}

dap.configurations.javascriptreact = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Debug Jest Tests',
    runtimeExecutable = 'node',
    runtimeArgs = {
      './node_modules/jest/bin/jest.js',
      '--runInBand',
    },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
  },
}

dap.configurations.typescriptreact = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Debug Jest Tests',
    runtimeExecutable = 'node',
    runtimeArgs = {
      './node_modules/jest/bin/jest.js',
      '--runInBand',
    },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
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
