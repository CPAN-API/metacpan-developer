#!/bin/sh

mkdir -p ~/CPAN
RSYNC='/usr/bin/rsync -av --delete --relative'
PATH='cpan-rsync.perl.org::CPAN'

$RSYNC $PATH/authors/id/L/LL/LLAP ~/CPAN/
$RSYNC $PATH/authors/id/N/NE/NEILB ~/CPAN/
$RSYNC $PATH/authors/id/O/OA/OALDERS ~/CPAN/
$RSYNC $PATH/authors/id/P/PE/PERLER ~/CPAN/
$RSYNC $PATH/authors/id/R/RW/RWSTAUNER ~/CPAN/

$RSYNC $PATH/authors/00whois.xml ~/CPAN/
$RSYNC $PATH/modules/0* ~/CPAN/
