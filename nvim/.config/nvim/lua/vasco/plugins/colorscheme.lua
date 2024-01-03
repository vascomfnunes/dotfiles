local config = require 'vasco.config'
local none = 'NONE'

return {
  'olimorris/onedarkpro.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    colors = {}, -- Override default colors or create your own
    highlights = {
      NormalFloat = {
        bg = none,
      },
      TelescopeBorder = {
        fg = config.border.color,
        bg = none,
      },
      TelescopeNormal = {
        bg = none,
      },
      WhichKeyFloat = {
        bg = none,
      },
      NeoTreeCursorLine = {
        bg = '${bg_statusline}',
      },
      GpHandlerStandout = {
        bg = none,
      },
      FloatBorder = {
        bg = none,
        fg = config.border.color,
      },
    }, -- Override default highlight groups or create your own
    styles = { -- For example, to apply bold and italic, use "bold,italic"
      types = none, -- Style that is applied to types
      methods = none, -- Style that is applied to methods
      numbers = none, -- Style that is applied to numbers
      strings = none, -- Style that is applied to strings
      comments = 'italic', -- Style that is applied to comments
      keywords = none, -- Style that is applied to keywords
      constants = none, -- Style that is applied to constants
      functions = none, -- Style that is applied to functions
      operators = none, -- Style that is applied to operators
      variables = none, -- Style that is applied to variables
      parameters = none, -- Style that is applied to parameters
      conditionals = none, -- Style that is applied to conditionals
      virtual_text = 'bold,italic', -- Style that is applied to virtual text
    },
    filetypes = { -- Override which filetype highlight groups are loaded
      comment = true,
      go = true,
      html = true,
      java = true,
      javascript = true,
      json = true,
      lua = true,
      markdown = true,
      php = true,
      python = true,
      ruby = true,
      rust = true,
      scss = true,
      toml = true,
      typescript = true,
      typescriptreact = true,
      vue = true,
      xml = true,
      yaml = true,
    },
    plugins = { -- Override which plugin highlight groups are loaded
      aerial = true,
      barbar = true,
      copilot = false,
      dashboard = false,
      flash_nvim = true,
      gitsigns = true,
      hop = false,
      indentline = true,
      leap = true,
      lsp_saga = true,
      lsp_semantic_tokens = true,
      marks = false,
      mini_indentscope = false,
      neotest = true,
      neo_tree = true,
      nvim_cmp = true,
      nvim_bqf = true,
      nvim_dap = true,
      nvim_dap_ui = true,
      nvim_hlslens = false,
      nvim_lsp = true,
      nvim_navic = false,
      nvim_notify = true,
      nvim_tree = true,
      nvim_ts_rainbow = true,
      op_nvim = true,
      packer = false,
      polygot = false,
      rainbow_delimiters = true,
      startify = false,
      telescope = true,
      toggleterm = false,
      treesitter = true,
      trouble = true,
      vim_ultest = true,
      which_key = true,
    },

    options = {
      cursorline = false, -- Use cursorline highlighting?
      transparency = false, -- Use a transparent background?
      terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
      highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
    },
  },
}
