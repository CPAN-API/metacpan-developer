#!/bin/sh

mkdir -p src
cd src

git clone git://github.com/CPAN-API/metacpan-puppet.git
git clone git://github.com/CPAN-API/cpan-api.git metacpan-api
git clone git://github.com/CPAN-API/metacpan-web.git
git clone git://github.com/CPAN-API/metacpan-explorer.git

cd metacpan-web
sh git/setup.sh
cd ..

cd metacpan-api
sh git/setup.sh

vagrant plugin install vagrant-vbguest
