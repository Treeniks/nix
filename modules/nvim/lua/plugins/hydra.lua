local hydra = require('hydra')

hydra.setup({})

hydra({
    name = 'Window resizing',
    mode = 'n',
    body = '<C-w>',
    config = {},
    heads = {
        { '-', '<C-w>-', { desc = 'Decrease height' } },
        { '+', '<C-w>+', { desc = 'Increase height' } },

        { '<', '<C-w><', { desc = 'Decrease width' } },
        { '>', '<C-w>>', { desc = 'Increase width' } },
    },
})

-- this keybind replaces one of the rotate keybinds
-- but that's ok
hydra({
    name = 'Window resizing',
    mode = 'n',
    body = '<C-w>r',
    config = {
        invoke_on_body = true,
        desc = 'Window resizing',
    },
    heads = {
        -- these are mapped to work best on a window in the top right
        { 'h', '5<C-w>>' },
        { 'j', '5<C-w>+' },
        { 'k', '5<C-w>-' },
        { 'l', '5<C-w><' },
    },
})
