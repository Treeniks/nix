-- Text Editing

-- several additional a/i text objects
require('mini.ai').setup({})

-- `gc` and `gcc`
require('mini.comment').setup({})

-- `M` + `h|j|k|l` to move visual selection
require('mini.move').setup({})

-- `gx` for exchange
-- `gm` for multiply
-- `gr` for replace
-- `gs` for sort
-- and a few more that I never use
require('mini.operators').setup({})

require('mini.pairs').setup({})
-- remove these as they cause issues more often than not
MiniPairs.unmap('i', '"', '""')
MiniPairs.unmap('i', "'", "''")
MiniPairs.unmap('i', '`', '``')

-- `gS`
require('mini.splitjoin').setup({})

-- I prefer nvim-surround
-- require('mini.surround').setup({})

-- General Workflow

-- `[` and `]` prefixed keybinds
-- rarely used
require('mini.bracketed').setup({})

local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        -- Leader triggers
        { mode = { 'n', 'x' }, keys = '<leader>' },

        -- `[` and `]` keys
        { mode = 'n',          keys = '[' },
        { mode = 'n',          keys = ']' },

        -- Built-in completion
        { mode = 'i',          keys = '<C-x>' },

        -- `g` key
        { mode = { 'n', 'x' }, keys = 'g' },

        -- Marks
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },

        -- Registers
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },

        -- Window commands
        { mode = 'n',          keys = '<C-w>' },

        -- `z` key
        { mode = { 'n', 'x' }, keys = 'z' },
    },

    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },

    window = {
        delay = 0,
    },
})

require('mini.cmdline').setup({})

-- TODO figure out what this does
-- require('mini.diff').setup({})

require('mini.files').setup({
    windows = {
        preview = true,
    },

    mappings = {
        go_in = 'L',
        go_in_plus = 'l',
    },
})

local function open_mini_files()
    local path = vim.api.nvim_buf_get_name(0)
    local ok, _ = pcall(MiniFiles.open, path, false)
    if not ok then
        MiniFiles.open(vim.fn.getcwd(), false)
    end
end
vim.keymap.set(
    'n',
    '<leader>e',
    open_mini_files,
    { desc = 'Mini Files' }
)
vim.keymap.set(
    require('utils').all_modes,
    '<C-y>',
    open_mini_files,
    { desc = 'Mini Files' }
)

require('mini.git').setup({})

-- `<CR>` jump anywhere in view thing
require('mini.jump2d').setup({})

-- Appearance

require('mini.cursorword').setup({})

-- example config from https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hipatterns.md
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
    highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})

require('mini.icons').setup({})

require('mini.statusline').setup({})

require('mini.trailspace').setup({})
