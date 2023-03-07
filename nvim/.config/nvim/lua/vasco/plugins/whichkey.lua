local M = {
  'folke/which-key.nvim',
}

M.keys = { '<leader>' }

function M.config()
  local whichkey = require 'which-key'
  local icons = require 'vasco.helpers.icons'
  local tmux_term = require 'tmux-awesome-manager.src.term'

  whichkey.setup {
    icons = {
      breadcrumb = icons.breadcrumb, -- symbol used in the command line area that shows your active key combo
      separator = icons.right_arrow, -- symbol used between a key and it's label
      group = icons.plus, -- symbol prepended to a group
    },
    window = {
      border = 'rounded', -- none, single, double, shadow
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
    -- Spell
    ['z='] = { '<cmd>Telescope spell_suggest<cr>', 'Spell suggestions' },
    -- Navigation
    ['<C-h>'] = { 'Navigate left' },
    ['<C-j>'] = { 'Navigate down' },
    ['<C-k>'] = { 'Navigate up' },
    ['<C-l>'] = { 'Navigate right' },
    ['˙'] = { ':TmuxResizeLeft<cr>', 'Resize left' },
    ['∆'] = { ':TmuxResizeDown<cr>', 'Resize down' },
    ['˚'] = { ':TmuxResizeUp<cr>', 'Resize up' },
    ['¬'] = { ':TmuxResizeRight<cr>', 'Resize right' },
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
        function()
          vim.lsp.buf.code_action()
        end,
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
        function()
          vim.lsp.buf.references()
        end,
        'References',
      },
      R = {
        function()
          vim.lsp.buf.rename()
        end,
        'Rename',
      },
      l = {
        function()
          vim.diagnostic.open_float()
        end,
        'Line diagnostics',
      },
      [']'] = {
        function()
          vim.diagnostic.goto_next()
        end,
        'Next diagnostic',
      },
      ['['] = {
        function()
          vim.diagnostic.goto_prev()
        end,
        'Previous diagnostic',
      },
      d = {
        function()
          vim.lsp.buf.definition()
        end,
        'Go to definition',
      },
      K = {
        function()
          vim.lsp.buf.hover()
        end,
        'Documentation',
      },
      x = {
        function()
          vim.diagnostic.config { signs = true, virtual_text = true }
        end,
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
      o = { vim.cmd.AerialToggle, 'Outline' },
      g = { vim.cmd.Neogen, 'Generate documentation' },
      c = {
        function()
          vim.g.codeium_enabled = true
        end,
        'Enable AI completion',
      },
      C = {
        function()
          vim.g.codeium_enabled = false
        end,
        'Disable AI completion',
      },
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
      c = { require('diffview.actions').cycle_layout, 'Cycle through available diff layouts' },
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
      s = { '<cmd>Telescope possession list<cr>', 'Sessions' },
      p = { '<cmd>Telescope lazy<cr>', 'Plugins' },
    },
    -- Markdown
    ['<leader>m'] = {
      name = 'Markdown',
      p = { vim.cmd.MarkdownPreview, 'Preview in browser' },
    },
    -- Colors
    ['<leader>C'] = {
      name = 'Colours',
      d = {
        function()
          vim.fn.system 'theme dark'
          Dark()
        end,
        'Dark',
      },
      l = {
        function()
          vim.fn.system 'theme light'
          Light()
        end,
        'Light',
      },
    },
    -- Yarn
    ['<leader>y'] = {
      name = 'Yarn',
      i = tmux_term.run_wk { cmd = 'yarn', name = 'Install', visit_first_call = false, open_as = 'panel' },
      a = tmux_term.run_wk {
        cmd = 'yarn add %1',
        name = 'Add',
        questions = {
          {
            question = 'Yarn package: ',
            required = true,
            open_as = 'pane',
            close_on_timer = 4,
            visit_first_call = false,
            focus_when_call = false,
          },
        },
      },
      d = tmux_term.run_wk {
        cmd = 'yarn add -D %1',
        name = 'Add (development)',
        questions = {
          {
            question = 'Yarn development package: ',
            required = true,
            open_as = 'pane',
            close_on_timer = 4,
            visit_first_call = false,
            focus_when_call = false,
          },
        },
      },
    },
    -- Rails
    ['<leader>r'] = {
      name = 'Rails',
      a = { vim.cmd.A, 'Alternate' },
      v = { vim.cmd.Eview, 'View' },
      h = { vim.cmd.Ehelper, 'Helper' },
      t = { vim.cmd.Espec, 'Test' },
      m = { vim.cmd.Emodel, 'Model' },
      j = { vim.cmd.Ejavascript, 'Javascript' },
      M = { vim.cmd.Emigration, 'Migration' },
      l = { vim.cmd.Elocale, 'Locale' },
      L = { vim.cmd.Elayout, 'Layout' },
      S = { vim.cmd.Estylesheet, 'Stylesheet' },
      c = { vim.cmd.Econtroller, 'Controller' },
      s = tmux_term.run_wk {
        cmd = 'bin/dev',
        name = 'Rails Server 7',
        visit_first_call = false,
        open_as = 'panel',
      },
      w = tmux_term.run_wk {
        cmd = 'bundle exec rails s',
        name = 'Rails Server < 7',
        visit_first_call = false,
        open_as = 'panel',
      },
      r = tmux_term.run_wk {
        cmd = 'bundle exec rails routes',
        name = 'Routes',
        visit_first_call = false,
        open_as = 'panel',
      },
      T = tmux_term.run_wk {
        cmd = 'bundle exec rspec',
        name = 'Run all RSpec tests',
        visit_first_call = false,
        open_as = 'panel',
      },
      C = tmux_term.run_wk { cmd = 'bundle exec rails c', name = 'Rails Console', open_as = 'window' },
      b = tmux_term.run_wk {
        cmd = 'bundle install',
        name = 'Bundle Install',
        open_as = 'pane',
        close_on_timer = 2,
        visit_first_call = false,
        focus_when_call = false,
      },
      u = tmux_term.run_wk {
        cmd = 'bundle update',
        name = 'Bundle Update',
        open_as = 'pane',
        close_on_timer = 2,
        visit_first_call = false,
        focus_when_call = false,
      },
      g = tmux_term.run_wk {
        cmd = 'bundle exec rails generate %1',
        name = 'Rails Generate',
        questions = {
          {
            question = 'Rails generate: ',
            required = true,
            open_as = 'pane',
            close_on_timer = 4,
            visit_first_call = false,
            focus_when_call = false,
          },
        },
      },
      D = tmux_term.run_wk {
        cmd = 'bundle exec rails destroy %1',
        name = 'Rails Destroy',
        questions = {
          {
            question = 'Rails destroy: ',
            required = true,
            open_as = 'pane',
            close_on_timer = 4,
            visit_first_call = false,
            focus_when_call = false,
          },
        },
      },
      d = {
        name = 'Database',
        c = tmux_term.run_wk {
          cmd = 'bundle exec rails db:create',
          name = 'Create',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
        m = tmux_term.run_wk {
          cmd = 'bundle exec rails db:migrate',
          name = 'Migrate',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
        s = tmux_term.run_wk {
          cmd = 'bundle exec rails db:seed',
          name = 'Seed',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
        r = tmux_term.run_wk {
          cmd = 'bundle exec rails db:rollback',
          name = 'Rollback',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
        R = tmux_term.run_wk {
          cmd = 'bundle exec rails db:rollback STEP=%1',
          name = 'Rollback (x steps)',
          questions = {
            {
              question = 'Rollback steps: ',
              required = true,
              open_as = 'pane',
              close_on_timer = 4,
              visit_first_call = false,
              focus_when_call = false,
            },
          },
        },
        d = tmux_term.run_wk {
          cmd = 'bundle exec rails db:drop',
          name = 'Drop',
          open_as = 'pane',
          close_on_timer = 2,
          visit_first_call = false,
          focus_when_call = false,
        },
      },
    },
    -- Zettelkasten
    ['<leader>z'] = {
      name = 'Zettelkasten',
      f = { '<cmd>Telekasten find_notes<cr>', 'Find by title' },
      s = { '<cmd>Telekasten search_notes<cr>', 'Search' },
      l = { '<cmd>Telekasten insert_link<cr>', 'Insert link' },
      n = { '<cmd>Telekasten new_note<cr>', 'New' },
      N = { '<cmd>Telekasten new_templated_note<cr>', 'New from template' },
      r = { '<cmd>Telekasten rename_note<cr>', 'Rename' },
      t = { '<cmd>Telekasten show_tags<cr>', 'Tags' },
      b = { '<cmd>Telekasten show_backlinks<cr>', 'Backlinks' },
      d = { '<cmd>Telekasten goto_today<cr>', 'Today diary' },
      P = { '<cmd>Telekasten paste_img_and_link<cr>', 'Paste image and link' },
      v = { '<cmd>Telekasten switch_vault<cr>', 'Switch vault' },
      p = { '<cmd>Telekasten panel<cr>', 'Panel' },
      g = { '<cmd>Telekasten follow_link<cr>', 'Follow link' },
    },
    -- Plugins
    ['<leader>u'] = {
      name = 'Update',
      p = { vim.cmd.Lazy, 'Plugins' },
      l = { vim.cmd.Mason, 'LSP/Linters/Debuggers' },
      t = { vim.cmd.TSUpdate, 'Treesitter definitions' },
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
end

function M.init() end

return M
