{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";

      gs = "git status";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit -m";
      gt = "git tag -ma";
      gp = "git push";
      gpt = "git push --follow-tags";
      gpl = "git pull";
      gl = "git log";
      glol = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";

      h = "history";

      prolo = "cd ~/Documents/Prologin";
    };

    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };

    initExtra = ''
source /etc/nixos/dotfiles/p10k.zsh
    '';
  };
}
