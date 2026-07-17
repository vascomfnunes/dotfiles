local packs = require("packs")

-- Tool paths

-- Mason tools should win over system binaries. Ruby tooling is managed by
-- Mise and launched through it so each project's Ruby context is available.
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- Treesitter

local treesitter_languages = {
  "lua", "vim", "vimdoc", "bash", "json",
  "html", "css", "javascript", "typescript",
  "ruby", "rbs", "yaml", "markdown", "markdown_inline",
}

local treesitter = require("nvim-treesitter")
local treesitter_install_dir = vim.fn.stdpath("data") .. "/site"
vim.fn.mkdir(treesitter_install_dir .. "/parser", "p")
vim.fn.mkdir(treesitter_install_dir .. "/queries", "p")
treesitter.setup({
  install_dir = treesitter_install_dir,
})

vim.api.nvim_create_user_command("TreesitterInstallAll", function()
  treesitter.install(treesitter_languages)
end, { desc = "Install configured Treesitter parsers", force = true })

local treesitter_group = vim.api.nvim_create_augroup("DotfilesTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_group,
  pattern = treesitter_languages,
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
    if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 then
      treesitter.install({ lang }):await(vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          pcall(vim.treesitter.start, ev.buf)
        end
      end))
    else
      pcall(vim.treesitter.start, ev.buf)
    end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Mason and external tools

local mason_tools = {
  "lua-language-server",
  "tsgo", "eslint-lsp",
  "css-lsp", "html-lsp", "stimulus-language-server",
  "prettier",
}

local mise_tools = {
  "gem:ruby-lsp", "gem:ripper-tags",
  "gem:htmlbeautifier", "gem:erb-formatter",
}

local function sync_editor_tools()
  packs.load("mason.nvim")
  require("mason").setup()
  vim.cmd("MasonInstall " .. table.concat(mason_tools, " "))
  local command = { "mise", "install" }
  vim.list_extend(command, mise_tools)
  vim.system(command, { text = true }, vim.schedule_wrap(function(result)
    if result.code == 0 then
      vim.notify("Mise editor tools are installed", vim.log.levels.INFO)
    else
      local message = vim.trim(result.stderr or "")
      vim.notify(message ~= "" and message or "Mise tool installation failed", vim.log.levels.ERROR)
    end
  end))
end

vim.api.nvim_create_user_command("ToolsSync", sync_editor_tools, {
  desc = "Install configured editor tools",
  force = true,
})

-- Native LSP config

-- Neovim 0.12 handles LSP completion items and snippets natively. Extend the
-- server trigger list so completion remains automatic while typing words, as
-- it was with nvim-cmp.
local lsp_group = vim.api.nvim_create_augroup("DotfilesLspCompletion", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if not client:supports_method("textDocument/completion") then return end

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
  end,
})

-- Core has no automatic signature help yet, so open the floating window
-- whenever a server-declared trigger character is typed in insert mode.
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local provider = client.server_capabilities.signatureHelpProvider
    if not provider then return end

    local triggers = {}
    for _, character in ipairs(provider.triggerCharacters or {}) do triggers[character] = true end
    for _, character in ipairs(provider.retriggerCharacters or {}) do triggers[character] = true end
    if vim.tbl_isempty(triggers) then return end

    local signature_group = vim.api.nvim_create_augroup("DotfilesSignatureHelp" .. ev.buf, { clear = true })
    vim.api.nvim_create_autocmd("InsertCharPre", {
      group = signature_group,
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
  end,
})

-- Highlight other occurrences of the symbol under the cursor while idle
-- (LspReferenceText/Read/Write groups; 'updatetime' controls the delay).
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if not client:supports_method("textDocument/documentHighlight") then return end

    local highlight_group = vim.api.nvim_create_augroup("DotfilesDocumentHighlight" .. ev.buf, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = highlight_group,
      buffer = ev.buf,
      callback = function() vim.lsp.buf.document_highlight() end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = highlight_group,
      buffer = ev.buf,
      callback = function() vim.lsp.buf.clear_references() end,
    })
    vim.api.nvim_create_autocmd("LspDetach", {
      group = highlight_group,
      buffer = ev.buf,
      callback = function(detach_ev)
        -- Keep the autocmds while any remaining client still provides
        -- document highlights.
        for _, remaining in ipairs(vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/documentHighlight" })) do
          if remaining.id ~= detach_ev.data.client_id then return end
        end
        vim.lsp.buf.clear_references()
        vim.api.nvim_del_augroup_by_id(highlight_group)
      end,
    })
  end,
})

-- ruby-lsp currently behaves better with full semantic token delta disabled.
local ruby_caps = vim.lsp.protocol.make_client_capabilities()
local full = vim.tbl_get(ruby_caps, "textDocument", "semanticTokens", "requests", "full")
if type(full) == "table" then
  full.delta = false
end

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
    capabilities = ruby_caps,
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

