#!/bin/bash

# The puppet master needs a 'search' line in order to resolve correctly
# but resolv.conf is unreliable because it gets populated by the host OS.
grep -qE '^search ' /etc/resolv.conf || \
  echo 'search metacpan.org' >> /etc/resolv.conf
