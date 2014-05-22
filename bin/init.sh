#!/bin/sh

mkdir -p src
cd src

git clone git://github.com/CPAN-API/metacpan-puppet.git
git clone git://github.com/CPAN-API/cpan-api.git
git clone git://github.com/CPAN-API/metacpan-web.git
git clone git://github.com/CPAN-API/metacpan-explorer.git

vagrant plugin install vagrant-vbguest
