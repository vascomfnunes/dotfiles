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

function M.parse(text)
  local classes = {}
  local ok, parser = pcall(vim.treesitter.get_string_parser, text, "css")
  if ok then
    class_query = class_query or vim.treesitter.query.parse("css", "(class_selector (class_name) @class)")
    local tree = parser:parse()[1]
    for _, node in class_query:iter_captures(tree:root(), text, 0, -1) do
      classes[vim.treesitter.get_node_text(node, text)] = true
    end
  else
    -- Keep completions working before the CSS parser has been installed. This
    -- intentionally handles only conventional class selectors.
    local selectors = text:gsub("/%*.-%*/", "")
    for selector in selectors:gmatch("([^{}]+){") do
      for name in selector:gmatch("%.([%a_%-][%w_%-]*)") do
        classes[name] = true
      end
    end
  end
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
end

function M.index(root)
  local project = { root = root, files = {}, classes = {}, names = {} }
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

local function completion_context(params)
  local bufnr = vim.uri_to_bufnr(params.textDocument.uri)
  if not vim.api.nvim_buf_is_valid(bufnr) then return nil end

  local position = params.position
  local start_line = math.max(0, position.line - 20)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, position.line + 1, false)
  local current = lines[#lines] or ""
  local byte_col = vim.str_byteindex(current, "utf-16", position.character, false)
  lines[#lines] = current:sub(1, byte_col)
  if not M.is_completion_context(table.concat(lines, "\n")) then return nil end

  local fragment = lines[#lines]:match("([%w_-]*)$") or ""
  return position.character - #fragment
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
          local sources = vim.tbl_map(function(path)
            return vim.fs.relpath(project.root, path) or path
          end, project.classes[name])
          items[#items + 1] = {
            label = name,
            kind = vim.lsp.protocol.CompletionItemKind.Class,
            detail = table.concat(sources, ", "),
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
