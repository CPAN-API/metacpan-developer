#!/bin/bash

# NOTE: This is temporary until we're using Daemon::Control in puppet/production.

# Get the right perl.
. /home/metacpan/.metacpanrc

make_init () {
  local name="$1" dir="$2"
  local script="/home/metacpan/$dir/bin/daemon-control.pl"
  local init="/etc/init.d/$name"

  # If the script isn't there yet, exit (working on an old branch, maybe).
  test -f "$script" || return

  # Stop the old service with the old init script.
  service "$name" stop

  # Save puppet's init script so we can restore it later.
  grep -q puppet "$init" && mv -f "$init" "/etc/init.d/.${name}.puppet"

  # Replace init script with much simpler Daemon::Control wrapper.
  perl "$script" get_init_file > "$init"
  chmod 0755 "$init"

  # Start the new service.
  service "$name" start
}

make_init metacpan-www     metacpan.org
make_init metacpan-api api.metacpan.org

exit 0
