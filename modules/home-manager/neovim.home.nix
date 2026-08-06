{ pkgs, ... }:
{
  programs = {
    neovim = {
      enable = false; # Disabled in favor of nixcats
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withRuby = true;
      withNodeJs = true;
      withPython3 = true;
      
      initLua = ''
        vim.cmd([[source ~/.config/nvim/init-real.vim]])
        vim.g.python3_host_prog = "${pkgs.python3.withPackages (ps: with ps; [ pynvim ])}/bin/python3"
      '';
      
      extraWrapperArgs = [
        "--add-flags" "--cmd 'set rtp^=${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}'"
      ];
      
      plugins = [
      ];
      
      extraPackages = with pkgs; [
        (python3.withPackages (ps: with ps; [ pynvim ]))
        # Required for theniceboy/nvim
        nodejs
        python3
        xclip
        wl-clipboard
        ripgrep
        fzf
        gcc
        gnumake
        git
        curl
        wget
        unzip
        
        # LSPs and formatters
        bash-language-server
        cargo
        lua-language-server
        nil
        pyright
        shellcheck
        shfmt
        stylua
        yarn
      ];
    };
  };
}
