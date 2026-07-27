-- see `:help map-modes` for the list of modes
local all_modes = { 'n', 'i', 'c', 'x', 's', 'o', 't' }

vim.filetype.add({
    extension = { styx = "styx" },
})

-- ===== opt =====
-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- indents
vim.opt.tabstop = 4     -- overwritten for some filetypes

vim.opt.softtabstop = 0 -- 0 means "use tabstop"
vim.opt.shiftwidth = 0
vim.opt.expandtab = true

-- wordwrap settings
-- vim.opt.wrap = true/false -- filetype specific
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = 'sbr'
vim.opt.showbreak = ' '

-- search
vim.opt.incsearch = true
vim.opt.ignorecase = true -- unsure

vim.opt.termguicolors = true

vim.opt.scrolloff = 1
vim.opt.signcolumn = 'yes' -- or 'number'

-- whitespace visuals
vim.opt.list = true
vim.opt.listchars:append({
    tab = '>-',
    trail = '⋅',
})

vim.opt.undofile = true

vim.opt.winborder = 'rounded'

-- ===============

vim.g.mapleader = ' '

vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', vim.cmd.write, { desc = 'Save' })
vim.keymap.set('i', '<C-v>', '<C-r>+')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')

vim.keymap.set('', '<C-d>', '10jzz')
vim.keymap.set('', '<C-u>', '10kzz')
vim.keymap.set('', '<C-f>', '10j')
vim.keymap.set('', '<C-b>', '10k')

vim.keymap.set('n', '<ESC>', vim.cmd.nohlsearch)

vim.keymap.set('n', '<leader>n', vim.cmd.tabnew, { desc = 'New Tab' })
vim.keymap.set('n', '<leader>q', vim.cmd.tabclose, { desc = 'Close Tab' })
vim.keymap.set('n', '<leader>j', vim.cmd.tabnext, { desc = 'Next Tab' })
vim.keymap.set('n', '<leader>k', vim.cmd.tabprev, { desc = 'Prev Tab' })
vim.keymap.set('n', '<leader>J', function() vim.cmd.tabmove('-1') end, { desc = 'Move Tab Left' })
vim.keymap.set('n', '<leader>K', function() vim.cmd.tabmove('+1') end, { desc = 'Move Tab Right' })

-- this one is different to <leader>n above, because it starts the new tab in terminal mode
vim.keymap.set(
    all_modes,
    '<C-S-T>',
    function()
        vim.schedule(function()
            vim.cmd('terminal')
            vim.cmd('startinsert')
        end)
    end,
    { desc = 'New Tab' }
)
vim.keymap.set(all_modes, '<C-S-W>', vim.cmd.tabclose, { desc = 'Close Tab' })
vim.keymap.set(all_modes, '<C-Tab>', vim.cmd.tabnext, { desc = 'Next Tab' })
vim.keymap.set(all_modes, '<C-S-Tab>', vim.cmd.tabprev, { desc = 'Prev Tab' })
vim.keymap.set(all_modes, '<C-<>', function() vim.cmd.tabmove('-1') end, { desc = 'Move Tab Left' })
vim.keymap.set(all_modes, '<C->>', function() vim.cmd.tabmove('+1') end, { desc = 'Move Tab Right' })

-- normal mode alt keybind
-- particularly useful when in term mode
vim.keymap.set(all_modes, '<C-\'>', '<C-\\><C-n>')

-- ===== Neovide =====
-- cannot be JetBrains Mono at the time of writing for some reason, as that makes Neovide segfault...
vim.opt.guifont = 'JetBrainsMono Nerd Font:h14'
vim.g.neovide_opacity = 0.95
vim.g.neovide_refresh_rate = 300

-- cursor settings
vim.g.neovide_cursor_trail_size = 0.1
vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_cursor_short_animation_length = 0.025

vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Make neovide a terminal emulator',
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

require('plugins')
require('lsp')
require('treesitter')
require('terminal')
