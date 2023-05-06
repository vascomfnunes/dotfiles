local options = {
  fileencoding = 'utf-8',
  ruler = false,
  ignorecase = true,
  foldmethod = 'expr',
  foldexpr = 'nvim_treesitter#foldexpr()',
  foldlevelstart = 99,
  mouse = 'a',
  pumheight = 10,
  termguicolors = true,
  scrolloff = 8,
  sidescrolloff = 8,
  showmode = false,
  showcmd = false,
  smartcase = true,
  smartindent = true,
  spelllang = 'en_gb',
  splitbelow = true,
  splitright = true,
  swapfile = false,
  thesaurus = os.getenv 'HOME' .. '/.config/nvim/thesaurii.txt',
  undodir = os.getenv 'HOME' .. '/.config/nvim/undo',
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
  winbar = '%=%m\\ %f',
  completeopt = { 'menuone', 'noselect' },
}

local globals = {
  mapleader = ' ',
  maplocalleader = ' ',
  -- Fill chars needed for folds
  fillchars = 'fold:\\ ',
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(globals) do
  vim.g[k] = v
end

vim.opt.iskeyword:append '-'
vim.opt.shortmess:append 'c' -- don't show redundant messages from ins-completion-menu
vim.opt.shortmess:append 'I' -- don't show the default intro message
vim.opt.whichwrap:append '<,>,[,],h,l'

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append '<>[]hl'

local default_providers = {
  'node',
  'perl',
  'python3',
  'ruby',
}

for _, provider in ipairs(default_providers) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end
