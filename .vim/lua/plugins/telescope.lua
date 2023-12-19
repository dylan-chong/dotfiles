local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup{
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
        -- Open file and resume telescope
        ["<C-o>"] = function(prompt_bufnr)
          actions.select_default(prompt_bufnr)
          builtin.resume()
        end,
        ["<C-t>"] = function(prompt_bufnr)
          actions.select_tab(prompt_bufnr)
        end,
        ["<C-v>"] = function(prompt_bufnr)
          actions.select_vertical(prompt_bufnr)
        end,
        ["<C-x>"] = function(prompt_bufnr)
          actions.select_horizontal(prompt_bufnr)
        end,
        ["<C-q>"] = function(prompt_bufnr)
          -- TODO doesn't work
          builtin.quickfix()
        end,
      },
    },
  },
  pickers = {
    grep_string = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
  },
  extensions = {
    fzf = {},
  },
}

telescope.load_extension('fzf')
telescope.load_extension('recent_files')

vim.keymap.set('n', '<leader>Tr', builtin.resume, {})

vim.keymap.set('n', '<leader>f', function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set('n', '<leader>F', telescope.extensions.recent_files.pick, {})

vim.keymap.set('n', '<leader>r', ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '' })<Left><Left><Left><Left>", {})
vim.keymap.set('n', '<leader>R', ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '<C-r><C-w>' })<Left><Left><Left><Left>", {})
vim.keymap.set('v', '<leader>r', builtin.grep_string, {})

vim.keymap.set('n', '<leader>zg', builtin.git_status, {})
