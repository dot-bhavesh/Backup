#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch Polybar using the isolated i3 config
polybar -c ~/.config/i3/polybar/config.ini left-pill &
polybar -c ~/.config/i3/polybar/config.ini center-pill &
polybar -c ~/.config/i3/polybar/config.ini sys-pill &
polybar -c ~/.config/i3/polybar/config.ini right-pill &

