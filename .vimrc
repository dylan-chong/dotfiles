" Must be first stuff
" {{{

set encoding=utf-8

" Easy leader
let mapleader=" "

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

" Polyglot
let g:polyglot_disabled = ['markdown']

" }}}



" Vundle
" {{{

set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" PLUGINS GO HERE
" {
"
" Themes
Plugin 'morhetz/gruvbox'
Plugin 'chriskempson/base16-vim'

" CTags
Plugin 'ludovicchabant/vim-gutentags'

" NERDTree
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" File-related stuff
Plugin 'dkprice/vim-easygrep'

" FZF
set rtp+=/usr/local/opt/fzf
Plugin 'junegunn/fzf.vim'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Space/indenting
Plugin 'tpope/vim-sleuth' " Detects space/tab sizes of current file
Plugin 'thirtythreeforty/lessspace.vim' " Strip whitespace from lines changed
Plugin 'ntpeters/vim-better-whitespace' " Used only for :StripWhitespace

" Low level editing
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'scrooloose/nerdcommenter'
Plugin 'godlygeek/tabular' " Space out code into tables

" Language packs
Plugin 'sheerun/vim-polyglot'

" Linting
Plugin 'w0rp/ale'

" Completion
Plugin 'ervandew/supertab'
Plugin 'Shougo/deoplete.nvim'
if !has('nvim')
  Plugin 'roxma/nvim-yarp'
  Plugin 'roxma/vim-hug-neovim-rpc'
endif
Plugin 'slashmili/alchemist.vim'

" Lilypond
Plugin 'gisraptor/vim-lilypond-integrator'

" PlantUML
Plugin 'aklt/plantuml-syntax'
Plugin 'weirongxu/plantuml-previewer.vim'

" Javascript
Plugin 'Galooshi/vim-import-js'

" Wintabs (must be after vim-airline)
Plugin 'zefei/vim-wintabs'
Plugin 'zefei/vim-wintabs-powerline'

" JSON
Plugin 'tpope/vim-jdaddy' " JSON formatting

" REPL
Plugin 'metakirby5/codi.vim'

" Session
Plugin 'xolox/vim-misc' " Required by vim-session
Plugin 'dylan-chong/vim-session'

" Miscellaneous
Plugin 'tyru/open-browser.vim' " Required by plantuml-previewer.vim
Plugin 'arecarn/vim-crunch' " Evaluate maths expressions

" }

call vundle#end()            " required
filetype plugin indent on    " required

" }}}



" Coloring
" {{{

" General
syntax on
let g:enable_bold_font = 1

" Colorscheme
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-materia

" Highlight line/column
" set cursorline

" End column
hi ColorColumn ctermbg=52
" Highlight only if there is a character on the column
cal matchadd('ColorColumn', '\%81v', 100)

" }}}



" Plugin Config
" {{{

" EasyGrep
let g:EasyGrepJumpToMatch = 0
let g:EasyGrepRecursive = 1
" rg respects gitignore files
let g:EasyGrepCommand = 'rg' " NOTE: Set to 'grep' if there are special characters
let g:EasyGrepReplaceWindowMode = 2

" Vim Airline Plugin
let g:airline_detect_modified=0
let g:airline_powerline_fonts=1
let g:airline_theme='base16'
" let g:airline_section_b = ''
let g:airline_section_x = ''
" let g:airline_section_y = ''
let g:airline_section_z = '%v'
let g:airline_detect_spell=0
let g:airline_detect_spelllang=0
let g:airline_detect_paste=1
let g:airline#extensions#hunks#enabled = 0
set laststatus=2 " Always show status line

" Deoplete
let g:deoplete#enable_ignore_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_at_startup = 0
au InsertEnter * call deoplete#enable() " Lazy load

" NERDTree
let g:nerdtree_tabs_open_on_gui_startup = 2
let g:nerdtree_tabs_open_on_console_startup = g:nerdtree_tabs_open_on_gui_startup
let NERDTreeShowLineNumbers=1 " enable line numbers
autocmd FileType nerdtree setlocal relativenumber
let NERDTreeShowHidden=1
let g:NERDTreeWinSize=45
nmap <leader>n :NERDTreeToggle<cr>
nmap <leader>N :NERDTreeFind<cr>

