-- Lazy plugin loaders: each function installs the plugin's runtime files and
-- runs its setup exactly once, on first use. Callers require this module and
-- invoke the loader before touching the plugin.
local packs = require("packs")

local did_setup = {}

local function setup_once(name, callback)
  if did_setup[name] then return end
  callback()
  did_setup[name] = true
end

local lazy = {}

local function plugin_loader(pack, module, options)
  return function()
    setup_once(pack, function()
      packs.load(pack)
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

return lazy
