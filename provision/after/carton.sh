#!/bin/bash

# Get functions.
. /vagrant/provision/common.bashrc


carton_dirs=(
  /home/metacpan/api.metacpan.org
  /home/metacpan/metacpan.org
)

for dir in "${carton_dirs[@]}"; do

  # Carton stores cache/config in ./.carton/ dir.
  change_shared_dir_owner metacpan:vagrant $dir/.carton

  # TODO: cd $dir; carton install ?

done
