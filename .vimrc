" =========================================================================
" General Settings
" =========================================================================
set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on

set number
set cursorline
set shiftwidth=4
set tabstop=4
set expandtab
set nobackup
set relativenumber
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set history=10000
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" =========================================================================
" Assembly 8086 Specific Settings
" =========================================================================
" Assembly file detection and settings
autocmd FileType asm setlocal:
    \ tabstop=8
    \ shiftwidth=8
    \ noexpandtab
    \ syntax=asm
    \ comments=:;
    \ commentstring=;%s
    \ filetype=asm

" Assembly file associations
autocmd BufNewFile,BufRead *.asm set filetype=asm
autocmd BufNewFile,BufRead *.s set filetype=asm

" =========================================================================
" Plugin Management (vim-plug)
" =========================================================================
call plug#begin('~/.vim/plugged')

Plug 'Shirk/vim-gas'

" General purpose plugins
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'

Plug 'wakatime/vim-wakatime'

" Zig
Plug 'ziglang/zig.vim'           " Syntax highlighting, build, run, test

" Rust
Plug 'rust-lang/rust.vim'          " Syntax highlighting, Cargo commands
Plug 'neoclide/coc.nvim', {'branch': 'release'}   " LSP / completion
Plug 'fannheyward/coc-rust-analyzer'             " Rust language server

" Java / Spring Boot
Plug 'neoclide/coc.nvim', {'branch': 'release'}        " LSP / completion
Plug 'neoclide/coc-java'                               " Java LSP
Plug 'tpope/vim-sensible'                              " sensible defaults
Plug 'sheerun/vim-polyglot'                            " syntax for many languages
Plug 'majutsushi/tagbar'                                " tags navigation
Plug 'vim-test/vim-test'                                " run tests
Plug 'tpope/vim-dispatch'                               " async build/run
Plug 'neoclide/coc-snippets'

" --- Essentials ---
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'github/copilot.vim'

" --- Navigation & Search ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'

" --- Git ---
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" --- LSP, Completion, Linting ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'neoclide/coc-snippets'
Plug 'neoclide/coc-tabnine'

" --- Languages ---
Plug 'udalov/kotlin-vim'
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc-java'
Plug 'vim-scripts/c.vim'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'neoclide/coc-tsserver'
Plug 'evanleck/vim-svelte'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'elzr/vim-json'
Plug 'jwalton512/vim-blade'

" --- Productivity ---
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-signify'
Plug 'ap/vim-css-color'

" --- Testing & Debugging ---
Plug 'vim-test/vim-test'
Plug 'puremourning/vimspector'

" --- Aesthetics ---
Plug 'morhetz/gruvbox'
Plug 'dracula/vim'
Plug 'sainnhe/everforest'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

" =========================================================================
" Assembly 8086 Syntax Highlighting
" =========================================================================
" Custom Assembly syntax highlighting
function! AssemblySyntax()
    " Keywords
    syn keyword asmKeyword mov add sub mul div inc dec
    syn keyword asmKeyword push pop call ret jmp je jne jg jl
    syn keyword asmKeyword cmp test and or xor not shl shr
    syn keyword asmKeyword int pushf popf iret
    syn keyword asmKeyword proc endp macro endm
    syn keyword asmKeyword db dw dd dup offset
    syn keyword asmKeyword ax bx cx dx si di sp bp
    syn keyword asmKeyword cs ds ss es
    syn keyword asmKeyword al ah bl bh cl ch dl dh

    " Registers
    syn match asmRegister "\<[abcd][hlx]\>"
    syn match asmRegister "\<[sde][ip]\>"
    syn match asmRegister "\<[csde]s\>"

    " Numbers
    syn match asmNumber "\<[0-9]\+[hH]\?\>"
    syn match asmNumber "\<0[0-9a-fA-F]\+[hH]\>"
    syn match asmNumber "\<[0-9a-fA-F]\+[hH]\>"

    " Strings
    syn region asmString start='"' end='"'
    syn region asmString start="'" end="'"

    " Comments
    syn match asmComment ";.*$"

    " Labels
    syn match asmLabel "^[a-zA-Z_][a-zA-Z0-9_]*:"

    " Directives
    syn match asmDirective "^\s*\.\w\+"

    " Highlighting
    hi def link asmKeyword Keyword
    hi def link asmRegister Identifier
    hi def link asmNumber Number
    hi def link asmString String
    hi def link asmComment Comment
    hi def link asmLabel Label
    hi def link asmDirective PreProc
endfunction

" Apply Assembly syntax for .asm files
autocmd FileType asm call AssemblySyntax()

" =========================================================================
" Key Mappings
" =========================================================================
let mapleader = " "

" Movement and editing
nnoremap <leader>\ ``
nnoremap <silent> <leader>p :%w !lp<CR>
inoremap jj <Esc>
nnoremap <space> :
nnoremap o o<esc>
nnoremap O O<esc>
nnoremap n nzz
nnoremap N Nzz
nnoremap Y y$

" File explorer & runners
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <F5> :w<CR>:!clear && python3 %<CR>

" Assembly-specific key mappings
" F5: Build and run Assembly (ELF32)
nnoremap <F5> :w<CR>:!nasm -f elf32 % -o %<.o && ld -m elf_i386 %<.o -o %< && ./%< <CR>
" F6: Build and run in DOSBox
nnoremap <F6> :w<CR>:!nasm -f bin % -o %<.com && dosbox %<.com <CR>
" F7: Build for DOS (COM file)
nnoremap <F7> :w<CR>:!nasm -f bin % -o %<.com <CR>
" F8: Run in DOSBox (assumes .com file exists)
nnoremap <F8> :!dosbox %<.com <CR>

