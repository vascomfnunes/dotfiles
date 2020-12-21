local lsp = require 'lspconfig'
local completion = require 'completion'

local function mapper(mode, key, result)
  vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<CR>", {noremap = true, silent = true})
end

local on_attach = function(client)
  if client.config.flags then client.config.flags.allow_incremental_sync = true end

  completion.on_attach(client)
  mapper('n', 'gd', 'vim.lsp.buf.definition()')
  mapper('n', 'gs', 'vim.lsp.buf.signature_help()')
  mapper('n', 'K', 'vim.lsp.buf.hover()')
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.g.completion_enable_snippet = "UltiSnips"
end

local default_lsp_config = {on_attach = on_attach}

local servers = {
  -- diagnosticls = diagnostics.options,
  bashls = {},
  vimls = {},
  dockerls = {},
  yamlls = {},
  jsonls = {},
  tsserver = {},
  html = {},
  cssls = {},

  solargraph = {settings = {solargraph = {diagnostics = true, formatting = true}}},

  sumneko_lua = {
    cmd = {'/home/vasco.nunes/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/bin/Linux/lua-language-server'},
    settings = {
      Lua = {
        diagnostics = {
          globals = {'vim', 'use', 'imap', 'nmap', 'vmap', 'tmap', 'inoremap', 'nnoremap', 'vnoremap', 'tnoremap'}
        },
        workspace = {library = {['$VIMRUNTIME/lua'] = true}}
      }
    }
  }
}

for server, config in pairs(servers) do lsp[server].setup(vim.tbl_deep_extend("force", default_lsp_config, config)) end
