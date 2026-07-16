local packs = require("packs")

-- Tool paths

-- Mason tools should win over system binaries. Ruby tooling is deliberately
-- excluded: Mise launches it inside each project's Ruby and Bundler context.
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
end, { desc = "Install configured Treesitter parsers" })

vim.api.nvim_create_autocmd("FileType", {
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
      pcall(vim.treesitter.start)
    end
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Mason and external tools

local mason_tools = {
  "lua-language-server",
  "typescript-language-server", "eslint-lsp",
  "css-lsp", "html-lsp", "htmlbeautifier",
}

vim.api.nvim_create_user_command("MasonToolsSync", function()
  packs.load_many({ "mason.nvim", "mason-tool-installer.nvim" })
  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = mason_tools,
    auto_update = false,
    run_on_start = false,
  })
  vim.cmd.MasonToolsInstall()
end, { desc = "Install configured Mason tools" })

-- Native LSP config

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ruby-lsp currently behaves better with full semantic token delta disabled.
local ruby_caps = vim.deepcopy(capabilities)
local full = ruby_caps.textDocument
  and ruby_caps.textDocument.semanticTokens
  and ruby_caps.textDocument.semanticTokens.requests
  and ruby_caps.textDocument.semanticTokens.requests.full
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
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
  ruby_lsp = {
    cmd = function(dispatchers, config)
      return vim.lsp.rpc.start(
        { "mise", "x", "--", "ruby-lsp" },
        dispatchers,
        config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
      )
    end,
    filetypes = { "ruby", "eruby" },
    root_markers = { "Gemfile", ".git" },
    init_options = { formatter = "auto" },
    capabilities = ruby_caps,
    reuse_client = function(client, config)
      config.cmd_cwd = config.root_dir
      return client.name == config.name and client.config.root_dir == config.root_dir
    end,
  },
  eslint = {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    root_markers = {
      ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml",
      ".eslintrc.yml", ".eslintrc.json", "package.json", "eslint.config.js",
    },
    settings = { workingDirectory = { mode = "location" }, format = true },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    settings = { typescript = { preferences = { includeCompletionsForModuleExports = true } } },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less", "sass" },
    root_markers = { "package.json", ".git" },
    settings = { css = { validate = true, lint = { unknownAtRules = "ignore" } } },
  },
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_markers = { "package.json", ".git" },
  },
}

for name, config in pairs(servers) do
  config.capabilities = config.capabilities or capabilities
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
end, {})

-- Tag the project and every bundled gem with ripper-tags so `gd` can fall
-- back to tags for definitions ruby-lsp can't resolve. Tags go to .git/tags
-- (see options.lua) with absolute paths, so jumps work from any cwd.
vim.api.nvim_create_user_command("GemTags", function()
  local root = vim.fs.root(0, "Gemfile")
  if not root then
    vim.notify("No Gemfile found", vim.log.levels.WARN)
    return
  end
  local tag_file = vim.uv.fs_stat(root .. "/.git") and root .. "/.git/tags" or root .. "/tags"
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
      require("lualine").refresh({ place = { "statusline" } })
    end)
  end
  vim.g.gemtags_running = true
  require("lualine").refresh({ place = { "statusline" } })
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
end, { desc = "Generate tags for project and bundled gems" })

-- Always-on plugin setup

local conform_util = require("conform.util")
require("conform").setup({
  formatters_by_ft = {
    ruby = function(bufnr)
      local path = vim.api.nvim_buf_get_name(bufnr)
      if vim.fs.root(path, { ".standard.yml" }) then return { "standardrb_mise" } end
      if vim.fs.root(path, { ".rubocop.yml" }) then return { "rubocop_mise" } end
      return {}
    end,
    html = { "htmlbeautifier" },
  },
  formatters = {
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

-- Surface LSP work ($/progress, e.g. ruby-lsp indexing) in the statusline.
-- Tracked per progress token instead of vim.lsp.status(), which also renders
-- `end` events and therefore never clears the last message.
local lsp_progress = ""
local lsp_progress_groups = {}

local function render_lsp_progress()
  local parts = {}
  for _, group in pairs(lsp_progress_groups) do
    local msg = group.title
    -- Some servers (ruby-lsp) restate the percentage in `message`; skip it
    -- rather than showing two counters.
    if group.message and not group.message:match("^%d+%%") then
      msg = msg .. ": " .. group.message
    end
    if group.percentage then
      msg = string.format("%d%% %s", group.percentage, msg)
    end
    parts[#parts + 1] = msg
  end
  local status = vim.fn.strcharpart(table.concat(parts, " | "), 0, 60)
  -- Escape % so progress text can't be parsed as statusline items (E539).
  lsp_progress = (status:gsub("%%", "%%%%"))
  require("lualine").refresh({ place = { "statusline" } })
end

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    if type(value) ~= "table" or not value.kind then return end
    local key = ev.data.client_id .. ":" .. tostring(ev.data.params.token)
    if value.kind == "end" then
      lsp_progress_groups[key] = nil
    else
      local group = lsp_progress_groups[key] or {}
      group.title = value.title or group.title or ""
      group.message = value.message or group.message
      group.percentage = value.percentage or group.percentage
      lsp_progress_groups[key] = group
    end
    render_lsp_progress()
  end,
})

-- A crashed or stopped server never sends its `end` events.
vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(ev)
    local prefix = ev.data.client_id .. ":"
    for key in pairs(lsp_progress_groups) do
      if vim.startswith(key, prefix) then lsp_progress_groups[key] = nil end
    end
    render_lsp_progress()
  end,
})

