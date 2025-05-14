local uv = vim.loop
local json = vim.json
local util = require("lspconfig.util")

local M = {}

function M.find_root()
  return util.root_pattern(".nvimconf.json")(vim.fn.getcwd())
end

function M.load()
  local root = M.find_root()
  if not root then
    return {}
  end

  local path = root .. "/.nvimconf.json"
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
