local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'RRethy/nvim-base16'
  use 'tpope/vim-fugitive'
  use 'kylechui/nvim-surround'
  use 'honza/vim-snippets'
  use { 'stevearc/dressing.nvim', requires = { 'MunifTanjim/nui.nvim' } }
  use 'numToStr/Comment.nvim'
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'nvim-treesitter/nvim-treesitter'
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = { 'nvim-treesitter' } }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'davidgranstrom/nvim-markdown-preview',
    cmd = 'MarkdownPreview',
  } -- requires 'npm install -g live-server' and 'brew install pandoc'
  use { 'nvim-pack/nvim-spectre', event = 'VimEnter' }
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'kevinhwang91/nvim-bqf', ft = 'qf' }
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'nvim-tree/nvim-tree.lua'
  use {
    'christoomey/vim-tmux-navigator',
    config = function()
      -- vim.g.tmux_navigator_no_mappings = 1
    end,
  }
  use 'RyanMillerC/better-vim-tmux-resizer'

  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end
