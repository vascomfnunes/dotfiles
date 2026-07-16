local opt = vim.opt

-- Editor UI

opt.number = true
opt.relativenumber = true

opt.wrap = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.winborder = "rounded"
opt.showmode = false

-- Indentation

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Search

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Completion menu

opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
opt.pumborder = "rounded"
opt.pumheight = 12
opt.pumwidth = 30
opt.pummaxwidth = 88

-- Window layout

opt.splitright = true
opt.splitbelow = true

-- Responsiveness and terminal behavior

opt.termguicolors = true
opt.timeoutlen = 400
opt.ttimeoutlen = 10
opt.scrolloff = 8
opt.updatetime = 200

-- Clipboard

opt.clipboard = "unnamed,unnamedplus"

-- Persistent undo

local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")
opt.undofile = true
opt.undodir = undodir

opt.confirm = true
