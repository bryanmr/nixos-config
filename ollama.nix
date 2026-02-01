{ config, pkgs, inputs, ... }:

let
  # Access the unstable packages for your specific system
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  hardware.nvidia-container-toolkit = {
    enable = true;
    suppressNvidiaDriverAssertion = true;
  };

  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-cuda;
    acceleration = "cuda";

    loadModels = [
      "nemotron-3-nano:30b"
      "gemma3:27b-it-qat"
    ];

    environmentVariables = {
      OLLAMA_NUM_CTX = "32768"; # 5090, 32GB VRAM
    };
  };

  # Enable the Open WebUI service
  services.open-webui = {
    enable = true;
    package = pkgs-unstable.open-webui;
    port = 8080;
    # Ensure it talks to your local Ollama instance
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";
      FRONTEND_BUILD_DIR = "${config.services.open-webui.stateDir}/build";
      DATA_DIR           = "${config.services.open-webui.stateDir}/data";
      STATIC_DIR         = "${config.services.open-webui.stateDir}/static";
    };
  };

  systemd.services.open-webui.path = [ pkgs.ffmpeg ];
}
