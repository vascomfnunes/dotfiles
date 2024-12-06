return {
  'williamboman/mason.nvim',
  cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll' },
  keys = {
    { '<leader>vm', '<cmd>Mason<cr>', desc = 'Mason' },
  },
  build = ':MasonUpdate',
  opts = {
    ensure_installed = {
      -- Formatters
      'stylua',
      'shfmt',
      'prettierd',
      'prettier',
      'black',
      'isort',

      -- Linters
      'shellcheck',
      'markdownlint',
      'stylelint',
      'yamllint',
      'eslint_d',

      -- Code Actions
      'htmlbeautifier',
    },
    max_concurrent_installers = 4,
    registries = {
      'github:mason-org/mason-registry',
    },
  },
  config = function(_, opts)
    local config = require 'vasco.config'
    local icons = require 'vasco.utils.icons'

    require('mason').setup(opts)

    local mr = require 'mason-registry'

    -- Enhanced error handling for installations
    local function ensure_installed()
      local installation_failed = false

      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          vim.notify('Installing ' .. tool, vim.log.levels.INFO)
          local success, err = pcall(function()
            p:install()
          end)
          if not success then
            installation_failed = true
            vim.notify('Failed to install ' .. tool .. ': ' .. tostring(err), vim.log.levels.ERROR)
          end
        end
      end

      if installation_failed then
        vim.notify('Some packages failed to install. Check logs for details.', vim.log.levels.WARN)
      end
    end

    -- Registry refresh with error handling
    if mr.refresh then
      mr.refresh(function()
        pcall(ensure_installed)
      end)
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
        keymaps = {
          toggle_package_expand = '<CR>',
          install_package = 'i',
          update_package = 'u',
          uninstall_package = 'x',
          cancel_installation = '<C-c>',
        },
      },
      pip = {
        upgrade_pip = true,
      },
      log_level = vim.log.levels.INFO,
    }
  end,
}
