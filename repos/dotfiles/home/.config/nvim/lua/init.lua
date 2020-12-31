require'plugins'.init()
require'settings'.init()
require'autocommands'.init()
require'mappings'.init()
require 'lsp.init'
require 'plugins.express_line'
require 'plugins.treesitter'
require 'plugins.vifm'
require 'plugins.fugitive'
require 'plugins.telescope'
require'theme'.init()
-- Colorizer should be required after the theme settings
require'colorizer'.setup()
