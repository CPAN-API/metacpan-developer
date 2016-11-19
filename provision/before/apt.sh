#!/bin/bash

sudo sed -i 's,http://debian.yorku.ca/debian/,http://mirror.bytemark.co.uk/debian/,' /etc/apt/sources.list
sudo apt-key adv --batch --keyserver pgp.mit.edu --recv-key '6F6B 1550 9CF8 E59E 6E46  9F32 7F43 8280 EF8D 349F'
sudo aptitude update
sudo aptitude upgrade -y
