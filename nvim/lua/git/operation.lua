local M = {}

function M.detect(exists)
  if exists("rebase-apply/applying") then
    return { name = "am", continue_args = { "am", "--continue" }, abort_args = { "am", "--abort" } }
  elseif exists("rebase-merge") or exists("rebase-apply") then
    return { name = "rebase", continue_args = { "rebase", "--continue" }, abort_args = { "rebase", "--abort" } }
  elseif exists("MERGE_HEAD") then
    return { name = "merge", continue_args = { "merge", "--continue" }, abort_args = { "merge", "--abort" } }
  elseif exists("CHERRY_PICK_HEAD") then
    return {
      name = "cherry-pick",
      continue_args = { "cherry-pick", "--continue" },
      abort_args = { "cherry-pick", "--abort" },
    }
  elseif exists("REVERT_HEAD") then
    return { name = "revert", continue_args = { "revert", "--continue" }, abort_args = { "revert", "--abort" } }
  end

  return nil
end

return M
