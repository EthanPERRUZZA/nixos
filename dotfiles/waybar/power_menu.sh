#!/bin/sh
case $(wofi -d -L 9 -l 3 -W 100 -x -60 -y -60 \
    -D dynamic_lines=true << EOF | sed 's/^ *//'
    Hibernate
    Shutdown
    Reboot
    Log off
    Sleep
    Lock
    Cancel
EOF
) in
    "Hibernate")
        systemctl hibernate
        ;;
    "Shutdown")
        shutdown now
        ;;
    "Reboot")
        reboot
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Lock")
        hyprlock
        ;;
    "Log off")
        kill hyprland
        ;;
esac
