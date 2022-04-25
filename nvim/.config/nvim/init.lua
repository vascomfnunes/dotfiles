-- GENERAL
--

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable some builtin vim plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- Python provider
vim.g.python3_host_prog = '/usr/local/bin/python3'

-- OPTIONS
--
vim.o.completeopt = 'menuone,noselect'
vim.o.dictionary = '/usr/share/dict/words'
vim.o.fileencoding = 'utf-8'
vim.o.ruler = false
vim.o.wildignore = '.git**/node_modules/**'
vim.o.ignorecase = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99
vim.o.autoread = true
vim.o.joinspaces = false
vim.o.cursorline = false
vim.o.mouse = 'a'
vim.o.path = '**'
vim.o.pumheight = 6
vim.o.scrolloff = 8
vim.o.shortmess = 'atToOc'
vim.o.showmode = false
vim.o.lazyredraw = true
vim.o.grepprg = 'rg --vimgrep --follow --no-heading'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelllang = 'en_gb'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.synmaxcol = 500
vim.o.thesaurus = os.getenv 'HOME' .. '/.config/nvim/thesaurii.txt'
vim.o.undodir = os.getenv 'HOME' .. '/.config/nvim/undo'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.updatetime = 250
vim.opt.termguicolors = true
vim.o.writebackup = false
vim.o.timeoutlen = 400
vim.o.ttimeoutlen = 50
vim.o.autoindent = true
vim.o.breakindentopt = 'shift:2,min:20'
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.foldenable = true
vim.o.linebreak = true
vim.wo.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.wo.signcolumn = 'yes'
vim.o.softtabstop = -2
vim.o.tabstop = 2
vim.o.textwidth = 120
vim.o.wrap = false
vim.o.virtualedit = 'block'
vim.o.clipboard = 'unnamedplus'

vim.opt.iskeyword = vim.opt.iskeyword + '-'
vim.opt.formatoptions = vim.opt.formatoptions
  + 'j' -- Auto-remove comments when combining lines ( <C-J> )
  + 'n' -- Indent past the formatlistpat, not underneath it.
  + 'q' -- Allow formatting comments w/ gq
  - 'c' -- In general, I like it when comments respect textwidth
  - 'r' -- But do continue when pressing enter.
  - 'o' -- O and o, don't continue comments
  - 't' -- Don't auto format my code. I got linters for that.

-- AUTOCOMMANDS
--

local custom_group = vim.api.nvim_create_augroup('CustomCmdGroup', { clear = true })

-- Highlight line on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = custom_group,
  pattern = '*',
})

-- Trim whitespaces
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = custom_group,
  pattern = { '*' },
  command = '%s/\\s\\+$//e',
})

-- PLUGINS
--

-- Clone packer first:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
  }

  use {
    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',
  }

  use {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
  }

  use 'jose-elias-alvarez/null-ls.nvim'

  use 'PlatyPew/format-installer.nvim'

  use 'windwp/nvim-ts-autotag'

  use 'echasnovski/mini.nvim'

  use 'norcalli/nvim-colorizer.lua'

  use { 'TimUntersberger/neogit', cmd = { 'Neogit' } }

  use { 'github/copilot.vim', cmd = { 'Copilot' } }

  use { 'rizzatti/dash.vim', cmd = 'Dash' }

  use 'kyazdani42/nvim-tree.lua'

  use 'kyazdani42/nvim-web-devicons'
end)

-- GIT SIGNS
--

require('gitsigns').setup()

-- NVIM TREE
--

local g = vim.g

g.nvim_tree_show_icons = { folders = 1, files = 1, git = 0 }

