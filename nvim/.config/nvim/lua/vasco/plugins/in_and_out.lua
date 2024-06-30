return {
  'ysmb-wtsg/in-and-out.nvim',
  event = 'InsertEnter',
  config = function()
    vim.keymap.set('i', '<C-l>', function()
      require('in-and-out').in_and_out()
    end)
  end,
}
