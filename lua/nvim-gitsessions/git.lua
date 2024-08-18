local M = {}

local function cmd_output(s)
    local output = vim.fn.system(s)
    return output:gsub("\n", "")
end

function M.get_branch()
    local branch = cmd_output("git rev-parse --abbrev-ref HEAD")
    return branch
end

function M.get_git_root()
    local git_root = cmd_output("git rev-parse --show-toplevel")
    return git_root
end

function M.is_git_repo()
    local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
end

function M.repo_name()
    local root = M.get_git_root()
    return root:match("^.+/(.+)$") or root
end

return M
