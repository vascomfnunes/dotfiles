require('ufo').setup {
  open_fold_hl_timeout = 0,
  provider_selector = function(_, _, _)
    return { 'treesitter', 'indent' }
  end,
}
