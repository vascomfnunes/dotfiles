local M = {}
local paths = {}

function M.path(root)
  if not root or root == "" then return nil end
  if paths[root] then return paths[root] end

  local result = vim.system({
    "git", "-C", root, "rev-parse", "--path-format=absolute", "--git-path", "tags",
  }, { text = true }):wait()
  local path = result.code == 0 and vim.trim(result.stdout or "") or ""
  if path == "" then path = root .. "/tags" end
  paths[root] = path
  return path
end

function M.with_file(bufnr, path, callback)
  return vim.api.nvim_buf_call(bufnr, function()
    local original = vim.bo[bufnr].tags
    local escaped = vim.fn.fnameescape(path):gsub(",", "\\,")
    vim.bo[bufnr].tags = escaped .. "," .. original
    local result = { pcall(callback) }
    vim.bo[bufnr].tags = original
    if not result[1] then error(result[2]) end
    return unpack(result, 2)
  end)
end

-- Tag the project and every bundled gem with ripper-tags so `gd` can fall
-- back to tags for definitions ruby-lsp can't resolve. Resolve the Git tags
-- path through Git itself so linked worktrees are supported.
local function generate_gem_tags()
  local root = vim.fs.root(0, "Gemfile")
  if not root then
    vim.notify("No Gemfile found", vim.log.levels.WARN)
    return
  end
  local tag_file = M.path(root)
  -- ripper-tags occasionally emits an entry with an embedded newline, which
  -- makes Vim reject the whole file (E431); drop malformed lines afterwards.
  local quoted = vim.fn.shellescape(tag_file)
  local sanitize = string.format(
    [[LC_ALL=C awk -F'\t' 'NF>=3' %s > %s.tmp && mv %s.tmp %s]],
    quoted, quoted, quoted, quoted
  )
  local function done(msg, level)
    vim.schedule(function()
      vim.g.gemtags_running = nil
      vim.notify(msg, level)
      vim.cmd.redrawstatus()
    end)
  end
  vim.g.gemtags_running = true
  vim.cmd.redrawstatus()
  vim.system({ "mise", "x", "--", "bundle", "list", "--paths" }, { cwd = root, text = true }, function(list)
    if list.code ~= 0 then
      done("bundle list failed:\n" .. (list.stderr or ""), vim.log.levels.ERROR)
      return
    end
    local cmd = {
      "mise", "x", "--", "ripper-tags", "-R", "--tag-file", tag_file,
      "--exclude=vendor", "--exclude=node_modules", root,
    }
    vim.list_extend(cmd, vim.split(vim.trim(list.stdout), "\n"))
    vim.system(cmd, { cwd = root, text = true }, function(res)
      if res.code ~= 0 then
        done("ripper-tags failed (gem install ripper-tags?):\n" .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      vim.system({ "sh", "-c", sanitize }, {}, function(s)
        if s.code == 0 then
          done("Tags written to " .. tag_file)
        else
          done("tags sanitize failed:\n" .. (s.stderr or ""), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("GemTags", generate_gem_tags, {
    desc = "Generate tags for project and bundled gems",
    force = true,
  })
end

return M
