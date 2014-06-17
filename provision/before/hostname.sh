#!/bin/bash

hostname=metacpan-dev

# If we can't write files, give up now.
if ! touch /tmp/disk-writable; then
  echo 'Failed to write to disk.  Please try "vagrant reload"';
  exit 1;
fi

# Set hostname in this session.
hostname "$hostname"
# Remember after reboot.
grep -qFx "$hostname" /etc/hostname || echo "$hostname" > /etc/hostname

# Ensure there is an entry for each host name.
for host in $hostname localhost puppet; do
  grep -qE "^127.0.[01].1[[:space:]]+.*$host" /etc/hosts || \
    echo "127.0.0.1       $host" >> /etc/hosts
done
