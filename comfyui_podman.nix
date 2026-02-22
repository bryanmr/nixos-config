{ config, pkgs, inputs, ... }:

# NOTE: This was an attempt at getting ComfyUI working on WSL. It failed.
# It is currently unused and not imported by any configuration.
# Leaving it here for reference in case it can be fixed later.

let
  # Access the unstable packages for your specific system
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  hardware.graphics.enable = true;
  hardware.nvidia-container-toolkit = {
    enable = true;
    suppressNvidiaDriverAssertion = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Allows you to use 'docker' commands if you're used to them
    autoPrune.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    package = pkgs-unstable.podman;
  };
  virtualisation.oci-containers.backend = "podman";
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      libglvnd
      linuxPackages.nvidia_x11
      # Any other common libraries unpatched binaries might need
      zlib
      openssl
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/comfyui 0775 bryan users -"
  ];

  # --- Assumes Podman is setup ---
  networking.firewall.allowedTCPPorts = [ 8188 8080 ];
  virtualisation.oci-containers.containers."comfyui" = {
    # Using a high-quality community image with CUDA pre-installed
    image = "docker.io/universonic/comfyui";
    ports = [ "8188:8188" ];
    cmd = [ "--listen" "0.0.0.0" "--port" "8188" ];
    volumes = [
      # Map a persistent folder on your NixOS host so your models/outputs aren't lost
      "/var/lib/comfyui:/home/user/ComfyUI"
    ];
    extraOptions = [
      # "--device=/etc/cdi/nvidia.json=all"
      "--device=nvidia.com/gpu=all"
      "--security-opt=label=disable"
      "--env" "LD_LIBRARY_PATH=/usr/lib/wsl/lib"
    ];
  };
}
