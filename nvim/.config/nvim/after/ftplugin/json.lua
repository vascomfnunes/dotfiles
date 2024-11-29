vim.opt_local.foldmethod = "indent"
vim.opt_local.cursorline = false
vim.opt_local.cursorcolumn = false
vim.opt_local.signcolumn = "yes"
vim.opt_local.conceallevel = 0
vim.bo.suffixesadd = ".json"

if vim.fn.executable("jq") == 1 then
   vim.bo.formatprg = "jq"
end
