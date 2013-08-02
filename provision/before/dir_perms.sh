#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc


# The web app writes to ./var/tmp
change_shared_dir_owner metacpan /home/metacpan/metacpan.org/var


# API test suite writes to multiple dirs.
change_shared_dir_owner metacpan:vagrant /home/metacpan/api.metacpan.org/t/var/tmp
change_shared_dir_owner metacpan:vagrant /home/metacpan/api.metacpan.org/var/


# Puppet needs to own it's ssl dir.
change_shared_dir_owner puppet:puppet /etc/puppet/ssl
