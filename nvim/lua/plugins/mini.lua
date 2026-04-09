require('mini.files').setup({
  mappings = {
    go_in = 'L',
    go_in_plus = 'l',
  },
})

vim.keymap.set('n', '<leader>e', function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end, { desc = 'Mini Files' })
