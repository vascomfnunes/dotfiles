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
require("lsp").setup()
require("tags").setup()
require("git").setup()
require("sessions").setup()
require("project").setup()

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
