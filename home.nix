{ config, pkgs, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    python314
    uv
    curl
    wget
    git
    nodejs_22
    pkgs-unstable.gemini-cli
    bubblewrap
    bindfs
    rustup
    pkgs-unstable.webkitgtk_4_1
    gtk3
    openssl
    dbus
    pkg-config
    libappindicator-gtk3
    pkgs-unstable.cargo-tauri
  ];

  home.shellAliases = {
    opencode = "npx opencode-ai@latest";
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

  xdg.configFile."opencode/opencode.json".text = ''
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/nemotron-3-nano:30b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama Local",
      "options": {
        "baseURL": "http://127.0.0.1:11434/v1"
      },
      "models": {
        "nemotron-3-nano:30b": {
          "name": "nemotron-3-nano:30b",
          "limit": {
            "context": 256000,
            "output": 8192
          }
        },
        "gemma3:27b-it-qat": {
          "name": "gemma3:27b-it-qat",
          "limit": {
            "context": 128000,
            "output": 4096
          }
        }
      }
    }
  }
}
  '';
}
