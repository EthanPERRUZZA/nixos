{ config, pkgs, ... }:

{
  imports = [
    ./../../homeManagerModules/default.nix
    ./../../homeManagerModules/git.nix
    ./../../homeManagerModules/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ethanp";
  home.homeDirectory = "/home/ethanp";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    btop

    google-chrome

    beeper # messagerie
    element-desktop
    discord
    slack

    pdfarranger
    kdePackages.gwenview

    bottles

    kdePackages.ktorrent

    kdePackages.partitionmanager

    kdePackages.kdenlive
    inkscape
    gimp
    # darktable

    python3
    lunarvim
    lazygit
    ripgrep
    fd
    
    jq

    obsidian

    texliveFull

    bat

    zoxide

    tldr

    postman

    libreoffice-qt

    spotify

    obs-studio
    vlc

    ncdu

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    vscode
    # (vscode-with-extensions.override {
    # vscodeExtensions = with vscode-extensions; [
    #   bbenoist.nix
    #   ms-python.python
    #   ms-python.debugpy
    #   ms-azuretools.vscode-docker
    #   rust-lang.rust-analyzer
    #   tamasfe.even-better-toml
    #   eamodio.gitlens
    #   vscode-extensions.ms-toolsai.jupyter
    #   ms-vsliveshare.vsliveshare
    #   esbenp.prettier-vscode
    #   github.copilot
    #   github.copilot-chat
    #   mechatroner.rainbow-csv
    # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #   {
    #     name = "remote-ssh-edit";
    #     publisher = "ms-vscode-remote";
    #     version = "0.47.2";
    #     sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    #   }
    #   ];
    # })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    nix-direnv
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ethanp/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.direnv.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
