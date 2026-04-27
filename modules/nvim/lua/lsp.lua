local blink = require('blink.cmp')
local telescope_builtin = require('telescope.builtin')
local lazydev = require('lazydev')

local servers = {
    rust_analyzer = {},
    nixd = {},
    lua_ls = {},
}

for server, config in pairs(servers) do
    config.capabilities = blink.get_lsp_capabilities(config.capabilities)
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

vim.diagnostic.config({
    jump = { on_jump = function(_, bufnr) vim.diagnostic.open_float({ bufnr = bufnr }) end }
})
vim.keymap.set('n', '<leader>g', vim.diagnostic.open_float, { desc = 'Diagnostic Float' })
-- I've tried vim.diagnostic.jump but it's just way less reliable than [d and ]d and idk why
vim.keymap.set('n', '<leader>d', '[d', { desc = 'Prev Diagnostic', remap = true })
vim.keymap.set('n', '<leader>f', ']d', { desc = 'Next Diagnositc', remap = true })

-- lsp keybinds
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        vim.keymap.set({ 'n', 'i', 'v' }, '<C-k>', vim.lsp.buf.hover)

        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'Format' })
        vim.keymap.set({ 'n', 'v', 'i' }, '<S-M-f>', vim.lsp.buf.format, { desc = 'Format' })
        vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action' })
        vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, { desc = 'Type Definition' })

        vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename' })

        -- telescope related
        vim.keymap.set('n', '<leader>lR', telescope_builtin.lsp_references, { desc = 'Find References' })
        vim.keymap.set('n', '<leader>ls', telescope_builtin.lsp_document_symbols, { desc = 'Document Symbols' })
    end
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
