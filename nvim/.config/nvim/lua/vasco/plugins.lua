local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

local packer = require('packer')

packer.init {
  display = {
    working_sym = ' ',
    error_sym = ' ',
    done_sym = ' ',
    removed_sym = ' ',
    moved_sym = ' ',
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
  autoremove = true,
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 6000 },
  max_jobs = 12,
  snapshot_path = vim.fn.stdpath 'config',
}

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'RRethy/nvim-base16'
  use 'tpope/vim-fugitive'
  use 'folke/which-key.nvim'
  use 'renerocksai/telekasten.nvim'
  use 'brenoprata10/nvim-highlight-colors'
  use { 'tpope/vim-rails', ft = 'ruby' }
  use 'kylechui/nvim-surround'
  use 'Equilibris/nx.nvim'
  use 'honza/vim-snippets'
  use {
    'rcarriga/nvim-dap-ui',
    requires = {
      { 'mfussenegger/nvim-dap' },
      { 'theHamsta/nvim-dap-virtual-text' },
    }
  }
  use {
    'nvim-neotest/neotest',
    requires = {
      'olimorris/neotest-rspec',
      'haydenmeade/neotest-jest',
    },
  }
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
  use 'nvim-pack/nvim-spectre'
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'kevinhwang91/nvim-bqf', ft = 'qf' }
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'nvim-tree/nvim-tree.lua'
  use 'christoomey/vim-tmux-navigator'
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
