vim.g.lua_tree_width = 40
vim.g.lua_tree_ignore = {'.git', 'node_modules', '.cache'}
vim.g.lua_tree_auto_close = 1
vim.g.lua_tree_quit_on_open = 1
vim.g.lua_tree_follow = 1
vim.g.lua_tree_git_hl = 1
vim.g.lua_tree_width_allow_resize = 1

vim.g.lua_tree_bindings = {
  edit = {'<CR>', 'o', 'l'},
  edit_vsplit = 'v',
  edit_split = 's',
  edit_tab = 't',
  close_node = {'<S-CR>', '<BS>', 'h'},
  toggle_dotfiles = 'a',
  refresh = 'R',
  preview = '<Tab>',
  delete = 'd',
  cut = 'x',
  copy = 'y',
  paste = 'p'
}

vim.api.nvim_set_keymap('n', 'e', ':LuaTreeToggle<CR>', {noremap = true, silent = true})
