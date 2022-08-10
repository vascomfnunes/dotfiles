-- PLUGINS
--

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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')

if not status_ok then
  return
end

-- Have packer to use a pop-up window
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end,
  },
  autoremove = true,
}

return packer.startup(function(use)
  use { 'wbthomason/packer.nvim', commit = 'afab89594f4f702dc3368769c95b782dbdaeaf0a' }

  use { 'lewis6991/impatient.nvim', commit = '49f4ed4a96e0dec3425f270001f341f78400fb49' }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = 'da7461b596d70fa47b50bf3a7acfaef94c47727d' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = 'e9ab0341394b41ac9fbd197b0a6ceaff3c4d9e51',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      {
        'jose-elias-alvarez/typescript.nvim',
        commit = '4f362c92c1f2f41c9bb13e72106b8719ae3ff379',
        config = [[ require("typescript").setup({})]],
      },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '4befb8936f5cbec3b726300ab29edacb891e1a7b' },
      { 'RRethy/nvim-treesitter-endwise', commit = '301ae86f057b077ee4865065023b0cae5aedb86a' },
      {
        'lewis6991/spellsitter.nvim',
        commit = 'eb74c4b1f4240cf1a7860877423195cec6311bd5',
        config = function()
          require('spellsitter').setup()
        end,
      },
      {
        'p00f/nvim-ts-rainbow',
        commit = '0c19f1eda263a1d44b6741e727fef223886c80a8',
      },
    },
  }

  use {
    'danymat/neogen',
    commit = 'c5a0c39753808faa41dea009d41dd686732c6774',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    commit = '9c3ca027661136a618c82275427746e481c84a4e',
    requires = 'nvim-lua/plenary.nvim',
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use {
    'sitiom/nvim-numbertoggle',
    commit = '1b10222a338b511a9f54ad4ace9abe1d054fdf3b',
    config = function()
      require('numbertoggle').setup()
    end,
  }

  use {
    'kevinhwang91/nvim-ufo',
    commit = '1029fa54fe7c03fd7697e8a9c808a1650923d118',
    requires = 'kevinhwang91/promise-async',
    config = "require('vasco.ufo')",
  }

  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    commit = '125795c4c725a85932fca6141d945c3c81301b07',
    config = "require('vasco.saga')",
  }

  use {
    'tpope/vim-projectionist',
    commit = 'd4aee3035699b82b3789cee0e88dad0e38c423ab',
    config = "require('vasco.projectionist')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = '8f80e821085bdb4583e78ea685e68dc34209d360',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '31807eef4ed574854b8a53ae40ea3292033a78ea' },
      { 'nvim-telescope/telescope-fzy-native.nvim', commit = '7b3d2528102f858036627a68821ccf5fc1d78ce4' },
    },
    cmd = 'Telescope',
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = 'ee97820925ee633cbe2521ccffd7dbf80fa08f83',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
      { 'olimorris/neotest-rspec', commit = '3fb12ce28599df84ffdeecfd2310b7a46a769be1' },
      { 'haydenmeade/neotest-jest', commit = '71a101d34276c2fd01bb5e908ad1199d091ad1c4' },
    },
    config = "require('vasco.neotest')",
  }

  use {
    'andythigpen/nvim-coverage',
    commit = '5b4d1749f11ac57bb41a1f5a919f6df25a9801a5',
    config = "require('vasco.coverage')",
  }

  use {
    'hrsh7th/nvim-cmp',
    commit = '706371f1300e7c0acb98b346f80dad2dd9b5f679',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' },
      { 'hrsh7th/cmp-nvim-lua', commit = 'd276254e7198ab7d00f117e88e223b4bd8c02d21' },
      { 'hrsh7th/cmp-buffer', commit = '62fc67a2b0205136bc3e312664624ba2ab4a9323' },
      { 'hrsh7th/cmp-path', commit = '466b6b8270f7ba89abd59f402c73f63c7331ff6e' },
      { 'hrsh7th/cmp-cmdline', commit = 'c36ca4bc1dedb12b4ba6546b96c43896fd6e7252' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = '007dd2740d9b70f2688db01a39d6d25b7169cd57' },
      { 'f3fora/cmp-spell', commit = '5602f1a0de7831f8dad5b0c6db45328fbd539971' },
      { 'saadparwaiz1/cmp_luasnip', commit = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' },
    },
    config = "require('vasco.completion')",
  }

  use { 'tpope/vim-ragtag', commit = '51b313e8a2e3a44f37b9d625bc0d461e9066b7e9', ft = { 'ruby', 'eruby' } }

  use {
    'L3MON4D3/LuaSnip',
    commit = 'c599c560ed26f04f5bdb7e4498b632dc16fb9209',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = '57e5b5dfbe991151b07d272a06e365a77cc3d0e7' }

  use {
    'williamboman/mason.nvim',
    commit = '3458edb7e020c8e1249b307b084f85ec0230175e',
    config = "require('vasco.mason')",
  }

  use { 'williamboman/mason-lspconfig.nvim' }

  use {
    'windwp/nvim-autopairs',
    commit = 'ca89ab9e7e42aa9279f1cdad15398d6e18ccee86',
    after = { 'nvim-treesitter', 'nvim-cmp' },
    config = "require('vasco.autopairs')",
  }

  use {
    'davidgranstrom/nvim-markdown-preview',
    commit = '3d6f941beb223b23122973d077522e9e2ee33068',
    cmd = 'MarkdownPreview',
  } -- requires 'npm install -g live-server' and 'brew install pandoc'

  use {
    'jakewvincent/mkdnflow.nvim',
    commit = 'a59b96c8b7c711ba30e0422689a3e61c0b0bd835',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {}
    end,
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = '5b745e5fa2a18a2c0df8966080f4321fad4f42d7',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = 'c138bbcd55d58d21ce12ceea8075dad29bea8c9f',
    config = "require('vasco.possession')",
  }

  use { 'aserowy/tmux.nvim', commit = '925dc91f569e8db84d0443693efe2321dc3ba7e7', config = "require('vasco.tmux')" }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

  use { 'echasnovski/mini.nvim', commit = '6d2b59cbdd84a47d080b6936267d7a16ee094b1f', config = "require('vasco.mini')" }

  use {
    'folke/which-key.nvim',
    commit = 'bd4411a2ed4dd8bb69c125e339d837028a6eea71',
    config = "require('vasco.whichkey')",
    keys = { '<leader>' },
  }

  use {
    'norcalli/nvim-colorizer.lua',
    commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6',
    config = "require('vasco.colorizer')",
  }

  use { 'nvim-pack/nvim-spectre', commit = '58010388ff3cd6e52394183ce207659d2ae87753', event = 'VimEnter' }

  use {
    'rcarriga/nvim-dap-ui',
    commit = 'd33b905770f9c674468b0b83bed3aeab41cf9bb0',
    requires = {
      { 'mfussenegger/nvim-dap', commit = 'b9328b0cbd4dcbab29b1ce68f7103fe86a7703e1' },
      { 'theHamsta/nvim-dap-virtual-text', commit = 'a36982259216afd710f55bcdc220477c74b5bc35' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = 'c9f3d44d2edfbb0bc6f8c5bb4366166e969b2e67',
    cmd = { 'Neogit' },
    config = "require('neogen').setup({ snippet_engine = 'luasnip' })",
  }

  use { 'rizzatti/dash.vim', commit = '25b17d9488454a1fcdbb2cbe829a23226f95e3c2', cmd = 'Dash' }

  use {
    'kyazdani42/nvim-tree.lua',
    commit = '261a5c380c000e23c4a23dcd55b984c856cdb113',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '2d02a56189e2bde11edd4712fea16f08a6656944' }

  use { 'romainl/vim-cool', commit = '0ad6a212a910cef0aac7af244ee008ddd39a75c2', event = 'VimEnter' }

  use {
    'stevearc/dressing.nvim',
    commit = 'd886a1bb0b43a81af58e0331fedbe8b02ac414fa',
    requires = { 'MunifTanjim/nui.nvim', commit = '70f2dadb73b5aa15727ec8f7a620818997505be5' },
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
