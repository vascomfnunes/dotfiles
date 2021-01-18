local M = {}
local remap = vim.api.nvim_set_keymap

local function vim()
  -- Disable annoying visual mode
  remap('n', 'Q', '<nop>', {silent = true})
  -- Clear highlights
  remap('n', '<leader>n', ':noh<cr>', {silent = true})
end

local function sessions()
  remap('n', '<leader>ss', ':mks $HOME/.config/nvim/sessions/', {silent = true})
  remap('n', '<leader>sl', ':source $HOME/.config/nvim/sessions/', {silent = true})
end

local function indent()
  remap('v', '<', '<gv', {silent = true})
  remap('v', '>', '>gv', {silent = true})
end

local function quickfix()
  remap('n', '<leader>q', ':copen<cr>', {silent = true})
end

local function goyo()
  remap('n', '<leader>z', ':Goyo<cr>', {silent = true})
end

local function splits()
  remap('n', 'vv', '<c-w>v', {silent = true})
  remap('n', 'ss', '<c-w>s', {silent = true})
end

local function tabs()
  remap('n', '<leader><tab><tab>', ':tabnew<cr>', {silent = true})
  remap('n', '<leader><tab>x', ':tabclose<cr>', {silent = true})
  remap('n', '<tab>', ':tabnext<cr>', {silent = true})
  remap('n', '<S-tab>', ':tabprevious<cr>', {silent = true})
end

local function vimspector()
  remap('n', '<leader>dB', '<Plug>VimspectorToggleBreakpoint', {silent = true})
  remap('n', '<leader>dR', '<Plug>VimspectorRestart', {silent = true})
  remap('n', '<leader>dS', '<Plug>VimspectorStop', {silent = true})
  remap('n', '<leader>dH', '<Plug>VimspectorStepHover', {silent = true})
  remap('n', '<leader>dI', '<Plug>VimspectorStepInto', {silent = true})
  remap('n', '<leader>dO', '<Plug>VimspectorStepOut', {silent = true})
  remap('n', '<leader>dC', '<Plug>VimspectorRunToCursor', {silent = true})
end

local function tmux()
  remap('n', '<c-h>', ':TmuxNavigateLeft<cr>', {silent = true})
  remap('n', '<c-j>', ':TmuxNavigateDown<cr>', {silent = true})
  remap('n', '<c-k>', ':TmuxNavigateUp<cr>', {silent = true})
  remap('n', '<c-l>', ':TmuxNavigateRight<cr>', {silent = true})
  remap('n', '<s-h>', ':TmuxResizeLeft<cr>', {silent = true})
  remap('n', '<s-j>', ':TmuxResizeDown<cr>', {silent = true})
  remap('n', '<s-k>', ':TmuxResizeUp<cr>', {silent = true})
  remap('n', '<s-l>', ':TmuxResizeRight<cr>', {silent = true})
end

local function tests()
  remap('n', '<leader>tn', ':TestNearest<cr>', {silent = true})
  remap('n', '<leader>tf', ':TestFile<cr>', {silent = true})
  remap('n', '<leader>ts', ':TestSuite<cr>', {silent = true})
end

local function tags()
  -- Jump to tag for css and scss classes
  remap('n', '<leader>]', ":tag /<c-r>=expand('<cword>')<cr>", {silent = true})
end

local function dasht()
  remap('n', '<leader>K', ':Dasht <C-R><C-W><cr>', {silent = true})
end

local function markdown()
  remap('n', '<leader>mp', ':MarkdownPreview<cr>', {silent = true})
end

local function easy_motion()
  remap('n', 'f', '<Plug>(easymotion-s2)', {silent = true})
end

local function vimwiki()
  remap('n', '<leader>di', ':VimwikiDiaryIndex<cr>', {silent = true})
  remap('n', '<leader>dn', ':VimwikiMakeDiaryNote<cr>', {silent = true})
  remap('n', '<leader>dy', ':VimwikiMakeYesterdayDiaryNote<cr>', {silent = true})
  remap('n', '<leader>dt', ':VimwikiMakeTomorrowDiaryNote<cr>', {silent = true})
  remap('n', '<leader>dtt', ':r !~/bin/vimwiki_diary_template %<cr>', {silent = true})
  remap('n', '<leader>dg', ':VimwikiDiaryGenerateLinks<cr>', {silent = true})
  remap('n', '<leader>wd', ':VimwikiDeleteFile<cr>', {silent = true})
  remap('n', '<leader>wr', ':VimwikiRenameFile<cr>', {silent = true})
  remap('n', '<leader>ws', ':VimwikiUISelect<cr>', {silent = true})
end

local function vcoolor()
  remap('n', '<leader>cc', ':VCoolor<cr>', {silent = true})
end

function M.init()
  vim()
  sessions()
  indent()
  quickfix()
  splits()
  tabs()
  tmux()
  tests()
  tags()
  dasht()
  markdown()
  easy_motion()
  vimwiki()
  goyo()
  vcoolor()
  vimspector()
end

return M
