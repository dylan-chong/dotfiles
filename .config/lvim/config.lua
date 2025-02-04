-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--------------- Builtin plugin config ---------------

lvim.builtin.project.active = false
lvim.builtin.lir.active = false

lvim.builtin.telescope.defaults.layout_strategy = 'vertical'
lvim.builtin.telescope.theme = nil                              -- TODO copy to lunarvim repo
lvim.builtin.telescope.defaults.path_display = { "truncate" }   -- TODO add to docs on lunarvim repo
lvim.builtin.telescope.defaults.previewer = true                -- TODO add nil value to defaults?
lvim.builtin.telescope.pickers.grep_string.only_sort_text = nil -- Allow filtering by file names using fzf
lvim.builtin.which_key.mappings['f'] = {
  function()
    require("lvim.core.telescope.custom-finders").find_project_files { previewer = true } -- TODO copy to lunarvim repo
  end,
  "Find File",
}
lvim.builtin.which_key.mappings['s']['t'] = {
  ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '' })<Left><Left><Left><Left><C-f>i",
  "Text (FZF)",
}
lvim.builtin.which_key.mappings['s']['T'] = {
  ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '\\\\b\\\\b' })<Left><Left><Left><Left><Left><Left><Left><C-f>i",
  "Text with word boundaries (FZF)",
}
lvim.builtin.which_key.vmappings['s'] = {
  T = {
    ":lua require('telescope.builtin').grep_string({ use_regex = true, search = '<C-r><C-w>' })<Left><Left><Left><Left><C-f>i",
    "Text (FZF)",
  }
}

local function PrettyPath()
  local rel = vim.fn.expand('%:.')
  return vim.fn.substitute(rel, '/', ' > ', 'g')
end
local lualine_components = require("lvim.core.lualine.components")
lvim.builtin.lualine.sections.lualine_c = { { PrettyPath }, lualine_components.diff, lualine_components.python_env }

-- TODO in lunarvim, s/'reset hunk'/'revert hunk'

