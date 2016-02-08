#!/bin/sh


. /usr/lib/libmodcgi.sh
[ -e /mod/etc/conf/xmail.cfg ] && . /mod/etc/conf/xmail.cfg

check "$TAR_ENABLED" yes:auto "*":man
check "$TAR_PREPEND_REMOTE_FILENAME" yes:prepend_remote_filename

sec_begin '$(lang de:"Aktiviert" en:"Enabled")'

cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1"> $(lang de:"Aktitviert" en:"Enabled")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2">   $(lang de:"Deaktiviert" en:"Disabled")</label>
<p>
$(lang de:"Mittels eines cron Auftrages wird ein inkrementelles Backup t&auml;glich ausgef&uuml;hrt und ein volles am ersten des Monates.  
Das Archive wird bei entsprechender Parametrisierung auf einen anderen Computer &uuml;bertragen und bei Erfolg gel&ouml;scht. 
Der Computer wird auch vorher aufgeweckt, wenn parametrisiert."
en:"Using a cron job a incrementel backup is executed on daily basis, whereas a full backup is done on the first of the month.
The archive can be copied be copied to remote computer, if according paramters are given and will be deleted if successfully transferred. 
Similarly the remote computer will be waked-up beore transfer.")</p>
EOF


sec_end

sec_begin '$(lang de:"Allgemeine Backup Einstellung" en:"General backup options")'

cat << EOF
<p>$(lang de:"Dienste die vor dem Backup gestoppt und anschlie&szlig;end wieder gestartet werden, um Ver&auml;nderungen w&auml;hrend des Backups zu verhindern, z.B. <small>rc.xmail rc.syslogd</small>" 
en:"Services to be stopped before backup and started again after backup in order to prevent write access to the directory, e.g. <small>rc.xmail rc.syslogd</small>") :<br> 
<input type="text" name="servicesstart_stop" size="40" maxlength="255" value="$(html "$TAR_SERVICESSTART_STOP")"></p>
<p>$(lang de:"Pfad des zu sichernden Verzeichnisses" en:"Directory name for backup"):<br> <input type="text" name="to_be_backuped_directory" size="40" maxlength="255" value="$(html "$TAR_TO_BE_BACKUPED_DIRECTORY")"></p>
<p>$(lang de:"Verzeichnispfad zur Sicherungsdatei" en:"Directory path to the backup-file") (default: <small>$TAR_TO_BE_BACKUPED_DIRECTORY/backups</small>):<br> 
<input type="text" name="archive_storage_location" size="50" maxlength="255" value="$(html "$TAR_ARCHIVE_STORAGE_LOCATION")"></p>
EOF
if [ -n "$XMAIL_MAILLOCATION" ]; then
cat << EOF
<p>$(lang de:"Mail Adresse f&uuml;r das Fehler-Log des crond jobs" en:"Mail address for failure log of the cron jobs"):<br> <input type="text" name="mail_to" size="25" maxlength="255" value="$(html "$TAR_MAIL_TO")"></p>
EOF
fi

cat << EOF
<p>$(lang de:"Mehrere Angaben voll- und teilspezifiziert durch Leerzeichen getrennt sind m&ouml;glich:" 
          en:"You may enter half- or full-specified paths sperarated by blanks:")</p>
<p>$(lang de:"Dateien/Verzeichnisse, ausgeschlossen vom Backup" en:"Files/directories excluded from backup"):<br> <input type="text" name="excludes" size="50" maxlength="255" value="$(html "$TAR_EXCLUDES")"></p>
<p>$(lang de:"Zus&auml;tzliche Dateien/Verzeichnisse f&uuml;r das Backup" en:"Files/directories included for backup"):<br> <input type="text" name="includes" size="50" maxlength="255" value="$(html "$TAR_INCLUDES")"></p>
EOF

sec_end

sec_begin '$(lang de:"Parameter f&uuml;r den Transfer des Archives" en:"Parameters to transfer archive")'

cat << EOF
<p>$(lang de:"MAC Adresse des aufzuweckenden Computers (f&uuml;r das entfernte Verzeichnis), z.B. <small>12-34-56-78-90-12</small>" en:"MAC address of the to be wakeuped computer (for the remote directory), e.g. <small>12-34-56-78-90-12</small>") :<br> 
<input type="text" name="wol_transfer_station_mac" size="25" maxlength="255" value="$(html "$TAR_WOL_TRANSFER_STATION_MAC")"></p>
<p>$(lang de:"Die Backupdatei kann mit folgenden Angaben mittels eines Kommandos wie scp, cp oder ftpput kopiert werden:" 
       en:"The archive can be copied with scp or ftpput using following settings:")</p>
<p>$(lang de:"Transfer Kommando, um das Archive zu transferieren" en:"Command to transfer the archive"):<br> <input type="text" name="transfer_cmd" size="50" maxlength="255" value="$(html "$TAR_TRANSFER_CMD")"></p>
<p>$(lang de:"Entfernter Verzeichnisname f&uuml;r den Transfer" en:"Remote directory name"):<br> <input type="text" name="remote_dirname" size="50" maxlength="255" value="$(html "$TAR_REMOTE_DIRNAME")"></p>
<p><input type="hidden" name="prepend_remote_filename" value="no">
<input id="e3" type="checkbox" name="prepend_remote_filename" value="yes"$prepend_remote_filename_chk><label for="e3">
$(lang de:"Stelle den entfernten Datei Namen dem lokalen Pfad im Transfer-Kommando voran" en:"pre-pend the remote file name to the local filename used for the transfer command")</label></p>
<p>$(lang de:"Der Befehl sieht wie folgt aus" en:"Command will look like"):<br>
EOF
if [ ${TAR_PREPEND_REMOTE_FILENAME} = 'no' ]; then
cat << EOF
<small>
${TAR_TRANSFER_CMD} ${TAR_TO_BE_BACKUPED_DIRECTORY}/$(uname -n)_backup_$(date +%Y-%m-%d).tar.gz ${TAR_REMOTE_DIRNAME}/$(uname -n)_backup_$(date +%Y-%m-%d).tar.gz
</small></p>
EOF
else
cat << EOF
<small>
${TAR_TRANSFER_CMD} ${TAR_REMOTE_DIRNAME}/$(uname -n)_backup_incr_$(date +%Y-%m-%d).tar.gz ${TAR_TO_BE_BACKUPED_DIRECTORY}/backups/$(uname -n)_backup_incr_$(date +%Y-%m-%d).tar.gz
</small></p>
EOF
fi

sec_end

