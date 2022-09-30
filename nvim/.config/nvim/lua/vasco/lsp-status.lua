local ok, lsp_status = pcall(require, 'lsp-status')

if not ok then
  return
end

lsp_status.register_progress()

lsp_status.config {
  indicator_errors = ' ',
  indicator_warnings = ' ',
  indicator_info = ' ',
  indicator_hint = ' ',
  indicator_ok = ' ',
}
