local M = {}
local documentation_request = 0

local documentation_winhl = table.concat({
  "Normal:DotfilesCompletionDocumentation",
  "NormalFloat:DotfilesCompletionDocumentation",
  "FloatBorder:DotfilesCompletionDocumentationBorder",
  "EndOfBuffer:DotfilesCompletionDocumentation",
}, ",")

local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰊄",
}

local function compact(value, width)
  value = tostring(value or ""):gsub("[\r\n]+", " "):gsub("%s+", " ")
  value = vim.trim(value)
  if vim.fn.strdisplaywidth(value) <= width then return value end
  return vim.fn.strcharpart(value, 0, width - 1) .. "…"
end

function M.convert(item)
  local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or "Unknown"
  local label_detail = item.labelDetails and item.labelDetails.detail or ""
  local label = item.label or ""
  if label_detail ~= "" and not label:find(label_detail, 1, true) then
    label = label .. label_detail
  end

  local converted = {
    abbr = compact(label, 48),
    menu = compact((item.labelDetails and item.labelDetails.description) or item.detail, 36),
  }

  -- Preserve Neovim's dynamically coloured square for CSS colour items.
  if kind ~= "Color" then
    converted.kind = string.format("%s  %s", kind_icons[kind] or "•", kind)
    converted.kind_hlgroup = "DotfilesCompletionKind" .. kind
  end
  return converted
end

function M.highlights(colors)
  local highlights = {
    Pmenu = { fg = colors.text, bg = colors.mantle },
    PmenuSel = { fg = colors.text, bg = colors.surface1, style = { "bold" } },
    PmenuBorder = { fg = colors.blue, bg = colors.mantle },
    PmenuKind = { fg = colors.subtext1, bg = colors.mantle },
    PmenuKindSel = { fg = colors.subtext1, bg = colors.surface1, style = { "bold" } },
    PmenuExtra = { fg = colors.overlay1, bg = colors.mantle },
    PmenuExtraSel = { fg = colors.subtext0, bg = colors.surface1 },
    PmenuMatch = { fg = colors.blue, style = { "bold" } },
    PmenuMatchSel = { fg = colors.sky, style = { "bold" } },
    PmenuSbar = { bg = colors.surface0 },
    PmenuThumb = { bg = colors.overlay1 },
    ComplMatchIns = { fg = colors.blue, style = { "bold" } },
    DotfilesCompletionDocumentation = { fg = colors.text, bg = colors.mantle },
    DotfilesCompletionDocumentationBorder = { fg = colors.blue, bg = colors.mantle },
  }

  local kind_colors = {
    Text = colors.teal,
    Method = colors.blue,
    Function = colors.blue,
    Constructor = colors.blue,
    Field = colors.green,
    Variable = colors.flamingo,
    Class = colors.yellow,
    Interface = colors.yellow,
    Module = colors.blue,
    Property = colors.green,
    Unit = colors.green,
    Value = colors.peach,
    Enum = colors.green,
    Keyword = colors.red,
    Snippet = colors.mauve,
    File = colors.blue,
    Reference = colors.red,
    Folder = colors.blue,
    EnumMember = colors.red,
    Constant = colors.peach,
    Struct = colors.blue,
    Event = colors.blue,
    Operator = colors.blue,
    TypeParameter = colors.blue,
    Unknown = colors.overlay1,
  }
  for kind, color in pairs(kind_colors) do
    highlights["DotfilesCompletionKind" .. kind] = { fg = color }
  end

  return highlights
end

local function style_documentation()
  local info = vim.fn.complete_info({ "preview_winid" })
  local win = info.preview_winid
  if type(win) ~= "number" or win == 0 or not vim.api.nvim_win_is_valid(win) then
    -- The preview id may briefly be unavailable while LSP documentation is
    -- being resolved. Its internal float has this otherwise unusual shape.
    for _, candidate in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(candidate)
      local buf = vim.api.nvim_win_get_buf(candidate)
      if
        config.relative ~= ""
        and config.focusable == false
        and config.zindex == 50
        and vim.bo[buf].buftype == "nofile"
        and vim.wo[candidate].winhighlight == "EndOfBuffer:"
      then
        win = candidate
        break
      end
    end
  end
  if type(win) ~= "number" or win == 0 or not vim.api.nvim_win_is_valid(win) then return false end

  -- The native completion documentation window is created borderless and only
  -- overrides EndOfBuffer, independently of 'pumborder' and 'winborder'.
  return pcall(function()
    vim.api.nvim_win_set_config(win, { border = "rounded" })
    vim.wo[win].winhighlight = documentation_winhl
  end)
end

local function style_documentation_when_ready()
  documentation_request = documentation_request + 1
  local request = documentation_request
  local attempts = 0

  local function attempt()
    if request ~= documentation_request then return end
    if style_documentation() then return end

    -- completionItem/resolve may create the documentation popup later.
    attempts = attempts + 1
    if attempts < 40 then vim.defer_fn(attempt, 50) end
  end

  attempt()
end

function M.setup()
  local group = vim.api.nvim_create_augroup("DotfilesCompletionDocumentation", { clear = true })
  vim.api.nvim_create_autocmd("CompleteChanged", {
    group = group,
    callback = style_documentation_when_ready,
  })
end

return M
