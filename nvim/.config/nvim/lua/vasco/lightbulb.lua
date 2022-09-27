local ok, lightbulb = pcall(require, 'nvim-lightbulb')

if not ok then
  return
end

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]

lightbulb.setup {
  -- LSP client names to ignore
  ignore = { 'lua' },
  sign = {
    enabled = true,
    priority = 1000,
  },
  float = {
    enabled = false,
    text = ' ',
    winblend = 0,
    win_opts = {},
  },
  autocmd = {
    enabled = false,
    pattern = { '*' },
    events = { 'CursorHold', 'CursorHoldI' },
  },
}

vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'LightBulbSign', linehl = '', numhl = '' })
