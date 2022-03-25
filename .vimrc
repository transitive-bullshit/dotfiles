" (zR opens all folds)

" Header {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
"   /$$$$$$$$ /$$$$$$  /$$$$$$   /$$$$$$  /$$   /$$       /$$    /$$ /$$$$$$ /$$      /$$
"  | $$_____/|_  $$_/ /$$__  $$ /$$__  $$| $$  | $$      | $$   | $$|_  $$_/| $$$    /$$$
"  | $$        | $$  | $$  \__/| $$  \__/| $$  | $$      | $$   | $$  | $$  | $$$$  /$$$$
"  | $$$$$     | $$  |  $$$$$$ | $$      | $$$$$$$$      |  $$ / $$/  | $$  | $$ $$/$$ $$
"  | $$__/     | $$   \____  $$| $$      | $$__  $$       \  $$ $$/   | $$  | $$  $$$| $$
"  | $$        | $$   /$$  \ $$| $$    $$| $$  | $$        \  $$$/    | $$  | $$\  $ | $$
"  | $$       /$$$$$$|  $$$$$$/|  $$$$$$/| $$  | $$  /$$    \  $/    /$$$$$$| $$ \/  | $$
"  |__/      |______/ \______/  \______/ |__/  |__/  |_/     \_/    |______/|__/     |__/
"
"
"   This is the personal .vimrc file of Travis Fischer (aka Fisch).
"   (www.transitivebullshit.com)
"
"   Based off of Steve Francia's excellent spf13 vim distribution.
"   (http://spf13.com)
" }

" Environment {
    " Basic settings {
        set nocompatible        " Must be first line (disables vi-compatibility support)

        if !(has('win16') || has('win32') || has('win64'))
            set shell=/bin/sh
        endif
    " }

    " Windows settings {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
            set gfn=Courier\ New:h12:b:cANSI
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after

            " If PowerShell is installed on the machine then set it up as the shell
            let s:powershell_path = $windir.'\system32\WindowsPowerShell\v1.0\powershell.exe'
            if filereadable(s:powershell_path)
                exe "set shell=".s:powershell_path
                set shellcmdflag="-Command - "
            endif
        endif
    " }

    " Setup Bundle Support {
        execute pathogen#infect()

        " initialize pathogen package manager
        "call plug#begin('~/.vim/plugged')

        " todo: neocomplcache is deprecated
        "Plug 'Shougo/neocomplcache'

        "Plug 'scrooloose/nerdtree'
        "Plug 'vim-syntastic/syntastic'
        "Plug 'godlygeek/tabular'
        "Plug 'Lokaltog/vim-easymotion'
        "Plug 'tpope/vim-fugitive'
        "Plug 'ctrlpvim/ctrlp.vim'
        "Plug 'ekalinin/Dockerfile.vim'

        " language support
        "Plug 'jelera/vim-javascript-syntax'
        "Plug 'pangloss/vim-javascript'
        "Plug 'groenewege/vim-less'
        "Plug 'hail2u/vim-css3-syntax'
        "Plug 'elzr/vim-json'
        "Plug 'fatih/vim-go'
        "Plug 'tomlion/vim-solidity'

        " template support
        "Plug 'mxw/vim-jsx'
        "Plug 'mustache/vim-mustache-handlebars'
        "Plug 'digitaltoad/vim-pug'
        "Plug 'wavded/vim-stylus'

        "call plug#end()
    " }
" }

