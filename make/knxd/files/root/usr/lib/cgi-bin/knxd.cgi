#!/bin/sh


. /usr/lib/libmodcgi.sh

check "$KNXD_ENABLED" yes:auto "*":man
check "$KNXD_LOG_DISABLE" yes:log_disable_yes "*":log_disable_no

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1">$(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2">$(lang de:"Manuell" en:"Manual")</label>
</p>
EOF

sec_end
sec_begin '$(lang de:"KNXD Serverkonfiguration" en:"KNXD server configuration")'

cat << EOF
<p>$(lang de:"EIBnet/IP Tunnel" en:"EIBnet/IP tunnel"):<br>
<input type="text" name="address" size="40" maxlength="255" value="$(html "$KNXD_ADDRESS")"><br>
<font size="-2">$(lang de:"z.B.: 192.168.178.1 oder leer lassen f&uuml;r ohne Tunnel" en:"For example: 192.168.178.1 or leave blank without tunneling")</font></P>
<p style="font-size:10px;">$(lang de:"Bitte &auml;ndern Sie diese Werte nur wenn Sie wissen was Sie tun." en:"Please change these values only if you know what you are doing.")</p>
<p> $(lang de:"Startparameter" en:"Start parameters"): <input type="text" name="special" size="45" maxlength="255" value="$(html "$KNXD_SPECIAL")"></p>
<input id="p1" type="radio" name="log_disable" value="yes"$log_disable_yes_chk><label for="x1">$(lang de:"kein Log" en:"Log disabled")</label><br>
<input id="p2" type="radio" name="log_disable" value="no"$log_disable_no_chk><label for="x2">$(lang de:"Datei:&nbsp;&nbsp;" en:"File:&nbsp;&nbsp;&nbsp;")
<input type="text" name="log_file" size="45" maxlength="200" value="$(html "$KNXD_LOG_FILE")"></label>
</p>
EOF

sec_end
