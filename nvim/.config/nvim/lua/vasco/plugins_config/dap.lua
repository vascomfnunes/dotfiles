require('nvim-dap-virtual-text').setup {}

local dap = require('dap')
local daps_path = string.format('%s/dap/', vim.fn.stdpath 'data')

vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'LspDiagnosticsSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'LspDiagnosticsSignInformation', linehl = '', numhl = '' })
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = ' ', texthl = 'LspDiagnosticSignWarning', linehl = '', numhl = '' }
)

-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

-- INSTALATION:
-- cd ~/.local/share/nvim
-- git clone https://github.com/microsoft/vscode-node-debug2.git
-- cd ~/dev/microsoft/vscode-node-debug2
-- npm install
-- NODE_OPTIONS=--no-experimental-fetch npm run build
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { daps_path .. '/vscode-node-debug2/out/src/nodeDebug.js' },
}

-- INSTALATION:
-- Install gem with `gem install readapt`
dap.adapters.ruby = {
  type = 'executable',
  command = 'bundle',
  args = { 'exec', 'readapt', 'stdio' },
}

-- INSTALATION:
-- cd ~/.local/share/nvim
-- git clone https://github.com/Microsoft/vscode-chrome-debug
-- cd ~/dev/microsoft/vscode-chrome-debug
-- npm install
-- npm run build
--
-- NOTE:
-- Chrome needs to be in remote debugging mode before starting debugging:
-- '~/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args -remote-debugging-port=9222'
dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = { daps_path .. '/vscode-chrome-debug/out/src/chromeDebug.js' },
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

local dapui = require "dapui"

dapui.setup {
  expand_lines = true,
  icons = { expanded = "", collapsed = "", circular = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.33,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.45 },
        { id = "console", size = 0.55 },
      },
      size = 0.40,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.9,
    max_width = 0.5, -- Floats will be treated as percentage of your screen.
    border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
}

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
