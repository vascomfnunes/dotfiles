return {
  'moyiz/git-dev.nvim',
  lazy = true,
  event = 'VeryLazy',
  cmd = { 'GitDevCleanAll' },
  keys = {
    {
      '<leader>go',
      function()
        local repo = vim.fn.input {
          prompt = 'Github repository name / URI: ',
          completion = 'file',
        }
        if repo ~= '' then
          require('git-dev').open(repo)
        end
      end,
      desc = 'Open remote repo',
      mode = 'n',
    },
    {
      '<leader>gc',
      '<cmd>GitDevCleanAll<cr>',
      desc = 'Clean all remote repos cache',
      mode = 'n',
    },
  },
  opts = {
    clone_path = vim.fn.stdpath('data') .. '/git-dev',
    silent = false,
    preview = true,
  },
}
