{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.beads;
  
  # Build beads from source since it's not in nixpkgs yet
  beads = pkgs.buildGoModule rec {
    pname = "beads";
    version = "0.49.4";
    
    src = pkgs.fetchFromGitHub {
      owner = "steveyegge";
      repo = "beads";
      rev = "v${version}";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder - will need to be updated
    };
    
    vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder - will need to be updated
    
    buildInputs = with pkgs; [ 
      icu 
      zstd 
    ];
    
    nativeBuildInputs = with pkgs; [
      pkg-config
    ];
    
    ldflags = [ "-s" "-w" ];
    
    meta = with lib; {
      description = "A memory upgrade for your coding agent - git-backed issue tracker";
      homepage = "https://github.com/steveyegge/beads";
      license = licenses.mit;
      mainProgram = "bd";
    };
  };
in
{
  options.beads = {
    enable = mkEnableOption "Beads - A memory upgrade for your coding agent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ beads ];
  };
}
