-- NULL-LS
--

local status_ok, null_ls = pcall(require, 'null-ls')

if not status_ok then
  return
end

local sources = {}

-- bellow clients require manual installation
table.insert(sources, null_ls.builtins.diagnostics.shellcheck) -- brew install shellcheck
table.insert(sources, null_ls.builtins.code_actions.shellcheck)
table.insert(sources, null_ls.builtins.diagnostics.markdownlint) -- brew install markdownlint-cli
table.insert(sources, null_ls.builtins.formatting.markdownlint)
table.insert(sources, null_ls.builtins.formatting.erb_lint) -- gem install erb_lint
table.insert(sources, null_ls.builtins.diagnostics.erb_lint)
table.insert(sources, null_ls.builtins.diagnostics.stylelint) -- npm install -g stylelint stylelint-config-standard stylelint-config-sass-guidelines stylelint-selector-bem-pattern postcss-scss
table.insert(sources, null_ls.builtins.formatting.stylelint)
table.insert(sources, null_ls.builtins.formatting.shfmt) -- brew install shfmt
table.insert(sources, null_ls.builtins.formatting.stylua)
table.insert(sources, null_ls.builtins.formatting.prettier)

null_ls.setup { sources = sources }
