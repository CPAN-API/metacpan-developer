#!/bin/bash

# This provisioner is a shim to ease contribution between basebox builds.
# Most of the necessary modules come pre-installed but as new requirements
# are added we can specify them here temporarily until a new base vm is built.

mods=(
  # TODO: uncoment this when a new one is released
  # https://github.com/rjbs/CPAN-Faker/issues/1
  #"CPAN::Faker 0.009"

  "AnyEvent::Curl::Multi"

  Test::Aggregate::Nested~0.366
)

# Get the right perl.
. /home/metacpan/.metacpanrc

for mod in "${mods[@]}"; do
  # If it can't be loaded attempt to install it.
  perl -M"${mod/\~/ }" -e1 &> /dev/null || \
    { echo yes | /home/metacpan/bin/install_modules "${mod/ /~}"; }
done
