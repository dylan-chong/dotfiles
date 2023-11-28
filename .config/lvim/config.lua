-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.project.active = false

lvim.plugins = {
  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {}
    end,
  },

  {
    'zefei/vim-wintabs',
    config = function()
      vim.api.nvim_command([[
        let g:wintabs_ui_vimtab_name_format = '%t'
        let g:wintabs_autoclose_vim = 1
        let g:wintabs_autoclose_vimtab = 1
        let g:wintabs_autoclose = 2

        " Change tabs
        nnoremap <Leader>gh gT
        nnoremap <Leader>g<Left> gT
        nnoremap <Leader>gl gt
        nnoremap <Leader>g<Right> gt

        " Change buffers
        nmap gh <Plug>(wintabs_previous)
        nmap g<Left> <Plug>(wintabs_previous)
        nmap gl <Plug>(wintabs_next)
        nmap g<Right> <Plug>(wintabs_next)

        " Other buffer stuff
        nmap <Leader>wu <Plug>(wintabs_undo)
        nmap <Leader>wm :WintabsMove<Space>
        nmap <Leader>wo <Plug>(wintabs_only)
        nnoremap <Leader>wO :tabonly<Bar>call<Space>wintabs#only()<Bar>only

        " Copied from https://github.com/zefei/vim-wintabs/issues/47#issuecomment-451717800
        function! WintabsCloseRight()
          call wintabs#refresh_buflist(0)
          let buflist = copy(w:wintabs_buflist)
          call filter(buflist, 'v:key > '.index(buflist, bufnr('%')))
          " 'v:key < ' for all tabs to the left
          for buffer in buflist
            execute 'buffer! '.buffer
            WintabsClose
          endfor
        endfunction

        " Override q,q!,wq to avoid accidentally closing all of the buffers in the
        " tab
        function! SaveAndCloseCurrentBuffer()
          :up
        call wintabs#close()
        endfunction
        call CommandCabbr('q', 'call wintabs#close()')
        call CommandCabbr('q!', 'call wintabs#close()')
        call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')
      ]])
    end,
  },

  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        trigger_events = { "BufLeave", "FocusLost" }
      })
    end,
  },
}

lvim.format_on_save.enabled = true

-- Strip ^M from recently pasted text
vim.api.nvim_command(
  "command! StripCarriageReturns %s/\r$//"
)
