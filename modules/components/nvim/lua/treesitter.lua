vim.opt.foldlevelstart = 99

local treesitter_group = vim.api.nvim_create_augroup('TreesitterHighlighting', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = treesitter_group,
    callback = function(ev)
        if vim.treesitter.language.add(ev.match) then
            vim.treesitter.start(ev.buf)

            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'

            vim.bo.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
        end
    end,
})
