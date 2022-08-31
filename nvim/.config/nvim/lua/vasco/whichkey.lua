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
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions text_objects = false, -- help for text objects triggered after entering an operator
      windows = false, -- default bindings on <c-w>
      nav = false, -- misc bindings to work with windows
      z = false, -- bindings for folds, spelling and others prefixed with z
      g = false, -- bindings for prefixed with g
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
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
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
  -- triggers = "auto", -- automatically setup triggers
  triggers = { '<leader>' }, -- or specify a list manually
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
  prefix = '<leader>',
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

  -- single
  ['n'] = { 'Toggle file explorer' },
  ['q'] = { 'Quickfix list' },
  ['v'] = { 'Neovim configuration' },

  b = {
    name = 'Buffers',
    d = { 'Remove buffer' },
  },

  c = {
    name = 'Colours',
    l = { 'Light theme' },
    d = { 'Dark theme' },
  },

  l = {
    name = 'LSP',
    a = { 'Code action' },
    s = { 'Signature help' },
    f = { 'Format' },
    v = { 'Preview definition' },
    o = { 'Outline' },
    r = { 'References' },
    R = { 'Rename' },
    l = { 'Line diagnostics' },
    D = { 'All diagnostics' },
    n = { 'Next diagnostic' },
    p = { 'Previous diagnostic' },
    d = { 'Go to definition' },
    K = { 'Documentation' },
  },

  d = {
    name = 'Debug/Documentation',
    b = { 'Breakpoint' },
    c = { 'Continue' },
    i = { 'Step into' },
    o = { 'Step over' },
    O = { 'Step out' },
    r = { 'Toggle repl' },
    t = { 'Toggle debug UI' },
    K = { 'Evaluate hover' },
    q = { 'Quit' },
    s = { 'Search in Dash' },
    g = { 'Generate documentation' },
  },

  t = {
    name = 'Tests',
    n = { 'Run nearest test' },
    f = { 'Run file tests' },
    S = { 'Stop' },
    s = { 'Summary' },
    d = { 'Debug' },
    o = { 'Show test output' },
  },

  g = {
    name = 'Git',
    g = { 'Neogit' },
    b = { 'Blame' },
    s = { 'Stage hunk' },
    u = { 'Unstage hunk' },
    r = { 'Reset hunk' },
    l = { 'View on loclist' },
  },

  f = {
    name = 'Finder',
    f = { 'Files' },
    g = { 'Grep' },
    G = { 'Grep word' },
    b = { 'Buffers' },
    d = { 'Diagnostics' },
    h = { 'Help' },
    q = { 'Quickfix' },
  },

  m = {
    name = 'Markdown',
    p = { 'Preview in browser' },
    t = { 'Generate TOC' },
    u = { 'Update TOC' },
    ['['] = { 'Previous header' },
    [']'] = { 'Next header' },
  },

  z = {
    name = 'Zettelkasten',
    f = { 'Find by title' },
    s = { 'Search' },
    l = { 'Insert link' },
    n = { 'New' },
    N = { 'New from template' },
    r = { 'Rename' },
    t = { 'Tags' },
    b = { 'Backlinks' },
    d = { 'Today diary' },
    P = { 'Paste image and link' },
    v = { 'Switch vault' },
    p = { 'Panel' },
  },

  p = {
    name = 'Project',
    a = { 'Alternate file' },
    v = { 'View' },
    c = { 'Controller' },
    m = { 'Model' },
    h = { 'Helper' },
    t = { 'Test' },
    j = { 'Javascript' },
    s = { 'Stylesheet' },
    r = { 'Search and replace' },
  },

  x = {
    name = 'Nx',
    a = { 'Actions' },
    g = { 'Generators' },
    r = { 'Run many' },
  },
}

local wk = require 'which-key'
wk.register(mappings, opts)
