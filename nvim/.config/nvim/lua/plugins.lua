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
  use { 'wbthomason/packer.nvim', commit = '6afb67460283f0e990d35d229fd38fdc04063e0a' }

  use { 'lewis6991/impatient.nvim', commit = 'b842e16ecc1a700f62adb9802f8355b99b52a5a6' }

  use {
    'sainnhe/gruvbox-material',
    config = "require('vasco.theme')",
  }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = 'd4eb971db353ccf78cefb3be1b05483b69ec1e69' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '0289160c963fac1d0330966a798acacf85a43a88',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      {
        'jose-elias-alvarez/typescript.nvim',
        commit = '3be39e4a6f329e3c9c2ed49783b89aebd5c69d0a',
        config = [[ require("typescript").setup({})]],
      },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '4d3a68c41a53add8804f471fcc49bb398fe8de08' },
      { 'RRethy/nvim-treesitter-endwise', commit = '0cf4601c330cf724769a2394df555a57d5fd3f34' },
      {
        'p00f/nvim-ts-rainbow',
        commit = 'fad8badcd9baa4deb2cf2a5376ab412a1ba41797',
      },
    },
  }

  use {
    'folke/todo-comments.nvim',
    commit = '02eb3019786d9083b93ab9457761899680c6f3ec',
    requires = { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
    config = "require('vasco.todo')",
  }

  use {
    'kosayoda/nvim-lightbulb',
    commit = '56b9ce31ec9d09d560fe8787c0920f76bc208297',
    config = "require('vasco.lightbulb')",
  }

  use {
    'danymat/neogen',
    commit = '967b280d7d7ade52d97d06e868ec4d9a0bc59282',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter', commit = '0289160c963fac1d0330966a798acacf85a43a88' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    commit = 'f98c85e7c3d65a51f45863a34feb4849c82f240f',
    requires = { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use {
    'sitiom/nvim-numbertoggle',
    commit = 'e361d84f6c0d18a936bceaf8bdd0d91f7514eda7',
    config = function()
      require('numbertoggle').setup()
    end,
  }

  use {
    'kevinhwang91/nvim-ufo',
    commit = 'e40b2575ce1574985d1807b51d1a855f5d395cc9',
    requires = 'kevinhwang91/promise-async',
    config = "require('vasco.ufo')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep. 'brew install fd' is optional.
    commit = 'd4204618dddf1628e7a19ad4a7b910864d1120a5',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
      { 'crispgm/telescope-heading.nvim', commit = '6f54230d738b1e582e3a4c983722ce795aca101c' },
    },
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = '6669f6dda2385ed358ffc90108e574ccccc71f32',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
      { 'nvim-treesitter/nvim-treesitter', commit = '0289160c963fac1d0330966a798acacf85a43a88' },
      { 'olimorris/neotest-rspec', commit = '5d4bf59f7eccc7352ce0535b2266edae0e2f5c2f' },
      { 'haydenmeade/neotest-jest', commit = 'cedda8ae1b5c1672e87767b61379b38c5be7a7db' },
    },
    config = "require('vasco.neotest')",
  }

  use {
    'David-Kunz/jester',
    commit = 'be6fdd511bce3343117977cab3ca686dd4d4c0d6',
    config = "require('vasco.jester')",
  }

  use {
    'hrsh7th/nvim-cmp',
    commit = '2427d06b6508489547cd30b6e86b1c75df363411',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' },
      { 'hrsh7th/cmp-nvim-lua', commit = 'd276254e7198ab7d00f117e88e223b4bd8c02d21' },
      { 'hrsh7th/cmp-buffer', commit = '62fc67a2b0205136bc3e312664624ba2ab4a9323' },
      { 'hrsh7th/cmp-path', commit = '447c87cdd6e6d6a1d2488b1d43108bfa217f56e1' },
      { 'hrsh7th/cmp-cmdline', commit = 'c66c379915d68fb52ad5ad1195cdd4265a95ef1e' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = '3dd40097196bdffe5f868d5dddcc0aa146ae41eb' },
      { 'f3fora/cmp-spell', commit = '5602f1a0de7831f8dad5b0c6db45328fbd539971' },
      { 'saadparwaiz1/cmp_luasnip', commit = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' },
      { 'rcarriga/cmp-dap', commit = 'a67883cfe574923d3414035ba16159c0ed6d8dcf' },
      { 'jbyuki/one-small-step-for-vimkind', commit = 'f0249e8d6b60c027110a861afee031b64fdcd86a' },
    },
    config = "require('vasco.completion')",
  }

  use { 'tpope/vim-ragtag', commit = '51b313e8a2e3a44f37b9d625bc0d461e9066b7e9', ft = { 'ruby', 'eruby' } }

  use {
    'L3MON4D3/LuaSnip',
    tag = 'v1.0.0',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = 'c68b3a003483cf382428a43035079f78474cd11e' }

  use {
    'williamboman/mason.nvim',
    commit = 'b39da844d26f598eca05c6decac0bd48713cd7ea',
    config = "require('vasco.mason')",
  }

  use { 'williamboman/mason-lspconfig.nvim', commit = '0051870dd728f4988110a1b2d47f4a4510213e31' }

  use {
    'windwp/nvim-autopairs',
    commit = '14cc2a4fc6243152ba085cc2059834113496c60a',
    after = { 'nvim-treesitter', 'nvim-cmp' },
    config = "require('vasco.autopairs')",
  }

  use {
    'davidgranstrom/nvim-markdown-preview',
    commit = '3d6f941beb223b23122973d077522e9e2ee33068',
    cmd = 'MarkdownPreview',
  } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use {
    'renerocksai/telekasten.nvim',
    commit = '4217ee242327ca62c56d3e90b5c39bd1bfbb20c1',
    config = "require('vasco.zettelkasten')",
  }

  use { 'mzlogin/vim-markdown-toc', commit = '7ec05df27b4922830ace2246de36ac7e53bea1db', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = '8af89c5fa2b732aaa9c3bf8aed95bccc9c4ce295',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = 'bdb7a99c4180bd6a45da1165e51fc31948412241',
    config = "require('vasco.possession')",
  }

  use {
    'windwp/nvim-ts-autotag',
    commit = 'fdefe46c6807441460f11f11a167a2baf8e4534b',
    config = "require('vasco.autotag')",
  }

  use {
    'folke/which-key.nvim',
    commit = '6885b669523ff4238de99a7c653d47b081b5506d',
    config = "require('vasco.whichkey')",
    keys = { '<leader>' },
  }

  use {
    'norcalli/nvim-colorizer.lua',
    commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6',
    config = "require('vasco.colorizer')",
  }

  use { 'nvim-pack/nvim-spectre', commit = '6d877bc1f2262af1053da466e4acd909ad61bc18', event = 'VimEnter' }

  use {
    'rcarriga/nvim-dap-ui',
    commit = '8d0768a83f7b89bd8cb8811800bc121b9353f0b2',
    requires = {
      { 'mfussenegger/nvim-dap', commit = '764899df5ca39076acb08a447f7e5bd0b4fa3147' },
      { 'theHamsta/nvim-dap-virtual-text', commit = '2971ce3e89b1711cc26e27f73d3f854b559a77d4' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = '463820a83f4ba387655f370a17c87dc3100cdf0d',
    cmd = { 'Neogit' },
    config = "require('vasco.neogit')",
  }

  use {
    'sindrets/diffview.nvim',
    commit = '6baa30d0a6f63da254c2d2c0638a426166973976',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
    },
    config = "require('vasco.diffview')",
  }

  use { 'rizzatti/dash.vim', commit = '25b17d9488454a1fcdbb2cbe829a23226f95e3c2', cmd = 'Dash' }

  use {
    'kyazdani42/nvim-tree.lua',
    commit = '9914780cbabdffe3cd030867f0bc34c6e51bcb95',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '969728506c0175644a1d448f55e311ccdada7eaf' }

  use {
    -- this requires the following font to be installed:
    -- https://github.com/yamatsum/nonicons/blob/master/dist/nonicons.ttf
    'yamatsum/nvim-nonicons',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use {
    'stevearc/dressing.nvim',
    commit = '76477792b34f8fed167b5aa61a325e4dab26c3d7',
    requires = { 'MunifTanjim/nui.nvim', commit = '70f2dadb73b5aa15727ec8f7a620818997505be5' },
  }

  use {
    'nvim-lualine/lualine.nvim',
    commit = 'a52f078026b27694d2290e34efa61a6e4a690621',
    config = "require('vasco.lualine')",
  }

  use {
    'j-hui/fidget.nvim',
    commit = '492492e7d50452a9ace8346d31f6d6da40439f0e',
    config = "require('vasco.fidget')",
  }

  use {
    'terrortylor/nvim-comment',
    commit = 'e9ac16ab056695cad6461173693069ec070d2b23',
    config = [[require('nvim_comment').setup()]],
  }

  use {
    'kylechui/nvim-surround',
    commit = 'a0b35fd410e16f00543e81dbb6c52c723f49717e',
    config = [[require('nvim-surround').setup()]],
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    commit = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6',
    config = "require('vasco.indent')",
  }

  use {
    'Equilibris/nx.nvim',
    commit = 'a44a70661501e50f1effa2dd80517898f33f4ea7',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = "require('vasco.nx')",
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
