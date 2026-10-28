#!/bin/sh
# Called by the permission_prompt hook so settings.shared.json stays identical on macOS and Linux.
case "$(uname)" in
  Darwin)
    osascript -e 'display notification "Claude Code needs your attention" with title "Claude Code"'
    timeout 3s mpg123 -f -15000 ~/Desktop/notifications/simple_bell.mp3
    ;;
  *)
    notify-send 'Claude needs your input ❇️' -a 'Claude'
    timeout 3s mpg123 -f -40000 ~/Desktop/notifications/simple_bell.mp3
    ;;
esac
