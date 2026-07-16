local loaded = {}
local pack_root = vim.fn.stdpath("data") .. "/site/pack/core/opt"

-- Load a package once from Neovim's native package path.
local function packadd(name, bang)
  if loaded[name] then return end
  local command = bang and "packadd! " or "packadd "
  vim.cmd(command .. vim.fn.fnameescape(name))
  loaded[name] = true
end

-- vim.pack specs usually derive the package directory from the repo name,
-- unless a plugin needs an explicit name override.
local function package_name(spec)
  if spec.name then return spec.name end
  return (spec.src:match("([^/]+)$"):gsub("%.git$", ""))
end

local function is_installed(name)
  return vim.uv.fs_stat(pack_root .. "/" .. name) ~= nil
end

-- Lazy plugins

-- Installed on demand and loaded by the helpers in plugins.lua.
local lazy_plugins = {
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/olimorris/neotest-rspec" },
  { src = "https://github.com/zidhuss/neotest-minitest" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/esmuellert/codediff.nvim" },
  { src = "https://github.com/akinsho/git-conflict.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/carlos-algms/agentic.nvim" },
}

-- Pack maintenance hooks

-- Keep native package updates useful for plugins with generated assets.
local function on_pack_changed(ev)
  local spec = ev.data and ev.data.spec or nil
  local kind = ev.data and ev.data.kind or nil
  if not spec or (kind ~= "install" and kind ~= "update") then return end

  if spec.name == "nvim-treesitter" then
    vim.schedule(function()
      pcall(vim.cmd, "silent! TSUpdate")
    end)
  elseif spec.name == "mason.nvim" then
    vim.schedule(function()
      if vim.fn.exists(":MasonUpdate") == 2 then pcall(vim.cmd, "silent! MasonUpdate") end
    end)
  end
end

local pack_group = vim.api.nvim_create_augroup("DotfilesPackages", { clear = true })
vim.api.nvim_create_autocmd("PackChanged", { group = pack_group, callback = on_pack_changed })

-- Eager plugins

-- Core UI/editing/LSP plugins needed during startup.
local eager_plugins = {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/nvim-mini/mini.pairs" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/jlcrochet/vim-rbs" },
  { src = "https://github.com/folke/which-key.nvim" },
}

-- Existing eager packages use packadd! during init: their Lua modules are
-- available immediately and Neovim sources plugin/ files once during its
-- normal startup sweep.
local missing = {}
for _, spec in ipairs(eager_plugins) do
  local name = package_name(spec)
  if is_installed(name) then
    packadd(name, true)
  else
    table.insert(missing, spec)
  end
end

if #missing > 0 then
  vim.pack.add(missing, { confirm = false, load = false })
  for _, spec in ipairs(missing) do
    loaded[package_name(spec)] = true
  end
end

-- Install optional packages on first run without adding them to runtimepath.
local missing_lazy = {}
for _, spec in ipairs(lazy_plugins) do
  if not is_installed(package_name(spec)) then table.insert(missing_lazy, spec) end
end

if #missing_lazy > 0 then
  vim.pack.add(missing_lazy, {
    confirm = false,
    load = function() end,
  })
end

-- Public API

return {
  load = packadd,
  load_many = function(names)
    for _, name in ipairs(names) do
      packadd(name)
    end
  end,
  install_all = function()
    vim.pack.add(eager_plugins, { confirm = false, load = true })
    vim.pack.add(lazy_plugins, { confirm = false, load = false })
  end,
}
