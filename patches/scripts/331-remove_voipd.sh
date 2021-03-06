[ "$FREETZ_REMOVE_VOIPD" == "y" ] || return 0
echo1 "removing VoIP files"

for files in \
  bin/showvoipdstat \
  bin/voipd \
  lib/libosip*2.so* \
  lib/librtpstream*.so* \
  lib/libsiplib.so* \
  usr/www/all/html/de/first/sip* \
  usr/www/all/html/de/fon/sip* \
  etc/init.d/rc.voip \
  ; do
	rm_files "${FILESYSTEM_MOD_DIR}/$files"
done
supervisor_delete_service "voip"
if \
  [ ! -e "${FILESYSTEM_MOD_DIR}/usr/share/telefon/libtam.so" -o "$FREETZ_REMOVE_TELEPHONY" == "y" ] \
  && \
  [ ! -e "${FILESYSTEM_MOD_DIR}/bin/ffmpegconv" -o "$FREETZ_REMOVE_MINID" == "y" ] \
  ; then
	rm_files "${FILESYSTEM_MOD_DIR}/lib/libmscodex.so*"
fi

echo1 "patching web UI"
modsed '/<tr.*\<FonAll\>/ {/\/tr>/ bn;:x;N;s/\n//;/\/tr>/ bn;bx;:n;s/<tr.*\/tr>//}' "${HTML_SPEC_MOD_DIR}/home/home.html"
modsed '/<tr.*\<FonStatus$1\>/ {/\/tr>/ bn;:x;N;s/\n//;/\/tr>/ bn;bx;:n;s/<tr.*\/tr>//}' "${HTML_SPEC_MOD_DIR}/home/home.html"
modsed "/jslGoTo('fon','siplist')/d;/^<?.* sip.*?>$/d" "${HTML_SPEC_MOD_DIR}/menus/menu2_fon.html"

echo1 "patching rc.conf"
modsed "s/CONFIG_FON_IPHONE=.*$/CONFIG_FON_IPHONE=\"n\"/g" "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"
modsed "s/CONFIG_FON_HD=.*$/CONFIG_FON_HD=\"n\"/g" "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"
modsed "s/CONFIG_T38=.*$/CONFIG_T38=\"n\"/g" "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"
modsed "s/CONFIG_FONQUALITY=.*$/CONFIG_FONQUALITY=\"n\"/g" "${FILESYSTEM_MOD_DIR}/etc/init.d/rc.conf"

touch "${FILESYSTEM_MOD_DIR}/bin/voipd"
chmod +x "${FILESYSTEM_MOD_DIR}/bin/voipd"

