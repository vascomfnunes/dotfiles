return {
  'echasnovski/mini.basics',
  version = false,
	lazy = false,
  setup = function()
    require('mini.basics').setup {
      mappings = {
        basic = false,
      },
    }
  end,
}
