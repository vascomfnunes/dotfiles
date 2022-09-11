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
  use { 'wbthomason/packer.nvim', commit = '50aeb9060cf64c3c27e6d7b11d7af9e209ed6c3b' }

  use { 'lewis6991/impatient.nvim', commit = 'b842e16ecc1a700f62adb9802f8355b99b52a5a6' }

  use { 'nathom/filetype.nvim', commit = 'b522628a45a17d58fc0073ffd64f9dc9530a8027' }

  use { 'neovim/nvim-lspconfig', commit = '79d4cb9c45ecf185d2200dd2af1e12829c8a9232' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '2a63ea5665a6de96acd31a045d9d4d73272ff5a9',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      {
        'jose-elias-alvarez/typescript.nvim',
        commit = '1684f7e3a9faf949be0999468d220211f23327ff',
        config = [[ require("typescript").setup({})]],
      },
      { 'JoosepAlviste/nvim-ts-context-commentstring', commit = '4d3a68c41a53add8804f471fcc49bb398fe8de08' },
      { 'RRethy/nvim-treesitter-endwise', commit = 'dbe426b2786ee41e55afd8ebded172ce206ffa65' },
      {
        'lewis6991/spellsitter.nvim',
        commit = 'eb74c4b1f4240cf1a7860877423195cec6311bd5',
        config = "require('vasco.spellsitter')",
      },
      {
        'p00f/nvim-ts-rainbow',
        commit = 'c641e224731180371e6a4705762af0c6a882d95e',
      },
    },
  }

  use {
    'folke/todo-comments.nvim',
    commit = 'fb6f16b89e475676d45bf6b39077fb752521e6f1',
    requires = { 'nvim-lua/plenary.nvim', commit = '4b66054e75356ac0b909bbfee9c682e703f535c2' },
    config = "require('vasco.todo')",
  }

  use {
    'kosayoda/nvim-lightbulb',
    commit = '56b9ce31ec9d09d560fe8787c0920f76bc208297',
    requires = { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
    config = "require('vasco.lightbulb')",
    -- require('nvim-lightbulb').setup { autocmd = { enabled = true } }
  }

  use {
    'danymat/neogen',
    commit = 'c5a0c39753808faa41dea009d41dd686732c6774',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter', commit = '2a63ea5665a6de96acd31a045d9d4d73272ff5a9' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    commit = '1e107c91c0c5e3ae72c37df8ffdd50f87fb3ebfa',
    requires = { 'nvim-lua/plenary.nvim', commit = '4b66054e75356ac0b909bbfee9c682e703f535c2' },
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
    commit = 'ddaac623e292e429621fb59d7cd9f3b32f3f16c5',
    requires = 'kevinhwang91/promise-async',
    config = "require('vasco.ufo')",
  }

  use {
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = '2584ff391b528d01bf5e8c04206d5902a79ebdde',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '4b66054e75356ac0b909bbfee9c682e703f535c2' },
      { 'crispgm/telescope-heading.nvim', commit = '6f54230d738b1e582e3a4c983722ce795aca101c' },
    },
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = 'bed067c925b5e31035b2821ae702552091a0b634',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '4b66054e75356ac0b909bbfee9c682e703f535c2' },
      { 'nvim-treesitter/nvim-treesitter', commit = '2a63ea5665a6de96acd31a045d9d4d73272ff5a9' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
      { 'olimorris/neotest-rspec', commit = '0c98f4ed25882f1e46e7cbdae1229e80d140994f' },
      { 'haydenmeade/neotest-jest', commit = '8c64cba48d7e3a9c8f58a32b85762bc8d06b2839' },
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
    commit = 'b16e5bcf1d8fd466c289eab2472d064bcd7bab5d',
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', commit = 'affe808a5c56b71630f17aa7c38e15c59fd648a8' },
      { 'hrsh7th/cmp-nvim-lua', commit = 'd276254e7198ab7d00f117e88e223b4bd8c02d21' },
      { 'hrsh7th/cmp-buffer', commit = '62fc67a2b0205136bc3e312664624ba2ab4a9323' },
      { 'hrsh7th/cmp-path', commit = '466b6b8270f7ba89abd59f402c73f63c7331ff6e' },
      { 'hrsh7th/cmp-cmdline', commit = 'c36ca4bc1dedb12b4ba6546b96c43896fd6e7252' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', commit = '007dd2740d9b70f2688db01a39d6d25b7169cd57' },
      { 'f3fora/cmp-spell', commit = '5602f1a0de7831f8dad5b0c6db45328fbd539971' },
      { 'saadparwaiz1/cmp_luasnip', commit = 'a9de941bcbda508d0a45d28ae366bb3f08db2e36' },
      { 'rcarriga/cmp-dap', commit = '3310f7daec849ba708c1dd34e3d3bc721ca35511' },
      { 'jbyuki/one-small-step-for-vimkind', commit = '59ec6f57545a42e68995994bfa57479da5e68b74' },
    },
    config = "require('vasco.completion')",
  }

  use { 'tpope/vim-ragtag', commit = '51b313e8a2e3a44f37b9d625bc0d461e9066b7e9', ft = { 'ruby', 'eruby' } }

  use {
    'L3MON4D3/LuaSnip',
    commit = '4073f821e1c02c7deb50235b4b68ecc5cf0b95e9',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = '57e5b5dfbe991151b07d272a06e365a77cc3d0e7' }

  use {
    'williamboman/mason.nvim',
    commit = '6a2b45bad60a5ffe44c5b2423fd70d5a7a60c5ba',
    config = "require('vasco.mason')",
  }

  use { 'williamboman/mason-lspconfig.nvim', commit = '1534b610c5e8afaa2cc4231f0715354dc2d9688b' }

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
    'renerocksai/telekasten.nvim',
    commit = 'fdb089daf6d66e9d559645e664a172ff5b6a5ddd',
    config = "require('vasco.zettelkasten')",
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = '1569ad4817492e0daefa4e1bcf55f8280cdc82db',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = 'daacdc338edd91be83db0ef73d4d8c92677cfb09',
    config = "require('vasco.possession')",
  }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

  use {
    'folke/which-key.nvim',
    commit = '439637d6a75fe27e369190df7910ed2a454109f6',
    config = "require('vasco.whichkey')",
    keys = { '<leader>' },
  }

  use {
    'norcalli/nvim-colorizer.lua',
    commit = '36c610a9717cc9ec426a07c8e6bf3b3abcb139d6',
    config = "require('vasco.colorizer')",
  }

  use { 'nvim-pack/nvim-spectre', commit = 'c553eb47ad9d82f8452119ceb6eb209c930640ec', event = 'VimEnter' }

  use {
    'rcarriga/nvim-dap-ui',
    commit = '225115ae986b39fdaffaf715e571dd43b3ac9670',
    requires = {
      { 'mfussenegger/nvim-dap', commit = '57003a082a92a9fcba9158626ea15385dd4bbba2' },
      { 'theHamsta/nvim-dap-virtual-text', commit = '2971ce3e89b1711cc26e27f73d3f854b559a77d4' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = 'c9f3d44d2edfbb0bc6f8c5bb4366166e969b2e67',
    cmd = { 'Neogit' },
    config = "require('vasco.neogit')",
  }

  use {
    'sindrets/diffview.nvim',
    commit = 'a4796a82e4da4c66476641012648c29e0b62a4ae',
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
    commit = '3e49d9b7484e21f0b24ebdf21b8b7af227ea97a6',
    config = "require('vasco.nvim-tree')",
    cmd = 'NvimTreeToggle',
  }

  use { 'kyazdani42/nvim-web-devicons', commit = '2d02a56189e2bde11edd4712fea16f08a6656944' }

  use {
    -- this requires the following font to be installed:
    -- https://github.com/yamatsum/nonicons/blob/master/dist/nonicons.ttf
    'yamatsum/nvim-nonicons',
    requires = { 'kyazdani42/nvim-web-devicons' },
  }

  use {
    'stevearc/dressing.nvim',
    commit = '9cdb3e0f0973447b940b35d3175dc780301de427',
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
    config = "require('vasco.fidget')",
  }

  use {
    'terrortylor/nvim-comment',
    commit = 'e9ac16ab056695cad6461173693069ec070d2b23',
    config = [[require('nvim_comment').setup()]],
  }

  use {
    'kylechui/nvim-surround',
    commit = '01e17311bddffd65cc191bbefb845dba46780859',
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

  use {
    'ellisonleao/gruvbox.nvim',
    commit = 'c7aaa3ec3f431d90b0b9382cb52bebffc0e4283a',
    config = "require('vasco.theme')",
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
