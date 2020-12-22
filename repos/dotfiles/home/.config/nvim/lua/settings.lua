vim.g.mapleader = " "

vim.g.python3_host_prog = "/usr/local/bin/python3"
vim.g.python_host_prog = "/usr/local/bin/python"

vim.o.number = true
vim.o.relativenumber = true
vim.o.ttyfast = true
vim.o.showcmd = true
vim.o.clipboard = "unnamed"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.inccommand = "nosplit"
vim.o.softtabstop = 2
vim.o.swapfile = false
vim.o.hidden = true
vim.o.joinspaces = false
vim.o.path = vim.o.path .. "**"
vim.o.updatetime = 100
vim.o.signcolumn = 'yes'
vim.o.wildignorecase = false
vim.o.wildignore = vim.o.wildignore ..
                       ".git,.hg,.svn,*.pyc,*.spl,*.o,*.out,*~,%*"
vim.o.wildignore = vim.o.wildignore ..
                       "*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store"
vim.o.wildignore = vim.o.wildignore ..
                       "**/node_modules/**,**/bower_modules/**,*/.sass-cache/*"
vim.o.wildignore = vim.o.wildignore ..
                       "__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**"
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.expandtab = true
vim.o.spell = false
vim.o.spelllang = "en_gb"
vim.o.smartindent = true
vim.o.formatoptions = "tcqj"
vim.o.mouse = "a"
vim.o.wrap = false
vim.o.undodir = "/Users/vasco.nunes/.config/nvim/undo"
vim.o.undofile = true
vim.o.undolevels = 100
vim.o.ignorecase = true
vim.o.synmaxcol = 500
vim.o.lazyredraw = true
vim.o.smartcase = true
vim.o.foldlevelstart = 99
vim.o.cmdheight = 2
vim.o.completeopt = "menu,menuone,noselect,noinsert,preview"
vim.o.pumblend = 7
vim.o.dictionary = "/usr/share/dict/words"
vim.o.thesaurus = "/Users/vasco.nunes/.vim/thesaurii.txt"

-- Visual shifting
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})
