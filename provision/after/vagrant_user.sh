#!/bin/bash

# Avoid confusion by giving the vagrant user the right perl.
function user_source_metacpanrc () {
  local user="$1"
  local home="/home/$user"
  local rc="$home/.metacpanrc" shrc="$home/.bashrc"
  local line="source $rc"

  echo 'PATH=/opt/perl-5.18.2/bin:$PATH' > "$rc"

  grep -qFx "$line" "$shrc" || echo "$line" >> "$shrc"

  chown "$user" "$rc" "$shrc"
}

user_source_metacpanrc vagrant
