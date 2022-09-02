local ok, neotest = pcall(require, 'neotest')

if not ok then
  return
end

neotest.setup {
  adapters = {
    require 'neotest-jest' {
      jestCommand = 'yarn jest',
    },
    require 'neotest-rspec',
  },
  icons = {
    child_indent = '│',
    child_prefix = '├',
    collapsed = '─',
    expanded = '╮',
    failed = ' ',
    final_child_indent = ' ',
    final_child_prefix = '╰',
    non_collapsible = '─',
    passed = ' ',
    running = ' ',
    skipped = ' ',
    unknown = ' ',
  },
  summary = {
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = 'a',
      expand = { '<CR>', '<2-LeftMouse>' },
      expand_all = 'e',
      jumpto = 'l',
      output = 'o',
      run = 'r',
      short = 'O',
      stop = 'u',
    },
  },
}