" General {
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    scriptencoding utf-8

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    "fun! <SID>StripTrailingWhitespaces()
    "    let l = line(".")
    "    let c = col(".")
    "    %s/\s\+$//e
    "    call cursor(l, c)
    "endfun

    set clipboard=unnamed       " clipboard goes to system clipboard

    set tabstop=2 shiftwidth=2 softtabstop=2

    set expandtab               " force tabs to use spaces instead of \t
    set smartindent             " indent on enter according to previous line's format

    "autocmd FileType javascript,html,css,less autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
    autocmd FileType javascript,html,css,less set tabstop=2 shiftwidth=2 softtabstop=2

    " for eko projects, use weird non-standard settings...
    "autocmd BufNewFile,BufRead ~/dev/eko/api/* setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
    "autocmd BufNewFile,BufRead ~/dev/eko/api/* setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
    autocmd FileType jade setlocal autoindent noexpandtab

    set sm                      " show matching parenthesis
    set ai sm

    set autowrite               " auto-write file when switching files with :e

    set mouse=a
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing

    " fix unclosed paren indents, switch indents, and public/private indents
    " NOTE: this appears to cause annoying issues with javascript file indenting
    "set cinoptions+=:1s,l1,g1s,h1s,(0,u0,W1s

    set history=1000            " Store a ton of history (default is 20)
    set shortmess+=filmnrxoOtT  " Abbrev. of messages (avoids 'hit enter')

    "set backup
    "set writebackup
    set nobackup
    set nowritebackup
    "set noswapfile

    set backupdir=$HOME/.vim/backup//,$HOME/.tmp//,$HOME/tmp//,/tmp//
    set directory=$HOME/.vim/swap//,$HOME/.tmp//,$HOME/tmp//,/tmp//
    set undodir=$HOME/.vim/undo//,$HOME/.tmp//,$HOME/tmp//,/tmp//
    set viewdir=$HOME/.vim/sessions

    if has('persistent_undo')
        set undofile            " persistent undo
        set undolevels=1000     " Maximum number of changes that can be undone
        set undoreload=10000    " Maximum number lines to save for undo on a buffer reload
    endif
" }

" Vim UI {
    " silent (no annoying beep, hurray!)
    set vb t_vb=".

    " open files using current directory
    set browsedir=buffer

    " customize status line
    if has('statusline')
        set laststatus=2
        "set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        "set statusline+=\ [%{&ff}/%Y]            " Filetype
        "set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    "set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    "set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    "set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set wildignore=*.o,*.pyc
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    "set list
    "set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

    " Sane indentation in insert mode
    "map! <CR>  <CR><up><down>
    "set cpo+=I

    " GVim {
        if has('gui_running')
            set guioptions-=m        " Remove the menu & toolbar
            set guioptions-=T
            set lines=75 columns=236 " Set fullscreen

            if has("gui_gtk2")
                set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
            elseif has("gui_mac")
                set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
            elseif has("gui_win32")
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif

            "if has('gui_macvim')
            "    set transparency=5  " Make the window slightly transparent
            "endif
        else
            if &term == 'xterm' || &term == 'screen'
                set t_Co=256        " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
            endif
            "set term=builtin_ansi  " Make arrow and other keys work
        endif
    " }
" }

" FileTypes {
    au FileType C,H,c,cc,cpp,h,pde,java,pl,cs,m setlocal formatoptions=croql cindent
    au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
    au FileType pde,cs,m,h  set tabstop=4 shiftwidth=4 softtabstop=4
    au BufWritePre *.py execute ':Black'

    " Automatically enable GLSL syntax highlighting
    au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl

    au FileType python set tabstop=4 shiftwidth=4 softtabstop=4
    " au BufRead *.py inoremap # X<c-h>#

    au FileWritePost,BufWritePost *.less :call LessCSSCompress()
    au BufNewFile,BufRead *.less set filetype=less
    au BufNewFile,BufRead Fastfile set filetype=ruby

    " Mapping file extensions to known types
    au BufRead,BufNewFile *.*proj       setfiletype xml
    au BufRead,BufNewFile *.xaml        setfiletype xml
    au BufRead,BufNewFile *.targets     setfiletype xml
    au BufRead,BufNewFile *.sg          setfiletype cs
    au BufRead,BufNewFile *.csi         setfiletype cs
    au BufRead,BufNewFile *.pde         setfiletype java
    au BufRead,BufNewFile *.ps1         setfiletype ps1

    let html_use_css=1
