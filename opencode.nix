{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_22
  ];

  environment.shellAliases = {
    opencode = "npx opencode-ai@latest";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  system.activationScripts.opencodeConfig = {
  text = ''
    mkdir -p /home/bryan/.config/opencode/
    cat <<'EOF' > /home/bryan/.config/opencode/opencode.json
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
EOF
    chown bryan:users /home/bryan/.config/opencode/opencode.json
  '';
  };
}
