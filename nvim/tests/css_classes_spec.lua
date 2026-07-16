local root = assert(arg[1], "dotfiles root is required")
package.path = root .. "/nvim/lua/?.lua;" .. package.path

local css_classes = require("css_classes")
local temporary = vim.fn.tempname()
local repository = temporary .. "/repository"

vim.fn.mkdir(repository .. "/app/assets/stylesheets", "p")
vim.fn.mkdir(repository .. "/app/components", "p")
vim.fn.mkdir(repository .. "/node_modules/example", "p")
vim.fn.mkdir(repository .. "/public/assets", "p")

vim.fn.writefile({
  ".button, .button--primary:hover { color: blue; }",
  "@media (width > 40rem) { .card { display: block; } }",
  ".vc-body-main-content { display: grid; }",
}, repository .. "/app/assets/stylesheets/application.css")
vim.fn.writefile({ ".panel { padding: 1rem; }" }, repository .. "/app/components/panel.scss")
vim.fn.writefile({ ".dependency { color: red; }" }, repository .. "/node_modules/example/index.css")
vim.fn.writefile({ ".generated { color: red; }" }, repository .. "/public/assets/application.css")
vim.fn.writefile({ '<div class="vc-body-ma">Button</div>' }, repository .. "/index.html")
vim.fn.writefile({ '<div class="car">Card</div>' }, repository .. "/card.html.erb")

assert(vim.deep_equal(css_classes.parse(".alpha:hover, .beta-name {}"), { "alpha", "beta-name" }))
assert(css_classes.is_completion_context('<div class="button'))
assert(css_classes.is_completion_context('<%= tag.div class: "button'))
assert(not css_classes.is_completion_context('<div id="button'))

local project = css_classes.index(repository)
assert(project.classes.button)
assert(project.classes["button--primary"])
assert(project.classes.card)
assert(project.classes.panel)
assert(not project.classes.hover)
assert(not project.classes.dependency)
assert(not project.classes.generated)

css_classes.setup()
local function completion_items(path, filetype, prefix)
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.cmd.setfiletype(filetype)
  assert(vim.wait(1000, function()
    return #vim.lsp.get_clients({ name = "css_classes", bufnr = 0 }) == 1
  end), "css_classes did not attach")

  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_win_set_cursor(0, { 1, line:find(prefix, 1, true) + #prefix - 1 })
  local client = vim.lsp.get_clients({ name = "css_classes", bufnr = 0 })[1]
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  local response = assert(client:request_sync("textDocument/completion", params, 1000, 0))
  local items = {}
  for _, item in ipairs(response.result.items) do items[item.label] = item end
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  local word_boundary = vim.fn.match(line:sub(1, cursor_col), "\\k*$")
  local matches, start_col = vim.lsp.completion._convert_results(
    line,
    0,
    cursor_col,
    client.id,
    word_boundary,
    nil,
    response.result,
    client.offset_encoding
  )
  return items, matches, start_col
end

local html_items, html_matches, html_start = completion_items(repository .. "/index.html", "html", "vc-body-ma")
local dashed_item = assert(html_items["vc-body-main-content"])
assert(dashed_item.textEdit.newText == "vc-body-main-content")
assert(dashed_item.textEdit.range.start.character == 12)
assert(dashed_item.textEdit.range["end"].character == 22)
assert(html_start == 12)
assert(#html_matches == 1)
assert(html_matches[1].word == "vc-body-main-content")

local erb_items = completion_items(repository .. "/card.html.erb", "eruby", "car")
assert(erb_items.card)

vim.fn.delete(temporary, "rf")
