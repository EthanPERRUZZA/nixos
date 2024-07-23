{ 
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    hyprlock
    hypridle
  ];

  # ------------------------------------
  # Hyprlock
  # ------------------------------------
  xdg.configFile."hypr/hyprlock.conf".source = ../../dotfiles/hypr/hyprlock.conf;

  # ------------------------------------
  # Hyprland
  # ------------------------------------
  # Alternativ storage for hyprland config file.
  #xdg.configFile."hypr/hyprland.conf".source = "./hypr/hyprland.conf";
  # Hyprland
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi";

    "$mod" = "SUPER";
    bind =
      [
        "$mod SHIFT, Q, killactive, "
        "$mod , Return, exec, $terminal"
        "$mod SHIFT, F, exec, firefox"
        "$mod CTRL, L, exec, hyprlock"
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

    exec-once = [
      "ags -c /etc/nixos/homeManagerModules/ags/config.js >& /tmp/ags.log &"
      "hypridle &"
    ];

    misc = {
      "force_default_wallpaper" = "0"; # Disable anime mascot hyprland wallpappers
    };
    
    #general = with config.colorScheme.colors; {
    general = {
      "gaps_in" = "5";
      "gaps_out" = "10";
      "border_size" = "2";

      "resize_on_border" = "true";

      # Game display performances
      "allow_tearing" = "true";
    };

    decoration = {
        "rounding" = "10";

        # Change transparency of focused and unfocused windows
        "active_opacity" = "0.95";
        "inactive_opacity" = "0.8";
        "fullscreen_opacity" = "1.0";

        "drop_shadow" = "true";
        "shadow_range" = "4";
        "shadow_render_power" = "3";

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
            "enabled" = "true";
            "size" = "3";
            "passes" = "1";
            
            "vibrancy" = "0.1696";
        };
    };

    input = {
        "kb_layout" = "us";
        "kb_variant" = "altgr-intl";
        "kb_model" = "";
        "kb_options" = "";
        "kb_rules" = "";
    
        "follow_mouse" = "1";
    
        "sensitivity" = "0"; # -1.0 - 1.0, 0 means no modification.
    
        touchpad = {
            "natural_scroll" = "false";
        };
    };

    gestures = {
      "workspace_swipe" = "true";
      "workspace_swipe_fingers" = "3";
    };

    source = "~/.config/hypr/monitors.conf";
  };
}
