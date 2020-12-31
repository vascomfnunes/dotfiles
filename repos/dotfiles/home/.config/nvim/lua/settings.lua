local M = {}
local g = vim.g
local wo = vim.wo
local o = vim.o
local fn = vim.fn
local basedir = "/Users/vasco.nunes/.config/nvim/"

local function create_directories()
  if fn.isdirectory(basedir .. 'undo') == 0 then
    fn.mkdir(basedir .. 'undo', 'p')
  end
  if fn.isdirectory(basedir .. 'sessions') == 0 then
    fn.mkdir(basedir .. 'sessions', 'p')
  end
end

local function set_providers()
  g.python_host_skip_check = 1
  g.python_host_prog = "/usr/local/bin/python"
  g.python3_host_skip_check = 1
  g.python3_host_prog = "/usr/local/bin/python3"
  g.loaded_node_provider = 0
  g.loaded_ruby_provider = 0
  g.loaded_perl_provider = 0
end

local function disable_builtin_plugins()
  g.loaded_gzip = 1
  g.loaded_tar = 1
  g.loaded_tarPlugin = 1
  g.loaded_zip = 1
  g.loaded_zipPlugin = 1
  g.loaded_getscript = 1
  g.loaded_getscriptPlugin = 1
  g.loaded_vimball = 1
  g.loaded_vimballPlugin = 1
  g.loaded_2html_plugin = 1
  g.loaded_logiPat = 1
  g.loaded_rrhelper = 1
  g.loaded_netrwPlugin = 1
  g.loaded_netrwSettings = 1
  g.loaded_netrwFileHandlers = 1
end

local function set_wildmenu()
  local wildignored = {
    "tags",
    "*/__pycache__/*",
    "build/*",
    "build.?/*",
    "*/node_modules/*",
    "*/env/*",
    "*.png",
    "*.jpg",
    "*.jpeg",
    "*/migrations/*",
    "*/.git/*",
    "*.DS_store"
  }

  local wildignore = ''
  for i = 1, #wildignored do
    wildignore = wildignore .. wildignored[i] .. ','
  end

  o.wildignore = wildignore

  -- Files with these suffixes get a lower priority when matching a wildcard
  local suffixesed = {
    ".aux",
    ".log",
    ".dvi",
    ".bbl",
    ".blg",
    ".brf",
    ".cb",
    ".ind",
    ".idx",
    ".ilg",
    ".inx",
    ".out",
    ".toc",
    ".o",
    ".obj",
    ".dll",
    ".class",
    ".pyc",
    ".ipynb",
    ".so",
    ".swp",
    ".zip",
    ".exe",
    ".jar",
    ".gz"
  }

  local suffixes = ''
  for i = 1, #suffixesed do
    suffixes = suffixes .. suffixesed[i] .. ','
  end

  o.suffixes = suffixes
  o.wildignorecase = false
end

local function set_general_options()
  g.mapleader = " "

  o.clipboard = "unnamed"
  o.cmdheight = 2
  o.completeopt = "menuone,noselect,noinsert"
  o.dictionary = "/usr/share/dict/words"
  o.expandtab = true
  o.foldlevelstart = 99
  o.formatoptions = "tcqj"
  o.hidden = true
  o.hlsearch = true
  o.ignorecase = true
  o.inccommand = "nosplit"
  o.incsearch = true
  o.joinspaces = false
  o.lazyredraw = true
  o.mouse = "a"
  o.path = vim.o.path .. "**"
  o.pumblend = 7
  o.shiftwidth = 2
  o.shortmess = vim.o.shortmess .. "c"
  o.showcmd = true
  o.signcolumn = 'yes'
  o.smartcase = true
  o.smartindent = true
  o.softtabstop = 2
  o.spelllang = "en_gb"
  o.splitbelow = true
  o.splitright = true
  o.swapfile = false
  o.synmaxcol = 500
  o.tabstop = 2
  o.thesaurus = "/Users/vasco.nunes/.vim/thesaurii.txt"
  o.ttyfast = true
  o.undodir = "/Users/vasco.nunes/.config/nvim/undo"
  o.undofile = true
  o.undolevels = 100
  o.updatetime = 100
  o.wrap = false
  wo.number = true
  wo.relativenumber = true
end

function M.init()
  create_directories()
  set_providers()
  disable_builtin_plugins()
  set_general_options()
  set_wildmenu()
end

return M
