return {
  "elentok/format-on-save.nvim",
  event = "VeryLazy",
  config = function()
    local formatters = require("format-on-save.formatters")

    require("format-on-save").setup({
      auto_commands = false,
      user_commands = false,
      exclude_path_patterns = {
        "/node_modules/",
      },
      formatter_by_ft = {
        css = formatters.prettierd,
        html = formatters.lsp,
        javascript = formatters.prettierd,
        json = formatters.lsp,
        lua = formatters.stylua,
        markdown = formatters.prettierd,
        rust = formatters.lsp,
        scss = formatters.prettierd,
        ruby = formatters.lsp,
        sh = formatters.shfmt,
        typescript = formatters.prettierd,
        typescriptreact = formatters.prettierd,
        yaml = formatters.lsp,
      },
    })
  end,
}
