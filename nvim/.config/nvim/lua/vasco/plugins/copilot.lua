return {
  'github/copilot.vim',
  event = 'VeryLazy',
  config = function()
    -- Disable default tab mapping for Copilot suggestions
    vim.g.copilot_no_tab_map = true

    -- Accept Copilot suggestion with Ctrl-h
    vim.api.nvim_set_keymap('i', '<C-h>', 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })
  end,
}
