local M = {}

local projects = {}
local class_query

local excluded_directories = {
  [".git"] = true,
  [".jj"] = true,
  [".bundle"] = true,
  [".cache"] = true,
  build = true,
  coverage = true,
  dist = true,
  log = true,
  node_modules = true,
  storage = true,
  tmp = true,
  vendor = true,
}

local function is_stylesheet(path)
  return path:match("%.css$") or path:match("%.scss$") or path:match("%.sass$")
end

local function sorted_keys(values)
  local result = vim.tbl_keys(values)
  table.sort(result)
  return result
end

local function parse_conventional_selectors(text, classes)
  local uncommented = text:gsub("/%*.-%*/", "")
  for selector in uncommented:gmatch("([^{}]+){") do
    for name in selector:gmatch("%.([%a_%-][%w_%-]*)") do
      classes[name] = true
    end
  end

  -- Indented Sass has no braces. Restrict this fallback to lines beginning
  -- with a class selector so property values such as `.5rem` are ignored.
  for line in uncommented:gmatch("[^\r\n]+") do
    if line:match("^%s*%.") then
      for name in line:gmatch("%.([%a_%-][%w_%-]*)") do
        classes[name] = true
      end
    end
  end
end

function M.parse(text)
  local classes = {}
  local ok, parser = pcall(vim.treesitter.get_string_parser, text, "css")
  if ok then
    class_query = class_query or vim.treesitter.query.parse("css", "(class_selector (class_name) @class)")
    local tree = parser:parse()[1]
    for _, node in class_query:iter_captures(tree:root(), text, 0, -1) do
      classes[vim.treesitter.get_node_text(node, text)] = true
    end
  end
  -- Keep conventional CSS and indented Sass working before the parser is
  -- installed, and when the CSS parser cannot understand the input.
  if not ok or next(classes) == nil then parse_conventional_selectors(text, classes) end
  return sorted_keys(classes)
end

