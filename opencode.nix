{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_22
  ];

  environment.shellAliases = {
    opencode = "npx opencode-ai@latest --provider ollama --model nemotron-3-nano:30b --endpoint http://localhost:11434";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];
}
