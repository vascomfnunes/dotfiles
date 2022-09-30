local M = {}

local on_attach = function(client, bufnr)
  client.server_capabilities.document_formatting = false
  client.server_capabilities.document_range_formatting = false

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require('nvim-lsp-ts-utils').setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = true,
    import_all_timeout = 5000, -- ms

    -- eslint
    eslint_enable_code_actions = false,
    eslint_enable_disable_comments = false,
    eslint_bin = 'eslint_d',
    eslint_config_fallback = nil,
    eslint_enable_diagnostics = false,
    eslint_opts = {
      condition = function(utils)
        return utils.root_has_file '.eslintrc.js'
      end,
    },

    -- formatting
    enable_formatting = false,
    formatter = 'prettier_d_slim',
    formatter_config_fallback = nil,

    -- parentheses completion
    complete_parens = false,
    signature_help_in_parens = false,

    -- update imports on file move
    update_imports_on_move = true,
    require_confirmation_on_move = true,
    watch_dir = nil,

    -- filter diagnostics
    filter_out_diagnostics_by_severity = { 'hint' },
    filter_out_diagnostics_by_code = {},
  }

  require('nvim-lsp-ts-utils').setup_client(client)
end

M.capabilities = capabilities
M.on_attach = on_attach

return M
