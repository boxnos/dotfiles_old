" basic {{{
set notimeout
set history=10000
"set clipboard=unnamed

set directory=~/.vim/tmp
set backupdir=~/.vim/tmp

" avoid :intro
set shortmess+=I

" o,O action
set cpoptions+=#

" command line
set wildmode=list:longest,full
" }}}

" mouse {{{
if has('mouse')
  if has('mouse_sgr')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
  set mouse=a
endif
"}}}

" search {{{
set incsearch
set ignorecase
set smartcase
" }}}

" GUI {{{
if has("gui_running")
  set guifont=Ricty\ 11
  set guioptions-=T
endif

" save window position and window size {{{
" Vim-users.jp - Hack #120: gVim でウィンドウの位置とサイズを記憶する - http://vim-users.jp/2010/01/hack120/
if has("gui_running")
  let g:save_window_file = expand("~/.vim/savesize.vim")
  augroup SaveWindow
    autocmd!
    autocmd VimLeavePre * call s:save_window()
    function! s:save_window()
      let options = [
        \ 'set columns=' . &columns,
        \ 'set lines=' . &lines,
        \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
        \ ]
      call writefile(options, g:save_window_file)
    endfunction
  augroup END

  if filereadable(g:save_window_file)
    execute 'source' g:save_window_file
  endif
endif
" }}}
" }}}

" map {{{

" キーコードはすぐにタイムアウト。マッピングはタイムアウトしない
set notimeout ttimeout ttimeoutlen=1000

cnoremap <C-P> <UP>
cnoremap <C-N> <Down>
cnoremap <Up> <C-P>
cnoremap <Up> <C-N>

inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap < <><LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap <C-z>; <C-O>$;