require('nvim-tree').setup {
  nvim_tree_ignore = { '.git', '.node_modules', '.cache' },
  update_cwd = true,
  update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  trash = {
    cmd = 'trash',
    require_confirm = true,
  },
  view = {
    width = 40,
    side = 'right',
    mappings = {
      -- custom only false will merge the list with the default mappings
      -- if true, it will only use your list to set the mappings
      custom_only = false,
      -- list of mappings to set on the tree manually
      list = {
        { key = { '<CR>', 'o', 'l' }, action = 'edit' },
        { key = '<C-v>', action = 'vsplit' },
        { key = '<C-s>', action = 'split' },
        { key = '<C-t>', action = 'tabnew' },
        { key = 'h', action = 'close_node' },
        { key = '<Tab>', action = 'preview' },
        { key = 'H', action = 'toggle_dotfiles' },
        { key = 'R', action = 'refresh' },
        { key = 'a', action = 'create' },
        { key = 'd', action = 'remove' },
        { key = 'r', action = 'rename' },
        { key = 'x', action = 'cut' },
        { key = 'y', action = 'copy' },
        { key = 'p', action = 'paste' },
        { key = 'Y', action = 'copy_name' },
        { key = 'C', action = 'copy_path' },
        { key = 'gy', action = 'copy_absolute_path' },
        { key = '-', action = 'dir_up' },
        { key = 'q', action = 'close' },
        { key = 'g?', action = 'toggle_help' },
      },
    },
  },
}

-- TREESITTER
--

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'css',
    'dockerfile',
    'go',
    'graphql',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'regex',
    'ruby',
    'scss',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },
}

-- AUTOTAGS
--

require('nvim-ts-autotag').setup()

-- COMPLETION
--

local cmp = require 'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-l>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'spell' },
  },
  view = {
    entries = 'native',
  },
}

-- LSP
--

local lsp_installer = require 'nvim-lsp-installer'
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_installer.on_server_ready(function(server)
  local opts = { capabilities = capabilities }
  server:setup(opts)
end)

-- Diagnostic signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- NULL-LS
--

local null_ls = require 'null-ls'
local formatter_install = require 'format-installer'

local sources = {}

for _, formatter in ipairs(formatter_install.get_installed_formatters()) do
  local config = { command = formatter.cmd }
  table.insert(sources, null_ls.builtins.formatting[formatter.name].with(config))
end

null_ls.setup { sources = sources }

-- SNIPS
--

require('luasnip.loaders.from_vscode').lazy_load()

-- TELESCOPE
--

local actions = require 'telescope.actions'
local telescope = require 'telescope'

telescope.setup {
  defaults = {
    preview = { hide_on_startup = false },
    file_ignore_patterns = { '.node_modules', '.git', 'undo', 'tmp', 'fonts', 'images', 'vendor' },
    prompt_prefix = '❯ ',
    selection_caret = '❯ ',
    sorting_strategy = 'ascending',
    scroll_strategy = 'cycle',
    path_display = { 'absolute' },
    layout_config = { prompt_position = 'top' },
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<c-l>'] = actions.select_default + actions.center,
      },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  },
}

telescope.load_extension 'fzy_native'

-- MINI
--

