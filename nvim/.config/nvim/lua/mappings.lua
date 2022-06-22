-- MAPPINGS
--

local keymap = vim.keymap.set
local silent = { silent = true }

keymap('n', '<leader>v', ':cd ~/.config/nvim|e init.lua<cr>') -- neovim configuration
keymap('n', 'Q', '<nop>')
keymap('c', 'W', 'w')
keymap('n', '<leader>q', ':copen<cr>') -- open quicklist
keymap('n', '<leader>c', ':nohlsearch<cr>') -- clear search highlights
keymap('n', '<leader>n', ':NvimTreeToggle<cr>') -- explorer

-- Move text up and down
keymap('n', '<A-j>', ':m .+1<CR>')
keymap('n', '<A-k>', ':m .-2<CR>')
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv")
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv")
keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi')

-- Don't yank on delete char
keymap('n', 'x', '"_x', silent)
keymap('n', 'X', '"_X', silent)
keymap('v', 'x', '"_x', silent)
keymap('v', 'X', '"_X', silent)

-- Don't yank on visual paste
keymap('v', 'p', '"_dP', silent)

-- Splits
keymap('n', 'vv', '<c-w>v')
keymap('n', 'ss', '<c-w>s')
keymap('n', '<leader>z', '<C-w>|<C-w>_') -- maximize split (zoom)

-- Tabs
keymap('n', '<c-t>', ':tabnew<cr>') -- new tab
keymap('n', '<c-x>', ':tabclose<cr>') -- close tab
keymap('n', '<tab>', ':tabnext<cr>') -- next tab

-- Indentation
keymap('v', '<', '<gv') -- indent left
keymap('v', '>', '>gv') -- indent right

-- Buffers
keymap('n', ',', ':bprevious<cr>') -- previous buffer
keymap('n', '.', ':bnext<cr>') -- next buffer

-- Finder
keymap('n', '<leader>ff', ':Telescope find_files<cr>') -- files
keymap('n', '<leader>fh', ':Telescope help_tags<cr>') -- help
keymap('n', '<leader>fg', ':Telescope live_grep<cr>') -- live grep
keymap('n', '<leader>fb', ':Telescope buffers<cr>') -- list buffers
keymap('n', '<leader>fG', ':Telescope grep_string<cr>') -- grep string under cursor
keymap('n', '<leader>fq', ':Telescope quickfix<cr>') -- quickfix
keymap('n', '<leader>fs', ':Telescope possession list<cr>') -- quickfix

-- Git
keymap('n', '<leader>gg', ':Neogit<cr>') -- git status
keymap('n', '<leader>gs', ':Gitsigns stage_hunk<cr>') -- stage hunk
keymap('n', '<leader>gu', ':Gitsigns undo_stage_hunk<cr>') -- unstage hunk
keymap('n', '<leader>gr', ':Gitsigns reset_hunk<cr>') -- reset hunk
keymap('n', '<leader>gl', ':Gitsigns setloclist<cr>') -- location list

keymap('n', '<leader>gb', function()
  require('gitsigns').blame_line() -- git blame line
end)

keymap('n', '<leader>ds', ':Dash<cr>') -- search in dash

-- Lsp
keymap('n', '<leader>lD', ':Telescope diagnostics bufnr=0<cr>') -- show lsp diagnostics

-- Markdown
keymap('n', '<leader>mp', ':MarkdownPreview<cr>') -- renders markdown document in browser
keymap('n', '<leader>m[', ':MkdnPrevHeading<cr>') -- previous markdown header
keymap('n', '<leader>m]', ':MkdnNextHeading<cr>') -- next markdown header
keymap('n', '<leader>mt', ':GenTocGFM<cr>') -- generate TOC
keymap('n', '<leader>mu', ':UpdateToc<cr>') -- update TOC

-- Debug
keymap('n', '<leader>dc', ':DapContinue<cr>')
keymap('n', '<leader>db', ':DapToggleBreakpoint<cr>')
keymap('n', '<leader>do', ':DapStepOver<cr>')
keymap('n', '<leader>di', ':DapStepInto<cr>')
keymap('n', '<leader>dO', ':DapStepOut<cr>')
keymap('n', '<leader>dr', ':DapToggleRepl<cr>')
keymap('n', '<leader>dq', ':DapTerminate<cr>')
keymap('n', '<leader>dg', ':Neogen<cr>') -- generate documentation

keymap('n', '<leader>dt', function()
  require('dapui').toggle()
end)

-- Tests
keymap('n', '<leader>tn', ':lua require("neotest").run.run()<cr>')
keymap('n', '<leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<cr>')
keymap('n', '<leader>tS', ':lua require("neotest").run.stop()<cr>')
keymap('n', '<leader>ts', ':lua require("neotest").summary.toggle()<cr>')
keymap('n', '<leader>td', ':lua require("neotest").run.run({strategy = "dap"})<cr>')
keymap('n', '<leader>to', ':lua require("neotest").output.open({ enter = true })<cr>')

-- Projectionist
keymap('n', '<leader>pa', ':A<cr>')
keymap('n', '<leader>pv', ':Eview<cr>')
keymap('n', '<leader>pc', ':Econtroller<cr>')
keymap('n', '<leader>pm', ':Emodel<cr>')
keymap('n', '<leader>ph', ':Ehelper<cr>')
keymap('n', '<leader>pt', ':Espec<cr>')
keymap('n', '<leader>pj', ':Ejavascript<cr>')
keymap('n', '<leader>ps', ':Estylesheets<cr>')

-- Refactor with spectre
keymap('n', '<Leader>pr', "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", silent)
keymap('v', '<Leader>pr', "<cmd>lua require('spectre').open_visual()<CR>")

keymap('n', '<leader>lf', function()
  vim.lsp.buf.formatting() -- lsp format
end)

keymap('n', '<leader>lr', function()
  vim.lsp.buf.references() -- lsp references
end)

keymap('n', '<leader>la', function()
  vim.lsp.buf.code_action() -- lsp code action
end)

keymap('n', '<leader>lR', function()
  vim.lsp.buf.rename() -- lsp rename
end)

keymap('n', '<leader>ll', function()
  vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' }) -- lsp line diagnostics
end)

keymap('n', '<leader>ln', function()
  vim.diagnostic.goto_next() -- lsp next diagnostic
end)

keymap('n', '<leader>lp', function()
  vim.diagnostic.goto_prev() -- lsp previous diagnostic
end)

keymap('n', 'gd', function()
  vim.lsp.buf.definition() -- lsp go to definition
end)

keymap('n', 'K', function()
  vim.lsp.buf.hover() -- lsp hover documentation
end)
