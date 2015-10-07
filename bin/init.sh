#!/bin/sh

mkdir -p src
cd src

git clone git://github.com/CPAN-API/metacpan-puppet.git
git clone git://github.com/CPAN-API/cpan-api.git metacpan-api
git clone git://github.com/CPAN-API/metacpan-web.git
git clone git://github.com/CPAN-API/metacpan-explorer.git
git clone git://github.com/CPAN-API/github-meets-cpan.git

cd metacpan-web
sh git/setup.sh
cd ..

cd metacpan-api
sh git/setup.sh

if ! [ -e metacpan_server_local.conf ]; then
     echo "cpan /home/vagrant/CPAN" > metacpan_server_local.conf
fi

vagrant plugin install vagrant-vbguest
