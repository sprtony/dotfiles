#!/bin/bash

# Convenience wrapper for launching polybar on all monitors
killall polybar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar top &
  done
else
  polybar top &
fi
