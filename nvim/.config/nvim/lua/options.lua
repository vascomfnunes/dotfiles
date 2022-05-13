-- OPTIONS
--

local options = {
  completeopt = 'menu,menuone,noselect',
  dictionary = '/usr/share/dict/words',
  fileencoding = 'utf-8',
  ruler = false,
  ignorecase = true,
  foldmethod = 'expr',
  foldexpr = 'nvim_treesitter#foldexpr()',
  foldlevelstart = 99,
  autoread = true,
  joinspaces = false,
  cursorline = false,
  mouse = 'a',
  path = '**',
  wildignore = '**/node_modules/**,**/.git/**',
  pumheight = 6,
  scrolloff = 8,
  showmode = false,
  lazyredraw = true,
  grepprg = 'rg --vimgrep --follow --no-heading',
  smartcase = true,
  smartindent = true,
  spelllang = 'en_gb',
  splitbelow = true,
  splitright = true,
  swapfile = false,
  synmaxcol = 500,
  thesaurus = os.getenv 'HOME' .. '/.config/nvim/thesaurii.txt',
  undodir = os.getenv 'HOME' .. '/.config/nvim/undo',
  undofile = true,
  undolevels = 1000,
  undoreload = 10000,
  updatetime = 250,
  termguicolors = true,
  writebackup = false,
  timeoutlen = 400,
  ttimeoutlen = 50,
  autoindent = true,
  breakindentopt = 'shift:2,min:20',
  breakindent = true,
  expandtab = true,
  foldenable = true,
  linebreak = true,
  number = true,
  relativenumber = true,
  shiftwidth = 2,
  signcolumn = 'yes',
  softtabstop = -2,
  tabstop = 2,
  textwidth = 120,
  wrap = false,
  virtualedit = 'block',
  clipboard = 'unnamed,unnamedplus',
}

local globals = {
  -- Disable filetype plugin, use the new Lua version
  do_filetype_lua = 1,
  did_load_filetypes = 0,

  mapleader = ' ',
  maplocalleader = ' ',

  -- disable some builtin vim plugins
  loaded_gzip = 1,
  loaded_zip = 1,
  loaded_zipPlugin = 1,
  loaded_tar = 1,
  loaded_tarPlugin = 1,
  loaded_getscript = 1,
  loaded_getscriptPlugin = 1,
  loaded_vimball = 1,
  loaded_vimballPlugin = 1,
  loaded_2html_plugin = 1,
  loaded_matchit = 1,
  loaded_matchparen = 1,
  loaded_logiPat = 1,
  loaded_rrhelper = 1,
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  loaded_netrwSettings = 1,

  -- Fill chars needed for folds
  fillchars = 'fold:\\ ',

  -- Disable unused providers
  loaded_ruby_provider = 0,
  loaded_pearl_provider = 0,

  -- Python provider
  python3_host_prog = '~/homebrew/bin/python3',
}

vim.opt.iskeyword:append '-'
vim.opt.shortmess:append 'c'
vim.opt.formatoptions:append 'j' -- Auto-remove comments when combining lines ( <C-J> )
vim.opt.formatoptions:append 'n' -- Indent past the formatlistpat, not underneath it.
vim.opt.formatoptions:append 'q' -- Allow formatting comments w/ gq
vim.opt.formatoptions:remove 'c' --In general, I like it when comments respect textwidth
vim.opt.formatoptions:remove 'r' -- But do continue when pressing enter.
vim.opt.formatoptions:remove 'o' -- O and o, don't continue comments
vim.opt.formatoptions:remove 't' -- Don't auto format my code. I got linters for that.

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end