-- LSP Lint
lvim.format_on_save.enabled = true
lvim.format_on_save.timeout = 2000
lvim.format_on_save.pattern = '*.ts,*.tsx,*.lua'
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "eslint_d", filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" } },
}
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "prettierd",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
  {
    -- TODO autofix doesnt work here
    name = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end
lvim.builtin.which_key.mappings.l.o = {
  organize_imports, "Organize imports"
}

--------------- Custom plugins ---------------

lvim.plugins = {
  -- Using old session plugin because it works with wintabs.
  -- In the future, will use scope.nvim and a session plugin that goes with tt
  {
    'dylan-chong/vim-session',
    dependencies = {
      'xolox/vim-misc'
    },
    config = function()
      vim.api.nvim_exec2([[
        " Settings to get it to work like vim-obsession (save session in current directory)
        let g:session_autosave_silent = 1
        let g:session_autoload = 'no'
        let g:session_autosave = 'yes'
        let g:session_lock_enabled = 0
        let g:session_directory = './'
        let g:session_default_name = 'Session'
        let g:session_autosave_periodic = 0
        let g:session_autosave_only_with_explicit_session = 1
        augroup vim_session_autosave
          au!
          au FocusLost,BufWritePost,VimLeave * silent! call xolox#session#auto_save()
        augroup END
        let g:session_persist_colors = 0

        " TODO add support for tab local variable storage
      ]], {})
    end,
  },

  {
    'dylan-chong/vim-wintabs',
    config = function()
      lvim.builtin.which_key.mappings['w'] = nil -- force saves by default in lunarvim, conflicts with Wintabs <leader>w

      local line_diagnostics = lvim.lsp.buffer_mappings.normal_mode['gl']
      if line_diagnostics then
        lvim.lsp.buffer_mappings.normal_mode['gl'] = nil
        lvim.lsp.buffer_mappings.normal_mode['gK'] = line_diagnostics
      end

      vim.api.nvim_exec2([[
        function! g:Shorten_string(string, max_length)
          let suffix = '...'
          if len(a:string) > a:max_length
            return a:string[:a:max_length - len(suffix) - 1] . suffix
          else
            return a:string
          endif
        endfunction

        function! g:Set_wintabs_tab_name()
          let new_name = input('Tab name: ', get(t:, 'wintabs_custom_tab_name', ''))
          let t:wintabs_custom_tab_name = new_name
        endfunction
        command! WintabsSetTabName call g:Set_wintabs_tab_name()

        function! g:Wintabs_ui_tablabel(tabnr)
          return gettabvar(a:tabnr, 'wintabs_custom_tab_name')
        endfunction

        let g:_wintabs_ui_bufname_max_length = 20
        function! g:Wintabs_ui_bufname(bufnr)
          let file = Shorten_string(fnamemodify(bufname(a:bufnr), ':t'), g:_wintabs_ui_bufname_max_length)

          if index(['index.tsx', 'index.ts', 'index.jsx', 'index.js'], file) != -1
            let suffix = '/i'
            let parent_dir = Shorten_string(fnamemodify(bufname(a:bufnr), ':h:t'), g:_wintabs_ui_bufname_max_length - len(suffix))
            return parent_dir . suffix
          endif

          return file
        endfunction

        let g:wintabs_ui_vimtab_name_format = '%t'
        let g:wintabs_ui_sep_inbetween = ''
        let g:wintabs_ui_active_left = ''
        let g:wintabs_ui_active_right = ''
        let g:wintabs_autoclose_vim = 1
        let g:wintabs_autoclose_vimtab = 1
        let g:wintabs_autoclose = 2

        " Change buffers
        nmap gh <Plug>(wintabs_previous)
        nmap gl <Plug>(wintabs_next)

        " Other buffer stuff
        nmap <Leader>wu <Plug>(wintabs_undo)
        nmap <Leader>wm :WintabsMove<Space>
        nmap <Leader>wo <Plug>(wintabs_only)
        nnoremap <Leader>wO :tabonly<Bar>call<Space>wintabs#only()<Bar>only

        " Override q,q!,wq to avoid accidentally closing all of the buffers in the
        " tab
        function! SaveAndCloseCurrentBuffer()
          :up
        call wintabs#close()
        endfunction

        " Function to replace built in commands
        " Taken from: http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
        function! CommandCabbr(abbreviation, expansion)
          execute 'cabbr '
                \. a:abbreviation
                \. ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "'
                \. a:expansion
                \. '" : "'
                \. a:abbreviation
                \. '"<CR>'
        endfunction

        call CommandCabbr('q', 'call wintabs#close()')
        call CommandCabbr('q!', 'call wintabs#close()')
        call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')
      ]], {})
    end,
  },

  {
    "okuuva/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        trigger_events = {
          immediate_save = { "BufLeave", "FocusLost" },
          defer_save = {},
        },
      })
    end,
  },

  {
    "lmburns/lf.nvim",
    dependencies = {
      "toggleterm.nvim"
    },
    config = function()
      require("lf").setup({})
      local fn = vim.fn
      local o = vim.o

      lvim.builtin.which_key.mappings.n = {
        function()
          require("lf").start({
            height = 99999,
            width = 99999,
            winblend = 0,
          })
        end,
        "Browse Files"
      }
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },
  { "tpope/vim-abolish" }, -- :S substitution, casing changes

  {
    -- TODO get working?
    "AckslD/nvim-revJ.lua",
    dependencies = { "wellle/targets.vim" },
    config = function()
      lvim.builtin.which_key.vmappings.J = {
        function() require('revj').format_visual() end,
        "Split line into multiple lines"
      }
    end
  },

  {
    "mizlan/iswap.nvim",
    config = function()
      lvim.builtin.which_key.mappings['<'] = { ":ISwapWithLeft<CR>", "Swap current element with previous" }
      lvim.builtin.which_key.mappings['>'] = { ":ISwapWithRight<CR>", "Swap current element with next" }
    end
  },

  {
    "hinell/lsp-timeout.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      vim.g.lspTimeoutConfig = {
        startTimeout = 1000 * 1,
        --stopTimeout = 1000 * 60 * 999,
      }
    end
  },

  -- TODO - copy to lunar
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    init = function()
      local spectre = require('spectre')
      spectre.setup()
      lvim.builtin.which_key.mappings['r'] = {
        r = {
          function() spectre.toggle() end,
          "Find and replace",
        },
      }
      lvim.builtin.which_key.vmappings['r'] = {
        r = {
          function() spectre.open_visual() end,
          "Find and replace",
        },
      }
    end
  },

  -- TODO copy to lunar
  {
    'stevearc/dressing.nvim'
  },

  {
    "tpope/vim-fugitive",
    config = function()
      lvim.builtin.which_key.mappings.g.l = { '<cmd>Git blame<cr>', 'Git Blame' }
    end
  },

  { 'tpope/vim-eunuch' }, -- File related stuff

  { 'rickhowe/diffchar.vim' },

  {
    -- TODO copy to lunar
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      -- Copied from https://github.com/ray-x/lsp_signature.nvim?tab=readme-ov-file#configure
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
            return
          end
          require("lsp_signature").on_attach({ hint_enable = false, hi_parameter = 'Search' }, bufnr)
        end,
      })
    end,
  },
  -- TODO auto detect indent
}

