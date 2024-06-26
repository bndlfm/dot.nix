{ pkgs, ... }:{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    #extraConfig = ''
    #:luafile ~/.config/nvim/lazy_bootstrap.lua
    #'';
    extraPackages = with pkgs; [
      cargo
      fzf
      gcc
      git
      lua-language-server
      lazygit
      gnumake
      nil
      nodejs
      bash-language-server
      javascript-typescript-langserver
      nodePackages.vscode-langservers-extracted
      ocaml
      opam
      pyright
      python3
      python3Packages.pip
      unzip
      yarn
    ];
    plugins = with pkgs.vimPlugins; [
      vim-nix
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.c
        p.cpp
        p.lua
        p.nix
        p.python
        p.rust
        p.typescript
      ]))
    ];
  };
}
