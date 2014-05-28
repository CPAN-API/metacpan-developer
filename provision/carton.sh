#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc


carton_dirs=(
  /home/metacpan/api.metacpan.org
  /home/metacpan/metacpan.org
)

for dir in "${carton_dirs[@]}"; do

    cd $dir;
    /usr/local/perlbrew/perls/perl-5.16.2/bin/carton install;

done