--------------- Custom configurations ---------------

-- File operations
vim.api.nvim_exec2([[
  nnoremap <C-q> :w<CR>:e<CR>
  inoremap <C-q> <Esc>:w<CR>
  nmap Q :wq<CR>

  " C-c to exit
  nnoremap <C-c> :wqa
  augroup control_c_to_exit
    autocmd!
    autocmd CmdLineEnter : nunmap <C-c>
    autocmd CmdLineLeave : nnoremap <C-c> :wqa
  augroup END
]], {})


-- Copy current file to clipboard
-- TODO NEXT just call https://github.com/tnakaz/path-to-clipboard.nvim/blob/main/lua/path-to-clipboard/init.lua
--
vim.api.nvim_exec2([[
  function! g:CopySingleLine(string)
    if executable('pbcopy')
      silent exec "!echo " . a:string . " | tr -d '\\n' | pbcopy"
    elseif executable('clip.exe')
      silent exec "!echo " . a:string . " | tr -d '\\n' | clip.exe"
    else
      echoerr 'No clipboard program found'
      throw l:output
    endif
    echom "Copied: '" . a:string . "'"
  endfunction
]], {})

-- Copy file path
function CopyPath(expand)
  local string = vim.fn.expand(expand)
  vim.fn.setreg('+', string)
  print('Copied: ' .. string)
end

lvim.builtin.which_key.mappings['%'] = {
  ":lua CopyPath('%:.')<Left><Left><C-f>i",
  "Copy file path"
}

-- Nicer looking C-g file output
vim.keymap.set('n', '<C-g>', function()
  print(PrettyPath())
end)

-- Select current line except whitespace
vim.keymap.set('n', 'gV', '^v$<Left>')

-- Tab keys (goes well with wintabs)
lvim.builtin.which_key.mappings['t'] = {
  {
    h = { "gT", "Previous tab" },
    l = { "gt", "Next tab" },
    N = { ":tabnew<Space><C-f>a", "New tab" },
    n = { ":tabnew<Space><C-f>a", "New tab" },
    c = { ":tabclose<C-f>a", "Close tab" },
    o = { ":tabonly<CR>", "Close other tabs" },
    m = { ":tabm<Space><C-f>a", "Move tab" },
    d = { "<C-w>s<C-w>TgT:WintabsClose<CR>:tabnext<CR>", "Move buffer to new tab" },
    D = { "<C-w>s<C-w>T", "Duplicate buffer in new tab" },
  },
  "Tab"
}

-- Strip ^M from recently pasted text
vim.api.nvim_command(
  "command! StripCarriageReturns %s/\r$//"
)

lvim.builtin.which_key.mappings['c'] = {
  [[:lua complete_todo()<CR>]],
  "Complete Todo"
}
function complete_todo()
  local current_pos = vim.fn.getpos('.')
  local current_line = vim.fn.getline('.')
  local datetime = os.date("%Y-%m-%d %H:%M:%S")

  vim.api.nvim_input('dd')

  -- Append the line with datetime at the beginning to the bottom
  vim.fn.append('$', '- ' .. datetime .. ' ' .. current_line)

  -- Move the cursor back to the original position
  vim.fn.setpos('.', current_pos)
end

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = true
vim.opt.breakindent = true

-- Get command mode completion to work more nicely (TODO copy to lunarvim repo)
vim.opt.smartcase = true

-- Fix bug https://github.com/LunarVim/LunarVim/issues/3007#issuecomment-1281428877
-- TODO disable this in luanrvim
vim.api.nvim_del_augroup_by_name('_auto_resize')
