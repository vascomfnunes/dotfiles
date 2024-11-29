local function override_dark_highlights()
  vim.cmd 'hi WhichKeyNormal guibg=#333333'
  vim.cmd 'hi LazyNormal guibg=#282828'
  vim.cmd 'hi LazyBackdrop guibg=#282828'
  vim.cmd 'hi LazyDimmed guibg=#282828'
end

local function override_light_highlights()
  vim.cmd 'hi WhichKeyNormal guibg=#f4e8be'
  vim.cmd 'hi LazyNormal guibg=#fbf1c7'
end

return {
  'f-person/auto-dark-mode.nvim',
  lazy = false,
  priority = 9999,
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option_value('background', 'dark', {})
      vim.cmd 'colorscheme onedark'
      override_dark_highlights()
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value('background', 'light', {})
      vim.cmd 'colorscheme onelight'
      override_light_highlights()
    end,
  },
}
