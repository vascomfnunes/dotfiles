-- PLUGINS
--

local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

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
  use { 'wbthomason/packer.nvim', commit = '00ec5adef58c5ff9a07f11f45903b9dbbaa1b422' }

  use { 'lewis6991/impatient.nvim', commit = '969f2c5c90457612c09cf2a13fee1adaa986d350' }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = '9278dfbb92f8e99c313ce58ddcff92bd0bce5c0c' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '158009d873525373d1d65fe2cecdbfdf18c824cd',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      { 'jose-elias-alvarez/nvim-lsp-ts-utils', commit = '441385952278a1df5c91ba0d33e72c148d4654d3' },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '88343753dbe81c227a1c1fd2c8d764afb8d36269' },
      { 'RRethy/nvim-treesitter-endwise', commit = 'd618adae7e372df0e5413e8eaa1075b443cf594d' },
      {
        'lewis6991/spellsitter.nvim',
        commit = 'c1b318f8b959e015f5cc7941624d1ca0f84705dd',
        config = function()
          require('spellsitter').setup()
        end,
      },
    },
  }

  use {
    'danymat/neogen',
    commit = 'c5a0c39753808faa41dea009d41dd686732c6774',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter', commit = '158009d873525373d1d65fe2cecdbfdf18c824cd' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    commit = '4883988cf8b623f63cc8c7d3f11b18b7e81f06ff',
    requires = 'nvim-lua/plenary.nvim',
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use {
    'tpope/vim-projectionist',
    commit = 'd4aee3035699b82b3789cee0e88dad0e38c423ab',
    config = "require('vasco.projectionist')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = 'd88b44ddf14670cffa9fdb1eaca7a0429a973653',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '968a4b9afec0c633bc369662e78f8c5db0eba249' },
      { 'nvim-telescope/telescope-fzy-native.nvim', commit = '7b3d2528102f858036627a68821ccf5fc1d78ce4' },
    },
    cmd = 'Telescope',
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = '6e235a45f957d07eacf7dfd0bb3023a78312b1ad',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '968a4b9afec0c633bc369662e78f8c5db0eba249' },
      { 'nvim-treesitter/nvim-treesitter', commit = '3cd45c302a108ef4c26b01285e178426cd7e0589' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '1bfb32e7ba1344925ad815cb0d7f901dbc0ff7c1' },
      { 'olimorris/neotest-rspec', commit = '08b30fcf52b2d090814b45a3717a2e29b2d10ef3' },
      { 'haydenmeade/neotest-jest', commit = '64e527abe7b6ef21d0af574f4db12a53e748bc54' },
    },
    config = "require('vasco.neotest')",
  }

  use {
    'hrsh7th/nvim-cmp',
    commit = '1cad1815e165c2b436f41a1ee20327701842a761',
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
    commit = 'a12441e0598e93e67235eba67c8e6fbffc896f06',
    requires = { 'rafamadriz/friendly-snippets', commit = 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = '57e5b5dfbe991151b07d272a06e365a77cc3d0e7' }

  use {
    'williamboman/nvim-lsp-installer',
    commit = '5904749c2b7fb9d70967a9dc3599107e3d07c6d1',
    config = "require('vasco.lsp-installer')",
  }

  use {
    'windwp/nvim-autopairs',
    commit = '4a95b3982be7397cd8e1370d1a09503f9b002dbf',
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
    commit = 'fc7e40d53bbb83b823230158db2f97488ae9223c',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {}
    end,
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = 'ff40739e5be6581899b43385997e39eecdbf9465',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = '3ed843794beeb6baf2557176ccc0d58ce24ba425',
    config = "require('vasco.possession')",
  }

  use { 'PlatyPew/format-installer.nvim', commit = '8d1042d4fcdfb3fc5d7d455579300d841bf3be7e' }

  use { 'aserowy/tmux.nvim', commit = '7b19060fccfbd1791ae17ec2372e0bc836f9d519', config = "require('vasco.tmux')" }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

  use { 'echasnovski/mini.nvim', commit = 'cc8fb168b95620ec1611916a6d2a74e6a5cdcbdb', config = "require('vasco.mini')" }

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
    commit = '52f4840cb95e6638f18a74b71b536c3bd12e9fd8',
    requires = {
      { 'mfussenegger/nvim-dap', commit = '2420042482ee7fd30d425e9be9ceab0a9c791ca1' },
      { 'theHamsta/nvim-dap-virtual-text', commit = '9b731b9748d243b60e61eecbe2d114c39554486e' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = '2b33d2edba011799c496a2dc7c77ebbe1b3c5b76',
    cmd = { 'Neogit' },
    config = "require('neogen').setup({ snippet_engine = 'luasnip' })",
  }

  use { 'rizzatti/dash.vim', commit = '25b17d9488454a1fcdbb2cbe829a23226f95e3c2', cmd = 'Dash' }

  use {
    'kyazdani42/nvim-tree.lua',
    commit = '79258f1d670277016523e13c0a88daa25070879f',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '8d2c5337f0a2d0a17de8e751876eeb192b32310e' }

  use { 'romainl/vim-cool', commit = '0ad6a212a910cef0aac7af244ee008ddd39a75c2', event = 'VimEnter' }

  use {
    'stevearc/dressing.nvim',
    commit = 'af179837e1cdddfb164f0296883951b2255c46d2',
    requires = { 'MunifTanjim/nui.nvim', commit = 'b26b36ae71b7a4dfde1c633a39a86d8f58d9e0ab' },
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
