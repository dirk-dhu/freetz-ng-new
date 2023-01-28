#!/bin/sh

. /usr/lib/libmodcgi.sh

cgi --width=$(modconf value RRDSTATS_ALTWIDTH rrdstats)
cgi_begin "DigiTemp"

source /usr/lib/cgi-bin/rrdstats/rrddt.cgi

cgi_end
