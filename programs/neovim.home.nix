{ pkgs, ... }:
let
  magma-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "magma";
    version = "6.6.6";
    src = pkgs.fetchFromGitHub {
     owner = "dccsillag";
     repo = "magma-nvim";
     rev = "ff3deba8a879806a51c005e50782130246143d06";
     sha256 = "sha256-IrMR57gk9iCk73esHO24KZeep9VrlkV5sOC4PzGexyo=";
      };
    passthru.python3Dependencies = ps:
      with pkgs; [
        pynvim
        jupyter-client
        ueberzug
        pillow
        cairosvg
        plotly
        ipykernel
        pyperclip
        pnglatex
        ];
    meta.homepage = "https://github.com/dccsillag/magma-nvim";
  };

in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaPackages = ps: [
      ps.magick
      ];
    extraPython3Packages = ps: with ps; [
      cairosvg
      ipykernel
      jupyter-client
      pillow
      pip
      plotly
      pnglatex
      pyperclip
      pynvim
      ueberzug
      ];
    extraPackages = with pkgs; [
      bash-language-server
      cargo
      fennel
      fennel-ls
      fnlfmt
      fzf
      gcc
      git
      gnumake
      highlight
      imagemagick
      javascript-typescript-langserver
      lua-language-server
      texlivePackages.latex
      lazygit
      lua51Packages.lua
      lua51Packages.luarocks
      #nixd
      nodejs
      pyright
      shellcheck
      shfmt
      stylua
      unzip
      yarn
      ];
    plugins = with pkgs.vimPlugins; [
      vim-nix
      molten-nvim
      (nvim-treesitter.withPlugins (ps: with ps; [
        bash
        c
        cpp
        fennel
        kdl
        lua
        ocaml
        nix
        python
        regex
        rust
        scheme
        typescript
        ]))
      ];
  };
}
