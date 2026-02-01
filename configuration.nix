{ config, pkgs, ... }:

{
  # System Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/New_York";
  virtualisation.docker.enable = true;
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "25.05";

  # Secrets Management (sops-nix)
  sops = {
    defaultSopsFile = "/home/bryan/secrets/secrets.yaml";
    age.keyFile = "/home/bryan/.config/sops/age/keys.txt";
    validateSopsFiles = false;
    
    secrets = {
      ssh_key = { 
        path = "/home/bryan/.ssh/id_ed25519";
        owner = "bryan"; 
      };
      ssh_pub_key = { 
        path = "/home/bryan/.ssh/id_ed25519.pub";
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
    # Helper to rebuild
    (pkgs.writeShellScriptBin "rebuild" ''
      if grep -qi microsoft /proc/version; then
        TARGET="wsl"
      else
        TARGET="desktop"
      fi

      echo "Detected environment: $TARGET"
      sudo nixos-rebuild switch --flake /home/bryan/nixos-config#$TARGET

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
    sec-edit = "sops /home/bryan/secrets/secrets.yaml";
  };

  # Maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
