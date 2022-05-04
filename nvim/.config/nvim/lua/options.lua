-- OPTIONS
--

vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.dictionary = '/usr/share/dict/words'
vim.opt.fileencoding = 'utf-8'
vim.opt.ruler = false
vim.opt.ignorecase = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99
vim.opt.autoread = true
vim.opt.joinspaces = false
vim.opt.cursorline = false
vim.opt.mouse = 'a'
vim.opt.path = '**'
vim.opt.wildignore = '**/node_modules/**,**/.git/**'
vim.opt.pumheight = 6
vim.opt.scrolloff = 8
vim.opt.shortmess = 'atToOc'
vim.opt.showmode = false
vim.opt.lazyredraw = true
vim.opt.grepprg = 'rg --vimgrep --follow --no-heading'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = 'en_gb'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.synmaxcol = 500
vim.opt.thesaurus = os.getenv 'HOME' .. '/.config/nvim/thesaurii.txt'
vim.opt.undodir = os.getenv 'HOME' .. '/.config/nvim/undo'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.updatetime = 250
vim.opt.termguicolors = true
vim.opt.writebackup = false
vim.opt.timeoutlen = 400
vim.opt.ttimeoutlen = 50
vim.opt.autoindent = true
vim.opt.breakindentopt = 'shift:2,min:20'
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.foldenable = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.signcolumn = 'yes'
vim.opt.softtabstop = -2
vim.opt.tabstop = 2
vim.opt.textwidth = 120
vim.opt.wrap = false
vim.opt.virtualedit = 'block'
vim.opt.clipboard = 'unnamedplus'

vim.opt.iskeyword = vim.opt.iskeyword + '-'
vim.opt.formatoptions = vim.opt.formatoptions
  + 'j' -- Auto-remove comments when combining lines ( <C-J> )
  + 'n' -- Indent past the formatlistpat, not underneath it.
  + 'q' -- Allow formatting comments w/ gq
  - 'c' -- In general, I like it when comments respect textwidth
  - 'r' -- But do continue when pressing enter.
  - 'o' -- O and o, don't continue comments
  - 't' -- Don't auto format my code. I got linters for that.