" }

" Key Mappings {
    let mapleader = ','

    " Split current buffer with pair source file
    nnoremap gs         :call SplitPairFile()<CR>
    " Open pair source file in current buffer
    nnoremap ge         :call EditPairFile()<CR>

    " Open header or source file of word under cursor (either split or in current
    " buffer
    nnoremap gcs        wb"zye:call SplitFilePrefix('<C-R>z',".cs")<CR>
    nnoremap gce        wb"zye:call EditFilePrefix('<C-R>z',".cs")<CR>

    nnoremap ghs        wb"zye:call SplitFilePrefix('<C-R>z',".h")<CR>
    nnoremap ghe        wb"zye:call EditFilePrefix('<C-R>z',".h")<CR>

    " inline files
    nnoremap gis        wb"zye:call SplitFilePrefix(expand("%:r"),".inl")<CR>
    nnoremap gie        wb"zye:call EditFilePrefix(expand("%:r"),".inl")<CR>

    " Open man page of word under cursor
    nnoremap gm         wb"zye:!man '<C-R>z'<CR>

    " Open man page of word under cursor -- gl specific
    nnoremap gl         wb"zye:call ManOpenGL('<C-R>z')<CR>

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    "vnoremap . :normal .<CR>

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Inserts the path of the currently edited file into a command
    " Command mode: Ctrl+P
    " (stolen from Janus)
    cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

    " Shift key fixes {
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    " }

    " Code folding {
        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>
        nmap <leader>f3 :set foldlevel=3<CR>
        nmap <leader>f4 :set foldlevel=4<CR>
        nmap <leader>f5 :set foldlevel=5<CR>
        nmap <leader>f6 :set foldlevel=6<CR>
        nmap <leader>f7 :set foldlevel=7<CR>
        nmap <leader>f8 :set foldlevel=8<CR>
        nmap <leader>f9 :set foldlevel=9<CR>
    " }
" }

