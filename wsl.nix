{ pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "bryan";
  wsl.useWindowsDriver = true;

  environment.variables.LD_LIBRARY_PATH = "/usr/lib/wsl/lib";

  home-manager.users.bryan = {
    home.sessionVariables.KUBECONFIG = "/mnt/c/Users/bryan/.kube/config";
  };
}
