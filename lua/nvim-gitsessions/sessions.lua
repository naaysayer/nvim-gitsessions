local git = require("nvim-gitsessions.git")

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
        return
    end

    local sessionfile = M.get_sessionfilename()

    vim.cmd("mksession! " .. sessionfile)
end

function M.load()
    if not git.is_git_repo() then
        return
    end

    if vim.fn.isdirectory(M.path) then
        local sessionfile = M.get_sessionfilename()
        if vim.fn.filereadable(sessionfile) == 1 then
            vim.cmd("source " .. sessionfile)
        else
        end
    end
end

function M.list()
    local project = git.repo_name()
    local sessions = {}

    if not vim.fn.isdirectory(M.path) then
        return nil
    end

    for _, file in ipairs(vim.fn.readdir(M.path)) do
        if string.find(file, M.path .. "/" .. project .. "-") then
            table.insert(sessions, string.sub(file, 1, string.len(project) + 1))
        end
    end
    return sessions
end

local function auto_save()
    -- check if buffer git COMMIT_MSG
    if vim.bo.filetype == "gitcommit" then
        return
    end
    M.save()
end

local function auto_load()
    -- todo: check if vim opened with file specified in session
    if vim.fn.argc() ~= 0 then
        return
    end
    M.load()
end

function M.autocmd_init()
    local group = vim.api.nvim_create_augroup("nvim_gitsessions", { clear = true })

    vim.api.nvim_create_autocmd({ "UILeave" }, { callback = auto_save, group = group, })
    vim.api.nvim_create_autocmd("UIEnter", { callback = auto_load, group = group, nested = true, once = true })
end

return M
