#!/bin/bash

# This provisioner is a shim to ease contribution between basebox builds.
# Most of the necessary modules come pre-installed but as new requirements
# are added we can specify them here temporarily until a new base vm is built.

mods=(
  Carton
  Daemon::Control

  # README_API.md describes using these to get a mirror.
  CPAN
  CPAN::Mini

  Code::TidyAll
  Perl::Tidy
)

# Get the right perl.
. /home/metacpan/.metacpanrc

# TODO: Get a real list of not-satisfied mods and just install those for each project.

for mod in "${mods[@]}"; do
  # If it can't be loaded attempt to install it.
  perl -M"${mod/\~/ }" -e1 &> /dev/null || \
    { echo yes | /home/metacpan/bin/install_modules "${mod/ /~}"; }
done
