syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab " convert tabs to spaces
set smartindent
set nu relativenumber
set clipboard=unnamedplus " copy paste between VIM and other windows
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set cursorline
set noshowmode    " hide default mode indicator (--INSERT--, --VISUAL--)
set guioptions-=m " hide menu
set guioptions-=T " hide toolbar
set guioptions-=r " hide right scrollbar
set guioptions-=l " hide left scrollbar
set guioptions-=L " hide scrollbar
set guioptions-=R " hide scrollbar
set guioptions-=e " hide gui tabs

set colorcolumn=80
highlight Colorcolumn ctermbg=0 guibg=grey

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'junegunn/fzf', {'do': { -> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'mbbill/undotree'
Plug 'nvie/vim-flake8'

call plug#end()

colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='soft'

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:ctrlp_user_command = ['.git/', 'git --git-dif=%s/.git ls-files -oc --exclude-standard']

let mapleader = " "
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" ag is fast enoug that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<SPACE>
nnoremap <silent><leader>+ :vertical resize +5<CR>
nnoremap <silent><leader>- :vertical resize -5<CR>

nnoremap <silent><leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent><leader>gf :YcmCompleter FixIt<CR>

" Comment / uncomment
augroup commenting
        autocmd FileType c,cpp     let b:comment_leader = '// '
        autocmd FileType sh,python let b:comment_leader = '# '
        autocmd FileType vim       let b:comment_leader = '" '
        noremap <silent> <Leader>cc :<C-B>silent <C-E>s/^\(\s*\)/\1<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
        noremap <silent> <Leader>cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>/\1/e<CR>:nohlsearch<CR>
augroup END

" --- Splits ---
set splitbelow splitright

" Change 2 split windows from vert to horiz or vice versa
map <Leader>th <C-W>t<C-W>H
map <Leader>tk <C-W>t<C-W>K

" Friendly split resizing

noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>

noremap <silent> <C-Down> :resize -3<CR>

" Allow passing optional flags into the Rg command.
"   Example: :Rg myterm -g '*.md'
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \ "rg --column --line-number --no-heading --color=always --smart-case " .
  \ <q-args>, 1, fzf#vim#with_preview(), <bang>0)


" Flake 8 autocheck
autocmd BufWritePost *.py call flake8#Flake8()

" Statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  if strlen(l:branchname) > 15
      let l:branchname = l:branchname[:15] . "..."
  endif
  let b:gitstatus = strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

autocmd VimEnter,BufEnter,FileType * call StatuslineGit() "sets branch name on vim start, new buffer open and for quickfix window

hi NormalColor guifg=Black guibg=Green ctermbg=34 ctermfg=0
hi InsertColor guifg=Black guibg=Cyan ctermbg=44 ctermfg=0
hi ReplaceColor guifg=Black guibg=maroon1 ctermbg=165 ctermfg=0
hi VisualColor guifg=Black guibg=Orange ctermbg=202 ctermfg=0
hi CommandColor guifg=White guibg=Black ctermbg=12 ctermfg=11
hi DelimiterColor ctermbg=7 ctermfg=0


set laststatus=2
set statusline=
set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#InsertColor#%{(mode()==?'i')?'\ \ INSERT\ ':''}
set statusline+=%#ReplaceColor#%{(mode()==?'R')?'\ \ RPLACE\ ':''}
set statusline+=%#VisualColor#%{(mode()==#'v')?'\ \ VISUAL\ ':''}
set statusline+=%#VisualColor#%{(mode()==#'V')?'\ \ V-LINE\ ':''}
set statusline+=%#VisualColor#%{(mode()==nr2char(22))?'\ \ V-BLOCK\ ':''}
set statusline+=%#CommandColor#%{(mode()=='c')?'\ \ COMMAND\ ':''}
set statusline+=%#CursorIM#
set statusline+=%(%{b:gitstatus}%) " git branch
set statusline+=%#DelimiterColor#
set statusline+=\ \%f "full path
set statusline+=\%m " modified [+] flag
set statusline+=%= " right align
set statusline+=\ %y\                                 " FileType
set statusline+=\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}] " Encoding & Fileformat
set statusline+=\ %l:\%c\ %L\            " Rownumber: colnumber total rows
 
