local ok, fidget = pcall(require, 'fidget')

if not ok then
  return
end

fidget.setup {
  window = {
    blend = 0,
  },
  sources = {
    ltex = {
      ignore = true,
    },
  },
}
