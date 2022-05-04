vim.opt_local.foldmethod = "indent"
vim.opt_local.cursorline = true
vim.opt_local.cursorcolumn = false
vim.opt_local.signcolumn = "yes"
vim.bo.suffixesadd = ".json"

if vim.fn.executable("jq") == 1 then
   vim.bo.formatprg = "jq"
end
