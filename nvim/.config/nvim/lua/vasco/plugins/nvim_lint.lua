return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      markdown = { 'markdownlint' },
      sh = { 'shellcheck' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
      yaml = { 'yamllint' },
    }
  end,
}
