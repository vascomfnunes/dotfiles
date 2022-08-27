-- PLUGINS
require 'vasco.impatient'
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
  use { 'wbthomason/packer.nvim', commit = '3a9f9801f683946b9f1047d8f4bf9946c29e927d' }

  use { 'lewis6991/impatient.nvim', commit = 'b842e16ecc1a700f62adb9802f8355b99b52a5a6' }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = '891bfe844981bfb782fc83289130846da95061dd' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = 'a59e6e0ef064b7a4c96f8f26c9e407d53f017211',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      {
        'jose-elias-alvarez/typescript.nvim',
        commit = '4f362c92c1f2f41c9bb13e72106b8719ae3ff379',
        config = [[ require("typescript").setup({})]],
      },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '37a97a04c39f26fffe7745815517e1ce1a0eb3be' },
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
    commit = '1e107c91c0c5e3ae72c37df8ffdd50f87fb3ebfa',
    after = 'gruvbox-material',
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
    commit = 'ba18a3bb31c35f16b4178ca69db097d0c6ba261a',
    requires = 'kevinhwang91/promise-async',
    config = "require('vasco.ufo')",
  }

  use {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    commit = 'da3ec06ad8ef99264ef32470c9f727a210518326',
    config = "require('vasco.saga')",
  }

  use {
    'tpope/vim-projectionist',
    commit = 'd4aee3035699b82b3789cee0e88dad0e38c423ab',
    config = "require('vasco.projectionist')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = '3e944f02ff8040056b44f6a9aed48842317b33ac',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '31807eef4ed574854b8a53ae40ea3292033a78ea' },
    },
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = '8f4e4e3ba2e1d9cc152e464a2623e04b7a861bbe',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
      { 'olimorris/neotest-rspec', commit = 'f1d33d23950073faca6361aaae3f9efd23d6a42b' },
      { 'haydenmeade/neotest-jest', commit = '408245bec62813ed858de49ca07172d3f018a79f' },
    },
    config = "require('vasco.neotest')",
  }

  use {
    'microsoft/vscode-js-debug',
    run = 'npm install --legacy-peer-deps && npm run compile',
    config = "require('vasco.vscode-js-debug')",
  }

  use {
    'David-Kunz/jester',
    config = function()
      require('jester').setup {
        cmd = "yarn jest -t '$result' -- $file",
        terminal_cmd = ':vsplit | terminal',
      }
    end,
  }

  use { 'AndrewRadev/diffurcate.vim', cmd = 'Diffurcate' }

  use {
    'hrsh7th/nvim-cmp',
    commit = '058100d81316239f3874064064f0f0c5d43c2103',
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
    commit = '04f90900f2a57938921fd25169c7f282e7eefe85',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = '57e5b5dfbe991151b07d272a06e365a77cc3d0e7' }

  use {
    'williamboman/mason.nvim',
    commit = 'b4484e29d619778daa4522294b5e88c24dda267a',
    config = "require('vasco.mason')",
  }

  use { 'williamboman/mason-lspconfig.nvim', commit = 'd9365e72afb2f876a62cd3cade555dc1a95031d9' }

  use {
    'windwp/nvim-autopairs',
    commit = '0a18e10a0c3fde190437567e40557dcdbbc89ea1',
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
    commit = 'f98639be99a497ee0ccb78ec81ea6c8e7849f9db',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup {}
    end,
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = '753ad51790a966b42997ac935e26573fb6d5864a',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = 'c138bbcd55d58d21ce12ceea8075dad29bea8c9f',
    config = "require('vasco.possession')",
  }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

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
      { 'mfussenegger/nvim-dap', commit = 'ad8b0de205a077b66cb301531bdc31c8fc7551b6' },
      { 'theHamsta/nvim-dap-virtual-text', commit = 'a36982259216afd710f55bcdc220477c74b5bc35' },
      {
        'mxsdev/nvim-dap-vscode-js',
        commit = '32b0b9f735fc7e352194b6c9a8f540277ec83fe3',
        requires = { 'mfussenegger/nvim-dap' },
      },
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
    commit = 'c3ea264947671f44d836af5b7587e12c4b4611f9',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '2d02a56189e2bde11edd4712fea16f08a6656944' }

  use { 'romainl/vim-cool', commit = '0ad6a212a910cef0aac7af244ee008ddd39a75c2', event = 'VimEnter' }

  use {
    'stevearc/dressing.nvim',
    commit = '96b09a0e3c7c457140303c796bd84f13cfd9dbc0',
    requires = { 'MunifTanjim/nui.nvim', commit = '70f2dadb73b5aa15727ec8f7a620818997505be5' },
  }

  use {
    'nvim-lualine/lualine.nvim',
    commit = '3cf45404d4ab5e3b5da283877f57b676cb78d41d',
    requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
    config = "require('vasco.lualine')",
  }

  use {
    'j-hui/fidget.nvim',
    commit = '492492e7d50452a9ace8346d31f6d6da40439f0e',
    config = function()
      require('fidget').setup {
        window = {
          blend = 0,
        },
      }
    end,
  }

  use {
    'terrortylor/nvim-comment',
    commit = 'e9ac16ab056695cad6461173693069ec070d2b23',
    config = [[require('nvim_comment').setup()]],
  }

  use {
    'kylechui/nvim-surround',
    commit = '48540cf24c1744c8f089099270fa8acea2672125',
    config = [[require('nvim-surround').setup()]],
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    commit = 'c15bbe9f23d88b5c0b4ca45a446e01a0a3913707',
    config = "require('vasco.indent')",
  }

  use { 'mickael-menu/zk-nvim', config = "require('vasco.zk')" }

  use {
    'Equilibris/nx.nvim',
    commit = '8842b4ff57d917b7ccaa9d80a454d87342a13d60',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = "require('vasco.nx')",
  }

  -- use {
  --   'sainnhe/gruvbox-material',
  --   config = "require('vasco.theme')",
  -- }

  -- use 'morhetz/gruvbox'

  use 'rmehri01/onenord.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
