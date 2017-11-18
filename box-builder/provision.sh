#!/bin/bash

set -o errexit
set -e -o pipefail

echo "vagrant provision: $0"

# run.sh (in metacpan-puppet) won't run until this is done:
hosts_line="127.0.0.1    puppet"
grep -F "$hosts_line" /etc/hosts || echo $'\n\n# puppet (run.sh)\n'"$hosts_line" >> /etc/hosts

DEB=puppet-release-stretch.deb
cd /tmp
wget https://apt.puppetlabs.com/$DEB -O $DEB
dpkg -i $DEB

apt-get update

apt-get -q --assume-yes install dirmngr vim sudo openssh-server git
apt-get -q --assume-yes install puppetmaster puppet

# We don't want puppet running automatically
update-rc.d puppet disable; /etc/init.d/puppet stop

cd /etc
# Maybe clean out package files
if [ ! -d /etc/puppet/.git ]; then
  rm -rf /etc/puppet
fi
