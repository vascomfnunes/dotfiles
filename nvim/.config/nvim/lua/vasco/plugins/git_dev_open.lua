return {
  'moyiz/git-dev.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>go',
      function()
        local repo = vim.fn.input 'Github repository name / URI: '
        if repo ~= '' then
          require('git-dev').open(repo)
        end
      end,
      desc = 'Open remote repo',
      mode = { 'n' },
    },
    {
      '<leader>gc',
      '<cmd>GitDevCleanAll<cr>',
      desc = 'Clean all remote repos cache',
      mode = { 'n' },
    },
  },
  opts = {},
}
