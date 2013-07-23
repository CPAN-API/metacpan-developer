#!/bin/bash

# Vagrant shared directories get owned by the vagrant user
# but some programs need certain (usually sub-) dirs to be user-writable.
# Create tmp dirs and mount them on top of the share to work around this.
function change_shared_dir_owner () {
  local user="$1" dest="$2"
  local src="/tmp/v-share-mounts/$dest"
  mkdir -p "$dest" "$src"
  chown "$user" "$src"
  mount --bind "$src" "$dest"
}

# The web app writes to ./var/tmp
change_shared_dir_owner metacpan /home/metacpan/metacpan.org/var

# Puppet needs to own it's ssl dir.
change_shared_dir_owner puppet:puppet /etc/puppet/ssl


# Run puppet to cleanup and check everything is running
/etc/puppet/run.sh
