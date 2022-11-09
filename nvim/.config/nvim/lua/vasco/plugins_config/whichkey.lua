local whichkey = require('which-key')

whichkey.setup {
  icons = {
    breadcrumb = '壟', -- symbol used in the command line area that shows your active key combo
    separator = ' ', -- symbol used between a key and it's label
    group = ' ', -- symbol prepended to a group
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
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = { '<space>' }, -- or specify a list manually
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
  ['<leader>v'] = { ':cd ~/.config/nvim|e init.lua<cr>', 'Neovim configuration' },
  ['<ESC>'] = { ':nohlsearch<cr>', 'Clear highlights' },

  -- Explorer
  ['<leader>e'] = { ':NvimTreeToggle<cr>', 'Toggle file explorer' },

  -- Spell
  ['z='] = { ':Telescope spell_suggest<cr>', 'Spell suggestions' },

  -- Navigation
  ['<C-h>'] = { ':TmuxNavigateLeft<cr>', 'Navigate left' },
  ['<C-j>'] = { ':TmuxNavigateDown<cr>', 'Navigate down' },
  ['<C-k>'] = { ':TmuxNavigateUp<cr>', 'Navigate up' },
  ['<C-l>'] = { ':TmuxNavigateRight<cr>', 'Navigate right' },

  -- Splits
  ['vv'] = { '<C-w>v', 'Split vertical' },
  ['ss'] = { '<C-w>s', 'Split horizontal' },
  ['zz'] = { '<C-w>|<C-w>_', 'Split zoom' },

  -- Buffers
  ['.'] = {
    ':bnext<cr>',
    'Next buffer',
  },

  [','] = {
    ':bprevious<cr>',
    'Previous buffer',
  },

  ['<leader>b'] = {
    name = 'Buffers',
    d = { ':bwipeout<cr>', 'Remove buffer' },
  },

  -- Tabs
  ['<leader>T'] = {
    name = 'Tabs',
    t = { ':tabnew<cr>', 'New' },
    c = { ':tabclose<cr>', 'Close' },
    n = { ':tabnext<cr>', 'Next' },
    p = { ':tabprevious<cr>', 'Previous' },
  },

  -- Code
  ['<leader>c'] = {
    name = 'Code',
    t = { '<c-]>', 'Goto to tag' },
    o = { ':CocOutline<cr>', 'Outline' },
    r = { '<Plug>(coc-rename)', 'Rename symbol' },
    x = { '<Plug>(coc-codeaction)', 'Actions' },
    l = { '<Plug>(coc-codelens-action)', 'Code lens' },
    i = { ':OR<cr>', 'Organize imports' },
    d = { ':CocList diagnostics<cr>', 'Diagnostics' },
    j = { ':CocNext<cr>', 'Next diagnostic' },
    k = { ':CocPrev<cr>', 'Previous diagnostic' },
    a = { 'Swap next param' },
    q = { '<Plug>(coc-fix-current)', 'Quickfix' },
    K = { '<CMD>lua _G.show_docs()<CR>', 'Show documentation' },
    A = { 'Swap previous param' },
    f = { ":Format<cr>", 'Format' },
  },

  -- Debug
  ['<leader>d'] = {
    name = 'Debug',
    b = { ':DapToggleBreakpoint<cr>', 'Breakpoint' },
    c = { ':DapContinue<cr>', 'Continue' },
    i = { ':DapStepInto<cr>', 'Step into' },
    o = { ':DapStepOver<cr>', 'Step over' },
    O = { ':DapStepOut<cr>', 'Step out' },
    r = { ':DapToggleRepl<cr>', 'Toggle repl' },
    t = { ":lua require('dapui').toggle()<cr>", 'Toggle debug UI' },
    K = { ":lua require('dap.ui.widgets').hover()<cr>", 'Evaluate hover' },
    q = { ':DapTerminate<cr>', 'Quit' },
  },

  -- Tests
  ['<leader>t'] = {
    name = 'Tests',
    n = { ':lua require("neotest").run.run()<cr>', 'Run nearest test' },
    f = { ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', 'Run file tests' },
    S = { ':lua require("neotest").run.stop()<cr>', 'Stop' },
    s = { ':lua require("neotest").summary.toggle()<cr>', 'Summary' },
    o = { ':lua require("neotest").output.open({ enter = true })<cr>', 'Show test output' },
  },

  -- Git
  ['<leader>g'] = {
    name = 'Git',
    g = { ":G<cr>", 'Git status' },
    b = { ":Git blame<cr>", 'Blame' },
  },

  -- Finder
  ['<leader>f'] = {
    name = 'Finder',
    f = { ':Telescope find_files<cr>', 'Files' },
    g = { ':Telescope live_grep<cr>', 'Grep' },
    G = { ':Telescope grep_string<cr>', 'Grep word' },
    b = { ':Telescope buffers<cr>', 'Buffers' },
    h = { ':Telescope help_tags<cr>', 'Help' },
    q = { ':Telescope quickfix<cr>', 'Quickfix' },
  },

  -- Markdown
  ['<leader>m'] = {
    name = 'Markdown',
    p = { ':MarkdownPreview<cr>', 'Preview in browser' },
  },

  -- Zettelkasten
  ['<leader>z'] = {
    name = 'Zettelkasten',
    f = { ':Telekasten find_notes<cr>', 'Find by title' },
    s = { ':Telekasten search_notes<cr>', 'Search' },
    l = { ':Telekasten insert_link<cr>', 'Insert link' },
    n = { ':Telekasten new_note<cr>', 'New' },
    N = { ':Telekasten new_templated_note<cr>', 'New from template' },
    r = { ':Telekasten rename_note<cr>', 'Rename' },
    t = { ':Telekasten show_tags<cr>', 'Tags' },
    b = { ':Telekasten show_backlinks<cr>', 'Backlinks' },
    d = { ':Telekasten goto_today<cr>', 'Today diary' },
    P = { ':Telekasten paste_img_and_link<cr>', 'Paste image and link' },
    v = { ':Telekasten switch_vault<cr>', 'Switch vault' },
    p = { ':Telekasten panel<cr>', 'Panel' },
  },

  -- Plugins
  ['<leader>p'] = {
    name = 'Plugins',
    i = { ':PackerInstall<cr>', 'Install' },
    u = { ':PackerUpdate<cr>', 'Update' },
    r = { ':PackerClean<cr>', 'Clean' },
    s = { ':PackerSync<cr>', 'Sync' },
    c = { ':PackerCompile<cr>', 'Compile' },
    S = { ':PackerSnapshot nvim-snapshot.json<cr>', 'Snapshot' },
    R = { ':PackerSnapshotRollback nvim-snapshot.json<cr>', 'Rollback' },
  },

  -- Next
  ['<leader>n'] = {
    name = 'Nx',
    a = { ':Telescope nx actions<cr>', 'Actions' },
    g = { ':Telescope nx generators<cr>', 'Generators' },
    r = { ':Telescope nx run_many<cr>', 'Run many' },
  },

  -- Search
  ['<leader>s'] = {
    name = 'Search & replace',
    s = { ":lua require('spectre').open()<cr>", 'Toggle' },
    g = { ":lua require('spectre').open_visual({select_word=true})<cr>", 'Grep current word' },
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
    v = { ":lua require('spectre').open_visual()<cr>", 'Grep selected' },
  },
}

whichkey.register(mappings, opts)
whichkey.register(visual_mappings, visual_opts)
