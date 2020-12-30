local remap = vim.api.nvim_set_keymap

-- Visual shifting
remap('v', '<', '<gv', {silent = true})
remap('v', '>', '>gv', {silent = true})

-- Open quickfix
remap('n', '<leader>q', ':copen<cr>', {silent = true})

-- Sessions
remap('n', '<leader>ss', ':mks $HOME/.config/nvim/sessions/', {silent = true})
remap('n', '<leader>sl', ':source $HOME/.config/nvim/sessions/', {silent = true})

-- Window splits
remap('n', 'vv', '<c-w>v', {silent = true})
remap('n', 'ss', '<c-w>s', {silent = true})

-- Clear highlights
remap('n', '<leader>n', ':noh<cr>', {silent = true})

-- Tabs
remap('n', '<leader><tab>n', ':tabnew<cr>', {silent = true})
remap('n', '<leader><tab>q', ':tabclose<cr>', {silent = true})
remap('n', '<tab>', ':tabnext<cr>', {silent = true})
remap('n', '<S-tab>', ':tabprevious<cr>', {silent = true})

-- Jump to tag for css and scss classes
remap('n', '<leader>]', ":tag /<c-r>=expand('<cword>')<cr>", {silent = true})
