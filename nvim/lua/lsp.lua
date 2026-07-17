-- Native LSP configuration: servers, diagnostics, and the attach-time
-- behaviors (completion, signature help, document highlight).
local M = {}

local function enable_completion(ev, client)
  if not client:supports_method("textDocument/completion") then return end

  -- Neovim 0.12 handles LSP completion items and snippets natively. Extend
  -- the server trigger list so completion remains automatic while typing
  -- words, as it was with nvim-cmp.
  local provider = client.server_capabilities.completionProvider
  if provider then
    local characters = provider.triggerCharacters or {}
    local present = {}
    for _, character in ipairs(characters) do present[character] = true end
    for character in ("-_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):gmatch(".") do
      if not present[character] then characters[#characters + 1] = character end
    end
    provider.triggerCharacters = characters
  end
  vim.lsp.completion.enable(true, client.id, ev.buf, {
    autotrigger = true,
    convert = require("completion").convert,
  })
end

-- Core has no automatic signature help yet, so open the floating window
-- whenever a server-declared trigger character is typed in insert mode.
local function enable_signature_help(ev, client)
  local provider = client.server_capabilities.signatureHelpProvider
  if not provider then return end

  local triggers = {}
  for _, character in ipairs(provider.triggerCharacters or {}) do triggers[character] = true end
  for _, character in ipairs(provider.retriggerCharacters or {}) do triggers[character] = true end
  if vim.tbl_isempty(triggers) then return end

  local group = vim.api.nvim_create_augroup("DotfilesSignatureHelp" .. ev.buf, { clear = true })
  vim.api.nvim_create_autocmd("InsertCharPre", {
    group = group,
    buffer = ev.buf,
    callback = function()
      if triggers[vim.v.char] then
        -- InsertCharPre fires before the character lands in the buffer;
        -- defer so the server sees the trigger character in the request.
        vim.schedule(function()
          vim.lsp.buf.signature_help({ silent = true, focusable = false, max_height = 12 })
        end)
      end
    end,
  })
end

-- Highlight other occurrences of the symbol under the cursor while idle
-- (LspReferenceText/Read/Write groups; 'updatetime' controls the delay).
local function enable_document_highlight(ev, client)
  if not client:supports_method("textDocument/documentHighlight") then return end

  local group = vim.api.nvim_create_augroup("DotfilesDocumentHighlight" .. ev.buf, { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = group,
    buffer = ev.buf,
    callback = function() vim.lsp.buf.document_highlight() end,
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    buffer = ev.buf,
    callback = function() vim.lsp.buf.clear_references() end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    buffer = ev.buf,
    callback = function(detach_ev)
      -- Keep the autocmds while any remaining client still provides
      -- document highlights.
      for _, remaining in ipairs(vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/documentHighlight" })) do
        if remaining.id ~= detach_ev.data.client_id then return end
      end
      vim.lsp.buf.clear_references()
      vim.api.nvim_del_augroup_by_id(group)
    end,
  })
end

-- ruby-lsp currently behaves better with full semantic token delta disabled.
local function ruby_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local full = vim.tbl_get(capabilities, "textDocument", "semanticTokens", "requests", "full")
  if type(full) == "table" then
    full.delta = false
  end
  return capabilities
end

local servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    settings = {
      Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  ruby_lsp = {
    cmd = function(dispatchers, config)
      return vim.lsp.rpc.start(
        { "mise", "x", "--", "ruby-lsp" },
        dispatchers,
        config and config.root_dir and { cwd = config.root_dir }
      )
    end,
    filetypes = { "ruby", "eruby" },
    root_markers = { "Gemfile", ".git" },
    init_options = { formatter = "auto" },
    capabilities = ruby_capabilities(),
    -- One ruby-lsp per project root; ruby-lsp does not support multi-root.
    reuse_client = function(client, config)
      return client.name == config.name and client.config.root_dir == config.root_dir
    end,
  },
  eslint = {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    root_markers = {
      ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml",
      ".eslintrc.yml", ".eslintrc.json", "package.json",
      "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
      "eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
    },
    settings = {
      validate = "on",
      experimental = {},
      nodePath = "",
      workingDirectory = { mode = "auto" },
      format = true,
    },
  },
  tsgo = {
    cmd = { "tsgo", "--lsp", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = {
      "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git",
    },
    settings = {
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less", "sass" },
    root_markers = { "package.json", ".git" },
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      sass = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  },
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_markers = { "package.json", ".git" },
  },
  stimulus_ls = {
    cmd = { "stimulus-language-server", "--stdio" },
    filetypes = { "html", "ruby", "eruby", "blade", "php", "javascript", "typescript" },
    root_markers = { "Gemfile", ".git" },
  },
}

function M.setup()
  local group = vim.api.nvim_create_augroup("DotfilesLsp", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(ev)
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      enable_completion(ev, client)
      enable_signature_help(ev, client)
      enable_document_highlight(ev, client)
    end,
  })

  local S = vim.diagnostic.severity
  vim.diagnostic.config({
    signs = {
      text = {
        [S.ERROR] = "",
        [S.WARN] = "",
        [S.HINT] = "󰋽",
        [S.INFO] = "",
      },
    },
    virtual_text = { prefix = "●" },
    severity_sort = true,
  })

  for name, config in pairs(servers) do
    vim.lsp.config[name] = config
    vim.lsp.enable(name)
  end

  -- Show a compact LSP status without pulling in a separate UI plugin.
  vim.api.nvim_create_user_command("LspInfo", function()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
      vim.notify("No active LSP clients", vim.log.levels.INFO)
      return
    end
    local msg = { "Active Clients:" }
    for _, client in ipairs(clients) do
      table.insert(msg, string.format("- %s (id: %d, root: %s)", client.name, client.id, client.root_dir or "N/A"))
    end
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, { title = "LSP Status" })
  end, { force = true })
end

return M
