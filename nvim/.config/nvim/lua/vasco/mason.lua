local status_ok, mason = pcall(require, 'mason')

if not status_ok then
  return
end

local mason_config_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')

if not mason_config_ok then
  return
end

mason.setup {
  ui = {
    border = 'rounded',

    keymaps = {
      -- Keymap to expand a package
      toggle_package_expand = '<CR>',
      -- Keymap to install the package under the current cursor position
      install_package = 'i',
      -- Keymap to reinstall/update the package under the current cursor position
      update_package = 'u',
      -- Keymap to check for new version for the package under the current cursor position
      check_package_version = 'c',
      -- Keymap to update all installed packages
      update_all_packages = 'U',
      -- Keymap to check which installed packages are outdated
      check_outdated_packages = 'C',
      -- Keymap to uninstall a package
      uninstall_package = 'X',
      -- Keymap to cancel a package installation
      cancel_installation = '<C-c>',
      -- Keymap to apply language filter
      apply_language_filter = '<C-f>',
    },
  },
}

local servers = {
  'bashls',
  'cssls',
  'cssmodules_ls',
  'dockerls',
  'emmet_ls',
  'graphql',
  'yamlls',
  'stylelint_lsp',
  'sumneko_lua',
  'html',
  'solargraph',
  'jsonls',
  'eslint',
  'tsserver',
  'omnisharp',
  'node_debug2_adapter',
  'chrome_debug_adapter'
  -- 'tailwindcss'
}

mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

