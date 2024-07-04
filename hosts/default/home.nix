{ config, pkgs, ... }:

{
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    
    kitty
    dolphin
    wofi
    brightnessctl

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Ethan Perruzza";
    userEmail = "ethan.perruzza@epita.fr";
  };

  # Alternative storage for hyprland config file.
  #xdg.configFile."hypr/hyprland.conf".source = "./hypr/hyprland.conf";
  # Hyprland
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi";

    "$mod" = "SUPER";
    bind =
      [
        "$mod SHIFT, Q, killactive, "
        "$mod , Return, exec, $terminal"
        "$mod SHIFT, F, exec, firefox"
        "ALT, Space, exec, pkill $menu || $menu --show drun"
        "$mod, V, togglefloating,"

	# Move focus with mainMod + arrow keys
	"$mod, left, movefocus, l"
        "$mod, H, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, L, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, J, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, K, movefocus, d"

	# Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspacesilent, special:magic"
        #", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            ]
          )
          10)
      );
    
    # Bind and repeat on hold (e) & on locked screen (l)
    bindel =
      [
        # Sound Control.
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+" 
      ];

    exec-once = ''
      ${pkgs.waybar}/bin/waybar &
    '';

    #general = with config.colorScheme.colors; {
    #  "col.active_boder" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
    #  "col.inactive_border" = "rgba(${base00}ff)";
    #};
  };
}
