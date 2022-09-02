local ok, jester = pcall(require, 'jester')

if not ok then
  return
end

jester.setup {
  cmd = "yarn jest -t '$result' -- $file",
  terminal_cmd = ':vsplit | terminal',
  dap = { -- debug adapter configuration
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = { '--inspect-brk', '$path_to_jest', '--no-coverage', '-t', '$result', '--', '$file' },
    args = { '--no-cache' },
    sourceMaps = 'inline',
    protocol = 'inspector',
    skipFiles = { '<node_internals>/**/*.js' },
    console = 'externalTerminal',
    port = 9229,
    disableOptimisticBPs = true,
  },
}
