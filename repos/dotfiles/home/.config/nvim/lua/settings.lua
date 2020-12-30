local g = vim.g
local wo = vim.wo
local o = vim.o
local api = vim.api
local fn = vim.fn
local basedir = "/Users/vasco.nunes/.config/nvim/"

g.mapleader = " "

g.python_host_skip_check = 1
g.python_host_prog = "/usr/local/bin/python"
g.python3_host_skip_check = 1
g.python3_host_prog = "/usr/local/bin/python3"
g.loaded_node_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

g.loaded_gzip              = 1
g.loaded_tar               = 1
g.loaded_tarPlugin         = 1
g.loaded_zip               = 1
g.loaded_zipPlugin         = 1
g.loaded_getscript         = 1
g.loaded_getscriptPlugin   = 1
g.loaded_vimball           = 1
g.loaded_vimballPlugin     = 1
g.loaded_2html_plugin      = 1
g.loaded_logiPat           = 1
g.loaded_rrhelper          = 1
g.loaded_netrwPlugin       = 1
g.loaded_netrwSettings     = 1
g.loaded_netrwFileHandlers = 1

wo.number = true
wo.relativenumber = true
o.ttyfast = true
o.showcmd = true
o.clipboard = "unnamed"
o.tabstop = 2
o.shiftwidth = 2
o.inccommand = "nosplit"
o.softtabstop = 2
o.swapfile = false
o.hidden = true
o.joinspaces = false
o.path = vim.o.path .. "**"
o.updatetime = 100
o.signcolumn = 'yes'
o.wildignorecase = false
o.hlsearch = true
o.incsearch = true
o.splitbelow = true
o.splitright = true
o.expandtab = true
o.spelllang = "en_gb"
o.smartindent = true
o.formatoptions = "tcqj"
o.mouse = "a"
o.wrap = false
o.undodir = "/Users/vasco.nunes/.config/nvim/undo"
o.undofile = true
o.undolevels = 100
o.ignorecase = true
o.synmaxcol = 500
o.lazyredraw = true
o.smartcase = true
o.foldlevelstart = 99
o.cmdheight = 2
o.completeopt = "menuone,noselect,noinsert"
o.shortmess = vim.o.shortmess .. "c"
o.pumblend = 7
o.dictionary = "/usr/share/dict/words"
o.thesaurus = "/Users/vasco.nunes/.vim/thesaurii.txt"

local wildignored = {
  "tags", "*/__pycache__/*", "build/*", "build.?/*", "*/node_modules/*", "*/env/*", "*.png", "*.jpg", "*.jpeg",
  "*/migrations/*", "*/.git/*", "*.DS_store"
}

local wildignore = ''
for i = 1, #wildignored do wildignore = wildignore .. wildignored[i] .. ',' end

o.wildignore = wildignore

-- Files with these suffixes get a lower priority when matching a wildcard
local suffixesed = {
  ".aux", ".log", ".dvi", ".bbl", ".blg", ".brf", ".cb", ".ind", ".idx", ".ilg", ".inx", ".out", ".toc", ".o", ".obj",
  ".dll", ".class", ".pyc", ".ipynb", ".so", ".swp", ".zip", ".exe", ".jar", ".gz"
}

local suffixes = ''
for i = 1, #suffixesed do suffixes = suffixes .. suffixesed[i] .. ',' end

o.suffixes = suffixes

-- Create directories if they don't exist
if fn.isdirectory(basedir .. 'undo') == 0 then fn.mkdir(basedir .. 'undo', 'p') end
if fn.isdirectory(basedir .. 'sessions') == 0 then fn.mkdir(basedir .. 'sessions', 'p') end
