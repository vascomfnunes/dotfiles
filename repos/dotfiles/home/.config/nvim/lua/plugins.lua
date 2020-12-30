local cmd = vim.cmd

-- Only required if you have packer in your `opt` pack
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  if vim.fn.input("Download Packer? (y for yes)") ~= "y" then return end
  local directory = string.format('%s/site/pack/packer/opt/', vim.fn.stdpath('data'))
  vim.fn.mkdir(directory, 'p')
  local out = vim.fn.system(string.format('git clone %s %s', 'https://github.com/wbthomason/packer.nvim',
                                          directory .. '/packer.nvim'))
  print(out)
  print("Downloading packer.nvim...")

  return
end
-- Automatically run :PackerCompile whenever plugins.lua is updated
cmd [[ autocmd BufWritePost plugins.lua PackerCompile ]]

return require('packer').startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use {'neovim/nvim-lspconfig'}
  use {'nvim-lua/completion-nvim'}
  use {'kyazdani42/nvim-web-devicons'}
  -- use {'kyazdani42/nvim-tree.lua'}
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}}
  use {'tjdevries/express_line.nvim'}
  use {'vifm/vifm.vim', opt = true, cmd = 'Vifm'}
  use {'RishabhRD/nvim-cheat.sh', requires = {'RishabhRD/popfix'}, opt = true, cmd = 'Cheat'}
  use {'junegunn/vim-peekaboo'}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'SirVer/ultisnips'}
  use {'honza/vim-snippets'}
  use {'justinmk/vim-gtfo'}
  use {'DataWraith/auto_mkdir'}
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
  use {'cohama/lexima.vim'}
  use {'rhysd/committia.vim'}
  use {'junegunn/goyo.vim', opt = true, cmd = 'Goyo'}
  use {'editorconfig/editorconfig-vim'}
  use {'easymotion/vim-easymotion'}
  use {'AndrewRadev/splitjoin.vim'}
  use {'romainl/vim-cool'}
  use {'tpope/vim-fugitive'}
  use {'tpope/vim-rails', opt = true, ft = 'ruby'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-commentary'}
  use {'tpope/vim-ragtag', opt = true, ft = 'eruby'}
  use {'airblade/vim-gitgutter'}
  use {'vim-test/vim-test', opt = true, cmd = {'TestFile', 'TestSuite', 'TestNearest'}}
  use {'vimwiki/vimwiki'}
  use {'mattn/emmet-vim'}
  use {'sunaku/vim-dasht', opt = true, cmd = 'Dasht'}
  use {
    'alexbel/vim-rubygems',
    opt = true,
    requires = {'mattn/webapi-vim'},
    cmd = {'RubygemsGemInfo', 'RubygemsAppendVersion'}
  }
  use {'AndrewRadev/tagalong.vim', opt = true, ft = {'html', 'eruby'}}
  use {'mzlogin/vim-markdown-toc'}
  use {'kkoomen/vim-doge', run = function() vim.cmd [[call doge#install()]] end}
  use {'christoomey/vim-tmux-navigator'}
  use {'RyanMillerC/better-vim-tmux-resizer'}
  use {'tmux-plugins/vim-tmux-focus-events'}
  use {'norcalli/nvim-colorizer.lua'}
  use 'vascomfnunes/vimbox'
end)
