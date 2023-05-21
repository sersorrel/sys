{ config, lib, pkgs, unstable, ... }:

{
  options = {
    sys.neovim.enable = lib.mkOption {
      description = "Whether to install neovim, a modal text editor.";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.sys.neovim.enable (let
    essence-vim = pkgs.vimUtils.buildVimPlugin {
      name = "essence.vim";
      src = pkgs.fetchFromGitHub {
        owner = "Druid-of-Luhn";
        repo = "essence.vim";
        rev = "feb317f277b46409f2fb73601e3db813d8b34480";
        sha256 = "0340zc8a6867xh57rv6pckpq91kfky7qixpi1q4y2ahhcnfwb63f";
      };
    };
    leap = pkgs.vimUtils.buildVimPlugin {
      name = "leap.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "ggandor";
        repo = "leap.nvim";
        rev = "cd90202232806ec2dab9c76c7287bd2190a17459";
        sha256 = "0fk686d4hs7ld4a85gfhqmd4nk9f951bjjhkknbkkq0rijdrpysa";
      };
    };
    leap-spooky = pkgs.vimUtils.buildVimPlugin {
      name = "leap-spooky.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "ggandor";
        repo = "leap-spooky.nvim";
        rev = "748b2614e859704d8004e86be97401c9f3e28e80";
        sha256 = "0rhpmxv59s6449k3g2qap55lpnlf3z8vm2vml172ygzfw0l0ilkr";
      };
    };
    vim-angry = pkgs.vimUtils.buildVimPlugin {
      name = "vim-angry";
      src = pkgs.fetchFromGitHub {
        owner = "b4winckler";
        repo = "vim-angry";
        rev = "08e9e9a50e6683ac7b0c1d6fddfb5f1235c75700";
        sha256 = "0cxfvzlka0pgqs2ij4vwfv97yqks2ncnzk86a5psv985i8qmba30";
      };
    };
    vim-buffet = pkgs.vimUtils.buildVimPlugin {
      name = "vim-buffet";
      src = pkgs.fetchFromGitHub {
        owner = "bagrat";
        repo = "vim-buffet";
        rev = "d4f90cc5b9ef613e6464990f204006d74f89978a";
        sha256 = "183yb722qh3pvsb3n7vvzqpw7jlv2kcixz34qn3k4bsqj41g8y5y";
      };
    };
    vim-crystalline = pkgs.vimUtils.buildVimPlugin {
      name = "vim-crystalline";
      src = pkgs.fetchFromGitHub {
        owner = "rbong";
        repo = "vim-crystalline";
        rev = "5e797dbebbb7f2863d91a529236341f0971227ce";
        sha256 = "sha256-uaR8gNcCJBa7SmlKxuaT0BJPF8G6RDMMIPjqKJ8xPMw";
      };
    };
    vim-pythonsense = pkgs.vimUtils.buildVimPlugin {
      name = "vim-pythonsense";
      src = pkgs.fetchFromGitHub {
        owner = "jeetsukumaran";
        repo = "vim-pythonsense";
        rev = "9200a57629c904ed2ab8c9b2e8c5649d311794ba";
        sha256 = "1m2qz3j05f3y99wjjcnkhbpj8j3hdsnwjc33skzldv5khspg011d";
      };
    };
    vim-textobj-line = pkgs.vimUtils.buildVimPlugin {
      name = "vim-textobj-line";
      src = pkgs.fetchFromGitHub {
        owner = "kana";
        repo = "vim-textobj-line";
        rev = "0a78169a33c7ea7718b9fa0fad63c11c04727291";
        sha256 = "0mppgcmb83wpvn33vadk0wq6w6pg9cq37818d1alk6ka0fdj7ack";
      };
    };
    vim-textobj-quote = pkgs.vimUtils.buildVimPlugin {
      name = "vim-textobj-quote";
      src = pkgs.fetchFromGitHub {
        owner = "preservim";
        repo = "vim-textobj-quote";
        rev = "7ce5b324ebd21f3bc98ec11e534ed4e9677834c9";
        sha256 = "09k6j3a1dbc9l9ydsbh3cad2ibdwr4gkxp70hphf3q43gamm3x51";
      };
    };
  in {
    home.sessionVariables.EDITOR = "nvim";
    # https://stackoverflow.com/a/61368522/5951320
    xdg.configFile."nvim/after/syntax/nix.vim".text = ''
      syntax match nixFunctionCall /lib\.\&lib/ conceal cchar=𝕃
      syntax match nixFunctionCall /pkgs\.\&pkgs/ conceal cchar=ℙ
      syntax match nixFunctionCall /builtins\.\&builtins/ conceal cchar=𝔹
      syntax match nixFunctionCall /unstable\.\&unstable/ conceal cchar=𝕌
    '';
    xdg.configFile."nvim/after/ftplugin/rust.vim".text = ''
      nnoremap <buffer> <leader>f :call rustfmt#Format()<CR>
    '';
    programs.neovim = {
      enable = true;
      extraConfig = builtins.readFile ./init.vim;
      plugins = with pkgs.vimPlugins; [
        # Tim Pope
        vim-commentary
        vim-eunuch
        vim-fugitive
        vim-repeat
        vim-scriptease
        vim-sensible
        vim-speeddating
        vim-surround
        # Appearance
        {
          plugin = gruvbox-community;
          config = ''
            set termguicolors
            let g:gruvbox_undercurl = 1
            let g:gruvbox_contrast_light = 'hard'
            let g:gruvbox_invert_selection = 0
            colorscheme gruvbox
          '';
        }
        {
          plugin = vim-buffet;
          config = ''
            " Set up custom colours for vim-buffet.
            function! s:gruvbox(x)
              return synIDattr(hlID(a:x), 'fg')
            endfunction
            function! g:BuffetSetCustomColors()
              exec 'hi! BuffetCurrentBuffer guifg='.s:gruvbox('GruvboxBg0').' guibg='.s:gruvbox('GruvboxFg4')
              exec 'hi! BuffetActiveBuffer guifg='.s:gruvbox('GruvboxFg4').' guibg='.s:gruvbox('GruvboxBg2')
              exec 'hi! BuffetBuffer guifg='.s:gruvbox('GruvboxFg4').' guibg='.s:gruvbox('GruvboxBg2')
              hi! link BuffetModCurrentBuffer BuffetCurrentBuffer
              hi! link BuffetModActiveBuffer BuffetActiveBuffer
              hi! link BuffetModBuffer BuffetBuffer
              exec 'hi! BuffetTrunc guifg='.s:gruvbox('GruvboxBg4').' guibg='.s:gruvbox('GruvboxBg1')
              exec 'hi! BuffetTab guifg='.s:gruvbox('GruvboxBg2').' guibg='.s:gruvbox('GruvboxBlue')
            endfunction
          '';
        }
        {
          plugin = vim-crystalline;
          config = ''
            function! StatusLine(current, width)
              let l:s = ""
              if a:current
                let l:s .= crystalline#mode() . crystalline#right_mode_sep("")
              else
                let l:s .= '%#CrystallineInactive#'
              endif
              let l:s .= ' %f%h%w%m%r '
              if a:current
                let l:s .= crystalline#right_sep("", 'Fill') . ' %{FugitiveHead()}'
              endif
              let l:s .= '%='
              if a:current
                let l:s .= crystalline#left_sep("", 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
                let l:s .= crystalline#left_mode_sep("")
              endif
              if a:width > 80
                let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
              else
                let l:s .= ' '
              endif
              return l:s
            endfunction
            function! TabLine()
              let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
              return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
            endfunction
            let g:crystalline_enable_sep = 1
            let g:crystalline_statusline_fn = 'StatusLine'
            let g:crystalline_tabline_fn = 'TabLine'
            let g:crystalline_theme = 'gruvbox'
            set showtabline=2
            set guioptions-=e
            set laststatus=2
            set noshowmode
          '';
        }
        essence-vim
        {
          plugin = vim-polyglot;
          config = ''
            " Enable LaTeX math support in Markdown.
            let g:vim_markdown_math = 1
            " Highlight YAML and TOML frontmatter.
            let g:vim_markdown_frontmatter = 1
            let g:vim_markdown_toml_frontmatter = 1
            " Don't automatically insert bulletpoints (it doesn't always behave properly).
            let g:vim_markdown_auto_insert_bullets = 0
            let g:vim_markdown_new_list_item_indent = 0
            " Disable automatic folding.
            let g:vim_markdown_folding_disabled = 1
            " Don't conceal code blocks.
            let g:vim_markdown_conceal_code_blocks = 0
            " Render strikethrough as strikethrough.
            let g:vim_markdown_strikethrough = 1
          '';
        }
        # Text objects
        vim-angry
        {
          plugin = vim-pythonsense;
          config = ''
            " Disable the vim-pythonsense keymaps, so we can enable just the docstring text object.
            let g:is_pythonsense_suppress_keymaps = 1
          '';
        }
        vim-textobj-comment
        vim-textobj-entire
        vim-textobj-line
        {
          plugin = vim-textobj-quote;
          config = ''
            let g:textobj#quote#educate = 0
            augroup textobj_quote
              au!
              au FileType * call textobj#quote#init()
            augroup END
          '';
        }
        vim-textobj-user
        # Keybinds
        conflict-marker-vim
        {
          plugin = ctrlp;
          config = ''
            " Make CtrlP ignore files that Git ignores, when in a Git repository.
            let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
            " When not in a Git repository, don't show uninteresting stuff.
            let g:ctrlp_custom_ignore = '\v\.(aux|fdb_latexmk|fls|mypy_cache)$'
            " Do show hidden files (when ctrlp_user_command doesn't apply).
            let g:ctrlp_show_hidden = 1
          '';
        }
        {
          plugin = leap;
          config = ''
            lua <<EOF
            require'leap'.add_default_mappings()
            EOF
          '';
        }
        {
          plugin = leap-spooky;
          config = ''
            lua <<EOF
            require'leap-spooky'.setup{}
            EOF
          '';
        }
        {
          plugin = splitjoin-vim;
          config = ''
            let g:splitjoin_trailing_comma = 1
            let g:splitjoin_python_brackets_on_separate_lines = 1
          '';
        }
        vim-table-mode
        # Behaviour
        editorconfig-vim
        {
          plugin = pear-tree;
          config = ''
            " Stop pear-tree unpredictably erasing brackets, we don't care about repeating that much.
            let g:pear_tree_repeatable_expand = 0
            " Do be clever about maintaining balance.
            let g:pear_tree_smart_openers = 1
            let g:pear_tree_smart_closers = 1
            let g:pear_tree_smart_backspace = 1
          '';
        }
        {
          plugin = vim-gitgutter;
          config = ''
            " Disable the vim-gitgutter keymaps, we will enable the interesting ones ourselves.
            let g:gitgutter_map_keys = 0
            " Slimmed-down and modified mappings from vim-gitgutter.
            nmap ]h <plug>(GitGutterNextHunk)
            nmap [h <plug>(GitGutterPrevHunk)
            nmap <leader>hs <plug>(GitGutterStageHunk)
            nmap <leader>hu <plug>(GitGutterUndoHunk)
            omap ih <Plug>(GitGutterTextObjectInnerPending)
            omap ah <Plug>(GitGutterTextObjectOuterPending)
            xmap ih <Plug>(GitGutterTextObjectInnerVisual)
            xmap ah <Plug>(GitGutterTextObjectOuterVisual)
          '';
        }
        {
          plugin = vim-rooter;
          config = ''
            " Stop vim-rooter echoing the working directory it's changing to.
            let g:rooter_silent_chdir = 1
          '';
        }
        # LSP support
        {
          # using unstable.vimPlugins.nvim-lspconfig silently fails
          # https://github.com/NixOS/nixpkgs/pull/136429
          # https://github.com/NixOS/nixpkgs/issues/138084
          plugin = nvim-lspconfig;
          config = ''
            lua <<EOF
            require'lspconfig'.pyright.setup{}
            require'lspconfig'.rnix.setup{
              -- fix the default use of $HOME as root_dir ($PWD is probably more sensible)
              root_dir = function(fname)
                return require'lspconfig.util'.find_git_ancestor(fname) or vim.fn.getcwd()
              end,
            }
            -- NB: as of 2022-11-06, elixirls and r_language_server have the same root_dir brokenness as rnix; worth checking the current behaviour if you ever add those
            EOF
          '';
        }
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp-vsnip
        {
          plugin = vim-vsnip;
          config = ''
            imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
            smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
            imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
            smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
          '';
        }
        {
          plugin = crates-nvim;
          config = ''
            lua require'crates'.setup{popup={autofocus=true}}
          '';
        }
        nvim-cmp
        plenary-nvim
        rust-tools-nvim
        # Linting
        {
          plugin = nvim-lint;
          config = ''
            lua <<EOF
            require'lint'.linters_by_ft = {
              sh = {'shellcheck',},
              bash = {'shellcheck',},
            }
            EOF
            au BufWritePost,CursorHold,CursorHoldI <buffer> lua require'lint'.try_lint()
          '';
        }
      ];
      extraPackages = with pkgs; [
        nodePackages.pyright
        shellcheck
      ];
    };
    home.packages = with pkgs; [
      rnix-lsp
    ];
  });
}
