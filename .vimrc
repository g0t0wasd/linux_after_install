set nocompatible     " required

so ~/.vim/plugins.vim

let mapleader = ','

set nomodeline

"--------- Graphics --------"
set nu
set t_CO=256
syntax on
set ruler
set completeopt-=preview
set backspace=indent,eol,start

set ls=2
set incsearch
set hlsearch

colorscheme gruvbox

if has("gui_running")
    set lines=40 columns=150
endif

" прячем панельки
"set guioptions-=m   " меню
set guioptions-=T    " тулбар
set guioptions-=r    " скроллбары
set guioptions-=l    " скроллбары
set guioptions-=L    " скроллбары
set guioptions-=R    " скроллбары
set guioptions-=e    " gui tabs


" отключаем бэкапы и своп-файлы
set nobackup 	     " no backup files
set nowritebackup    " only in case you don't want a backup file while editing
set noswapfile 	     " no swap files

" отключаем пищалку и мигание
set visualbell t_vb= 
set novisualbell     

"  при переходе за границу в 80 символов в Ruby/Python/js/C/C++ подсвечиваем на темном фоне текст
augroup vimrc_autocmds
    autocmd!
    autocmd FileType ruby,python,javascript,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType ruby,python,javascript,c,cpp match Excess /\%80v.*/
    autocmd FileType ruby,python,javascript,c,cpp set nowrap
augroup END



"=====================================================
" Languages support
"=====================================================
" --- Python ---
autocmd FileType python set completeopt-=preview " раскомментируйте, в случае, если не надо, чтобы jedi-vim показывал документацию по методу/классу
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" --- JavaScript ---
let javascript_enable_domhtmlcss=1
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd BufNewFile,BufRead *.json setlocal ft=javascript

" --- HTML ---
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" --- template language support (SGML / XML too) ---
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd bufnewfile,bufread *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
let html_no_rendering=1
let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'
autocmd FileType html,htmldjango,htmljinja,eruby,mako let b:closetag_html_style=1
"autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako source ~/.vim/scripts/closetag.vim

" --- CSS ---
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4



"--------- Splits --------"
set splitbelow
set splitright

"split navigations
map <c-J> <C-W><C-J>
map <c-K> <C-W><C-K>
map <c-L> <C-W><C-L>
map <c-H> <C-W><C-H>


"--------- Mappings --------"
" Сохранение
map <C-s> :w<CR> " CTRL+S - сохранить файл

" Новый таб
map <C-t> :tabnew<CR>

map <Leader><space> :nohlsearch<cr>


"--------- Flake 8 settings --------"
autocmd BufWritePost *.py call Flake8()  " check for errors on file close
let g:flake8_max_markers=50  " (default)



"--------- CtrlP settings --------"
"let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
"if executable('ag')
"  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"endif

" NerdTree настройки
" показать NERDTree на F3
map <F3> :NERDTreeToggle<CR>
"игноррируемые файлы с расширениями
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']

" Gruvbox settings
set background=dark
let g:gruvbox_contrast_dark='soft'
