#!/bin/sh

. /usr/lib/libmodcgi.sh

cgi --width=$RRDSTATS_ALTWIDTH
cgi_begin "RRDstats"

source /usr/lib/cgi-bin/rrdstats/stats.cgi

cgi_end
