local ok, whichkey = pcall(require, 'which-key')

if not ok then
  return
end

whichkey.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions text_objects = false, -- help for text objects triggered after entering an operator
      text_objects = true,
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = 'Comments' },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
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
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = { '<space>' }, -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { 'j', 'k' },
    v = { 'j', 'k' },
  },
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
  ['<leader>n'] = { ':NvimTreeToggle<cr>', 'Toggle file explorer' },

  -- Spell
  ['z='] = { ':Telescope spell_suggest', 'Spell suggestions' },

  -- Navigation
  ['<C-b>'] = { '<ESC>^', 'Beginning of line' },
  ['<C-e>'] = { '<End>', 'End of line' },
  ['<A-J>'] = { ':m .+1<cr>', 'Move line down' },
  ['<A-K>'] = { ':m .-2<cr>', 'Move line up' },
  ['<C-h>'] = { ":lua require('vasco.kitty').navigate 'h'<cr>", 'Navigate left' },
  ['<C-j>'] = { ":lua require('vasco.kitty').navigate 'j'<cr>", 'Navigate down' },
  ['<C-k>'] = { ":lua require('vasco.kitty').navigate 'k'<cr>", 'Navigate up' },
  ['<C-l>'] = { ":lua require('vasco.kitty').navigate 'l'<cr>", 'Navigate right' },
  ['<A-h>'] = { '<C-w><', 'Resize left' },
  ['<A-j>'] = { '<C-w>-', 'Resize down' },
  ['<A-k>'] = { '<C-w>+', 'Resize up' },
  ['<A-l>'] = { '<C-w>>', 'Resize right' },

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
  ['<c-t>'] = { ':tabnew<cr>', 'New tab' },
  ['<c-x>'] = { ':tabclose<cr>', 'Close tab' },
  ['<tab>'] = { ':tabnext<cr>', 'Next tab' },

  -- Indentation
  ['<'] = { '<gv', 'Indent left' },
  ['>'] = { '>gv', 'Indent right' },

  -- Theme
  ['<leader>T'] = {
    name = 'Theme',
    l = { ":lua SetColorscheme('light')<cr>", 'Light' },
    d = { ":lua SetColorscheme('dark')<cr>", 'Dark' },
  },

  -- Quick fix
  ['<leader>q'] = {
    name = 'Quickfix',
    q = { ':lua require("functions").toggle_qf()<cr>', 'Toggle' },
    t = { ':TodoQuickFix<cr>', 'Todos' },
    j = { ':cnext<cr>', 'Next Quickfix Item' },
    k = { ':cprevious<cr>', 'Previous Quickfix Item' },
  },

  -- LSP
  ['<leader>l'] = {
    name = 'LSP',
    a = { ':lua vim.lsp.buf.code_action()<cr>', 'Code action' },
    s = { ':lua vim.lsp.buf.signature_help()<cr>', 'Signature help' },
    f = { ':lua vim.lsp.buf.formatting()<cr>', 'Format' },
    r = { ':lua vim.lsp.buf.references()<cr>', 'References' },
    R = { ':lua vim.lsp.buf.rename()<cr>', 'Rename' },
    l = { ':lua vim.diagnostic.open_float()<cr>', 'Line diagnostics' },
    D = { ':Telescope diagnostics bufnr=0<cr>', 'All diagnostics' },
    n = { ':lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic' },
    p = { ':lua vim.diagnostic.goto_previous()<cr>', 'Previous diagnostic' },
    d = { ':lua vim.lsp.buf.definition()<cr>', 'Go to definition' },
    K = { ':lua vim.lsp.buf.hover()<cr>', 'Documentation' },
  },

  -- Debug/documentation
  ['<leader>d'] = {
    name = 'Debug/Documentation',
    b = { ':DapToggleBreakpoint<cr>', 'Breakpoint' },
    c = { ':DapContinue<cr>', 'Continue' },
    i = { ':DapStepInto<cr>', 'Step into' },
    o = { ':DapStepOver<cr>', 'Step over' },
    O = { ':DapStepOut<cr>', 'Step out' },
    r = { ':DapToggleRepl<cr>', 'Toggle repl' },
    t = { ":lua require('dapui').toggle()", 'Toggle debug UI' },
    K = { ":lua require('dap.ui.widgets').hover()<cr>", 'Evaluate hover' },
    q = { ':DapTerminate<cr>', 'Quit' },
    s = { ':Dash<cr>', 'Search in Dash' },
    l = { ':lua require"osv".run_this()<cr>', 'Start lua dap' },
    g = { ':Neogen<cr>', 'Generate documentation' },
  },

  -- Tests
  ['<leader>t'] = {
    name = 'Tests',
    n = { ':lua require("neotest").run.run()<cr>', 'Run nearest test' },
    f = { ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>', 'Run file tests' },
    S = { ':lua require("neotest").run.stop()<cr>', 'Stop' },
    s = { ':lua require("neotest").summary.toggle()<cr>', 'Summary' },
    d = { ':lua require"jester".debug()<cr>', 'Debug' },
    o = { ':lua require("neotest").output.open({ enter = true })<cr>', 'Show test output' },
  },

  -- Git
  ['<leader>g'] = {
    name = 'Git',
    g = { ':Neogit<cr>', 'Neogit' },
    b = { ":lua require('gitsigns').blame_line()<cr>", 'Blame' },
    s = { ':Gitsigns stage_hunk<cr>', 'Stage hunk' },
    u = { ':Gitsigns undo_stage_hunk<cr>', 'Unstage hunk' },
    r = { ':Gitsigns reset_hunk<cr>', 'Reset hunk' },
    l = { ':Gitsigns setloclist<cr>', 'View on loclist' },
  },

  -- Finder
  ['<leader>f'] = {
    name = 'Finder',
    f = { ':Telescope find_files<cr>', 'Files' },
    g = { ':Telescope live_grep<cr>', 'Grep' },
    G = { ':Telescope grep_string<cr>', 'Grep word' },
    b = { ':Telescope buffers<cr>', 'Buffers' },
    d = { ':Telescope diagnostics<cr>', 'Diagnostics' },
    h = { ':Telescope help_tags<cr>', 'Help' },
    q = { ':Telescope quickfix<cr>', 'Quickfix' },
    s = { ':Telescope possession list<cr>', 'Sessions' },
  },

  -- Markdown
  ['<leader>m'] = {
    name = 'Markdown',
    p = { ':MarkdownPreview<cr>', 'Preview in browser' },
    t = { ':GenTocGFM<cr>', 'Generate TOC' },
    u = { ':UpdateToc<cr>', 'Update TOC' },
    h = { ':Telescope heading<cr>', 'Headings outline' },
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

  -- Project
  ['<leader>p'] = {
    name = 'Project',
    r = { ":lua require('spectre').open_visual({select_word=true})<cr>", 'Search and replace' },
  },

  -- Next
  ['<leader>x'] = {
    name = 'Nx',
    a = { ':Telescope nx actions<cr>', 'Actions' },
    g = { ':Telescope nx generators<cr>', 'Generators' },
    r = { ':Telescope nx run_many<cr>', 'Run many' },
  },
}

local wk = require 'which-key'
wk.register(mappings, opts)
