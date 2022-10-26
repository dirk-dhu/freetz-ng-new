#!/bin/sh


. /usr/lib/libmodcgi.sh
[ -e /mod/etc/conf/certbot.cfg ] && . /mod/etc/conf/certbot.cfg

check "$DOVECOT_ENABLED" yes:auto "*":man
check "$DOVECOT_USECERTBOT" yes:usecertbot "*":xmail
check "$DOVECOT_UNPRIV" yes:unpriv
check "$DOVECOT_IMAP" yes:imap
check "$DOVECOT_USE_CONFIG_FROM_FLASH" yes:use_config_from_flash
check "$DOVECOT_COPY_CONFIG_TO_FLASH" yes:copy_config_to_flash

sec_begin '$(lang de:"Starttyp" en:"Start type")'
cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1"> $(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2"> $(lang de:"Manuell" en:"Manual")</label>
</p>
EOF
sec_end

sec_begin '$(lang de:"Zentrale Serverkonfiguration" en:"Core server configuration")'
cat << EOF
<p><input type="hidden" name="unpriv" value="no">
<input id="u1" type="checkbox" name="unpriv" value="yes"$unpriv_chk><label for="u1">
$(lang de:"Dovecot mit unpriviligierter Benutzer ID starten" en:"Start Dovecot with unprivileged user ID")</label>
</p>
<hr>
<p><input type="hidden" name="use_config_from_flash" value="no">
<input id="u2" type="checkbox" name="use_config_from_flash" value="yes"$use_config_from_flash_chk><label for="u2">
$(lang de:"Benutze Dovecot Konfiguration aus dem internen Speicher" en:"Use dovecot configuration from internal storage")</label>
</p>
<hr>
<p>
EOF
if [ "$CERTBOT_ENABLED" = 'yes' ]; then
cat << EOF
<input id="c1" type="radio"  name="usecertbot" value="yes"$usecertbot_chk><label for="c1"> $(lang de:"Benutze Certbots SSL Zertifikat" en:"Use Certbot SSL certificate")</label>
EOF
else
cat << EOF
<input id="c1" type="hidden" name="usecertbot" value="yes"$usecertbot_chk>
EOF
fi
cat << EOF
<br>
<input id="c2" type="radio"  name="usecertbot" value="no"$xmail_chk><label for="c2"> $(lang de:"Benutze XMails SSL Zertifikat" en:"Use XMail SSL certificate")</label>
</p>
EOF
if [ "$DOVECOT_USE_CONFIG_FROM_FLASH" != 'yes' ]; then
cat << EOF
<hr>
<p style="font-size:10px;">$(lang de:"Bitte gib hier den Speicherort f&uuml;r Dovecot Konfiguration an. Dieses Verzeichnis muss beschreibbar und bereits vorhanden sein. 
Falls das Verzeichnis leer ist, wird automatisch die richtige Dateistruktur erstellt. Dieses Verzeichnis wird alle Konfigurationsdateien von Dovecot enthalten, 
welche manuell bearbeitet werden m&uuml;ssen (nur die Hauptdatei kann hier bearbeitet werden)." 
en:"Please provide the storage location for Dovecot configuration. This directory must be writeable and exist. In case the directory is empty, 
the proper directory structure will be created. This directory will contain all configuration files for Dovecot which must be modified directly
(only the main config file can be accessed here).")</p>
<p> $(lang de:"Verzeichnis f&uuml;r Dovecot" en:"Directory for Dovecot"): <input type="text" name="configlocation" size="30" maxlength="255" value="$(html "$DOVECOT_CONFIGLOCATION")"></p>
<p><input type="hidden" name="copy_config_to_flash" value="no">
<input id="u3" type="checkbox" name="copy_config_to_flash" value="yes"$copy_config_to_flash_chk><label for="u3">
$(lang de:"Copy Konfiguration in den internen Speicher" en:"Copy Konfiguration to internal storage")</label>
</p>
EOF
fi
cat << EOF
<hr>
<p> $(lang de:"Startparameter" en:"Start parameters"): <input type="text" name="special" size="45" maxlength="255" value="$(html "$DOVECOT_SPECIAL")"></p>
EOF
sec_end

sec_begin '$(lang de:"Angebotene Dienste" en:"Offered services")'
cat << EOF
<p style="font-size:10px;">$(lang de:"Bitte beachte: Wenn Dovecot mit einer unpriviligierten Benutzer-ID gestartet wird, m&uuml;ssen alle hier angegebenen Ports gr&ouml;sser oder gleich 1024 sein, da ansonsten der Dienst nicht startet. Um Dienste aus dem Internet zug&auml;nglich zu machen, musst du eine Port-Weiterleitung mit der Fritz!Box Firewall einrichten (z.B. von Port 143 auf der Internet-Seite zum Port 10143 auf der lokalen Seite)." en:"Please note: If Dovecot is started with an unprivileged user ID, all ports must be above or equal to 1024 as otherwise the service will not be started. To make services available from the Internet, please use the port forwarding with the Fritz!Box firewall (e.g. from port 143 on the Internet side to port 10143 on the local side.")</p>
<hr>
<p><input type="hidden" name="imap" value="no">
<input id="a1" type="checkbox" name="imap" value="yes"$imap_chk><label for="a1"> $(lang de:"IMAP aktivieren" en:"Activate IMAP")</label></p>
<p> $(lang de:"IMAP Port" en:"IMAP port"): <input type="text" name="imapport" size="5" maxlength="5" value="$(html "$DOVECOT_IMAPPORT")"></p>
EOF
sec_end

sec_begin '$(lang de:"Update Passw&ouml;rter" en:"Update password")'
cat << EOF
<p style="font-size:10px;">$(lang de:"Bilde Dovecot Passw&ouml;rter aus XMail Passw&ouml;rtern" en:"Update Dovecot passwords from XMail passwords") <b><a style='font-size:14px;' target='_blank' href=/xmail_sync.php>$(lang de:"und f&uuml;hre das Script aus" en:"and run script")</a></b>$(lang de:"." en:".")<p>
EOF
sec_end

sec_begin '$(lang de:"Tipps zur Konfiguration" en:"Hints for configuration")'
cat << EOF
<p style="font-size:10px;">$(lang de:"Zur Aktivierung von SSL wird das SSL Zertifikat und der entsprechende private SSL Schl&uuml;ssel von XMail mitbenutzt: Das Zertifikat muss als Datei server.cert und der private Schl&uuml;sse als Datei server.key gespeichert werden. Beachte bitte, dass sowohl XMail als auch Dovecot das Recht haben muss, diese Dateien zu lesen." en:"To activate SSL you have to provide the SSL certificate and the corresponding private key which is reused from XMail directory. The certificate must be saved in the file server.cert and the key in the file server.key. Please ensure that XMail as well Dovecot has the permissions to read those files.")</p>
<hr>
EOF
sec_end
