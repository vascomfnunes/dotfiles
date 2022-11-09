require('nvim-dap-virtual-text').setup {}

local dap = require('dap')
local daps_path = string.format('%s/dap/', vim.fn.stdpath 'data')

vim.fn.sign_define('DapBreakpoint', { text = ' ', texthl = 'LspDiagnosticsSignError', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = ' ', texthl = 'LspDiagnosticsSignInformation', linehl = '', numhl = '' })
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = ' ', texthl = 'LspDiagnosticSignWarning', linehl = '', numhl = '' }
)

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
-- Add gems to the Gemfile:
-- gem 'debug'
--
-- Make sure to have rdbg in path for current Ruby version:
-- gem install rdbg
dap.adapters.ruby = function(callback, config)
  callback {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "bundle",
      args = { "exec", "rdbg", "-n", "--open", "--port", "${port}",
        "-c", "--", "bundle", "exec", config.command, config.script,
      },
    },
  }
end

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

dap.configurations.typescript = {
  {
    type = 'node2',
    name = 'Attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.expand '%:p:h',
    sourceMaps = true,
    protocol = 'inspector',
  },
  {
    type = 'node2',
    request = 'launch',
    name = 'Jest test',
    runtimeExecutable = 'node',
    runtimeArgs = { '--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest' },
    args = { '${file}', '--runInBand', '--no-cache', '--coverage', 'false' },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
    sourceMaps = 'inline',
    port = 9229,
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
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

dap.configurations.javascript = dap.configurations.typescript
dap.configurations.typescriptreact = dap.configurations.typescript
dap.configurations.javascriptreact = dap.configurations.typescript

dap.configurations.ruby = {
  {
    type = "ruby",
    name = "Rails",
    request = "attach",
    localfs = true,
    command = "rails",
    script = "server"
  },
  {
    type = "ruby",
    name = "Spec on current file",
    request = "attach",
    localfs = true,
    command = "rspec",
    script = "${file}",
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
