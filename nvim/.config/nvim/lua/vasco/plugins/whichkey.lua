local config = require 'vasco.config'

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local whichkey = require 'which-key'
    local icons = require 'vasco.helpers.icons'

    whichkey.setup {
      icons = {
        breadcrumb = icons.breadcrumb, -- symbol used in the command line area that shows your active key combo
        separator = icons.right_arrow, -- symbol used between a key and it's label
        group = icons.plus, -- symbol prepended to a group
      },
      window = {
        border = config.border_style, -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 0, 0, 0, 0 }, -- extra window padding [top, right, bottom, left]
      },
      layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 4, -- spacing between columns
        align = 'left', -- align columns left, center or right
      },
      show_help = false, -- show help message on the command line when the popup is visible
      show_keys = false, -- show the currently pressed key and its label as a message in the command line
      triggers = { '<space>' }, -- or specify a list manually
      zindex = 100,
    }

    local opts = {
      mode = 'n', -- NORMAL mode
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    }

    local mappings = {
      -- ignore
      ['1'] = 'which_key_ignore',
      ['2'] = 'which_key_ignore',
      ['3'] = 'which_key_ignore',
      ['4'] = 'which_key_ignore',
      ['5'] = 'which_key_ignore',
      ['6'] = 'which_key_ignore',
      ['7'] = 'which_key_ignore',
      ['8'] = 'which_key_ignore',
      ['9'] = 'which_key_ignore',
      -- General
      ['<leader>v'] = { '<cmd>cd ~/.config/nvim|e init.lua<cr>', 'Neovim configuration' },
      ['<ESC>'] = { vim.cmd.nohlsearch, 'Clear highlights' },
      ['K'] = {
        function()
          vim.lsp.buf.hover()
        end,
        'LSP documentation',
      },
      ['gd'] = {
        function()
          vim.lsp.buf.definition()
        end,
        'Go to definition',
      },
      ['<leader><space>'] = {
        function()
          vim.o.spell = not vim.o.spell
        end,
        'Toggle spell',
      },
      ['<c-S>'] = { '<cmd>set nospell<cr>', 'Spell off' },
      -- Explorer
      ['<leader>e'] = {
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
        end,
        'Toggle file explorer',
      },
      ['<leader>w'] = { '<cmd>set wrap<cr>', 'Set wrap' },
      ['<leader>W'] = { '<cmd>set nowrap<cr>', 'Unset wrap' },
      -- Spell
      ['z='] = { '<cmd>Telescope spell_suggest<cr>', 'Spell suggestions' },
      -- Navigation
      ['<C-h>'] = { ':SmartCursorMoveLeft<cr>', 'Move right' },
      ['<C-j>'] = { ':SmartCursorMoveDown<cr>', 'Move right' },
      ['<C-k>'] = { ':SmartCursorMoveUp<cr>', 'Move right' },
      ['<C-l>'] = { ':SmartCursorMoveRight<cr>', 'Move right' },
      ['<A-h>'] = { ':SmartResizeLeft<cr>', 'Resize left' },
      ['<A-j>'] = { ':SmartResizeDown<cr>', 'Resize down' },
      ['<A-k>'] = { ':SmartResizeUp<cr>', 'Resize up' },
      ['<A-l>'] = { ':SmartResizeRight<cr>', 'Resize right' },
      -- Splits
      ['vv'] = { '<C-w>v', 'Split vertical' },
      ['ss'] = { '<C-w>s', 'Split horizontal' },
      ['Zz'] = { '<C-w>|<C-w>_', 'Split zoom in' },
      ['Zo'] = { '<C-w>=', 'Split zoom out' },
      -- Zen mode
      ['<leader>Z'] = { vim.cmd.ZenMode, 'Zen mode' },
      -- Buffers
      ['.'] = {
        vim.cmd.bnext,
        'Next buffer',
      },
      [','] = {
        vim.cmd.bprevious,
        'Previous buffer',
      },
      ['<leader>K'] = { vim.cmd.DashWord, 'Dash documentation (current word)' },
      ['<leader>k'] = { vim.cmd.Dash, 'Dash documentation (search)' },
      ['<leader>b'] = {
        name = 'Buffers',
        d = { vim.cmd.bwipeout, 'Remove buffer' },
      },
      -- Tabs
      ['<leader><Tab>'] = {
        name = 'Tabs',
        n = { vim.cmd.tabnew, 'New' },
        c = { vim.cmd.tabclose, 'Close' },
        [']'] = { vim.cmd.tabnext, 'Next' },
        ['['] = { vim.cmd.tabprevious, 'Previous' },
      },
      -- Quick fix
      ['<leader>q'] = {
        name = 'Quickfix',
        q = {
          function()
            require('vasco.helpers.functions').toggle_qf()
          end,
          'Toggle',
        },
        t = { vim.cmd.TodoQuickFix, 'Todos' },
        j = { vim.cmd.cnext, 'Next Quickfix Item' },
        k = { vim.cmd.cprevious, 'Previous Quickfix Item' },
      },
      -- Code
      ['<leader>c'] = {
        name = 'Code',
        p = {
          name = 'Peek',
          c = { 'Class' },
          f = { 'Function' },
        },
        t = { '<c-]>', 'Goto to tag' },
        a = {
          '<cmd>Lspsaga code_action<CR>',
          'Code action',
        },
        s = {
          function()
            vim.lsp.buf.signature_help()
          end,
          'Signature help',
        },
        f = {
          function()
            vim.lsp.buf.format()
          end,
          'Format',
        },
        r = {
          '<cmd>Lspsaga lsp_finder<CR>',
          'References',
        },
        R = {
          '<cmd>Lspsaga rename<CR>',
          'Rename',
        },
        l = {
          ':Lspsaga show_line_diagnostics<cr>',
          'Line diagnostics',
        },
        [']'] = {
          ':Lspsaga diagnostic_jump_next<cr>',
          'Next diagnostic',
        },
        ['['] = {
          ':Lspsaga diagnostic_jump_previous<cr>',
          'Previous diagnostic',
        },
        d = {
          '<cmd>Lspsaga goto_definition<CR>',
          'Go to definition',
        },
        K = {
          '<cmd>Lspsaga hover_doc<CR>',
          'Documentation',
        },
        x = {
          ':Lspsaga show_diagnostics<cr>',
          'Show diagnostics',
        },
        X = {
          function()
            vim.diagnostic.config { signs = false, virtual_text = false }
          end,
          'Hide diagnostics',
        },
        D = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'All diagnostics' },
        i = { vim.cmd.TypescriptOrganizeImports, 'Organize imports (typescript only)' },
        u = { vim.cmd.TypescriptRemoveUnused, 'Remove unused imports (typescript only)' },
        o = { '<cmd>Lspsaga outline<CR>', 'Outline' },
        g = { vim.cmd.Neogen, 'Generate documentation' },
      },
      -- Debug
      ['<leader>d'] = {
        name = 'Debug',
        b = { vim.cmd.DapToggleBreakpoint, 'Breakpoint' },
        c = { vim.cmd.DapContinue, 'Continue' },
        i = { vim.cmd.DapStepInto, 'Step into' },
        o = { vim.cmd.DapStepOver, 'Step over' },
        O = { vim.cmd.DapStepOut, 'Step out' },
        r = { vim.cmd.DapToggleRepl, 'Toggle repl' },
        t = {
          function()
            require('dapui').toggle()
          end,
          'Toggle debug UI',
        },
        K = {
          function()
            require('dap.ui.widgets').hover()
          end,
          'Evaluate hover',
        },
        q = { vim.cmd.DapTerminate, 'Quit' },
      },
      -- Tests
      ['<leader>t'] = {
        name = 'Tests',
        n = {
          function()
            require('neotest').run.run()
          end,
          'Run nearest test',
        },
        f = {
          function()
            require('neotest').run.run(vim.fn.expand '%')
          end,
          'Run file tests',
        },
        S = {
          function()
            require('neotest').run.stop()
          end,
          'Stop',
        },
        s = {
          function()
            require('neotest').summary.toggle()
          end,
          'Summary',
        },
        o = {
          function()
            require('neotest').output.open { enter = true }
          end,
          'Show test output',
        },
      },
      -- Harpoon
      ['<leader>h'] = {
        name = 'Harpoon',
        a = {
          function()
            require('harpoon.mark').add_file()
          end,
          'Add file',
        },
        h = {
          function()
            require('harpoon.ui').toggle_quick_menu()
          end,
          'Toggle files files',
        },
      },
      -- Git
      ['<leader>g'] = {
        name = 'Git',
        g = { vim.cmd.Neogit, 'Neogit' },
        b = {
          function()
            require('gitsigns').blame_line()
          end,
          'Blame',
        },
        s = { '<cmd>Neotree float git_status reveal=true<cr>', 'Status' },
        u = { '<cmd>Gitsigns undo_stage_hunk<cr>', 'Unstage hunk' },
        r = { '<cmd>Gitsigns reset_hunk<cr>', 'Reset hunk' },
        l = { '<cmd>Gitsigns setloclist<cr>', 'View on loclist' },
        y = {
          'require("gitlinker.actions").clipboard',
          'Yank repository URL line',
        },
        C = { require('diffview.actions').cycle_layout, 'Cycle through available diff layouts' },
        ['['] = { require('diffview.actions').next_conflict, 'Jump to the next conflict' },
        [']'] = { require('diffview.actions').prev_conflict, 'Jump to the previous conflict' },
        o = { require('diffview.actions').conflict_choose 'ours', 'Choose the OURS version of a conflict' },
        t = { require('diffview.actions').conflict_choose 'theirs', 'Choose the THEIRS version of a conflict' },
        a = { require('diffview.actions').conflict_choose 'all', 'Choose ALL the versions of a conflict' },
        B = { require('diffview.actions').conflict_choose 'base', 'Choose the BASE version of a conflict' },
        d = { require('diffview.actions').conflict_choose 'none', 'Delete the conflict region' },
      },
      -- Finder
      ['<leader>f'] = {
        name = 'Finder',
        f = { '<cmd>Telescope find_files hidden=true<cr>', 'Files' },
        r = { '<cmd>Telescope resume<cr>', 'Resume' },
        n = { '<cmd>Telescope noice<cr>', 'Noice' },
        c = { '<cmd>Telescope colorscheme<cr>', 'Colorschemes' },
        g = { '<cmd>Telescope live_grep<cr>', 'Grep' },
        G = { '<cmd>Telescope grep_string<cr>', 'Grep word' },
        d = { '<cmd>Telescope diagnostics<cr>', 'Diagnostics' },
        b = { '<cmd>Telescope buffers ignore_current_buffer=true sort_mru=true<cr>', 'Buffers' },
        h = { '<cmd>Telescope help_tags<cr>', 'Help' },
        q = { '<cmd>Telescope quickfix<cr>', 'Quickfix' },
        p = { '<cmd>Telescope lazy<cr>', 'Plugins' },
        t = { vim.cmd.TodoTelescope, 'View TODOs' },
      },
      -- Markdown
      ['<leader>m'] = {
        name = 'Markdown',
        p = { vim.cmd.MarkdownPreview, 'Preview in browser' },
      },
      -- Plugins
      ['<leader>u'] = {
        name = 'Update',
        p = { vim.cmd.Lazy, 'Plugins' },
        l = { vim.cmd.Mason, 'LSP/Linters/Debuggers' },
        t = { vim.cmd.TSUpdate, 'Treesitter definitions' },
      },
      -- Theme
      ['<leader>T'] = {
        name = 'Theme',
        d = { ':set background=dark<cr>', 'Dark' },
        l = { ':set background=light<cr>', 'Light' },
      },
      -- Search
      ['<leader>s'] = {
        name = 'Search & replace',
        s = {
          function()
            require('spectre').open()
          end,
          'Open search & replace',
        },
        g = {
          function()
            require('spectre').open_visual { select_word = true }
          end,
          'Grep current word',
        },
      },
    }

    -- Visual mode
    local visual_opts = {
      mode = 'v', -- NORMAL mode
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    }

    local visual_mappings = {
      -- Git
      ['<leader>g'] = {
        name = 'Git',
        y = {
          '',
          'Yank repository URL line',
        },
      },

      -- Search
      ['<leader>s'] = {
        name = 'Search & replace',
        v = {
          function()
            require('spectre').open_visual()
          end,
          'Grep selected',
        },
      },
      -- Debug
      ['<leader>d'] = {
        name = 'Debug',
        c = { vim.cmd.DapContinue, 'Continue' },
        i = { vim.cmd.DapStepInto, 'Step into' },
        o = { vim.cmd.DapStepOver, 'Step over' },
        O = { vim.cmd.DapStepOut, 'Step out' },
        t = {
          function()
            require('dapui').toggle()
          end,
          'Toggle debug UI',
        },
        K = {
          function()
            require('dap.ui.widgets').hover()
          end,
          'Evaluate hover',
        },
        q = { vim.cmd.DapTerminate, 'Quit' },
      },
      -- Code
      ['<leader>c'] = {
        name = 'Code',
        f = {
          function()
            vim.lsp.buf.format()
          end,
          'Format',
        },
      },
    }

    -- Terminal mode
    local terminal_opts = {
      mode = 't',
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
    }

    local terminal_mappings = {}

    whichkey.register(mappings, opts)
    whichkey.register(visual_mappings, visual_opts)
    whichkey.register(terminal_mappings, terminal_opts)
  end,
}
