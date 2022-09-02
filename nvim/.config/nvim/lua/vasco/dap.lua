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

dap.adapters.nlua = function(cb, config)
  cb { type = 'server', host = config.host, port = config.port }
end

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
    type = 'node2',
    name = 'node attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.expand '%:p:h',
    sourceMaps = true,
    protocol = 'inspector',
  },
  {
    type = 'chrome',
    name = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ['webpack://_N_E/./*'] = '${webRoot}/*',
      ['webpack:///./*'] = '${webRoot}/*',
    },
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.typescript = {
  {
    type = 'node2',
    name = 'node attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.expand '%:p:h',
    sourceMaps = true,
    protocol = 'inspector',
  },
  {
    type = 'chrome',
    name = 'chrome',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ['webpack://_N_E/./*'] = '${webRoot}/*',
      ['webpack:///./*'] = '${webRoot}/*',
    },
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.javascriptreact = {
  {
    type = 'node2',
    name = 'node attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.expand '%:p:h',
    sourceMaps = true,
    protocol = 'inspector',
  },
  {
    type = 'chrome',
    name = 'chrome',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ['webpack://_N_E/./*'] = '${webRoot}/*',
      ['webpack:///./*'] = '${webRoot}/*',
    },
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}

dap.configurations.typescriptreact = {
  {
    type = 'node2',
    name = 'node attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.expand '%:p:h',
    sourceMaps = true,
    protocol = 'inspector',
  },
  {
    type = 'chrome',
    name = 'chrome',
    request = 'attach',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    sourceMapPathOverrides = {
      -- Sourcemap override for nextjs
      ['webpack://_N_E/./*'] = '${webRoot}/*',
      ['webpack:///./*'] = '${webRoot}/*',
    },
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

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local value = vim.fn.input 'Host [default: 127.0.0.1]: '
      return value ~= '' and value or '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input 'Port: ')
      assert(val, 'Please provide a port number')
      return val
    end,
  },
}
