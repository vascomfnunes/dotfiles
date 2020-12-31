require'utils'

nvim_create_augroups(
  {
    general = {
      -- Source the init.vim file after saving it
      {"BufWritePost", "init.vim", "source $MYVIMRC"},
      {"TextYankPost", "*", "silent! lua vim.highlight.on_yank()"},
      {"FileType", "html,css,scss,eruby", "EmmetInstall"},
      {"BufReadPost", "fugitive://*", "set bufhidden=delete"},
      {"User", "GoyoEnter", "nested call <SID>goyo_enter()"},
      {"User", "GoyoLeave", "nested call <SID>goyo_leave()"},
      {"BufWritePre", "*", ":call TrimWhitespace()"},
      {"BufWritePost", "plugins.lua", "PackerCompile"}
    }
  }
)
