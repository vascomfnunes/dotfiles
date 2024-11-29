return {
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        enable_rename = true,
        enable_close = false,
        enable_close_on_slash = false,
        filetypes = {
          'html',
          'javascript',
          'typescript',
          'javascriptreact',
          'typescriptreact',
          'svelte',
          'eruby',
          'vue',
          'tsx',
          'jsx',
          'xml',
          'php',
          'markdown',
        },
      },
      ft = {
        'html',
        'eruby',
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
    }
  end,
}
