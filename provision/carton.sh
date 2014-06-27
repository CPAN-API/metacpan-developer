#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc


carton_dirs=(
  api.metacpan.org
  metacpan.org
)

for dir in "${carton_dirs[@]}"; do

    cd /home/metacpan/$dir;
    /usr/local/perlbrew/perls/perl-5.16.2/bin/carton install --path ~/carton/$dir;

done
