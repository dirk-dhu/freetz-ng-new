#!/bin/sh
ARCH=`cat /proc/cpuinfo | grep -sq -e 34Kc -e 24kc && echo -march=24kc -mtune=24kc`
export CFLAGS="$ARCH -msoft-float -O3 -Os -pipe -Wa,--trap -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -fno-stack-protector -fPIC -I/usr/local/include"
export LDFLAGS="-L/usr/local/lib -L/usr/lib/freetz -L/lib -L/usr/lib"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export SPEC_CFLAGS="$CFLAGS"
export SPEC_CXXFLAGS="$CFLAGS"
export SPEC_LDFLAGS="$LDFLAGS"
export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib/freetz:/usr/local/lib:/lib:/usr/lib:$LD_LIBRARY_PATH
