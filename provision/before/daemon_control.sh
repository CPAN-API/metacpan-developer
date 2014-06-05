#!/bin/bash

# NOTE: This is temporary until we're using Daemon::Control in puppet/production.

undo_dc () {
  local name="$1"

  # Stop the services before running puppet.
  # If they are running and were started with Daemon::Control they'll be
  # occupying the ports and puppet will fail to refresh the services it installs
  # (and treat that as an error).
  service "$name" stop

  # Restore the init script puppet expects just to avoid the diff noise.
  local init="/etc/init.d/$name"
  local pupinit="/etc/init.d/.${name}.puppet"
  test -f "$pupinit" && cp -f "$pupinit" "$init"
}

undo_dc metacpan-api
undo_dc metacpan-www

exit 0
