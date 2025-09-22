{ config, pkgs, ... }:

{
  #xdg.configHome.".bashrc".source = ../../dotfiles/bashrc;

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

      c = "clear";

      d = "cd ~/Documents/";
      dw = "cd ~/Downloads/";
    };

    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
source /etc/nixos/dotfiles/p10k.zsh

eval "$(zoxide init zsh)"
    '';
  };
}
