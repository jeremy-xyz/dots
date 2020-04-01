" Name: neovim configuration
" Author: koltea

"" Vim-plug
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.config/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf.vim'
Plug 'Yggdroot/indentLine'

call plug#end()

"" General settings
set termguicolors                                       " Opaque Background.
set ft=dosini                                           " Set syntax on other files.
set mouse=a                                             " enable mouse scrolling.
set clipboard+=unnamedplus                              " use system clipboard by default.
filetype plugin indent on                               " enable indentations.
set incsearch ignorecase smartcase hlsearch             " highlight text while searching.
set list listchars=trail:»,tab:»-                       " use tab to navigate in list mode.
set fillchars+=vert:\▏                                  " requires a patched nerd font (try FiraCode).
set wrap breakindent                                    " wrap long lines to the width set by tw.
set encoding=utf-8                                      " text encoding.
set number                                              " enable numbers on the left.
set relativenumber                                      " current line is 0.
set noshowmode                                          " disable showing modes.
set title                                               " tab title as file file.
set conceallevel=2                                      " set this so we wont break indentation plugin.
set splitright                                          " open vertical split to the right.
set splitbelow                                          " open horizontal split to the bottom.
set tw=90                                               " auto wrap lines that are longer than that.
set emoji                                               " enable emojis.
let g:indentLine_setConceal = 0                         " fix the annoying markdown links conversion.
au BufEnter * set fo-=c fo-=r fo-=o                     " stop annoying auto commenting on new lines.
set history=1000                                        " history limit.
set backspace=indent,eol,start                          " sensible backspacing.
set undofile                                            " enable persistent undo.
set undodir=/tmp                                        " undo temp file directory.
set foldlevel=0                                         " open all folds by default.
set inccommand=nosplit                                  " visual feedback while substituting.
let loaded_netrw = 0                                    " disable netew.
let g:omni_sql_no_default_maps = 1                      " disable sql omni completion.

"" smart tab
set tabstop=4 softtabstop=4 shiftwidth=4
set expandtab smarttab autoindent

"" Colorscheme
"" overrides
function! MyOverrides() abort
    highlight Normal ctermbg=NONE gui=NONE guibg=NONE
    highlight NonText guibg=none guifg=bg
    highlight clear SignColumn
    highlight Pmenu guibg='00010a' guifg=white
    highlight Comment gui=bold
    highlight VertSplit cterm=NONE
    highlight Search guibg=#b16286 guifg=#ebdbb2 gui=NONE
    highlight clear LineNr
    highlight clear CursorLineNr
    highlight CursorLineNr gui=bold
    highlight DiffAdd guibg=NONE
    highlight DiffChange guibg=NONE
    highlight DiffDelete guibg=NONE
    highlight CocCursorRange guibg=#b16286 guifg=#ebdbb2
    highlight ALEErrorSign ctermfg=9 ctermbg=15 guifg=#C30500
    highlight ALEWarningSign ctermfg=11 ctermbg=15 guifg=#FFA500
    highlight ALEVirtualTextError ctermfg=9 ctermbg=15 guifg=#C30500
    highlight ALEVirtualTextWarning ctermfg=11 ctermbg=15 guifg=#FFA500
endfunction

augroup MyColors
    autocmd!
    autocmd Colorscheme * call MyOverrides()
augroup end

"" Airline
let g:nord_uniform_diff_background = 1                  " remove nord colorscheme diff background
set background=dark                                     " set background to light or dark
colorscheme nord                                        " main colorscheme
let g:airline_theme='nord'                              " airline theme
let g:airline_powerline_fonts = 1                       " enable powerline font

call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
let g:airline_section_z = airline#section#create(['%3p%%  ',
    \ g:airline_symbols.linenr .' ', 'linenr', 'maxlinenr', ':%c '])

let g:airline_section_warning = ''                      " warning count
let g:airline#extensions#tabline#enabled = 1            " enable smarter tabline
let g:airline#extensions#tabline#fnamemod = ':t'        " show only file name on tabs
let g:airline#extensions#ale#enabled = 1                " ALE integration

"" Performance tweaks
set nocursorline
set nocursorcolumn
set lazyredraw
set synmaxcol=180
set re=1

"" Required by coc
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

"" Conquer of completion
"" use tab for completion trigger.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"" navigate snippet placeholders using tab.
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

"" use enter to accept snippet expansion.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

"" show docs on things with K.
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

"" ALE
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'c' : ['clang-format'],
    \'cpp' : ['clang-format'],
    \'markdown' : ['prettier'],
    \'json': ['prettier'],
    \'python': ['autopep8'],
    \}
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_warning = '⚠'
let g:ale_sign_error = '✘'
let g:ale_sign_info = ''
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_prefix = '❯❯❯ '

"" IndentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

"" FZF
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
let $FZF_DEFAULT_OPTS="--reverse "

"" files window with preview.
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"" advanced grep(faster with preview).
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

"" floating fzf window with borders.
function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

"" Mappings
let mapleader=" "
inoremap jj <ESC>
nmap <leader>w :wq!<cr>
nmap <leader>q :q!<cr>
nmap <leader>e :bd<CR>
nnoremap <silent> <leader>f :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>c :Commands<CR>
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>
map <leader><space> :let @/=''<cr> " clear search
noremap <silent> <esc><esc> :noh<return>

"" use a different buffer for dd.
    nnoremap d "_d
    vnoremap d "_d

"" coc mappings
    nmap <silent> <C-c> <Plug>(coc-cursors-position)
    nmap <silent> <C-a> <Plug>(coc-cursors-word)
    xmap <silent> <C-a> <Plug>(coc-cursors-range)

"" use `[g` and `]g` to navigate diagnostics.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

"" for global rename.
    nmap <leader>rn <Plug>(coc-rename)

"" goTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
"" use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

"" split navigation.
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

"" add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

"" add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

"" save file as sudo on files that require root permission.
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

"" run xrdb when Xresources are updated.
    autocmd BufWritePost *Xresources !xrdb %

"" update binds when sxhkdrc is updated.
    autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
