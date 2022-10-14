-- PLUGINS
require 'vasco.impatient'

local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
  vim.notify('Installing packer... Please, close and reopen Neovim.', vim.log.levels.WARN)
  packer_bootstrap = fn.system {
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')

if not status_ok then
  return
end

-- Have packer to use a pop-up window
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
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'lewis6991/impatient.nvim'

  use {
    'sainnhe/gruvbox-material',
    config = "require('vasco.theme')",
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      -- {
      --   'jose-elias-alvarez/typescript.nvim',
      --   config = [[ require("typescript").setup({})]],
      -- },
      'JoosepAlviste/nvim-ts-context-commentstring',
      'RRethy/nvim-treesitter-endwise',
      'p00f/nvim-ts-rainbow',
    },
  }

  use {
    'folke/todo-comments.nvim',
    event = { 'BufRead', 'BufNewFile' },
    requires = { 'nvim-lua/plenary.nvim' },
    config = "require('vasco.todo')",
  }

  use {
    'kosayoda/nvim-lightbulb',
    config = "require('vasco.lightbulb')",
  }

  use {
    'danymat/neogen',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewFile' },
    requires = { 'nvim-lua/plenary.nvim' },
    config = "require('vasco.gitsigns')",
  }

  use {
    'sitiom/nvim-numbertoggle',
    config = function()
      require('numbertoggle').setup()
    end,
  }

  use {
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = "require('vasco.ufo')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep. 'brew install fd' is optional.
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'crispgm/telescope-heading.nvim' },
    },
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'olimorris/neotest-rspec',
      'haydenmeade/neotest-jest',
    },
    config = "require('vasco.neotest')",
  }

  use {
    'David-Kunz/jester',
    config = "require('vasco.jester')",
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'f3fora/cmp-spell',
      'saadparwaiz1/cmp_luasnip',
      'rcarriga/cmp-dap',
      'jbyuki/one-small-step-for-vimkind',
    },
    config = "require('vasco.completion')",
  }

  use { 'tpope/vim-ragtag', ft = { 'ruby', 'eruby' } }

  use {
    'L3MON4D3/LuaSnip',
    config = "require('vasco.luasnip')",
  }

  use { 'rafamadriz/friendly-snippets' }

  use 'onsails/lspkind-nvim'

  use {
    'junnplus/lsp-setup.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = "require('vasco.lsp')",
  }

  use {
    'windwp/nvim-autopairs',
    keys = {
      { 'i', '(' },
      { 'i', '[' },
      { 'i', '{' },
      { 'i', "'" },
      { 'i', '"' },
      { 'i', '<BS>' },
    },
    after = { 'nvim-treesitter', 'nvim-cmp' },
    config = "require('vasco.autopairs')",
  }

  use {
    'davidgranstrom/nvim-markdown-preview',
    cmd = 'MarkdownPreview',
  } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use {
    'renerocksai/telekasten.nvim',
    config = "require('vasco.zettelkasten')",
  }

  use { 'mzlogin/vim-markdown-toc', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    config = "require('vasco.possession')",
  }

  use {
    'windwp/nvim-ts-autotag',
    ft = {
      'html',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'svelte',
      'vue',
      'tsx',
      'jsx',
      'rescript',
      'xml',
      'php',
      'markdown',
      'glimmer',
      'handlebars',
      'hbs',
    },
    config = "require('vasco.autotag')",
  }

  use {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufRead', 'BufNewFile' },
    config = "require('vasco.colorizer')",
  }

  use { 'nvim-pack/nvim-spectre', event = 'VimEnter' }

  use {
    'rcarriga/nvim-dap-ui',
    event = { 'BufRead', 'BufNewFile' },
    requires = {
      { 'mfussenegger/nvim-dap' },
      { 'theHamsta/nvim-dap-virtual-text' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    cmd = { 'Neogit' },
    config = "require('vasco.neogit')",
  }

  use {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
    },
    config = "require('vasco.diffview')",
  }

  use { 'rizzatti/dash.vim', cmd = 'Dash' }

  use {
    'kyazdani42/nvim-tree.lua',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use {
    -- this requires the following font to be installed:
    -- https://github.com/yamatsum/nonicons/blob/master/dist/nonicons.ttf
    'yamatsum/nvim-nonicons',
    event = { 'BufRead', 'BufNewFile' },
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use {
    'stevearc/dressing.nvim',
    requires = { 'MunifTanjim/nui.nvim' },
  }

  use {
    'terrortylor/nvim-comment',
    config = [[require('nvim_comment').setup()]],
  }

  use {
    'kylechui/nvim-surround',
    config = [[require('nvim-surround').setup()]],
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = "require('vasco.indent')",
  }

  use {
    'Equilibris/nx.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = "require('vasco.nx')",
  }

  use { 'vifm/vifm.vim', cmd = 'Vifm' }

  use { 'nvim-lualine/lualine.nvim', config = "require('vasco.lualine')" }

  use {
    'j-hui/fidget.nvim',
    config = "require('vasco.fidget')",
  }

  use {
    'folke/which-key.nvim',
    config = "require('vasco.whichkey')",
    keys = { '<leader>' },
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
