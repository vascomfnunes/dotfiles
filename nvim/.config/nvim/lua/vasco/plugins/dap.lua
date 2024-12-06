return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/neotest',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'LiadOz/nvim-dap-repl-highlights',
    'theHamsta/nvim-dap-virtual-text',
    'suketa/nvim-dap-ruby', -- This requires debug gem to be installed!
  },
  keys = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { '<leader>dc', dap.continue, desc = 'Debug: Start/Continue' },
      { '<leader>ds', dap.step_into, desc = 'Debug: Step Into' },
      { '<leader>dn', dap.step_over, desc = 'Debug: Step Over' },
      { '<leader>do', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>di', dapui.eval, desc = 'Inspect' },
      { '<leader>dq', dap.terminate, desc = 'Terminate' },
      { '<leader>dr', dap.repl.open, desc = 'Open REPL' },
      {
        '<leader>dB',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { '<leader>dt', dapui.toggle, desc = 'Toggle UI' },
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('dap-ruby').setup()
    require('nvim-dap-repl-highlights').setup()
    require('nvim-dap-virtual-text').setup()

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
          breakpoint = '⏏',
        },
      },
    }

    vim.fn.sign_define(
      'DapBreakpoint',
      { text = '⏹', texthl = 'DiagnosticError', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapBreakpointCondition',
      { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapBreakpointRejected',
      { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapLogPoint',
      { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
    )
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticSign' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
