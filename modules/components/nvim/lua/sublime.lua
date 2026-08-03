local function git_rel_path()
    local file = vim.fn.expand('%:p')
    local file_dir = vim.fn.expand('%:p:h')
    local file_name = vim.fn.expand('%:t')

    if vim.fn.filereadable(file) == 0 then
        vim.notify('Buffer has no file', vim.log.levels.WARN)
        return
    end

    local rel_file_dir = vim.fn.systemlist({ 'git', '-C', file_dir, 'rev-parse', '--show-prefix' })[1]

    if vim.v.shell_error ~= 0 then
        vim.notify('Not inside a git repository', vim.log.levels.WARN)
        return
    end

    -- if we're in a file at the root of the git repo, rel_file_dir would be nil
    rel_file_dir = rel_file_dir or ''

    return rel_file_dir .. file_name
end

local function smerge_file_history()
    vim.system({ 'sublime_merge', '.' })

    local rel_path = git_rel_path()
    if rel_path == nil then return end

    vim.system({ 'sublime_merge', 'log', rel_path })
end

local function smerge_line_history()
    vim.system({ 'sublime_merge', '.' })

    local line_start = vim.fn.line(".")
    local line_end = vim.fn.line("v")

    local rel_path = git_rel_path()
    if rel_path == nil then return end

    local query = string.format('file:"%s" line:%d-%d', rel_path, line_start, line_end)
    vim.system({ 'sublime_merge', 'search', query })
end

vim.keymap.set({ 'n', 'v' }, '<leader>gf', smerge_file_history, { desc = 'SMerge File History' })
vim.keymap.set({ 'n', 'v' }, '<leader>gl', smerge_line_history, { desc = 'SMerge Line History' })
