-- MAPPINGS
--

vim.keymap.set('n', '<leader>v', ':cd ~/.config/nvim|e init.lua<cr>') -- neovim configuration
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('c', 'W', 'w')
vim.keymap.set('n', '<leader>q', ':copen<cr>') -- open quicklist
vim.keymap.set('n', '<leader>c', ':nohlsearch<cr>') -- clear search highlights
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<cr>') -- explorer

-- Splits
vim.keymap.set('n', 'vv', '<c-w>v')
vim.keymap.set('n', 'ss', '<c-w>s')
vim.keymap.set('n', '<leader>z', '<C-w>|<C-w>_') -- maximize split (zoom)

-- Tabs
vim.keymap.set('n', '<c-t>', ':tabnew<cr>') -- new tab
vim.keymap.set('n', '<c-x>', ':tabclose<cr>') -- close tab
vim.keymap.set('n', '<tab>', ':tabnext<cr>') -- next tab

-- Indentation
vim.keymap.set('v', '<', '<gv') -- indent left
vim.keymap.set('v', '>', '>gv') -- indent right

-- Buffers
vim.keymap.set('n', ',', ':bprevious<cr>') -- previous buffer
vim.keymap.set('n', '.', ':bnext<cr>') -- next buffer

-- Finder
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>') -- files
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>') -- help
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>') -- live grep
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>') -- list buffers
vim.keymap.set('n', '<leader>fG', ':Telescope grep_string<cr>') -- grep string under cursor
vim.keymap.set('n', '<leader>fq', ':Telescope quickfix<cr>') -- quickfix

-- Git
vim.keymap.set('n', '<leader>gg', ':Neogit<cr>') -- git status

vim.keymap.set('n', '<leader>gb', function()
  require('gitsigns').blame_line() -- git blame line
end)

-- Copilot
vim.keymap.set('n', '<leader>ce', ':Copilot enable<cr>') -- enable copilot
vim.keymap.set('n', '<leader>cd', ':Copilot disable<cr>') -- disable copilot
vim.keymap.set('n', '<leader>cs', ':Copilot status<cr>') -- copilot status

vim.keymap.set('n', '<leader>ds', ':Dash<cr>') -- search in dash

-- Lsp
vim.keymap.set('n', '<leader>fd', ':Telescope diagnostics bufnr=0<cr>') -- show lsp diagnostics
vim.keymap.set('n', '<leader>ls', ':Telescope lsp_document_symbols<cr>') -- show lsp symbols

-- Markdown
vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<cr>') -- renders markdown document in browser

-- Debug
vim.keymap.set('n', '<leader>dc', ':DapContinue<cr>')
vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<cr>')
vim.keymap.set('n', '<leader>do', ':DapStepOver<cr>')
vim.keymap.set('n', '<leader>di', ':DapStepInto<cr>')
vim.keymap.set('n', '<leader>dx', ':DapStepOut<cr>')
vim.keymap.set('n', '<leader>dr', ':DapToggleRepl<cr>')
vim.keymap.set('n', '<leader>dq', ':DapTerminate<cr>')

-- Tests
vim.keymap.set('n', '<leader>tn', ':TestNearest<cr>')
vim.keymap.set('n', '<leader>tf', ':TestFile<cr>')
vim.keymap.set('n', '<leader>ts', ':TestSuite<cr>')

-- Projectionist
vim.keymap.set('n', 'ga', ':A<cr>')
vim.keymap.set('n', 'gv', ':Eview<cr>')
vim.keymap.set('n', 'gc', ':Econtroller<cr>')
vim.keymap.set('n', 'gm', ':Emodel<cr>')
vim.keymap.set('n', 'gh', ':Ehelper<cr>')
vim.keymap.set('n', 'gt', ':Espec<cr>')
vim.keymap.set('n', 'gj', ':Ejavascript<cr>')
vim.keymap.set('n', 'gs', ':Estylesheets<cr>')

vim.keymap.set('n', '<leader>dt', function()
  require('dapui').toggle()
end)

vim.keymap.set('n', '<leader>lf', function()
  vim.lsp.buf.formatting() -- lsp format
end)

vim.keymap.set('n', '<leader>lr', function()
  vim.lsp.buf.references() -- lsp references
end)

vim.keymap.set('n', '<leader>la', function()
  vim.lsp.buf.code_action() -- lsp code action
end)

vim.keymap.set('n', '<leader>lR', function()
  vim.lsp.buf.rename() -- lsp rename
end)

vim.keymap.set('n', '<leader>ld', function()
  vim.diagnostic.open_float(0, { scope = 'line', border = 'rounded' }) -- lsp line diagnostics
end)

vim.keymap.set('n', '<leader>ln', function()
  vim.diagnostic.goto_next() -- lsp next diagnostic
end)

vim.keymap.set('n', '<leader>lp', function()
  vim.diagnostic.goto_prev() -- lsp previous diagnostic
end)

vim.keymap.set('n', 'gd', function()
  vim.lsp.buf.definition() -- lsp go to definition
end)

vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover() -- lsp hover documentation
end)
