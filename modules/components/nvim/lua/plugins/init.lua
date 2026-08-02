require('plugins.catppuccin')
require('plugins.hydra')
require('plugins.mini')
require('plugins.telescope')

require('nvim-surround').setup({})

require('oil').setup({
    view_options = { show_hidden = true },
    float = {
        preview_split = 'right',
    },
})
-- vim.keymap.set(require('utils').all_modes, '<C-y>', function() vim.cmd(':Oil') end)
-- vim.keymap.set(require('utils').all_modes, '<C-y>', function() vim.cmd(':Yazi') end)

vim.keymap.set('n', '<leader>gg', function() vim.cmd(':Neogit') end, { desc = 'Neogit' })

---- builtins
vim.cmd.packadd('nvim.undotree')
