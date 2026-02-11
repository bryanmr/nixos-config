{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    python314
    uv
    curl
    wget
    git
    nodejs_20
  ];

  home.shellAliases = {
    opencode = "npx opencode-ai";
  };

  home.sessionVariables = {
    UV_PYTHON_DOWNLOADS = "never";
  };

  programs.git = {
    enable = true;
    settings.user.name = "Bryan";
    settings.user.email = "bryan.mreese@gmail.com";
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
