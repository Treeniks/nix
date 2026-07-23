require('catppuccin').setup({
    dim_inactive = {
        enabled = true,
    },
    integrations = {
        telescope = { enabled = true },
        mini = { enabled = true },
        blink_cmp = true,
    },
    -- neovide :term mode colors
    -- https://github.com/neovide/neovide/issues/2050#issuecomment-2993699739
    term_colors = true,

    -- sometimes fun in neovide
    -- transparent_background = true,
})