" Plugin Customizations {
    " prettier {
        let g:prettier#quickfix_enabled = 0
        let g:prettier#autoformat = 0

        au BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html Prettier
    " }

    " Misc {
        let g:NERDShutUp=1
        let b:match_ignorecase = 1
    " }

    " Tabularize {
        map! <leader>a= :Tabularize /=<CR>
        map  <leader>a= :Tabularize /=<CR>
        map! <leader>a: :Tabularize /:<CR>
        map  <leader>a: :Tabularize /:<CR>
    " }

    " nodejs-autocomplete {
        " automatically open and close the popup menu for nodejs autocompletion
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    " }

    " NERDTree {
        " automatically open NERDTree when vim starts if no files were specified
        au vimenter * if !argc() | NERDTree | endif

        map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map ,e :NERDTreeFind<CR>
        nmap ,nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let NERDTreeHijackNetrw=1
        let NERDTreeUseTCD=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }

    " OmniComplete {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " Some convenient mappings
        inoremap <expr> <Esc>      pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
        inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " Automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }

    " ctrlp {
        let g:ctrlp_working_path_mode = 'ra'
        "nnoremap <silent> <c-t> :CtrlP<CR>
        "nnoremap <silent> <c-r> :CtrlPMRU<CR>
        let g:ctrlp_map = '<c-p>'
        let g:ctrlp_cmd = 'CtrlP'

        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

        " On Windows use "dir" as fallback command.
        if has('win32') || has('win64')
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': 'dir %s /-n /b /s /a-d'
            \ }
        else
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': 'find %s -type f'
            \ }
        endif

        " CtrlP auto cache clearing.
        " ----------------------------------------------------------------------------
        function! SetupCtrlP()
            if exists("g:loaded_ctrlp") && g:loaded_ctrlp
                augroup CtrlPExtension
                autocmd!
                autocmd FocusGained  * CtrlPClearCache
                "autocmd BufWritePost * CtrlPClearCache
                augroup END
            endif
        endfunction

        if has("autocmd")
            autocmd VimEnter * :call SetupCtrlP()
        endif
    "}

    " PythonMode {
        " Disable if python support not present
        if !has('python')
            let g:pymode = 1
        endif
    " }

    " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>:GitGutter<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        nnoremap <silent> <leader>gg :GitGutterToggle<CR>
    "}

    " neocomplcache {
        let g:acp_enableAtStartup = 0
        let g:neocomplcache_enable_at_startup = 1
        let g:neocomplcache_enable_camel_case_completion = 1
        let g:neocomplcache_enable_smart_case = 1
        let g:neocomplcache_enable_underbar_completion = 1
        let g:neocomplcache_enable_auto_delimiter = 1
        let g:neocomplcache_max_list = 15
        let g:neocomplcache_force_overwrite_completefunc = 1
        let g:neocomplcache_temporary_dir = "$HOME/.vim/tmp/neocomplcache"

        " SuperTab like snippets behavior.
        imap <silent><expr><TAB> neosnippet#expandable() ?
                    \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                    \ "\<C-e>" : "\<TAB>")
        smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

        " Define dictionary.
        let g:neocomplcache_dictionary_filetype_lists = {
                    \ 'default' : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }

        " Define keyword.
        if !exists('g:neocomplcache_keyword_patterns')
            let g:neocomplcache_keyword_patterns = {}
        endif
        let g:neocomplcache_keyword_patterns._ = '\h\w*'

        " Plugin key-mappings {
            " These two lines conflict with the default digraph mapping of <C-K>
            " If you prefer that functionality, add the following to your
            " .vimrc.before.local file:
            "   let g:spf13_no_neosnippet_expand = 1
            if !exists('g:spf13_no_neosnippet_expand')
                imap <C-k> <Plug>(neosnippet_expand_or_jump)
                smap <C-k> <Plug>(neosnippet_expand_or_jump)
            endif

            inoremap <expr><C-g> neocomplcache#undo_completion()
            inoremap <expr><C-l> neocomplcache#complete_common_string()
            inoremap <expr><CR> neocomplcache#complete_common_string()

            " <TAB>: completion.
            inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
            inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

            " <CR>: close popup
            " <s-CR>: close popup and save indent.
            inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
            inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

            " <C-h>, <BS>: close popup and delete backword char.
            inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
            inoremap <expr><C-y> neocomplcache#close_popup()
        " }

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        "autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
        autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

        " Haskell post write lint and check with ghcmod
        " $ `cabal install ghcmod` if missing and ensure
        " ~/.cabal/bin is in your $PATH.
        if !executable("ghcmod")
            autocmd BufWritePost *.hs GhcModCheckAndLintAsync
        endif

        " Enable heavy omni completion.
        if !exists('g:neocomplcache_omni_patterns')
            let g:neocomplcache_omni_patterns = {}
        endif
        let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
        "let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

        " Use honza's snippets.
        let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

        " Enable neosnippet snipmate compatibility mode
        let g:neosnippet#enable_snipmate_compatibility = 1

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        " Disable the neosnippet preview candidate window
        " When enabled, there can be too much visual noise
        " especially when splits are used.
        set completeopt-=preview
    " }

    " GitGutter {
        let g:gitgutter_realtime = 0
        set shell=/bin/bash
    " }

    " Syntastic {
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*

        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 0
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
        let g:syntastic_javascript_checkers = ['eslint']
        let g:jsx_ext_required = 0 " Allow jsx in normal js files

        let g:syntastic_python_checkers = ['python3']
    " }
" }

