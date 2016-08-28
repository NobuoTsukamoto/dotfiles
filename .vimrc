"------------------------------------------------------------------------------
" 検索関連
"------------------------------------------------------------------------------
set ignorecase               " 大文字、小文字は意識しない
set smartcase                " 検索文字に大文字がある場合は大文字、小文字を区別
set incsearch                " インクリメンタルサーチ
set hlsearch                 " 検索マッチテキストをハイライト

" '/'や'?'を状況に合わせて自動的にエスケープ
cnoremap <expr> / (getcmdtype() == '/') '\/' : '/'
cnoremap <expr> ? (getcmdtype() == '?') ? '\?' : '?'


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
" タブ幅の設定
"------------------------------------------------------------------------------
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

"------------------------------------------------------------------------------
" マクロ、キー設定
"------------------------------------------------------------------------------
" 挿入モード終了時に IME 状態を保存しない
inoremap <silent> <Esc> <Esc>
inoremap <silent> <C-[> <Esc>

" ESCを2回押すとハイライト表示を消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>


"------------------------------------------------------------------------------
" プラグイン管理
"------------------------------------------------------------------------------
if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
  Plug 'junegunn/vim-plug',
        \ {'dir': '~/.vim/plugged/vim-plug/autoload'}

  Plug 'git://github.com/altercation/vim-colors-solarized.git'

  Plug 'https://github.com/davidhalter/jedi-vim.git'
call plug#end()

" vim-colors-solarizedの設定
let g:solarized_termcolors=256
syntax enable
set background=light
colorscheme solarized

" テンプレート
autocmd BufNewFile *.py 0r $HOME/.vim/template/py.txt

" jedi-vimにpython3だと教えてあげる
" 基本的にpython3しか使わない
" 教えてあげないと2系を見に行き、保管できなくなる
let g:jedi#force_py_version = 3

