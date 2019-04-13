#!/bin/sh

MINICPAN="$HOME/CPAN"
mkdir -p "$MINICPAN"

RSYNC='/usr/bin/rsync -av --delete --relative'
CPAN_ROOT='cpan-rsync.perl.org::CPAN'

$RSYNC "$CPAN_ROOT/authors/id/L/LL/LLAP"       "$MINICPAN/"
$RSYNC "$CPAN_ROOT/authors/id/N/NE/NEILB"      "$MINICPAN/"
$RSYNC "$CPAN_ROOT/authors/id/O/OA/OALDERS"    "$MINICPAN/"
$RSYNC "$CPAN_ROOT/authors/id/P/PE/PERLER"     "$MINICPAN/"
$RSYNC "$CPAN_ROOT/authors/id/R/RW/RWSTAUNER"  "$MINICPAN/"

$RSYNC "$CPAN_ROOT/authors/0*"                 "$MINICPAN/"
$RSYNC "$CPAN_ROOT/modules/0*"                 "$MINICPAN/"

$RSYNC "$CPAN_ROOT/indices/mirrors.json"       "$MINICPAN/"
