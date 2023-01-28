#!/bin/sh

. /usr/lib/libmodcgi.sh

cgi --width=$(modconf value RRDSTATS_ALTWIDTH rrdstats)
cgi_begin "SmartHome"

source /usr/lib/cgi-bin/rrdstats/avmha.cgi

cgi_end
