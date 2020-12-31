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

-- Tmux
remap('n', '<c-h>', ':TmuxNavigateLeft<cr>', {silent = true})
remap('n', '<c-j>', ':TmuxNavigateDown<cr>', {silent = true})
remap('n', '<c-k>', ':TmuxNavigateUp<cr>', {silent = true})
remap('n', '<c-l>', ':TmuxNavigateRight<cr>', {silent = true})
remap('n', '<s-h>', ':TmuxResizeLeft<cr>', {silent = true})
remap('n', '<s-j>', ':TmuxResizeDown<cr>', {silent = true})
remap('n', '<s-k>', ':TmuxResizeUp<cr>', {silent = true})
remap('n', '<s-l>', ':TmuxResizeRight<cr>', {silent = true})

-- Dasht
remap('n', '<leader>k', ':Dasht<space>', {silent = true})

-- Markdown
remap('n', '<leader>mp', ':MarkdownPreview<cr>', {silent = true})

-- Goyo
remap('n', '<leader>z', ':Goyo<cr>', {silent = true})

-- Easymotion
remap('n', 'f', '<Plug>(easymotion-s2)', {silent = true})

-- Tests
remap('n', '<leader>tn', ':TestNearest<cr>', {silent = true})
remap('n', '<leader>tf', ':TestFile<cr>', {silent = true})
remap('n', '<leader>ts', ':TestSuite<cr>', {silent = true})
