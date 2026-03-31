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
    zellij
    opentofu
    pkgs-unstable.gemini-cli
    bubblewrap
    bindfs
    # LSPs
    pkgs-unstable.ty
    ruff
    nil
    rust-analyzer
    python312Packages.debugpy
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.shellAliases = {
    # opencode removed as it depends on nodejs; use nix-shell/flake instead if needed.
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

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
    languages = {
      language = [
        {
          name = "python";
          auto-format = true;
          formatter = { command = "ruff"; args = ["format" "-" "--stdin-filename" "diag.py"]; };
          language-servers = [ "ty" "ruff" ];
        }
      ];
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

  home.file.".gemini/.env".text = ''
    GEMINI_EXPERIMENTAL_ENABLE_AGENTS=true
    GEMINI_EXPERIMENTAL_PLAN=true
  '';
}
