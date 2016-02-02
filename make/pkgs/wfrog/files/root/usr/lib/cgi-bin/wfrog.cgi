#!/bin/sh


. /usr/lib/libmodcgi.sh
[ -r /etc/options.cfg ] && . /etc/options.cfg

check "$WFROG_ENABLED" yes:auto "*":man
check "$WFROG_WS28XX_GREP_IDS" yes:ws28xx_grep_ids

sec_begin '$(lang de:"Starttyp" en:"Start type")'
cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1"> $(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2"> $(lang de:"Manuell" en:"Manual")</label>
</p>
EOF
sec_end

sec_begin '$(lang de:"Konfiguration" en:"Configuration")'
cat << EOF
<h2>$(lang de:"Optionale Aufrufparameter:" en:"Optional commandline parameters:")</h2>
<p><input type="text" name="cmdline" size="45" maxlength="255" value="$(html "$WFROG_CMDLINE")"></p>
EOF
sec_end

sec_begin '$(lang de:"Dateisysteme" en:"Filesystems")'
cat << EOF
<h2>$(lang de:"Verzeichnis f&uuml;r die permanten Daten" en:"Directory for permantent data"):</h2>
<p><input type="text" name="location" size="45" maxlength="255" value="$(html "$WFROG_LOCATION")"></p>
EOF
sec_end

sec_begin '$(lang de:"Wfrog Seite" en:"Wfrog page")'
cat << EOF
<p>$(lang de:"Deine Wetterseite kann" en:"You and open your weather site") <b><a style='font-size:14px;' target='_blank' href=/weather/index.html>$(lang de:"hier" en:"here")</a></b>$(lang de:" ge&ouml;ffnet werden." en:".")<p>
EOF
sec_end

if [ -e /mod/etc/default.wfrog/WV5Datastore.cfg.default ]; then
sec_begin '$(lang de:"Hinweise zur Konfiguration des WV5Datastore" en:"Configuration hints for the WV5Datastore")'
cat << EOF
<p>
$(lang de:"Die Wetter Station kann mit den USB Dongle entweder mit dem mitgelieferten PC Programm synchronisiert werden oder mit dem Kommandozeilen Programm: "
en:"The weather station has to be sychomized to the USB dongle either using the PC program or the command line tool: ")
</p>
<p>/usr/lib/wfrog/ws-28xx/HeavyWeatherService.py</p>
<hr>
<p>
$(lang de:"Um den ws28xx Treiber zu konfigurieren muss insbesondere die DeviceID (ID) und die TranceiverSerNo (inp) aus der Log Datei in die WVDatestore Datei
eingetragen werden, re-starte wfrog und entnehme dem Start Log die Parameter. Die ID muss zuvor von hexadezimal nach dezimal umgerechnet werden" 
en:"In order to configure the ws28xx driver you have to set DeviceID (ID) and TranceiverSerNo (inp) in WVDatestore, re-start wfrog and take these parameters 
from the start log. The ID has to be converted from a hex to a decimal number.")
</p>
<p><input type="hidden" name="ws28xx_grep_ids" value="no">
<input id="g1" type="checkbox" name="ws28xx_grep_ids" value="yes"$ws28xx_grep_ids_chk><label for="g1">
$(lang de:"Grep IDs" en:"grep ids")</label></p>
EOF
sec_end
fi