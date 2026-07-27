{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  nixCats = inputs.nixCats;
  # get the nixCats library with the builder function (and everything else) in it
  utils = if nixCats ? utils then nixCats.utils else nixCats;
  luaPath = ./.;

  mkVimPlugin =
    {
      name,
      repo,
      owner,
      rev,
      hash ? "",
    }:
    pkgs.vimUtils.buildVimPlugin {
      pname = name;
      version = rev;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev;
        hash = if hash != "" then hash else "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
      doCheck = false;
      dontCheckNeovim = true;
    };

  patched-snacks = pkgs.vimUtils.buildVimPlugin {
    pname = "snacks.nvim";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "snacks.nvim";
      rev = "main";
      hash = "sha256-gU0XjCcnmZNwZ/erukA8miBiMKaSsSiInLtiv+OyEJI=";
    };
    # Patch was: patches = [ ./patches/snacksScope.patch ];
    # But it is already upstreamed in the main branch.
    doCheck = false;
    dontCheckNeovim = true;
  };

  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          bash-language-server
          cargo
          fzf
          gcc
          git
          gnumake
          highlight
          imagemagick
          lua-language-server
          texlivePackages.latex
          lazygit
          lua51Packages.lua
          lua51Packages.luarocks
          nil
          nodejs
          pyright
          shellcheck
          shfmt
          stylua
          # ueberzugpp
          unzip
          viu
          yarn
          ripgrep
          fd
          file
          binutils
          pkg-config
          python3
          (python3.withPackages (
            ps: with ps; [
              pynvim
              jupyter-client
              pillow
              cairosvg
              ipykernel
              pyperclip
            ]
          ))
        ];
      };

      startupPlugins = {
        general = [
          patched-snacks
        ];
      };

      optionalPlugins = {
        general = [ ];
      };

    };

  packageDefinitions = {
    nvim =
      {
        pkgs,
        name,
        mkPlugin,
        ...
      }:
      {
        settings = {
          wrapRc = true;
          aliases = [
            "vim"
            "vi"
          ];
          withPython3 = true;
          withRuby = true;
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          general = true;
        };
      };
  };

  defaultPackageName = "nvim";

  nixcatsNvim = utils.baseBuilder luaPath {
    inherit pkgs;
  } categoryDefinitions packageDefinitions defaultPackageName;

in
{

  home.packages = [
    nixcatsNvim
  ];

  home.sessionVariables = {
    EDITOR = lib.mkForce "nvim";
    SUDOEDITOR = lib.mkForce "nvim";
    VISUAL = lib.mkForce "nvim";
    PAGER = lib.mkForce "nvim +Man!";
    MANPAGER = lib.mkForce "nvim +Man!";
  };
}