" Nerd Commenter
" let g:NERDDefaultAlign = 'start'
let g:NERDRemoveExtraSpaces = 0
let g:NERDTrimTrailingWhitespace = 1
let g:NERDSpaceDelims = 1
nmap gc <leader>c<space>
vmap gc <leader>c<space>

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Alchemist
let g:alchemist#elixir_erlang_src = '~/.elixir-completion/'

" AutoPairs
let g:AutoPairsMapSpace = 0
let g:AutoPairsMultilineClose = 0

" Ale
let g:ale_completion_enabled = 1
let g:ale_set_signs = 1
let g:ale_change_sign_column_color = 1
let g:ale_sign_column_always = 0
let g:ale_completion_delay = 500
let g:ale_linters = {
      \ 'java': []
      \ }
" Turn linting errors into warnings
let g:ale_type_map = {
            \ 'tslint': {'ES': 'WS', 'E': 'W'},
            \ 'credo': {'ES': 'WS', 'E': 'W'}
            \ }
let g:ale_fixers = {
            \ 'typescript': ['tslint --fix'],
            \ 'javascript': ['eslint'],
            \ 'python': ['autopep8']
            \ }
let g:ale_typescript_tslint_use_global = 0
let g:ale_typescript_tsserver_use_global = 0
let g:ale_elixir_credo_use_global = 0
let g:ale_lint_on_enter = 0
nnoremap <leader>an :ALENextWrap<CR>
nnoremap <leader>ap :ALEPreviousWrap<CR>
nnoremap <leader>aj :ALEGoToDefinitionInTab<CR>
nnoremap <leader>af :ALEFix<CR>

" Import JS
nnoremap <leader>jj :ImportJSWord<CR>

" Better Whitespace
let g:better_whitespace_enabled = 0

" Git Gutter
set updatetime=300
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

" PlantUML Previewer
augroup plantuml_previewer_config
  au!
  au FileType plantuml let g:plantuml_previewer#plantuml_jar_path =
        \ substitute(
        \   system("cat `which plantuml` | grep 'plantuml.jar' | perl -pe 's/.* (\\S+plantuml\\.jar).*/\\1/'"),
        \   '\n', '', 'g'
        \ )
augroup END
let g:plantuml_previewer#plantuml_jar_path = '/usr/local/Cellar/plantuml/1.2018.3/libexec/plantuml.jar'

" Markdown (part of polyglot)
" Hack to fix bulet point problem
" autocmd FileType markdown
"     \ set formatoptions-=q |
"     \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" Fugitive
nnoremap <Leader>gcm :w<CR>:Gcommit -v
nnoremap <Leader>gap :w<CR>:Git add -p<CR>i
nnoremap <Leader>gdf :w<CR>:Git diff<CR>i
nnoremap <Leader>gs :w<CR>:Git status<CR>i
nnoremap <Leader>gph :w<CR>:Gpush<Space>
nnoremap <Leader>gpl :w<CR>:Gpull<Space>

" Win Tabs
let g:wintabs_ui_vimtab_name_format = '%t'
let g:wintabs_autoclose_vim = 1
let g:wintabs_autoclose_vimtab = 1
let g:wintabs_autoclose = 2
if !has('idea')
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
  nmap <Leader>qu <Plug>(wintabs_undo)
  nmap <Leader>qq <Plug>(wintabs_close)
  nmap <Leader>qm :WintabsMove<Space>
  nmap <Leader>qo <Plug>(wintabs_only)

  " Override q,q!,wq to avoid accidentally closing all of the buffers in the
  " tab
  function! SaveAndCloseCurrentBuffer()
    :w
    call wintabs#close()
  endfunction
  call CommandCabbr('q', 'call wintabs#close()')
  call CommandCabbr('q!', 'call wintabs#close()')
  call CommandCabbr('wq', 'call SaveAndCloseCurrentBuffer()')
endif
" Show git commit file in tabline
let g:wintabs_ignored_filetypes = []
autocmd FileType gitcommit set buflisted
" Fix this plugin overriding the styling for vim-airline
call g:Base16hi(
      \ 'TablineSel',
      \ g:base16_gui00,
      \ g:base16_gui0D,
      \ g:base16_cterm00,
      \ g:base16_cterm0D,
      \ 'bold',
      \ ''
      \ )