require("lualine").setup({
  sections = {
    lualine_b = { "branch", require("git").status },
    lualine_c = { "filename" },
    lualine_x = {
      function() return lsp_progress end,
      function() return vim.g.gemtags_running and "generating tags…" or "" end,
      "filetype",
    },
  },
})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("smart-splits").setup({})

-- Lazy plugin setup

local did_setup = {}

local function setup_once(name, callback)
  if did_setup[name] then return end
  callback()
  did_setup[name] = true
end

local lazy = {}

function lazy.cmp()
  setup_once("nvim-cmp", function()
    packs.load_many({ "nvim-cmp", "LuaSnip", "cmp_luasnip", "cmp-buffer", "cmp-path", "friendly-snippets" })
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end)
end

function lazy.fzf()
  setup_once("fzf-lua", function()
    packs.load("fzf-lua")
    local actions = require("fzf-lua.actions")
    require("fzf-lua").setup({
      winopts = { height = 0.85, width = 0.80 },
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
    require("mini.files").setup({ options = { use_as_default_explorer = true } })
  end)
end

function lazy.flash()
  setup_once("flash.nvim", function()
    packs.load("flash.nvim")
    require("flash").setup({})
  end)
end

function lazy.gitsigns()
  setup_once("gitsigns.nvim", function()
    packs.load("gitsigns.nvim")
    require("gitsigns").setup({ current_line_blame = true })
  end)
end

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
    vim.api.nvim_create_autocmd("FileType", {
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
      disable_diagnostics = true,
    })
  end)
end

function lazy.treesitter_context()
  setup_once("nvim-treesitter-context", function()
    packs.load("nvim-treesitter-context")
    require("treesitter-context").setup({ max_lines = 3 })
  end)
end

function lazy.trouble()
  setup_once("trouble.nvim", function()
    packs.load("trouble.nvim")
    require("trouble").setup({})
  end)
end

function lazy.grug_far()
  setup_once("grug-far.nvim", function()
    packs.load("grug-far.nvim")
    require("grug-far").setup({ transient = true })
  end)
end

function lazy.outline()
  setup_once("outline.nvim", function()
    packs.load("outline.nvim")
    require("outline").setup({ outline_window = { width = 30 } })
  end)
end

function lazy.render_markdown()
  setup_once("render-markdown.nvim", function()
    packs.load("render-markdown.nvim")
    require("render-markdown").setup({ latex = { enabled = false } })
  end)
end

function lazy.overseer()
  setup_once("overseer.nvim", function()
    packs.load("overseer.nvim")
    require("overseer").setup({ templates = { "builtin" } })
  end)
end

function lazy.agentic()
  setup_once("agentic.nvim", function()
    packs.load("agentic.nvim")
    require("agentic").setup({
      provider = "codex-acp",
    })
  end)
end

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_languages,
  once = true,
  callback = lazy.treesitter_context,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = lazy.render_markdown,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = lazy.cmp,
})

-- Open directories with mini.files since netrw is disabled (e.g. `nvim .`).
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name == "" or vim.fn.isdirectory(name) == 0 then return end
    lazy.mini_files()
    vim.bo[ev.buf].buflisted = false
    require("mini.files").open(name)
  end,
})

-- Avoid making the first insert pay the full completion/snippet setup cost.
vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    vim.defer_fn(lazy.cmp, 1000)
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
