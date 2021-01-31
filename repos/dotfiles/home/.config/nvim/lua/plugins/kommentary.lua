local sk = vim.api.nvim_set_keymap

require('kommentary.config').config["rust"] = {"//", {"/*", "*/"}}

sk('n', 'gc', '<Plug>Kommentary', {noremap = true, expr = true})
sk('v', 'gc', '<Plug>Kommentary', {noremap = true, expr = true})
