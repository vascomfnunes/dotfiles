-- OPTIONS
--

local options = {
  completeopt = 'menu,menuone',
  dictionary = '/usr/share/dict/words',
  fileencoding = 'utf-8',
  ruler = false,
  ignorecase = true,
  foldmethod = 'expr',
  foldexpr = 'nvim_treesitter#foldexpr()',
  foldlevelstart = 99,
  mouse = 'a',
  path = '**',
  wildmode = 'full',
  wildignore = [[
    .git,.hg,.svn
    *.aux,*.out,*.toc
    *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
    *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
    *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
    *.mp3,*.oga,*.ogg,*.wav,*.flac
    *.eot,*.otf,*.ttf,*.woff
    *.doc,*.pdf,*.cbr,*.cbz
    *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
    *.swp,.lock,.DS_Store,._*
    */tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
  ]],
  pumheight = 6,
  scrolloff = 8,
  showmode = false,
  grepprg = 'rg --vimgrep --follow --no-heading',
  smartcase = true,
  smartindent = true,
  spelllang = 'en_gb',
  spell = false,
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
  timeoutlen = 300,
  ttimeoutlen = 50,
  breakindentopt = 'shift:2,min:20',
  breakindent = true,
  expandtab = true,
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
  laststatus = 3,
  winbar = '%f',
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

-- disable some builtin vim plugins
local default_plugins = {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'matchit',
  'tar',
  'tarPlugin',
  'rrhelper',
  'spellfile_plugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
  'tutor',
  'rplugin',
  'syntax',
  'synmenu',
  'optwin',
  'compiler',
  'bugreport',
  'ftplugin',
}

for _, plugin in pairs(default_plugins) do
  vim.g['loaded_' .. plugin] = 1
end

vim.opt.iskeyword:append '-'
-- vim.opt.shortmess:append 'c'
vim.opt.formatoptions:append 'j' -- Auto-remove comments when combining lines ( <C-J> )
-- vim.opt.formatoptions:append 'n' -- Indent past the formatlistpat, not underneath it.
vim.opt.formatoptions:append 'q' -- Allow formatting comments w/ gq
vim.opt.formatoptions:remove 'c' --In general, I like it when comments respect textwidth
-- vim.opt.formatoptions:append 'r' -- But do continue when pressing enter.
vim.opt.formatoptions:remove 'o' -- O and o, don't continue comments
vim.opt.formatoptions:remove 't' -- Don't auto format my code. I got linters for that.

-- disable nvim intro
vim.opt.shortmess:append 'sI'

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
