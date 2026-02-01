{ pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "bryan";
  wsl.useWindowsDriver = true;
}
