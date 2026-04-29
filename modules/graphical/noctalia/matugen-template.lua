-- primary
-- {{colors.primary.default.hex}} primary
-- {{colors.on_primary.default.hex}} on_primary
-- {{colors.primary_container.default.hex}} primary_container
-- {{colors.on_primary_container.default.hex}} on_primary_container
-- {{colors.primary_fixed.default.hex}} primary_fixed
-- {{colors.primary_fixed_dim.default.hex}} primary_fixed_dim
-- {{colors.on_primary_fixed.default.hex}} on_primary_fixed
-- {{colors.on_primary_fixed_variant.default.hex}} on_primary_fixed_variant
--
-- secondary
-- {{colors.secondary.default.hex}} secondary
-- {{colors.on_secondary.default.hex}} on_secondary
-- {{colors.secondary_container.default.hex}} secondary_container
-- {{colors.on_secondary_container.default.hex}} on_secondary_container
-- {{colors.secondary_fixed.default.hex}} secondary_fixed
-- {{colors.secondary_fixed_dim.default.hex}} secondary_fixed_dim
-- {{colors.on_secondary_fixed.default.hex}} on_secondary_fixed
-- {{colors.on_secondary_fixed_variant.default.hex}} on_secondary_fixed_variant
--
-- teritary
-- {{colors.tertiary.default.hex}} tertiary
-- {{colors.on_tertiary.default.hex}} on_tertiary
-- {{colors.tertiary_container.default.hex}} tertiary_container
-- {{colors.on_tertiary_container.default.hex}} on_tertiary_container
-- {{colors.tertiary_fixed.default.hex}} tertiary_fixed
-- {{colors.tertiary_fixed_dim.default.hex}} tertiary_fixed_dim
-- {{colors.on_tertiary_fixed.default.hex}} on_tertiary_fixed
-- {{colors.on_tertiary_fixed_variant.default.hex}} on_tertiary_fixed_variant
--
-- error
-- {{colors.error.default.hex}} error
-- {{colors.on_error.default.hex}} on_error
-- {{colors.error_container.default.hex}} error_container
-- {{colors.on_error_container.default.hex}} on_error_container
--
-- surface
-- {{colors.surface.default.hex}} surface
-- {{colors.on_surface.default.hex}} on_surface
-- {{colors.surface_variant.default.hex}} surface_variant
-- {{colors.on_surface_variant.default.hex}} on_surface_variant
-- {{colors.surface_dim.default.hex}} surface_dim
-- {{colors.surface_bright.default.hex}} surface_bright
-- {{colors.surface_container_lowest.default.hex}} surface_container_lowest
-- {{colors.surface_container_low.default.hex}} surface_container_low
-- {{colors.surface_container.default.hex}} surface_container
-- {{colors.surface_container_high.default.hex}} surface_container_high
-- {{colors.surface_container_highest.default.hex}} surface_container_highest
--
-- outline & utilities
-- {{colors.outline.default.hex}} outline
-- {{colors.outline_variant.default.hex}} outline_variant
-- {{colors.shadow.default.hex}} shadow
-- {{colors.scrim.default.hex}} scrim
--
-- inverse
-- {{colors.inverse_surface.default.hex}} inverse_surface
-- {{colors.inverse_on_surface.default.hex}} inverse_on_surface
-- {{colors.inverse_primary.default.hex}} inverse_primary
--
-- background
-- {{colors.background.default.hex}} background
-- {{colors.on_background.default.hex}} on_background

local config = {
    integrations = {
        telescope = { enabled = true },
        mini = { enabled = true },
        blink_cmp = true,
    },

    -- I set noctalia to the builtin catppuccin and tried to match the colors it outputs
    -- to the palette of catppuccin/nvim mocha palette
    --
    -- V means it is a perfect match
    -- X means it is not a perfect match
    color_overrides = {
        mocha = {
            rosewater = "{{colors.secondary_fixed.default.hex}}",     -- X
            flamingo  = "{{colors.secondary_fixed.default.hex}}",     -- X
            pink      = "{{colors.primary_fixed.default.hex}}",       -- X
            mauve     = "{{colors.primary.default.hex}}",             -- V
            red       = "{{colors.error.default.hex}}",               -- V
            maroon    = "{{colors.secondary_fixed_dim.default.hex}}", -- X
            peach     = "{{colors.secondary.default.hex}}",           -- V
            yellow    = "{{colors.secondary_fixed.default.hex}}",     -- X
            green     = "{{colors.tertiary.default.hex}}",            -- X
            teal      = "{{colors.tertiary.default.hex}}",            -- V
            sky       = "{{colors.tertiary_fixed.default.hex}}",      -- X
            sapphire  = "{{colors.tertiary_fixed_dim.default.hex}}",  -- X
            blue      = "{{colors.on_surface_variant.default.hex}}",  -- X
            lavender  = "{{colors.primary_fixed.default.hex}}",       -- X

            text      = "{{colors.on_surface.default.hex}}",          -- V

            subtext1  = "{{colors.on_surface.default.hex}}",          -- X
            subtext0  = "{{colors.on_surface.default.hex}}",          -- X

            overlay2  = "{{colors.outline.default.hex}}",             -- X
            overlay1  = "{{colors.outline.default.hex}}",
            overlay0  = "{{colors.outline_variant.default.hex}}",

            surface2  = "{{colors.surface_bright.default.hex}}",            -- X
            surface1  = "{{colors.surface_container_highest.default.hex}}", -- X
            surface0  = "{{colors.surface_container.default.hex}}",         -- V

            base      = "{{colors.surface.default.hex}}",                   -- V
            mantle    = "{{colors.surface_dim.default.hex}}",               -- X
            crust     = "{{colors.shadow.default.hex}}",                    -- V
        },

    },
}

require('catppuccin').setup(config)

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
    vim.uv.constants.SIGUSR1,
    vim.schedule_wrap(function()
        package.loaded['plugins.catppuccin-matugen'] = nil
        require('plugins.catppuccin-matugen')
        if vim.g.colors_name == 'catppuccin-mocha' then
            vim.cmd.colorscheme('catppuccin-mocha')
        end
    end)
)
