"------------------------------------------------------------------------------
" 検索関連
"------------------------------------------------------------------------------
set ignorecase               " 大文字、小文字は意識しない
set smartcase                " 検索文字に大文字がある場合は大文字、小文字を区別
set incsearch                " インクリメンタルサーチ
set hlsearch                 " 検索マッチテキストをハイライト

" '/'や'?'を状況に合わせて自動的にエスケープ
" cnoremap <expr> / (getcmdtype() == '/') '\/' : '/'
" cnoremap <expr> ? (getcmdtype() == '?') ? '\?' : '?'

"------------------------------------------------------------------------------
" タブ幅の設定
"------------------------------------------------------------------------------
set expandtab
set softtabstop=2
set shiftwidth=2
set tabstop=2

"------------------------------------------------------------------------------
" 編集関連
"------------------------------------------------------------------------------
set shiftround               " '<'や'>'でインデントする際に'shiftwidth'の
                             " 倍数にまとめる
set infercase                " 保管時に大文字、小文字を区別しない
"set virtualedit=all          " カーソル文字がない場所でも移動できる
set hidden                   " バッファを閉じる代わりに隠す
set switchbuf=useopen        " 新しく開く代わりに開いてあるバッファを開く
set showmatch                " 対応するカッコをハイライト表示
set matchtime=3              " ハイライト表示は３秒

" 対応カッコに'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" swapファイル、backupファイルは無効
set nowritebackup
set nobackup
set noswapfile

"------------------------------------------------------------------------------
" 表示関連
"------------------------------------------------------------------------------
set list                     " 不可視文字の表示
" 不可視文字をUnicodeで
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set number                   " 行番号の表示
set wrap                     " 長いテキストの折り返し
set textwidth=0              " 自動改行を無効
set colorcolumn=80           " 80行目にラインを表示

" スクリーンベルを無効
set t_vb=
set novisualbell

"------------------------------------------------------------------------------
" 編集関連
"------------------------------------------------------------------------------
autocmd QuickFixCmdPost *grep* cwindow " grep時にquickfix-windowを開く


"------------------------------------------------------------------------------
" マクロ、キー設定
"------------------------------------------------------------------------------
" 挿入モード終了時に IME 状態を保存しない
 "inoremap <silent> <Esc> <Esc>
 "inoremap <silent> <C-[> <Esc>

" ESCを2回押すとハイライト表示を消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>


"------------------------------------------------------------------------------
" プラグイン管理
"------------------------------------------------------------------------------
if has('win32') || has('win64')
  let s:plug_vim = expand('~/vimfiles/autoload/plug.vim')
else
  let s:plug_vim = expand('~/.vim/autoload/plug.vim')
endif

if empty(glob(s:plug_vim))
  if executable('curl')
    echo 'Installing vim-plug...'
    call mkdir(fnamemodify(s:plug_vim, ':h'), 'p')
    execute 'silent !curl -fLo ' . shellescape(s:plug_vim) . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  else
    echohl WarningMsg
    echomsg 'vim-plug is not installed and curl is not available.'
    echohl None
  endif
endif

if filereadable(s:plug_vim)
  call plug#begin()
    Plug 'altercation/vim-colors-solarized'

    Plug 'preservim/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle'] }

    "Plug 'scrooloose/vim-slumlord'
  call plug#end()
endif

" vim-colors-solarizedの設定
let g:solarized_termcolors=256
"let g:solarized_termtrans=1
syntax enable
set background=dark
silent! colorscheme solarized
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

"------------------------------------------------------------------------------
" NERDTreeの設定
"------------------------------------------------------------------------------
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

if has('win32') || has('win64')
  let NERDTreeIgnore = ['\c^ntuser\.dat']
endif
