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

  Plug 'https://github.com/justmao945/vim-clang.git'

  Plug 'https://github.com/aklt/plantuml-syntax.git'

  Plug 'https://github.com/scrooloose/nerdtree.git'

  Plug 'https://github.com/tyru/caw.vim.git'

  "Plug 'https://github.com/scrooloose/vim-slumlord.git'
call plug#end()

" vim-colors-solarizedの設定
let g:solarized_termcolors=256
"let g:solarized_termtrans=1
syntax enable
set background=light
colorscheme solarized
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

" テンプレート
autocmd BufNewFile *.py 0r $HOME/.vim/template/py.txt
autocmd BufNewFile *.h 0r $HOME/.vim/template/cpp_header.txt
autocmd BufNewFile *.cpp 0r $HOME/.vim/template/cpp_source.txt

" jedi-vimにpython3だと教えてあげる
" 基本的にpython3しか使わない
" 教えてあげないと2系を見に行き、保管できなくなる
let g:jedi#force_py_version = 3

" python_path に virtualenv の path も追加する
let s:python_path = system('python3 -', 'import sys;sys.stdout.write(",".join(sys.path))')

python3 <<EOM
import sys
import vim

python_paths = vim.eval('s:python_path').split(',')
for path in python_paths:
    if not path in sys.path:
        sys.path.insert(0, path)
EOM


function! s:cpp()
  " includeのパスを追加する
  setlocal path+=/usr/include,/usr/local/include/opencv4,/usr/include/c++/9/,/usr/include/c++/9/x86_64-redhat-linux/
  " setlocal path+=/usr/include,/usr/lib/gcc/x86_64-redhat-linux/7/include/,/usr/include/c++/7/,/usr/include/c++/7/x86_64-redhat-linux/

  " disable auto completion for vim-clanG
  " let g:clang_auto = 1
  let g:clang_complete_auto = 1
  let g:clang_auto_select = 0
  let g:clang_use_library = 1

  let g:clang_c_options = '-std=c11'
  let g:clang_cpp_options = '-std=c++14 -stdlib=libc++'

endfunction

augroup vimrc-c
    autocmd!
    autocmd FileType cpp call s:cpp()
augroup END

let g:plantuml_executable_script = '/home/nobuo/dotfiles/plantuml'

"------------------------------------------------------------------------------
" NERDTreeの設定
"------------------------------------------------------------------------------
" autocmd vimenter * NERDTree     " 起動時にNERDTreeを表示する
map <C-n> :NERDTreeToggle<CR>   " キーバインド

" ファイル名が指定された場合は、非表示
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" 閉じたらNERDTreeも閉じる
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"------------------------------------------------------------------------------
" cawの設定
"------------------------------------------------------------------------------
" コメントアウトを切り替えるマッピング
" \c でカーソル行をコメントアウト
" 再度 \c でコメントアウトを解除
" 選択してから複数行の \c も可能
nmap \c <Plug>(caw:I:toggle)
vmap \c <Plug>(caw:I:toggle)

" \C でコメントアウトの解除
nmap \C <Plug>(caw:I:uncomment)
vmap \C <Plug>(caw:I:uncomment)

" カッコ、クォートの補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
