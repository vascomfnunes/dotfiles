local packs = require("packs")
local lazy = require("lazyload")

-- Tool paths

-- Mason tools should win over system binaries. Ruby tooling is managed by
-- Mise and launched through it so each project's Ruby context is available.
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

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
  { "<leader>s", group = "Session", mode = { "n", "v" } },
  { "<leader>t", group = "Tests", mode = { "n", "v" } },
})
