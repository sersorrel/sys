" Highlight highlighted columns with a dark grey background.
highlight ColorColumn ctermbg=darkgrey ctermfg=white

" Unmap F1 to avoid accidentally opening the help pages.
nnoremap <F1> <nop>
inoremap <F1> <nop>
" Prevent shift-enter scrolling down
nmap <S-CR> <CR>

" Buffer-switching keybinds.
" NB: mapping <tab> in normal mode breaks ctrl-I!
nnoremap <S-Tab> :bn<CR>
nnoremap gb :bn<CR>
nnoremap gB :bp<CR>
nnoremap <c-left> :bp<CR>
nnoremap <c-right> :bn<CR>
nnoremap <c-q> :close<CR>

" Window-switching keybinds.
nnoremap <silent> <c-h> <c-w><c-h>
nnoremap <silent> <c-j> <c-w><c-j>
nnoremap <silent> <c-k> <c-w><c-k>
nnoremap <silent> <c-l> <c-w><c-l>

" Get rid of the easy accidental entrypoints into ex mode.
nnoremap q: <nop>
nnoremap q/ <nop>
nnoremap q? <nop>
nnoremap Q <nop>

" Cancel search highlighting on <CR>.
nnoremap <silent> <CR> :noh<CR>

" Don't unselect the selection when changing indentation in visual mode.
xnoremap < <gv
xnoremap > >gv

" j and k move vertically by visual line (unless used with a count).
" Normal mode
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" Visual mode
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'
" Operator-pending mode (e.g. after d or c)
onoremap <expr> j v:count ? 'j' : 'gj'
onoremap <expr> k v:count ? 'k' : 'gk'
" ...as do arrow keys.
" Normal, visual and operator-pending modes
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <up> gk
onoremap <Down> gj
onoremap <up> gk
" Insert mode
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" gV selects the text you just inserted.
nnoremap gV `[v`]

" <leader>w toggles tw between 0, 80, 79, and 72.
nnoremap <silent> <leader>w :call <SID>change_width()<CR>:set tw?<CR>
fun! s:change_width() abort
  if &tw == 72
    let &tw = 0
  elseif &tw == 79
    let &tw = 72
  elseif &tw == 80
    let &tw = 79
  else
    let &tw = 80
  endif
endfun

" \dd and \do toggle a diff of the buffer and the file on disk.
nnoremap <silent> <leader>dd :Diff<CR>
nnoremap <silent> <leader>do :Doff<CR>
" Show a diff between the buffer and the file on disk.
let s:diffwin = -1
fun! Diff() abort
  if !filereadable(expand('%'))
    echo 'File does not exist on disk!'
    return
  endif
  if &diff
    return
  endif
  let l:filetype = &filetype
  leftabove vertical new
  let s:diffwin = win_getid()
  set buftype=nofile
  set bufhidden=wipe
  let &filetype = l:filetype
  read #
  0d_
  diffthis
  wincmd p
  diffthis
endfunction
function! Doff() abort
  let l:win = win_getid()
  if !win_gotoid(s:diffwin)
    return
  endif
  if !&diff
    return
  endif
  close
  if l:win != s:diffwin
    if !win_gotoid(l:win)
      echoerr 'Original window does not exist'
    endif
  endif
  diffoff
endfunction
command Diff call Diff()
command Doff call Doff()

" When writing to a file, copy any backup, don't rename and write a new file.
set backupcopy=yes

" Don't redraw in the middle of commands.
set lazyredraw

" Sentences are separated by one space.
set cpo-=J
set nojoinspaces

" Allow moving past EOL in visual block mode.
set virtualedit=block

" Write to swap files earlier (and show vim-gitgutter markers sooner).
set updatetime=400

" Don't show the intro screen or completion messages.
set shortmess+=Ic

" Autocomplete more like Bash (complete longest prefix and show a list when ambigous).
set wildmode=list:longest

" Don't autocomplete unuseful files.
set wildignore+=*.py[cod],*.egg-info,__pycache__/,*.sw?

" Always keep at least 5 lines visible around the cursor.
set scrolloff=5

" Wait no longer than 10ms for a keycode to arrive.
set ttimeoutlen=10

