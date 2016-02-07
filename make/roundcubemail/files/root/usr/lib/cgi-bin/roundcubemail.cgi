#!/bin/sh

. /usr/lib/libmodcgi.sh
. /mod/etc/conf/apache2.cfg

check "$ROUNDCUBEMAIL_DOWNLOADER" yes:downloader
check "$ROUNDCUBEMAIL_INSTALLER_ENABLED" yes:installer_enabled
check "$ROUNDCUBEMAIL_DISABLE_INSTALLER" yes:disable_installer

sec_begin '$(lang de:"Zentrale Konfiguration" en:"Core configuration")'
cat << EOF
<p><input type="hidden" name="downloader" value="no">
<input id="d1" type="checkbox" name="downloader" value="yes"$downloader_chk><label for="d1">
$(lang de:"Download roundcubemail und installiere es zu folgendem Verzeichnis" en:"Download roundcubemail and install it to below directory")</label></p>
<hr>
<p style="font-size:10px;">$(lang de:"Bitte gib hier den Speicherort f&uuml;r roundcubemail Dateien an. Falls das Verzeichnis leer ist oder nicht vorhanden, wird automatisch die richtige Dateistruktur erstellt. Dieses Verzeichnis wird alle Dateien von roundcubemail enthalten, welche via einem Webfrontend bearbeitet werden muss." en:"Please provide the storage location for roundcubemail files. In case the directory is empty or not present, the proper directory structure will be created. This directory will contain all files for roundcubemail which must be modified via a web frontend.")</p>
<p> $(lang de:"Verzeichnis f&uuml;r roundcubemail" en:"Directory for roundcubemail"): <input type="text" name="location" size="45" maxlength="255" value="$(html "$ROUNDCUBEMAIL_LOCATION")"></p>
<hr>
<p style="font-size:10px;">$(lang de:"Benutze roundcube Version." en:"Use roundcube version.")</p>
<p> $(lang de:"Version roundcubemail" en:"Version roundcubemail"): <input type="text" name="version" size="8" maxlength="10" value="$(html "$ROUNDCUBEMAIL_VERSION")"></p>
EOF
if [ "$ROUNDCUBEMAIL_INSTALLER_ENABLED" = "no" ]; then
cat << EOF
<hr>
<p><input type="hidden" name="installer_enabled" value="no">
<input id="i1" type="checkbox" name="installer_enabled" value="yes"$installer_enabled_chk><label for="i1">
$(lang de:"roundcube Konfigurator/Installer Modus setzen" en:"set roundcube configurator/installer mode")</label></p>
EOF
fi
sec_end

if [ "$ROUNDCUBEMAIL_INSTALLER_ENABLED" = "yes" ]; then
sec_begin '$(lang de:"roundcubemail (Webmail Konfiguration/Installer)" en:"roundcubemail (webmail configuration/installer)")'
cat << EOF
<p>$(lang de:"Die Konfigurationsoberfl&auml;che kann" en:"You and open the configuration site") <b><a style='font-size:14px;' target='_blank' href=http://`ifconfig lan | grep "inet addr" | cut -d: -f2 | cut -d' ' -f1`:$APACHE2_PORT/webmail/installer>$(lang de:"hier" en:"here")</a></b>$(lang de:" ge&ouml;ffnet werden bzw." en:" or")
<b><a style='font-size:14px;' target='_blank' href=/cgi-bin/file/roundcubemail/config>$(lang de:"direkt" en:"directly")</a></b>$(lang de:" editiert werden." en:" edited.")</p>
EOF
if [ "$ROUNDCUBEMAIL_INSTALLER_STATE" = "started" ]; then
cat << EOF
<hr>
<p><input type="hidden" name="disable_installer" value="no">
<input id="d2" type="checkbox" name="disable_installer" value="yes"$disable_installer_chk><label for="d2">
$(lang de:"Setze Konfiguration/Installer Modus zur&uuml;ck" en:"Reset configuration/installer mode")</label></p>
EOF
fi
sec_end
elif [ "$ROUNDCUBEMAIL_INSTALLED" = "yes" ]; then
sec_begin '$(lang de:"roundcubemail (Webmail)" en:"roundcubemail (webmail)")'
cat << EOF
<p>$(lang de:"Die Webmail Seite kann" en:"You can open the webmail site") <b><a style='font-size:14px;' target='_blank' href=http://`ifconfig lan | grep "inet addr" | cut -d: -f2 | cut -d' ' -f1`:$APACHE2_PORT/webmail>$(lang de:"hier" en:"here")</a></b>$(lang de:" ge&ouml;ffnet werden." en:".")<p>
EOF
sec_end
fi

