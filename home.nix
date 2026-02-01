{ config, pkgs, ... }:

{
  home.username = "bryan";
  home.homeDirectory = "/home/bryan";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    python314
    uv
    curl
    wget
    git
  ];

  home.sessionVariables = {
    UV_PYTHON_DOWNLOADS = "never";
  };

  programs.git = {
    enable = true;
    userName = "Bryan";
    userEmail = "bryan.mreese@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      uvx = "uvx --python $(which python3)";
    };
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
      vim-nix
    ];
    settings = {
      ignorecase = true;
      smartcase = true;
      number = true;
      shiftwidth = 2;
      expandtab = true;
    };
    extraConfig = ''
      set mouse=a
      set autoindent
      syntax on
    '';
  };

}