" Don't ring the bell unless it's important.
set belloff=esc

" Ignore case in searches.
set ignorecase
" Only ignore case in searches when pattern is all-lowercase.
set smartcase
" Highlight search matches.
set hlsearch

" Persist indent of the current line when pressing enter.
set autoindent
" When indentexpr isn't available, fall back to C-like indent rules.
set cindent
" Snap to multiples of shiftwidth when indenting.
set shiftround

" Highlight the line the cursor is on.
set cursorline

" Show line numbers.
set number
set numberwidth=5

" Always show the sign column.
if has('signs')
  set signcolumn=yes
endif

" Soft wrap at words.
set linebreak

" Show the current file in the terminal title.
" This breaks horribly in iTerm2 for some reason, so disable it there.
if $LC_TERMINAL != "iTerm2"
  set title
  set titleold=
endif

" Highlight the column after tw by default.
set cc=+1

" Enable conceal in insert mode only.
set conceallevel=2
set concealcursor=

" Show some whitespace/virtual characters, per lcs.
set list

" Put an arrow in front of lines that wrap around.
let &showbreak='↪ '

" Avoid trying to highlight extremely long lines.
set synmaxcol=999

" Highlight all trailing whitespace except when editing at the end of a line.
" Based on <http://vim.wikia.com/wiki/Highlight_unwanted_spaces>.
" The important bits of this pattern:
" \%#  : cursor position
" \@<! : assert no match of previous (negative lookbehind)
"        /\(abc\)\@<!def/ matches 'def' not preceded by 'abc'.
" $    : eol
" We use matchadd() rather than :match in order to increase the priority to 11
" (the default is 10), so that trailing whitespace is never overshadowed by
" anything else.
highlight TrailingWhitespace ctermbg=red guibg=red
au WinEnter * if exists('w:trail_match') | silent! call matchdelete(w:trail_match) | endif | let w:trail_match = matchadd('TrailingWhitespace', '\s\+$', 11)
au InsertEnter * if exists('w:trail_match') | silent! call matchdelete(w:trail_match) | endif | let w:trail_match = matchadd('TrailingWhitespace', '\s\+\%#\@<!$', 11)
au InsertLeave * if exists('w:trail_match') | silent! call matchdelete(w:trail_match) | endif | let w:trail_match = matchadd('TrailingWhitespace', '\s\+$', 11)

" Use different cursors depending on the mode.
" Requires DECSCUSR support (gnome-terminal/VTE has support since VTE 0.39).
" Alacritty also has support, but Vim can't tell even when the terminfo is set
" up correctly, because Vim uses termcap instead of terminfo, and 24-bit
" colour info doesn't fit into termcap.
" Kitty likewise.
if !empty($VTE_VERSION) && str2nr($VTE_VERSION) > 3900 || $TERM == 'alacritty' || !empty($ALACRITTY_LOG) || $TERM == 'xterm-kitty'
  let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
  let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
  let &t_EI = "\<esc>[ q"  " default cursor (usually blinking block) otherwise
endif

" Alacritty and kitty behave mostly like xterm, but Vim doesn't know that.
if $TERM == 'alacritty' || $TERM == 'xterm-kitty'
  " 24-bit colour
  let &t_8b = "\<esc>[48;2;%lu;%lu;%lum"
  let &t_8f = "\<esc>[38;2;%lu;%lu;%lum"
  " Bracketed paste
  let &t_BE = "\<esc>[?2004h"
  let &t_BD = "\<esc>[?2004l"
  " Strikethrough
  let &t_Ts = "\<esc>[9m"
  let &t_Te = "\<esc>[29m"
  " Request terminal version string (makes cursor keys work in CtrlP)
  let &t_RV = "\<esc>[>c"
endif

" Tell vim to work with UTF-8 internally.
set encoding=utf-8
" Save files as UTF-8.
set fileencoding=utf-8
" Try these encodings when opening files.
set fileencodings=utf-8,latin1,shift-jis

