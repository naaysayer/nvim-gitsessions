local git = require("nvim-gitsessions.git")

local M = {
    path = nil
}

local ignore_session = false

function M.set_path(path)
    M.path = path
end

function M.get_sessionfilename()
    return (M.path .. "/" .. git.repo_name() .. "/" .. git.get_branch() .. ".vim"):gsub("\n", "")
end

local function session_exist(session_filename)
    return vim.fn.filereadable(session_filename) == 1
end

function M.save()
    if not git.is_git_repo() then
        return
    end

    local projectdir = M.path .. "/" .. git.repo_name()
    if vim.fn.isdirectory(projectdir) == 0 then
        vim.fn.mkdir(projectdir, "p")
    end

    local sessionfile = projectdir .. "/" .. git.get_branch() .. ".vim"
    vim.cmd("mksession! " .. sessionfile)
end

function M.load()
    local sessionfile = M.get_sessionfilename()
    if session_exist(sessionfile) then
        vim.cmd("source " .. sessionfile)
    end
end

local function auto_save()
    -- check if buffer git COMMIT_MSG
    if vim.bo.filetype == "gitcommit" or ignore_session then
        return
    end
    M.save()
end

local function auto_load()
    -- todo: check if vim opened with file specified in session
    if vim.fn.argc() ~= 0 then
        if session_exist(M.get_sessionfilename()) then
            ignore_session = true
        end
        return
    end
    M.load()
end

function M.autocmd_init()
    local group = vim.api.nvim_create_augroup("nvim_gitsessions", { clear = true })

    vim.api.nvim_create_autocmd({ "UILeave" }, { callback = auto_save, group = group, })
    vim.api.nvim_create_autocmd("UIEnter", { callback = auto_load, group = group, nested = true, once = true })
end

function M.explore()
    vim.cmd("Hexplore! " .. M.path)
end


return M