" Assembly-specific key mappings
inoremap <C-c> ;<Esc>
nnoremap <leader>c :Commentary<CR>
vnoremap <leader>c :Commentary<CR>

" Window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
noremap <C-Up> <C-w>+
noremap <C-Down> <C-w>-
noremap <C-Left> <C-w>>
noremap <C-Right> <C-w><

" Quick navigation
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-t> :TagbarToggle<CR>
nnoremap <C-p> :Files<CR>

" Ignore junk in NERDTree
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$', '\.o$', '\.com$']

" =========================================================================
" Assembly 8086 Snippets
" =========================================================================
" Assembly snippets using UltiSnips format
function! AssemblySnippets()
    " Complete program template
    inoremap <buffer> prog<CR> .model small<CR>.stack 100h<CR>.data<CR>    <CR>.code<CR>main proc<CR>    mov ax, @data<CR>    mov ds, ax<CR>    <CR>    mov ax, 4c00h<CR>    int 21h<CR>main endp<CR>end main<Esc>kA
    
    " Procedure definition
    inoremap <buffer> proc<CR> <C-R>=expand('<cword>')<CR> proc<CR>    <CR>    ret<CR><C-R>=expand('<cword>')<CR> endp<Esc>kA
    
    " Loop structure
    inoremap <buffer> loop<CR> mov cx, <CR><CR>label:<CR>    <CR>    loop label<Esc>kA
    
    " Conditional jump
    inoremap <buffer> jump<CR> cmp , <CR>j label<Esc>kA
    
    " INT 21h function
    inoremap <buffer> int21<CR> mov ah, <CR>mov dl, 'A'<CR>int 21h<Esc>kA
    
    " Data declaration
    inoremap <buffer> data<CR>  db <Esc>A
endfunction

" Apply snippets for Assembly files
autocmd FileType asm call AssemblySnippets()

" =========================================================================
" Autocommands
" =========================================================================
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab

if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
augroup END

" Auto-create missing folders before saving
augroup auto_mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

" =========================================================================
" FZF
" =========================================================================
command! -bang -nargs=? Files
  \ call fzf#vim#files(
  \   systemlist('git rev-parse --show-toplevel 2>/dev/null || pwd')[0],
  \   fzf#vim#with_preview(),
  \   <bang>0)

nnoremap <leader>f :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :BLines<CR>

" =========================================================================
" UI / Colors
" =========================================================================

" set termguicolors

" Set Everforest as colorscheme
" colorscheme everforest
set t_Co=256
set background=dark
colorscheme PaperColor

" Assembly syntax highlighting improvements
let g:asm_syntax_nasm = 1
let g:asm_syntax_intel = 1

" Statusline
set laststatus=2
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=\ row:\ %l\ col:\ %c\ [%p%%]

nnoremap <leader>e :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:NERDTreeQuitOnOpen=1

set shortmess+=c
set completeopt=menu,menuone,noselect,noinsert

" =========================================================================
" CoC Config (completion & LSP)
" =========================================================================
" Tab to accept suggestion, Shift-Tab to go back
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use Enter to confirm selection
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Auto-install servers
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-java',
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-pyright',
  \ 'coc-clangd',
  \ ]

" =========================================================================
" Assembly 8086 Development Workflow
" =========================================================================
" Create project structure command
command! -nargs=1 NewAssemblyProject call NewAssemblyProject(<f-args>)
function! NewAssemblyProject(name)
    execute '!mkdir -p ' . a:name . '/{src,bin,obj}'
    execute '!touch ' . a:name . '/src/' . a:name . '.asm'
    execute 'edit ' . a:name . '/src/' . a:name . '.asm'
    " Insert basic template
    call setline(1, ['.model small', '.stack 100h', '.data', '    ', '.code', 'main proc', '    mov ax, @data', '    mov ds, ax', '    ', '    mov ax, 4c00h', '    int 21h', 'main endp', 'end main'])
    execute 'write'
endfunction

" Assembly build commands
command! AsmBuild :!nasm -f elf32 % -o %<.o && ld -m elf_i386 %<.o -o %<
command! AsmBuildDOS :!nasm -f bin % -o %<.com
command! AsmRun :!./%<
command! AsmRunDOS :!dosbox %<.com

" =========================================================================
" Airline Configuration
" =========================================================================
let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#enabled = 1

" =========================================================================
" Auto-completion for Assembly
" =========================================================================
autocmd FileType asm setlocal omnifunc=syntaxcomplete#Complete

" =========================================================================
" Assembly-specific abbreviations
" =========================================================================
autocmd FileType asm iabbrev <buffer> int21 mov ah, 02h<CR>mov dl, 'A'<CR>int 21h
autocmd FileType asm iabbrev <buffer> int21exit mov ah, 4c00h<CR>int 21h
autocmd FileType asm iabbrev <buffer> int21str mov ah, 09h<CR>mov dx, offset <CR>int 21h
autocmd FileType asm iabbrev <buffer> int21char mov ah, 02h<CR>mov dl, <CR>int 21h
autocmd FileType asm iabbrev <buffer> int21input mov ah, 01h<CR>int 21h
autocmd FileType asm iabbrev <buffer> pushall push ax<CR>push bx<CR>push cx<CR>push dx
autocmd FileType asm iabbrev <buffer> popall pop dx<CR>pop cx<CR>pop bx<CR>pop ax
