#!/bin/sh

. /usr/lib/libmodcgi.sh

cgi --width=$(modconf value RRDSTATS_ALTWIDTH rrdstats)
cgi_begin "RRDstats"

source /usr/lib/cgi-bin/rrdstats/stats.cgi

cgi_end
