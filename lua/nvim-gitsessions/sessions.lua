local git = require("nvim-gitsessions.git")
local autocommand = vim.api.nvim_create_user_command

local M = {
    path = nil
}

function M.set_path(path)
    M.path = path
end

function M.get_sessionfilename()
    return (M.path .. "/" .. git.repo_name() .. "-" .. git.get_branch() .. ".vim"):gsub("\n", "")
end

function M.save()
    if not git.is_git_repo() then
        print("Not a git repository")
        return
    end

    local sessionfile = M.get_sessionfilename()
    print("Saving session to " .. sessionfile)
    vim.cmd("mksession! " .. sessionfile)
end

function M.load()
    if not git.is_git_repo() then
        print("Not a git repository")
        return
    end
    if vim.fn.isdirectory(M.path) then
        local sessionfile = M.get_sessionfilename()
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

    if not vim.fn.isdirectory(M.path) then
        print("Path does not exist")
        return nil
    end

    for _, file in ipairs(vim.fn.readdir(M.path)) do
        if string.find(file, M.path .. "/" .. project .. "-") then
            table.insert(sessions, string.sub(file, 1, string.len(project) + 1))
        end
    end
    print(sessions)
end

local function auto_save()
    -- check if buffer git COMMIT_MSG
    if vim.bo.filetype == "gitcommit" then
        return
    end
    M.sessions.save()
end

local function auto_load()
    -- check if vim opened with file specified in session
    if vim.fn.argc() > 0 then
        return
    end
    M.sessions.load()
end

function M.autocmd_init()
        local agroup = vim.api.nvim_create_augroup("nvim_gitsessions", { clear = true })

        vim.api.nvim_create_autocmd({ "VimLeave" }, { callback = auto_save, group = agroup, })
        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = auto_load, group = agroup, })
end

return M
