local status_ok, mason = pcall(require, 'mason')

if not status_ok then
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

require('mason-lspconfig').setup {
  ensure_installed = {
    'sumneko_lua',
    'solargraph',
    'bashls',
    'stylua',
    'eslint',
    'tsserver',
    'cssls',
    'cssmodules_ls',
    'dockerls',
    'emmet_ls',
    'graphql',
    'html',
    'jsonls',
    'tailwindcss',
    'yamlls',
    'stylelint_lsp',
    'prettier'
  },
  automatic_installation = true,
}
