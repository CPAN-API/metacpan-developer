#!/bin/sh

sudo service elasticsearch start

cd /home/metacpan/api.metacpan.org

/home/metacpan/bin/metacpan-api-carton-exec bin/metacpan mapping

sh /vagrant/bin/partial-cpan-mirror.sh


export MINICPAN=$HOME/CPAN

sudo /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan release ~/CPAN/authors/id
sudo /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan latest
sudo /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan author
