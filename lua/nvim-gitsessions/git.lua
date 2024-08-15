local M = {}

function M.get_branch()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
    return branch
end

function M.get_git_root()
    local git_root = vim.fn.system("git rev-parse --show-toplevel")
    return git_root
end

function M.is_git_repo()
    local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree")
    return is_git_repo
end

function M.repo_name()
    local root = M.get_git_root()
    local repo_name = vim.fn.system("basename " .. root)
    return repo_name
end

return M