" Create missing directories on save.
" This allows creating files in directories that don't exist yet --
" potentially dangerous, but mostly useful.
" From https://stackoverflow.com/a/4294176/5951320
fun! s:CreateNonexistentDirs(file, buf) abort
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfun
augroup BWCCreateDir
  au!
  au BufWritePre * :call s:CreateNonexistentDirs(expand('<afile>'), +expand('<abuf>'))
augroup end

" Make :Q an alias for :qa.
command -bang Q qa

" Automatically reload files that were changed on disk (if not modified)
augroup file_changes
  au!
  " Don't run if in command-line mode.
  " <https://unix.stackexchange.com/a/383044/226269>
  au FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
augroup end

" Enable modelines.
set modeline
set modelines=5

" Allow switching buffers with unsaved work.
set hidden

" Enable spell-checking support.
set spellfile=$HOME/.vim/spell/general.utf-8.add
set spelllang=en_gb

" Stop the cursor blinking in gvim.
set guicursor+=a:blinkon0
" Hide the menu and toolbar.
set guioptions-=m
set guioptions-=T
" Use a nicer font than the default.
set guifont=Iosevka\ 10
" Match Kitty's line spacing.
set linespace=2

" Stop scrollwheel moving the viewport
" (in other editors, this is fine, but in nvim it drags the cursor with it,
" which is less than great: <https://github.com/neovim/neovim/issues/279>)
set mouse=
if has('gui_running')
  " Paste with ctrl-shift-v (since gvim can use ctrl-shift!)
  noremap <C-S-v> <C-r><C-o>+
  inoremap <C-S-v> <C-r><C-o>+
  xnoremap <C-S-c> "+y

  " Highlight occurrences of the selected word on double-click
  " https://vim.fandom.com/wiki/Highlight_all_search_pattern_matches
  function! s:makepattern(text)
    let pat = escape(a:text, '\')
    let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
    let pat = substitute(pat, '^\_s\+', '\\s\\*', '')
    let pat = substitute(pat, '\_s\+',  '\\_s\\+', 'g')
    return '\\V' . escape(pat, '\"')
  endfunction
  noremap <2-LeftMouse> <2-LeftMouse>:<c-u>let @/="<C-R>=<SID>makepattern(@*)<CR>"<CR>:set hls<CR>
endif

" Show completion popup even if there's only one option, and don't select anything by default
set completeopt=menuone,noselect

" LSP (and similar IDE-like things) configuration
lua <<EOF
-- set up rust-analyzer via rust-tools.nvim
-- https://sharksforarms.dev/posts/neovim-rust/
require'rust-tools'.setup{
  tools = { -- rust-tools options
    hover_actions = {
      auto_focus = true,
      },
    },
  server = { -- nvim-lspconfig options
    settings = {
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
          },
        },
      },
    },
  }

-- set up cmp, see https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
      end,
    },
  mapping = {
    ["<c-p>"] = cmp.mapping.select_prev_item(),
    ["<c-n>"] = cmp.mapping.select_next_item(),
    ["<s-tab>"] = cmp.mapping.select_prev_item(),
    ["<tab>"] = cmp.mapping.select_next_item(),
    ["<c-d>"] = cmp.mapping.scroll_docs(-2),
    ["<c-f>"] = cmp.mapping.scroll_docs(2),
    ["<c-space>"] = cmp.mapping.complete(),
    ["<c-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm{
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
      },
    },
  sources = {
    { name = "nvim_lsp" },
    { name = "crates" },
    { name = "path" },
    { name = "vsnip" },
    { name = "buffer", max_item_count = 10 },
    },
  formatting = {
    deprecated = true,
    },
  }
EOF

function! s:on_goto()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'tag '.expand('<cword>')
  else
    lua vim.lsp.buf.definition()
  end
endfunction
nnoremap <silent> <c-]> <cmd>call <SID>on_goto()<CR>
function! s:on_hover()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (index(['man'], &filetype) >= 0)
    execute 'Man '.expand('<cword>')
  elseif (expand('%:t') == 'Cargo.toml')
    lua require'crates'.show_versions_popup()
  else
    lua vim.lsp.buf.hover()
  endif
endfunction
nnoremap <silent> K <cmd>call <SID>on_hover()<CR>
nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> [g <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]g <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> ? <cmd>lua vim.diagnostic.open_float()<CR>
