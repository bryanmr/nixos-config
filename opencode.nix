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
}
