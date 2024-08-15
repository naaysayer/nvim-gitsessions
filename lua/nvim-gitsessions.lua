
local config = require("nvim-gitsessions.config")

local command = vim.api.nvim_create_user_command

local M = {
    config = config,
}

function M.hello()
    print("hello from nvim-gitsessions")
end

---@param options? NGsessions.UserConfig
function M.setup(options)
    if options then
        config.setup(options)
    end
    command("NvimGitSessionsHello", M.hello, {})
end

return M

