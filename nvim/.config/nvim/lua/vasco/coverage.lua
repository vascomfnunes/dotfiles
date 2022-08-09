require('coverage').setup {
  commands = true,
  highlights = {
    covered = { fg = '#C3E88D' }, -- supports style, fg, bg, sp (see :h highlight-gui)
    uncovered = { fg = '#F07178' },
  },
  signs = {
    covered = { hl = 'CoverageCovered', text = '▎' },
    uncovered = { hl = 'CoverageUncovered', text = '▎' },
  },
  summary = {
    min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
  },
  lang = {
    -- customize language specific settings
  },
}
