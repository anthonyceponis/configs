set relativenumber

" Set default indentation to 2 spaces
set tabstop=2         " Number of spaces that a <Tab> character represents
set shiftwidth=2      " Number of spaces to use for each step of (auto)indent
set expandtab         " Convert tabs to spaces
set softtabstop=2     " Number of spaces a <Tab> counts for in insert mode

set clipboard=unnamedplus

set termguicolors

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'junegunn/fzf.vim'                              " Fuzzy finder Vim integration
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'morhetz/gruvbox'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'joshdick/onedark.vim'
Plug 'cormacrelf/vim-colors-github'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-one'

call plug#end()

" Enable ALE auto-formatting on save
let g:ale_fix_on_save = 1

" Set ALE fixers for different file types
let g:ale_fixers = {
    \ 'javascript': ['prettier'],
    \ 'javascriptreact': ['prettier'],
    \ 'typescriptreact': ['prettier'],
    \ 'typescript': ['prettier'],
    \ 'python': ['black'],
    \ 'html': ['prettier'],
    \ 'css': ['prettier'],
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format'],
    \ 'ocaml': ['ocamlformat']
    \ }

let g:ale_ocaml_ocamlformat_options = '--enable-outside-detected-project'

set background=light
colorscheme PaperColor













