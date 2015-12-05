" zR opens all folds

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
    
    set tabstop=4 shiftwidth=4 softtabstop=4
    
    fun! <SID>StripTrailingWhitespaces()
        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    
    autocmd FileType javascript,html,css,less autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
    autocmd FileType javascript,html,css,less set tabstop=2 shiftwidth=2 softtabstop=2
    
    set sm                      " show matching parenthesis
    set ai sm
    
    set expandtab               " force tabs to use spaces instead of \t
    set smartindent             " indent on enter according to previous line's format
    
    set autowrite               " auto-write file when switching files with :e
    
    set mouse=a
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    
    " fix unclosed paren indents, switch indents, and public/private indents
    set cinoptions+=:1s,l1,g1s,h1s,(0,u0,W1s
    
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
            
            if has('gui_macvim')
                set transparency=5  " Make the window slightly transparent
            endif
        else
            if &term == 'xterm' || &term == 'screen'
                set t_Co=256        " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
            endif
            "set term=builtin_ansi  " Make arrow and other keys work
        endif
    " }
" }

" FileTypes {
    au FileType C,H,c,cc,cpp,h,pde,java,pl,cs,m set formatoptions=croql cindent
    au FileType py  set tabstop=4 shiftwidth=4 softtabstop=4
    au FileType pde,cs,m,h  set tabstop=4 shiftwidth=4 softtabstop=4

    " Automatically enable GLSL syntax highlighting
    au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
    ":au! FileType python setl nosmartindent
    au BufRead *.py inoremap # X<c-h>#

    au FileWritePost,BufWritePost *.less :call LessCSSCompress()
    au BufNewFile,BufRead *.less set filetype=less
    
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
" }