" とりあえず {{{
inoremap <C-y>" ""<left>
inoremap <C-y>' ''<left>
inoremap <C-y>( ()<left>
inoremap <C-y>{ {}<left>
inoremap <C-y>[ []<left>
inoremap <C-y>< <><left>
inoremap <C-y>% <% %><left><left><left>
" }}}
" }}}

" indent {{{
aug All
  au!
  au FileType * setl formatoptions-=ro
  au Filetype * setl cindent ts=8 sw=2 sts=2 et
  au Filetype c,cpp,java setl cindent ts=8 sw=4 sts=4 et
  au Filetype * setl cinoptions=0:,(0                      " )
  au Filetype lisp,scheme setl cindent& ts=8 sw=2 sts=2 et
"  au Filetype vim,ruby,zsh,sh,python setl ts=8 sw=2 sts=2 et
  au Filetype make setl ts=8 sw=8 sts=8 noet
  au BufRead,BufNewFile *.gradle set filetype=groovy
aug END

set nowrap
" }}}

" Quickfix {{{
augroup quick
  au! QuickfixCmdPost grep,grepadd,vimgrep copen
  au! QuickfixCmdPost make call s:Open_quickfix_window()
augroup END

function! s:Open_quickfix_window()
  for e in filter(getqflist(), 'v:val.valid != 0')
    copen
    return
  endfor
  cclose
endfunction
" }}}

" status line {{{
set showcmd
set cmdheight=1
set laststatus=2
set wildmenu

set statusline=
set statusline+=[*%n]\  " バッファ番号
set statusline+=%f\     " ファイル名
set statusline+=%{'['.(&fenc!=''?&fenc:'?').'-'.&ff.']'} " 文字コード
set statusline+=%y      " ファイルタイプ
set statusline+=%r      " 読み取り専用フラグ
set statusline+=%h      " ヘルプバッファ
set statusline+=%w      " プレビューウィンドウ
set statusline+=%m      " バッファ状態[+]とか

set statusline+=%=      " 区切り

"set statusline+=\ %{strftime('%c')}  " 時間
set statusline+=%4l/%4L  " 行番号
" set statusline+=%4p%%    " どこにいるか
" set statusline+=\ %3c    " 列
" set statusline+=\ %4B    " 文字コード
set statusline+=%<       " 折り返しの指定
" }}}

" alt {{{
" 端末の Vim でも Alt キーを使う - 永遠に未完成 http://d.hatena.ne.jp/thinca/20101215/1292340358
" nomal mode only
" if has('unix') && !has('gui_running')
"   " Use meta keys in console.
"   function! s:use_meta_keys()
"     for i in map(
"     \   range(char2nr('a'), char2nr('z'))
"     \ + range(char2nr('A'), char2nr('Z'))
"     \ + range(char2nr('0'), char2nr('9'))
"     \ , 'nr2char(v:val)')
"       " <ESC>O do not map because used by arrow keys.
"       if i != 'O'
"         execute 'nmap <ESC>' . i '<M-' . i . '>'
"       endif
"     endfor
"   endfunction
"
"   call s:use_meta_keys()
"   map <NUL> <C-Space>
"   map! <NUL> <C-Space>
" endif
" }}}

" Rename {{{
" Vim-users.jp - Hack #17: Vimを終了することなく編集中ファイルのファイル名を変更する http://vim-users.jp/2009/05/hack17/
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
" }}}

" plugins {{{
set nocompatible
filetype off

" NeoBundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache.vim'
let g:neocomplcache_temporary_dir = "$HOME/.cache/neocomplcache"
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_min_syntax_length = 2

inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

NeoBundle 'Shougo/neocomplcache-rsense.vim'
let g:neocomplcache#sources#rsense#home_directory = $RSENCE_HOME

" let g:rsenseHome = $HOME . "/opt/rsense"
" let g:rsenseUseOmniFunc = 1

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

NeoBundle 'Shougo/vimshell.vim'
let g:vimshell_right_prompt = '"[" . fnamemodify(getcwd(), ":~") . "]"'

function! s:awsome_map(mode, name, key)
  exe a:mode . 'noremap [' . a:name . '] <Nop>'
  exe a:mode . 'map ' . a:key . ' [' . a:name . ']'
endfunction

" Unite {{{
NeoBundle 'Shougo/unite.vim'
NeoBundle 'basyura/unite-rails'
call s:awsome_map("n", "unite", "<Leader>u")
nnoremap [unite]u  :<C-u>Unite -no-split<Space>
nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]f :<C-u>Unite<Space>file<CR>
nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
nnoremap [unite]r :<C-u>Unite<Space>rails/
" }}}

NeoBundle 'Shougo/neomru.vim'

NeoBundle 'tyru/open-browser.vim'
" need install ~/bin/ff
" /bin/firefox "$@" >& /dev/null
let g:openbrowser_browser_commands = [{'name' : 'ff', 'args' : ['{browser}', '{uri}']}]
call s:awsome_map("n", "OB", "<Leader>o")
call s:awsome_map("v", "OB", "<Leader>o")
nmap [OB]o <Plug>(openbrowser-open)
vmap [OB]o <Plug>(openbrowser-open)
nmap [OB]s <Plug>(openbrowser-smart-search)
vmap [OB]s <Plug>(openbrowser-smart-search)

NeoBundle 'thinca/vim-quickrun'
let g:quickrun_config = {}
let g:quickrun_config._ = {
      \       "outputter/buffer/split" : ":botright",
      \       "outputter/buffer/close_on_empty" : 1
      \   }
let g:quickrun_config.python = {'command' : 'python3'}
let g:quickrun_config.html = {'command': 'ff'}
let g:quickrun_config.slim = {'command' : 'slimrb', 'exec' : '%c -p %s > %s:r.html \&\& ff %s:r.html'}
" let g:quickrun_config.slim = {'command' : 'slimrb', 'exec' : '%c -p %s', 'outputter' : 'browser'}
let g:quickrun_config.markdown = {'command' : 'kramdown', 'outputter': 'browser'}
let g:quickrun_config.haskell = {'command' : 'ghci', 'runner' : 'shell'}

NeoBundle 'tpope/vim-surround'

" Ruby/Rails
NeoBundle 'tpope/vim-rails'
autocmd FileType ruby let g:neocomplcache_force_overwrite_completefunc = 1
" let g:neocomplcache_omni_patterns = {}
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
" NeoBundle 'Shougo/neocomplcache-rsense'
" let g:neocomplcache#sources#rsense#home_directory = '~/.vim/opt/rsense'

" slim
NeoBundle 'sorah/vim-slim'
" NeoBundle 'slim-template/vim-slim'

" Haskell
NeoBundle 'dag/vim2hs'
NeoBundleLazy 'ujihisa/neco-ghc', {'autoload' : {'filetypes' : ['haskell']}}
" autocmd! FileType haskell setlocal omnifunc=necoghc#omnifunc

" PHP
NeoBundle 'StanAngeloff/php.vim'

" filetype
NeoBundle 'tpope/vim-markdown'
NeoBundle 'pangloss/vim-javascript'
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags="html,body,head"
NeoBundle 'othree/html5.vim'
NeoBundle 'groenewege/vim-less'

" Japanese
NeoBundle 'banyan/recognize_charcode.vim'

" zen {{{
NeoBundle 'mattn/emmet-vim'
let g:user_emmet_settings = {
      \  'indentation' : "  ",
      \  'lang' : 'ja',
      \  'html' : {
      \    'filters' : 'html',
      \    'snippets' : {
      \      'html:5': "<!DOCTYPE html>\n"
      \               ."<html lang=\"${lang}\">\n"
      \               ."\t<head>\n"
      \               ."\t\t<meta charset=\"utf-8\" />\n"
      \               ."\t\t<title></title>\n"
      \                ."\t</head>\n"
      \                ."\t<body>\n"
      \                ."\t\t${child}|\n"
      \                ."\t</body>\n"
      \                ."</html>"
      \    },
      \    'default_attributes': {
      \      'script:n': {},
      \    }
      \  }
      \}
imap <C-Y><C-Y> <C-Y>,
" }}}

NeoBundle 'scrooloose/nerdcommenter'
let NERDSpaceDelims = 1

" NeoBundle 'fuenor/im_control.vim'
" let IM_CtrlMode = 5
" let IM_CtrlIBusPython = 1

NeoBundle 'vim-jp/vimdoc-ja'
set helplang=en

" color {{{

" color schemes
NeoBundle 'wombat256.vim'
NeoBundle 'desert256.vim'
NeoBundle 'w0ng/vim-hybrid'

set t_Co=256
syntax enable
set listchars=tab:>-,eol:<
set list
let g:lisp_rainbow = 1

if ($TERM == 'xterm-256color' || $TERM == 'screen-256color')
  colorscheme hybrid

  " colorscheme wombat256mod
  "hi Normal ctermbg=233
  " eol
  "hi clear NonText
  "hi NonText guifg=grey40 ctermfg=238
  " tab
  "hi clear SpecialKey
  "hi SpecialKey guifg=grey50 ctermfg=238
else
  colorscheme hybrid
endif

" WhitespaceEOL
" http://d.hatena.ne.jp/tasukuchan/20070816/1187246177
highlight WhitespaceEOL ctermbg=238 guibg=grey50
match WhitespaceEOL /\s\+$/

" }}}

filetype plugin indent on
" }}}

" vim:set foldmethod=marker:
