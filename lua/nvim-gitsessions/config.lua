--- @class NGsessions.config
--- @field manual boolean
--- @field path string

--- @class NGsessions.UserConfig : NGsessions.config
---
--- Save/Load sessions manually, instead of using VimLeave and VimEnter events
--- @field manual boolean
---
--- Path to save/load session files
--- @field path string

--- @type NGsessions.config
local default_confg = {
    manual = false,
    path = vim.fn.stdpath("data") .. "/sessions",
}
local config = vim.deepcopy(default_confg)

local M = {}

function M.setup(user_config)
    local config = vim.tbl_deep_extend("force", config, user_config)
    vim.g.sessions_path = config.path
    vim.g.sessions_manual = config.manual
end

--- @type NGsessions.config.Config
setmetatable(M, {
  __index = function(_, k)
    return config[k]
  end
})

return M
