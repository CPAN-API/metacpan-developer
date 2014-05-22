#!/bin/bash

# This provisioner is a shim to ease contribution between basebox builds.
# Most of the necessary modules come pre-installed but as new requirements
# are added we can specify them here temporarily until a new base vm is built.

mods=(
  "Module::Faker 0.015"
  "CPAN::Faker 0.010"

  "Catalyst::Runtime 5.90042"

  Parse::PMFile
  HTML::Escape

  "AnyEvent::Curl::Multi"

  Module::Metadata~1.000012
  Safe~2.35

  CPAN::Changes

  Test::Aggregate::Nested~0.371
  Test::Routine
  Test::More~0.99
  Perl::Tidy
  Test::Code::TidyAll

  # Not used by apps, just to ease debugging.
  Carp::Always

  Carton

  # README_API.md describes using these to get a mirror.
  CPAN
  CPAN::Mini

  Data::Pageset

  JSON~2.90
  JSON::XS~3.01

)

# Get the right perl.
. /home/metacpan/.metacpanrc

# TODO: Get a real list of not-satisfied mods and just install those for each project.

for mod in "${mods[@]}"; do
  # If it can't be loaded attempt to install it.
  perl -M"${mod/\~/ }" -e1 &> /dev/null || \
    { echo yes | /home/metacpan/bin/install_modules "${mod/ /~}"; }
done
