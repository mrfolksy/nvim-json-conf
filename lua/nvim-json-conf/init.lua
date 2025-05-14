local cfg = require("nvim-json-conf.config")

local M = {
  _cache = nil,
}

function M.setup()
  M._cache = cfg.load()
end

function M.get()
  if not M._cache then
    M._cache = cfg.load()
  end
  return M._cache
end

return M
