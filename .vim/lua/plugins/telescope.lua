require('telescope').setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
  },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>r', builtin.live_grep, {})