require('mini.comment').setup()
require('mini.tabline').setup()
require('mini.pairs').setup()
require('mini.statusline').setup()
require('mini.surround').setup {
  mappings = {
    add = 'sa', -- Add surrounding
    delete = 'sd', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'cs', -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`
  },
}
require('mini.indentscope').setup {
  draw = {
    delay = 100,
    animation = require('mini.indentscope').gen_animation 'none',
  },
  symbol = '│',
}

require('mini.base16').setup {
  -- palette based on Gruvbox Material Dark Soft
  palette = {
    base00 = '#32302f', -- Default Background
    base01 = '#32302f', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#444444', -- Selection Background
    base03 = '#666666', -- Comments, Invisibles, Line Highlighting
    base04 = '#999999', -- Dark Foreground (Used for status bars)
    base05 = '#d4be98', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#666666', -- Light Foreground (Not often used)
    base07 = '#32302f', -- Light Background (Not often used)
    base08 = '#7daea3', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#e78a4e', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#ea6962', -- Classes, Markup Bold, Search Text Background
    base0B = '#a9b665', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#d3869b', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#89b482', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#d3869b', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#d4be98', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  name = 'minischeme',
  use_cterm = true,
}

-- COLORIZER
--

require('colorizer').setup()

-- MAPPINGS
--

vim.keymap.set('n', '<leader>v', ':cd ~/.config/nvim|e init.lua<cr>') -- neovim configuration
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('c', 'W', 'w')
vim.keymap.set('n', '<leader>q', ':copen<cr>') -- open quicklist
vim.keymap.set('n', '<leader>c', ':nohlsearch<cr>') -- clear search highlights
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<cr>') -- explorer

-- Splits
vim.keymap.set('n', 'vv', '<c-w>v')
vim.keymap.set('n', 'ss', '<c-w>s')

-- Movement
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')

-- Tabs
vim.keymap.set('n', '<c-t>', ':tabnew<cr>') -- new tab
vim.keymap.set('n', '<c-x>', ':tabclose<cr>') -- close tab
vim.keymap.set('n', '<tab>', ':tabnext<cr>') -- next tab

-- Indentation
vim.keymap.set('v', '<', '<gv') -- indent left
vim.keymap.set('v', '>', '>gv') -- indent right

-- Buffers
vim.keymap.set('n', ',', ':bprevious<cr>') -- previous buffer
vim.keymap.set('n', '.', ':bnext<cr>') -- next buffer

-- Finder
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>') -- files
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>') -- help
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>') -- live grep
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>') -- list buffers
vim.keymap.set('n', '<leader>fG', ':Telescope grep_string<cr>') -- grep string under cursor
vim.keymap.set('n', '<leader>fq', ':Telescope quickfix<cr>') -- quickfix

-- Git
vim.keymap.set('n', '<leader>gg', ':Neogit<cr>') -- git status

vim.keymap.set('n', '<leader>gb', function()
  require('gitsigns').blame_line() -- git blame line
end)

-- Copilot
vim.keymap.set('n', '<leader>ce', ':<Cmd>Copilot enable<cr>') -- enable copilot
vim.keymap.set('n', '<leader>cd', ':<Cmd>Copilot disable<cr>') -- disable copilot
vim.keymap.set('n', '<leader>cs', ':<Cmd>Copilot status<cr>') -- copilot status

vim.keymap.set('n', '<leader>ds', ':Dash<cr>') -- search in dash

-- Lsp
vim.keymap.set('n', '<leader>fd', ':Telescope diagnostics bufnr=0<cr>') -- show lsp diagnostics
vim.keymap.set('n', '<leader>ls', ':Telescope lsp_document_symbols<cr>') -- show lsp symbols

vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.formatting() -- lsp format
end)

vim.keymap.set('n', '<leader>lr', function()
  vim.lsp.buf.references() -- lsp references
end)

vim.keymap.set('n', '<leader>la', function()
  vim.lsp.buf.code_action() -- lsp code action
end)

vim.keymap.set('n', '<leader>lR', function()
  vim.lsp.buf.rename() -- lsp rename
end)

vim.keymap.set('n', '<leader>ld', function()
  vim.diagnostic.open_float() -- lsp line diagnostics
end)

vim.keymap.set('n', '<leader>ln', function()
  vim.diagnostic.goto_next() -- lsp next diagnostic
end)

vim.keymap.set('n', '<leader>lp', function()
  vim.diagnostic.goto_prev() -- lsp previous diagnostic
end)

vim.keymap.set('n', 'gd', function()
  vim.lsp.buf.definition() -- lsp go to definition
end)

vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover() -- lsp hover documentation
end)

-- HIGHLIGHTS
--

vim.api.nvim_set_hl(0, 'MiniStatusLineInactive', { bg = '#444444' })
vim.api.nvim_set_hl(0, 'MiniStatusLineFilename', { bg = '#444444', fg = '#999999' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#444444', fg = '#888888' })
vim.api.nvim_set_hl(0, 'Title', { fg = '#dddddd' })
vim.api.nvim_set_hl(0, 'SpellBad', { fg = '#ea6962' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#a9b665' })
vim.api.nvim_set_hl(0, 'CmpItemKind', { fg = '#ea6962' })
vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = '#7daea3' })
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#ea6962' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#e78a4e' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#89b482' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#89b482' })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg = '#ea6962' })
vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg = '#e78a4e' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg = '#89b482' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg = '#89b482' })
vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#dddddd' })
vim.api.nvim_set_hl(0, 'NVimTreeWindowPicker', { fg = '#ea6962' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#444444' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#d4be98' })
vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#444444' })
