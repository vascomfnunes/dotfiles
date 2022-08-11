require 'vasco.impatient'
require 'vasco.filetype'
require 'options'
require 'plugins'
require 'mappings'
require 'autocommands'
require 'vasco.lsp.config'

function set_colorscheme(mode)
  vim.cmd('set background=' .. mode)
  vim.loop.spawn('kitty', {
    args = {
      '@',
      'set-colors',
      '-c',
      string.format(vim.env.HOME .. '/.config/kitty/gruvbox-material-soft-' .. mode .. '.conf'),
    },
  }, nil)
end
