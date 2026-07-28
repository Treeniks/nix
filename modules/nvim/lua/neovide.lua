local all_modes = require('utils').all_modes

-- this file sets up Neovide as a terminal emulator, so I can live 24/7 in NeoVim

-- cannot be JetBrains Mono at the time of writing for some reason, as that makes Neovide segfault...
vim.opt.guifont = 'Maple Mono:h14'
vim.g.neovide_opacity = 0.95
vim.g.neovide_refresh_rate = 300

-- cursor settings
vim.g.neovide_cursor_trail_size = 0.1
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_short_animation_length = 0.025

-- we can have these settings, even if we're not in neovide, because kitty takes priority
--
-- this one is different to <leader>n, because it starts the new tab in terminal mode
vim.keymap.set(
    all_modes,
    '<C-S-t>',
    function()
        vim.cmd('tabnew')
        vim.cmd('terminal')
        vim.cmd('startinsert')
    end,
    { desc = 'New Tab' }
)
vim.keymap.set(
    all_modes,
    '<C-S-w>',
    function()
        -- close the current window
        -- but close the tab if it's the last window
        -- but close neovim if it's the last tab
        --
        -- this mimics kitty's behavior
        local current_tab = vim.api.nvim_get_current_tabpage()
        local wins = vim.api.nvim_tabpage_list_wins(current_tab)
        local tabs = vim.api.nvim_list_tabpages()

        if #wins > 1 then
            vim.cmd.wincmd('c')
        elseif #tabs > 1 then
            vim.cmd.tabclose()
        else
            vim.cmd('qa!')
        end
    end,
    { desc = 'Close Tab' }
)
vim.keymap.set(all_modes, '<C-Tab>', vim.cmd.tabnext, { desc = 'Next Tab' })
vim.keymap.set(all_modes, '<C-S-Tab>', vim.cmd.tabprev, { desc = 'Prev Tab' })
-- wrapped in pcall because it fails if the tab is the first/last
vim.keymap.set(all_modes, '<C-<>', function() pcall(vim.cmd.tabmove, '-1') end, { desc = 'Move Tab Left' })
vim.keymap.set(all_modes, '<C->>', function() pcall(vim.cmd.tabmove, '+1') end, { desc = 'Move Tab Right' })

vim.keymap.set(all_modes, '<C-:>', function() vim.cmd.wincmd('W') end, { desc = 'Focus Previous Window' })
vim.keymap.set(all_modes, '<C-">', function() vim.cmd.wincmd('w') end, { desc = 'Focus Next Window' })
vim.keymap.set(
    all_modes,
    '<C-S-CR>',
    function()
        -- TODO this should become more of a grid layout thing,
        -- but I probably don't use it often enough for that anyway
        vim.cmd('rightbelow vsplit')
        vim.cmd('terminal')
        vim.cmd('startinsert')
    end,
    { desc = 'Open Terminal Split' }
)

vim.keymap.set(
    all_modes,
    '<C-t>',
    function()
        vim.cmd('terminal')
        vim.cmd('startinsert')
    end,
    { desc = 'Open Terminal' }
)

-- https://github.com/neovide/neovide/discussions/2301#discussioncomment-8223203
if vim.g.neovide then
    vim.keymap.set(
        all_modes,
        '<C-+>',
        function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1 end
    )
    vim.keymap.set(
        all_modes,
        '<C-_>',
        function() vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1 end
    )
    vim.keymap.set(
        all_modes,
        '<C-)>',
        function() vim.g.neovide_scale_factor = 1 end
    )
end

vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Make neovide a terminal emulator, by opening into terminal mode by default.',
    once = true,
    callback = function(_)
        if vim.g.neovide and vim.fn.argc() == 0 then
            vim.schedule(function()
                vim.cmd('terminal')
                vim.cmd('startinsert')
            end)
        end
    end,
})

vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        if vim.bo.buftype == 'terminal' then
            -- we don't want to use schedule here, or we get put into insert mode
            -- when opening a file with telescope while a terminal is open
            vim.cmd('startinsert')
        end
    end
})
