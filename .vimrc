" windows-specific settings
set gfn=Courier\ New:h12:b:cANSI
"source $VIMRUNTIME/mswin.vim
"behave mswin

"set guioptions=em
"set showtabline=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2

" note - make selection in visual mode, then type +y to copy to X11 buffer

" convert a file to HTML!!!
" gvim -f +"syn on" +"run! syntax/2html.vim" +"wq" +"q" main.cpp

autocmd FileWritePost,BufWritePost *.less :call LessCSSCompress()
autocmd BufNewFile,BufRead *.less set filetype=css
autocmd BufNewFile,BufRead *.less.template set filetype=css

" automatically compile %.less to %.css on write
function! LessCSSCompress()
  let cwd  = expand('%:p:h')
  let name = expand('%:t:r')
  
  "execute '!clear; echo '.cwd.' '.name
  
  if (executable('lessc'))
    cal system('lessc '.cwd.'/'.name.'.less > '.cwd.'/'.name.'.css &')
  endif
endfunction

filetype plugin on

:set tabstop=4 shiftwidth=4 softtabstop=4

" show matching parenthesis
set sm
" force tabs to use spaces instead of \t
set expandtab
" indent on enter according to previous line's format
set smartindent
" color :)
syntax on
" incremental search-as-you-type
"set incsearch
" highlight search terms
set hlsearch
" auto-write file when switching files with :e
set autowrite
" enable mouse support for all modes
"    On some windowing systems, this requires you to use 'Shift' plus 
" the mouse to use the window manager's clipboard.
set mouse=a

set ai sm

":inoremap # #

:autocmd FileType C,H,c,cc,cpp,h,pde,java,pl,cs,m set formatoptions=croql cindent
:autocmd FileType py  set tabstop=4 shiftwidth=4 softtabstop=4
:autocmd FileType pde,cs,m,h  set tabstop=4 shiftwidth=4 softtabstop=4

" Automatically enable GLSL syntax highlighting
:au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
":au! FileType python setl nosmartindent
:autocmd BufRead *.py inoremap # X<c-h>#

:abbr #d #define
:abbr #i #include
:abbr #b /* ------------------------------------------------
:abbr #e   ------------------------------------------------ */

:let html_use_css=1

"map! <F10> <Esc>:setlocal spell spelllang=en_us<CR><CR>
"map! <F11> <Esc>:setlocal nospell<CR><CR>
map! <F8>  <Esc>:w<CR>
map  <F8>  <Esc>:w<CR>

if has('unix')
    let s:sep='/' 				" path separator
    map! <F7>  <Esc>:!clear && python -i '%:p'<CR>
    map  <F7>  <Esc>:!clear && python -i '%:p'<CR>
else " windows
    let s:sep='\'
    map! <F7>  <Esc>:call CompileCSProj('msb')<CR>
    map  <F7>  <Esc>:call CompileCSProj('msb')<CR>
    map! <F6>  <Esc>:call CompileCSProj('msbw')<CR>
    map  <F6>  <Esc>:call CompileCSProj('msbw')<CR>
    map! <F9>  <Esc>:call DoEdit()<CR>
    map  <F9>  <Esc>:call DoEdit()<CR>
    
    nnoremap msb          <Esc>:call CompileCSProj('msb')<CR>
    nnoremap msbw         <Esc>:call CompileCSProj('msbw')<CR>
    
    set shell=\"%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe\ -nologo\ -noexit\"
endif

" Sane indentation in insert mode!!!
map! <CR>  <CR><up><down>
:set cpo+=I


" highlight current line
"set cursorline term=ansi ctermbg=4
"set showcmd

set wildmenu
set wildmode=longest,full
set wildignore=*.o

" fix pasting so you don't get the step down effect
":set invpaste paste?
"map <C-Z> :shell

" disable vi-compabibility support
set nocompatible

" Automatically chmod +x Shell and Perl scripts
"au BufWritePost   *.sh             !chmod +x %
"au BufWritePost   *.pl             !chmod +x %


