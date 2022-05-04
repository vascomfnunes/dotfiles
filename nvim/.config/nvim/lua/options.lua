-- OPTIONS
--
vim.o.completeopt = 'menuone,noselect'
vim.o.dictionary = '/usr/share/dict/words'
vim.o.fileencoding = 'utf-8'
vim.o.ruler = false
vim.o.ignorecase = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99
vim.o.autoread = true
vim.o.joinspaces = false
vim.o.cursorline = false
vim.o.mouse = 'a'
vim.o.path = '**'
vim.o.wildignore = '**/node_modules/**,**/.git/**'
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
