require('plugins.catppuccin')
require('plugins.mini')
require('plugins.telescope')

require('nvim-surround').setup({})

-- the noctalia matugen setup is only there if we use the hot reload neovim package
-- in standalone, the module never gets generated
-- so we wrap it in pcall so we don't fail if it's not there
local ok, _ = pcall(require, 'plugins.catppuccin-matugen')
if not ok then
    -- and use normal catppuccin as fallback
    require('plugins.catppuccin')
end
