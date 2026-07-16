-- Startup

-- Disable unused providers/plugins to suppress warnings and speed up startup.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_gzip = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1

require("options")
require("keymaps")
require("plugins")
require("git").setup()

-- Theme

require("catppuccin").setup({
  transparent_background = true,
  custom_highlights = function(colors)
    local highlights = require("completion").highlights(colors)
    -- Default separator is near-invisible with transparency
    highlights.WinSeparator = { fg = colors.overlay0 }
    return highlights
  end,
})
vim.cmd("colorscheme catppuccin")
require("completion").setup()

-- Project root detection

-- Keep the working directory local to the current window and cache each
-- buffer's resolved root so normal buffer movement stays cheap.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype ~= "" then return end
    local buf = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(buf)
    if path == "" then return end
    local cached_path = vim.b[buf].project_root_path
    local root = vim.b[buf].project_root
    if cached_path == path then
      if root then vim.cmd.lcd(vim.fn.fnameescape(root)) end
      return
    end

    root = vim.fs.root(path, { ".git", "Gemfile", "package.json" })
    vim.b[buf].project_root_path = path
    vim.b[buf].project_root = root
    if root then vim.cmd.lcd(vim.fn.fnameescape(root)) end
  end,
})
