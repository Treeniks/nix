local osc7_sequence = '\x1b\x5d\x37\x3b'

vim.api.nvim_create_autocmd('TermRequest', {
    desc = 'Sync nvim cwd with shell cwd via OSC 7',
    -- allow triggering other autocmds
    -- in particular 'DirChanged' for direnv
    nested = true,
    callback = function(event)
        if string.sub(event.data.sequence, 1, 4) == osc7_sequence then
            -- remove the OSC 7 sequence
            local dir = string.gsub(event.data.sequence, osc7_sequence, '')
            -- NOTE this doesn't cover kitty's own OSC 7 message,
            -- so this stops working while inside a kitty terminal
            dir = vim.uri_to_fname(dir)
            -- remove the hostname
            dir = string.gsub(dir, '^/[^/]*', '')

            if vim.fn.isdirectory(dir) == 0 then return end

            vim.api.nvim_buf_set_var(event.buf, 'last_osc7_payload', dir)
            if vim.api.nvim_get_current_buf() == event.buf then
                vim.cmd.tcd(dir)
            end
        end
    end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'DirChanged' }, {
    callback = function(_)
        if vim.b.last_osc7_payload ~= nil
            and vim.fn.isdirectory(vim.b.last_osc7_payload) == 1
        then
            vim.cmd.tcd(vim.b.last_osc7_payload)
        end
    end
})
