" =====================================================================
" General settings
" =====================================================================
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

set background=dark
syntax on
set nocompatible
set mouse=v 				" make sure middle-click copying works
set laststatus=2 			" Always show a status line (see statusline).
set modeline modelines=2 	" Allow the use of 2 modelines.
set showmode 				" Definitely show the mode we're in.
set ruler 					" Use the ruler. Show cursor at all times
set showcmd 				" Show (partial) commands the ruler.
set wrap					" wrap long lines
set linebreak				" set where to break long lines (not in middle of words)
"set textwidth=180 			" Make the standard texwidth 180 characters.
filetype plugin on			" filetype plugin
if has("unix") 				" use bash as the shell.
        let &shell="bash"
endif


" Reformat the statusline (see laststatus).
" Shows the buffer number, the relative path, status flags like: modified,
" readonly, filetype and help, the line number, column numver, virtual column
" number and finally the percentace through the file of the displayed window.
set statusline=[%n]\ %f\ %(\ %M%R%Y%H%)%=%-14.(%l,%c,%V%)\ %P



" =====================================================================
" Indentation
" =====================================================================
"
" See also: filetype and smartindent.
set autoindent 				" IMHO autoindent is a Good Thing(TM).
filetype indent on			" filetype indent
set smartindent 			" Make sure indenting is smart; i.e. tabbing is determined by syntax hints.
set smarttab 				" Smart use of tabs (e.g. backspace will delete 'shiftwidht' of space).
"set foldmethod=manual
"set foldnestmax=2
set backspace=2 			" Allow backspacing over autoindent, line breaks (join lines) and over the start of insert.
set shiftwidth=4 			" Number of spaces to use for each step of (auto)indent.


" Set the tabstop at 4 characters. I know it's not recomended to use, but
" it allows systematic indentation with TABs and looks nicer than a width of
" 8 spaces.
set tabstop=4


" move text and rehighlight
vnoremap > ><CR>gv
vnoremap < <<CR>gv 



" =====================================================================
" Buffers 
" =====================================================================

set hidden 								" Use hidden buffers: keep changes w/o saving them when abandoning a buffer
set viminfo='50,\"200,:100,n~/.viminfo 	" specify what info to store and where.
set history=50 							" 50 lines of command lines history


" restore cursor position
"au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
    "\ exe "normal g'\"" | endif
autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif



" restore screen when exiting
if &term =~ "ansi"
" SecureCRT versions prior to 6.1.x do not support 4-digit DECSET
" let &t_ti = "\<Esc>[?1049h"
" let &t_te = "\<Esc>[?1049l"
" Use 2-digit DECSET instead
	let &t_ti = "\<Esc>[?47h"
	let &t_te = "\<Esc>[?47l"
endif 


" =====================================================================
" Searching
" =====================================================================

"set hlsearch 		" Set highlighted search.
set ignorecase		" Ignore case when searching (ignorecase).
set smartcase 		" AllLowerCase >case INsensitive; some uppercase -> case sensitive.
set incsearch 		" Set incremental search.
set showmatch 		" Show matching brackets.
set report=0 		" Set the threshold for the number of changes/substitutions reported. 0=always


:map j <Down>:nohlsearch<CR>
:map k <Up>:nohlsearch<CR>
:map h <Left>:nohlsearch<CR>
:map l <Right>:nohlsearch<CR>
":nmap <silent> <F10> :silent noh<CR>



" =====================================================================
" Python Settings
" =====================================================================

au BufRead *.py set expandtab
au BufNewFile *.py set expandtab


" =====================================================================
" LaTex Settings
" =====================================================================
" map the shortcuts for compile/view - assuming no vim-latex
":nmap <silent> <F9> :! latex %<.tex <CR>
":nmap <silent> <S-F9> :! xdvi %<.dvi <CR>

" use only if breaking lines
"au BufRead *.tex set textwidth=80
"au BufNewFile *.tex set textwidth=80
" tip:  use gq} to reformat paragraphs


" tip: forget above and use g-<arrow> to move up and down long lines as shown here
" (depends on :set wrap and :set linebreak)
map <Down> g<Down>
map <Up> g<Up>

" set all latex-related files
au BufNewFile,BufRead *.latex,*.sty,*.dtx,*.ltx,*.bbl     setf tex


" =====================================================================
" Vim-Latex Plugin Settings
" =====================================================================

" REQUIRED. This makes vim invoke latex-suite when you open a tex file.
filetype plugin on


" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash


" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*


" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" My own addition
let g:Tex_ViewRule_dvi = 'xdvi -s 6'

" =====================================================================
" Disable Bell
" =====================================================================
set visualbell
set t_vb=

" for PaperSpace Gradient Ctrl-key issues - enter :Vb to enter visual model
" Reference: https://stackoverflow.com/questions/63899874/how-to-enter-in-visual-block-mode-in-vim-by-command
" To highlight enter line: Shift-V
command! Vb :execute "normal! \<C-v>"
" Variation:
" Reference: https://vi.stackexchange.com/questions/3699/is-there-a-command-to-enter-visual-block-mode
"command! Vb normal! <C-v>

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