" Custom Methods {
    " automatically compile %.less to %.css on write
    function! LessCSSCompress()
      let cwd  = expand('%:p:h')
      let name = expand('%:t:r')

      if (executable('lessc'))
        call system('lessc '.cwd.'/'.name.'.less > '.cwd.'/'.name.'.css &')
      endif
    endfunction

    " load files relative to current path by switching to the directory of the
    " current file
    au BufEnter * :call CdCurFile()
    function! CdCurFile()
       exec "lcd " substitute(expand("%:p:h"), " ", "\\ ", "g")
    endfunction

    """"""" Returns the "pair file name" for the current buffer, e.g.
    """"""" if editing "foo.cpp" returns "foo.h" and vice versa
    function GetPairFileName()
      let root = expand("%:r")
      let ext = expand("%:e")
      let newExt = "cs"
      if ext == "cpp" || ext == "cs" || ext == "c" || ext == "inl" || ext == "C"
         if filereadable(root.".h")
            let newExt = "h"
         elseif filereadable(root.".H")
            let newExt = "H"
         endif
      elseif ext == "h" || ext == "H"
         if filereadable(root.".cpp")
            let newExt = "cpp"
         elseif filereadable(root.".cs")
            let newExt = "cs"
         elseif filereadable(root.".c")
            let newExt = "c"
         elseif filereadable(root.".C")
            let newExt = "C"
         elseif filereadable(root.".m")
            let newExt = "m"
         endif
      elseif ext == "vert"
         let newExt = "frag"
      elseif ext == "frag"
         let newExt = "vert"
      elseif ext == "vp"
         let newExt = "fp"
      elseif ext == "fp"
         let newExt = "vp"
      elseif ext == "m"
         let newExt = "h"
      endif
      let file = root.".".newExt
      return file
    endfunction

    function SplitFile(file)
      exe ":sp" a:file
    endfunction

    function EditFile(file)
      if bufexists(a:file)
         exe ":b" a:file
      else
         exe ":e" a:file
      endif
    endfunction

    """"""" Edits the "pair file" as described above.  Uses :b if the
    """"""" Edits buffer already exists, else :e.  This ensures that we will go to
    """"""" Edits the line we were editing before if possible.
    function SplitPairFile()
      let file = GetPairFileName()
      call SplitFile(file)
    endfunction

    """"""" Edits the "pair file" as described above.  Uses :b if the
    """"""" Edits buffer already exists, else :e.  This ensures that we will go to
    """"""" Edits the line we were editing before if possible.
    function EditPairFile()
      let file = GetPairFileName()
      call EditFile(file)
    endfunction

    function EditFilePrefix(prefix, suffix)
      let file = a:prefix.a:suffix
      echo file
      call EditFile(file)
    endfunction

    function SplitFilePrefix(prefix, suffix)
      let file = a:prefix.a:suffix
      echo file
      call SplitFile(file)
    endfunction

    " display results of a command in a new window
    function ExecuteCommandInNewWindow(aCommand)
        execute "new"
        execute ":setlocal buftype=nowrite"
        execute ":setlocal bufhidden=delete"
        execute ":setlocal noswapfile"
        let cmd = ":.!".a:aCommand
        echo cmd
        execute cmd
    endfunction

    " googles the given string
    function Google(aString)
        let aUrl = "w3m -dump \"http://www.google.com/search?q=" . a:aString . "\""
        echo aUrl
        call ExecuteCommandInNewWindow(aUrl)
    endfunction

    " searches the official OpenGL docs
    "
    " Ex. for glClearDepth
    " http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/cleardepth.html
    function ManOpenGL(aString)
        if match(a:aString, "glu") == 0
            let prefixStr = "glu"
            let str = tolower(strpart(a:aString, 3))
        elseif match(a:aString, "gl") == 0
            let prefixStr = "gl"
            let str = tolower(strpart(a:aString, 2))
        else
            echo "Unable to find " . a:aString
            return
        endif
        let aUrl = "w3m -dump \"http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/".prefixStr."/".str.".html\""
        call ExecuteCommandInNewWindow(aUrl)
    endfunction
" }

" Notes {
    " search for expr only in lines > 27
    " /\%>27lexpr

    "converts .less to .css (lessc required)
    "nnoremap ,m :w <BAR> !lessc % > %:t:r.css<CR><space>
    "
    " zR opens all folds
    " zM closes all folds
" }

