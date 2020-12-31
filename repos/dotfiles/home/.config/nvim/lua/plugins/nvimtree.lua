local api = vim.api
local g = vim.g
local tree = {}

function tree.setup()
  g.nvim_tree_width = 40
  g.nvim_tree_ignore = {'.git', 'node_modules', '.DS_Store'}
  g.nvim_tree_auto_open = 0
  g.nvim_tree_auto_close = 1
  g.nvim_tree_quit_on_open = 1
  g.nvim_tree_follow = 1
  g.nvim_tree_git_hl = 1
  g.nvim_tree_tab_open = 1
  g.nvim_tree_width_allow_resize = 1
  g.nvim_tree_show_icons = {git = 1, folders = 0, files = 0}
  g.nvim_tree_icons = {
    default = '',
    git = {unstaged = "✗", staged = "✓", unmerged = "", renamed = "➜", untracked = "★"},
    folder = {default = "", open = ""}
  }
  g.nvim_tree_bindings = {
    edit = {'<cr>', 'l', 'o'},
    edit_vsplit = '<c-v>',
    edit_split = '<c-s>',
    edit_tab = '<c-t>',
    close_node = {'<s-cr>', 'h'},
    refresh = 'R',
    create = 'a',
    remove = 'd',
    rename = 'r',
    cut = 'x',
    copy = 'y',
    paste = 'p'
  }

  api.nvim_set_keymap('n', 'e', ':NvimTreeToggle<CR>', {noremap = true})

  api.nvim_exec([[
  augroup LuaTreeOverride
    au!
    au FileType NvimTree setlocal nowrap
  augroup END
  ]], '')
end

return tree
