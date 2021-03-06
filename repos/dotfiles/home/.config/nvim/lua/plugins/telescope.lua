vim.cmd [[packadd popup.nvim]]
vim.cmd [[packadd plenary.nvim]]
vim.cmd [[packadd telescope.nvim]]

local telescope = require('telescope')
local actions = require('telescope.actions')

vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope git_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fm', ':Telescope marks<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fk', ':Telescope keymaps<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fs', ':Telescope spell_suggest<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fa', ':Telescope lsp_code_actions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fF', ':Telescope find_files<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fo', ':Telescope lsp_document_symbols<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fq', ':Telescope quickfix<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fr', ':Telescope registers<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ft', ':Telescope tags<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fG', ':Telescope grep_string<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gr', ':Telescope lsp_references<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ca', ':Telescope lsp_code_actions<CR>', {noremap = true, silent = true})

-- depends on `nvim-telescope/telescope-fzy-native.nvim`
vim.cmd [[packadd telescope-fzy-native.nvim]]
telescope.load_extension('fzy_native') -- superfast sorter
telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<c-l>"] = actions.goto_file_selection_edit
      }
    }
  }
}
