local status_ok, nx = pcall(require, 'nx')

if not status_ok then
  return
end

-- add a conditional guard, nx plugin currently errors if not inside a git root directory
if vim.fn.isdirectory '.git' ~= 0 then
  nx.setup {
    -- Base command to run all other nx commands, some other values may be:
    -- - `npm nx`
    -- - `yarn nx`
    -- - `pnpm nx`
    nx_cmd_root = 'nx',
  }
end
