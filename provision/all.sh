#!/bin/bash

# Execute all the scripts in a directory.
function exec_dir () {
  local dir="$1"
  [[ "${dir:0:1}" == "/" ]] || dir="/vagrant/provision/$dir"
  for exe in "$dir"/*; do
    test -x "$exe" && echo "# $exe" && "$exe"
  done
}


# Execute any before-puppet vm initialization scripts.
exec_dir before

# Run puppet to cleanup and check everything is running
## FIXME: if puppet --verison != 3.6.2
# apt-get remove -f -y puppet puppet-common puppetmaster
# apt-get install -y git
# cd /tmp/
# wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
# dpkg -i puppetlabs-release-wheezy.deb
# apt-get update
# apt-get install -y puppet
# gem install deep_merge

/etc/puppet/run.sh


# Execute any after-puppet vm clean-up scripts.
exec_dir after


# Don't let vagrant think the provision failed.
exit 0