" fix unclosed paren indents, switch indents, and public/private indents
" -- awesome for aligning function arguments -- tfischer
:set cinoptions+=:1s,l1,g1s,h1s,(0,u0,W1s


" if possible (vague definition), break lines at 80 characters!!
" after a ';'
noremap format     :%s/.\{,79\};\s*\|.\{,79\}\s\+/&\r/g


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


"nnoremap json  <ESC>:%s/,\s*$/;/g<CR>gg=G:%s/;$/, /g<CR>
"nnoremap =   <ESC>:%s/,\s*$/;/g<CR>gg=G:%s/;$/,/g<CR>

":nmap \x :call GetMemberVar()<CR>:exe "/" . Name<CR>
"
"map <F10> <Esc>/^%changelog<CR>:r!date +"* \%a \%b \%e \%Y Lars R. Damerow <lars@pixar.com> "<CR>A

":function GetInput(str)
":  call inputsave()
":  let result = input(a:str)
":  call inputrestore()
":  return result
"endfunction


"nnoremap gm         wb"zye:call ExecuteCommandInNewWindow("man <C-R>z")<CR>

"nnoremap gd         :call CdCurFile()<CR>
"nnoremap gs         :tabedit %<CR>
"nnoremap gmf        wb"zye:call FindMelHelp('<C-R>z')<CR>
"nnoremap gmm        wb"zye:call OpenMelHelp('<C-R>z')<CR>


" search for expr only in lines > 27
" /\%>27lexpr
" 
" ye -> copy til end of word :)
" yw -> copy til one char past end of word


" silent (no annoying beep, hurray!)
:set vb t_vb=".
" Maki GUI File Open use current directory
:set browsedir=buffer

"
" custom methods
"

function! CompileCSProj(buildtool)
    let csproj = GetCSProj()
    let str = a:buildtool.' '.csproj
    "echo str
    execute "!clear; echo ".str."; ".str
    "call system(str)
endfunction

function! DoEdit()
    let name = expand("%")
    let str = "sd edit ".name
    execute "!clear; echo \"".str."\"; ".str
endfunction

" extract most likely name of .csproj from current directory name
function! GetCSProj()
    return expand("%:p:h") . "\\" . expand("%:p:h:t") . ".csproj"
endfunction

" load files relative to current path by switching to the directory of the
" current file 
:autocmd BufEnter * :call CdCurFile()
:function! CdCurFile()
:   exec "lcd " substitute(expand("%:p:h"), " ", "\\ ", "g")
:endfunction


""""""" Returns the "pair file name" for the current buffer, e.g.
""""""" if editing "foo.cpp" returns "foo.h" and vice versa
:function GetPairFileName()
:  let root = expand("%:r")
:  let ext = expand("%:e")
:  let newExt = "cs"
:  if ext == "cpp" || ext == "cs" || ext == "c" || ext == "inl" || ext == "C"
:     if filereadable(root.".h")
:        let newExt = "h"
:     elseif filereadable(root.".H")
:        let newExt = "H"
:     endif
:  elseif ext == "h" || ext == "H"
:     if filereadable(root.".cpp")
:        let newExt = "cpp"
:     elseif filereadable(root.".cs")
:        let newExt = "cs"
:     elseif filereadable(root.".c")
:        let newExt = "c"
:     elseif filereadable(root.".C")
:        let newExt = "C"
:     elseif filereadable(root.".m")
:        let newExt = "m"
:     endif
:  elseif ext == "vert"
:     let newExt = "frag"
:  elseif ext == "frag"
:     let newExt = "vert"
:  elseif ext == "vp"
:     let newExt = "fp"
:  elseif ext == "fp"
:     let newExt = "vp"
:  elseif ext == "m"
:     let newExt = "h"
:  endif
:  let file = root.".".newExt
:  return file
:endfunction

"" Note:
"" :<C-R><C-W>  inserts current word in ':' command line
""              (very useful for searching)


:function SplitFile(file)
:  exe ":sp" a:file
:endfunction

:function EditFile(file)
:  if bufexists(a:file)
:     exe ":b" a:file
:  else
:     exe ":e" a:file
:  endif
:endfunction



""""""" Edits the "pair file" as described above.  Uses :b if the
""""""" Edits buffer already exists, else :e.  This ensures that we will go to
""""""" Edits the line we were editing before if possible.
:function SplitPairFile()
:  let file = GetPairFileName()
:  call SplitFile(file)
:endfunction

""""""" Edits the "pair file" as described above.  Uses :b if the
""""""" Edits buffer already exists, else :e.  This ensures that we will go to
""""""" Edits the line we were editing before if possible.
:function EditPairFile()
:  let file = GetPairFileName()
:  call EditFile(file)
:endfunction

:function EditFilePrefix(prefix, suffix)
:  let file = a:prefix.a:suffix
:  echo file
:  call EditFile(file)
:endfunction

:function SplitFilePrefix(prefix, suffix)
:  let file = a:prefix.a:suffix
:  echo file
:  call SplitFile(file)
:endfunction

"
" function to open the maya help in a view
"
:function OpenMelHelp(aMelCommand)
:    execute "new " . a:aMelCommand
:    execute ":setlocal buftype=nowrite"
:    execute ":setlocal bufhidden=delete"
:    execute ":setlocal noswapfile"
:    execute ":.! w3m -dump \"http://maya6docs.pixar.com/Maya6.0/en_US/Commands/" . a:aMelCommand . ".html\""
:endfunction

"
" function to find the maya help in a view
"
:function FindMelHelp(aMelSubstring)
:    execute "new " . a:aMelSubstring
:    execute ":setlocal buftype=nowrite"
:    execute ":setlocal bufhidden=delete"
:    execute ":setlocal noswapfile"
:    execute ":.! w3m -dump \"http://mayadocs.pixar.com/Maya5.0/en_US/Commands/index_substring.html?" . a:aMelSubstring
:endfunction

"
" function to display results of a command in a new window
"
:function ExecuteCommandInNewWindow(aCommand)
:    execute "new"
:    execute ":setlocal buftype=nowrite"
:    execute ":setlocal bufhidden=delete"
:    execute ":setlocal noswapfile"
:    let cmd = ":.!".a:aCommand
:    echo cmd
:    execute cmd
:endfunction

"
" function to run google
"
:function Google(aString)
:    let aUrl = "w3m -dump \"http://www.google.com/search?q=" . a:aString . "\""
:    echo aUrl
:    call ExecuteCommandInNewWindow(aUrl)
:endfunction

"
" function to search for official OpenGL docs
" 
" Ex. for glClearDepth
" http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/cleardepth.html
"
:function ManOpenGL(aString)
:    if match(a:aString, "glu") == 0
:        let prefixStr = "glu"
:        let str = tolower(strpart(a:aString, 3))
:    elseif match(a:aString, "gl") == 0
:        let prefixStr = "gl"
:        let str = tolower(strpart(a:aString, 2))
:    else
:        echo "Unable to find " . a:aString
:        return
:    endif
:    let aUrl = "w3m -dump \"http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/".prefixStr."/".str.".html\""
:    call ExecuteCommandInNewWindow(aUrl)
:endfunction

"
" source plugins
"    matchit allows matching of html/php tags
"
source $VIMRUNTIME/macros/matchit.vim

" If PowerShell is installed on the machine then set it up as the shell
let s:powershell_path = $windir.'\system32\WindowsPowerShell\v1.0\powershell.exe'  
if filereadable(s:powershell_path)
    exe "set shell=".s:powershell_path
    set shellcmdflag="-Command - " 
endif

" Automatically check RO files out from SD
"au FileChangedRO * call AutoCheckout()

"function AutoCheckout() 
"    if (confirm("Checkout?", "&Yes\n&No", 1) == 1) 
"        call SDCheckOut()
"
"        " Checking out the file causes it to be reloaded, but BufRead
"        " does not automatically happen for some reason causing us to
"        " loose syntax highlighting, etc.  Force it.
"        doautocmd BufRead
"    endif 
"endfunction

" Mapping file extensions to known types
au BufRead,BufNewFile *.*proj                setfiletype xml
au BufRead,BufNewFile *.xaml                 setfiletype xml
au BufRead,BufNewFile *.targets              setfiletype xml
au BufRead,BufNewFile *.sg                   setfiletype cs
au BufRead,BufNewFile *.csi                  setfiletype cs
au BufRead,BufNewFile *.pde                  setfiletype java
au BufRead,BufNewFile *.ps1                  setfiletype ps1

" Some plugins are failing to autoload:
"source $home/vimfiles/plugin/a.vim
"source $home/vimfiles/plugin/cscomment.vim
"source $home/vimfiles/plugin/taglist.vim

" Options for minibufexpl.vim
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1

" Don't write *.tmp files into the area where I am working
set dir=/tmp

" System vimrc file for Mac OS X
" Author:  Benji Fisher <benji@member.AMS.org>
" Last modified:  8 May 2006

" TODO:  Is there a better way to tell that Vim.app was started from Finder.app?
" Note:  Do not move this to the gvimrc file, else this value of $PATH will
" not be available to plugin scripts.
if has("gui_running") && system('ps xw | grep "Vim -psn" | grep -vc grep') > 0
  " Get the value of $PATH from a login shell.
  " If your shell is not on this list, it may be just because we have not
  " tested it.  Try adding it to the list and see if it works.  If so,
  " please post a note to the vim-mac list!
  if $SHELL =~ '/\(sh\|csh\|bash\|tcsh\|zsh\)$'
    let s:path = system("echo echo VIMPATH'${PATH}' | $SHELL -l")
    let $PATH = matchstr(s:path, 'VIMPATH\zs.\{-}\ze\n')
  endif
endif
