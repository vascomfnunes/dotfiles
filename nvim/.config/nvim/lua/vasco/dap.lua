-- DAP
--

local status_ok, dap = pcall(require, 'dap')

if not status_ok then
  return
end

require('dapui').setup()
require('nvim-dap-virtual-text').setup()

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })

-- dap.set_log_level 'TRACE'

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/vscode-node-debug2/out/src/nodeDebug.js' },
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
