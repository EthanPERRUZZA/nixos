{ config, pkgs, inputs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Ethan Perruzza";
    userEmail = "ethan.perruzza@gmail.com";
    extraConfig = {
      core.editor = "vim";
      safe.directory = "/etc/nixos";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };

}
