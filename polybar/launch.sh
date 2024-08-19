#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch nakedbar
echo "---" | tee -a /tmp/nakedbar.log
polybar nakedbar >>/tmp/nakedbar.log 2>&1 & disown

echo "Bars launched..."
