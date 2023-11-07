local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
      },
    },
  },
  extensions = {
    fzf = {},
  },
}

telescope.load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>r', ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '' })<Left><Left><Left><Left>", {})
vim.keymap.set('n', '<leader>R', builtin.grep_string, {})
vim.keymap.set('v', '<leader>r', builtin.grep_string, {})
vim.keymap.set('n', '<leader>zg', builtin.git_status, {})
