{ ... }:

{
  imports =
    [
      ./package.nix
    ];

  services.custom.nordvpn.enable = true;
}
