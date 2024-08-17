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
    manual = true,
    path = vim.fn.stdpath("data") .. "/nvim-gitsessions",
}
local config = vim.deepcopy(default_confg)

local M = {}

function M.setup(user_config)
    config = vim.tbl_deep_extend("force", default_confg, user_config)
end

--- @type NGsessions.config.Config
setmetatable(M, {
  __index = function(_, k)
    return config[k]
  end
})

return M
