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
