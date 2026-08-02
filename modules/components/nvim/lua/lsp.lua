local blink = require('blink.cmp')
local telescope_builtin = require('telescope.builtin')
local lazydev = require('lazydev')

local servers = {
    rust_analyzer = {},
    nixd = {},
    lua_ls = {},
    jsonls = {},
}

for server, config in pairs(servers) do
    config.capabilities = blink.get_lsp_capabilities(config.capabilities)
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

vim.diagnostic.config({
    jump = { on_jump = function(_, bufnr) vim.diagnostic.open_float({ bufnr = bufnr }) end }
})

vim.keymap.set('n', '<leader>d', function() telescope_builtin.diagnostics({ bufnr = 0 }) end,
    { desc = 'Diagnostic Picker (local)' })
vim.keymap.set('n', '<leader>D', function() telescope_builtin.diagnostics({ workspace = true }) end,
    { desc = 'Diagnostic Picker (workspace)' })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-h>', vim.diagnostic.open_float, { desc = 'Diagnostic Float' })

-- TODO I'll probably want some better keybinds for next/prev diagnostic, but I can't use these anymore
-- I'll have to see if the telescope diagnostic picker isn't good enough already
--
-- I've tried vim.diagnostic.jump but it's just way less reliable than [d and ]d and idk why
-- vim.keymap.set('n', '<leader>d', '[d', { desc = 'Prev Diagnostic', remap = true })
-- vim.keymap.set('n', '<leader>f', ']d', { desc = 'Next Diagnositc', remap = true })

local lsp_keybinds_group = vim.api.nvim_create_augroup('LspKeybinds', { clear = true })

-- lsp keybinds
vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_keybinds_group,
    callback = function(_)
        vim.keymap.set({ 'n', 'i', 'v' }, '<C-k>', vim.lsp.buf.hover, { desc = 'LSP Hover' })

        -- not the best keybind, but I used to use '<leader>lf' so my muscle memory kinda works
        vim.keymap.set('n', '<leader>l', vim.lsp.buf.format, { desc = 'LSP Format' })
        vim.keymap.set({ 'n', 'v', 'i' }, '<S-M-f>', vim.lsp.buf.format, { desc = 'LSP Format' })
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'LSP Type Definition' })

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP Goto Definition' })
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP Goto Declaration' })

        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'LSP Rename' })

        -- telescope related
        vim.keymap.set('n', '<leader>R', telescope_builtin.lsp_references, { desc = 'LSP Find References' })
        vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_document_symbols, { desc = 'LSP Symbols (local)' })
        vim.keymap.set('n', '<leader>S', telescope_builtin.lsp_workspace_symbols, { desc = 'LSP Symbols (workspace)' })
    end,
})

lazydev.setup({})

-- blink keybinds
blink.setup({
    keymap = {
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'hide_documentation', 'hide_signature', 'fallback' },

        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-l>'] = { 'snippet_forward' },
        ['<C-L>'] = { 'snippet_backward' },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
})
