return {
  'williamboman/mason.nvim',
  cmd = { 'Mason', 'MasonInstall' },
  keys = { { '<leader>vm', '<cmd>Mason<cr>', desc = 'Mason' } },
  build = ':MasonUpdate',
  opts = {
    ensure_installed = {
      'stylua',
      'shfmt',
      'prettierd',
      'shellcheck',
      'markdownlint',
      'stylelint',
      'yamllint',
      'htmlbeautifier',
    },
  },
  config = function(_, opts)
    local config = require 'vasco.config'
    local icons = require 'vasco.utils.icons'

    require('mason').setup(opts)

    local mr = require 'mason-registry'
    local function ensure_installed()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end
    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end

    require('mason.settings').set {
      ui = {
        border = config.border.style,
        icons = {
          package_installed = icons.check,
          package_pending = icons.cog,
          package_uninstalled = icons.error,
        },
      },
    }
  end,
}
