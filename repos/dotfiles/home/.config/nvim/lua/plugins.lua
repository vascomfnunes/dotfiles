-- Only required if you have packer in your `opt` pack
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  -- TODO: Maybe handle windows better?
  if vim.fn.input("Download Packer? (y for yes)") ~= "y" then return end

  local directory = string.format('%s/site/pack/packer/opt/', vim.fn.stdpath('data'))

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(string.format('git clone %s %s', 'https://github.com/wbthomason/packer.nvim',
                                          directory .. '/packer.nvim'))

  print(out)
  print("Downloading packer.nvim...")

  return
end

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use {'neovim/nvim-lspconfig'}
  use {'nvim-lua/completion-nvim'}
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
  use {'tjdevries/express_line.nvim'}
  use {'vifm/vifm.vim'}
  use {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd [[TSUpdate]] end}
  use {'SirVer/ultisnips'}
  use {'honza/vim-snippets'}
  use {'justinmk/vim-gtfo'}
  use {'DataWraith/auto_mkdir'}
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
  use {'cohama/lexima.vim'}
  use {'rhysd/committia.vim'}
  use {'junegunn/goyo.vim', opt = true, cmd = {'Goyo'}}
  use {'editorconfig/editorconfig-vim'}
  use {'easymotion/vim-easymotion'}
  use {'AndrewRadev/splitjoin.vim'}
  use {'romainl/vim-cool'}
  use {'tpope/vim-fugitive'}
  use {'tpope/vim-rails'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-commentary'}
  use {'tpope/vim-ragtag'}
  use {'airblade/vim-gitgutter'}
  use {'vim-test/vim-test'}
  use {'vimwiki/vimwiki'}
  use {'sunaku/vim-dasht'}
  use {'mattn/webapi-vim'}
  use {'alexbel/vim-rubygems'}
  use {'AndrewRadev/tagalong.vim'}
  use {'mzlogin/vim-markdown-toc'}
  use {'vascomfnunes/vimbox'}
  use {'kkoomen/vim-doge', run = function() vim.cmd [[call doge#install()]] end}
  use {'christoomey/vim-tmux-navigator'}
  use {'RyanMillerC/better-vim-tmux-resizer'}
  use {'tmux-plugins/vim-tmux-focus-events'}
  use {'norcalli/nvim-colorizer.lua'}
end)
