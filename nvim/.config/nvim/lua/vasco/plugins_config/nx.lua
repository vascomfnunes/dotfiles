-- add a conditional guard, nx plugin currently errors if not inside a git root directory
if vim.fn.isdirectory '.git' ~= 0 and vim.fn.isdirectory 'apps' ~= 0 then
  require('nx').setup {
    -- Base command to run all other nx commands, some other values may be:
    -- - `npm nx`
    -- - `yarn nx`
    -- - `pnpm nx`
    nx_cmd_root = 'nx',
  }
end
