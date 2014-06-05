#!/bin/bash

hostname=metacpan-dev
hostname "$hostname"
echo "$hostname" > /etc/hostname

HOSTNAME=$hostname perl -p -i -e 's/^(127.0.[01].1\s+)debian$/$1$ENV{HOSTNAME}/' /etc/hosts
