#!/bin/sh

# Fix the `stdin: is not a tty` message.
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