-- Tag the project and every bundled gem with ripper-tags so `gd` can fall
-- back to tags for definitions ruby-lsp can't resolve. Resolve the Git tags
-- path through Git itself so linked worktrees are supported.
vim.api.nvim_create_user_command("GemTags", function()
  local root = vim.fs.root(0, "Gemfile")
  if not root then
    vim.notify("No Gemfile found", vim.log.levels.WARN)
    return
  end
  local tag_file = require("tags").path(root)
  -- ripper-tags occasionally emits an entry with an embedded newline, which
  -- makes Vim reject the whole file (E431); drop malformed lines afterwards.
  local quoted = vim.fn.shellescape(tag_file)
  local sanitize = string.format(
    [[LC_ALL=C awk -F'\t' 'NF>=3' %s > %s.tmp && mv %s.tmp %s]],
    quoted, quoted, quoted, quoted
  )
  local function done(msg, level)
    vim.schedule(function()
      vim.g.gemtags_running = nil
      vim.notify(msg, level)
      vim.cmd.redrawstatus()
    end)
  end
  vim.g.gemtags_running = true
  vim.cmd.redrawstatus()
  vim.system({ "mise", "x", "--", "bundle", "list", "--paths" }, { cwd = root, text = true }, function(list)
    if list.code ~= 0 then
      done("bundle list failed:\n" .. (list.stderr or ""), vim.log.levels.ERROR)
      return
    end
    local cmd = {
      "mise", "x", "--", "ripper-tags", "-R", "--tag-file", tag_file,
      "--exclude=vendor", "--exclude=node_modules", root,
    }
    vim.list_extend(cmd, vim.split(vim.trim(list.stdout), "\n"))
    vim.system(cmd, { cwd = root, text = true }, function(res)
      if res.code ~= 0 then
        done("ripper-tags failed (gem install ripper-tags?):\n" .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      vim.system({ "sh", "-c", sanitize }, {}, function(s)
        if s.code == 0 then
          done("Tags written to " .. tag_file)
        else
          done("tags sanitize failed:\n" .. (s.stderr or ""), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end, { desc = "Generate tags for project and bundled gems", force = true })

-- Always-on plugin setup

require("css_classes").setup()

local conform_util = require("conform.util")
require("conform").setup({
  formatters_by_ft = {
    ruby = function(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      if vim.fs.root(path, { ".standard.yml" }) then return { "standardrb_mise" } end
      if vim.fs.root(path, { ".rubocop.yml" }) then return { "rubocop_mise" } end
      return {}
    end,
    html = { "htmlbeautifier_mise" },
    eruby = { "erb_format_mise" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    sass = { "prettier" },
  },
  formatters = {
    erb_format_mise = {
      command = "mise",
      args = { "x", "--", "erb-format", "--stdin" },
    },
    htmlbeautifier_mise = {
      command = "mise",
      args = { "x", "--", "htmlbeautifier" },
    },
    standardrb_mise = {
      command = "mise",
      args = { "x", "--", "standardrb", "--fix", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
      cwd = conform_util.root_file({ "Gemfile", ".git" }),
      require_cwd = true,
      exit_codes = { 0, 1 },
    },
    rubocop_mise = {
      command = "mise",
      args = { "x", "--", "rubocop", "--server", "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
      cwd = conform_util.root_file({ "Gemfile", ".git" }),
      require_cwd = true,
      exit_codes = { 0, 1 },
    },
  },
})

require("statusline").setup()
require("mini.pairs").setup({})
require("mini.surround").setup({})

-- Lazy plugin setup

local did_setup = {}

local function setup_once(name, callback)
  if did_setup[name] then return end
  callback()
  did_setup[name] = true
end

local lazy = {}

local function plugin_loader(package, module, options)
  return function()
    setup_once(package, function()
      packs.load(package)
      require(module).setup(options or {})
    end)
  end
end

function lazy.fzf()
  setup_once("fzf-lua", function()
    packs.load("fzf-lua")
    local actions = require("fzf-lua.actions")
    require("fzf-lua").setup({
      winopts = { height = 0.85, width = 0.80 },
      keymap = {
        fzf = {
          ["ctrl-l"] = "accept",
        },
      },
      git = {
        status = {
          actions = {
            ["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
          },
        },
      },
    })
  end)
end

function lazy.mini_files()
  setup_once("mini.files", function()
    packs.load("mini.files")
    require("mini.files").setup({
      mappings = {
        go_in = "L",
        go_in_plus = "l",
      },
      options = { use_as_default_explorer = true },
    })
  end)
end

lazy.flash = plugin_loader("flash.nvim", "flash")
lazy.gitsigns = plugin_loader("gitsigns.nvim", "gitsigns", { current_line_blame = true })

function lazy.codediff()
  setup_once("codediff.nvim", function()
    packs.load("codediff.nvim")
    require("codediff").setup({
      diff = {
        -- Match the JetBrains merge editor: incoming | result | current.
        conflict_ours_position = "right",
        conflict_result_position = "center",
        conflict_result_width_ratio = { 1, 2, 1 },
        cycle_next_hunk = true,
        cycle_next_file = true,
        cycle_hunks_across_files = true,
        hide_merge_artifacts = true,
      },
      explorer = {
        initial_focus = "explorer",
        -- Preview files while navigating with j/k without leaving the list.
        auto_open_on_cursor = true,
        focus_on_select = true,
        view_mode = "tree",
        visible_groups = {
          staged = true,
          unstaged = true,
          conflicts = true,
        },
      },
    })

    -- Keep <CR> as CodeDiff's select action and add the familiar tree-style
    -- `l`: expand directories, or open a file and focus its diff/result pane.
    local group = vim.api.nvim_create_augroup("DotfilesCodeDiff", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "codediff-explorer",
      callback = function(ev)
        vim.keymap.set("n", "l", "<CR>", {
          buffer = ev.buf,
          desc = "Open entry",
          remap = true,
          silent = true,
        })
      end,
    })
  end)
end

function lazy.git_conflict()
  setup_once("git-conflict.nvim", function()
    packs.load("git-conflict.nvim")
    require("git-conflict").setup({
      -- Upstream still uses the pre-0.12 diagnostic API for this option.
      disable_diagnostics = false,
    })

    local diagnostics_enabled = {}
    local group = vim.api.nvim_create_augroup("DotfilesGitConflictDiagnostics", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "GitConflictDetected",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if diagnostics_enabled[buf] == nil then
          diagnostics_enabled[buf] = vim.diagnostic.is_enabled({ bufnr = buf })
        end
        vim.diagnostic.enable(false, { bufnr = buf })
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "GitConflictResolved",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local was_enabled = diagnostics_enabled[buf]
        diagnostics_enabled[buf] = nil
        if was_enabled ~= nil then vim.diagnostic.enable(was_enabled, { bufnr = buf }) end
      end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
      group = group,
      callback = function(ev) diagnostics_enabled[ev.buf] = nil end,
    })
  end)
end

lazy.treesitter_context = plugin_loader("nvim-treesitter-context", "treesitter-context", { max_lines = 3 })
lazy.grug_far = plugin_loader("grug-far.nvim", "grug-far", { transient = true })
lazy.render_markdown = plugin_loader("render-markdown.nvim", "render-markdown", { latex = { enabled = false } })
lazy.agentic = plugin_loader("agentic.nvim", "agentic", { provider = "codex-acp" })

function lazy.neotest()
  setup_once("neotest", function()
    packs.load_many({ "nvim-nio", "neotest", "neotest-rspec", "neotest-minitest" })
    require("neotest").setup({
      adapters = {
        require("neotest-rspec")({ rspec_cmd = function() return { "bundle", "exec", "rspec" } end }),
        require("neotest-minitest")({ test_cmd = function() return { "bundle", "exec", "rails", "test" } end }),
      },
      status = { enabled = true, signs = true, virtual_text = true },
      output = { open_on_run = true },
    })
  end)
end

-- Expose lazy setup functions to keymaps and autocmds.
vim.g.dotfiles_lazy = lazy

-- Lazy-load triggers

local lazy_group = vim.api.nvim_create_augroup("DotfilesLazyPlugins", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = lazy_group,
  pattern = treesitter_languages,
  once = true,
  callback = lazy.treesitter_context,
})

vim.api.nvim_create_autocmd("FileType", {
  group = lazy_group,
  pattern = "markdown",
  callback = lazy.render_markdown,
})

-- Open directories with mini.files since netrw is disabled (e.g. `nvim .`).
vim.api.nvim_create_autocmd("BufEnter", {
  group = lazy_group,
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == "" or vim.fn.isdirectory(name) == 0 then return end
    lazy.mini_files()
    vim.bo[ev.buf].buflisted = false
    require("mini.files").open(name)
  end,
})

vim.defer_fn(function()
  lazy.gitsigns()
  lazy.git_conflict()
end, 100)

-- Which-key groups

local wk = require("which-key")
wk.setup({ preset = "classic", delay = 200 })
wk.add({
  { "<leader>a", group = "AI", mode = { "n", "v" } },
  { "<leader>g", group = "Git", mode = { "n", "v" } },
  { "<leader>gy", group = "Copy", mode = { "n", "v" } },
  { "<leader>c", group = "Code/Diagnostics", mode = { "n", "v" } },
  { "<leader>f", group = "Find/Search", mode = { "n", "v" } },
  { "<leader>p", group = "Packages", mode = { "n", "v" } },
  { "<leader>r", group = "Ruby/Rails", mode = { "n", "v" } },
  { "<leader>q", group = "Quickfix", mode = { "n", "v" } },
  { "<leader>t", group = "Tests", mode = { "n", "v" } },
})
