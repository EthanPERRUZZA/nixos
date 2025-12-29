{
  config,
  pkgs,
  lib,
  ...
}:
{
  services = {
    xserver = {
      # Required for DE to launch.
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };

      # Enable Desktop Environment.
      # desktopManager.gnome.enable = true;
      # Configure keymap in X11.
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
      # Exclude default X11 packages I don't want.
      excludePackages = with pkgs; [ xterm ];
    };
  };
}
