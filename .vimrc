set nocompatible " required
" set rtp=~/.vim,/var/lib/vim/addons,/usr/share/vim/vim81 " explicitly provide runtime path

"=====================================================
" Vundle settings
"=====================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'		" let Vundle manage Vundle, required


"--- Code/project navigation ---
Plugin 'scrooloose/nerdtree' 	    	" Project and file navigation
" --- Languages support ---
Plugin 'nvie/vim-flake8'
Plugin 'mattn/emmet-vim'		" Emmet for VIM
call vundle#end()            		" required

" --- Color scheme ---
" set t_CO=256 " color scheme support


set background=dark
colorscheme gruvbox
" set termguicolors
let g:gruvbox_contrast_dark='soft'
syntax on " syntax highlighting

set expandtab " convert tabs to spaces
set tabstop=4 " indent using four spaces
set smarttab " insert tabstop number of spaces on tab key press

" --- Search Options ---
set hlsearch " enable search highlighting
set incsearch " incremental search that shows partial matches

" --- User Interface Options ---
if has("gui_running")
    set lines=30 columns=120
endif
set laststatus=2 " always display status bar
set ruler " always show cursor position
set cursorline " highlight the line currently under cursor
set relativenumber " show relative line number
set nu " show number
set colorcolumn=80 " color line at 80 line
set title " set window's title as a current file
set spelllang=en
set spell
set backspace=indent,eol,start

set guioptions-=m " hide menu
set guioptions-=T " hide toolbar
set guioptions-=r " hide right scrollbar
set guioptions-=l " hide left scrollbar
set guioptions-=L " hide scrollbar
set guioptions-=R " hide scrollbar
set guioptions-=e " hide gui tabs
set noshowmode    " hide default mode indicator (--INSERT--, --VISUAL--)

" --- Turn off backups and swaps

set nobackup
set nowritebackup
set noswapfile

" --- Turn off bells and blinks
set visualbell t_vb=
set novisualbell


"=====================================================
" Languages support
"=====================================================
" --- Python ---
augroup python
        autocmd FileType python set completeopt-=preview " раскомментируйте, в случае, если не надо, чтобы jedi-vim показывал документацию по методу/классу
        autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
        \ formatoptions+=croq softtabstop=4 smartindent
        \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
        autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" --- JavaScript ---
augroup javascript
        let javascript_enable_domhtmlcss=1
        autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
        autocmd BufNewFile,BufRead *.json setlocal ft=javascript
augroup END

" --- template language support (SGML / XML too) ---
augroup templates
        autocmd FileType html,xhtml,xml,htmldjango,htmljinja setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
        autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
        autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=pythonlet html_no_rendering=1
        let g:closetag_default_xml=1
        let g:sparkupNextMapping='<c-l>'
        autocmd FileType html,htmldjango,htmljinja let b:closetag_html_style=1
        " autocmd FileType html,xhtml,xml,htmldjango,htmljinja source ~/.vim/scripts/closetag.vim
augroup END

" --- CSS ---
augroup css
        autocmd FileType css set omnifunc=csscomplete#CompleteCSS
        autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
augroup END

" --- Splits ---
set splitbelow
set splitright

" --- Mappings ---

" leader character
let mapleader = ","

" Don't use arrows
nnoremap <down> <nop>
nnoremap <up> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap <down> <nop>
inoremap <up> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Split navigations
nnoremap <c-J> <C-W><C-J>
nnoremap <c-K> <C-W><C-K>
nnoremap <c-L> <C-W><C-L>
nnoremap <c-H> <C-W><C-H>

" New tab
nnoremap <leader>t :tabnew<CR>

" Save
nnoremap <leader>s :w<CR>

" Unhighlight
nnoremap <leader><space> :nohlsearch<CR>

" Copy paste
noremap <leader>y "+y
noremap <leader>p "+p

" Comment / uncomment
augroup commenting
        autocmd FileType c,cpp     let b:comment_leader = '// '
        autocmd FileType sh,python let b:comment_leader = '# '
        autocmd FileType vim       let b:comment_leader = '" '
        noremap <silent> <Leader>cc :<C-B>silent <C-E>s/^\(\s*\)/\1<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
        noremap <silent> <Leader>cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>/\1/e<CR>:nohlsearch<CR>
