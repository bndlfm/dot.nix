{...}:{
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
      dart
      eza
      fd
      fzf
      gcc
      git
      lua-language-server
      lazygit
      nil
      nodejs
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      python3
      python3Packages.pip
      tree-sitter
      ripgrep
      unzip
      yarn
      wget
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
