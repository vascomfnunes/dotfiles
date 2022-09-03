local ok, fidget = pcall(require, 'fidget')

if not ok then
  return
end

fidget.setup {
  text = {
    spinner = 'dots',
    done = ' ',
  },
  window = {
    relative = 'win',
    blend = 0,
  },
}
