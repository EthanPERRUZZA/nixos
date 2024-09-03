{ config, pkgs, inputs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Ethan Perruzza";
    userEmail = "ethan.perruzza@gmail.com";
  };

}
