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
    package = pkgs-unstable.ollama-cuda; # Now it's tracked and "pure"!
    acceleration = "cuda";

    loadModels = [
      "nemotron-3-nano"
    ];

    environmentVariables = {
      OLLAMA_NUM_CTX = "32768"; # 5090, 32GB VRAM
    };
  };

  # Enable the Open WebUI service
  services.open-webui = {
    enable = true;
    port = 8080;
    # Ensure it talks to your local Ollama instance
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      # Disables the "first user is admin" check if you're just using it solo
      WEBUI_AUTH = "False";
    };
  };
}
