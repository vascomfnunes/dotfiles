-- NVIM TREE
--

local status_ok, tree = pcall(require, 'nvim-tree')

if not status_ok then
  return
end

tree.setup {
  disable_netrw = true,
  hijack_cursor=true,
  filters = {
    dotfiles = false,
  },
  update_cwd = true,
  update_focused_file = { enable = true, update_cwd = false, ignore_list = {} },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  trash = {
    require_confirm = true,
  },
  view = {
    width = 35,
    side = 'right',
    mappings = {
      -- custom only false will merge the list with the default mappings
      -- if true, it will only use your list to set the mappings
      custom_only = false,
      -- list of mappings to set on the tree manually
      list = {
        { key = { '<CR>', 'o', 'l' }, action = 'edit' },
        { key = '<C-v>', action = 'vsplit' },
        { key = '<C-s>', action = 'split' },
        { key = '<C-t>', action = 'tabnew' },
        { key = 'h', action = 'close_node' },
        { key = '<Tab>', action = 'preview' },
        { key = 'H', action = 'toggle_dotfiles' },
        { key = 'R', action = 'refresh' },
        { key = 'a', action = 'create' },
        { key = 'd', action = 'remove' },
        { key = 'r', action = 'rename' },
        { key = 'x', action = 'cut' },
        { key = 'y', action = 'copy' },
        { key = 'p', action = 'paste' },
        { key = 'Y', action = 'copy_name' },
        { key = 'C', action = 'copy_path' },
        { key = 'gy', action = 'copy_absolute_path' },
        { key = '-', action = 'dir_up' },
        { key = 'q', action = 'close' },
        { key = 'g?', action = 'toggle_help' },
      },
    },
  },
  renderer = {
    icons = {
      show = { folder = true, file = true, folder_arrow = true },
    },
  },
}
