" basic {{{
set nocompatible

" buffers
set hidden
set confirm

" files
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set viminfo+=n~/.vim/tmp/viminfo

" avoid :intro
set shortmess+=I

" o,O action
set cpoptions+=#

set scrolloff=3

set notimeout

" command line
set wildmode=list:longest,full

" search
set incsearch
set ignorecase
set smartcase

set history=10000
"set clipboard=unnamed

" status line {{{
set showcmd
set cmdheight=1
set laststatus=2
set wildmenu

" left
" %n buffer number
" %f filename
" encoding-rt
" %y filetype
" %r Readonly flag
" %h Help buffer flag
" %w Preview window flag
" %m Modified flag
" %= Separation point between left and right aligned items.
set statusline=[*%n]\ %f\ %{'['.(&fenc!=''?&fenc:'?').'-'.&ff.']'}%y%r%h%w%m%=      " 区切り
" right
" %l Line number
" %L Number of lines in buffer
" %< Where to truncate line if too long.
set statusline+=%4l/%4L%<
" }}}
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
set notimeout ttimeout ttimeoutlen=1000

noremap <Leader><Leader> "+

cnoremap <C-P> <UP>
cnoremap <C-N> <Down>
cnoremap <Up> <C-P>
cnoremap <Up> <C-N>

inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap ( ()<LEFT>
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap < <><LEFT>

inoremap <C-y>" "
inoremap <C-y>' '
inoremap <C-y>( (
inoremap <C-y>{ {
inoremap <C-y>[ [
inoremap <C-y>< <

inoremap <C-z>; <C-O>$;
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

" plugins {{{
filetype off

" NeoBundle
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

" NeoComplete {{{
NeoBundle 'Shougo/NeoComplete.vim'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

let g:neocomplete#force_overwrite_completefunc = 1

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Install clang_complete
NeoBundle 'Rip-Rip/clang_complete'

let g:clang_complete_auto = 0
let g:clang_auto_select = 0
" let g:clang_use_library = 1

let g:clang_user_options = '-std=c++11 -stdlib=libc++'
" }}}

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
let g:quickrun_config.markdown = {'command' : 'redpygments', 'cmdopt' : '-d', 'outputter': 'browser'}
let g:quickrun_config.haskell = {'command' : 'ghci', 'runner' : 'shell'}

NeoBundle 'tpope/vim-surround'

" Ruby/Rails
NeoBundle 'vim-ruby/vim-ruby'
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

" Scheme
NeoBundle 'amdt/vim-niji'

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

" after 'filetype plugin on' {{{
" off auto comment
au FileType * setl formatoptions-=ro

" indent
aug Indent
  au!
  au Filetype * setl cindent ts=8 sw=2 sts=2 et
  au Filetype * setl cinoptions=0:,(0                             " for close ):
  au Filetype c,cpp,java,markdown setl cindent ts=8 sw=4 sts=4 et
  au Filetype lisp,scheme setl cindent& ts=8 sw=2 sts=2 et
  au Filetype make setl ts=8 sw=8 sts=8 noet
  au BufRead,BufNewFile *.gradle set filetype=groovy
aug END

set nowrap
" }}}

" Rename {{{
" Vim-users.jp - Hack #17: Vimを終了することなく編集中ファイルのファイル名を変更する http://vim-users.jp/2009/05/hack17/
command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
" }}}

" vim: foldmethod=marker