call g:Base16hi(
      \ 'Tabline',
      \ g:base16_gui04,
      \ g:base16_gui02,
      \ g:base16_cterm04,
      \ g:base16_cterm02,
      \ '',
      \ ''
      \ )
let g:wintabs_powerline_sep_buffer = ''
let g:wintabs_powerline_sep_tab = ''
" Reinitialise when reloading vimrc to make it look right
call wintabs_powerline#init()

" Vim Session
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

" Gutentags
" rg respects gitignore files. This command also filters out certain file types
" that we do not want tags for
let g:gutentags_file_list_command = "rg -l '.' | rg -v '(json|plist)$'"
let g:gutentags_define_advanced_commands = 1

" FZF
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>F :History<CR>
nnoremap <silent> <Leader>zc :Commands<CR>
nnoremap <silent> <Leader>zb :Buffers<CR>
nnoremap <silent> <Leader>zt :Tags<CR>
nnoremap <silent> <Leader>zl :BLines<CR>
nnoremap <silent> <Leader>z/ :History/<CR>
nnoremap <silent> <Leader>z: :History:<CR>
nnoremap <silent> <Leader>zh :Helptags<CR>
nnoremap <silent> <Leader>zm :Maps<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case -g '!.git' --hidden ".shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
cnoreabbrev rg Rg

" Codi
let g:codi#rightalign = 1
let g:codi#width = 100
let g:codi#autocmd = 'InsertLeave' " TODO update when pasting

" }}}



" Key mappings
" {{{

" Clear highlighting
if !has('nvim') && !has('idea') && !has("gui_running")
  " Is normal vim. escape mappings break it:
  " https://github.com/vim/vim/issues/3080#issuecomment-399738110
else
  nnoremap <silent> <esc> <esc>:noh<cr>
endif
inoremap <silent> <esc> <esc>:noh<cr>

" Splitting lines
nnoremap <C-j> i<CR><ESC>

" Wrap paragraph
nnoremap gqp gwip

