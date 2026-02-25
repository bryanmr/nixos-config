{ config, pkgs, lib, ... }:

let
  userHome = "/home/bryan";
in
{
  # System Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/New_York";
  nix.settings.auto-optimise-store = true;

  # Secrets Management (sops-nix)
  sops = {
    defaultSopsFile = "${userHome}/secrets/secrets.yaml";
    age.keyFile = "${userHome}/.config/sops/age/keys.txt";
    validateSopsFiles = false;
    
    secrets = {
      ssh_key = { 
        path = "${userHome}/.ssh/id_ed25519";
        owner = "bryan"; 
      };
      ssh_pub_key = { 
        path = "${userHome}/.ssh/id_ed25519.pub";
        owner = "bryan"; 
      };
    };
  };

  # SSH Agent
  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';

  # Packages
  environment.systemPackages = with pkgs; [
    vim
    sops
    age
    jq
    k9s
    kubectl
    kubernetes-helm
    nvidia-container-toolkit
    # Helper to rebuild
    (pkgs.writeShellScriptBin "rebuild" ''
      if grep -qi microsoft /proc/version; then
        TARGET="wsl"
      else
        TARGET="desktop"
      fi

      echo "Detected environment: $TARGET"
      sudo nixos-rebuild switch --flake ${userHome}/nixos-config#$TARGET

      source ~/.bashrc
    '')
  ];

  # Environment
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  environment.shellAliases = {
    nix-clean = "sudo nix-collect-garbage -d";
    sec-edit = "sops ${userHome}/secrets/secrets.yaml";
  };

  programs.bash.interactiveShellInit = ''
      set -o noclobber
  '';

  # Maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  imports =
  [
    ./ollama.nix
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];
}
