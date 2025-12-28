{ config, pkgs, inputs, ... }:

{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ethan Perruzza";
        email = "ethan.perruzza@gmail.com";
      };
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

    signing = {
      key = "10746D84004889C78BE4147B896A511FE431AE32";
      signer = "gpg2";
      signByDefault = true;
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
      {
        condition = "gitdir:~/Documents/Prologin/";
        contents = {
          user = {
            email = "ethan.perruzza@prologin.org";
          };
        };
      }
    ];
  };

}
