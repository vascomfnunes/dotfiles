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
  code_action_icon = ' ',
  code_action_lightbulb = {
    enable = true,
    enable_in_insert = true,
    cache_code_action = true,
    sign = true,
    update_time = 150,
    sign_priority = 20,
    virtual_text = false,
  },
  diagnostic_header = { ' ', ' ', ' ', ' ' },
}
