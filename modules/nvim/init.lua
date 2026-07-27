local all_modes = require('utils').all_modes

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

-- normal mode alt keybind
-- particularly useful when in term mode
vim.keymap.set(all_modes, '<C-\'>', function() vim.cmd('stopinsert') end)

require('plugins')

require('lsp')
require('neovide')
require('terminal')
require('treesitter')
