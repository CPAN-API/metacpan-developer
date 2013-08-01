#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc


# The web app writes to ./var/tmp
change_shared_dir_owner metacpan /home/metacpan/metacpan.org/var


# API test suite writes to multiple dirs.
change_shared_dir_owner metacpan:vagrant /home/metacpan/api.metacpan.org/t/var/tmp
change_shared_dir_owner metacpan:vagrant /home/metacpan/api.metacpan.org/var/
sudo -u metacpan mkdir -p /home/metacpan/api.metacpan.org/var/{tmp,log}

# CPAN::Faker 0.008 mistakenly requires source dir to be writable.
# https://github.com/CPAN-API/cpan-api/issues/277
# https://github.com/rjbs/CPAN-Faker/issues/1
# In the meantime the test suite can be run as the vagrant user.
chmod -R g+w /home/metacpan/api.metacpan.org/{t/,}var/tmp


# Puppet needs to own it's ssl dir.
change_shared_dir_owner puppet:puppet /etc/puppet/ssl
