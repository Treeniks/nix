local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Help Tags' })

require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ["<C-d>"] = actions.delete_buffer,
                -- also mapped to C-c by default
                ["<C-esc>"] = "close",
            }
        }
    }
})
