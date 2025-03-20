{ config, pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Ethan Perruzza";
    userEmail = "ethan.perruzza@gmail.com";

    extraConfig = {
      core = {
        editor = "vim";
      };
      safe.directory = "/etc/nixos";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      delta = {
        navigate = true;
        dark = true;
        line-numbers = true;
      };
    };

    includes = [
      {
        condition = "gitdir:~/Documents/Assistant/";
        contents = {
          user = {
            email = "ethan.perruzza@epita.fr";
          };
        };
      }
      {
        condition = "gitdir:~/Documents/Epita/";
        contents = {
          user = {
            email = "ethan.perruzza@epita.fr";
          };
        };
      }
    ];
  };

}
