local blink = require('blink.cmp')
local telescope_builtin = require('telescope.builtin')

local servers = {
  rust_analyzer = {},
}

for server,config in pairs(servers) do
  config.capabilities = blink.get_lsp_capabilities(config.capabilities)
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- lsp keybinds
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    vim.keymap.set({'n', 'i', 'v'}, '<C-k>', vim.lsp.buf.hover)

    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
    vim.keymap.set({'n', 'v', 'i'}, '<S-M-f>', vim.lsp.buf.format)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)

    -- telescope related
    vim.keymap.set('n', '<leader>ls', telescope_builtin.lsp_document_symbols)
  end
})

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
