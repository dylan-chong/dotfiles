require('spectre').setup({
})

vim.keymap.set('n', '<leader>vr', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('v', '<leader>vr', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current selection"
})
