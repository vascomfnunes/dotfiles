local M = {
  'mrjones2014/dash.nvim',
  build = 'make install',
  cmd = { 'Dash', 'DashWord' },
}

function M.config()
  require('dash').setup {
    dash_app_path = '/Applications/Dash.app',
    -- search engine to fall back to when Dash has no results, must be one of: 'ddg', 'duckduckgo', 'startpage', 'google'
    search_engine = 'ddg',
    file_type_keywords = {
      javascript = { 'javascript', 'nodejs' },
      typescript = { 'typescript', 'javascript', 'nodejs' },
      typescriptreact = { 'typescript', 'javascript', 'react' },
      javascriptreact = { 'javascript', 'react' },
      ruby = { 'ruby', 'rails' },
    },
  }
end

return M
