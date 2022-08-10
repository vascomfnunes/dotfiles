local status_ok, saga = pcall(require, 'lspsaga')

if not status_ok then
  return
end

saga.init_lsp_saga {
  border_style = 'rounded',
  finder_action_keys = {
    open = '<c-l>',
    vsplit = 'v',
    split = 's',
    tabe = 't',
    quit = 'q',
  },
  code_action_keys = {
    quit = 'q',
    exec = '<c-l>',
  },
}
