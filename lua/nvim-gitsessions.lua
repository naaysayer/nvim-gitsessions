
local config = require("nvim-gitsessions.config")
local git = require("nvim-gitsessions.git")

local command = vim.api.nvim_create_user_command

local M = {
    config = config,
}

local function get_sessionfilename()
    return (M.config.path .. "/" .. git.repo_name() .. "-" .. git.get_branch() .. ".vim"):gsub("\n", "")
end

function M.save()
    if not git.is_git_repo() then
        print("Not a git repository")
        return
    end

    local sessionfile = get_sessionfilename()
    print("Saving session to " .. sessionfile)
    vim.cmd("mksession! " .. sessionfile)
end

function M.load()
    if not git.is_git_repo() then
        print("Not a git repository")
        return
    end
    if vim.fn.isdirectory(M.config.path) then
        local sessionfile = get_sessionfilename()
        if vim.fn.filereadable(sessionfile) == 1 then
            print("Loading session from " .. sessionfile)
            vim.cmd("source " .. sessionfile)
        else
            print("Session file not found")
        end
    else
        print("Path does not exist")
    end
end

function M.list()
    local project = git.repo_name()
    local sessions = {}

    if not vim.fn.isdirectory(M.config.path) then
        print("Path does not exist")
        return nil
    end

    for _, file in ipairs(vim.fn.readdir(M.config.path)) do
        if string.find(file, M.config.path .. "/" .. project .. "-") then
            table.insert(sessions, string.sub(file, 1, string.len(project) + 1))
        end
    end
    print(sessions)
end

---@param options? NGsessions.UserConfig
function M.setup(options)
    if options then
        M.config.setup(options)
    end

    if vim.fn.isdirectory(M.config.path) == 0 then
        vim.fn.mkdir(M.config.path, "p")
    end

    if not config.manual then
        local agroup = vim.api.nvim_create_augroup("nvim_gitsessions", { clear = true })
        vim.api.nvim_create_autocmd({ "VimLeave" }, {
            callback = function()
                M.save()
            end,
            group = agroup,
        })
        vim.api.nvim_create_autocmd({ "VimEnter" }, {
            callback = function()
                M.load()
            end,
            group = agroup,
        })
    end

    command("NvimGitSessionsSave", M.save, { nargs = 0 })
    command("NvimGitSessionsLoad", M.load, { nargs = 0 })
    command("NvimGitSessionsList", M.list, { nargs = 0 })
end

return M

