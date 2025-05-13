local uv = vim.loop
local json = vim.json
local util = require("lspconfig.util")

local M = {}

-- Find the nearest ancestor dir containing .nvimrc.json
function M.find_root()
  return util.root_pattern(".nvimrc.json")(vim.fn.getcwd())
end

-- Load and decode .nvimrc.json into a Lua table (or {} on failure)
function M.load()
  local root = M.find_root()
  if not root then
    return {}
  end

  local path = root .. "/.nvimrc.json"
  if uv.fs_stat(path) == nil then
    return {}
  end

  local data = vim.fn.readfile(path)
  local ok, tbl = pcall(json.decode, table.concat(data, "\n"))
  if not ok then
    vim.notify("projectconfig: invalid JSON in " .. path, vim.log.levels.ERROR)
    return {}
  end

  return tbl
end

return M
