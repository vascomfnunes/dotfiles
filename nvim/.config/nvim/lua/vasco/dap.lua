-- DAP
--

local status_ok, dap = pcall(require, 'dap')

if not status_ok then
  return
end

require('dapui').setup()
require('nvim-dap-virtual-text').setup()

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

-- Install chrome debug:
-- git clone https://github.com/Microsoft/vscode-chrome-debug ~/.local/share/nvim/dap/vscode-chrome-debug
-- cd ./vscode-chrome-debug && npm install && npm run build
-- (chrome should be started with '--remote-debugging-port=9222')
dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = { os.getenv 'HOME' .. '/.local/share/nvim/dap/vscode-chrome-debug/out/src/chromeDebug.js' },
}

dap.configurations.javascript = {
  {
    type = 'chrome',
    request = 'attach',
    program = '${file}',
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
    request = 'attach',
    program = '${file}',
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
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}
