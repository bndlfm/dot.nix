{ pkgs, ... }:{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = with pkgs; [
      bash-language-server
      cargo
      fzf
      gcc
      git
      gnumake
      imagemagick
      javascript-typescript-langserver
      lua-language-server
      lazygit
      #nil
      nixd
      nodejs
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
