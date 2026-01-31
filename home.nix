{ pkgs, ... }:

{
  home.username = "bryan";
  home.homeDirectory = "/home/bryan";

  # This is the user-level version of systemPackages
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

  # Manage your git config via Nix!
  programs.git = {
    enable = true;
    userName = "Bryan";
    userEmail = "bryan.mreese@gmail.com";
  };

  # Example: Managing your bash aliases
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
      number = true;     # Show line numbers
      shiftwidth = 2;    # 2 space tabs
      expandtab = true;
    };
    extraConfig = ''
      set mouse=a
      set autoindent
      syntax on
    '';
  };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
