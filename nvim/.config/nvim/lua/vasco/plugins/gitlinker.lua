return {
  'ruifm/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'BufReadPost',
  keys = {
    {
      '<leader>gy',
      function()
        require('gitlinker').get_buf_range_url(vim.fn.mode())
      end,
      desc = 'Copy git permalink to clipboard',
      mode = { 'n', 'v' },
    },
  },
  opts = {
    callbacks = {
      ['github.com'] = function(url_data)
        return require('gitlinker.hosts').get_github_type_url(url_data)
      end,
      ['gitlab.com'] = function(url_data)
        return require('gitlinker.hosts').get_gitlab_type_url(url_data)
      end,
      ['try.gitea.io'] = function(url_data)
        return require('gitlinker.hosts').get_gitea_type_url(url_data)
      end,
      ['codeberg.org'] = function(url_data)
        return require('gitlinker.hosts').get_gitea_type_url(url_data)
      end,
      ['bitbucket.org'] = function(url_data)
        return require('gitlinker.hosts').get_bitbucket_type_url(url_data)
      end,
    },
    add_current_line_on_normal_mode = true,
    -- Remove the require('gitlinker.actions') call
    action_callback = vim.fn.setreg, -- This will copy to clipboard
    print_url = true,
  },
}
