{
  home.file.".ideavimrc".text = ''
    " make undo behave like real vim, https://youtrack.jetbrains.com/issue/VIM-308
    set nooldundo

    " Show a few lines of context around the cursor. Note that this makes the
    " text scroll if you mouse-click near the start or end of the window.
    " This causes severe issues in DataSpell, so disable it there (VIM-2501).
    if &ide !~? "dataspell"
      set scrolloff=4
    endif

    " Do incremental searching.
    set incsearch

    " Don't use Ex mode, use Q for formatting.
    map Q gq

    " let the IDE handle joining lines
    set ideajoin
    " enable vim-surround
    set surround
    " enable vim-commentary
    set commentary
    " enable argtextobj.vim (like vim-angry)
    set argtextobj
    let g:argtextobj_pairs="(:),[:],{:},<:>"
    " enable textobj-entire
    set textobj-entire
    " ]g/[g navigate around diagnostics
    nnoremap ]g :action GotoNextError<CR>
    nnoremap [g :action GotoPreviousError<CR>
    " ]h/[h navigate around changes
    nnoremap ]h :action VcsShowNextChangeMarker<CR>
    nnoremap [h :action VcsShowPrevChangeMarker<CR>
    " ctrl-w in normal mode closes the tab
    nnoremap <c-w> :tabclose<CR>

    " enable matchit.vim emulation
    set matchit

    " stuff from init.nvim

    " Ignore case in searches.
    set ignorecase
    " Only ignore case in searches when pattern is all-lowercase.
    set smartcase
    " Highlight search matches.
    set hlsearch
    " Cancel search highlighting on <CR>.
    nnoremap <silent> <CR> :noh<CR>
    " Don't unselect the selection when changing indentation in visual mode.
    xnoremap < <gv
    xnoremap > >gv
    " j and k move vertically by visual line (unless used with a count).
    " ideavim doesn't support v:count yet, so we have to just unconditionally use
    " the visual-line motions
    " Normal mode
    " nnoremap <expr> j v:count ? 'j' : 'gj'
    " nnoremap <expr> k v:count ? 'k' : 'gk'
    nnoremap j gj
    nnoremap k gk
    " Visual mode
    " vnoremap <expr> j v:count ? 'j' : 'gj'
    " vnoremap <expr> k v:count ? 'k' : 'gk'
    vnoremap j gj
    vnoremap k gk
    " Operator-pending mode (e.g. after d or c)
    " onoremap <expr> j v:count ? 'j' : 'gj'
    " onoremap <expr> k v:count ? 'k' : 'gk'
    onoremap j gj
    onoremap k gk
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
    " Allow moving past EOL in visual block mode.
    set virtualedit=block
  '';
}
