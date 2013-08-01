#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc


# The web app writes to ./var/tmp
change_shared_dir_owner metacpan /home/metacpan/metacpan.org/var


# API test suite writes to multiple dirs.
change_shared_dir_owner metacpan:vagrant /home/metacpan/api.metacpan.org/t/var/tmp
change_shared_dir_owner metacpan:vagrant /home/metacpan/api.metacpan.org/var/

# CPAN::Faker 0.008 mistakenly requires source dir to be writable.
# https://github.com/CPAN-API/cpan-api/issues/277
# https://github.com/rjbs/CPAN-Faker/issues/1
# In the meantime the test suite can be run as the vagrant user.

# Make the required subdirs so that we can grant write perms to the group.
api_root=/home/metacpan/api.metacpan.org
api_dirs=($api_root/{t/,}var/{tmp,log})
  mkdir -p "${api_dirs[@]}"

  # Ensure file is created so vagrant or metacpan can keep writing to it.
  touch $api_root/var/log/metacpan.log

  chown -R metacpan:vagrant "${api_dirs[@]}"
  chmod -R g+w "${api_dirs[@]}"


# Puppet needs to own it's ssl dir.
change_shared_dir_owner puppet:puppet /etc/puppet/ssl
