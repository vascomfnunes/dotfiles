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

dap.set_log_level 'TRACE'

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.javascript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Debug Jest Tests',
    -- trace = true, -- include debugger info
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

-- Install DAP chrome-debug-adapter with Mason
-- (chrome should be started before e.g. '~/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args -remote-debugging-port=9222')
-- dap.adapters.chrome = {
--   type = 'executable',
--   command = 'node',
--   args = { vim.fn.stdpath 'data' .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js' },
-- }
--
-- dap.configurations.javascript = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}',
--   },
-- }
--
-- dap.configurations.typescript = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}',
--   },
-- }
--
-- dap.configurations.javascriptreact = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}',
--   },
-- }
--
-- dap.configurations.typescriptreact = {
--   {
--     type = 'chrome',
--     request = 'attach',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     port = 9222,
--     webRoot = '${workspaceFolder}',
--   },
-- }