" Save one keystroke when aligning code
nnoremap =p mz=ap`z

" Whole file operatoins
nnoremap yaf mzggVGy`z
nnoremap daf mzggVGd`z
vnoremap af mzggoG$

" Replace (a (local) variable name)
" Part 1: Yank current selection (for example a variableName)
vnoremap <C-p> "xyV
" Part 1.1: (Optional variant of part 1 - select current word)
nnoremap <C-p> viw"xyV
" Part 2: Start the search with the template (containing variableName as a
" search term and replaced term), in the selected range. Assumes gdefault is
" on. You can optionally type <C-r>x to paste what we are going to replace. You
" can also adjust the selection area after pressing <C-r> by pressing
" <ESC>gvADJUST_YOUR_SEARCH_AREA_NOW:<Up>.
vnoremap <C-r> :s/\C\V\<<C-r>x\>/

" Reload .vimrc
nnoremap <leader>sv :w<CR>:so $MYVIMRC<CR>

" Exporting documents
nnoremap <Leader>dm :w<CR>:!doc export '%'<CR>
nnoremap <Leader>dt :w<CR>:!pdflatex '%' && open %:r.pdf<CR>

" 'Inspections'
" {{{
" Split list/params by comma (except trailing comma)
vnoremap <leader>i, mz:s/,\(\s*$\)\@\!/,\r<CR>=ap`z
" Put a new line at the start and end of the selection
vmap <leader>i<C-j> <ESC><Right><C-j>gvo<ESC><C-j>
" Split params by comma and start/end of selection (Doesnt work if nested method calls)
vmap <leader>i<CR> <leader>i<C-j>V<leader>i,
" Same as above, but selects automatically
nmap <leader>i<CR> v%<Right>o%%<Left><leader>i<CR>
" Split line into multiple lines by '.'
vnoremap <leader>i. :s/\./\r\.<CR><ESC>mz=ap`z
" }}}

" Don't deselect text on indent
vnoremap < <gv
vnoremap > >gv

" Duplicate buffer in new tab
nnoremap <C-w>d <C-w>s<C-w>T
nmap <C-w>D <C-w>d:tabm-<CR>

" Switch to last tab
let g:lasttab = 1
nnoremap <Leader>gt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Auto format comments
nnoremap <leader>oa :set formatoptions+=a<CR>
nnoremap <leader>oA :set formatoptions-=a<CR>

" Select recently pasted text
nnoremap gp `[v`]

" Select current line except whitespace
nnoremap gV ^v$<Left>

" Copy current file to clipboard
nnoremap <Leader>% :call CopyToClipboard(expand('%'))<Left><Left><Left>

" Jump to definition - tjump in new tab
nnoremap <C-g><C-]> <C-w>s<C-w>Tg<C-]>

" File operations
nnoremap <C-q> :wa<CR>
nnoremap <C-c> :wqa

" Moving tabs
nnoremap <C-w>< :tabm-<CR>
nnoremap <C-w>> :tabm+<CR>

" }}}



" Gui Vims
" {{{

if has("gui_running")
  " MacVim
  set guifont=Fira\ Code\ Light:h13
  set linespace=4
endif

" }}}



" Other
" {{{
"
" Scrolling
set scrolloff=4
set sidescrolloff=4

" Text width
set textwidth=79

" Indenting defaults
" Defaults to 4 spaces for most filetypes
if get(g:, '_has_set_default_indent_settings', 0) == 0
  autocmd FileType typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,tmux,plantuml
        \ setlocal expandtab tabstop=2 shiftwidth=2
  " setglobal seems to not override sleuth when reloading vimrc
  set expandtab
  set tabstop=4
  set shiftwidth=4
  let g:_has_set_default_indent_settings = 1
endif

" Line Numbers
set relativenumber
set number
au BufEnter * set relativenumber
au BufEnter * set number

" Somehow maybe gets the Mac clipboard to work
set clipboard=unnamed

" Backspace fix
set backspace=2

" Odd filetypes/extensions
au BufRead,BufNewFile *.js.applescript set filetype=javascript

" Markdown bullet indenting
set autoindent

" Command completion
set wildmode=longest:full,full

" Remove scrollbars on guis
set guioptions-=L " split
set guioptions-=R " split
set guioptions-=r

" Disable continuing comments on new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Autosave
au FocusLost * silent! :wa
" Autosave when doing some actions
set autowrite
set autowriteall

" Auto reload
set autoread
au FocusGained,BufEnter * :silent! checktime " Taken from https://stackoverflow.com/a/2329094/1726450

" Tags
set tags=./tags;

" Don't wrap long lines onto the next line on the screen
set nowrap

" No double space after running `gq` on a line with a '.' at the end
set nojoinspaces

" Get bg color to work in tmux
set t_ut=

" Colors in neovim
set termguicolors

" No swapfiles
set nobackup noswapfile

" Mouse
set mouse=a

" Redraw faster
set lazyredraw

" Spelling
setglobal spelllang=en_nz
set dictionary+=/usr/share/dict/words
autocmd FileType markdown,text,bib,latex,plaintex setlocal spell

" TODO Use a plugin and instead of making the function myself
function! g:CopyToClipboard(string)
  silent exec "!echo " . a:string . " | pbcopy"
  echom "Copied: '" . a:string . "'"
endfunction

" Export plantuml
function! g:PlantUMLSave()
  exec "!plantuml -headless " . expand('%') . " &"
endfunction
command! PlantUMLSave silent call g:PlantUMLSave()

" Open image plantuml saved by PlantUMLSave
function! g:PlantUMLOpenImage()
  exec "!open " . expand('%:p:r') . ".png"
endfunction
command! PlantUMLOpenImage silent call g:PlantUMLOpenImage()

" Case (and ignore case in command mode)
set ignorecase
set smartcase
augroup dynamic_smartcase
  autocmd!
  autocmd CmdLineEnter : set nosmartcase
  autocmd CmdLineLeave : set smartcase
augroup END

" Don't wrap in the middle of a word
set linebreak

" Highlight search results
set hlsearch

" Move cursor to next search result
set incsearch

" Show substitution results as you are typing the regex out (Neovim only)
if has('nvim')
  set inccommand=nosplit
endif

" Automatically add g option with substitute
set gdefault

" Wildignore
set wildignore+=package-lock.json,yarn.lock,tags,Session.vim

" Don't care about accidental capitals
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev WQ wq

" Open help split vertically
autocmd FileType help wincmd L

" }}}
