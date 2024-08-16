
local config = require("nvim-gitsessions.config")
local sessions = require("nvim-gitsessions.sessions")

local command = vim.api.nvim_create_user_command

local M = {
    config = config,
    sessions = sessions,
}

---@param options? NGsessions.UserConfig
function M.setup(options)
    if options then
        M.config.setup(options)
    end
    M.sessions.set_path(M.config.path)

    if vim.fn.isdirectory(M.config.path) == 0 then
        vim.fn.mkdir(M.config.path, "p")
    end

    if not config.manual then
    end

    command("NvimGitSessionsSave", M.sessions.save, { nargs = 0 })
    command("NvimGitSessionsLoad", M.sessions.load, { nargs = 0 })
end

return M

