local cfg = require("nvim-json-conf.config")

local M = {
  _cache = nil,
}

-- Call this once at startup (or on DirChanged) to prime the cache
function M.setup()
  M._cache = cfg.load()
end

-- Fetch the latest config (reloads if not primed)
function M.get()
  if not M._cache then
    M._cache = cfg.load()
  end
  return M._cache
end

return M
