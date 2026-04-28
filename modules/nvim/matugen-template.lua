require('catppuccin').setup {
    integrations = {
        telescope = { enabled = true },
        mini = { enabled = true },
        blink_cmp = true,
    },

    color_overrides = {
        all = {
            rosewater = "{{colors.primary.default.hex}}",
            flamingo  = "{{colors.secondary.default.hex}}",
            pink      = "{{colors.tertiary.default.hex}}",

            mauve     = "{{colors.primary_fixed.default.hex}}",
            red       = "{{colors.secondary_fixed.default.hex}}",
            maroon    = "{{colors.tertiary_fixed.default.hex}}",

            peach     = "{{colors.primary_fixed_dim.default.hex}}",
            yellow    = "{{colors.secondary_fixed_dim.default.hex}}",
            green     = "{{colors.tertiary_fixed_dim.default.hex}}",

            teal      = "{{colors.primary.default.hex}}",
            sky       = "{{colors.secondary.default.hex}}",
            sapphire  = "{{colors.tertiary.default.hex}}",

            blue      = "{{colors.primary_fixed.default.hex}}",
            lavender  = "{{colors.secondary_fixed.default.hex}}",

            text      = "{{colors.on_surface.default.hex}}",

            subtext1  = "{{colors.on_surface_variant.default.hex}}",
            subtext0  = "{{colors.on_surface_variant.default.hex}}",

            overlay1  = "{{colors.surface_container_lowest.default.hex}}",
            overlay0  = "{{colors.surface_container_low.default.hex}}",
            surface2  = "{{colors.surface_container.default.hex}}",
            surface1  = "{{colors.surface_container_high.default.hex}}",    -- selection
            surface0  = "{{colors.surface_container_highest.default.hex}}", -- line in mini.files

            base      = "{{colors.surface.default.hex}}",
            mantle    = "{{colors.surface_dim.default.hex}}",
            crust     = "{{colors.surface_variant.default.hex}}",
        },
    },
}

-- Register a signal handler for SIGUSR1 (matugen updates)
-- TODO doesn't work and I don't think I care enough to fix it
--
-- local signal = vim.uv.new_signal()
-- if signal then
--     signal:start(
--         vim.uv.constants.SIGUSR1,
--         vim.schedule_wrap(function()
--             package.loaded['plugins.catppuccin-matugen'] = nil
--             require('plugins.catppuccin-matugen')
--         end)
--     )
-- end
