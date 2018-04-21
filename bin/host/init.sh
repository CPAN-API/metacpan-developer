#!/bin/bash

set -o errexit
set -e -o pipefail

mkdir -p src
pushd src

git clone --recursive git://github.com/metacpan/github-meets-cpan.git
git clone --recursive git://github.com/metacpan/metacpan-api.git
git clone --recursive git://github.com/metacpan/metacpan-explorer.git
git clone --recursive git://github.com/metacpan/metacpan-puppet.git
git clone --recursive git://github.com/metacpan/metacpan-web.git

# set up Git hooks
pushd metacpan-web
sh git/setup.sh
popd

pushd metacpan-api
sh git/setup.sh

if ! [ -e metacpan_server_local.conf ]; then
     echo "cpan /home/vagrant/CPAN" > metacpan_server_local.conf
fi

vagrant plugin install vagrant-vbguest
