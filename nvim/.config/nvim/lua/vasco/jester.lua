local ok, jester = pcall(require, 'jester')

if not ok then
  return
end

jester.setup {
  cmd = "yarn jest -t '$result' -- $file",
  terminal_cmd = ':vsplit | terminal',
}
