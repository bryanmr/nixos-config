{
  description = "Bryan's Clean NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, sops-nix, ... }:
  let
    system = "x86_64-linux";
    
    shared-modules = [
      ./configuration.nix
      sops-nix.nixosModules.sops
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.bryan = import ./home.nix;
      }
    ];
  in {
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = shared-modules ++ [
          nixos-wsl.nixosModules.default
          ./wsl.nix
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = shared-modules ++ [
          ./desktop.nix
          ./hardware-configuration.nix
        ];
      };
    };
  };
}
