return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      lua = { 'luacheck' },
      markdown = { 'markdownlint' },
      sh = { 'shellcheck' },
      yaml = { 'yamllint' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
      javascriptreact = { 'stylelint', 'eslint' },
      typescript = { 'eslint' },
      typescriptreact = { 'stylelint', 'eslint' },
    }
  end,
}
