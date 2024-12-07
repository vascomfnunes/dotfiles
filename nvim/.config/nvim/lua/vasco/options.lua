-- Function to set the winbar
local function winbar()
  return '%=%f %-m %y'
end

-- Options table
local options = {
  ruler = false,
  ignorecase = true,
  list = true,
  listchars = { tab = '» ', trail = '·', nbsp = '␣' },
  foldmethod = 'expr',
  foldtext = '',
  foldexpr = 'nvim_treesitter#foldexpr()',
  inccommand = 'split',
  foldlevelstart = 99,
  mouse = 'a',
  pumheight = 10,
  scrolloff = 10,
  sidescrolloff = 10,
  hlsearch = true,
  showmode = false,
  showcmd = false,
  smartcase = true,
  smartindent = true,
  spelllang = 'en_gb',
  splitbelow = true,
  splitright = true,
  breakindent = true,
  swapfile = false,
  thesaurus = vim.fn.expand '~/.config/nvim/thesaurii.txt',
  undodir = vim.fn.expand '~/.config/nvim/undo',
  undofile = true,
  undolevels = 1000,
  updatetime = 100,
  writebackup = false,
  timeoutlen = 300,
  ttimeoutlen = 50,
  expandtab = true,
  number = true,
  relativenumber = true,
  shiftwidth = 2,
  signcolumn = 'yes',
  tabstop = 2,
  wrap = false,
  clipboard = 'unnamed,unnamedplus',
  laststatus = 3,
  cmdheight = 0,
  completeopt = { 'menuone', 'noselect', 'popup', 'noinsert' },
  winbar = winbar(),
  smoothscroll = true
}

-- Apply options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Additional settings
vim.opt.iskeyword:append '-'
vim.opt.shortmess:append 'cI' -- don't show redundant messages from ins-completion-menu and the default intro message
vim.opt.whichwrap:append '<>,[],hl'

-- Disable default providers
local default_providers = { 'node', 'perl', 'python3', 'ruby' }
for _, provider in ipairs(default_providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- Global variables
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.fillchars = 'fold:\\ ' -- Fill chars needed for folds
