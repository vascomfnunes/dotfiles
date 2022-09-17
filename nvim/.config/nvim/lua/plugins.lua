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

  use { 'neovim/nvim-lspconfig', commit = '51775b12cfbf1b6462c7b13cd020cc09e6767aea' }

  use {
    'nvim-treesitter/nvim-treesitter',
    commit = '8689f61270c1b80131b0e7bea56d5df70766a06f',
    run = ':TSUpdate',
    config = "require('vasco.treesitter')",
    requires = {
      {
        'jose-elias-alvarez/typescript.nvim',
        commit = 'fc02517dbec65143d4d414ed6b66bbf5405c0c20',
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
    requires = { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
    config = "require('vasco.lightbulb')",
  }

  use {
    'danymat/neogen',
    commit = 'c5a0c39753808faa41dea009d41dd686732c6774',
    config = function()
      require('neogen').setup {}
    end,
    requires = { 'nvim-treesitter/nvim-treesitter', commit = '8689f61270c1b80131b0e7bea56d5df70766a06f' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    commit = '231fa923fbc2797eef92b24860ab882cebf645b2',
    requires = { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
    config = "require('vasco.gitsigns')",
    event = 'BufRead',
  }

  use {
    'sitiom/nvim-numbertoggle',
    commit = 'b48b9c74aabdf6cfd3f7fd990baae7681890b764',
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
    'nvim-telescope/telescope.nvim', -- requires 'brew install rg' for live_grep
    commit = '30e2dc5232d0dd63709ef8b44a5d6184005e8602',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
      { 'crispgm/telescope-heading.nvim', commit = '6f54230d738b1e582e3a4c983722ce795aca101c' },
    },
    config = "require('vasco.telescope')",
  }

  use {
    'nvim-neotest/neotest',
    commit = '15c0bb23431d165300507573b0ae29debd57ea29',
    requires = {
      { 'nvim-lua/plenary.nvim', commit = '62dc2a7acd2fb2581871a36c1743b29e26c60390' },
      { 'nvim-treesitter/nvim-treesitter', commit = '8689f61270c1b80131b0e7bea56d5df70766a06f' },
      { 'antoinemadec/FixCursorHold.nvim', commit = '5aa5ff18da3cdc306bb724cf1a138533768c9f5e' },
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
    commit = '85daa472e352941c3ba0fd3c1e891b93dec8168a',
    requires = { 'rafamadriz/friendly-snippets' },
    config = "require('vasco.luasnip')",
  }

  use { 'onsails/lspkind-nvim', commit = 'f46e3b5528e73347dc0678277460e5cea2a52b6a' }

  use {
    'williamboman/mason.nvim',
    commit = 'd7eb2eeec566da6cfd1c61b1d7aa6fc592d1b296',
    config = "require('vasco.mason')",
  }

  use { 'williamboman/mason-lspconfig.nvim', commit = 'b70dedab5ceb5f3f84c6bc9ceea013292a14f8dc' }

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
    commit = 'fdb089daf6d66e9d559645e664a172ff5b6a5ddd',
    config = "require('vasco.zettelkasten')",
  }

  use { 'mzlogin/vim-markdown-toc', commit = '31aa38e58334f1321ae8ec6f38d05303f3226698', ft = 'markdown' }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    commit = 'fb2c4701f29dd60f003c6e5d3db1ff606d65907f',
    config = "require('vasco.null-ls')",
  }

  use {
    'jedrzejboczar/possession.nvim',
    commit = '19419f2f303858cea6e1d8d5ddd4ce380c6884c7',
    config = "require('vasco.possession')",
  }

  use {
    'windwp/nvim-ts-autotag',
    commit = '044a05c4c51051326900a53ba98fddacd15fea22',
    config = "require('vasco.autotag')",
  }

  use {
    'folke/which-key.nvim',
    commit = '92d924d1f4ec67a86a4d54c3ea22caf8ad09a5d4',
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
    commit = 'ebebd429f88bcf656d4c78dec201a8be73a76156',
    requires = {
      { 'mfussenegger/nvim-dap', commit = '2cfd77058dbafc7134bf3555c398d26d399e0623' },
      { 'theHamsta/nvim-dap-virtual-text', commit = '2971ce3e89b1711cc26e27f73d3f854b559a77d4' },
    },
    config = "require('vasco.dap')",
  }

  use {
    'TimUntersberger/neogit',
    commit = '64245bb7f577bad0308d77dc1116ce7d8428f27f',
    cmd = { 'Neogit' },
    config = "require('vasco.neogit')",
  }

  use {
    'sindrets/diffview.nvim',
    commit = '387098ddc683cc93495da9e5501373db187ada3b',
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
    commit = 'fb8735e96cecf004fbefb086ce85371d003c5129',
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
    commit = 'fbc798c34c21a4d7914a41f5b2263af2f75750c8',
    requires = { 'MunifTanjim/nui.nvim', commit = '70f2dadb73b5aa15727ec8f7a620818997505be5' },
  }

  use {
    'nvim-lualine/lualine.nvim',
    commit = 'a52f078026b27694d2290e34efa61a6e4a690621',
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
    commit = 'd91787d5a716623be7cec3be23c06c0856dc21b8',
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
    commit = 'c632f629026cf41308b4473ab9bb9686318c993c',
    config = "require('vasco.theme')",
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
