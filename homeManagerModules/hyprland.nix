{ config, pkgs, inputs, ... }:

{
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
