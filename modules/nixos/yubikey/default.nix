{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enable PC/SC daemon for smart card support
  services = {
    pcscd.enable = true;
    udev = {
      packages = [ pkgs.yubikey-personalization ];
    };
  };

  # login or get root access via yubikey
  # security.pam = {
  #   u2f = {
  #     enable = true;
  #     settings.cue = true;
  #   };
  #
  #   yubico = {
  #     enable = false;
  #     debug = false;
  #     mode = "challenge-response";
  #     id = [ "32226314" ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
    # Tools for backing up keys
    paperkey
    pgpdump
    parted
    cryptsetup

    # Yubico's official tools
    yubikey-manager
    yubikey-touch-detector
    yubikey-personalization
    yubico-piv-tool
    yubioath-flutter

    # Testing
    ent

    # Password generation tools
    diceware
    pwgen
    rng-tools

    pinentry-all
  ];

  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
