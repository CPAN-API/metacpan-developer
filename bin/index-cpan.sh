#!/bin/sh

sudo service elasticsearch-es-01 start

cd ~/metacpan-api

./bin/run bin/metacpan mapping

sh /vagrant/bin/partial-cpan-mirror.sh

export MINICPAN=$HOME/CPAN

./bin/run bin/metacpan release ~/CPAN/authors/id/
./bin/run bin/metacpan latest
./bin/run bin/metacpan author