local function stylesheet_paths(root)
  local paths = {}

  local function walk(directory, relative)
    local ok, entries = pcall(vim.fs.dir, directory)
    if not ok then return end

    for name, kind in entries do
      local path = vim.fs.joinpath(directory, name)
      local child_relative = relative == "" and name or vim.fs.joinpath(relative, name)
      if kind == "directory" then
        local generated_assets = child_relative == vim.fs.joinpath("public", "assets")
          or child_relative == vim.fs.joinpath("public", "packs")
        if not excluded_directories[name] and not generated_assets then walk(path, child_relative) end
      elseif kind == "file" and is_stylesheet(name) then
        paths[#paths + 1] = path
      end
    end
  end

  walk(root, "")
  table.sort(paths)
  return paths
end

local function read_classes(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  return ok and M.parse(table.concat(lines, "\n")) or {}
end

local function rebuild(project)
  project.classes = {}
  for path, names in pairs(project.files) do
    for _, name in ipairs(names) do
      local sources = project.classes[name] or {}
      sources[#sources + 1] = path
      project.classes[name] = sources
    end
  end
  project.names = sorted_keys(project.classes)

  -- Precompute completion details so per-keystroke requests stay cheap, and
  -- sort sources so completions and definitions are deterministic.
  project.details = {}
  for name, sources in pairs(project.classes) do
    table.sort(sources)
    local relative = vim.tbl_map(function(path)
      return vim.fs.relpath(project.root, path) or path
    end, sources)
    project.details[name] = table.concat(relative, ", ")
  end
end

function M.index(root)
  local project = { root = root, files = {} }
  for _, path in ipairs(stylesheet_paths(root)) do
    project.files[path] = read_classes(path)
  end
  rebuild(project)
  projects[root] = project
  return project
end

function M.is_completion_context(text)
  local tag = text:match("<[^<>]*$")
  if tag and tag:match("[%s<]class%s*=%s*[\"'][^\"']*$") then return true end
  return text:match("class%s*:%s*[\"'][^\"']*$") ~= nil
end

-- Lines up to the cursor plus the cursor's byte column, for context checks.
local function cursor_context(params)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  if not vim.api.nvim_buf_is_valid(bufnr) then return nil end

  local position = params.position
  local start_line = math.max(0, position.line - 20)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, position.line + 1, false)
  local current = lines[#lines] or ""
  local byte_col = vim.str_byteindex(current, "utf-16", position.character, false)
  return lines, current, byte_col
end

local function class_at_position(params)
  local lines, current, byte_col = cursor_context(params)
  if not lines then return nil end

  local before = current:sub(1, byte_col):match("([%w_-]+)$") or ""
  local after = current:sub(byte_col + 1):match("^([%w_-]+)") or ""
  local name = before .. after
  if name == "" then return nil end

  lines[#lines] = current:sub(1, byte_col + #after)
  if not M.is_completion_context(table.concat(lines, "\n")) then return nil end
  return name
end

local function utf16_col(line, byte_col)
  return vim.str_utfindex(line, "utf-16", byte_col, false)
end

function M.definition_ranges(text, name)
  local lines = vim.split(text, "\n", { plain = true })
  local ok, ranges = pcall(function()
    local parser = vim.treesitter.get_string_parser(text, "css")
    class_query = class_query or vim.treesitter.query.parse("css", "(class_selector (class_name) @class)")
    local tree = parser:parse()[1]
    local result = {}

    for _, node in class_query:iter_captures(tree:root(), text, 0, -1) do
      if vim.treesitter.get_node_text(node, text) == name then
        local start_row, start_col, end_row, end_col = node:range()
        result[#result + 1] = {
          start = { line = start_row, character = utf16_col(lines[start_row + 1], start_col) },
          ["end"] = { line = end_row, character = utf16_col(lines[end_row + 1], end_col) },
        }
      end
    end
    return result
  end)
  if ok and #ranges > 0 then return ranges end

  -- Keep definitions working before the CSS parser has been installed.
  ranges = {}
  local escaped = name:gsub("([^%w])", "%%%1")
  for row, line in ipairs(lines) do
    local offset = 1
    while true do
      local start_col, end_col = line:find("%." .. escaped, offset)
      if not start_col then break end
      local next_character = line:sub(end_col + 1, end_col + 1)
      if next_character == "" or not next_character:match("[%w_-]") then
        ranges[#ranges + 1] = {
          start = { line = row - 1, character = utf16_col(line, start_col) },
          ["end"] = { line = row - 1, character = utf16_col(line, start_col + #name) },
        }
      end
      offset = end_col + 1
    end
  end
  return ranges
end

local function completion_context(params)
  local lines, current, byte_col = cursor_context(params)
  if not lines then return nil end

  lines[#lines] = current:sub(1, byte_col)
  if not M.is_completion_context(table.concat(lines, "\n")) then return nil end

  local fragment = lines[#lines]:match("([%w_-]*)$") or ""
  return params.position.character - #fragment
end

local function create_server(dispatchers, project)
  local closing = false
  local request_id = 0
  local server = {}

  function server.request(method, params, callback)
    if method == "initialize" then
      callback(nil, {
        capabilities = {
          completionProvider = { triggerCharacters = { "\"", "'", " ", "-" } },
          definitionProvider = true,
          positionEncoding = "utf-16",
          textDocumentSync = { openClose = true, change = 1 },
        },
        serverInfo = { name = "Project CSS classes" },
      })
    elseif method == "textDocument/completion" then
      local items = {}
      local edit_start = completion_context(params)
      if edit_start then
        for _, name in ipairs(project.names) do
          items[#items + 1] = {
            label = name,
            kind = vim.lsp.protocol.CompletionItemKind.Class,
            detail = project.details[name],
            textEdit = {
              newText = name,
              range = {
                start = { line = params.position.line, character = edit_start },
                ["end"] = params.position,
              },
            },
          }
        end
      end
      callback(nil, { isIncomplete = false, items = items })
    elseif method == "textDocument/definition" then
      local locations = {}
      local name = class_at_position(params)
      for _, path in ipairs(name and project.classes[name] or {}) do
        local ok, content = pcall(vim.fn.readfile, path)
        if ok then
          for _, range in ipairs(M.definition_ranges(table.concat(content, "\n"), name)) do
            locations[#locations + 1] = { uri = vim.uri_from_fname(path), range = range }
          end
        end
      end
      callback(nil, locations)
    elseif method == "shutdown" then
      callback(nil, nil)
    else
      callback({ code = -32601, message = "Method not found" }, nil)
    end

    request_id = request_id + 1
    return true, request_id
  end

  function server.notify(method)
    if method == "exit" then dispatchers.on_exit(0, 15) end
  end

  function server.is_closing()
    return closing
  end

  function server.terminate()
    closing = true
  end

  return server
end

local function start(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then return end

  local root = require("project").root(path)
  if not root then return end
  local project = projects[root] or M.index(root)

  vim.lsp.start({
    name = "css_classes",
    cmd = function(dispatchers) return create_server(dispatchers, project) end,
    root_dir = root,
  }, { bufnr = bufnr })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("DotfilesCssClasses", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "html", "eruby" },
    callback = function(ev) start(ev.buf) end,
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = { "*.css", "*.scss", "*.sass" },
    callback = function(ev)
      local path = vim.api.nvim_buf_get_name(ev.buf)
      local root = require("project").root(path)
      local project = root and projects[root] or nil
      if not project then return end

      project.files[path] = read_classes(path)
      rebuild(project)
    end,
  })
end

return M
