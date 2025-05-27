return {
  'dylan-chong/vim-wintabs',
  config = function()
    -- lvim.builtin.which_key.mappings['w'] = nil -- force saves by default in lunarvim, conflicts with Wintabs <leader>w

    -- local line_diagnostics = lvim.lsp.buffer_mappings.normal_mode['gl']
    -- if line_diagnostics then
    --   lvim.lsp.buffer_mappings.normal_mode['gl'] = nil
    --   lvim.lsp.buffer_mappings.normal_mode['gK'] = line_diagnostics
    -- end

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
      let g:wintabs_autoclose_vim = 1 " This doesn't work and using try catch in SaveAndCloseCurrentBuffer
      let g:wintabs_autoclose_vimtab = 1 " This doesn't work and using try catch in SaveAndCloseCurrentBuffer
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
        " Close in case it's last window to avoid cannot close last window error
        try
          WintabsClose
        catch
          quit
        endtry
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
}
