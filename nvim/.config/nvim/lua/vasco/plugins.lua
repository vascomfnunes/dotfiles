return {
  'MunifTanjim/nui.nvim',
  'nvim-lua/plenary.nvim',
  'b0o/schemastore.nvim',
  'windwp/nvim-spectre',
  { 'sainnhe/gruvbox-material', lazy = false },
  { 'kyazdani42/nvim-web-devicons', event = 'VeryLazy' },
  {
    'utilyre/barbecue.nvim',
    version = '*',
    dependencies = { 'smiteshp/nvim-navic' },
    event = 'BufReadPost',
    config = function()
      require('barbecue').setup()
    end,
  },
  {
    'danymat/neogen',
    cmd = 'Neogen',
    config = function()
      require('neogen').setup { snippet_engine = 'luasnip' }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'BufReadPost',
    ft = {
      'html',
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact',
      'vue',
      'tsx',
      'jsx',
      'xml',
      'php',
      'markdown',
    },
  },
  { 'christoomey/vim-tmux-navigator', event = 'VimEnter' },
  {
    'RyanMillerC/better-vim-tmux-resizer',
    event = 'VimEnter',
    config = function()
      vim.g.tmux_resizer_no_mappings = 1
    end,
  },
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    config = function()
      require('Comment').setup()
    end,
  },
  {
    'kylechui/nvim-surround',
    event = 'BufReadPost',
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'BufReadPost',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
  },
  {
    'Exafunction/codeium.vim',
    event = 'VeryLazy',
    config = function()
      vim.g.codeium_enabled = false
      vim.keymap.set('i', '<C-g>', function()
        return vim.fn['codeium#Accept']()
      end, { expr = true })
    end,
  },
  { -- requires 'npm install -g live-server' and 'brew install pandoc'
    'davidgranstrom/nvim-markdown-preview',
    ft = 'markdown',
  },
  {
    'tpope/vim-rails',
    ft = 'ruby',
  },
  {
    'tpope/vim-ragtag',
    ft = 'eruby',
  },
}
