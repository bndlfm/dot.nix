{ pkgs, ... }:{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      bash-language-server
      cargo
      fzf
      gcc
      git
      gnumake
      javascript-typescript-langserver
      lua-language-server
      lazygit
      nixd
      nodejs
      nodePackages.vscode-langservers-extracted
      ocaml
      opam
      pyright
      python3
      python3Packages.pip
      shellcheck
      shfmt
      stylua
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
        p.ocaml
        p.nix
        p.python
        p.rust
        p.scheme
        p.typescript
      ]))
    ];
  };
}