augroup END

" Tabs navigation
noremap <leader>1 1gt<CR>
noremap <leader>2 2gt<CR>
noremap <leader>3 3gt<CR>
noremap <leader>4 4gt<CR>
noremap <leader>5 5gt<CR>
noremap <leader>6 6gt<CR>
noremap <leader>7 7gt<CR>
noremap <leader>8 8gt<CR>
noremap <leader>9 9gt<CR>


" Flake 8 autocheck
autocmd BufWritePost *.py call flake8#Flake8()


" NerdTree settings
" show NERDTree on F3
map <F3> :NERDTreeToggle<CR>
" open NERDTree for current dir
map <leader>f :NERDTreeFind<CR>
" file types to ignore
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']  

" Auto change the directory to the current file I'm working on
autocmd BufEnter * lcd %:p:h 



" Session saving
" Automatically save / rewrite the session when leaving Vim
augroup leave
        autocmd VimLeave * mksession! ~/.vim/session.vim
augroup END

" use ++nested to allow automatic file type detection and such
autocmd VimEnter * nested call <SID>load_session()

function! s:load_session()
    " save curdir and arglist for later
    let l:cwd = getcwd()
    let l:args = argv()
    " source session
    silent source ~/.vim/session.vim
    "restore curdir (otherwise relative paths may change)
    " call chdir(l:cwd)
    execute 'cd' fnameescape(l:cwd)
    " open all args
    for l:file in l:args
        execute 'tabnew' l:file
    endfor
    " add args to our arglist just in case
    " execute 'argadd' join(l:args)
endfunction

" Statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  let b:gitstatus = strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

autocmd VimEnter,BufEnter,FileType * call StatuslineGit() "sets branch name on vim start, new buffer open and for quickfix window

" Automatically change the statusline color depending on mode

" augroup coloring
    " autocmd VimEnter * hi NormalColor guifg=Black guibg=Green ctermbg=46 ctermfg=0
    " autocmd VimEnter * hi InsertColor guifg=Black guibg=Cyan ctermbg=51 ctermfg=0
    " autocmd VimEnter * hi ReplaceColor guifg=Black guibg=maroon1 ctermbg=165 ctermfg=0
    " autocmd VimEnter * hi VisualColor guifg=Black guibg=Orange ctermbg=202 ctermfg=0
" augroup END

hi NormalColor guifg=Black guibg=Green ctermbg=46 ctermfg=0
hi InsertColor guifg=Black guibg=Cyan ctermbg=51 ctermfg=0
hi ReplaceColor guifg=Black guibg=maroon1 ctermbg=165 ctermfg=0
hi VisualColor guifg=Black guibg=Orange ctermbg=202 ctermfg=0

set ssop-=options

let g:modeMap={
    \ "\<C-V>" : 'cv'
    \}
set laststatus=2
set statusline=
set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#InsertColor#%{(mode()==?'i')?'\ \ INSERT\ ':''}
set statusline+=%#ReplaceColor#%{(mode()==?'R')?'\ \ RPLACE\ ':''}
set statusline+=%#VisualColor#%{(mode()==#'v')?'\ \ VISUAL\ ':''}
set statusline+=%#VisualColor#%{(mode()==#'V')?'\ \ V-LINE\ ':''}
set statusline+=%#VisualColor#%{(mode()=='\<C-V>')?'\ \ V-BLOCK\ ':''}
set statusline+=%#CursorIM#     " colour
set statusline+=%(%{b:gitstatus}%)                      " git branch
set statusline+=%4*\ %<%F%*                             "full path
set statusline+=%4*\%m                        " modified [+] flag
set statusline+=%4*%=                          " right align
set statusline+=%8*\ %y\                                 " FileType
set statusline+=%7*\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}] " Encoding & Fileformat
set statusline+=%#Cursor#       " colour
set statusline+=\ %l:\%c\ %L\            " Rownumber: colnumber total rows
