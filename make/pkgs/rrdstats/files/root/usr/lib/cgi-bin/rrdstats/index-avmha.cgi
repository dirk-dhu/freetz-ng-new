#!/bin/sh

. /usr/lib/libmodcgi.sh

cgi --width=$RRDSTATS_ALTWIDTH
cgi_begin "SmartHome"

source /usr/lib/cgi-bin/rrdstats/avmha.cgi

cgi_end
