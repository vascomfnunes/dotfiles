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
    name = 'Debug Jest Tests',
    runtimeExecutable = 'node',
    runtimeArgs = { '--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest' },
    args = { '${file}', '--runInBand', '--no-cache', '--coverage', 'false' },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
    sourceMaps = 'inline',
    port = 9229,
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
    protocol = 'inspector',
  },
}