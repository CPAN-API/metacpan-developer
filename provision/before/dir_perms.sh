#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc

# Puppet needs to own it's ssl dir.
change_shared_dir_owner puppet:puppet /etc/puppet/ssl
