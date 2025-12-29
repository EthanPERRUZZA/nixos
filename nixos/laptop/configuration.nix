{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    ../../modules/nixos/kde/default.nix
    ../../modules/nixos/yubikey/default.nix
    ../../modules/nixos/tuxedo/charging-profile.nix
    # If you want to use modules your own flake exports (from modules/nixos):
    # inputs.self.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    # overlays = [
    #   # Add overlays your own flake exports (from overlays and pkgs dir):
    #   inputs.self.overlays.additions
    #   inputs.self.overlays.modifications
    #   inputs.self.overlays.unstable-packages

    #   # You can also add overlays exported from other flakes:
    #   # neovim-nightly-overlay.overlays.default

    #   # Or define it inline, for example:
    #   # (final: prev: {
    #   #   hi = final.hello.overrideAttrs (oldAttrs: {
    #   #     patches = [ ./change-hello-to-hi.patch ];
    #   #   });
    #   # })
    # ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.tuxedo-drivers.enable = true;
  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };
  boot.tmp.cleanOnBoot = true;

  networking.hostName = "laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  console = {
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the GNOME Desktop Environment.
  services = {
    xserver = {
      # Required for DE to launch.
      enable = true;

      videoDrivers = [
        "displaylink"
        "modesetting"
      ];
      displayManager.sessionCommands = ''
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
      '';

      # Configure keymap in X11.
      xkb.layout = "us";
      xkb.variant = "altgr-intl";
      # Exclude default X11 packages I don't want.
      excludePackages = with pkgs; [ xterm ];
    };
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
      pkgs.foomatic-filters
      pkgs.hplip
    ];
  };

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pipewire.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  services.blueman.enable = true;

  # Portal for screen sharing support
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ethanp = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      # "nordvpn"
      "dialout"
    ];
  };

  # home-manager = {
  #   # also pass inputs to home-manager modules
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     "ethanp" = import ./home.nix;
  #   };
  #   backupFileExtension = "backup";
  # };

  # VPN
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  security.pki.certificateFiles = [
    # ../../certs/sncf.fr.pem
  ];

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  # programs.virt-manager.enable = true;
  # users.groups.libvirtd.members = ["ethanp"];
  # virtualisation.libvirtd.enable = true;
  # virtualisation.libvirtd.qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  # virtualisation.spiceUSBRedirection.enable = true;
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  programs.kdeconnect.enable = true;

  # services.udev.packages = [ pkgs.usb-blaster-udev-rules ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    nh
    vim
    alacritty
    # firefox
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true; }) { })
    htop
    tree
    curl
    brightnessctl
    networkmanagerapplet
    git
    zip
    unzip
    ripgrep
    vpnc-scripts
    xclip
    wl-clipboard
    man-pages
    man-pages-posix
    nixfmt
    wget
  ];
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
    ];
  };

  services.fwupd.enable = true;

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # 631 # cups
      # 1880 # node-red
      # 1883 # mosquitto
    ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
